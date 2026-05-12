-- ============================================================
-- Vessel Safety Organization (APP.6 기준, BBCHP + 한국적만)
-- 적용 대상: 6척
--   · 한국적 4: WOORI SUN, SJ BUSAN, SJ COLOMBO, SJ ASIA
--   · BBCHP  2: DAEBO GLADSTONE, BT TREVIA
-- ============================================================
DROP TABLE IF EXISTS vessel_safety_org;

CREATE TABLE vessel_safety_org (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  vessel_imo      TEXT NOT NULL REFERENCES vessels(imo),
  role_code       TEXT NOT NULL,    -- MASTER / SAFETY_OFFICER / HEALTH_OFFICER / SAFETY_REP
  role_ko         TEXT NOT NULL,
  role_en         TEXT NOT NULL,
  designation_ko  TEXT,             -- 직책 지정 (예: '기관장')
  designation_en  TEXT,
  qualification   TEXT,             -- 자격 요건
  duties          TEXT,             -- 핵심 직무
  sort_order      INTEGER DEFAULT 0
);
CREATE INDEX idx_vso_imo ON vessel_safety_org(vessel_imo);

-- 적용 대상 표시용 컬럼 추가 (vessels에 safety_org_required 플래그)
-- 별도 테이블 대신 vessels에 컬럼 추가
ALTER TABLE vessels ADD COLUMN safety_org_required INTEGER DEFAULT 0;
ALTER TABLE vessels ADD COLUMN flag_category TEXT;  -- 'KOR' | 'BBCHP' | 'PAN'

-- 적용 대상 6척 마킹
UPDATE vessels SET safety_org_required = 1, flag_category = 'KOR'   WHERE imo = '9310678'; -- WOORI SUN
UPDATE vessels SET safety_org_required = 1, flag_category = 'KOR'   WHERE imo = '9418729'; -- SJ BUSAN
UPDATE vessels SET safety_org_required = 1, flag_category = 'KOR'   WHERE imo = '9478511'; -- SJ COLOMBO
UPDATE vessels SET safety_org_required = 1, flag_category = 'KOR'   WHERE imo = '9304538'; -- SJ ASIA
UPDATE vessels SET safety_org_required = 1, flag_category = 'BBCHP' WHERE imo = '9610561'; -- DAEBO GLADSTONE
UPDATE vessels SET safety_org_required = 1, flag_category = 'BBCHP' WHERE imo = '9710517'; -- BT TREVIA

-- 비대상은 PAN 으로 표시
UPDATE vessels SET flag_category = 'PAN' WHERE flag_category IS NULL;

-- ============================================================
-- Seed: 4개 직책 × 6척 = 24행
-- 직책만 (이름 없음) — 안전사관은 기관장(C/E)으로 표준 지정
-- ============================================================

-- WOORI SUN (9310678)
INSERT INTO vessel_safety_org (vessel_imo, role_code, role_ko, role_en, designation_ko, designation_en, qualification, duties, sort_order) VALUES
('9310678','MASTER',         '선장',     'Master',          '선장',                 'Master / Captain',          NULL,                                    '선내 안전·보건 점검 총괄, 작업중지 최종 승인, 사고 보고', 1),
('9310678','SAFETY_OFFICER', '안전사관', 'Safety Officer',  '기관장',               'Chief Engineer (C/E)',      '기관장 또는 승선 경력 2년 이상의 기관사', '장비·기계 점검, 고위험작업 현장 감독, 비상 시 작업중지 지시', 2),
('9310678','HEALTH_OFFICER', '보건사관', 'Health Officer',  '의료관리자 / 선장 겸임','Medical Officer / Master', '의료관리자 또는 선장 겸임',              '응급환자 초기대응, 의료장비·의약품 관리, 전염병 예방',     3),
('9310678','SAFETY_REP',     '안전대표', 'Safety Rep.',     '선원 중 선출',          'Elected from Crew',         '일반 선원 중 공정·자유로운 절차로 선출',  '선원 의견 수렴·전달, 선내안전위원회 참석',                4);

-- SJ BUSAN (9418729)
INSERT INTO vessel_safety_org (vessel_imo, role_code, role_ko, role_en, designation_ko, designation_en, qualification, duties, sort_order) VALUES
('9418729','MASTER',         '선장',     'Master',          '선장',                 'Master / Captain',          NULL,                                    '선내 안전·보건 점검 총괄, 작업중지 최종 승인, 사고 보고', 1),
('9418729','SAFETY_OFFICER', '안전사관', 'Safety Officer',  '기관장',               'Chief Engineer (C/E)',      '기관장 또는 승선 경력 2년 이상의 기관사', '장비·기계 점검, 고위험작업 현장 감독, 비상 시 작업중지 지시', 2),
('9418729','HEALTH_OFFICER', '보건사관', 'Health Officer',  '의료관리자 / 선장 겸임','Medical Officer / Master', '의료관리자 또는 선장 겸임',              '응급환자 초기대응, 의료장비·의약품 관리, 전염병 예방',     3),
('9418729','SAFETY_REP',     '안전대표', 'Safety Rep.',     '선원 중 선출',          'Elected from Crew',         '일반 선원 중 공정·자유로운 절차로 선출',  '선원 의견 수렴·전달, 선내안전위원회 참석',                4);

-- SJ COLOMBO (9478511)
INSERT INTO vessel_safety_org (vessel_imo, role_code, role_ko, role_en, designation_ko, designation_en, qualification, duties, sort_order) VALUES
('9478511','MASTER',         '선장',     'Master',          '선장',                 'Master / Captain',          NULL,                                    '선내 안전·보건 점검 총괄, 작업중지 최종 승인, 사고 보고', 1),
('9478511','SAFETY_OFFICER', '안전사관', 'Safety Officer',  '기관장',               'Chief Engineer (C/E)',      '기관장 또는 승선 경력 2년 이상의 기관사', '장비·기계 점검, 고위험작업 현장 감독, 비상 시 작업중지 지시', 2),
('9478511','HEALTH_OFFICER', '보건사관', 'Health Officer',  '의료관리자 / 선장 겸임','Medical Officer / Master', '의료관리자 또는 선장 겸임',              '응급환자 초기대응, 의료장비·의약품 관리, 전염병 예방',     3),
('9478511','SAFETY_REP',     '안전대표', 'Safety Rep.',     '선원 중 선출',          'Elected from Crew',         '일반 선원 중 공정·자유로운 절차로 선출',  '선원 의견 수렴·전달, 선내안전위원회 참석',                4);

-- SJ ASIA (9304538)
INSERT INTO vessel_safety_org (vessel_imo, role_code, role_ko, role_en, designation_ko, designation_en, qualification, duties, sort_order) VALUES
('9304538','MASTER',         '선장',     'Master',          '선장',                 'Master / Captain',          NULL,                                    '선내 안전·보건 점검 총괄, 작업중지 최종 승인, 사고 보고', 1),
('9304538','SAFETY_OFFICER', '안전사관', 'Safety Officer',  '기관장',               'Chief Engineer (C/E)',      '기관장 또는 승선 경력 2년 이상의 기관사', '장비·기계 점검, 고위험작업 현장 감독, 비상 시 작업중지 지시', 2),
('9304538','HEALTH_OFFICER', '보건사관', 'Health Officer',  '의료관리자 / 선장 겸임','Medical Officer / Master', '의료관리자 또는 선장 겸임',              '응급환자 초기대응, 의료장비·의약품 관리, 전염병 예방',     3),
('9304538','SAFETY_REP',     '안전대표', 'Safety Rep.',     '선원 중 선출',          'Elected from Crew',         '일반 선원 중 공정·자유로운 절차로 선출',  '선원 의견 수렴·전달, 선내안전위원회 참석',                4);

-- DAEBO GLADSTONE (9610561) - BBCHP
INSERT INTO vessel_safety_org (vessel_imo, role_code, role_ko, role_en, designation_ko, designation_en, qualification, duties, sort_order) VALUES
('9610561','MASTER',         '선장',     'Master',          '선장',                 'Master / Captain',          NULL,                                    '선내 안전·보건 점검 총괄, 작업중지 최종 승인, 사고 보고', 1),
('9610561','SAFETY_OFFICER', '안전사관', 'Safety Officer',  '기관장',               'Chief Engineer (C/E)',      '기관장 또는 승선 경력 2년 이상의 기관사', '장비·기계 점검, 고위험작업 현장 감독, 비상 시 작업중지 지시', 2),
('9610561','HEALTH_OFFICER', '보건사관', 'Health Officer',  '의료관리자 / 선장 겸임','Medical Officer / Master', '의료관리자 또는 선장 겸임',              '응급환자 초기대응, 의료장비·의약품 관리, 전염병 예방',     3),
('9610561','SAFETY_REP',     '안전대표', 'Safety Rep.',     '선원 중 선출',          'Elected from Crew',         '일반 선원 중 공정·자유로운 절차로 선출',  '선원 의견 수렴·전달, 선내안전위원회 참석',                4);

-- BT TREVIA (9710517) - BBCHP
INSERT INTO vessel_safety_org (vessel_imo, role_code, role_ko, role_en, designation_ko, designation_en, qualification, duties, sort_order) VALUES
('9710517','MASTER',         '선장',     'Master',          '선장',                 'Master / Captain',          NULL,                                    '선내 안전·보건 점검 총괄, 작업중지 최종 승인, 사고 보고', 1),
('9710517','SAFETY_OFFICER', '안전사관', 'Safety Officer',  '기관장',               'Chief Engineer (C/E)',      '기관장 또는 승선 경력 2년 이상의 기관사', '장비·기계 점검, 고위험작업 현장 감독, 비상 시 작업중지 지시', 2),
('9710517','HEALTH_OFFICER', '보건사관', 'Health Officer',  '의료관리자 / 선장 겸임','Medical Officer / Master', '의료관리자 또는 선장 겸임',              '응급환자 초기대응, 의료장비·의약품 관리, 전염병 예방',     3),
('9710517','SAFETY_REP',     '안전대표', 'Safety Rep.',     '선원 중 선출',          'Elected from Crew',         '일반 선원 중 공정·자유로운 절차로 선출',  '선원 의견 수렴·전달, 선내안전위원회 참석',                4);

-- ============================================================
-- View: 적용 대상 선박만
-- ============================================================
CREATE VIEW IF NOT EXISTS v_safety_eligible_vessels AS
SELECT v.imo, v.name, v.type, v.flag, v.flag_category, v.gt, v.dwt,
       v.ism_manager_code,
       c.name_ko AS ism_name_ko, c.name_en AS ism_name_en
FROM vessels v
LEFT JOIN companies c ON c.code = v.ism_manager_code
WHERE v.safety_org_required = 1
ORDER BY v.flag_category DESC, v.no;
