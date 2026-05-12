// ============================================================
// init-db.js  ·  Build SQLite DB from schema.sql + seed.sql
// ============================================================
const fs = require('fs');
const path = require('path');
const { DatabaseSync } = require('node:sqlite');

const DB_PATH = path.resolve(__dirname, '..', 'db', 'orgchart.db');
const SQL_DIR = path.resolve(__dirname, '..', 'db');

const FILES = [
  ['schema.sql',              'Schema'],
  ['seed.sql',                'Seed'],
  ['seed_extra.sql',          'Extra (particulars + duties)'],
  ['seed_safety.sql',         'Vessel safety org'],
  ['seed_mtt.sql',            'MTT duty assignments'],
  ['seed_supervisors.sql',    'Vessel supervisor'],
  ['seed_rightship.sql',      'RightShip'],
  ['seed_gapfill.sql',        'Gap-fill'],
  ['seed_contacts.sql',       'Contact list (staff_contact)'],
  ['seed_shore_safety.sql',   'Shore safety org (SAPA / 중처법)'],
  ['seed_normalize.sql',      'Particulars normalize']
];

if (fs.existsSync(DB_PATH)) { fs.unlinkSync(DB_PATH); console.log('· Old DB removed'); }
const db = new DatabaseSync(DB_PATH);
db.exec('PRAGMA journal_mode = WAL');

for (const [name, label] of FILES) {
  const p = path.join(SQL_DIR, name);
  if (!fs.existsSync(p)) { console.log('· (skip) ' + name); continue; }
  db.exec(fs.readFileSync(p, 'utf8'));
  console.log('· ' + label + ' applied');
}

const tableExists = n => !!db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name=?").get(n);
const cnt = (t) => tableExists(t) ? db.prepare(`SELECT COUNT(*) AS n FROM ${t}`).get().n : '-';
console.log('· Row counts:', {
  companies: cnt('companies'),
  teams: cnt('teams'),
  staff: cnt('staff'),
  vessels: cnt('vessels'),
  vessel_particulars: cnt('vessel_particulars'),
  duty_assignments: cnt('duty_assignments'),
  vessel_safety_org: cnt('vessel_safety_org'),
  vessel_supervisor: cnt('vessel_supervisor'),
  staff_contact: cnt('staff_contact'),
  shore_safety_roles: cnt('shore_safety_roles'),
  shore_safety_requirements: cnt('shore_safety_requirements')
});
db.close();
console.log('\n✓ DB initialized:', DB_PATH);

// PR-13 APP.6 보강 (SHM 행, has_swa 플래그, qualification 강화)
console.log('\n--- Applying PR-13 APP.6 migration ---');
require('./migrate-safety-app6.js');
