CREATE TABLE IF NOT EXISTS mdm.carrier_detail (
  party_id UUID PRIMARY KEY REFERENCES mdm.party(id) ON DELETE CASCADE, -- the carrier party this detail belongs to
  mc_number TEXT UNIQUE, -- FMCSA Motor Carrier number
  dot_number TEXT UNIQUE, -- FMCSA DOT number
  scac TEXT UNIQUE, -- Standard Carrier Alpha Code (4-letter, used in EDI)
  operating_status TEXT, -- authorized, out of service, etc.
  authority_type TEXT, -- common, contract, etc.
  safety_rating TEXT, -- satisfactory, conditional, unsatisfactory
  hazmat BOOLEAN NOT NULL DEFAULT false, -- whether carrier is hazmat-certified
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS mdm.equipment_type (
  code TEXT PRIMARY KEY, -- stable identifier, e.g. 'dry_van', 'reefer', 'flatbed'
  name TEXT NOT NULL, -- human-readable label, e.g. 'Dry Van', 'Reefer', 'Flatbed'
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS mdm.carrier_equipment (
  carrier_party_id UUID NOT NULL REFERENCES mdm.carrier_detail(party_id) ON DELETE CASCADE,
  equipment_type_code TEXT NOT NULL REFERENCES mdm.equipment_type(code) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (carrier_party_id, equipment_type_code)
);

CREATE INDEX IF NOT EXISTS idx_carrier_equipment_type
  ON mdm.carrier_equipment (equipment_type_code);

INSERT INTO mdm.equipment_type (code, name) VALUES
  ('dry_van', 'Dry Van'),
  ('reefer', 'Reefer'),
  ('flatbed', 'Flatbed'),
  ('step_deck', 'Step Deck'),
  ('lowboy', 'Lowboy'),
  ('intermodal', 'Intermodal'),
  ('tanker', 'Tanker'),
  ('box_truck', 'Box Truck'),
  ('sprinter_van', 'Sprinter Van'),
  ('power_only', 'Power Only')
ON CONFLICT (code) DO NOTHING;

CREATE TABLE IF NOT EXISTS mdm.region (
  code TEXT PRIMARY KEY, -- stable identifier, e.g. 'us_midwest', 'ca_on'
  name TEXT NOT NULL, -- human-readable label, e.g. 'US Midwest', 'Ontario'
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- Lanes are modeled at the region level (e.g. 'US Midwest -> US Southeast'),
-- not city or zip. Region granularity is enough to answer "can this carrier
-- serve this corridor?" without needing point-to-point precision. If precise
-- matching is ever needed (rate quoting, exact origin/destination pairs),
-- revisit and move to zip/geo-level lanes.
CREATE TABLE IF NOT EXISTS mdm.lane (
  id UUID PRIMARY KEY, -- generated in Go
  origin_region_code TEXT NOT NULL REFERENCES mdm.region(code),
  destination_region_code TEXT NOT NULL REFERENCES mdm.region(code),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (origin_region_code, destination_region_code)
);
-- Lanes are directed: 'Midwest -> Southeast' is a different lane than
-- 'Southeast -> Midwest'. This matters because a carrier may have headhaul
-- capacity one way and no backhaul the other. If you only ever care about
-- "serves this corridor in either direction," collapse to an unordered pair.
CREATE TABLE IF NOT EXISTS mdm.carrier_lane (
  carrier_party_id UUID NOT NULL REFERENCES mdm.carrier_detail(party_id) ON DELETE CASCADE,
  lane_id UUID NOT NULL REFERENCES mdm.lane(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (carrier_party_id, lane_id)
);

CREATE INDEX IF NOT EXISTS idx_carrier_lane_lane
ON mdm.carrier_lane (lane_id);
