-- ============================================================
-- Vessel Supervisor mapping
-- 출처: SAMJOO SM / DORIKO Contact list (2026.05.08) 공식 PDF
-- ============================================================
DROP TABLE IF EXISTS vessel_supervisor;

CREATE TABLE vessel_supervisor (
  vessel_imo    TEXT PRIMARY KEY REFERENCES vessels(imo),
  primary_supt  TEXT NOT NULL,
  backup_supt   TEXT,
  remarks       TEXT
);

-- 박해민 (H.M.Park · doriko.com)  ← YOUNG SHIN / AH SHIN / SANG SHIN
INSERT INTO vessel_supervisor (vessel_imo, primary_supt) VALUES
  ('9021332', '박해민'),
  ('9177430', '박해민'),
  ('9073701', '박해민');

-- 최광식 (G.S.Choi · doriko.com)  ← SJ BUSAN / SJ COLOMBO
INSERT INTO vessel_supervisor (vessel_imo, primary_supt) VALUES
  ('9418729', '최광식'),
  ('9478511', '최광식');

-- 권순범 (S.B.Kwon · samjoosm.com)  ← GMT ASTRO
INSERT INTO vessel_supervisor (vessel_imo, primary_supt) VALUES
  ('8606056', '권순범');

-- 이주원 (J.W.Lee · doriko.com)  ← HAE SHIN / G POSEIDON / SOO SHIN
INSERT INTO vessel_supervisor (vessel_imo, primary_supt) VALUES
  ('9053505', '이주원'),
  ('9445394', '이주원'),
  ('9166704', '이주원');

-- 김동현 (D.H.Kim · samjoosm.com)  ← DAEBO GLADSTONE
INSERT INTO vessel_supervisor (vessel_imo, primary_supt) VALUES
  ('9610561', '김동현');

-- 팽철호 (C.H.Pang · samjoosm.com)  ← SJ ASIA / BT TREVIA
INSERT INTO vessel_supervisor (vessel_imo, primary_supt) VALUES
  ('9304538', '팽철호'),
  ('9710517', '팽철호');

-- WOORI SUN
INSERT INTO vessel_supervisor (vessel_imo, primary_supt) VALUES
  ('9310678', '최광식');
