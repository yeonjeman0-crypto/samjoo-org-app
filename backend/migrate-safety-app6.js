// ============================================================
// migrate-safety-app6.js
//   PR-13 APP.6 절차서 기준으로 vessel_safety_org 보강:
//   1. SHM (Shore Safety & Health Manager / 육상 안전보건관리자) row 추가
//   2. has_swa 컬럼 추가 (SWA 권한자 표시 — Safety Rep / Safety Officer / Master)
//   3. qualification 텍스트 강화
//   · Idempotent
// Run: node migrate-safety-app6.js
// ============================================================
const path = require('path');
const { DatabaseSync } = require('node:sqlite');

const DB_PATH = path.resolve(__dirname, '..', 'db', 'orgchart.db');
const db = new DatabaseSync(DB_PATH);

// ─── 1) has_swa 컬럼 추가 (idempotent) ─────────
const cols = db.prepare("PRAGMA table_info(vessel_safety_org)").all().map(c => c.name);
if (!cols.includes('has_swa')) {
  db.exec("ALTER TABLE vessel_safety_org ADD COLUMN has_swa INTEGER DEFAULT 0");
  console.log('· has_swa column added');
} else {
  console.log('· has_swa column exists (skip)');
}
if (!cols.includes('shore_based')) {
  db.exec("ALTER TABLE vessel_safety_org ADD COLUMN shore_based INTEGER DEFAULT 0");
  console.log('· shore_based column added');
} else {
  console.log('· shore_based column exists (skip)');
}

// ─── 2) SWA 권한 표시 (절차서 §1.3.6) ──────────
//   · MASTER, SAFETY_OFFICER, SAFETY_REP — Stop Work Authority 보유
db.prepare(`UPDATE vessel_safety_org SET has_swa = 1 WHERE role_code IN ('MASTER','SAFETY_OFFICER','SAFETY_REP')`).run();
db.prepare(`UPDATE vessel_safety_org SET has_swa = 0 WHERE role_code = 'HEALTH_OFFICER'`).run();
console.log('· SWA flags applied');

// ─── 3) qualification 강화 ──────────────────────
const qualMap = {
  MASTER:         '한국적 외항선 선장 / Master',
  SAFETY_OFFICER: '기관장 또는 승선 경력 2년 이상 기관사 (선장 임명)',
  HEALTH_OFFICER: '의료관리자 또는 선장 겸임 (감염병·의약품 관리)',
  SAFETY_REP:     '일반 선원 중 공정·자유로운 절차로 선출 (선원 의견 대표)'
};
for (const [code, q] of Object.entries(qualMap)) {
  db.prepare(`UPDATE vessel_safety_org SET qualification = ? WHERE role_code = ? AND (qualification IS NULL OR qualification = '')`).run(q, code);
}
console.log('· qualification text strengthened');

// ─── 4) SHM (육상 안전보건관리자) 행 추가 ────────
//   · 회사별 본부장이 담당 (samjoo: 최우종, doriko: 최인호)
//   · 적용 대상 6척에 대해 그 선박의 ism_manager_code 본부장이 SHM
const eligible = db.prepare(`
  SELECT v.imo, v.name, v.ism_manager_code
  FROM vessels v
  WHERE v.safety_org_required = 1
`).all();

const shmByCompany = {
  samjoo: { name: '최우종', en: 'CHOI WOO JONG · TEDDY', title: 'DP' },
  doriko: { name: '최인호', en: 'CHOI IN HO',            title: 'DP' }
};

const insertShm = db.prepare(`
  INSERT INTO vessel_safety_org
    (vessel_imo, role_code, role_ko, role_en, designation_ko, designation_en, qualification, duties, sort_order, has_swa, shore_based)
  VALUES (?, 'SHM', '안전보건관리자', 'Safety & Health Manager', ?, ?, ?, ?, 0, 0, 1)
`);
const checkExist = db.prepare(`SELECT id FROM vessel_safety_org WHERE vessel_imo = ? AND role_code = 'SHM'`);

let added = 0;
eligible.forEach(v => {
  if (checkExist.get(v.imo)) return;
  const shm = shmByCompany[v.ism_manager_code];
  if (!shm) return;
  insertShm.run(
    v.imo,
    `${shm.name} (${shm.title})`,
    `${shm.en} (Division Manager DP)`,
    '회사 육상 조직 인원 (DP 또는 위임)',
    [
      '• 위험성 평가 계획·실행 총괄',
      '• 고위험 작업 사전 검토·승인',
      '• 선내 안전위원회 운영 지원',
      '• 안전보건 교육·훈련 총괄',
      '• 안전보건 비용 부담 (선원 전가 금지)'
    ].join('\n')
  );
  added++;
});
console.log(`· SHM rows added: ${added}`);

// ─── 5) sort_order 재정렬 (SHM=0 → 최상단) ─────
const orderMap = { SHM: 0, MASTER: 1, SAFETY_OFFICER: 2, HEALTH_OFFICER: 3, SAFETY_REP: 4 };
for (const [code, ord] of Object.entries(orderMap)) {
  db.prepare(`UPDATE vessel_safety_org SET sort_order = ? WHERE role_code = ?`).run(ord, code);
}

// ─── 검증 ─────────────────────────────────────
console.log('\n=== 검증 (WOORI SUN, IMO 9310678) ===');
db.prepare(`SELECT role_code, role_ko, designation_ko, has_swa, shore_based FROM vessel_safety_org WHERE vessel_imo='9310678' ORDER BY sort_order`).all()
  .forEach(r => console.log(` [${r.sort_order || ''}] ${r.role_code.padEnd(15)} ${r.role_ko.padEnd(10)} | ${r.designation_ko || ''} | SWA=${r.has_swa} shore=${r.shore_based}`));

db.close();
console.log('\n✓ Safety APP.6 migration complete');
