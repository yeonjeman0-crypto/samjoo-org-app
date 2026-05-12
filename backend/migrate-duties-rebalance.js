// ============================================================
// migrate-duties-rebalance.js
//   Phase 1: 팽철호의 SQT 6건을 SQT 잔여 인원에게 재배치
//   Phase 2: BST(경영지원팀) 업무 데이터 추가
//   · Idempotent (필요 시 반복 실행 가능)
// Run: node migrate-duties-rebalance.js
// ============================================================
const fs = require('fs');
const path = require('path');
const { DatabaseSync } = require('node:sqlite');

const DB_PATH = path.resolve(__dirname, '..', 'db', 'orgchart.db');
const BST_SQL = path.resolve(__dirname, '..', 'db', 'seed_bst.sql');

const db = new DatabaseSync(DB_PATH);

// ─────────────────────────────────────────────
// Phase 1 — SQT 재배치 (팽철호 → SQT 인원)
// ─────────────────────────────────────────────
console.log('Phase 1: SQT 재배치 (팽철호 → 잔여 SQT 인원)');

const reassign = [
  { area: '문서/기록 관리',         new_owner: '민경진', new_backup: '함혁'   },
  { area: '안전품질팀 데이터 관리',  new_owner: '함혁',   new_backup: '민경진' },
  { area: '기타',                    new_owner: '노경수', new_backup: '함혁'   },
  { area: 'Near-miss 관리',          new_owner: '민경진', new_backup: '노경수' },
  { area: '선급/증서 관리',          new_owner: '함혁',   new_backup: '노경수' },
  { area: '변경관리 (MOC)',          new_owner: '노경수', new_backup: '민경진' }
];

const update = db.prepare(`
  UPDATE duty_assignments
  SET staff_name = ?, role_ko = ?, backup_name = ?, backup_names = ?
  WHERE team_code = 'SQT' AND staff_name = '팽철호' AND duty_area = ?
`);

const roleOf = name => {
  const r = db.prepare(`
    SELECT REPLACE(role_ko,' ','') AS r
    FROM staff
    WHERE company_code='combined' AND REPLACE(name_ko,' ','')=?
    LIMIT 1
  `).get(name);
  return r?.r || '감독';
};

reassign.forEach(r => {
  const role = roleOf(r.new_owner);
  const result = update.run(r.new_owner, role, r.new_backup, JSON.stringify([r.new_backup]), r.area);
  console.log(`   [${r.area.padEnd(22)}] → ${r.new_owner} (백업 ${r.new_backup})  ${result.changes ? '✓' : '(skip)'}`);
});

// ─────────────────────────────────────────────
// Phase 2 — BST 업무 데이터 적용
// ─────────────────────────────────────────────
console.log('\nPhase 2: BST 업무 데이터 적용');
db.exec(fs.readFileSync(BST_SQL, 'utf8'));
const bstCount = db.prepare("SELECT COUNT(*) AS n FROM duty_assignments WHERE team_code='BST'").get().n;
console.log(`   BST rows: ${bstCount}`);

// ─────────────────────────────────────────────
// 검증
// ─────────────────────────────────────────────
console.log('\n=== 검증: 회사 × 팀 매트릭스 ===');
const COMPANIES = ['combined','samjoo','doriko'];
const TEAMS = ['CMT','SQT','MTT','BST'];
for (const co of COMPANIES) {
  console.log(` ${co.toUpperCase()}`);
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
    console.log(`   ${t}: ${new Set(f.map(d=>d.staff_name)).size}명 / ${f.length}건 (필수 ${f.filter(x=>x.is_essential).length})`);
  }
}

console.log('\n=== SQT 인원별 (재배치 후) ===');
db.prepare("SELECT staff_name, COUNT(*) AS n, SUM(is_essential) AS ess FROM duty_assignments WHERE team_code='SQT' GROUP BY staff_name ORDER BY n DESC")
  .all().forEach(r => console.log(`  ${r.staff_name}: ${r.n}건 (필수 ${r.ess})`));

console.log('\n=== BST 인원별 ===');
db.prepare("SELECT staff_name, COUNT(*) AS n, SUM(is_essential) AS ess FROM duty_assignments WHERE team_code='BST' GROUP BY staff_name ORDER BY n DESC")
  .all().forEach(r => console.log(`  ${r.staff_name}: ${r.n}건 (필수 ${r.ess})`));

db.close();
console.log('\n✓ Migration complete');
