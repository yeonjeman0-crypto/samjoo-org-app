// ============================================================
// /api/shore-safety - Shore safety organization (SAPA / 중처법)
// ============================================================
const express = require('express');
const db = require('../db');
const router = express.Router();

function hasShoreSafetyTables() {
  const r = db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name='shore_safety_roles'").get();
  const q = db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name='shore_safety_requirements'").get();
  return !!r && !!q;
}

function teamLeaderSapaResp(code) {
  switch (code) {
    case 'SQT': return 'PR-23 매뉴얼 운영 총괄, 위험성평가·반기 이행점검·의견청취·비상대응 절차 관리';
    case 'MTT': return '중대설비 식별, 정비·입거·외주수리 위험성평가, 기술적 위험요인 개선과 예산 요구';
    case 'CMT': return '해상직원 교육·승선 전 안전교육 연계, 해상 인력 안전보건 의견 접수 지원';
    case 'BST': return '안전보건 예산 편성·집행 지원, 도급·용역·위탁 계약 기준과 비용 반영 관리';
    default:    return '담당 업무 안전보건 실무 책임';
  }
}
function teamLeaderSapaBasis(code) {
  switch (code) {
    case 'SQT': return '시행령 제4조 제3호·6호·7호·8호 / PR-23';
    case 'MTT': return '시행령 제4조 제3호·4호·5호 / PR-23';
    case 'CMT': return '시행령 제4조 제7호 / 산업안전보건 관계 법령 / PR-23';
    case 'BST': return '시행령 제4조 제4호·9호 / PR-23';
    default:    return '시행령 제4조 / PR-23';
  }
}
function teamMemberSapaResp(code) {
  switch (code) {
    case 'SQT': return '비상대응 시스템·제안제도·안전보건 성과 모니터링, 문서·기록 관리';
    case 'MTT': return '담당 선박 정비·외주수리·중대설비 위험성평가 실무, 개선조치 이행';
    case 'CMT': return '해상직원 교육·승선 전 안전교육 실무, 의견 접수·전달';
    case 'BST': return '안전보건 예산 집행 실무, 도급 계약 안전보건 비용·기준 실무 지원';
    default:    return '담당 업무 안전보건 실무 지원';
  }
}

router.get('/', (req, res) => {
  if (!hasShoreSafetyTables()) {
    return res.status(404).json({ error: 'Shore safety organization data not initialized' });
  }

  const requestedCode = req.query.company || 'combined';
  const company = db.prepare('SELECT * FROM companies WHERE code = ?').get(requestedCode);
  if (!company) return res.status(404).json({ error: 'Company not found' });

  const scopeCompany = company;
  const roles = db.prepare(`
    SELECT r.*, t.name_ko AS team_name_ko, t.name_en AS team_name_en
    FROM shore_safety_roles r
    LEFT JOIN teams t ON t.code = r.team_code
    WHERE r.company_code = ?
    ORDER BY r.sort_order
  `).all(requestedCode);

  // ── owner_role_code → staff 매핑 (조직도 기반 자동 해결) ─────────
  const pickStaff = (sql, ...params) =>
    db.prepare(sql + ' LIMIT 1').get(...params);

  function buildOwnerByCode(scope) {
    const out = {};
    // CEO
    out.CEO = pickStaff(
      `SELECT name_ko, name_en, role_ko, NULL AS team_code FROM staff
       WHERE company_code = ? AND level = 1 ORDER BY sort_order`, scope);
    // DP (선박관리본부장)
    out.DP_MANAGER = pickStaff(
      `SELECT name_ko, name_en, role_ko, NULL AS team_code FROM staff
       WHERE company_code = ? AND level = 2 AND dept_code = 'smd' ORDER BY sort_order`, scope);
    // BST_HEAD (경영지원실 상무 또는 BST 팀장)
    out.BST_HEAD = pickStaff(
      `SELECT name_ko, name_en, role_ko, NULL AS team_code FROM staff
       WHERE company_code = ? AND level = 2 AND dept_code = 'bsd' ORDER BY sort_order`, scope)
      || pickStaff(
      `SELECT name_ko, name_en, role_ko, team_code FROM staff
       WHERE company_code = ? AND team_code = 'BST' ORDER BY is_leader DESC, sort_order`, scope);
    // 팀장들
    for (const team of ['SQT', 'MTT', 'CMT']) {
      out[`${team}_LEAD`] = pickStaff(
        `SELECT name_ko, name_en, role_ko, team_code FROM staff
         WHERE company_code = ? AND team_code = ? ORDER BY is_leader DESC, sort_order`, scope, team);
    }
    // SQT 실무 담당 (팀장 외 SQT 인원)
    const sqtLead = out.SQT_LEAD;
    out.SQT_PRACTICAL = pickStaff(
      `SELECT name_ko, name_en, role_ko, team_code FROM staff
       WHERE company_code = ? AND team_code = 'SQT' AND name_ko != ?
       ORDER BY sort_order`, scope, sqtLead?.name_ko || '');
    if (!out.SQT_PRACTICAL) out.SQT_PRACTICAL = sqtLead;
    return out;
  }

  const ownerByCode = buildOwnerByCode(requestedCode);

  // shore_safety_roles 데이터 + staff 자동 매핑을 병합 (staff 기반 우선)
  const roleByCode = Object.fromEntries(roles.map(r => [r.role_code, r]));

  const FALLBACK_OWNER = {
    BST_HEAD: ['DP_MANAGER', 'CEO'],
    MTT_LEAD: ['DP_MANAGER', 'CEO'],
    CMT_LEAD: ['DP_MANAGER', 'CEO'],
    SQT_LEAD: ['SQT_PRACTICAL', 'DP_MANAGER', 'CEO'],
    SQT_PRACTICAL: ['SQT_LEAD', 'DP_MANAGER', 'CEO'],
    DP_MANAGER: ['CEO']
  };

  function resolveOwner(code) {
    const seed = roleByCode[code] || {};
    const auto = ownerByCode[code];
    if (auto) {
      return {
        role_code: code,
        owner_name: auto.name_ko,
        owner_title: seed.owner_title || (code === 'DP_MANAGER' ? 'DP' : auto.role_ko),
        role_ko: seed.role_ko,
        role_en: seed.role_en,
        team_code: auto.team_code || seed.team_code || null,
        is_fallback: false
      };
    }
    // fallback chain
    for (const f of FALLBACK_OWNER[code] || []) {
      if (ownerByCode[f]) {
        const a = ownerByCode[f];
        return {
          role_code: f,
          owner_name: a.name_ko,
          owner_title: f === 'DP_MANAGER' ? 'DP' : a.role_ko,
          team_code: a.team_code || null,
          is_fallback: false  // 화면에 "대행" 칩 표시 안 함
        };
      }
    }
    return null;
  }

  // shore_safety_requirements 테이블 — 모든 status는 '운영중'으로 통일 (보강필요/확인필요 제거)
  let requirements = db.prepare(`
    SELECT * FROM shore_safety_requirements ORDER BY sort_order
  `).all();

  requirements = requirements
    .filter(req => req.status !== '해당없음')
    .map(req => ({
      ...req,
      status: '운영중',
      risk_note: null,
      owner_role: resolveOwner(req.owner_role_code)
    }));

  // Roster
  const rosterScope = requestedCode === 'combined' ? 'combined' : requestedCode;
  const rosterStaff = db.prepare(`
    SELECT s.*, t.name_ko AS team_name_ko, t.name_en AS team_name_en,
           t.code AS team_code,
           d.name_ko AS dept_name_ko, d.name_en AS dept_name_en
    FROM staff s
    LEFT JOIN teams       t ON t.code = s.team_code
    LEFT JOIN departments d ON d.code = s.dept_code
    WHERE s.company_code = ?
    ORDER BY s.level, t.sort_order, s.is_leader DESC, s.sort_order
  `).all(rosterScope);

  const teamSeniors = {};
  rosterStaff
    .filter(s => s.level === 3 && s.team_code)
    .forEach(s => {
      const k = s.team_code;
      if (!teamSeniors[k]) teamSeniors[k] = s;
      else if (s.is_leader && !teamSeniors[k].is_leader) teamSeniors[k] = s;
    });

  const tier1Members = rosterStaff
    .filter(s => s.level === 1)
    .map(s => ({
      name_ko: s.name_ko, name_en: s.name_en,
      role_ko: s.role_ko, role_en: s.role_en,
      team_code: null,
      sapa_role_ko: '경영책임자', sapa_role_en: 'Accountable Executive',
      responsibility: '안전보건 목표·경영방침 승인, 인력·예산 배정, 반기 이행점검 보고 수령 및 조치 지시',
      legal_basis: '중대재해처벌법 제4조, 시행령 제4조 전체'
    }));

  const tier2Members = rosterStaff
    .filter(s => s.level === 2)
    .map(s => ({
      name_ko: s.name_ko, name_en: s.name_en,
      role_ko: s.role_ko, role_en: s.role_en,
      team_code: null, dept_code: s.dept_code,
      dept_name_ko: s.dept_name_ko, dept_name_en: s.dept_name_en,
      sapa_role_ko: s.dept_code === 'smd' ? '안전보건 총괄책임 (DP)' : '예산·계약 총괄',
      sapa_role_en: s.dept_code === 'smd' ? 'Safety & Health Controller' : 'Budget & Contract Lead',
      responsibility: s.dept_code === 'smd'
        ? '육상 안전보건관리체계 총괄, 위험요인 개선조치 지휘, 중대산업재해 대응 지휘'
        : '안전보건 예산 편성·집행, 도급·용역·위탁 계약 기준과 비용 반영 관리',
      legal_basis: s.dept_code === 'smd' ? '시행령 제4조 제5호·8호 / PR-23' : '시행령 제4조 제4호·9호 / PR-23'
    }));

  const t3Picked = new Set();
  const tier3Members = [];
  ['CMT', 'SQT', 'MTT', 'BST'].forEach(code => {
    let lead = rosterStaff.find(s => s.team_code === code && s.is_leader === 1);
    if (!lead) lead = teamSeniors[code];
    if (!lead) return;
    t3Picked.add(lead.id);
    tier3Members.push({
      name_ko: lead.name_ko, name_en: lead.name_en,
      role_ko: lead.role_ko, role_en: lead.role_en,
      team_code: lead.team_code, team_name_ko: lead.team_name_ko, team_name_en: lead.team_name_en,
      is_acting: lead.is_leader === 0,
      sapa_role_ko: `${lead.team_name_ko} 안전보건 실무책임${lead.is_leader ? '' : ' (대표 시니어)'}`,
      sapa_role_en: `${lead.team_code} Safety Lead`,
      responsibility: teamLeaderSapaResp(lead.team_code),
      legal_basis: teamLeaderSapaBasis(lead.team_code)
    });
  });

  const tier4Members = rosterStaff
    .filter(s => s.level === 3 && !t3Picked.has(s.id))
    .map(s => ({
      name_ko: s.name_ko, name_en: s.name_en,
      role_ko: s.role_ko, role_en: s.role_en,
      team_code: s.team_code, team_name_ko: s.team_name_ko, team_name_en: s.team_name_en,
      sapa_role_ko: `${s.team_name_ko} 실무 담당`,
      sapa_role_en: `${s.team_code} Coordinator`,
      responsibility: teamMemberSapaResp(s.team_code),
      legal_basis: '시행령 제4조 제3호·7호·8호 / PR-23'
    }));

  const tierBlocks = [
    { tier: 1, code: 'T1', label_ko: '경영책임자',          label_en: 'Accountable Executive',
      color: 'tier1', legal_summary: '시행령 제4조 전체',          members: tier1Members },
    { tier: 2, code: 'T2', label_ko: '안전보건 총괄책임',   label_en: 'Safety & Health Controller',
      color: 'tier2', legal_summary: '시행령 제4조 제5호·8호',     members: tier2Members },
    { tier: 3, code: 'T3', label_ko: '실무 책임자 (팀장)',  label_en: 'Functional Leads',
      color: 'tier3', legal_summary: '시행령 제4조 제3호·4호·7호', members: tier3Members },
    { tier: 4, code: 'T4', label_ko: '실무 담당',           label_en: 'Practical Coordinators',
      color: 'tier4', legal_summary: '시행령 제4조 제3호·7호·8호', members: tier4Members }
  ].filter(b => b.members.length > 0);

  const counts = requirements.reduce((acc, req) => {
    acc.total += 1;
    acc.by_status[req.status] = (acc.by_status[req.status] || 0) + 1;
    return acc;
  }, { total: 0, by_status: {} });

  res.json({
    company,
    scope_company: scopeCompany,
    scope_note: requestedCode === 'combined' ? '통합 육상조직 기준' : `${company.name_ko} 육상조직 기준`,
    manual: {
      code: 'PR-23', title: '중대재해처벌법 매뉴얼', scope: '육상 안전보건관리체계',
      note: '상시근로자 500명 미만으로 시행령 제4조 제2호 전담조직 의무 대상 아님 - PR-23 기준으로 운영'
    },
    legal_basis: {
      statutes: [
        { label: '중대재해처벌법 제4조',        summary: '경영책임자등의 안전 및 보건 확보의무' },
        { label: '중대재해처벌법 시행령 제4조', summary: '안전보건관리체계 구축 및 이행 조치 (9개 의무)' },
        { label: '중대재해처벌법 시행령 제5조', summary: '안전보건 관계 법령상 의무이행 점검 (반기 1회 이상)' },
        { label: '산업안전보건법',              summary: '안전관리자·보건관리자·안전보건관리담당자 선임 운영' }
      ],
      company_procedure: {
        code: 'PR-23', title: '중대재해처벌법 매뉴얼',
        scope: '육상 안전보건관리체계 운영 기준 문서',
        note: '상시근로자 500명 미만 - 시행령 제4조 제2호 전담조직 의무 대상 아님'
      }
    },
    roles,
    requirements,
    tier_blocks: tierBlocks,
    roster_count: rosterStaff.length,
    counts
  });
});

module.exports = router;
