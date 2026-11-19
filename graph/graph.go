package graph

import (
	"github.com/graphql-go/graphql"
)

// Schema attempts to parse the schema for all the models or panics if there is a parsing
// error for fetching the data attributes, resolvers, etc.
func Schema() *graphql.Schema {
	config := graphql.SchemaConfig{
		Query: graphql.NewObject(graphql.ObjectConfig{
			Name: "waypoint",
			Fields: graphql.Fields{
				"hello": &graphql.Field{
					Type: graphql.String,
					Resolve: func(p graphql.ResolveParams) (any, error) {
						return "world", nil
					},
				},
			},
		}),
	}
	schema, err := graphql.NewSchema(config)
	if err != nil {
		panic(err)
	}
	return &schema
}
