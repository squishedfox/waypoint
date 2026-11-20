# Waypoint

Personal project for building a freight logistics platform because I like the logistics of figuring out logistics.

## Thank You

- [graphql-go/graphql](https://github.com/graphql-go/graphql)
- [graphql-go/handler](https://github.com/graphql-go/handler)

## Develop

## Tools

- An IDE e.g. NeoVim, Zed, or Visual Studio Code for writing Code
- A database explorer e.g. DBeaver, BeeKeeper, pgAdmin

### Getting Started

- Run the app with `docker compose up --build`
- Force refresh postgres seed/migrations `docker compose down -v && docker compose up -d`

## Domains

- [ ] Master Data Management
  - [ ] Locations
    - [ ] Warehouse
    - [ ] Residential
    - [ ] Business
    - [ ] Bin
    - [ ] Dock
    - [ ] Roll up
  - [ ] Organizations/Tenants
  - [ ] Relationships
    - [ ] Ship To
    - [ ] Ship From
- [ ] Dock Scheduling
- [ ] Tendering
- [ ] Load Board
- [ ] Carriers
  - [ ] Organizations/Tenants
  - [ ] Lanes
  - [ ] Equipment
- [ ] Documents
  - [ ] Bill of Lading
  - [ ] Master Bill of Lading
  - [ ] Packing Slips
- [ ] Compliance
  - [ ] Safety Ratings
  - [ ] Insurances
- [ ] Financials
  - [ ] Invoices
  - [ ] Vouchers
- [ ] EDI
  - [ ] Mapping
- [ ] Rating
  - [ ] Rates
  - [ ] Spot Negotiations
- [ ] Tracking/Visibility
- [ ] Analytics
  - [ ] Carrier Score Cards
  - [ ] Data Warehousing
- [ ] Loads
  - [ ] FTL
  - [ ] LTL
  - [ ] Rail
  - [ ] Ocean
  - [ ] Dock
  - [ ] Drayage
  - [ ] Last Mile
  - [ ] Parcel
  - [ ] Air

## Technology Stack

- Postgres
- GraphQL
- Go
- Typescript/Javascript
- Neovim/Zed Editor
