// ============================================================
// /api/safety  ·  Vessel Safety Organization (APP.6)
// 적용 대상: BBCHP + 한국적 (6척)
// ============================================================
const express = require('express');
const db = require('../db');
const router = express.Router();

function safetyProjection() {
  return `
    v.*,
    c.name_ko AS ism_name_ko,
    c.name_en AS ism_name_en,
    CASE WHEN v.safety_org_required = 1 THEN 1 ELSE 0 END AS safety_applicable,
    CASE WHEN v.safety_org_required = 1 THEN '적용' ELSE '해당 없음' END AS safety_status_ko,
    CASE
      WHEN v.flag_category = 'KOR' THEN 'KOREA FLAG'
      WHEN v.flag_category = 'BBCHP' THEN 'BBCHP'
      ELSE 'KOR/BBCHP 대상 아님'
    END AS safety_reason_ko
  `;
}

// GET /api/safety/vessels                     → 회사별 선박 안전조직 적용/해당없음 목록
// GET /api/safety/vessels/:imo                → 단일 선박 안전 조직
router.get('/vessels', (req, res) => {
  const company = req.query.company || 'combined';
  const companyRow = db.prepare(`SELECT * FROM companies WHERE code = ?`).get(company);
  if (!companyRow) return res.status(404).json({ error: 'Company not found' });

  const where = company === 'combined' ? '' : 'WHERE v.ism_manager_code = ?';
  const stmt = db.prepare(`
    SELECT ${safetyProjection()}
    FROM vessels v
    LEFT JOIN companies c ON c.code = v.ism_manager_code
    ${where}
    ORDER BY v.type DESC, v.no
  `);
  const vessels = company === 'combined' ? stmt.all() : stmt.all(company);
  const applicable = vessels.filter(v => v.safety_applicable);
  const notApplicable = vessels.filter(v => !v.safety_applicable);

  res.json({
    company: companyRow,
    count: vessels.length,
    summary: {
      total: vessels.length,
      applicable: applicable.length,
      not_applicable: notApplicable.length
    },
    by_category: {
      KOR:   applicable.filter(v => v.flag_category === 'KOR').length,
      BBCHP: applicable.filter(v => v.flag_category === 'BBCHP').length,
      NA:    notApplicable.length
    },
    vessels
  });
});

// 역할별 법령 근거 매핑 (선원법·산업안전보건법·중처법·PR-13 APP.6)
const ROLE_LEGAL = {
  SHM: {
    statute: '산업안전보건법 제62조, 시행령 제52조 / 중대재해처벌법 시행령 제4조',
    procedure: 'PR-23 매뉴얼 / PR-13 APP.6 §1.2',
    note: '육상 안전보건관리자 — 회사 본부장(DP)이 겸임. 위험성평가·예산·교육·비용부담 책임.'
  },
  MASTER: {
    statute: '선원법 제6조 (선장의 직무 권한) / 선원법 제79조 (사용자등의 안전보건 조치)',
    procedure: 'PR-13 APP.6 §1.3.1 / SMS Manual',
    note: '선내 최고책임자. 작업중지(SWA) 최종 승인권, 사고 보고 의무.'
  },
  SAFETY_OFFICER: {
    statute: '선원법 제79조 / 선원법 시행규칙 제56조의2 (안전담당사관)',
    procedure: 'PR-13 APP.6 §1.3.2',
    note: '기관장 또는 승선경력 2년 이상 기관사를 선장이 임명. 고위험작업 현장감독·작업중지 권한.'
  },
  HEALTH_OFFICER: {
    statute: '선원법 제86조 (의료관리자) / 선원법 시행규칙 제57조',
    procedure: 'PR-13 APP.6 §1.3.3 / PR-14 (선원 건강관리)',
    note: '의료관리자 또는 선장 겸임. 응급환자 초기대응·의약품 관리·전염병 예방.'
  },
  SAFETY_REP: {
    statute: '선원법 제79조의2 (선내안전위원회) / 산업안전보건법 제24조 (산업안전보건위원회)',
    procedure: 'PR-13 APP.6 §1.3.4',
    note: '일반 선원 중 공정·자유로운 절차로 선출. 선원 의견 수렴·전달, 위원회 참석.'
  }
};

const SAFETY_LEGAL_BASIS = {
  scope: {
    ko: '이 기준은 대한민국 선원법의 적용을 받는 선박, 대한민국 국적의 국제항해 외항선박과 해당 선박에 승무하는 선원, 선박소유자 및 관련 육상조직에 적용한다.',
    en: 'This standard applies to Korean-flagged ocean-going vessels engaged in international voyages that are subject to the Seafarers Act of the Republic of Korea, and to the crew members on board such vessels, the shipowner, and the related shore-based organization.'
  },
  basis_note: {
    ko: '이 기준은 다음 각 호의 법령 및 국제기준을 근거로 하여 구성된다.',
    en: 'This standard is based on the following laws and international standards.'
  },
  statutes: [
    { label: '1) 선내 안전·보건 및 사고예방 기준',
      label_en: 'Onboard Safety, Health and Incident Prevention Standards',
      summary: '해양수산부 고시 (MOF Notification) — 한국적 외항선박 선내 안전·보건 조직 운영기준' },
    { label: '2) 선원법 및 관련 시행규칙',
      label_en: 'Seafarers Act and Related Enforcement Regulations',
      summary: '선원법 제79조 (안전·보건 조치) / 제79조의2 (선내안전위원회) / 시행규칙 제56조의2 (안전담당사관)' },
    { label: '3) 국제안전관리규약 (ISM Code)',
      label_en: 'International Safety Management Code',
      summary: 'SOLAS Ch.IX — 회사·선박의 안전관리시스템(SMS) 수립·유지, DOC/SMC 인증' },
    { label: '4) 안전관리 / Safety Management',
      label_en: 'Safety Management',
      summary: '중대재해처벌법 시행령 제4조 제8호 — 중대산업재해 대응 매뉴얼 마련·점검 / 산업안전보건법 제62조 (도급사업 안전보건관리책임자)' }
  ],
  company_procedure: {
    code: 'PR-13 APP.6',
    title: '선내 안전보건 조직 운영절차 / Onboard Safety & Health Organization Procedure',
    scope: 'BBCHP + 한국적 선박 (6척) · 선장(위원장) · 안전사관(기관장) · 보건사관(선장 겸임) · 안전대표(선원 선출) + SHM(육상)',
    note: '선내 4개 직책 + 육상 안전보건관리자(SHM) 체계. 분기 1회 이상 선내안전위원회 소집, 회의록 5년 이상 보관.'
  }
};

router.get('/vessels/:imo', (req, res) => {
  const vessel = db.prepare(`
    SELECT v.*, c.name_ko AS ism_name_ko, c.name_en AS ism_name_en
    FROM vessels v
    LEFT JOIN companies c ON c.code = v.ism_manager_code
    WHERE v.imo = ?
  `).get(req.params.imo);

  if (!vessel) return res.status(404).json({ error: 'Vessel not found' });
  if (!vessel.safety_org_required) {
    return res.json({
      vessel: {
        ...vessel,
        safety_applicable: 0,
        safety_status_ko: '해당 없음',
        safety_reason_ko: 'KOR/BBCHP 대상 아님'
      },
      roles: [],
      committee: null,
      legal_basis: SAFETY_LEGAL_BASIS,
      message: 'KOR/BBCHP 대상 선박이 아니므로 선박 안전조직 적용 대상이 아닙니다.'
    });
  }

  const rolesRaw = db.prepare(`
    SELECT * FROM vessel_safety_org
    WHERE vessel_imo = ?
    ORDER BY sort_order
  `).all(req.params.imo);

  const roles = rolesRaw.map(r => ({
    ...r,
    legal: ROLE_LEGAL[r.role_code] || null
  }));

  res.json({
    vessel: {
      ...vessel,
      safety_applicable: 1,
      safety_status_ko: '적용',
      safety_reason_ko: vessel.flag_category === 'KOR' ? 'KOREA FLAG' : 'BBCHP'
    },
    roles,
    legal_basis: SAFETY_LEGAL_BASIS,
    committee: {
      ko: '선내안전위원회 (Onboard Safety Committee)',
      en: 'Onboard Safety Committee',
      legal_basis: '선원법 제79조의2 / PR-13 APP.6 §2',
      members: ['선장 (위원장)', '안전사관', '보건사관', '안전대표'],
      schedule_ko: '분기 1회 이상 소집',
      schedule_en: 'At least quarterly',
      retention_ko: '회의록 5년 이상 보관 (선원법 시행규칙)',
      duties_ko: '안전보건 정책 심의, 위험요인 개선조치 검토, 사고 조사결과 검토, 교육·훈련 계획 승인'
    }
  });
});

module.exports = router;
