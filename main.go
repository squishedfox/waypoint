package main

import (
	"context"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"time"

	"github.com/graphql-go/handler"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/squishedfox/waypoint/database"
	"github.com/squishedfox/waypoint/graph"
	"github.com/squishedfox/waypoint/middleware"
)

// DbConn injects a `*pgxpool.Conn` into the request context and releases it
// when the request completes.
func ConnectionMiddleware(pool *pgxpool.Pool) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			conn, err := pool.Acquire(r.Context())
			if err != nil {
				http.Error(w, "failed to acquire database connection", http.StatusServiceUnavailable)
				return
			}
			defer conn.Release()

			ctx := database.WithConnection(r.Context(), conn)
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

func connectDB() (*pgxpool.Pool, error) {
	host := os.Getenv("DB_HOST")
	port := os.Getenv("DB_PORT")
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	name := os.Getenv("DB_NAME")

	dsn := fmt.Sprintf(
		"postgres://%s:%s@%s:%s/%s",
		user, password, host, port, name,
	)

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	db, err := pgxpool.New(ctx, dsn)
	if err != nil {
		return nil, err
	}

	if err := db.Ping(ctx); err != nil {
		db.Close()
		return nil, err
	}

	return db, nil
}

func GetAddr() string {
	host := os.Getenv("HOST")
	if host == "" {
		host = "0.0.0.0"
	}
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	addr := net.JoinHostPort(host, port)
	return addr
}

func main() {
	db, err := connectDB()
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	schema := graph.Schema()
	config := &handler.Config{
		Schema:     schema,
		Playground: true,
	}

	h := handler.New(config)

	wrappedHandler := middleware.Chain(ConnectionMiddleware(db))(h)
	http.Handle("/graphql", wrappedHandler)

	addr := GetAddr()

	log.Printf("Listening on %s", addr)

	http.ListenAndServe(addr, wrappedHandler)
}
