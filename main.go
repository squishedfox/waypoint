package main

import (
	"net/http"

	"github.com/graphql-go/handler"
	"github.com/squishedfox/waypoint/graph"
)

func main() {
	schema := graph.Schema()
	config := &handler.Config{
		Schema:     schema,
		Playground: true,
	}
	h := handler.New(config)
	http.Handle("/graphql", h)
	http.ListenAndServe(":8000", h)
}
