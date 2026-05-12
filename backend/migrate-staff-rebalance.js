// ============================================================
// migrate-staff-rebalance.js
//   · 회사별 조직도 ↔ 업무분장 정합성 보정
//   · 최우종(MTT 팀장 + SAMJOO 본부장) → SAMJOO MTT 팀원으로도 등록
//     · 본부장 직책은 그대로 유지
//     · MTT 팀원 row 추가하여 SAMJOO MTT 뷰에 그의 업무 9건이 보이도록
//   · Idempotent
// Run: node migrate-staff-rebalance.js
// ============================================================
const path = require('path');
const { DatabaseSync } = require('node:sqlite');

const DB_PATH = path.resolve(__dirname, '..', 'db', 'orgchart.db');
const db = new DatabaseSync(DB_PATH);

console.log('· 최우종 SAMJOO MTT 팀장으로 추가 등록');
const exists = db.prepare(`
  SELECT COUNT(*) AS n FROM staff
  WHERE company_code='samjoo' AND team_code='MTT' AND REPLACE(name_ko,' ','')='최우종'
`).get().n;

if (exists) {
  console.log('   (이미 등록됨, skip)');
} else {
  db.prepare(`
    INSERT INTO staff (company_code, team_code, dept_code, level, role_ko, role_en, name_ko, name_en, is_leader, sort_order)
    VALUES ('samjoo', 'MTT', 'smd', 3, '팀 장', 'TEAM LEADER', '최 우 종', 'CHOI WOO JONG · TEDDY', 1, 0)
  `).run();
  console.log('   ✓ 등록 완료 (팀장, sort_order=0 → MTT 최상단)');
}

// ─── 검증 ───
console.log('\n=== 검증: 회사 × 팀 매트릭스 (정합성) ===');
const COMPANIES = ['combined','samjoo','doriko'];
const TEAMS = ['CMT','SQT','MTT','BST'];
let combinedTotal = 0, splitTotal = 0;

for (const co of COMPANIES) {
  console.log(' ' + co.toUpperCase());
  let coTotal = 0;
  for (const t of TEAMS) {
    let staffSet = null;
    if (co !== 'combined') {
      const rows = db.prepare(`
        SELECT REPLACE(name_ko,' ','') AS k FROM staff
        WHERE company_code=? AND team_code=?
      `).all(co, t);
      staffSet = new Set(rows.map(r => r.k));
    }
    const all = db.prepare("SELECT staff_name, is_essential FROM duty_assignments WHERE team_code=?").all(t);
    const f = staffSet ? all.filter(d => staffSet.has(d.staff_name)) : all;
    coTotal += f.length;
    console.log(`   ${t}: ${new Set(f.map(d=>d.staff_name)).size}명 / ${f.length}건`);
  }
  console.log(`   ─── 합계: ${coTotal}건`);
  if (co === 'combined') combinedTotal = coTotal;
  else splitTotal += coTotal;
}

console.log(`\n  COMBINED ${combinedTotal} = SAMJOO + DORIKO ${splitTotal}  →  ${combinedTotal === splitTotal ? '✓ 정합' : '✗ 불일치 ' + (combinedTotal - splitTotal) + '건 차이'}`);

// SAMJOO MTT 인원별 확인
console.log('\n=== SAMJOO MTT 인원별 업무 ===');
const samjooMttSet = new Set(db.prepare(`
  SELECT REPLACE(name_ko,' ','') AS k FROM staff
  WHERE company_code='samjoo' AND team_code='MTT'
`).all().map(r => r.k));
db.prepare("SELECT staff_name, COUNT(*) AS n FROM duty_assignments WHERE team_code='MTT' GROUP BY staff_name").all()
  .filter(r => samjooMttSet.has(r.staff_name))
  .forEach(r => console.log(`  ${r.staff_name}: ${r.n}건`));

db.close();
console.log('\n✓ Migration complete');
