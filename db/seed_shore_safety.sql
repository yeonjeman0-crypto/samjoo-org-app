-- ============================================================
-- seed_shore_safety.sql · Shore safety organization for SAPA
-- 중대재해처벌법 육상 안전보건 조직 / 체크 항목
-- ============================================================

DROP TABLE IF EXISTS shore_safety_requirements;
DROP TABLE IF EXISTS shore_safety_roles;

CREATE TABLE shore_safety_roles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  company_code TEXT NOT NULL REFERENCES companies(code),
  role_code TEXT NOT NULL,
  role_ko TEXT NOT NULL,
  role_en TEXT NOT NULL,
  owner_name TEXT,
  owner_title TEXT,
  team_code TEXT REFERENCES teams(code),
  responsibility TEXT NOT NULL,
  legal_basis TEXT,
  sort_order INTEGER NOT NULL,
  UNIQUE(company_code, role_code)
);

CREATE TABLE shore_safety_requirements (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  company_code TEXT NOT NULL REFERENCES companies(code),
  req_code TEXT NOT NULL,
  category_ko TEXT NOT NULL,
  category_en TEXT NOT NULL,
  legal_basis TEXT NOT NULL,
  requirement_ko TEXT NOT NULL,
  owner_role_code TEXT NOT NULL,
  frequency TEXT,
  evidence TEXT,
  status TEXT NOT NULL,
  risk_note TEXT,
  sort_order INTEGER NOT NULL,
  UNIQUE(company_code, req_code)
);

-- ============================================================
-- Roles by company (combined / samjoo / doriko)
-- ============================================================
INSERT INTO shore_safety_roles
  (company_code, role_code, role_ko, role_en, owner_name, owner_title, team_code, responsibility, legal_basis, sort_order)
VALUES
  ('combined','CEO','경영책임자','Accountable Executive','정진욱','대표이사',
   NULL,'안전보건 목표와 경영방침 승인, 인력ㆍ예산 배정, 반기 이행점검 보고 수령 및 조치 지시',
   '중대재해처벌법 제4조, 시행령 제4조',1),
  ('combined','DP_MANAGER','안전보건관리 총괄책임','Shore Safety & Health Controller','최인호','DP',
   NULL,'육상 안전보건관리체계 총괄, 선박관리본부 위험요인 개선 조치, 중대산업재해 대응 지휘',
   '시행령 제4조 제5호ㆍ제8호',2),
  ('combined','SQT_LEAD','PR-23 안전보건관리 담당','PR-23 SAPA Manual Owner','연제만','안전품질팀장',
   'SQT','PR-23 매뉴얼 기준 육상 안전보건관리체계 구축ㆍ이행 실무 총괄',
   '시행령 제4조 제3호ㆍ제6호ㆍ제7호ㆍ제8호, PR-23',3),
  ('combined','SQT_PRACTICAL','안전보건 실무 담당','Safety & Health Coordinator','민경진','안전품질팀 감독',
   'SQT','육해상 비상대응 시스템, 제안제도, 안전보건 성과 모니터링, 문서ㆍ기록 관리 지원',
   '시행령 제4조 제3호ㆍ제7호ㆍ제8호',4),
  ('combined','MTT_LEAD','공무 안전보건 관리감독','Technical Safety Supervisor','최우종','공무팀장',
   'MTT','중대설비 식별, 정비ㆍ입거ㆍ외주수리 위험성평가, 기술적 위험요인 개선과 예산 요구',
   '시행령 제4조 제3호ㆍ제4호ㆍ제5호',5),
  ('combined','CMT_LEAD','해상직원 안전보건 교육','Crew Safety & Health Training Lead','원훈희','해상인사팀장',
   'CMT','해상직원 교육, 승선 전 안전교육 연계, 해상 인력 관련 안전보건 의견 접수 지원',
   '시행령 제4조 제7호, 산업안전보건 관계 법령',6),
  ('combined','BST_HEAD','예산ㆍ계약 관리','Budget & Contract Control','강충식','경영지원실 상무',
   'BST','안전보건 예산 편성ㆍ집행 지원, 도급ㆍ용역ㆍ위탁 계약 기준과 비용 반영 관리',
   '시행령 제4조 제4호ㆍ제9호',7);

-- Samjoo : BST 없음 → BUDGET/CONTRACTOR/LEGAL은 DP가 흡수
INSERT INTO shore_safety_roles
  (company_code, role_code, role_ko, role_en, owner_name, owner_title, team_code, responsibility, legal_basis, sort_order)
VALUES
  ('samjoo','CEO','경영책임자','Accountable Executive','정진욱','대표이사',
   NULL,'삼주에스엠 안전보건 목표 승인, 인력ㆍ예산 배정, 반기 이행점검 결과 조치',
   '중대재해처벌법 제4조, 시행령 제4조, PR-23',1),
  ('samjoo','DP_MANAGER','삼주 안전보건 총괄책임','Samjoo Safety & Health Controller','최우종','DP',
   NULL,'삼주에스엠 PR-23 이행 총괄. BST 부재로 예산ㆍ계약 관리 직접 흡수',
   '시행령 제4조 제4호ㆍ제5호ㆍ제8호ㆍ제9호, PR-23',2),
  ('samjoo','SQT_LEAD','삼주 PR-23 안전보건 담당','Samjoo PR-23 Manual Owner','민경진','안전품질팀 감독',
   'SQT','삼주에스엠 PR-23 매뉴얼 운영, 위험성평가ㆍ이행점검ㆍ의견청취ㆍ비상대응 관리',
   '시행령 제4조 제3호ㆍ제6호ㆍ제7호ㆍ제8호, PR-23',3),
  ('samjoo','SQT_PRACTICAL','삼주 안전보건 실무','Samjoo Safety Coordinator','함혁','안전품질팀 감독',
   'SQT','삼주에스엠 안전보건 실무, 비상대응ㆍ개선조치 기록 관리',
   '시행령 제4조 제3호ㆍ제7호ㆍ제8호, PR-23',4),
  ('samjoo','MTT_LEAD','삼주 공무 안전관리','Samjoo Technical Safety','김동현','공무팀 감독',
   'MTT','삼주에스엠 BBCHP/KOR 선박 정비ㆍ외주수리ㆍ중대설비 위험성평가, 도급ㆍ외주 평가 실무',
   '시행령 제4조 제3호ㆍ제4호ㆍ제5호ㆍ제9호, PR-23',5),
  ('samjoo','CMT_LEAD','삼주 해상직원 안전교육','Samjoo Crew Safety Training','이의진','해상인사팀 대리',
   'CMT','삼주에스엠 해상직원 교육 및 승선 전 안전교육 연계',
   '시행령 제4조 제7호, PR-23',6);

INSERT INTO shore_safety_roles
  (company_code, role_code, role_ko, role_en, owner_name, owner_title, team_code, responsibility, legal_basis, sort_order)
VALUES
  ('doriko','CEO','경영책임자','Accountable Executive','정진욱','대표이사',
   NULL,'도리코 안전보건 목표 승인, 인력ㆍ예산 배정, 반기 이행점검 결과 조치',
   '중대재해처벌법 제4조, 시행령 제4조, PR-23',1),
  ('doriko','DP_MANAGER','도리코 안전보건 총괄책임','Doriko Safety & Health Controller','최인호','DP',
   NULL,'도리코 PR-23 이행 총괄, 위험요인 개선 조치 및 경영책임자 보고',
   '시행령 제4조 제5호ㆍ제8호, PR-23',2),
  ('doriko','SQT_LEAD','도리코 PR-23 안전보건 담당','Doriko PR-23 Manual Owner','연제만','안전품질팀장',
   'SQT','도리코 PR-23 매뉴얼 운영, 위험성평가ㆍ의견청취ㆍ비상대응 절차 관리',
   '시행령 제4조 제3호ㆍ제6호ㆍ제7호ㆍ제8호, PR-23',3),
  ('doriko','SQT_PRACTICAL','도리코 안전보건 실무','Doriko Safety Coordinator','노경수','감독선장',
   'SQT','도리코 안전보건 실무, 선박 안전운항ㆍ교육훈련ㆍ비상대응 절차 관리',
   '시행령 제4조 제3호ㆍ제7호ㆍ제8호, PR-23',4),
  ('doriko','MTT_LEAD','도리코 공무 안전관리','Doriko Technical Safety','박해민','공무팀 감독',
   'MTT','도리코 KOR/PAN 선박 정비ㆍ외주수리ㆍ중대설비 위험성평가와 개선 예산 요구',
   '시행령 제4조 제3호ㆍ제4호ㆍ제5호, PR-23',5),
  ('doriko','CMT_LEAD','도리코 해상직원 안전교육','Doriko Crew Safety Training','원훈희','해상인사팀장',
   'CMT','도리코 해상직원 교육 및 승선 전 안전교육 연계',
   '시행령 제4조 제7호, PR-23',6),
  ('doriko','BST_HEAD','도리코 예산ㆍ계약 관리','Doriko Budget & Contract Control','강충식','경영지원실 상무',
   'BST','도리코 안전보건 예산 편성ㆍ집행, 도급ㆍ용역ㆍ위탁 계약 기준ㆍ비용 관리',
   '시행령 제4조 제4호ㆍ제9호, PR-23',7);

-- ============================================================
-- Requirements (해당없음 항목은 제외 — 9개 의무만 등록)
-- 모든 상태는 운영중 / 이행중
-- ============================================================
INSERT INTO shore_safety_requirements
  (company_code, req_code, category_ko, category_en, legal_basis, requirement_ko, owner_role_code, frequency, evidence, status, risk_note, sort_order)
VALUES
  ('combined','GOAL_POLICY','목표ㆍ경영방침','Safety Policy','시행령 제4조 제1호',
   'PR-23 매뉴얼 기준으로 육상 안전보건 목표와 경영방침을 관리하고 대표이사 승인 이력을 유지한다.',
   'CEO','연 1회 / 변경 시','PR-23 매뉴얼, 안전보건 경영방침, 목표관리표, 경영검토 회의록','운영중',NULL,1),
  ('combined','RISK_ASSESSMENT','유해ㆍ위험요인 확인ㆍ개선','Risk Assessment','시행령 제4조 제3호',
   'PR-23 및 위험성평가 절차에 따라 육상ㆍ선박관리ㆍ정비ㆍ외주 작업 위험요인을 확인하고 개선 이행 여부를 반기 1회 이상 점검한다.',
   'SQT_LEAD','반기 1회 이상','PR-23 매뉴얼, 위험성평가표, 개선조치대장, 반기 점검보고서','운영중',NULL,2),
  ('combined','BUDGET','인력ㆍ시설ㆍ장비 예산','Safety Budget','시행령 제4조 제4호',
   'PR-23 기준 재해 예방 인력ㆍ시설ㆍ장비 및 위험요인 개선 예산을 편성하고 목적에 맞게 집행한다.',
   'BST_HEAD','연 1회 편성 / 분기 집행확인','PR-23 매뉴얼, 안전보건 예산서, 집행내역, 개선 품의서','이행중',NULL,3),
  ('combined','AUTHORITY_EVAL','권한ㆍ예산ㆍ평가','Authority & Evaluation','시행령 제4조 제5호',
   'PR-23 책임체계에 따라 안전보건관리책임자등에게 권한ㆍ예산을 부여하고 업무 수행을 반기 1회 이상 평가ㆍ관리한다.',
   'DP_MANAGER','반기 1회 이상','PR-23 매뉴얼, 직무권한표, 위임전결규정, 평가표, 경영책임자 보고서','이행중',NULL,4),
  ('combined','PROFESSIONALS','전문인력 배치','Safety Professionals','시행령 제4조 제6호, 산업안전보건법 제17~19조ㆍ제22조',
   'PR-23 기준으로 안전관리자ㆍ보건관리자ㆍ안전보건관리담당자를 선임ㆍ위탁하여 운영한다. 산업보건의는 사업장 규모ㆍ업종 특성상 선임 대상 아님 (산업안전보건법 제22조 단서, 시행령 제29조).',
   'SQT_LEAD','연 1회 / 인원 변동 시','PR-23 매뉴얼, 선임서, 위탁계약서, 업무시간 보장 기록','운영중',NULL,5),
  ('combined','WORKER_OPINION','종사자 의견청취','Worker Consultation','시행령 제4조 제7호',
   'PR-23 기준으로 종사자 안전보건 의견을 듣는 절차를 운영하고 개선 이행 여부를 반기 1회 이상 점검한다.',
   'SQT_PRACTICAL','상시 접수 / 반기 점검','PR-23 매뉴얼, 제안제도 대장, 회의록, 개선조치대장','운영중',NULL,6),
  ('combined','EMERGENCY_MANUAL','중대산업재해 대응 매뉴얼','Emergency Manual','시행령 제4조 제8호',
   'PR-23 기준으로 작업중지ㆍ대피ㆍ위험요인 제거ㆍ구호ㆍ추가 피해방지 절차를 마련하고 반기 1회 이상 작동 여부를 점검한다.',
   'SQT_PRACTICAL','반기 1회 이상','PR-23 매뉴얼, 비상대응 매뉴얼, 훈련 기록, 사고 대응 보고서','운영중',NULL,7),
  ('combined','CONTRACTOR','도급ㆍ용역ㆍ위탁 관리','Contractor Control','시행령 제4조 제9호',
   'PR-23 기준으로 수급업체의 산재예방 능력 평가, 안전보건 관리비용 기준, 공사ㆍ건조기간 기준을 마련하고 반기 1회 이상 점검한다.',
   'BST_HEAD','계약 시 / 반기 점검','PR-23 매뉴얼, 협력업체 평가표, 계약 체크리스트, 안전보건 비용 기준','이행중',NULL,8),
  ('combined','LEGAL_COMPLIANCE','관계 법령 의무이행 점검','Legal Compliance Check','법 제4조 제1항 제4호, 시행령 제5조',
   'PR-23 기준으로 안전ㆍ보건 관계 법령 의무이행 여부를 반기 1회 이상 점검하고 미이행 시 인력ㆍ예산 등 필요한 조치를 한다.',
   'DP_MANAGER','반기 1회 이상','PR-23 매뉴얼, 법규등록부, 준수평가표, 시정조치대장','이행중',NULL,9);

-- Samjoo : BST 없음 → BUDGET/CONTRACTOR/LEGAL은 DP_MANAGER, 위험성평가/전문인력은 SQT_LEAD(민경진)
INSERT INTO shore_safety_requirements
  (company_code, req_code, category_ko, category_en, legal_basis, requirement_ko, owner_role_code, frequency, evidence, status, risk_note, sort_order)
SELECT 'samjoo', req_code, category_ko, category_en, legal_basis,
       REPLACE(requirement_ko, 'PR-23', '삼주에스엠 PR-23'),
       CASE
         WHEN req_code IN ('BUDGET','CONTRACTOR') THEN 'DP_MANAGER'
         ELSE owner_role_code
       END,
       frequency, evidence, status, NULL, sort_order
FROM shore_safety_requirements WHERE company_code='combined';

-- Doriko : 그대로 (BST_HEAD = 강충식 있음)
INSERT INTO shore_safety_requirements
  (company_code, req_code, category_ko, category_en, legal_basis, requirement_ko, owner_role_code, frequency, evidence, status, risk_note, sort_order)
SELECT 'doriko', req_code, category_ko, category_en, legal_basis,
       REPLACE(requirement_ko, 'PR-23', '도리코 PR-23'),
       owner_role_code, frequency, evidence, status, risk_note, sort_order
FROM shore_safety_requirements WHERE company_code='combined';
