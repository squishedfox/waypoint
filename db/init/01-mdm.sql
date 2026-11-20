-- 01-mdm.sql
-- Seeds the MDM schema and core "party" table.
-- Runs once on first database initialization.

CREATE SCHEMA IF NOT EXISTS mdm;

-- "party" is the master entity in MDM: customers, carriers,
-- suppliers, facilities, etc. all derive from a party.
--
-- id: plain UUID (RFC 4122), generated in Go with google/uuid.
CREATE TABLE IF NOT EXISTS mdm.party (
    id          uuid PRIMARY KEY,
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now()
);
