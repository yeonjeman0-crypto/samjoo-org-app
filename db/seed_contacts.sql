-- ============================================================
-- Contact info (출처: Contact list 260508)
-- 인사별 전화 + 이메일 + 담당 업무
-- ============================================================
DROP TABLE IF EXISTS staff_contact;
CREATE TABLE staff_contact (
  staff_name_ko    TEXT PRIMARY KEY,
  staff_name_en    TEXT,
  team_code        TEXT,
  role             TEXT,
  tel              TEXT,
  mobile           TEXT,
  email            TEXT,
  domain_company   TEXT,
  responsibilities TEXT
);

INSERT INTO staff_contact VALUES
  ('정진욱',  'JW JEONG',     NULL,  'CEO',                 '+82-2-2021-7406', '+82-2-2021-7406', '',                          '',          'Chief Executive Officer'),
  ('최인호',  'I.H. Choi',    'SMD', 'DP / CSO',            '+82-2-2021-7414', '+82-10-9061-7118', '',                         '',          'Ship Management Division Manager'),
  ('원훈희',  'H.H. Won',     'CMT', 'Team Leader',         '+82-51-441-8905', '+82-10-6283-0116', '',                         '',          'Crew change, Family visiting, Crew welfare/injury, Recruitment, CMT overall'),
  ('전정환',  'J.H. Jeon',    'CMT', 'Superintendent',      '+82-51-441-8912', '+82-10-5549-9769', '',                         '',          'Crew change (Bulk Fleet), Drill and training/education'),
  ('임수현',  'S.H. Im',      'CMT', 'Asst. Manager',       '+82-51-977-8971', '+82-10-3033-6252', '',                         '',          'Crew wage, Crew cost, Ship money (CTM), Crew examination'),
  ('이정은',  'J.E. Lee',     'CMT', 'Asst. Manager',       '+82-51-441-8911', '+82-10-8003-7056', '',                         '',          'Crew change (PCC Fleet), Crew qualification, Labor supervision, ITF, Collective agreement'),
  ('이의진',  'E.J. Lee',     'CMT', 'Asst. Manager',       '+82-51-997-8972', '+82-10-2354-2677', '',                         '',          'Crew drill and training/education, Supply chart and publication'),

  ('최우종',  'W.J. Choi',    'MTT', 'Team Leader',         '+82-2-2021-7424', '+82-10-8654-5431', 'wjchoi@doriko.com',         'DORIKO',    'Marine Technical Team overall'),
  ('박해민',  'H.M. Park',    'MTT', 'Superintendent',      '+82-2-2021-7444', '+82-10-2978-7780', 'hmpark@doriko.com',         'DORIKO',    'YOUNG SHIN / AH SHIN / SANG SHIN / WOORI SUN'),
  ('최광식',  'G.S. Choi',    'MTT', 'Superintendent',      '+82-2-2021-7445', '+82-10-7761-9236', 'kschoi@doriko.com',         'DORIKO',    'SJ BUSAN / SJ COLOMBO'),
  ('권순범',  'S.B. Kwon',    'MTT', 'Superintendent',      '+82-2-2021-7404', '+82-10-5539-4609', 'sbkwon@samjoosm.com',       'SAMJOO SM', 'GMT ASTRO'),
  ('이주원',  'J.W. Lee',     'MTT', 'Superintendent',      '+82-2-2021-7443', '+82-10-7257-7319', 'jwlee@doriko.com',          'DORIKO',    'HAE SHIN / G POSEIDON / SOO SHIN'),
  ('김동현',  'D.H. Kim',     'MTT', 'Superintendent',      '+82-2-2021-7431', '+82-10-5470-9770', 'dhkim@samjoosm.com',        'SAMJOO SM', 'DAEBO GLADSTONE / BT TREVIA'),
  ('팽철호',  'C.H. Pang',    'MTT', 'Superintendent',      '+82-2-2021-7406', '+82-10-3001-3786', 'pa5992@samjoosm.com',       'SAMJOO SM', 'SJ ASIA'),
  ('김가현',  'G.H. Kim',     'MTT', 'Asst. Manager',       '+82-2-2021-7435', '+82-10-8799-9645', 'ghkim@doriko.com',          'DORIKO',    'Supply Stores and work assistance'),

  ('연제만',  'J.M. Yeon',    'SQT', 'Team Leader',         '+82-2-2021-7452', '+82-10-9293-0923', '',                          '',          'Safety & Quality Team overall'),
  ('노경수',  'G.S. No',      'SQT', 'Port Captain',        '+82-2-2021-7462', '+82-10-6711-2138', '',                          '',          'Ship Operation, Cargo, Regulation, Education and training'),
  ('민경진',  'K.J. Min',     'SQT', 'Superintendent',      '+82-2-2021-7407', '+82-10-7703-5692', '',                          '',          'Safety/Hygene, Security, Risk assessment, Accident/Near-Miss, System document, PSC, Rightship Inspection'),
  ('함혁',    'H. Hyuk',      'SQT', 'Superintendent',      '+82-2-2021-7422', '+82-10-9511-4834', '',                          '',          'Environment, CII, IMO DCS, EU ETS, Ship Communication/IT, Data Management');

-- Patch existing staff table with email/tel from contact list (where matchable)
UPDATE staff SET role_en = 'CEO · Chief Executive Officer'           WHERE name_ko = '정 진 욱';
