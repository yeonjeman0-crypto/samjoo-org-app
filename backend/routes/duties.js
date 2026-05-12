// ============================================================
// /api/duties   ·  Team duty assignments
// ============================================================
const express = require('express');
const db = require('../db');
const router = express.Router();

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
    join: `LEFT JOIN staff_contact sc ON sc.staff_name_ko = d.staff_name`
  };
}

function normalizeBackupNames(row) {
  if (row.backup_names && String(row.backup_names).trim()) return row;

  const names = String(row.backup_name || '')
    .split(/\r?\n|[,;]/)
    .map(name => name.trim())
    .filter(Boolean);

  return {
    ...row,
    backup_names: names.length ? JSON.stringify(names) : row.backup_names
  };
}

function normalizeRows(rows) {
  return rows.map(normalizeBackupNames);
}

// GET /api/duties            → all
// GET /api/duties?team=SQT   → filter by team
// GET /api/duties/:team      → by team (path)
// GET /api/duties/by-staff/:name  → by staff name

router.get('/', (req, res) => {
  const { team } = req.query;
  const contacts = contactProjection();
  let rows;
  if (team) {
    rows = db.prepare(`
      SELECT d.*, t.name_ko AS team_name_ko, t.name_en AS team_name_en
             ${contacts.select}
      FROM duty_assignments d
      LEFT JOIN teams t ON t.code = d.team_code
      ${contacts.join}
      WHERE d.team_code = ?
      ORDER BY d.sort_order
    `).all(team);
  } else {
    rows = db.prepare(`
      SELECT d.*, t.name_ko AS team_name_ko, t.name_en AS team_name_en
             ${contacts.select}
      FROM duty_assignments d
      LEFT JOIN teams t ON t.code = d.team_code
      ${contacts.join}
      ORDER BY d.team_code, d.sort_order
    `).all();
  }
  rows = normalizeRows(rows);
  res.json({ count: rows.length, duties: rows });
});

// Role priority for fallback assignment (higher = picked first)
const ROLE_PRIORITY = {
  '팀장': 100, '감독선장': 90, '포트캡틴': 85, '감독': 70, '대리': 50, '본부장': 95
};
const normRole = s => String(s || '').replace(/\s+/g, '').replace(/\(.*\)/, '');

router.get('/:team', (req, res) => {
  const team = db.prepare('SELECT * FROM teams WHERE code = ?').get(req.params.team);
  if (!team) return res.status(404).json({ error: 'Team not found' });
  const contacts = contactProjection();
  const company = req.query.company || 'combined';

  // 1) 모든 업무 (combined 기준)
  let duties = normalizeRows(db.prepare(`
    SELECT d.* ${contacts.select}
    FROM duty_assignments d
    ${contacts.join}
    WHERE d.team_code = ?
    ORDER BY sort_order
  `).all(req.params.team));

  // 2) Fleet size 컨텍스트 (samjoo 3척 / doriko 10척 / combined 13척)
  const fleetCount = db.prepare(`
    SELECT COUNT(*) AS n FROM vessels
    ${company !== 'combined' ? 'WHERE ism_manager_code = ?' : ''}
  `).get(...(company !== 'combined' ? [company] : [])).n;

  // 3) 회사별 인원에게 자연 분배 (위임 아님 — 그 회사 인원이 본인 회사 업무 전체 담당)
  let mappingApplied = false;
  let companyStaff = [];
  if (company !== 'combined') {
    companyStaff = db.prepare(`
      SELECT REPLACE(name_ko,' ','') AS name, role_ko, sort_order, is_leader
      FROM staff
      WHERE company_code = ? AND team_code = ?
      ORDER BY is_leader DESC, sort_order
    `).all(company, req.params.team).map(r => ({
      ...r,
      role_norm: normRole(r.role_ko),
      role_clean: String(r.role_ko || '').replace(/\s+/g,'')
    }));

    if (companyStaff.length === 0) {
      // 회사에 이 팀 인원이 0명 → 빈 결과 (SAMJOO BST 같은 경우)
      duties = [];
    } else {
      mappingApplied = true;
      const rrCounter = {};

      // 회사의 본부장(DP) — 같은 팀 백업 후보가 없을 때 fallback
      const dp = db.prepare(`
        SELECT REPLACE(name_ko,' ','') AS name, role_ko, team_code
        FROM staff
        WHERE company_code = ? AND level = 2 AND dept_code = 'smd'
        ORDER BY sort_order
        LIMIT 1
      `).get(company);

      // 회사 전체 선박 수 / 통합 선박 수 → 비율 산정
      const totalFleetAll = db.prepare(`SELECT COUNT(*) AS n FROM vessels`).get().n;
      const fleetRatio = totalFleetAll > 0 ? (fleetCount / totalFleetAll) : 1;

      // 필수 업무 우선, 비필수는 선박 비율만큼만 유지
      const essentials = duties.filter(d => d.is_essential);
      const optionals = duties.filter(d => !d.is_essential);
      const keepOptional = Math.max(0, Math.ceil(optionals.length * fleetRatio));
      duties = [...essentials, ...optionals.slice(0, keepOptional)]
        .sort((a, b) => a.sort_order - b.sort_order);

      duties = duties.map(d => {
        const reqRole = normRole(d.role_ko);
        let candidates = companyStaff.filter(p => p.role_norm === reqRole);
        if (candidates.length === 0) {
          candidates = [...companyStaff].sort((a, b) =>
            (ROLE_PRIORITY[b.role_norm] || 0) - (ROLE_PRIORITY[a.role_norm] || 0)
          );
        }
        const key = `${reqRole}__${candidates.map(c => c.name).join(',')}`;
        const idx = (rrCounter[key] || 0) % candidates.length;
        rrCounter[key] = (rrCounter[key] || 0) + 1;
        const assignee = candidates[idx];

        // 백업: 1순위 = 같은 팀 다른 인원 (라운드로빈)
        //        2순위 = 같은 팀이 본인뿐이면 → 회사 본부장(DP) 1명 고정
        let backupName = null;
        let backupNames = null;
        let backupTeam = null;
        const sameTeamPool = companyStaff.filter(p => p.name !== assignee.name);
        if (sameTeamPool.length > 0) {
          const bkKey = `bk__${assignee.name}`;
          const bkIdx = (rrCounter[bkKey] || 0) % sameTeamPool.length;
          rrCounter[bkKey] = (rrCounter[bkKey] || 0) + 1;
          backupName = sameTeamPool[bkIdx].name;
          backupNames = JSON.stringify([backupName]);
        } else if (dp && dp.name !== assignee.name) {
          // 같은 팀에 본인뿐 → 본부장(DP) 고정 백업
          backupName = dp.name;
          backupNames = JSON.stringify([backupName]);
          backupTeam = dp.team_code || 'smd';
        }

        return {
          ...d,
          staff_name: assignee.name,
          role_ko: assignee.role_clean,
          backup_name: backupName,
          backup_names: backupNames,
          backup_team: backupTeam
        };
      });
    }
  }

  // home-team lookup (cross-team marker용)
  const homeTeamMap = {};
  db.prepare(`
    SELECT REPLACE(name_ko,' ','') AS key, team_code
    FROM staff
    WHERE company_code = 'combined' AND team_code IS NOT NULL
  `).all().forEach(r => { homeTeamMap[r.key] = r.team_code; });

  // 4) Group by staff
  const byStaff = {};
  duties.forEach(d => {
    if (!byStaff[d.staff_name]) {
      const homeTeam = homeTeamMap[d.staff_name] || null;
      byStaff[d.staff_name] = {
        staff_name: d.staff_name,
        role_ko: d.role_ko,
        home_team: homeTeam,
        is_cross_team: !!homeTeam && homeTeam !== req.params.team,
        contact_name_en: d.contact_name_en,
        contact_tel: d.contact_tel,
        contact_mobile: d.contact_mobile,
        contact_email: d.contact_email,
        contact_responsibilities: d.contact_responsibilities,
        duties: []
      };
    }
    byStaff[d.staff_name].duties.push(d);
  });

  res.json({
    team,
    company,
    company_scoped: mappingApplied,
    fleet_count: fleetCount,
    company_staff_count: companyStaff.length,
    duties,
    by_staff: Object.values(byStaff),
    counts: {
      duties: duties.length,
      staff: Object.keys(byStaff).length,
      essential: duties.filter(d => d.is_essential).length
    }
  });
});

router.get('/by-staff/:name', (req, res) => {
  const contacts = contactProjection();
  const rows = normalizeRows(db.prepare(`
    SELECT d.*, t.name_ko AS team_name_ko
           ${contacts.select}
    FROM duty_assignments d
    LEFT JOIN teams t ON t.code = d.team_code
    ${contacts.join}
    WHERE REPLACE(d.staff_name, ' ', '') = REPLACE(?, ' ', '')
    ORDER BY d.team_code, d.sort_order
  `).all(req.params.name));
  res.json({ staff_name: req.params.name, count: rows.length, duties: rows });
});

module.exports = router;
