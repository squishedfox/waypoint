package database

import (
	"context"
	"fmt"
	"reflect"

	"github.com/jackc/pgx/v5/pgxpool"
)

type dbContextKey string

const dbContextKeyValue dbContextKey = "postgresConnection"

var connType = reflect.TypeOf((*pgxpool.Conn)(nil))

func WithConnection(ctx context.Context, conn *pgxpool.Conn) context.Context {
	return context.WithValue(ctx, dbContextKeyValue, conn)
}

func GetConnection(ctx context.Context) (*pgxpool.Conn, error) {
	value := ctx.Value(dbContextKeyValue)
	if value == nil {
		return nil, fmt.Errorf("could not fetch value with key '%s' from context", dbContextKeyValue)
	}
	conn, ok := value.(*pgxpool.Conn)
	if !ok {
		return nil, fmt.Errorf("context value with key '%s' is not expected %v", dbContextKeyValue, connType)
	}
	return conn, nil
}
