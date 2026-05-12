-- ============================================================
-- SAMJOO SM & DORIKO · Normalized DB Schema v2
-- SQLite 3
--
-- Goal:
--   1) Keep DDL in one place.
--   2) Use stable IDs instead of Korean name strings as foreign keys.
--   3) Separate operational vessel records from raw imported particulars.
--   4) Preserve API-friendly views while the backend is migrated.
-- ============================================================

PRAGMA foreign_keys = ON;

-- Drop views first.
DROP VIEW IF EXISTS v_duty_assignments_api;
DROP VIEW IF EXISTS v_safety_eligible_vessels;
DROP VIEW IF EXISTS v_vessel_supervisor;
DROP VIEW IF EXISTS v_company_fleet_stats;
DROP VIEW IF EXISTS v_company_team_count;
DROP VIEW IF EXISTS v_company_staff_count;
DROP VIEW IF EXISTS v_current_staff;

-- Drop child tables before parent tables.
DROP TABLE IF EXISTS vessel_rightship_profiles;
DROP TABLE IF EXISTS vessel_safety_assignments;
DROP TABLE IF EXISTS vessel_safety_roles;
DROP TABLE IF EXISTS vessel_supervisor_assignments;
DROP TABLE IF EXISTS duty_backup_people;
DROP TABLE IF EXISTS duty_assignments;
DROP TABLE IF EXISTS vessel_particulars_raw;
DROP TABLE IF EXISTS vessel_particulars;
DROP TABLE IF EXISTS vessels;
DROP TABLE IF EXISTS staff_assignments;
DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS data_sources;

-- ============================================================
-- Source tracking
-- ============================================================

CREATE TABLE data_sources (
  source_id       INTEGER PRIMARY KEY AUTOINCREMENT,
  source_key      TEXT NOT NULL UNIQUE,
  source_type     TEXT NOT NULL CHECK (source_type IN (
                    'schema', 'seed', 'excel', 'pdf', 'rightship', 'manual', 'gapfill'
                  )),
  title           TEXT NOT NULL,
  path            TEXT,
  effective_date  TEXT,
  imported_at     TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  notes           TEXT
);

-- ============================================================
-- Organization master data
-- ============================================================

CREATE TABLE companies (
  company_code    TEXT PRIMARY KEY,
  name_ko         TEXT NOT NULL,
  name_en         TEXT NOT NULL,
  company_type    TEXT NOT NULL DEFAULT 'other' CHECK (company_type IN (
                    'rollup', 'ship_manager', 'ism_manager', 'owner', 'other'
                  )),
  role_ko         TEXT,
  role_en         TEXT,
  color_primary   TEXT,
  color_accent    TEXT,
  is_rollup       INTEGER NOT NULL DEFAULT 0 CHECK (is_rollup IN (0, 1)),
  sort_order      INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE departments (
  department_code TEXT PRIMARY KEY,
  name_ko         TEXT NOT NULL,
  name_en         TEXT NOT NULL,
  sort_order      INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE teams (
  team_code       TEXT PRIMARY KEY,
  department_code TEXT NOT NULL REFERENCES departments(department_code),
  name_ko         TEXT NOT NULL,
  name_en         TEXT NOT NULL,
  color_token     TEXT,
  sort_order      INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX idx_teams_department ON teams(department_code);

-- One real person. Organization memberships live in staff_assignments.
CREATE TABLE people (
  person_id       INTEGER PRIMARY KEY AUTOINCREMENT,
  person_key      TEXT NOT NULL UNIQUE, -- stable migration key, e.g. won_hun_hui
  name_ko         TEXT NOT NULL,
  name_ko_key     TEXT NOT NULL,        -- normalized display name, e.g. 원훈희
  name_en         TEXT,
  email           TEXT,
  phone           TEXT,
  is_active       INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
  notes           TEXT
);
CREATE INDEX idx_people_name_ko_key ON people(name_ko_key);

-- A person's role in a company/org chart at a point in time.
CREATE TABLE staff_assignments (
  assignment_id   INTEGER PRIMARY KEY AUTOINCREMENT,
  person_id       INTEGER NOT NULL REFERENCES people(person_id) ON DELETE RESTRICT,
  company_code    TEXT NOT NULL REFERENCES companies(company_code) ON DELETE RESTRICT,
  department_code TEXT REFERENCES departments(department_code) ON DELETE RESTRICT,
  team_code       TEXT REFERENCES teams(team_code) ON DELETE RESTRICT,
  org_level       INTEGER NOT NULL CHECK (org_level IN (1, 2, 3)),
  role_ko         TEXT NOT NULL,
  role_en         TEXT NOT NULL,
  is_leader       INTEGER NOT NULL DEFAULT 0 CHECK (is_leader IN (0, 1)),
  sort_order      INTEGER NOT NULL DEFAULT 0,
  valid_from      TEXT,
  valid_to        TEXT,
  source_id       INTEGER REFERENCES data_sources(source_id),
  CHECK (
    (org_level = 1 AND department_code IS NULL AND team_code IS NULL)
    OR (org_level = 2 AND department_code IS NOT NULL AND team_code IS NULL)
    OR (org_level = 3 AND department_code IS NOT NULL AND team_code IS NOT NULL)
  ),
  CHECK (valid_to IS NULL OR valid_from IS NULL OR valid_to >= valid_from)
);
CREATE INDEX idx_staff_assignments_person ON staff_assignments(person_id);
CREATE INDEX idx_staff_assignments_company ON staff_assignments(company_code);
CREATE INDEX idx_staff_assignments_team ON staff_assignments(team_code);
CREATE UNIQUE INDEX uq_staff_current_assignment
  ON staff_assignments(company_code, person_id, org_level, COALESCE(team_code, ''))
  WHERE valid_to IS NULL;

-- ============================================================
-- Fleet master data
-- ============================================================

CREATE TABLE vessels (
  imo                  TEXT PRIMARY KEY,
  vessel_no            INTEGER,
  name                 TEXT NOT NULL,
  vessel_type          TEXT NOT NULL CHECK (vessel_type IN ('VC', 'BC')),
  built_year           INTEGER CHECK (built_year IS NULL OR built_year BETWEEN 1900 AND 2100),
  flag_code            TEXT,
  flag_category        TEXT CHECK (flag_category IS NULL OR flag_category IN ('KOR', 'BBCHP', 'PAN', 'OTHER')),
  gt                   INTEGER CHECK (gt IS NULL OR gt >= 0),
  dwt                  INTEGER CHECK (dwt IS NULL OR dwt >= 0),
  class_society        TEXT,
  ism_manager_code     TEXT NOT NULL REFERENCES companies(company_code),
  safety_org_required  INTEGER NOT NULL DEFAULT 0 CHECK (safety_org_required IN (0, 1)),
  is_active            INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
  source_id            INTEGER REFERENCES data_sources(source_id)
);
CREATE INDEX idx_vessels_ism_manager ON vessels(ism_manager_code);
CREATE INDEX idx_vessels_type ON vessels(vessel_type);
CREATE INDEX idx_vessels_flag_category ON vessels(flag_category);

-- Canonical, typed particulars for queries and display.
CREATE TABLE vessel_particulars (
  imo                  TEXT PRIMARY KEY REFERENCES vessels(imo) ON DELETE CASCADE,
  port_of_registry     TEXT,
  call_sign            TEXT,
  official_no          TEXT,
  mmsi                 TEXT,
  registered_owner     TEXT,
  beneficial_owner     TEXT,
  manager_name         TEXT,
  operator_name        TEXT,
  p_and_i              TEXT,
  builder              TEXT,
  built_date           TEXT,
  keel_laid_date       TEXT,
  vessel_type_detail   TEXT,
  nt                   INTEGER CHECK (nt IS NULL OR nt >= 0),
  loa_m                REAL CHECK (loa_m IS NULL OR loa_m > 0),
  lbp_m                REAL CHECK (lbp_m IS NULL OR lbp_m > 0),
  breadth_m            REAL CHECK (breadth_m IS NULL OR breadth_m > 0),
  depth_m              REAL CHECK (depth_m IS NULL OR depth_m > 0),
  draft_summer_m       REAL CHECK (draft_summer_m IS NULL OR draft_summer_m > 0),
  draft_tropical_m     REAL CHECK (draft_tropical_m IS NULL OR draft_tropical_m > 0),
  draft_winter_m       REAL CHECK (draft_winter_m IS NULL OR draft_winter_m > 0),
  main_engine          TEXT,
  service_speed_kn     REAL CHECK (service_speed_kn IS NULL OR service_speed_kn > 0),
  mcr_kw               REAL CHECK (mcr_kw IS NULL OR mcr_kw > 0),
  mcr_rpm              REAL CHECK (mcr_rpm IS NULL OR mcr_rpm > 0),
  fuel_oil_m3          REAL CHECK (fuel_oil_m3 IS NULL OR fuel_oil_m3 >= 0),
  diesel_oil_m3        REAL CHECK (diesel_oil_m3 IS NULL OR diesel_oil_m3 >= 0),
  lub_oil_m3           REAL CHECK (lub_oil_m3 IS NULL OR lub_oil_m3 >= 0),
  bow_thruster         TEXT,
  hull_machinery       TEXT,
  equipment_no         TEXT,
  lightship_mt         REAL CHECK (lightship_mt IS NULL OR lightship_mt > 0),
  source_id            INTEGER REFERENCES data_sources(source_id),
  updated_at           TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Raw import payloads stay here so source text is not forced into typed columns.
CREATE TABLE vessel_particulars_raw (
  raw_id        INTEGER PRIMARY KEY AUTOINCREMENT,
  imo           TEXT NOT NULL REFERENCES vessels(imo) ON DELETE CASCADE,
  source_id     INTEGER REFERENCES data_sources(source_id),
  raw_payload   TEXT NOT NULL,
  imported_at   TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  notes         TEXT
);
CREATE INDEX idx_vessel_particulars_raw_imo ON vessel_particulars_raw(imo);

-- ============================================================
-- Team duties
-- ============================================================

CREATE TABLE duty_assignments (
  duty_id             INTEGER PRIMARY KEY AUTOINCREMENT,
  team_code           TEXT NOT NULL REFERENCES teams(team_code),
  assignee_person_id  INTEGER NOT NULL REFERENCES people(person_id),
  role_snapshot_ko    TEXT,
  duty_area           TEXT NOT NULL,
  duty_content        TEXT,
  is_essential        INTEGER NOT NULL DEFAULT 0 CHECK (is_essential IN (0, 1)),
  sort_order          INTEGER NOT NULL DEFAULT 0,
  valid_from          TEXT,
  valid_to            TEXT,
  source_id           INTEGER REFERENCES data_sources(source_id),
  remarks             TEXT,
  CHECK (valid_to IS NULL OR valid_from IS NULL OR valid_to >= valid_from)
);
CREATE INDEX idx_duty_team ON duty_assignments(team_code);
CREATE INDEX idx_duty_assignee ON duty_assignments(assignee_person_id);

CREATE TABLE duty_backup_people (
  duty_id           INTEGER NOT NULL REFERENCES duty_assignments(duty_id) ON DELETE CASCADE,
  backup_person_id  INTEGER NOT NULL REFERENCES people(person_id) ON DELETE RESTRICT,
  sort_order        INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (duty_id, backup_person_id)
);
CREATE INDEX idx_duty_backup_person ON duty_backup_people(backup_person_id);

-- ============================================================
-- Vessel supervisors
-- ============================================================

CREATE TABLE vessel_supervisor_assignments (
  supervisor_assignment_id INTEGER PRIMARY KEY AUTOINCREMENT,
  imo                      TEXT NOT NULL REFERENCES vessels(imo) ON DELETE CASCADE,
  primary_person_id        INTEGER NOT NULL REFERENCES people(person_id) ON DELETE RESTRICT,
  backup_person_id         INTEGER REFERENCES people(person_id) ON DELETE RESTRICT,
  assigned_date            TEXT,
  effective_from           TEXT,
  effective_to             TEXT,
  confidence               TEXT NOT NULL DEFAULT 'confirmed' CHECK (confidence IN ('confirmed', 'inferred', 'manual')),
  source_id                INTEGER REFERENCES data_sources(source_id),
  remarks                  TEXT,
  CHECK (effective_to IS NULL OR effective_from IS NULL OR effective_to >= effective_from)
);
CREATE INDEX idx_vessel_supervisor_imo ON vessel_supervisor_assignments(imo);
CREATE INDEX idx_vessel_supervisor_primary ON vessel_supervisor_assignments(primary_person_id);
CREATE UNIQUE INDEX uq_vessel_supervisor_current
  ON vessel_supervisor_assignments(imo)
  WHERE effective_to IS NULL;

-- ============================================================
-- Vessel safety organization
-- ============================================================

CREATE TABLE vessel_safety_roles (
  role_code   TEXT PRIMARY KEY,
  role_ko     TEXT NOT NULL,
  role_en     TEXT NOT NULL,
  sort_order  INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE vessel_safety_assignments (
  imo              TEXT NOT NULL REFERENCES vessels(imo) ON DELETE CASCADE,
  role_code        TEXT NOT NULL REFERENCES vessel_safety_roles(role_code),
  designation_ko   TEXT,
  designation_en   TEXT,
  qualification    TEXT,
  duties           TEXT,
  source_id        INTEGER REFERENCES data_sources(source_id),
  PRIMARY KEY (imo, role_code)
);
CREATE INDEX idx_vessel_safety_role ON vessel_safety_assignments(role_code);

-- ============================================================
-- RightShip overlay
-- ============================================================

CREATE TABLE vessel_rightship_profiles (
  imo                   TEXT PRIMARY KEY REFERENCES vessels(imo) ON DELETE CASCADE,
  doc_company           TEXT,
  commercial_manager    TEXT,
  technical_manager     TEXT,
  commercial_operator   TEXT,
  beneficial_owner      TEXT,
  registered_owner      TEXT,
  hull_type             TEXT,
  statcode5             TEXT,
  age_years             REAL CHECK (age_years IS NULL OR age_years >= 0),
  lead_sister_imo       TEXT,
  status                TEXT,
  source_id             INTEGER REFERENCES data_sources(source_id),
  updated_at            TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- API-friendly views
-- ============================================================

CREATE VIEW v_current_staff AS
SELECT
  sa.assignment_id,
  sa.company_code,
  sa.department_code,
  sa.team_code,
  sa.org_level,
  sa.role_ko,
  sa.role_en,
  sa.is_leader,
  sa.sort_order,
  p.person_id,
  p.name_ko,
  p.name_en,
  p.name_ko_key
FROM staff_assignments sa
JOIN people p ON p.person_id = sa.person_id
WHERE sa.valid_to IS NULL;

CREATE VIEW v_company_staff_count AS
SELECT company_code, COUNT(*) AS staff_count
FROM v_current_staff
GROUP BY company_code;

CREATE VIEW v_company_team_count AS
SELECT company_code, COUNT(DISTINCT team_code) AS teams_count
FROM v_current_staff
WHERE team_code IS NOT NULL
GROUP BY company_code;

CREATE VIEW v_company_fleet_stats AS
SELECT
  ism_manager_code AS company_code,
  COUNT(*) AS fleet_count,
  COALESCE(SUM(gt), 0) AS total_gt,
  COALESCE(SUM(dwt), 0) AS total_dwt,
  SUM(CASE WHEN vessel_type = 'VC' THEN 1 ELSE 0 END) AS vc_count,
  SUM(CASE WHEN vessel_type = 'BC' THEN 1 ELSE 0 END) AS bc_count
FROM vessels
WHERE is_active = 1
GROUP BY ism_manager_code;

CREATE VIEW v_vessel_supervisor AS
SELECT
  v.imo,
  v.vessel_no,
  v.name,
  v.vessel_type,
  v.flag_code,
  v.gt,
  v.dwt,
  v.class_society,
  v.ism_manager_code,
  pp.person_id AS primary_person_id,
  pp.name_ko AS primary_supt,
  bp.person_id AS backup_person_id,
  bp.name_ko AS backup_supt,
  s.assigned_date,
  s.effective_from,
  s.effective_to,
  s.confidence,
  s.remarks
FROM vessels v
LEFT JOIN vessel_supervisor_assignments s
  ON s.imo = v.imo AND s.effective_to IS NULL
LEFT JOIN people pp ON pp.person_id = s.primary_person_id
LEFT JOIN people bp ON bp.person_id = s.backup_person_id;

CREATE VIEW v_safety_eligible_vessels AS
SELECT
  v.imo,
  v.name,
  v.vessel_type,
  v.flag_code,
  v.flag_category,
  v.gt,
  v.dwt,
  v.ism_manager_code,
  c.name_ko AS ism_name_ko,
  c.name_en AS ism_name_en
FROM vessels v
LEFT JOIN companies c ON c.company_code = v.ism_manager_code
WHERE v.safety_org_required = 1
ORDER BY v.flag_category DESC, v.vessel_no;

CREATE VIEW v_duty_assignments_api AS
SELECT
  d.duty_id,
  d.team_code,
  t.name_ko AS team_name_ko,
  t.name_en AS team_name_en,
  p.person_id AS assignee_person_id,
  p.name_ko AS staff_name,
  d.role_snapshot_ko AS role_ko,
  d.duty_area,
  d.duty_content,
  d.is_essential,
  d.sort_order,
  GROUP_CONCAT(bp.name_ko, ', ') AS backup_names_text,
  d.remarks
FROM duty_assignments d
JOIN teams t ON t.team_code = d.team_code
JOIN people p ON p.person_id = d.assignee_person_id
LEFT JOIN duty_backup_people dbp ON dbp.duty_id = d.duty_id
LEFT JOIN people bp ON bp.person_id = dbp.backup_person_id
WHERE d.valid_to IS NULL
GROUP BY d.duty_id;
