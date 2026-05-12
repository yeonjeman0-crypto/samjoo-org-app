// ============================================================
// /api/staff       · staff profile (vessels + duties + contact)
// ============================================================
const express = require('express');
const db = require('../db');
const router = express.Router();

const norm = s => String(s || '').replace(/\s+/g, '');

function findStaff(rawName) {
  const key = norm(rawName);
  return db.prepare(`
    SELECT s.*,
           d.name_ko AS dept_name_ko, d.name_en AS dept_name_en,
           t.name_ko AS team_name_ko, t.name_en AS team_name_en
    FROM staff s
    LEFT JOIN departments d ON s.dept_code = d.code
    LEFT JOIN teams       t ON s.team_code = t.code
    WHERE REPLACE(s.name_ko, ' ', '') = ?
    ORDER BY CASE s.company_code WHEN 'combined' THEN 0 ELSE 1 END
    LIMIT 1
  `).get(key);
}

router.get('/profile/:name', (req, res) => {
  const staffRow = findStaff(req.params.name);
  if (!staffRow) return res.status(404).json({ error: 'Staff not found', name: req.params.name });

  // Contact card (if available)
  const hasContacts = db.prepare(`
    SELECT name FROM sqlite_master WHERE type='table' AND name='staff_contact'
  `).get();
  let contact = null;
  if (hasContacts) {
    contact = db.prepare(`
      SELECT * FROM staff_contact
      WHERE REPLACE(staff_name_ko, ' ', '') = ?
    `).get(norm(staffRow.name_ko));
  }

  // Vessels supervised — primary 책임 선박만
  const hasSupTable = db.prepare(`
    SELECT name FROM sqlite_master WHERE type='table' AND name='vessel_supervisor'
  `).get();
  let vesselsPrimary = [];
  if (hasSupTable) {
    vesselsPrimary = db.prepare(`
      SELECT v.imo, v.no, v.name, v.type, v.built, v.flag, v.gt, v.dwt, v.class,
             v.ism_manager_code
      FROM vessel_supervisor vs
      JOIN vessels v ON v.imo = vs.vessel_imo
      WHERE REPLACE(vs.primary_supt, ' ', '') = ?
      ORDER BY v.no
    `).all(norm(staffRow.name_ko));
  }

  // Duties — combined assignments (the canonical org duty list)
  const duties = db.prepare(`
    SELECT d.*, t.name_ko AS team_name_ko, t.name_en AS team_name_en
    FROM duty_assignments d
    LEFT JOIN teams t ON t.code = d.team_code
    WHERE REPLACE(d.staff_name, ' ', '') = ?
    ORDER BY d.team_code, d.sort_order
  `).all(norm(staffRow.name_ko));

  // SAPA role (if person is assigned in shore_safety_roles)
  const hasShore = db.prepare(`
    SELECT name FROM sqlite_master WHERE type='table' AND name='shore_safety_roles'
  `).get();
  let sapaRoles = [];
  if (hasShore) {
    sapaRoles = db.prepare(`
      SELECT * FROM shore_safety_roles
      WHERE REPLACE(owner_name, ' ', '') = ?
      ORDER BY company_code, sort_order
    `).all(norm(staffRow.name_ko));
  }

  res.json({
    staff: staffRow,
    contact,
    vessels: {
      primary: vesselsPrimary,
      count_primary: vesselsPrimary.length
    },
    duties,
    sapa_roles: sapaRoles,
    counts: {
      duties: duties.length,
      vessels_primary: vesselsPrimary.length
    }
  });
});

module.exports = router;
