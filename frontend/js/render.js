// ============================================================
// render.js  ·  Tabler-based DOM rendering
// ============================================================

const fmt = n => (n == null ? '—' : Number(n).toLocaleString());

function el(tag, cls, html) {
  const e = document.createElement(tag);
  if (cls) e.className = cls;
  if (html != null) e.innerHTML = html;
  return e;
}

// "본부장" → "DP", "CAPT. SUPT." → "PORT CAPT.", "SUPERINTENDENT" → "SUPT." 정규화
function normalizeTitleText(s) {
  return String(s == null ? '' : s)
    .replace(/선박관리본부장\s*\(?\s*DP\s*\)?/g, 'DP')
    .replace(/선박관리본부\s*·\s*본부장\s*\(?\s*DP\s*\)?/g, '선박관리본부 · DP')
    .replace(/본부장\s*\(\s*DP\s*\)/g, 'DP')
    .replace(/\s*본부장\s*/g, ' DP ')
    .replace(/\bCAPT\.\s*SUPT\.?/gi, 'PORT CAPT.')
    .replace(/\bSUPERINTENDENT\b/gi, 'SUPT.')
    .replace(/\s+/g, ' ')
    .trim();
}

function escapeHtml(s) {
  return normalizeTitleText(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function upperHtml(s) {
  return escapeHtml(String(s == null ? '' : s).toUpperCase());
}

const PT_UPPER_LABELS = new Set([
  'FLAG', 'PORT OF REGISTRY', 'CALL SIGN', 'OFFICIAL NO.', 'MMSI',
  'REGISTERED OWNER', 'BENEFICIAL OWNER', 'DOC COMPANY (ISM)',
  'COMMERCIAL MANAGER', 'TECHNICAL MANAGER', 'COMMERCIAL OPERATOR',
  'P & I CLUB', 'BUILDER', 'CLASS SOCIETY', 'MAIN ENGINE',
  'STATCODE5', 'LEAD SISTER SHIP'
]);

const PT_METER_LABELS = new Set([
  'LOA', 'LBP', 'BREADTH', 'DEPTH', 'SUMMER', 'TROPICAL', 'WINTER'
]);

const PT_DATE_LABELS = new Set(['KEEL LAID']);

function normalizeMeterText(value) {
  const text = String(value)
    .replace(/mtrs?|meters?|metres?/gi, 'm')
    .replace(/\bM\b/g, 'm')
    .replace(/(\d)\s*m\b/gi, '$1 m')
    .replace(/\s+/g, ' ')
    .trim();
  return /^[+-]?\d+(?:[.,]\d+)?$/.test(text) ? `${text} m` : text;
}

function normalizeDateText(value) {
  const text = String(value).trim().toUpperCase();
  const months = {
    JAN: '01', JANUARY: '01',
    FEB: '02', FEBRUARY: '02',
    MAR: '03', MARCH: '03',
    APR: '04', APRIL: '04',
    MAY: '05',
    JUN: '06', JUNE: '06',
    JUL: '07', JULY: '07',
    AUG: '08', AUGUST: '08',
    SEP: '09', SEPT: '09', SEPTEMBER: '09',
    OCT: '10', OCTOBER: '10',
    NOV: '11', NOVEMBER: '11',
    DEC: '12', DECEMBER: '12'
  };
  const pad = n => String(n).padStart(2, '0');

  let m = text.match(/^(\d{4})-(\d{1,2})-(\d{1,2})(?:\s+\d{1,2}:\d{2}:\d{2})?$/);
  if (m) return `${m[1]}-${pad(m[2])}-${pad(m[3])}`;

  m = text.match(/^(\d{1,2})[./](\d{1,2})[./](\d{4})$/);
  if (m) return `${m[3]}-${pad(m[2])}-${pad(m[1])}`;

  m = text.match(/^(\d{1,2})(?:ST|ND|RD|TH)?\s+([A-Z]+)\.?\s+(\d{4})$/);
  if (m && months[m[2]]) return `${m[3]}-${months[m[2]]}-${pad(m[1])}`;

  return text;
}

function normalizeParticularValue(label, value) {
  if (value == null || String(value).trim() === '') return '';
  const key = String(label).replace(/&amp;/g, '&').replace(/\s+/g, ' ').trim().toUpperCase();
  let text = String(value).replace(/&amp;/g, '&').replace(/\s+/g, ' ').trim();

  if (PT_METER_LABELS.has(key)) return normalizeMeterText(text);
  if (PT_DATE_LABELS.has(key)) return normalizeDateText(text);
  if (key === 'P & I CLUB' || key === 'BUILDER') return text.replace(/\.+$/g, '').toUpperCase();
  if (PT_UPPER_LABELS.has(key)) return text.toUpperCase();
  if (key === 'SERVICE SPEED') return text.replace(/\bknots?\b/gi, 'knots');
  if (key === 'M.C.R.') {
    return text
      .replace(/\bkw\b/gi, 'kW')
      .replace(/\bps\b/gi, 'PS')
      .replace(/\bhp\b/gi, 'HP')
      .replace(/\br\/min\b/gi, 'rpm')
      .replace(/\brpm\/min\b/gi, 'rpm')
      .replace(/\bX\b/g, 'x')
      .replace(/\s*x\s*/gi, ' x ')
      .replace(/\s+/g, ' ')
      .trim();
  }
  if (key === 'LIGHTSHIP') {
    return text.replace(/\bM\/T\b/gi, 'MT').replace(/\btons?\b/gi, 'MT');
  }
  return text;
}

// ─── Page title (top navbar) ─────────────────────
const VIEW_TITLES = {
  org:         { ko: '육 상 조 직',      en: 'SHORE ORGANIZATION' },
  'shore-safety': { ko: '육 상 안 전 보 건 조 직 · 책 임 체 계', en: '중대재해처벌법 (SAPA) · PR-23' },
  duties:      { ko: '육 상 업 무',      en: 'SHORE DUTY ASSIGNMENTS' },
  safety:      { ko: '선 박 안 전',      en: 'VESSEL SAFETY ORGANIZATION' },
  fleet:       { ko: '선 박 목 록',      en: 'FLEET LIST' },
  particulars: { ko: '선 박 제 원',      en: "VESSEL SPECIFICATIONS" }
};

function setPageTitle(view) {
  const t = VIEW_TITLES[view] || VIEW_TITLES.org;
  const ko = document.getElementById('pg-title-ko');
  const en = document.getElementById('pg-title-en');
  if (ko) ko.textContent = t.ko;
  if (en) en.textContent = t.en;
  const ph = document.getElementById('ph-section');
  if (ph) ph.textContent = t.ko;
}

// ─── Sidebar nav: active view ───────────────────
function setActiveNav(view) {
  document.querySelectorAll('#sub-nav .nav-item').forEach(li => {
    const a = li.querySelector('.nav-link');
    if (li.dataset.view === view) {
      li.classList.add('active');
      if (a) a.classList.add('active');
    } else {
      li.classList.remove('active');
      if (a) a.classList.remove('active');
    }
  });
}

// ─── Stats row (top) ─────────────────────────────
function updateStats(stats, teamsCount) {
  document.getElementById('num-staff').textContent = stats?.staff_count ?? '—';
  document.getElementById('num-fleet').textContent = stats?.fleet_count ?? '—';
  document.getElementById('num-gt').textContent    = fmt(stats?.total_gt);
  document.getElementById('num-teams').textContent = teamsCount ?? stats?.teams_count ?? '—';
}

// ─── Company dropdown (Bootstrap) ────────────────
function buildDropdownOptions(companies, currentCode, onSelect) {
  const host = document.getElementById('dd-options');
  host.innerHTML = '';
  companies.forEach(c => {
    const li = document.createElement('li');
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'dropdown-item' + (c.code === currentCode ? ' active' : '');
    btn.dataset.company = c.code;
    btn.innerHTML = `
      <span class="ko">${escapeHtml(c.name_ko)}</span>
      <span class="en">${escapeHtml(c.name_en)} · ${escapeHtml(c.role_en)}</span>`;
    btn.addEventListener('click', () => onSelect(c.code));
    li.appendChild(btn);
    host.appendChild(li);
  });
}

function setDropdownCurrent(company) {
  document.getElementById('dd-current-ko').textContent = company.name_ko;
  document.getElementById('dd-current-en').textContent =
    `${company.name_en} · ${company.role_en}`;
}

// ═══════════════════════════════════════════════════════
// ORG VIEW
// ═══════════════════════════════════════════════════════
function renderOrg(host, data) {
  host.innerHTML = '';
  const card = el('div', 'card');

  // 부서별 그룹핑 (선박관리본부 / 경영지원실)
  const DEPTS = [
    { code: 'smd', name_ko: '선박관리본부', name_en: 'Ship Management Division', tag_ko: '본부' },
    { code: 'bsd', name_ko: '경영지원실',   name_en: 'Business Support Department', tag_ko: '실' }
  ];
  const teamsByDept = (data.teams || []).reduce((acc, t) => {
    const k = t.department_code || 'etc';
    if (!acc[k]) acc[k] = [];
    acc[k].push(t);
    return acc;
  }, {});
  const headByDept = (data.department_heads || []).reduce((acc, h) => {
    acc[h.dept_code] = h;
    return acc;
  }, {});

  const deptCount = DEPTS.filter(d => headByDept[d.code] || (teamsByDept[d.code] || []).length).length;
  const teamCount = (data.teams || []).length;

  card.innerHTML = `
    <div class="card-header bilingual">
      <div>
        <div class="card-title-ko">조 직 도${data.company.code === 'combined' ? ' · 통 합' : ''}</div>
        <div class="card-title-en">ORGANIZATION CHART · ${escapeHtml(data.company.name_en)}</div>
      </div>
      <div class="card-meta">대표이사 · 1본부 1실 · <strong>${teamCount}팀</strong> · 총 <strong>${data.counts.staff}명</strong></div>
    </div>
    <div class="card-body p-0">
      <div class="org-canvas" id="org-canvas"></div>
    </div>`;
  host.appendChild(card);

  const canvas = card.querySelector('#org-canvas');

  // ── CEO ─────────────────────────────────
  if (data.ceo?.length) {
    const row = el('div', 'org-ceo-row');
    data.ceo.forEach(p => row.appendChild(personBox(p, 'org-box ceo')));
    canvas.appendChild(row);
  }

  // ── 부서별 그룹: 본부/실 + 산하 팀들 ────
  DEPTS.forEach(d => {
    const head = headByDept[d.code];
    const teams = teamsByDept[d.code] || [];
    if (!head && !teams.length) return;

    const group = el('div', `org-dept-group dept-${d.code}`);

    // 부서 라벨
    const lbl = el('div', 'org-dept-label');
    lbl.innerHTML = `
      <span class="org-dept-tag">${escapeHtml(d.tag_ko)}</span>
      <span class="org-dept-ko">${escapeHtml(d.name_ko)}</span>
      <span class="org-dept-en">${escapeHtml(d.name_en)}</span>
      <span class="org-dept-count">${teams.length}팀</span>`;
    group.appendChild(lbl);

    // 부서장
    if (head) {
      const cls = d.code === 'smd' ? 'org-box dp' : 'org-box biz';
      const headKey = (head.name_ko || '').replace(/\s/g, '');
      const dualTeam = teams.find(t =>
        (t.members || []).some(m => m.is_leader && (m.name_ko || '').replace(/\s/g,'') === headKey)
      );
      const headRow = el('div', 'org-dept-head-row');
      headRow.appendChild(personBox(head, cls, dualTeam ? `${dualTeam.name_ko} 팀장 겸직` : null));
      group.appendChild(headRow);
    }

    // 산하 팀들
    if (teams.length) {
      const colsClass = teams.length >= 3 ? 'cols-3' : (teams.length === 2 ? 'cols-2' : 'cols-1');
      const tg = el('div', `teams-grid ${colsClass}`);
      teams.forEach(t => tg.appendChild(teamBlock(t)));
      group.appendChild(tg);
    }

    canvas.appendChild(group);
  });
}

function personBox(p, cls, dualNote) {
  const b = el('div', `${cls} is-clickable`);
  b.dataset.staffName = p.name_ko || '';
  b.title = `클릭하여 ${p.name_ko || ''} 업무·관리선박 상세 보기`;
  b.innerHTML = `
    <div class="role-ko">${escapeHtml(p.role_ko)}</div>
    <div class="role-en">${escapeHtml(p.role_en)}</div>
    <div class="person-ko">${escapeHtml(p.name_ko)}</div>
    <div class="person-en">${escapeHtml(p.name_en)}</div>
    ${dualNote ? `<div class="org-dual-note">${escapeHtml(dualNote)}</div>` : ''}`;
  b.addEventListener('click', () => openStaffProfile(b.dataset.staffName));
  return b;
}

function teamBlock(team) {
  const c = el('div', `team-block ${team.color_token || ''}`);
  c.innerHTML = `
    <div class="team-head">
      <div class="ko">${escapeHtml(team.name_ko)} <span class="count">${team.members.length}</span></div>
      <div class="en">${escapeHtml(team.name_en)}</div>
    </div>
    <div class="team-body">
      ${team.members.map(m => `
        <div class="team-member is-clickable${m.is_leader ? ' is-leader' : ''}" data-staff-name="${escapeHtml(m.name_ko)}" title="클릭하여 ${escapeHtml(m.name_ko)} 업무·관리선박 상세 보기">
          <div class="role-block">
            <div class="ko">${escapeHtml(m.role_ko)}</div>
            <div class="en">${escapeHtml(m.role_en)}</div>
          </div>
          <div class="person-block">
            <div class="ko">${escapeHtml(m.name_ko)}</div>
            <div class="en">${escapeHtml(m.name_en)}</div>
          </div>
        </div>`).join('')}
    </div>`;
  c.querySelectorAll('[data-staff-name]').forEach(node => {
    node.addEventListener('click', () => openStaffProfile(node.dataset.staffName));
  });
  return c;
}

// ═══════════════════════════════════════════════════════
// FLEET VIEW
// ═══════════════════════════════════════════════════════
function renderFleet(host, data) {
  host.innerHTML = '';
  const card = el('div', 'card');
  card.innerHTML = `
    <div class="card-header bilingual">
      <div>
        <div class="card-title-ko">관 리 선 대${data.company.code === 'combined' ? ' · 통 합' : ''}</div>
        <div class="card-title-en">MANAGED FLEET · ${escapeHtml(data.company.name_en)}</div>
      </div>
      <div class="card-meta">총 <strong>${data.summary.total} 척</strong></div>
    </div>
    <div class="card-body p-0">
      <div class="fleet-summary">
        <div class="stat total"><div class="l">Total / 총 척수</div><div class="v">${data.summary.total}<span class="u">척</span></div></div>
        <div class="stat"><div class="l">VC / BC</div><div class="v">${data.summary.vc_count} / ${data.summary.bc_count}</div></div>
        <div class="stat"><div class="l">Total GT / 합계 GT</div><div class="v">${fmt(data.summary.total_gt)}</div></div>
        <div class="stat"><div class="l">Total DWT / 합계 DWT</div><div class="v">${fmt(data.summary.total_dwt)}</div></div>
      </div>
      <div class="fleet-owners" id="fleet-owners-row"></div>
      <div id="fleet-groups"></div>
      <div class="fleet-footnote">
        <strong>ISM MANAGER</strong> ${escapeHtml(data.company.name_en)}
        <span class="div">|</span>
        <strong>Class</strong> IACS members
        <span class="div">|</span>
        <strong>Flag</strong> KOR KOREA / PAN PANAMA
      </div>
    </div>`;
  host.appendChild(card);

  // 선주별 요약 행 (frontend 직접 계산)
  const allVessels = (data.groups || []).flatMap(g => g.vessels || []);
  const ownersHost = card.querySelector('#fleet-owners-row');
  if (ownersHost && allVessels.length) {
    const ownerSummary = buildOwnerSummary(allVessels);
    ownersHost.innerHTML = `
      <span class="fleet-owners-lbl">선주사 / OWNERS</span>
      ${ownerSummary.map(o => `
        <span class="owner-pill owner-${o.code}">${escapeHtml(o.name)} <span class="owner-cnt">${o.count}</span></span>
      `).join('')}`;
  }

  const groupsHost = card.querySelector('#fleet-groups');
  data.groups.forEach(g => groupsHost.appendChild(shipGroup(g)));
}

function ageBadgeClass(age) {
  if (age == null) return 'age-pill';
  if (age >= 25) return 'age-pill age-old';     // 25년 이상 — 빨강
  if (age >= 15) return 'age-pill age-mid';     // 15-24년 — 주황
  return 'age-pill age-young';                  // 14년 이하 — 녹색
}

// 선주사 매핑 (4개사: SAMJOO MARITIME / DAEBO L&S / GMT / WOORI SHIPPING)
const VESSEL_OWNER_MAP = {
  '8606056': { code: 'samjoo', name: 'SAMJOO MARITIME' },  // GMT ASTRO → 삼주
  '9021332': { code: 'samjoo', name: 'SAMJOO MARITIME' },  // YOUNG SHIN
  '9053505': { code: 'samjoo', name: 'SAMJOO MARITIME' },  // HAE SHIN
  '9073701': { code: 'samjoo', name: 'SAMJOO MARITIME' },  // SANG SHIN
  '9166704': { code: 'samjoo', name: 'SAMJOO MARITIME' },  // SOO SHIN
  '9177430': { code: 'samjoo', name: 'SAMJOO MARITIME' },  // AH SHIN
  '9445394': { code: 'gmt',    name: 'GMT' },              // G POSEIDON
  '9310678': { code: 'woori',  name: 'WOORI SHIPPING' },   // WOORI SUN
  '9418729': { code: 'samjoo', name: 'SAMJOO MARITIME' },  // SJ BUSAN
  '9478511': { code: 'samjoo', name: 'SAMJOO MARITIME' },  // SJ COLOMBO
  '9304538': { code: 'samjoo', name: 'SAMJOO MARITIME' },  // SJ ASIA
  '9610561': { code: 'daebo',  name: 'DAEBO L&S' },        // DAEBO GLADSTONE
  '9710517': { code: 'daebo',  name: 'DAEBO L&S' }         // BT TREVIA
};

function getOwner(v) {
  return v.owner || VESSEL_OWNER_MAP[v.imo] || { code: 'other', name: '-' };
}

function getAge(v) {
  if (v.age != null) return v.age;
  if (!v.built) return null;
  return new Date().getFullYear() - Number(v.built);
}

function buildOwnerSummary(vessels) {
  const map = {};
  vessels.forEach(v => {
    const o = getOwner(v);
    if (!map[o.code]) map[o.code] = { code: o.code, name: o.name, count: 0 };
    map[o.code].count += 1;
  });
  // 정렬: SAMJOO → DAEBO → GMT → WOORI → other
  const order = { samjoo: 1, daebo: 2, gmt: 3, woori: 4, other: 9 };
  return Object.values(map).sort((a, b) => (order[a.code] || 99) - (order[b.code] || 99));
}

function shipGroup(g) {
  const w = el('div', 'ship-group');
  w.innerHTML = `
    <div class="ship-group-head ${g.type === 'VC' ? 'vc' : 'bc'}">
      <span class="ko">${escapeHtml(g.name_ko)}</span>
      <span class="en">· ${escapeHtml(g.name_en)}</span>
      <span class="count">${g.count}</span>
    </div>
    <div class="table-responsive">
      <table class="table table-vcenter fleet-table">
        <thead>
          <tr>
            <th class="center" style="width:50px">NO</th>
            <th class="center" style="width:140px">담당 공무감독<span class="h-en">RESPONSIBLE MTT SUPT.</span></th>
            <th>선명<span class="h-en">SHIP NAME</span></th>
            <th class="center" style="width:90px">건조<span class="h-en">BUILT · AGE</span></th>
            <th class="center" style="width:65px">기국<span class="h-en">FLAG</span></th>
            <th style="width:90px;text-align:right">GT</th>
            <th style="width:90px;text-align:right">DWT</th>
            <th class="center" style="width:110px">선급<span class="h-en">CLASS</span></th>
            <th class="center" style="width:140px">선주<span class="h-en">OWNER</span></th>
            <th class="center" style="width:130px">ISM MANAGER<span class="h-en">DOC COMPANY</span></th>
          </tr>
        </thead>
        <tbody>
          ${g.vessels.map(v => {
            const owner = getOwner(v);
            const age = getAge(v);
            return `
            <tr data-supt="${suptSlug(v.primary_supt)}">
              <td class="center">${v.no}</td>
              <td class="center">
                ${v.primary_supt
                  ? `<span class="supt-pill supt-${suptSlug(v.primary_supt)}" title="담당 공무감독 — ${escapeHtml(v.name)}">${escapeHtml(v.primary_supt)}</span>`
                  : `<span class="supt-pill empty" title="담당 공무감독 미배정">미배정</span>`}
              </td>
              <td>
                <span class="nm">${upperHtml(v.name)}</span>
                <span class="nm-imo">IMO ${v.imo}</span>
              </td>
              <td class="center">
                <div class="built-yr">${v.built ?? '-'}</div>
                ${age != null ? `<span class="${ageBadgeClass(age)}" title="선령 ${age}년">선령 ${age}년</span>` : ''}
              </td>
              <td class="center">${upperHtml(v.flag)}</td>
              <td class="num">${fmt(v.gt)}</td>
              <td class="num">${fmt(v.dwt)}</td>
              <td class="center">${escapeHtml(v.class)}</td>
              <td class="center">
                <span class="owner-pill owner-${owner.code}" title="선주사 — ${escapeHtml(owner.name)}">${escapeHtml(owner.name)}</span>
              </td>
              <td class="center">
                <span class="doc-pill ${v.ism_manager_code === 'samjoo' ? 'sm' : 'dk'}">${
                  v.ism_manager_code === 'samjoo' ? 'SAMJOO SM' : 'DORIKO'}</span>
              </td>
            </tr>`;
          }).join('')}
        </tbody>
      </table>
    </div>`;
  return w;
}

function suptSlug(name) {
  if (!name) return 'none';
  return ({
    '박해민':'phm','이주원':'ljw','최광식':'cgs','김동현':'kdh',
    '권순범':'ksb','팽철호':'pch','최우종':'cwj'
  })[name.replace(/\s/g,'')] || 'other';
}

// ═══════════════════════════════════════════════════════
// PARTICULARS VIEW
// ═══════════════════════════════════════════════════════
function renderParticulars(host, data) {
  host.innerHTML = '';
  const card = el('div', 'card');
  card.innerHTML = `
    <div class="card-header bilingual">
      <div>
        <div class="card-title-ko">선 박 제 원</div>
        <div class="card-title-en">SHIP'S PARTICULARS · COMMON FIELDS</div>
      </div>
      <div class="card-meta">총 <strong>${data.count}척</strong> · 공통 30개 필드</div>
    </div>
    <div class="card-body p-0">
      <div class="particulars-grid" id="pt-grid"></div>
    </div>`;
  host.appendChild(card);
  const gridHost = card.querySelector('#pt-grid');
  data.vessels.forEach(v => gridHost.appendChild(ptCard(v)));
}

function ptCard(v) {
  const owner = v.ism_manager_code;
  const isPCTC = v.type === 'VC';
  const c = el('div', `pt-card ${owner === 'samjoo' ? 'sm' : 'dk'}`);
  c.innerHTML = `
    <div class="pt-head">
      <div class="pt-head-row">
        <div class="d-flex align-items-center gap-2 flex-wrap">
          <span class="pt-no">${v.no}</span>
          <span class="pt-name">${upperHtml(v.vessel_name || v.code_name || '—')}</span>
          <span class="pt-type ${isPCTC ? 'pctc' : 'bulk'}">${isPCTC ? 'PCTC' : 'BULK'}</span>
        </div>
      </div>
      <div class="pt-sub">
        <span class="pt-imo">IMO ${v.imo}</span>
        <span class="pt-doc">${owner === 'samjoo' ? 'SAMJOO SM' : 'DORIKO'}</span>
      </div>
    </div>
    <div class="pt-body">
      <div class="pt-section">
        <div class="pt-sec-title">IDENTITY</div>
        <div class="pt-grid">
          ${ptRow('FLAG', v.flag)}
          ${ptRow('PORT OF REGISTRY', v.port_of_registry)}
          ${ptRow('CALL SIGN', v.call_sign)}
          ${ptRow('OFFICIAL NO.', v.official_no)}
          ${ptRow('MMSI', v.mmsi)}
          ${ptRow('VESSEL TYPE', v.vessel_type)}
        </div>
      </div>
      <div class="pt-section">
        <div class="pt-sec-title">OWNERSHIP &amp; MANAGEMENT</div>
        <div class="pt-grid col1">
          ${ptRow('REGISTERED OWNER', v.registered_owner_rs || v.owner)}
          ${ptRow('BENEFICIAL OWNER', v.beneficial_owner)}
          ${ptRow('DOC COMPANY (ISM)', v.doc_company || v.manager)}
          ${ptRow('COMMERCIAL MANAGER', v.commercial_manager)}
          ${ptRow('TECHNICAL MANAGER', v.technical_manager)}
          ${ptRow('COMMERCIAL OPERATOR', v.commercial_operator || v.operator)}
          ${ptRow('P &amp; I CLUB', v.p_and_i)}
        </div>
      </div>
      <div class="pt-section">
        <div class="pt-sec-title">BUILD &amp; CLASS</div>
        <div class="pt-grid">
          ${ptRow('BUILDER', v.builder)}
          ${ptRow('BUILT YEAR', v.built_year)}
          ${ptRow('KEEL LAID', v.keel_laid)}
          ${ptRow('CLASS SOCIETY', v.class_society)}
        </div>
      </div>
      <div class="pt-section">
        <div class="pt-sec-title">DIMENSIONS &amp; STRUCTURE</div>
        <div class="pt-grid sm">
          ${ptRow('LOA', v.loa)}
          ${ptRow('LBP', v.lbp)}
          ${ptRow('BREADTH', v.breadth)}
          ${ptRow('DEPTH', v.depth)}
          ${ptRow('LIGHTSHIP', v.lightship)}
          ${ptRow('EQUIPMENT NO.', v.equipment_no)}
          ${ptRow('HULL TYPE', v.hull_type)}
          ${ptRow('STATCODE5', v.statcode5)}
          ${ptRow('LEAD SISTER SHIP', v.lead_sister_ship)}
        </div>
      </div>
      <div class="pt-section">
        <div class="pt-sec-title">TONNAGE &amp; DEADWEIGHT</div>
        <div class="pt-grid sm">
          ${ptRow('GT', v.gt)} ${ptRow('NT', v.nt)} ${ptRow('DWT', v.dwt)}
        </div>
      </div>
      <div class="pt-section">
        <div class="pt-sec-title">DRAFT</div>
        <div class="pt-grid sm">
          ${ptRow('SUMMER', v.draft_summer)}
          ${ptRow('TROPICAL', v.draft_tropical)}
          ${ptRow('WINTER', v.draft_winter)}
        </div>
      </div>
      <div class="pt-section">
        <div class="pt-sec-title">PROPULSION</div>
        <div class="pt-grid">
          ${ptRow('MAIN ENGINE', v.main_engine)}
          ${ptRow('M.C.R.', v.mcr)}
          ${ptRow('SERVICE SPEED', v.service_speed)}
        </div>
      </div>
    </div>`;
  return c;
}

function ptRow(label, value) {
  const normalized = normalizeParticularValue(label, value);
  const v = normalized ? escapeHtml(normalized) : '<span class="empty">미등록</span>';
  return `<div class="pt-row"><div class="pt-lbl">${label}</div><div class="pt-val">${v}</div></div>`;
}

// ═══════════════════════════════════════════════════════
// DUTIES VIEW (interactive team tabs + company filter)
// ═══════════════════════════════════════════════════════
const DUTIES_TEAMS = [
  { code: 'CMT', ko: '해상인사팀', en: 'Crew Mgmt',   color: 'marine' },
  { code: 'SQT', ko: '안전품질팀', en: 'Safety & Q.', color: 'safety' },
  { code: 'MTT', ko: '공무팀',     en: 'Marine Tech', color: 'tech'   },
  { code: 'BST', ko: '경영지원팀', en: 'Biz Support', color: 'biz'    }
];

async function renderDuties(host) {
  host.innerHTML = '';
  const company = (typeof State !== 'undefined' && State.currentCompany) ? State.currentCompany : 'combined';

  // 모든 팀 fetch 후 — 인원 0명인 팀(예: SAMJOO BST)은 탭 숨김
  const allSummaries = await Promise.all(DUTIES_TEAMS.map(t =>
    api.duty(t.code, company).catch(() => null)
  ));
  const visiblePairs = DUTIES_TEAMS
    .map((meta, i) => ({ meta, summary: allSummaries[i] }))
    .filter(p => company === 'combined' || (p.summary?.counts?.staff > 0));
  const visibleTeams = visiblePairs.map(p => p.meta);
  const summaries = visiblePairs.map(p => p.summary);

  const card = el('div', 'card');
  card.innerHTML = `
    <div class="card-header bilingual">
      <div>
        <div class="card-title-ko">육 상 업 무 분 장</div>
        <div class="card-title-en">SHORE DUTY ASSIGNMENTS · ${escapeHtml(company.toUpperCase())}</div>
      </div>
      <div class="card-meta">${company === 'combined' ? '통합 전체 업무' : '필수 업무 + 선대 비율 적용'}</div>
    </div>
    <div class="duty-tabs" id="duty-tabs"></div>
    <div class="card-body p-0">
      <div class="duty-team-panel" id="duty-team-panel"></div>
    </div>`;
  host.appendChild(card);

  // Decide initial active tab
  const stored = State.currentDutyTeam;
  const storedVisible = stored && visibleTeams.find(t => t.code === stored);
  const firstWithData = summaries.findIndex(s => s && s.counts && s.counts.duties > 0);
  let active = (storedVisible && summaries.find(s => s?.team?.code === stored && s.counts.duties))
    ? stored
    : (firstWithData >= 0 ? visibleTeams[firstWithData].code : (visibleTeams[0]?.code || 'SQT'));

  const tabsHost = card.querySelector('#duty-tabs');
  visibleTeams.forEach((meta, i) => {
    const data = summaries[i];
    const cnt = data?.counts || { duties: 0, staff: 0, essential: 0 };
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = `duty-tab tab-${meta.color}${meta.code === active ? ' active' : ''}${cnt.duties === 0 ? ' empty' : ''}`;
    btn.dataset.team = meta.code;
    btn.innerHTML = `
      <span class="dt-titles">
        <span class="dt-ko">${meta.ko}</span>
        <span class="dt-en">${meta.en}</span>
      </span>
      <span class="dt-counts">
        <span class="dt-cn">${cnt.staff}<small>명</small></span>
        <span class="dt-cn">${cnt.duties}<small>건</small></span>
      </span>`;
    btn.addEventListener('click', () => selectDutyTeam(meta.code, summaries));
    tabsHost.appendChild(btn);
  });

  // Adjust tab grid columns to actual count
  tabsHost.style.gridTemplateColumns = `repeat(${visibleTeams.length}, 1fr)`;

  renderDutyTeamPanel(
    card.querySelector('#duty-team-panel'),
    summaries.find(s => s?.team?.code === active),
    company
  );
}

function selectDutyTeam(teamCode, summaries) {
  State.currentDutyTeam = teamCode;
  document.querySelectorAll('#duty-tabs .duty-tab').forEach(b => {
    b.classList.toggle('active', b.dataset.team === teamCode);
  });
  const panel = document.getElementById('duty-team-panel');
  const data = summaries.find(s => s?.team?.code === teamCode);
  renderDutyTeamPanel(panel, data, State.currentCompany || 'combined');
  if (typeof initTooltips === 'function') initTooltips();
}

function renderDutyTeamPanel(panel, data, company) {
  panel.innerHTML = '';
  const coKo = company === 'combined' ? '통합' : (company === 'samjoo' ? '삼주에스엠' : '도리코');
  if (!data || !data.duties.length) {
    panel.innerHTML = `
      <div class="app-loader" style="padding:60px 20px;">
        <strong>${coKo}</strong>에 이 팀 소속 인원이 없거나 업무 데이터가 없습니다.
      </div>`;
    return;
  }
  panel.appendChild(dutyTeamSection(data));
}

function dutyTeamSection(data) {
  const t = data.team;
  const sec = el('div', `duty-team ${t.color_token || ''}`);
  const scopeBadge = data.company_scoped
    ? `<span class="badge company-scope" title="해당 회사 인원이 본인 회사 업무 전체 담당">선대 ${data.fleet_count}척 / ${data.company_staff_count}명 분담</span>`
    : '';
  sec.innerHTML = `
    <div class="duty-team-head">
      <div class="duty-team-title">
        <div class="ko">${escapeHtml(t.name_ko)}</div>
        <div class="en">${escapeHtml(t.name_en)}</div>
      </div>
      <div class="duty-team-stats">
        ${scopeBadge}
        <span class="badge">${data.counts.staff}명</span>
        <span class="badge">${data.counts.duties}건</span>
        <span class="badge essential">필수 ${data.counts.essential}</span>
      </div>
    </div>
    <div class="duty-staff-grid"></div>`;
  const grid = sec.querySelector('.duty-staff-grid');
  data.by_staff.forEach(s => grid.appendChild(dutyStaffCard(s)));
  return sec;
}

function dutyStaffCard(s) {
  const roleSlug = roleToSlug(s.role_ko);
  const c = el('div', `duty-staff role-${roleSlug}${s.is_cross_team ? ' cross-team' : ''}`);
  const crossBadge = s.is_cross_team
    ? `<span class="ds-cross" title="원소속 팀과 다른 팀 업무">${teamShortKo(s.home_team)} 겸직</span>`
    : '';
  c.innerHTML = `
    <div class="ds-head">
      <div class="ds-name is-clickable" data-staff-name="${escapeHtml(s.staff_name)}" title="클릭하여 ${escapeHtml(s.staff_name)} 업무·관리선박 상세 보기">${escapeHtml(s.staff_name)} ${crossBadge}</div>
      <div class="ds-role r-${roleSlug}">${escapeHtml(s.role_ko || '—')}</div>
    </div>
    <div class="ds-meta">
      <span class="ds-meta-cell"><span class="ds-meta-lbl">업무</span><span class="ds-meta-val">${s.duties.length}건</span></span>
      <span class="ds-meta-cell"><span class="ds-meta-lbl">필수</span><span class="ds-meta-val">${s.duties.filter(d=>d.is_essential).length}</span></span>
    </div>
    <div class="ds-duties">
      ${s.duties.map(d => dutyRow(d)).join('')}
    </div>`;
  const nameNode = c.querySelector('[data-staff-name]');
  if (nameNode) nameNode.addEventListener('click', () => openStaffProfile(nameNode.dataset.staffName));
  return c;
}

function teamShortKo(code) {
  return ({ CMT:'해상인사팀', SQT:'안전품질팀', MTT:'공무팀', BST:'경영지원팀' })[code] || code;
}

function roleToSlug(roleKo) {
  if (!roleKo) return 'default';
  const r = String(roleKo).replace(/\s+/g, '').trim();
  return ({
    '팀장':     'leader',
    '감독선장': 'captsupt',
    '포트캡틴': 'portcapt',
    '감독':     'supt',
    '대리':     'assist',
    'DP':       'head',
    '본부장':   'head',
    '본부장(DP)':'head',
    '상무':     'exec',
    '대표이사': 'ceo'
  })[r] || 'default';
}

function dutyRow(d) {
  const essential = d.is_essential ? `<span class="ds-essential" title="팀별 필수 인원"></span>` : '';
  const fallback = d.is_fallback
    ? `<span class="ds-fallback" title="해당 회사에 ${d.fallback_team === 'MTT' ? '공무팀' : d.fallback_team} 인원이 없어 ${teamShortKo(d.team_code || '')} 업무 대행">⇄ ${teamShortKo(d.team_code || '')} 업무 대행</span>`
    : '';
  const backupArr = d.backup_names ? safeParseBackups(d.backup_names) : [];
  const backups = backupArr.length
    ? `<div class="ds-backup">
        <span class="ds-bk-lbl">대행 / Backup</span>
        ${backupArr.map(b => `<span class="ds-bk-name">${escapeHtml(b)}</span>`).join('')}
      </div>`
    : '';
  return `
    <div class="ds-duty${d.is_fallback ? ' is-fallback' : ''}">
      <div class="ds-duty-head">
        ${essential}
        <div class="ds-duty-area">${escapeHtml(formatDutyArea(d.duty_area))}</div>
        ${fallback}
      </div>
      <div class="ds-duty-content">${formatDutyContent(d.duty_content)}</div>
      ${backups}
    </div>`;
}

// Normalize bullet prefixes (-, •, ·, 1., 1), 가., etc.) → unified <ul><li>
function formatDutyContent(raw) {
  if (!raw) return '';
  const lines = String(raw)
    .replace(/\r\n?/g, '\n')
    .split('\n')
    .map(l => l.trim())
    .filter(Boolean);
  if (!lines.length) return '';
  // Strip leading bullet markers
  const STRIP = /^(?:[-•·◦∙‣▪▫※]+\s*|\d+[.)]\s*|[①-⑳]\s*|[가-힣]\.\s*)/;
  const items = lines.map(line => line.replace(STRIP, '').trim()).filter(Boolean);
  return '<ul class="ds-list">' + items.map(it => `<li>${escapeHtml(it)}</li>`).join('') + '</ul>';
}

function formatDutyArea(s) {
  if (!s) return '';
  return String(s)
    .split(/\n+/).map(t => t.trim()).filter(Boolean).join(' · ')
    .replace(/\s*\/\s*·\s*/g, ' / ')
    .replace(/\s*·\s*\/\s*/g, ' / ')
    .replace(/\s+/g, ' ');
}

function safeParseBackups(raw) {
  try { return JSON.parse(raw); } catch { return raw ? [raw] : []; }
}

// ═══════════════════════════════════════════════════════
// SHORE SAFETY VIEW (SAPA / 중처법)
// ═══════════════════════════════════════════════════════
function shoreStatusDot(status) {
  switch (String(status || '').trim()) {
    case '운영중':   return '#047857'; // green
    case '이행중':   return '#2563EB'; // blue
    case '부분이행': return '#D97706'; // amber
    case '미이행':   return '#B91C1C'; // red
    case '해당없음': return '#6B7280'; // gray
    default:         return '#6B7280';
  }
}

// Map owner role_code → tier number (for left-border color)
function shoreOwnerTier(code) {
  switch (code) {
    case 'CEO':           return 1;
    case 'DP_MANAGER':    return 2;
    case 'SQT_LEAD':
    case 'MTT_LEAD':
    case 'CMT_LEAD':
    case 'BST_HEAD':      return 3;
    case 'SQT_PRACTICAL': return 4;
    case 'SUPERVISORS':   return 5;
    default:              return 3;
  }
}

function shoreTierLabel(t) {
  switch (t) {
    case 1: return 'T1 · 경영책임자';
    case 2: return 'T2 · 총괄책임';
    case 3: return 'T3 · 실무 책임자';
    case 4: return 'T4 · 실무 담당';
    case 5: return 'T5 · 현장 감독';
    default: return '';
  }
}

// 회사별 SAPA owner 매핑 (조직도 기반 — 백엔드 응답에 owner_role 없을 때 fallback)
const SAPA_OWNER_MAP = {
  combined: {
    CEO:           { name: '정진욱', title: '대표이사' },
    DP_MANAGER:    { name: '최인호', title: 'DP' },
    SQT_LEAD:      { name: '연제만', title: '안전품질팀장' },
    SQT_PRACTICAL: { name: '민경진', title: '안전품질팀 SUPT.' },
    MTT_LEAD:      { name: '최우종', title: '공무팀장' },
    CMT_LEAD:      { name: '원훈희', title: '해상인사팀장' },
    BST_HEAD:      { name: '강충식', title: '경영지원실 상무' }
  },
  doriko: {
    CEO:           { name: '정진욱', title: '대표이사' },
    DP_MANAGER:    { name: '최인호', title: 'DP' },
    SQT_LEAD:      { name: '연제만', title: '안전품질팀장' },
    SQT_PRACTICAL: { name: '노경수', title: '감독선장' },
    MTT_LEAD:      { name: '최광식', title: '공무팀 SUPT.' },
    CMT_LEAD:      { name: '원훈희', title: '해상인사팀장' },
    BST_HEAD:      { name: '강충식', title: '경영지원실 상무' }
  },
  samjoo: {
    CEO:           { name: '정진욱', title: '대표이사' },
    DP_MANAGER:    { name: '최우종', title: 'DP' },
    SQT_LEAD:      { name: '민경진', title: '안전품질팀 SUPT.' },
    SQT_PRACTICAL: { name: '함혁',   title: '안전품질팀 SUPT.' },
    MTT_LEAD:      { name: '김동현', title: '공무팀 SUPT.' },
    CMT_LEAD:      { name: '이의진', title: '해상인사팀 대리' },
    BST_HEAD:      { name: '최우종', title: 'DP' }   // BST 부재 → DP 흡수
  }
};

const SAPA_FALLBACK = {
  BST_HEAD:      ['DP_MANAGER', 'CEO'],
  MTT_LEAD:      ['DP_MANAGER', 'CEO'],
  CMT_LEAD:      ['DP_MANAGER', 'CEO'],
  SQT_LEAD:      ['SQT_PRACTICAL', 'DP_MANAGER', 'CEO'],
  SQT_PRACTICAL: ['SQT_LEAD', 'DP_MANAGER', 'CEO'],
  DP_MANAGER:    ['CEO']
};

function getSapaOwner(roleCode, companyCode) {
  const co = SAPA_OWNER_MAP[companyCode] || SAPA_OWNER_MAP.combined;
  if (co[roleCode]) return co[roleCode];
  for (const f of SAPA_FALLBACK[roleCode] || []) {
    if (co[f]) return co[f];
  }
  return { name: '-', title: '' };
}

function sapaRequirementRow(r, idx, companyCode) {
  const ownerSrc = r.owner_role || {};
  const ownerCode = ownerSrc.role_code || r.owner_role_code;
  const tier = shoreOwnerTier(ownerCode);
  // 백엔드 응답이 비어 있으면 frontend 매핑으로 채움
  const fallback = getSapaOwner(ownerCode, companyCode);
  const ownerName = ownerSrc.owner_name || fallback.name;
  const ownerTitle = ownerSrc.owner_title || ownerSrc.role_ko || fallback.title;
  // status는 항상 '운영중'으로 강제 (보강필요/확인필요 등 옛 데이터값 무시)
  const status = '운영중';
  const statusColor = shoreStatusDot(status);

  return `
    <div class="sapa-req-row tier${tier}">
      <div class="sapa-req-no">${idx}</div>
      <div>
        <div class="sapa-req-cat-ko">${escapeHtml(r.category_ko)}</div>
        <div class="sapa-req-cat-en">${escapeHtml(r.category_en || '')}</div>
        <div class="sapa-req-basis">${escapeHtml(r.legal_basis || '')}</div>
      </div>
      <div>
        <div class="sapa-req-text">${escapeHtml(r.requirement_ko)}</div>
        ${r.evidence ? `<div class="sapa-req-evidence">증빙 · ${escapeHtml(r.evidence)}</div>` : ''}
      </div>
      <div data-staff-name="${escapeHtml(ownerName !== '-' ? ownerName : '')}" class="${ownerName !== '-' ? 'is-clickable' : ''}">
        <div class="sapa-req-owner-tier">${shoreTierLabel(tier)}</div>
        <div class="sapa-req-owner-name">${escapeHtml(ownerName)}</div>
        <div class="sapa-req-owner-role">${escapeHtml(ownerTitle)}</div>
      </div>
      <div class="sapa-req-freq">${escapeHtml(r.frequency || '-')}</div>
      <div class="sapa-req-status">
        <span class="sapa-legend-item"><span class="sapa-legend-dot" style="background:${statusColor}"></span>${status}</span>
      </div>
    </div>`;
}

function renderShoreSafety(host, data) {
  host.innerHTML = '';
  const card = el('div', 'card shore-card');

  // Prefer personnel-based tier_blocks; fall back to seeded role tiers
  const blocks = Array.isArray(data.tier_blocks) && data.tier_blocks.length
    ? data.tier_blocks
    : (data.tiers || []).map(t => ({
        ...t,
        legal_summary: tierLegalSummary(t.tier),
        members: t.roles.map(r => ({
          name_ko: r.owner_name, name_en: '',
          role_ko: r.owner_title, role_en: '',
          team_code: r.team_code, team_name_ko: r.team_name_ko || '',
          sapa_role_ko: r.role_ko, sapa_role_en: r.role_en,
          responsibility: r.responsibility, legal_basis: r.legal_basis
        }))
      }));

  // status는 화면에서 '운영중' 한 가지로만 표시 (옛 데이터의 보강필요/확인필요 무시)
  const totalReq = data.counts?.total || (data.requirements?.length || 0);
  const countBadges = `<span class="sapa-legend-item"><span class="sapa-legend-dot" style="background:${shoreStatusDot('운영중')}"></span>운영중 ${totalReq}</span>`;

  const lb = data.legal_basis || {};
  const statutes = Array.isArray(lb.statutes) ? lb.statutes : (Array.isArray(data.legal_basis) ? data.legal_basis : []);
  const procedure = lb.company_procedure || { code: 'PR-23', title: '중대재해처벌법 매뉴얼', scope: '육상 안전보건관리체계', note: '' };

  card.innerHTML = `
    <div class="card-header bilingual">
      <div>
        <div class="card-title-ko">육 상 안 전 보 건 조 직 · 책 임 체 계</div>
        <div class="card-title-en">SAPA · ACCOUNTABILITY CASCADE · ${escapeHtml(data.scope_company.name_en)}</div>
      </div>
      <div class="card-meta">
        책임자 <strong>${data.roster_count ?? data.roles.length}명</strong>
        · 의무이행 <strong>${data.counts?.total || 0}항목</strong>
        · ${escapeHtml(data.scope_note)}
      </div>
    </div>
    <div class="card-body shore-body">
      <div class="sapa-legal-grid">
        <div class="sapa-legal-card statutes">
          <div class="sapa-legal-head">
            <div class="sapa-legal-h-ko">법령 기준</div>
            <div class="sapa-legal-h-en">STATUTORY BASIS</div>
          </div>
          <ul class="sapa-legal-list">
            ${statutes.map(s => `
              <li>
                <span class="sapa-legal-label">${escapeHtml(s.label)}</span>
                <span class="sapa-legal-summary">${escapeHtml(s.summary)}</span>
              </li>`).join('')}
          </ul>
        </div>
        <div class="sapa-legal-card procedure">
          <div class="sapa-legal-head">
            <div class="sapa-legal-h-ko">회사 절차서</div>
            <div class="sapa-legal-h-en">COMPANY PROCEDURE</div>
          </div>
          <div class="sapa-proc-code">${escapeHtml(procedure.code)}</div>
          <div class="sapa-proc-title">${escapeHtml(procedure.title)}</div>
          <div class="sapa-proc-scope">${escapeHtml(procedure.scope)}</div>
          ${procedure.note ? `<div class="sapa-proc-note">${escapeHtml(procedure.note)}</div>` : ''}
        </div>
      </div>

      <div class="shore-section-title">책임 체계 / Accountability Cascade — 일반 조직도와 다른 수직 책임 흐름</div>
      <div class="sapa-cascade">
        ${blocks.map(sapaTierBlock).join('')}
      </div>

      <div class="sapa-matrix">
        <div class="sapa-matrix-head">
          <div>
            <div class="h-ko">시행령 제4조 의무이행 매트릭스</div>
            <div class="h-en">SAPA ENFORCEMENT DECREE ART.4 · COMPLIANCE MATRIX</div>
          </div>
          <div class="h-counts">총 ${data.requirements.length}항목 · 책임 단계별 매핑</div>
        </div>
        <div class="sapa-matrix-body">
          ${data.requirements.map((r, i) => sapaRequirementRow(r, i + 1, data.company?.code || data.scope_company?.code || 'combined')).join('')}
        </div>
        <div class="sapa-legend">
          ${countBadges}
          <span class="sapa-legend-item"><span class="sapa-legend-dot" style="background:#B91C1C"></span>T1 경영책임자</span>
          <span class="sapa-legend-item"><span class="sapa-legend-dot" style="background:#C2410C"></span>T2 총괄책임</span>
          <span class="sapa-legend-item"><span class="sapa-legend-dot" style="background:#B45309"></span>T3 실무 책임자</span>
          <span class="sapa-legend-item"><span class="sapa-legend-dot" style="background:#047857"></span>T4 실무 담당</span>
          <span class="sapa-legend-item"><span class="sapa-legend-dot" style="background:#1E40AF"></span>T5 현장 감독</span>
        </div>
      </div>
    </div>`;
  host.appendChild(card);

  // Wire person-click → profile modal
  card.querySelectorAll('[data-staff-name]').forEach(node => {
    node.addEventListener('click', () => openStaffProfile(node.dataset.staffName));
  });
}

function sapaTierBlock(b) {
  return `
    <div class="sapa-tier sapa-tier${b.tier}">
      <div class="sapa-tier-label ${b.color}">
        <div class="tier-code">${escapeHtml(b.code)}</div>
        <div class="tier-ko">${escapeHtml(b.label_ko)}</div>
        <div class="tier-en">${escapeHtml(b.label_en)}</div>
        <div class="tier-count">${b.members.length}명 · ${escapeHtml(b.legal_summary || '')}</div>
      </div>
      <div class="sapa-role-list">
        ${b.members.map(sapaMemberCard).join('')}
      </div>
    </div>`;
}

function sapaMemberCard(m) {
  const teamBadge = m.team_code
    ? `<span class="sapa-team-chip team-${String(m.team_code).toLowerCase()}">${escapeHtml(m.team_code)}</span>`
    : (m.dept_code ? `<span class="sapa-team-chip dept-${m.dept_code}">${escapeHtml(m.dept_name_ko || m.dept_code)}</span>` : '');
  const clickHint = `<span class="sapa-click-hint">▸ 클릭하여 업무·관리선박 보기</span>`;
  return `
    <div class="sapa-role-card is-clickable" data-staff-name="${escapeHtml(m.name_ko || '')}">
      <div class="sapa-role-head">
        <div>
          <div class="sapa-role-ko">${escapeHtml(m.sapa_role_ko)}</div>
          <div class="sapa-role-en">${escapeHtml(m.sapa_role_en)}</div>
        </div>
        ${teamBadge}
      </div>
      <div class="sapa-role-owner">
        <span class="sapa-role-owner-name">${escapeHtml(m.name_ko || '-')}</span>
        <span class="sapa-role-owner-title">${escapeHtml(m.role_ko || '')}</span>
        ${m.is_acting ? '<span class="sapa-acting-chip">대표 시니어</span>' : ''}
      </div>
      <div class="sapa-role-resp">${escapeHtml(m.responsibility)}</div>
      <div class="sapa-role-basis">${escapeHtml(m.legal_basis || '')}</div>
      ${clickHint}
    </div>`;
}

// Client-side tier grouping fallback (older server without tiers field)
function buildTiersClient(roles) {
  const TIER_MAP = {
    CEO: 1, DP_MANAGER: 2,
    SQT_LEAD: 3, MTT_LEAD: 3, CMT_LEAD: 3, BST_HEAD: 3,
    SQT_PRACTICAL: 4, SUPERVISORS: 5
  };
  const META = {
    1: { code: 'T1', label_ko: '경영책임자',        label_en: 'Accountable Executive',      color: 'tier1' },
    2: { code: 'T2', label_ko: '안전보건 총괄책임', label_en: 'Safety & Health Controller', color: 'tier2' },
    3: { code: 'T3', label_ko: '실무 책임자',       label_en: 'Functional Leads',           color: 'tier3' },
    4: { code: 'T4', label_ko: '실무 담당',         label_en: 'Practical Coordinator',      color: 'tier4' },
    5: { code: 'T5', label_ko: '현장 관리감독자',   label_en: 'Line Supervisors',           color: 'tier5' }
  };
  const groups = {};
  roles.forEach(r => {
    const t = TIER_MAP[r.role_code] || 3;
    if (!groups[t]) groups[t] = { tier: t, ...META[t], roles: [] };
    groups[t].roles.push(r);
  });
  return Object.values(groups).sort((a, b) => a.tier - b.tier);
}

function tierLegalSummary(tier) {
  switch (tier) {
    case 1: return '시행령 제4조 전체';
    case 2: return '제4조 제5호·8호';
    case 3: return '제4조 제3호·4호·7호';
    case 4: return '제4조 제3호·7호·8호';
    case 5: return '제4조 제5호·8호 현장';
    default: return '';
  }
}

// ── Staff profile modal (vessels + duties) ────────────────
async function openStaffProfile(name) {
  if (!name) return;
  closeStaffProfile();
  const overlay = document.createElement('div');
  overlay.className = 'staff-modal-overlay';
  overlay.id = 'staff-modal';
  overlay.innerHTML = `
    <div class="staff-modal" role="dialog" aria-modal="true">
      <button type="button" class="staff-modal-close" aria-label="닫기">×</button>
      <div class="staff-modal-body"><div class="app-loader">불러오는 중…</div></div>
    </div>`;
  document.body.appendChild(overlay);
  overlay.addEventListener('click', e => { if (e.target === overlay) closeStaffProfile(); });
  overlay.querySelector('.staff-modal-close').addEventListener('click', closeStaffProfile);
  document.addEventListener('keydown', escCloseHandler);

  try {
    const data = await api.staffProfile(name);
    overlay.querySelector('.staff-modal-body').innerHTML = staffProfileHtml(data);
  } catch (err) {
    overlay.querySelector('.staff-modal-body').innerHTML = `
      <div class="staff-modal-error">
        <div class="staff-modal-error-title">${escapeHtml(name)} 정보를 찾을 수 없습니다</div>
        <div class="staff-modal-error-sub">${escapeHtml(err.message || '')}</div>
      </div>`;
  }
}
function closeStaffProfile() {
  const overlay = document.getElementById('staff-modal');
  if (overlay) overlay.remove();
  document.removeEventListener('keydown', escCloseHandler);
}
function escCloseHandler(e) { if (e.key === 'Escape') closeStaffProfile(); }

function staffProfileHtml(data) {
  const s = data.staff;
  const c = data.contact || {};
  const vp = data.vessels?.primary || [];
  const duties = data.duties || [];
  const sapa = data.sapa_roles || [];

  const dutiesByTeam = duties.reduce((acc, d) => {
    const key = d.team_code || 'OTHER';
    if (!acc[key]) acc[key] = { team_code: key, team_name_ko: d.team_name_ko || key, duties: [] };
    acc[key].duties.push(d);
    return acc;
  }, {});

  const vesselCard = (v) => `
    <div class="sp-vessel">
      <div class="sp-vessel-no">${escapeHtml(String(v.no ?? '·'))}</div>
      <div class="sp-vessel-main">
        <div class="sp-vessel-name">${upperHtml(v.name)}</div>
        <div class="sp-vessel-sub">IMO ${escapeHtml(v.imo)} · ${escapeHtml(v.type)} · ${escapeHtml(v.flag || '')} · GT ${Number(v.gt || 0).toLocaleString()}</div>
      </div>
      <div class="sp-vessel-ism ${v.ism_manager_code === 'samjoo' ? 'sm' : 'dk'}">
        ${v.ism_manager_code === 'samjoo' ? 'SAMJOO SM' : 'DORIKO'}
      </div>
    </div>`;

  const teamSectionHtml = Object.values(dutiesByTeam).map(g => `
    <div class="sp-duty-team">
      <div class="sp-duty-team-head">
        <span class="sp-duty-team-code team-${String(g.team_code).toLowerCase()}">${escapeHtml(g.team_code)}</span>
        <span class="sp-duty-team-ko">${escapeHtml(g.team_name_ko)}</span>
        <span class="sp-duty-team-cnt">${g.duties.length}건</span>
      </div>
      <div class="sp-duty-list">
        ${g.duties.map(d => `
          <div class="sp-duty-row ${d.is_essential ? 'is-essential' : ''}">
            <div class="sp-duty-area">${escapeHtml(d.duty_area || d.work_area_ko || '')}</div>
            <div class="sp-duty-content">${formatDutyContent(d.duty_content || d.work_content_ko || '')}</div>
            ${d.remarks ? `<div class="sp-duty-content-en">${escapeHtml(d.remarks)}</div>` : ''}
          </div>
        `).join('')}
      </div>
    </div>
  `).join('');

  return `
    <div class="sp-head">
      <div>
        <div class="sp-name-ko">${escapeHtml(s.name_ko)}</div>
        <div class="sp-name-en">${escapeHtml(s.name_en || '')}</div>
      </div>
      <div class="sp-meta">
        <div class="sp-meta-row"><span class="sp-meta-k">소속</span><span class="sp-meta-v">${escapeHtml(s.dept_name_ko || '—')}</span></div>
        <div class="sp-meta-row"><span class="sp-meta-k">팀</span><span class="sp-meta-v">${escapeHtml(s.team_name_ko || '—')}</span></div>
        <div class="sp-meta-row"><span class="sp-meta-k">직책</span><span class="sp-meta-v">${escapeHtml(s.role_ko)}</span></div>
      </div>
    </div>

    ${(c.email || c.mobile || c.tel) ? `
      <div class="sp-contact">
        ${c.email ? `<a class="sp-contact-item" href="mailto:${escapeHtml(c.email)}"><span class="k">Email</span><span class="v">${escapeHtml(c.email)}</span></a>` : ''}
        ${c.mobile ? `<a class="sp-contact-item" href="tel:${escapeHtml(c.mobile)}"><span class="k">Mobile</span><span class="v">${escapeHtml(c.mobile)}</span></a>` : ''}
        ${c.tel ? `<div class="sp-contact-item"><span class="k">Tel</span><span class="v">${escapeHtml(c.tel)}</span></div>` : ''}
      </div>
    ` : ''}

    ${sapa.length ? `
      <div class="sp-section">
        <div class="sp-section-head">SAPA 책임 / Accountability under PR-23</div>
        <div class="sp-sapa-list">
          ${sapa.map(r => `
            <div class="sp-sapa-card">
              <div class="sp-sapa-role">${escapeHtml(r.role_ko)} <span class="sp-sapa-en">${escapeHtml(r.role_en)}</span></div>
              <div class="sp-sapa-resp">${escapeHtml(r.responsibility)}</div>
              <div class="sp-sapa-basis">${escapeHtml(r.legal_basis || '')}</div>
            </div>`).join('')}
        </div>
      </div>` : ''}

    ${vp.length ? `
      <div class="sp-section">
        <div class="sp-section-head">관리 선박 / Managed Vessels <span class="sp-section-meta">${vp.length}척</span></div>
        <div class="sp-vessels">
          ${vp.map(v => vesselCard(v)).join('')}
        </div>
      </div>` : ''}

    <div class="sp-section">
      <div class="sp-section-head">개인 업무분장 / Individual Duty Assignment <span class="sp-section-meta">총 ${duties.length}건</span></div>
      ${duties.length ? teamSectionHtml : '<div class="sp-empty">조직도에 매핑된 업무가 없습니다.</div>'}
    </div>
  `;
}

// ═══════════════════════════════════════════════════════
// VESSEL SAFETY ORGANIZATION VIEW (PR-13 APP.6)
// ═══════════════════════════════════════════════════════
async function renderSafety(host, state) {
  host.innerHTML = '';
  const card = el('div', 'card');
  card.innerHTML = `
    <div class="card-header bilingual">
      <div>
        <div class="card-title-ko">선 박 안 전 조 직</div>
        <div class="card-title-en">VESSEL SAFETY ORGANIZATION · PR-13 APP.6 (BBCHP + KOR)</div>
      </div>
      <div class="card-meta" id="safety-meta">불러오는 중…</div>
    </div>
    <div class="card-body p-0">
      <div class="safety-wrap" id="safety-wrap"></div>
    </div>`;
  host.appendChild(card);

  const body = card.querySelector('#safety-wrap');
  const co = state.currentCompany;
  const list = await api.safetyVessels(co);
  let vessels = list.vessels || [];
  vessels = vessels.map(v => ({
    ...v,
    safety_applicable: v.safety_applicable != null
      ? Number(v.safety_applicable)
      : ((v.flag_category === 'KOR' || v.flag_category === 'BBCHP') ? 1 : 0)
  }));
  if (co !== 'combined') vessels = vessels.filter(v => v.ism_manager_code === co);

  const meta = document.getElementById('safety-meta');
  if (!vessels.length) {
    meta.innerHTML = `<strong>${co === 'samjoo' ? '삼주에스엠' : '도리코'}</strong> 대상 선박 없음`;
    body.innerHTML = `<div class="app-loader">선택한 회사의 ISM 관리 선박이 없습니다.</div>`;
    return;
  }
  const scope = co === 'combined' ? '전체' : co === 'samjoo' ? '삼주에스엠(주)' : '(주)도리코';
  const applicableArr = vessels.filter(v => v.safety_applicable === 1);
  const naArr = vessels.filter(v => v.safety_applicable !== 1);
  const cat = {
    KOR:   applicableArr.filter(v => v.flag_category === 'KOR').length,
    BBCHP: applicableArr.filter(v => v.flag_category === 'BBCHP').length
  };
  meta.innerHTML = `<strong>${scope}</strong> 전체 <strong>${vessels.length}척</strong> · 적용 ${applicableArr.length}척 (KOR ${cat.KOR} + BBCHP ${cat.BBCHP}) · 해당 없음 ${naArr.length}척 · 기준 PR-13 APP.6`;

  if (!state.currentVessel || !applicableArr.find(v => v.imo === state.currentVessel)) {
    state.currentVessel = applicableArr[0]?.imo || null;
  }
  body.appendChild(safetyVesselSelector({ vessels }, state.currentVessel));
  const detail = el('div', 'safety-detail');
  detail.id = 'safety-detail';
  body.appendChild(detail);
  if (state.currentVessel) await loadSafetyVessel(state.currentVessel);
  else detail.innerHTML = '<div class="app-loader">KOR/BBCHP 적용 대상 선박이 없습니다.</div>';
}

function safetyVesselSelector(list, currentImo) {
  const wrap = el('div', 'safety-vessel-bar');
  const groups = [
    { cat: 'KOR',   label_ko: '한국적', label_en: 'KOREAN FLAG',
      filter: v => Number(v.safety_applicable) === 1 && v.flag_category === 'KOR' },
    { cat: 'BBCHP', label_ko: 'BBCHP', label_en: 'BAREBOAT CHARTER HIRE PURCHASE',
      filter: v => Number(v.safety_applicable) === 1 && v.flag_category === 'BBCHP' },
    { cat: 'NA',    label_ko: '해당 없음', label_en: 'NOT APPLICABLE',
      filter: v => Number(v.safety_applicable) !== 1 }
  ];
  groups.forEach(g => {
    const items = list.vessels.filter(g.filter);
    if (!items.length) return;
    const grp = el('div', `svb-group cat-${g.cat.toLowerCase()}`);
    grp.innerHTML = `
      <div class="svb-grp-head">
        <span class="svb-grp-ko">${g.label_ko}</span>
        <span class="svb-grp-en">${g.label_en}</span>
        <span class="svb-grp-count">${items.length}</span>
      </div>
      <div class="svb-chips"></div>`;
    const chips = grp.querySelector('.svb-chips');
    items.forEach(v => {
      const applicable = Number(v.safety_applicable) === 1;
      const chip = document.createElement('button');
      chip.type = 'button';
      chip.className = `svb-chip ${v.imo === currentImo ? 'active' : ''}${applicable ? '' : ' disabled'}`;
      chip.dataset.imo = v.imo;
      chip.disabled = !applicable;
      chip.title = applicable ? '' : 'PR-13 APP.6 대상이 아니므로 선박 안전조직 해당 없음';
      chip.innerHTML = `
        <span class="svb-name">${upperHtml(v.name)}</span>
        <span class="svb-imo">IMO ${v.imo}</span>
        <span class="svb-ism ${v.ism_manager_code === 'samjoo' ? 'sm' : 'dk'}">${
          v.ism_manager_code === 'samjoo' ? 'SAMJOO SM' : 'DORIKO'}</span>
        ${applicable ? '' : '<span class="svb-na">해당 없음</span>'}`;
      if (applicable) chip.addEventListener('click', () => selectSafetyVessel(v.imo));
      chips.appendChild(chip);
    });
    wrap.appendChild(grp);
  });
  return wrap;
}

async function selectSafetyVessel(imo) {
  if (window.__APP_STATE__) window.__APP_STATE__.currentVessel = imo;
  document.querySelectorAll('.svb-chip').forEach(c => c.classList.toggle('active', c.dataset.imo === imo));
  await loadSafetyVessel(imo);
}

async function loadSafetyVessel(imo) {
  const detail = document.getElementById('safety-detail');
  if (!detail) return;
  detail.innerHTML = '<div class="app-loader">불러오는 중…</div>';
  const data = await api.safetyVessel(imo);
  detail.innerHTML = '';
  detail.appendChild(safetyVesselHeader(data.vessel));
  if (!Number(data.vessel.safety_applicable)) {
    if (data.legal_basis) detail.appendChild(safetyLegalBasis(data.legal_basis));
    detail.appendChild(safetyNotApplicable(data));
    return;
  }
  if (data.legal_basis) detail.appendChild(safetyLegalBasis(data.legal_basis));
  detail.appendChild(safetyOrgChart(data.roles || []));
  if (data.committee) detail.appendChild(safetyCommittee(data.committee));
}

// 선박 안전조직 법령 근거 + 적용범위 + 회사 절차서
function safetyLegalBasis(lb) {
  const w = el('div', 'svo-legal');
  const statutes = Array.isArray(lb.statutes) ? lb.statutes : [];
  const proc = lb.company_procedure || {};
  const scope = lb.scope || {};
  const note = lb.basis_note || {};

  w.innerHTML = `
    ${scope.ko ? `
      <div class="svo-scope-card">
        <div class="svo-scope-head">
          <div class="svo-scope-h-ko">적용범위 · APPLICATION</div>
          <div class="svo-scope-h-en">PR-13 APP.6 §1 SCOPE</div>
        </div>
        <div class="svo-scope-body">
          <div class="svo-scope-ko">${escapeHtml(scope.ko)}</div>
          ${scope.en ? `<div class="svo-scope-en">${escapeHtml(scope.en)}</div>` : ''}
        </div>
      </div>` : ''}

    <div class="sapa-legal-grid">
      <div class="sapa-legal-card statutes">
        <div class="sapa-legal-head">
          <div class="sapa-legal-h-ko">근거 법령 · 국제기준</div>
          <div class="sapa-legal-h-en">STATUTORY &amp; INTERNATIONAL BASIS</div>
        </div>
        ${note.ko ? `<div class="svo-basis-note">${escapeHtml(note.ko)}${note.en ? ` <em>${escapeHtml(note.en)}</em>` : ''}</div>` : ''}
        <ul class="sapa-legal-list">
          ${statutes.map(s => `
            <li>
              <span class="sapa-legal-label">${escapeHtml(s.label)}${s.label_en ? ` <em class="svo-legal-en">${escapeHtml(s.label_en)}</em>` : ''}</span>
              <span class="sapa-legal-summary">${escapeHtml(s.summary)}</span>
            </li>`).join('')}
        </ul>
      </div>
      <div class="sapa-legal-card procedure">
        <div class="sapa-legal-head">
          <div class="sapa-legal-h-ko">회사 절차서</div>
          <div class="sapa-legal-h-en">COMPANY PROCEDURE</div>
        </div>
        <div class="sapa-proc-code">${escapeHtml(proc.code || 'PR-13 APP.6')}</div>
        <div class="sapa-proc-title">${escapeHtml(proc.title || '선내 안전보건 조직 운영절차')}</div>
        <div class="sapa-proc-scope">${escapeHtml(proc.scope || '')}</div>
        ${proc.note ? `<div class="sapa-proc-note">${escapeHtml(proc.note)}</div>` : ''}
      </div>
    </div>`;
  return w;
}

function safetyVesselHeader(v) {
  const hd = el('div', 'svh');
  const catCls = v.flag_category === 'KOR' ? 'cat-kor' : (v.flag_category === 'BBCHP' ? 'cat-bbchp' : '');
  hd.innerHTML = `
    <div>
      <div class="svh-name">${upperHtml(v.name)} <span class="svh-imo">IMO ${escapeHtml(v.imo)}</span></div>
      <div class="svh-meta">
        <span><strong>기준</strong>PR-13 APP.6</span>
        <span><strong>ISM</strong>${v.ism_manager_code === 'samjoo' ? 'SAMJOO SM' : 'DORIKO'}</span>
        <span><strong>유형</strong>${escapeHtml(v.type || '-')}</span>
        <span><strong>기국</strong>${escapeHtml(v.flag || '-')}</span>
      </div>
    </div>
    <div class="svh-r">
      <span class="svh-pill ${catCls}">${escapeHtml(v.flag_category || '-')}</span>
    </div>`;
  return hd;
}

function safetyNotApplicable() {
  const w = el('div', 'svo-committee');
  w.innerHTML = `
    <div class="svc-head">
      <div class="svc-ko">PR-13 APP.6 적용 대상 선박이 아님</div>
      <div class="svc-en">NOT APPLICABLE · PANAMA FLAG</div>
    </div>
    <div class="svc-row">
      <span class="svc-lbl">사유</span>
      <span class="svc-val">파나마 기국 선박은 선원법 / 산업안전보건법상 선내 안전보건위원회 구성 의무 대상이 아님.</span>
    </div>`;
  return w;
}

function safetyOrgChart(roles) {
  const wrap = el('div', 'svo-chart');
  if (!roles.length) {
    wrap.innerHTML = '<div class="app-loader">등록된 역할이 없습니다.</div>';
    return wrap;
  }

  const cardHtml = (r) => {
    const cls = String(r.role_code || '').toLowerCase();
    const legal = r.legal || {};
    return `
      <div class="svo-card ${cls}">
        <div class="svo-role-head">
          <div>
            <div class="svo-role-ko">${escapeHtml(r.role_ko)}</div>
            <div class="svo-role-en">${escapeHtml(r.role_en || '')}</div>
          </div>
          ${r.has_swa ? '<span class="svo-swa">SWA 권한</span>' : ''}
        </div>
        ${r.designation_ko ? `
          <div class="svo-desig">
            <div class="svo-desig-ko">${escapeHtml(r.designation_ko)}</div>
            ${r.designation_en ? `<div class="svo-desig-en">${escapeHtml(r.designation_en)}</div>` : ''}
          </div>` : ''}
        ${r.qualification ? `
          <div class="svo-qual">
            <span class="svo-lbl">자격 / Qualification</span>
            ${escapeHtml(r.qualification)}
          </div>` : ''}
        ${r.duties ? `
          <div class="svo-duties">
            <span class="svo-lbl">직무 / Duties</span>
            ${escapeHtml(r.duties)}
          </div>` : ''}
        ${legal.statute || legal.procedure ? `
          <div class="svo-legal-row">
            ${legal.statute ? `<div class="svo-legal-statute"><span class="svo-lbl">법령 / Statute</span>${escapeHtml(legal.statute)}</div>` : ''}
            ${legal.procedure ? `<div class="svo-legal-proc"><span class="svo-lbl">절차서 / Procedure</span>${escapeHtml(legal.procedure)}</div>` : ''}
          </div>` : ''}
      </div>`;
  };

  // Master 카드는 상단 단독, 나머지는 3열 그리드
  const master = roles.find(r => r.role_code === 'MASTER');
  const others = roles.filter(r => r.role_code !== 'MASTER');

  let html = '';
  if (master) {
    html += `<div class="svo-section-lbl">선내 / Onboard</div>`;
    html += `<div class="svo-top">${cardHtml(master)}</div>`;
  }
  if (others.length) {
    html += `<div class="svo-grid">${others.map(cardHtml).join('')}</div>`;
  }
  wrap.innerHTML = html;
  return wrap;
}

function safetyCommittee(committee) {
  const w = el('div', 'svo-committee');
  const members = committee.members || [];
  w.innerHTML = `
    <div class="svc-head">
      <div class="svc-ko">${escapeHtml(committee.ko || '안전보건위원회')}</div>
      <div class="svc-en">${escapeHtml(committee.en || 'Safety & Health Committee')} · 위원 ${members.length}명</div>
    </div>
    ${committee.legal_basis ? `
      <div class="svc-row">
        <span class="svc-lbl">법령 / 절차</span>
        <span class="svc-val">${escapeHtml(committee.legal_basis)}</span>
      </div>` : ''}
    <div class="svc-row">
      <span class="svc-lbl">위원 구성</span>
      <span class="svc-val">${members.map(escapeHtml).join(' · ')}</span>
    </div>
    ${committee.duties_ko ? `
      <div class="svc-row">
        <span class="svc-lbl">심의 사항</span>
        <span class="svc-val">${escapeHtml(committee.duties_ko)}</span>
      </div>` : ''}
    ${committee.schedule_ko ? `
      <div class="svc-row">
        <span class="svc-lbl">소집 주기</span>
        <span class="svc-val">${escapeHtml(committee.schedule_ko)}${committee.schedule_en ? ` (${escapeHtml(committee.schedule_en)})` : ''}</span>
      </div>` : ''}
    ${committee.retention_ko ? `
      <div class="svc-row">
        <span class="svc-lbl">회의록 보관</span>
        <span class="svc-val">${escapeHtml(committee.retention_ko)}</span>
      </div>` : ''}`;
  return w;
}
