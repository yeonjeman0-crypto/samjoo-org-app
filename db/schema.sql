-- ============================================================
-- SAMJOO SM & DORIKO  ·  Organization & Fleet DB Schema
-- SQLite 3
-- ============================================================
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS vessels;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS companies;

-- 회사 / Companies
CREATE TABLE companies (
  code           TEXT PRIMARY KEY,           -- 'combined' | 'samjoo' | 'doriko'
  name_ko        TEXT NOT NULL,
  name_en        TEXT NOT NULL,
  role_ko        TEXT,                       -- 통합 조직 / 선박관리회사 / ISM Manager
  role_en        TEXT,
  color_primary  TEXT,                       -- hex
  color_accent   TEXT,
  sort_order     INTEGER DEFAULT 0
);

-- 부서·실 / Departments (선박관리본부, 경영지원실)
CREATE TABLE departments (
  code           TEXT PRIMARY KEY,           -- 'smd' | 'bsd'
  name_ko        TEXT NOT NULL,
  name_en        TEXT NOT NULL,
  sort_order     INTEGER DEFAULT 0
);

-- 팀 / Teams
CREATE TABLE teams (
  code           TEXT PRIMARY KEY,           -- 'CMT','SQT','MTT','BST'
  name_ko        TEXT NOT NULL,
  name_en        TEXT NOT NULL,
  department_code TEXT REFERENCES departments(code),
  color_token    TEXT,                       -- 'marine','safety','tech','biz'
  sort_order     INTEGER DEFAULT 0
);

-- 인사 / Staff
CREATE TABLE staff (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  company_code   TEXT NOT NULL REFERENCES companies(code),
  team_code      TEXT REFERENCES teams(code),           -- NULL: CEO / Director
  dept_code      TEXT REFERENCES departments(code),     -- NULL: CEO
  level          INTEGER NOT NULL,           -- 1 CEO  2 Dept Head  3 Team Member
  role_ko        TEXT NOT NULL,              -- 대표이사/본부장/상무/팀장/감독/감독선장/대리
  role_en        TEXT NOT NULL,
  name_ko        TEXT NOT NULL,
  name_en        TEXT NOT NULL,
  is_leader      INTEGER NOT NULL DEFAULT 0, -- 1 = team leader
  sort_order     INTEGER DEFAULT 0
);
CREATE INDEX idx_staff_company ON staff(company_code);
CREATE INDEX idx_staff_team    ON staff(team_code);

-- 선박 / Vessels
CREATE TABLE vessels (
  imo            TEXT PRIMARY KEY,           -- IMO number
  no             INTEGER,                    -- display index
  name           TEXT NOT NULL,
  type           TEXT NOT NULL,              -- 'VC' (Vehicles Carrier) | 'BC' (Bulk Carrier)
  built          INTEGER,
  flag           TEXT,                       -- 'PAN','KOR'
  gt             INTEGER,
  dwt            INTEGER,
  class          TEXT,                       -- 'DNV (IACS)' etc.
  ism_manager_code TEXT NOT NULL REFERENCES companies(code)
);
CREATE INDEX idx_vessels_ism ON vessels(ism_manager_code);
CREATE INDEX idx_vessels_type ON vessels(type);

-- ============================================================
-- Aggregated views
-- ============================================================
CREATE VIEW IF NOT EXISTS v_company_staff_count AS
SELECT company_code, COUNT(*) AS staff_count
FROM staff GROUP BY company_code;

CREATE VIEW IF NOT EXISTS v_company_team_count AS
SELECT company_code, COUNT(DISTINCT team_code) AS teams_count
FROM staff WHERE team_code IS NOT NULL GROUP BY company_code;

CREATE VIEW IF NOT EXISTS v_company_fleet_stats AS
SELECT ism_manager_code AS company_code,
       COUNT(*)         AS fleet_count,
       SUM(gt)          AS total_gt,
       SUM(dwt)         AS total_dwt,
       SUM(CASE WHEN type='VC' THEN 1 ELSE 0 END) AS vc_count,
       SUM(CASE WHEN type='BC' THEN 1 ELSE 0 END) AS bc_count
FROM vessels GROUP BY ism_manager_code;
