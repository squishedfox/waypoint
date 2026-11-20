# Waypoint

## Graph

### Summary

GraphQL implementation for interacting with external services

### Getting Started

- Make sure to have [Docker](https://www.docker.com/products/docker-desktop/) for sandboxing services locally
- [Go 1.17+](https://go.dev/)
- An IDE e.g. [NeoVim](https://neovim.io/), [Zed](https://zed.dev/), or [Visual Studio Code](https://code.visualstudio.com/download) for writing code
- A database explorer e.g. [DBeaver](https://dbeaver.io/), [BeeKeeper Studio](https://www.beekeeperstudio.io/), [pgAdmin](https://www.postgresql.org/)

### Running project

- Run the app with `docker compose up --build`
- Force refresh postgres seed/migrations `docker compose down -v && docker compose up -d`

### Tech Stack

- postgres
- Go

### Thank You

- [graphql-go/graphql](https://github.com/graphql-go/graphql)
- [graphql-go/handler](https://github.com/graphql-go/handler)
