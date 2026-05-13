// ============================================================
// migrate-safety.js  ·  Apply seed_safety.sql to existing DB
// (no drop, idempotent)
// Run: node migrate-safety.js
// ============================================================
const fs = require('fs');
const path = require('path');
const Database = require('better-sqlite3');

const DB_PATH = path.resolve(__dirname, '..', 'db', 'orgchart.db');
const SAFETY  = path.resolve(__dirname, '..', 'db', 'seed_safety.sql');

const db = new Database(DB_PATH);

// vessels table: add columns only if missing
const vesselCols = db.prepare("PRAGMA table_info(vessels)").all().map(r => r.name);
if (!vesselCols.includes('safety_org_required')) {
  db.exec("ALTER TABLE vessels ADD COLUMN safety_org_required INTEGER DEFAULT 0");
  console.log('· vessels.safety_org_required added');
}
if (!vesselCols.includes('flag_category')) {
  db.exec("ALTER TABLE vessels ADD COLUMN flag_category TEXT");
  console.log('· vessels.flag_category added');
}

// Apply safety seed but skip ALTER (already handled above)
const sql = fs.readFileSync(SAFETY, 'utf8')
  .split('\n')
  .filter(line => !line.trim().startsWith('ALTER TABLE'))
  .join('\n');

db.exec(sql);
console.log('· seed_safety.sql applied');

// Verify
const cnt = {
  vessel_safety_org: db.prepare('SELECT COUNT(*) AS n FROM vessel_safety_org').get().n,
  eligible_vessels:  db.prepare('SELECT COUNT(*) AS n FROM vessels WHERE safety_org_required = 1').get().n
};
console.log('· Counts:', cnt);

const eligible = db.prepare(`
  SELECT imo, name, flag_category, ism_manager_code
  FROM vessels WHERE safety_org_required = 1
  ORDER BY flag_category DESC, no
`).all();
console.log('· Eligible vessels:');
eligible.forEach(v => console.log('   ', v.imo, v.name, '['+v.flag_category+']', '→', v.ism_manager_code));

db.close();
console.log('\n✓ Migration complete');
