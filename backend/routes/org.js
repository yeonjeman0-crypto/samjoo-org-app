// ============================================================
// /api/companies/:code/org   ·  Hierarchical org chart
// ============================================================
const express = require('express');
const db = require('../db');
const router = express.Router({ mergeParams: true });

function contactProjection() {
  const hasContacts = db.prepare(`
    SELECT name FROM sqlite_master WHERE type='table' AND name='staff_contact'
  `).get();

  if (!hasContacts) {
    return {
      select: `,
        NULL AS contact_name_en,
        NULL AS contact_tel,
        NULL AS contact_mobile,
        NULL AS contact_email,
        NULL AS contact_responsibilities
      `,
      join: ''
    };
  }

  return {
    select: `,
      sc.staff_name_en AS contact_name_en,
      sc.tel AS contact_tel,
      sc.mobile AS contact_mobile,
      sc.email AS contact_email,
      sc.responsibilities AS contact_responsibilities
    `,
    join: `LEFT JOIN staff_contact sc ON sc.staff_name_ko = REPLACE(s.name_ko, ' ', '')`
  };
}

router.get('/', (req, res) => {
  const { code } = req.params;
  const company = db.prepare(`SELECT * FROM companies WHERE code = ?`).get(code);
  if (!company) return res.status(404).json({ error: 'Company not found' });
  const contacts = contactProjection();

  // CEO (level 1)
  const ceo = db.prepare(`
    SELECT s.* ${contacts.select}
    FROM staff s
    ${contacts.join}
    WHERE s.company_code = ? AND s.level = 1
    ORDER BY s.sort_order
  `).all(code);

  // Department heads (level 2)
  const deptHeads = db.prepare(`
    SELECT s.*, d.name_ko AS dept_name_ko, d.name_en AS dept_name_en
           ${contacts.select}
    FROM staff s
    LEFT JOIN departments d ON s.dept_code = d.code
    ${contacts.join}
    WHERE s.company_code = ? AND s.level = 2
    ORDER BY d.sort_order, s.sort_order
  `).all(code);

  // Teams + members
  const teams = db.prepare(`
    SELECT t.code, t.name_ko, t.name_en, t.color_token,
           t.department_code, t.sort_order
    FROM teams t
    WHERE EXISTS (SELECT 1 FROM staff s WHERE s.company_code = ? AND s.team_code = t.code)
    ORDER BY t.sort_order
  `).all(code);

  const members = db.prepare(`
    SELECT s.* ${contacts.select}
    FROM staff s
    ${contacts.join}
    WHERE s.company_code = ? AND s.team_code = ?
    ORDER BY s.is_leader DESC, s.sort_order
  `);

  const teamsOut = teams.map(t => ({
    ...t,
    members: members.all(code, t.code)
  }));

  res.json({
    company,
    ceo,
    department_heads: deptHeads,
    teams: teamsOut,
    counts: {
      staff: ceo.length + deptHeads.length + teamsOut.reduce((a, t) => a + t.members.length, 0),
      teams: teamsOut.length
    }
  });
});

module.exports = router;
