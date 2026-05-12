// ============================================================
// /api/companies
// ============================================================
const express = require('express');
const db = require('../db');
const router = express.Router();

// GET /api/companies  ·  List all companies with aggregated stats
router.get('/', (req, res) => {
  const rows = db.prepare(`
    SELECT c.code, c.name_ko, c.name_en, c.role_ko, c.role_en,
           c.color_primary, c.color_accent, c.sort_order
    FROM companies c
    ORDER BY c.sort_order
  `).all();

  const stats = db.prepare(`
    SELECT c.code AS company_code,
           (SELECT COUNT(*) FROM staff s WHERE s.company_code = c.code) AS staff_count,
           (SELECT COUNT(DISTINCT team_code) FROM staff s
              WHERE s.company_code = c.code AND s.team_code IS NOT NULL) AS teams_count
    FROM companies c
  `).all();

  const fleet = db.prepare(`
    SELECT ism_manager_code,
           COUNT(*) AS fleet_count,
           COALESCE(SUM(gt), 0)  AS total_gt,
           COALESCE(SUM(dwt),0)  AS total_dwt,
           SUM(CASE WHEN type='VC' THEN 1 ELSE 0 END) AS vc_count,
           SUM(CASE WHEN type='BC' THEN 1 ELSE 0 END) AS bc_count
    FROM vessels GROUP BY ism_manager_code
  `).all();

  const fleetByCo = Object.fromEntries(fleet.map(f => [f.ism_manager_code, f]));
  const statByCo  = Object.fromEntries(stats.map(s => [s.company_code, s]));

  // 'combined' aggregates from both samjoo+doriko
  const combinedFleet = {
    fleet_count: (fleetByCo.samjoo?.fleet_count || 0) + (fleetByCo.doriko?.fleet_count || 0),
    total_gt:    (fleetByCo.samjoo?.total_gt    || 0) + (fleetByCo.doriko?.total_gt    || 0),
    total_dwt:   (fleetByCo.samjoo?.total_dwt   || 0) + (fleetByCo.doriko?.total_dwt   || 0),
    vc_count:    (fleetByCo.samjoo?.vc_count    || 0) + (fleetByCo.doriko?.vc_count    || 0),
    bc_count:    (fleetByCo.samjoo?.bc_count    || 0) + (fleetByCo.doriko?.bc_count    || 0),
  };

  const data = rows.map(r => ({
    ...r,
    stats: {
      staff_count: statByCo[r.code]?.staff_count || 0,
      teams_count: statByCo[r.code]?.teams_count || 0,
      ...(r.code === 'combined' ? combinedFleet : (fleetByCo[r.code] || {
        fleet_count: 0, total_gt: 0, total_dwt: 0, vc_count: 0, bc_count: 0
      }))
    }
  }));

  res.json({ companies: data });
});

// GET /api/companies/:code  ·  Company detail (single)
router.get('/:code', (req, res) => {
  const c = db.prepare(`SELECT * FROM companies WHERE code = ?`).get(req.params.code);
  if (!c) return res.status(404).json({ error: 'Company not found' });
  res.json(c);
});

module.exports = router;
