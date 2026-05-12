// ============================================================
// /api/companies/:code/fleet   ·  Managed fleet list
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
        NULL AS primary_supt_name_en,
        NULL AS primary_supt_tel,
        NULL AS primary_supt_mobile,
        NULL AS primary_supt_email,
        NULL AS primary_supt_responsibilities
      `,
      join: ''
    };
  }

  return {
    select: `,
      sc.staff_name_en AS primary_supt_name_en,
      sc.tel AS primary_supt_tel,
      sc.mobile AS primary_supt_mobile,
      sc.email AS primary_supt_email,
      sc.responsibilities AS primary_supt_responsibilities
    `,
    join: `LEFT JOIN staff_contact sc ON sc.staff_name_ko = s.primary_supt`
  };
}

// 선주사 매핑 (4개사: DAEBO L&S / SAMJOO MARITIME / GMT / WOORI SHIPPING)
const VESSEL_OWNER = {
  '8606056': { code: 'samjoo', name: 'SAMJOO MARITIME' },  // GMT ASTRO → 삼주
  '9021332': { code: 'samjoo', name: 'SAMJOO MARITIME' },
  '9053505': { code: 'samjoo', name: 'SAMJOO MARITIME' },
  '9073701': { code: 'samjoo', name: 'SAMJOO MARITIME' },
  '9166704': { code: 'samjoo', name: 'SAMJOO MARITIME' },
  '9177430': { code: 'samjoo', name: 'SAMJOO MARITIME' },
  '9445394': { code: 'gmt',    name: 'GMT' },              // G POSEIDON → GMT
  '9310678': { code: 'woori',  name: 'WOORI SHIPPING' },
  '9418729': { code: 'samjoo', name: 'SAMJOO MARITIME' },
  '9478511': { code: 'samjoo', name: 'SAMJOO MARITIME' },
  '9304538': { code: 'samjoo', name: 'SAMJOO MARITIME' },
  '9610561': { code: 'daebo',  name: 'DAEBO L&S' },
  '9710517': { code: 'daebo',  name: 'DAEBO L&S' }         // BT TREVIA → 대보
};

router.get('/', (req, res) => {
  const { code } = req.params;
  const company = db.prepare(`SELECT * FROM companies WHERE code = ?`).get(code);
  if (!company) return res.status(404).json({ error: 'Company not found' });
  const contacts = contactProjection();

  const baseSelect = `
    SELECT v.*,
           c.name_ko AS ism_name_ko, c.name_en AS ism_name_en,
           s.primary_supt
           ${contacts.select}
    FROM vessels v
    LEFT JOIN companies c          ON c.code = v.ism_manager_code
    LEFT JOIN vessel_supervisor s  ON s.vessel_imo = v.imo
    ${contacts.join}
  `;
  const rawVessels = (code === 'combined')
    ? db.prepare(`${baseSelect} ORDER BY v.type DESC, v.no`).all()
    : db.prepare(`${baseSelect} WHERE v.ism_manager_code = ? ORDER BY v.type DESC, v.no`).all(code);

  // 선령(age) + 선주(owner) 부착
  const currentYear = new Date().getFullYear();
  const vessels = rawVessels.map(v => ({
    ...v,
    age: v.built ? currentYear - Number(v.built) : null,
    owner: VESSEL_OWNER[v.imo] || { code: 'other', name: '-' }
  }));

  // Group by type
  const vc = vessels.filter(v => v.type === 'VC');
  const bc = vessels.filter(v => v.type === 'BC');

  // 선주별 집계
  const byOwner = vessels.reduce((acc, v) => {
    const k = v.owner.code;
    if (!acc[k]) acc[k] = { code: k, name: v.owner.name, count: 0 };
    acc[k].count += 1;
    return acc;
  }, {});

  const summary = {
    total:     vessels.length,
    vc_count:  vc.length,
    bc_count:  bc.length,
    total_gt:  vessels.reduce((a, v) => a + (v.gt  || 0), 0),
    total_dwt: vessels.reduce((a, v) => a + (v.dwt || 0), 0),
    by_owner:  Object.values(byOwner)
  };

  res.json({
    company,
    summary,
    groups: [
      { type: 'VC', name_ko: '자동차 운반선', name_en: 'VEHICLES CARRIER', count: vc.length, vessels: vc },
      { type: 'BC', name_ko: '벌 크 선',     name_en: 'BULK CARRIER',     count: bc.length, vessels: bc }
    ].filter(g => g.count > 0)
  });
});

module.exports = router;
