module github.com/squishedfox/waypoint

go 1.27.1

replace github.com/squishedfox/waypoint/graph => ./graph

require (
	github.com/graphql-go/handler v0.2.4
	github.com/squishedfox/waypoint/graph v0.0.0-00010101000000-000000000000
)

require (
	github.com/graphql-go/graphql v0.8.1 // indirect
	github.com/jackc/pgpassfile v1.0.0 // indirect
	github.com/jackc/pgservicefile v0.0.0-20240606120523-5a60cdf6a761 // indirect
	github.com/jackc/pgx/v5 v5.13.0 // indirect
	github.com/jackc/puddle/v2 v2.2.3 // indirect
	golang.org/x/sync v0.22.0 // indirect
	golang.org/x/text v0.41.0 // indirect
)
