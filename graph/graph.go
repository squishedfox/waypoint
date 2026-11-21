package graph

import (
	"github.com/graphql-go/graphql"
	"github.com/squishedfox/waypoint/database"
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
				"status": &graphql.Field{
					Type: graphql.String,
					Resolve: func(p graphql.ResolveParams) (any, error) {
						conn, err := database.GetConnection(p.Context)
						if err != nil {
							return nil, err
						}
						err = conn.Ping(p.Context)
						if err != nil {
							return nil, err
						}
						return "OK", nil
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
