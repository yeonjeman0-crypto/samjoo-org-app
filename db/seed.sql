-- ============================================================
-- Seed data  ·  As of 2026-05
-- ============================================================

-- Companies
INSERT INTO companies (code, name_ko, name_en, role_ko, role_en, color_primary, color_accent, sort_order) VALUES
  ('combined', '삼주에스엠(주) & (주)도리코', 'SAMJOO SM & DORIKO',       '통합 조직',      'COMBINED ORGANIZATION', '#7C3AED', '#EDE9FE', 1),
  ('samjoo',   '삼주에스엠(주)',             'SAMJOO SM CO., LTD.',      '선박 관리회사',   'SHIP MANAGER',          '#2563EB', '#DBEAFE', 2),
  ('doriko',   '(주)도리코',                'DORIKO LTD.',              'ISM MANAGER',    'ISM MANAGER',           '#0891B2', '#CFFAFE', 3);

-- Departments
INSERT INTO departments (code, name_ko, name_en, sort_order) VALUES
  ('smd', '선박관리본부', 'Ship Management Division',   1),
  ('bsd', '경영지원실',  'Business Support Department', 2);

-- Teams
INSERT INTO teams (code, name_ko, name_en, department_code, color_token, sort_order) VALUES
  ('CMT', '해상인사팀', 'Crew Management Team',  'smd', 'marine', 1),
  ('SQT', '안전품질팀', 'Safety & Quality Team', 'smd', 'safety', 2),
  ('MTT', '공무팀',     'Marine Technical Team', 'smd', 'tech',   3),
  ('BST', '경영지원팀', 'Business Support Team', 'bsd', 'biz',    4);

-- ============================================================
-- STAFF
-- level: 1=CEO, 2=Dept Head, 3=Member
-- ============================================================

-- ───── COMBINED (23) ─────
-- CEO
INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order) VALUES
('combined', NULL, NULL, 1, '대표이사', 'CHIEF EXECUTIVE OFFICER', '정 진 욱', 'JEONG JIN WOOK', 0, 1);

-- Department heads
INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order) VALUES
('combined', NULL, 'smd', 2, '선박관리본부 · DP', 'SHIP MGMT DIVISION · DIVISION MANAGER', '최 인 호', 'CHOI IN HO',     0, 1),
('combined', NULL, 'bsd', 2, '경영지원실 · 상무',           'BUSINESS SUPPORT DEPARTMENT',          '강 충 식', 'KANG CHUNG SIK', 0, 2);

-- CMT (해상인사팀) 5
INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order) VALUES
('combined','CMT','smd',3,'팀 장','TEAM LEADER',      '원 훈 희','WON HUN HUI',     1,1),
('combined','CMT','smd',3,'감 독','SUPERINTENDENT',  '전 정 환','JEON JEONG HWAN',0,2),
('combined','CMT','smd',3,'대 리','ASSISTANT MGR.',  '임 수 현','IM SU HYUN',     0,3),
('combined','CMT','smd',3,'대 리','ASSISTANT MGR.',  '이 정 은','LEE JEONG EUN',  0,4),
('combined','CMT','smd',3,'대 리','ASSISTANT MGR.',  '이 의 진','LEE UI JIN',     0,5);

-- SQT (안전품질팀) 4
INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order) VALUES
('combined','SQT','smd',3,'팀 장',    'TEAM LEADER',     '연 제 만','YEON JE MAN',          1,1),
('combined','SQT','smd',3,'감독선장', 'CAPT. SUPT.',     '노 경 수','NOH GYEONG SU · DAVE', 0,2),
('combined','SQT','smd',3,'감 독',    'SUPERINTENDENT',  '민 경 진','MIN KYOUNG JIN',       0,3),
('combined','SQT','smd',3,'감 독',    'SUPERINTENDENT',  '함 혁',   'HAM HYUK',             0,4);

-- MTT (공무팀) 8
INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order) VALUES
('combined','MTT','smd',3,'팀 장','TEAM LEADER',     '최 우 종','CHOI WOO JONG · TEDDY',1,1),
('combined','MTT','smd',3,'감 독','SUPERINTENDENT', '최 광 식','CHOI GWANG SIK',       0,2),
('combined','MTT','smd',3,'감 독','SUPERINTENDENT', '박 해 민','PARK HAEMIN · HENRY',  0,3),
('combined','MTT','smd',3,'감 독','SUPERINTENDENT', '이 주 원','LEE JU WON',           0,4),
('combined','MTT','smd',3,'감 독','SUPERINTENDENT', '김 동 현','KIM DONG HYUN',        0,5),
('combined','MTT','smd',3,'감 독','SUPERINTENDENT', '권 순 범','KWON SUN BEOM',        0,6),
('combined','MTT','smd',3,'감 독','SUPERINTENDENT', '팽 철 호','PAENG CHEOL HO',       0,7),
('combined','MTT','smd',3,'대 리','ASSISTANT MGR.', '김 가 현','KIM KA HYUN',          0,8);

-- BST (경영지원팀) 3
INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order) VALUES
('combined','BST','bsd',3,'팀 장','TEAM LEADER',     '공 유 진','KONG YU JIN',  1,1),
('combined','BST','bsd',3,'대 리','ASSISTANT MGR.', '김 현 기','KIM HYEON KI', 0,2),
('combined','BST','bsd',3,'대 리','ASSISTANT MGR.', '라 지 현','LA JI HYUN',   0,3);

-- ───── SAMJOO SM (8) ─────
INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order) VALUES
('samjoo', NULL, NULL,  1, '대표이사',                 'CHIEF EXECUTIVE OFFICER',              '정 진 욱','JEONG JIN WOOK',         0,1),
('samjoo', NULL, 'smd', 2, '선박관리본부 · DP','SHIP MGMT DIVISION · DIVISION MANAGER','최 우 종','CHOI WOO JONG · TEDDY', 0,1);

-- CMT 1
INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order) VALUES
('samjoo','CMT','smd',3,'대 리','ASSISTANT MGR.','이 의 진','LEE UI JIN',0,1);

-- SQT 2
INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order) VALUES
('samjoo','SQT','smd',3,'감 독','SUPERINTENDENT','민 경 진','MIN KYOUNG JIN',0,1),
('samjoo','SQT','smd',3,'감 독','SUPERINTENDENT','함 혁',  'HAM HYUK',      0,2);

-- MTT 3
INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order) VALUES
('samjoo','MTT','smd',3,'감 독','SUPERINTENDENT','김 동 현','KIM DONG HYUN', 0,1),
('samjoo','MTT','smd',3,'감 독','SUPERINTENDENT','권 순 범','KWON SUN BEOM', 0,2),
('samjoo','MTT','smd',3,'감 독','SUPERINTENDENT','팽 철 호','PAENG CHEOL HO',0,3);

-- ───── DORIKO (16) ─────
INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order) VALUES
('doriko', NULL, NULL,  1, '대표이사',                  'CHIEF EXECUTIVE OFFICER',               '정 진 욱','JEONG JIN WOOK',  0,1),
('doriko', NULL, 'smd', 2, '선박관리본부 · DP','SHIP MGMT DIVISION · DIVISION MANAGER', '최 인 호','CHOI IN HO',      0,1),
('doriko', NULL, 'bsd', 2, '경영지원실 · 상무',          'BUSINESS SUPPORT DEPARTMENT',           '강 충 식','KANG CHUNG SIK',  0,2);

-- CMT 4
INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order) VALUES
('doriko','CMT','smd',3,'팀 장','TEAM LEADER',     '원 훈 희','WON HUN HUI',      1,1),
('doriko','CMT','smd',3,'감 독','SUPERINTENDENT', '전 정 환','JEON JEONG HWAN', 0,2),
('doriko','CMT','smd',3,'대 리','ASSISTANT MGR.', '임 수 현','IM SU HYUN',      0,3),
('doriko','CMT','smd',3,'대 리','ASSISTANT MGR.', '이 정 은','LEE JEONG EUN',   0,4);

-- SQT 2
INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order) VALUES
('doriko','SQT','smd',3,'팀 장',    'TEAM LEADER', '연 제 만','YEON JE MAN',          1,1),
('doriko','SQT','smd',3,'감독선장', 'CAPT. SUPT.', '노 경 수','NOH GYEONG SU · DAVE', 0,2);

-- MTT 4
INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order) VALUES
('doriko','MTT','smd',3,'감 독','SUPERINTENDENT','최 광 식','CHOI GWANG SIK',      0,1),
('doriko','MTT','smd',3,'감 독','SUPERINTENDENT','박 해 민','PARK HAEMIN · HENRY', 0,2),
('doriko','MTT','smd',3,'감 독','SUPERINTENDENT','이 주 원','LEE JU WON',          0,3),
('doriko','MTT','smd',3,'대 리','ASSISTANT MGR.','김 가 현','KIM KA HYUN',         0,4);

-- BST 3
INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order) VALUES
('doriko','BST','bsd',3,'팀 장','TEAM LEADER',    '공 유 진','KONG YU JIN', 1,1),
('doriko','BST','bsd',3,'대 리','ASSISTANT MGR.','김 현 기','KIM HYEON KI',0,2),
('doriko','BST','bsd',3,'대 리','ASSISTANT MGR.','라 지 현','LA JI HYUN',  0,3);

-- ============================================================
-- VESSELS  ·  13 ships
-- ============================================================
INSERT INTO vessels (imo, no, name, type, built, flag, gt, dwt, class, ism_manager_code) VALUES
('8606056', 1, 'GMT ASTRO',       'VC', 1987, 'PAN', 48017,  16141,  'DNV (IACS)', 'doriko'),
('9021332', 2, 'YOUNG SHIN',      'VC', 1992, 'PAN', 47677,  14274,  'NK (IACS)',  'doriko'),
('9053505', 3, 'HAE SHIN',        'VC', 1994, 'PAN', 41931,  17183,  'DNV (IACS)', 'doriko'),
('9073701', 4, 'SANG SHIN',       'VC', 1994, 'PAN', 50308,  16178,  'DNV (IACS)', 'doriko'),
('9166704', 5, 'SOO SHIN',        'VC', 1998, 'PAN', 44219,  13680,  'DNV (IACS)', 'doriko'),
('9177430', 6, 'AH SHIN',         'VC', 1999, 'PAN', 57449,  21503,  'DNV (IACS)', 'doriko'),
('9445394', 7, 'G POSEIDON',      'VC', 2011, 'PAN', 72408,  27003,  'DNV (IACS)', 'doriko'),
('9310678', 8, 'WOORI SUN',       'BC', 2004, 'KOR', 29960,  53576,  'KR (IACS)',  'doriko'),
('9418729', 9, 'SJ BUSAN',        'BC', 2008, 'KOR', 31544,  55940,  'KR (IACS)',  'doriko'),
('9478511',10, 'SJ COLOMBO',      'BC', 2010, 'KOR', 31544,  55989,  'KR (IACS)',  'doriko'),
('9304538',11, 'SJ ASIA',         'BC', 2005, 'KOR', 88494, 177477,  'KR (IACS)',  'samjoo'),
('9610561',12, 'DAEBO GLADSTONE', 'BC', 2013, 'PAN', 44102,  81399,  'KR (IACS)',  'samjoo'),
('9710517',13, 'BT TREVIA',       'BC', 2016, 'PAN', 36332,  63581,  'KR (IACS)',  'samjoo');
