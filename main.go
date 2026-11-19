package main

import (
	"log"
	"net"
	"net/http"
	"os"

	"github.com/graphql-go/handler"
	"github.com/squishedfox/waypoint/graph"
)

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
	schema := graph.Schema()
	config := &handler.Config{
		Schema:     schema,
		Playground: true,
	}
	h := handler.New(config)
	http.Handle("/graphql", h)

	addr := GetAddr()

	log.Printf("Listening on %s", addr)

	http.ListenAndServe(addr, h)
}
