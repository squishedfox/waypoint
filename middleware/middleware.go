package middleware

import "net/http"

// Middleware is a function that wraps an http.Handler and returns a new one.
type Middleware func(http.Handler) http.Handler

// Chain composes multiple middlewares into a single Middleware.
//
// Middlewares run in the order they are provided, so Chain(a, b, c) executes
// a, then b, then c, before finally invoking the handler.
//
// Example:
//
//	http.Handle("/graphql", Chain(RequestID, Logging, DbConn(pool))(h))
func Chain(mws ...Middleware) Middleware {
	return func(final http.Handler) http.Handler {
		for i := len(mws) - 1; i >= 0; i-- {
			final = mws[i](final)
		}
		return final
	}
}
