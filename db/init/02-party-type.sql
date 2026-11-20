-- 02-party-type.sql
-- Party type vocabulary and many-to-many party<->type mapping.
-- A party may fill multiple personas (e.g. both customer and supplier).
-- Types represent INTRINSIC entity kinds only — per-shipment roles
-- (shipper, consignee, notify-party) are modeled separately.

CREATE TABLE IF NOT EXISTS mdm.party_type (
    code        text PRIMARY KEY,
    name        text NOT NULL,
    created_at  timestamptz NOT NULL DEFAULT now()
);

-- Junction table: many parties <-> many types
CREATE TABLE IF NOT EXISTS mdm.party_party_type (
    party_id         uuid NOT NULL REFERENCES mdm.party(id) ON DELETE CASCADE,
    party_type_code  text NOT NULL REFERENCES mdm.party_type(code) ON DELETE CASCADE,
    created_at       timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (party_id, party_type_code)
);

-- Supports "find all parties of a given type" (e.g. all carriers)
CREATE INDEX IF NOT EXISTS idx_party_party_type_code
    ON mdm.party_party_type (party_type_code);

-- Seed the controlled vocabulary
INSERT INTO mdm.party_type (code, name) VALUES
    ('customer',       'Customer'),          -- the shipper/buyer of freight services
    ('carrier',        'Carrier'),           -- domestic motor carrier (trucking)
    ('supplier',       'Supplier'),          -- vendor/producer providing the goods
    ('facility',       'Facility'),          -- warehouse, DC, cross-dock, yard, CFS
    ('broker',         'Broker'),            -- freight broker arranging capacity
    ('3pl',            '3PL'),               -- third-party logistics provider (warehousing + transport)
    ('driver',         'Driver'),            -- individual operator / owner-operator
    ('forwarder',      'Freight Forwarder'), -- arranges international movement (NVOCC, etc.)
    ('customs_broker', 'Customs Broker'),    -- handles customs clearance and filing
    ('ocean_carrier',  'Ocean Carrier'),     -- steamship line / ocean transport
    ('air_carrier',    'Air Carrier')        -- airline / air freight carrier
ON CONFLICT (code) DO NOTHING;
