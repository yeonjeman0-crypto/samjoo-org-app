// ============================================================
// app.js  ·  state + event wiring + main flow
// ============================================================
const State = {
  currentCompany:  'combined',
  currentView:     'org',
  currentVessel:   null,
  currentDutyTeam: null,   // remembered active team in duties view
  companies:       [],
};

const $body = document.body;

async function boot() {
  try {
    const data = await api.companies();
    State.companies = data.companies;

    buildDropdownOptions(State.companies, State.currentCompany, switchCompany);

    // Sidebar nav (Tabler nav-items with data-view)
    document.querySelectorAll('#sub-nav .nav-item').forEach(li => {
      li.addEventListener('click', e => {
        e.preventDefault();
        switchView(li.dataset.view);
      });
    });

    setActiveNav(State.currentView);
    setPageTitle(State.currentView);

    await load();
  } catch (err) {
    console.error('Boot failed:', err);
    document.getElementById('content-host').innerHTML =
      `<div class="card"><div class="card-body text-danger">
         <strong>API 연결 실패:</strong> ${err.message}<br>
         <small class="text-secondary">backend 서버가 실행 중인지 확인하세요 (npm start).</small>
       </div></div>`;
  }
}

async function switchCompany(code) {
  State.currentCompany = code;
  $body.dataset.company = code;

  // Close Bootstrap dropdown
  const trigger = document.getElementById('dd-trigger');
  if (window.bootstrap && trigger) {
    const inst = window.bootstrap.Dropdown.getInstance(trigger);
    if (inst) inst.hide();
  }

  document.querySelectorAll('#dd-options .dropdown-item').forEach(b => {
    b.classList.toggle('active', b.dataset.company === code);
  });

  await load();
}

async function switchView(view) {
  State.currentView = view;
  $body.dataset.view = view;
  setActiveNav(view);
  setPageTitle(view);
  await load();
}

async function load() {
  const code = State.currentCompany;
  const co   = State.companies.find(c => c.code === code);
  if (!co) return;

  setDropdownCurrent(co);
  updateStats(co.stats, co.stats?.teams_count);

  const host = document.getElementById('content-host');
  host.innerHTML = '<div class="card"><div class="card-body app-loader">불러오는 중 / Loading…</div></div>';

  try {
    if (State.currentView === 'org') {
      const data = await api.org(code);
      renderOrg(host, data);
    } else if (State.currentView === 'fleet') {
      const data = await api.fleet(code);
      renderFleet(host, data);
    } else if (State.currentView === 'particulars') {
      const data = await api.particulars(code);
      renderParticulars(host, data);
    } else if (State.currentView === 'duties') {
      await renderDuties(host);
    } else if (State.currentView === 'safety') {
      await renderSafety(host, State);
    } else if (State.currentView === 'shore-safety') {
      const data = await api.shoreSafety(code);
      renderShoreSafety(host, data);
    }
    initTooltips();
  } catch (err) {
    host.innerHTML = `<div class="card"><div class="card-body text-danger app-loader">${err.message}</div></div>`;
  }
}

// Bootstrap Tooltip 자동 초기화 (Tabler 번들에 포함)
function initTooltips() {
  if (!window.bootstrap) return;
  document.querySelectorAll('[data-bs-toggle="tooltip"], [title]:not([data-bs-toggle])').forEach(el => {
    if (!el.getAttribute('title')) return;
    if (window.bootstrap.Tooltip.getInstance(el)) return;
    new window.bootstrap.Tooltip(el, { container: 'body', placement: 'top', boundary: 'window' });
  });
}

async function selectSafetyVessel(imo) {
  State.currentVessel = imo;
  await load();
}

boot();
