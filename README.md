# SAMJOO SM & DORIKO  ·  Org & Fleet System

3-Tier 분리 구조 (DB / Backend / Frontend)

```
samjoo_org_app/
├── db/
│   ├── schema.sql        ─ 스키마 정의 (companies / departments / teams / staff / vessels)
│   ├── seed.sql          ─ 초기 데이터 (회사 3 · 인사 47 · 선박 13)
│   └── orgchart.db       ─ SQLite 파일 (init 후 자동 생성)
│
├── backend/
│   ├── package.json
│   ├── init-db.js        ─ schema + seed 실행해 DB 생성
│   ├── db.js             ─ 공유 SQLite 커넥션
│   ├── server.js         ─ Express 진입점 (port 3000)
│   └── routes/
│       ├── companies.js  ─ GET /api/companies, /:code
│       ├── org.js        ─ GET /api/companies/:code/org
│       └── fleet.js      ─ GET /api/companies/:code/fleet
│
└── frontend/
    ├── index.html        ─ 정적 셸 (콘텐츠 없음, JS로 주입)
    ├── css/styles.css
    └── js/
        ├── api.js        ─ fetch 헬퍼
        ├── render.js     ─ DOM 빌더
        └── app.js        ─ state + 이벤트 + 메인 흐름
```

## 실행

```bash
cd samjoo_org_app/backend
npm install
npm run init-db        # DB 생성
npm start              # http://localhost:3000
```

## API

| Method | Endpoint                              | 응답 |
|--------|---------------------------------------|------|
| GET    | `/api/health`                         | 헬스체크 |
| GET    | `/api/companies`                      | 회사 3개 + 통계 (staff/fleet/GT/teams) |
| GET    | `/api/companies/:code`                | 회사 단건 (`combined`/`samjoo`/`doriko`) |
| GET    | `/api/companies/:code/org`            | 조직도 트리 (CEO + 부서장 + 팀+멤버) |
| GET    | `/api/companies/:code/fleet`          | 관리 선대 (요약 + VC/BC 그룹) |

## DB 스키마 요약

| 테이블 | 키 | 비고 |
|--------|-----|------|
| `companies`   | code (PK) | combined / samjoo / doriko |
| `departments` | code (PK) | smd (선박관리본부) / bsd (경영지원실) |
| `teams`       | code (PK) | CMT / SQT / MTT / BST |
| `staff`       | id (PK)   | company_code, team_code, dept_code, level, role, name, is_leader |
| `vessels`     | imo (PK)  | type (VC/BC), gt, dwt, class, flag, ism_manager_code |

뷰: `v_company_staff_count`, `v_company_team_count`, `v_company_fleet_stats`

## 데이터 수정

`db/seed.sql` 편집 후 `npm run init-db` 재실행 → DB 재생성.
또는 SQLite CLI / DB Browser 로 직접 `orgchart.db` 수정 가능.

## 프론트엔드 동작 흐름

1. `boot()` → `GET /api/companies` 호출
2. 회사 드롭다운 + 통계 사이드바 채움
3. `load()` → 현재 회사·뷰에 따라 `/org` 또는 `/fleet` 호출
4. `render.js` 가 응답 JSON → HTML DOM 으로 변환
5. 회사·뷰 전환 시 같은 `load()` 재호출

기준일: 2026.05
