// ============================================================
// api.js  ·  Thin REST client
// ============================================================
const API_BASE = '';   // same origin (Express serves both)

async function jget(url) {
  const r = await fetch(API_BASE + url);
  if (!r.ok) throw new Error(`${url}: ${r.status} ${r.statusText}`);
  return r.json();
}

const api = {
  companies()             { return jget('/api/companies'); },
  company(code)           { return jget(`/api/companies/${code}`); },
  org(code)               { return jget(`/api/companies/${code}/org`); },
  fleet(code)             { return jget(`/api/companies/${code}/fleet`); },
  particulars(co)         { return jget(`/api/particulars${co && co !== 'combined' ? '?company='+co : ''}`); },
  particular(imo)         { return jget(`/api/particulars/${imo}`); },
  duties()                { return jget('/api/duties'); },
  duty(team, company)     {
    const q = company ? `?company=${encodeURIComponent(company)}` : '';
    return jget(`/api/duties/${team}${q}`);
  },
  dutyMeta()              { return jget('/api/particulars/_meta/common-fields'); },
  safetyVessels(company)  { return jget(`/api/safety/vessels?company=${encodeURIComponent(company || 'combined')}`); },
  safetyVessel(imo)       { return jget(`/api/safety/vessels/${imo}`); },
  shoreSafety(company)    { return jget(`/api/shore-safety?company=${encodeURIComponent(company || 'combined')}`); },
  staffProfile(name)      { return jget(`/api/staff/profile/${encodeURIComponent(name)}`); },
};
