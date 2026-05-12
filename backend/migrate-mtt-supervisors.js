// ============================================================
// migrate-mtt-supervisors.js
//   · MTT duty data + vessel_supervisor table
//   · Idempotent (no DB unlink)
// Run: node migrate-mtt-supervisors.js
// ============================================================
const fs = require('fs');
const path = require('path');
const { DatabaseSync } = require('node:sqlite');

const DB_PATH    = path.resolve(__dirname, '..', 'db', 'orgchart.db');
const MTT_SQL    = path.resolve(__dirname, '..', 'db', 'seed_mtt.sql');
const SUPER_SQL  = path.resolve(__dirname, '..', 'db', 'seed_supervisors.sql');

const db = new DatabaseSync(DB_PATH);

console.log('· Applying MTT duty assignments…');
db.exec(fs.readFileSync(MTT_SQL, 'utf8'));

console.log('· Applying vessel_supervisor…');
db.exec(fs.readFileSync(SUPER_SQL, 'utf8'));

const cnt = {
  mtt_duties:        db.prepare("SELECT COUNT(*) AS n FROM duty_assignments WHERE team_code='MTT'").get().n,
  vessel_supervisor: db.prepare("SELECT COUNT(*) AS n FROM vessel_supervisor").get().n
};
console.log('· Counts:', cnt);

console.log('· Vessels with supervisor:');
const list = db.prepare(`
  SELECT v.imo, v.name, s.primary_supt, s.backup_supt
  FROM vessels v
  LEFT JOIN vessel_supervisor s ON s.vessel_imo = v.imo
  ORDER BY v.no
`).all();
list.forEach(r => console.log(`   ${r.imo}  ${r.name.padEnd(18)} → ${r.primary_supt || '(미배정)'}` +
  (r.backup_supt ? `  [백업: ${r.backup_supt}]` : '')));

db.close();
console.log('\n✓ Migration complete');
