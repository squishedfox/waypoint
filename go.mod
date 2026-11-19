module github.com/squishedfox/waypoint

go 1.27.1

replace github.com/squishedfox/waypoint/graph => ./graph

require github.com/graphql-go/handler v0.2.4

require (
	github.com/graphql-go/graphql v0.8.1 // indirect
	github.com/squishedfox/waypoint/graph v0.0.0-00010101000000-000000000000
)
