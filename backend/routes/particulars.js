// ============================================================
// /api/particulars   ·  Vessel particulars (common fields)
// ============================================================
const express = require('express');
const db = require('../db');
const router = express.Router();

// GET /api/particulars            → all vessels + particulars joined
// GET /api/particulars/:imo       → single
// Optional filter: ?company=samjoo|doriko

router.get('/', (req, res) => {
  const co = req.query.company;
  // Check vessel_rightship existence
  const hasRS = db.prepare(`SELECT name FROM sqlite_master WHERE type='table' AND name='vessel_rightship'`).get();
  const rsJoin = hasRS ? `LEFT JOIN vessel_rightship r ON r.imo = v.imo` : '';
  const rsSel  = hasRS ? `, r.doc_company, r.commercial_manager, r.technical_manager,
                            r.commercial_operator, r.beneficial_owner, r.registered_owner_rs,
                            r.hull_type, r.statcode5, r.age, r.lead_sister_ship,
                            r.status AS rs_status` : '';
  const base = `
    SELECT v.imo, v.no, v.name AS code_name, v.type, v.built, v.flag AS short_flag,
           v.gt AS v_gt, v.dwt AS v_dwt, v.class AS v_class, v.ism_manager_code,
           p.* ${rsSel}
    FROM vessels v
    LEFT JOIN vessel_particulars p ON p.imo = v.imo
    ${rsJoin}
  `;
  const rows = (co && co !== 'combined')
    ? db.prepare(`${base} WHERE v.ism_manager_code = ? ORDER BY v.type DESC, v.no`).all(co)
    : db.prepare(`${base} ORDER BY v.type DESC, v.no`).all();
  res.json({ count: rows.length, vessels: rows });
});

router.get('/:imo', (req, res) => {
  const row = db.prepare(`
    SELECT v.no, v.name AS code_name, v.type, v.built, v.flag AS short_flag,
           v.gt AS v_gt, v.dwt AS v_dwt, v.class AS v_class, v.ism_manager_code,
           p.*
    FROM vessels v
    LEFT JOIN vessel_particulars p ON p.imo = v.imo
    WHERE v.imo = ?
  `).get(req.params.imo);
  if (!row) return res.status(404).json({ error: 'Not found' });
  res.json(row);
});

// Common field summary: which fields are filled across all vessels
router.get('/_meta/common-fields', (req, res) => {
  const cols = [
    'vessel_name','flag','port_of_registry','call_sign','official_no','mmsi',
    'owner','manager','operator','p_and_i','builder','built_year','keel_laid',
    'class_society','vessel_type','gt','nt','dwt','loa','lbp','breadth','depth',
    'draft_summer','draft_tropical','draft_winter','main_engine','service_speed','mcr',
    'equipment_no','lightship'
  ];
  const total = db.prepare('SELECT COUNT(*) AS n FROM vessel_particulars').get().n;
  const result = cols.map(c => {
    const filled = db.prepare(
      `SELECT COUNT(*) AS n FROM vessel_particulars WHERE ${c} IS NOT NULL AND ${c} <> ''`
    ).get().n;
    return { field: c, filled, total, ratio: total ? +(filled/total).toFixed(2) : 0 };
  });
  res.json({ total, fields: result });
});

module.exports = router;
