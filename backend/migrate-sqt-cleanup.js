// ============================================================
// migrate-sqt-cleanup.js
//   · SQT 데이터 정합성 보정
//     - 노경수 role: 포트캡틴 → 감독선장 (조직도 일치)
//     - duty_area 내 \n 제거 → 한 줄로 정리 (슬래시 중복 표시 방지)
//   · Idempotent
// Run: node migrate-sqt-cleanup.js
// ============================================================
const path = require('path');
const { DatabaseSync } = require('node:sqlite');

const DB_PATH = path.resolve(__dirname, '..', 'db', 'orgchart.db');
const db = new DatabaseSync(DB_PATH);

console.log('· 노경수 SQT role 정정 (포트캡틴 → 감독선장)');
const r1 = db.prepare(`
  UPDATE duty_assignments
  SET role_ko = '감독선장'
  WHERE team_code = 'SQT' AND staff_name = '노경수' AND role_ko = '포트캡틴'
`).run();
console.log(`   updated rows: ${r1.changes}`);

console.log('· duty_area 줄바꿈 정리');
// SQLite 표준 함수만 사용 — \n 을 공백으로 치환 후 다중공백을 단일공백으로
const r2 = db.prepare(`
  UPDATE duty_assignments
  SET duty_area =
    TRIM(
      REPLACE(REPLACE(REPLACE(duty_area, char(10), ' '), char(13), ' '), '  ', ' ')
    )
  WHERE duty_area LIKE '%' || char(10) || '%' OR duty_area LIKE '%  %'
`).run();
console.log(`   updated rows: ${r2.changes}`);

// 두 번째 패스로 잔여 다중공백 제거
db.prepare(`
  UPDATE duty_assignments
  SET duty_area = REPLACE(duty_area, '  ', ' ')
  WHERE duty_area LIKE '%  %'
`).run();

// 슬래시 주변 공백 정리: "/ /" → "/"
db.prepare(`
  UPDATE duty_assignments
  SET duty_area = REPLACE(duty_area, '/ /', '/')
  WHERE duty_area LIKE '%/ /%'
`).run();

// 검증
console.log('\n· SQT 직무영역 (정리 후):');
db.prepare(`
  SELECT staff_name, role_ko, duty_area
  FROM duty_assignments
  WHERE team_code = 'SQT'
  ORDER BY sort_order
`).all().forEach(r => {
  console.log(`   ${r.staff_name.padEnd(5)} | ${(r.role_ko||'').padEnd(6)} | ${r.duty_area}`);
});

db.close();
console.log('\n✓ SQT cleanup migration complete');
