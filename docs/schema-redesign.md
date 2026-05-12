# 데이터 스키마 재설계안

기준일: 2026-05-12

## 결론

현재 구조는 기본 테이블은 있지만, 스키마와 seed가 섞여 있고 사람을 이름 문자열로 참조해서 데이터가 쉽게 끊긴다. v2에서는 `person_id`, `company_code`, `team_code`, `imo` 같은 안정적인 키를 기준으로 다시 잡는다.

가장 중요한 변경은 다음 네 가지다.

1. 사람은 `people`에 한 번만 저장하고, 회사별/조직도별 배치는 `staff_assignments`로 분리한다.
2. 업무분장과 담당감독은 이름 문자열 대신 `person_id`를 참조한다.
3. 선박 기본정보는 `vessels`, 정제된 제원은 `vessel_particulars`, 원문 import는 `vessel_particulars_raw`로 분리한다.
4. `CREATE TABLE`과 `ALTER TABLE`은 seed 파일에서 제거하고, 모든 DDL은 `db/schema_v2.sql`로 모은다.

## 현재 문제

### 1. 이름 문자열 참조

현재 `staff.name_ko`는 `원 훈 희`, `박 해 민`처럼 공백 포함이고, `duty_assignments.staff_name`과 `vessel_supervisor.primary_supt`는 `원훈희`, `박해민`처럼 공백 없이 저장되어 있다.

이 때문에 exact join은 0건이다. 공백 제거로 임시 매칭은 가능하지만, 같은 사람이 `combined`와 실제 회사 레코드에 중복되어 있어서 장기적으로 안정적이지 않다.

### 2. DDL과 seed 혼재

현재 `schema.sql`에는 기본 테이블만 있고, `seed_extra.sql`, `seed_safety.sql`, `seed_supervisors.sql`, `seed_rightship.sql`이 테이블 생성과 컬럼 추가까지 수행한다. 이 구조에서는 스키마 변경 이력을 추적하기 어렵고, migration 스크립트의 idempotent 보장도 약하다.

### 3. 선박 제원 중복

`vessels`와 `vessel_particulars`가 `flag`, `gt`, `dwt`, `class`, `type` 성격의 값을 중복으로 가진다. 또한 `vessel_particulars`는 `232.39mtrs`, `18,769 Ton`, `FWA`, `Not in particulars`처럼 단위와 설명이 섞인 raw import에 가깝다.

## v2 핵심 테이블

### 조직

`companies`
: 회사/롤업 단위. `combined`는 실회사라기보다 집계용이므로 `is_rollup = 1`로 구분한다.

`departments`
: 본부/실 단위. 현재 `smd`, `bsd`.

`teams`
: 팀 단위. `department_code`를 필수 FK로 둔다.

`people`
: 실제 사람. 이름 표기는 여기서 한 번만 관리한다. `person_key`는 migration용 안정 키이고, `name_ko_key`는 공백 제거 등 검색용 키다.

`staff_assignments`
: 사람이 어느 회사/부서/팀에서 어떤 역할을 맡는지 저장한다. CEO, 본부장, 팀원은 `org_level`과 CHECK 제약으로 구분한다.

### 업무분장

`duty_assignments`
: 업무 1건. 담당자는 `assignee_person_id`로 참조한다.

`duty_backup_people`
: 백업 담당자는 여러 명일 수 있으므로 별도 연결 테이블로 둔다. 기존 `backup_name`, `backup_names` 문자열/JSON 혼합 구조를 제거한다.

### 선박

`vessels`
: 운영 기준 선박 마스터. IMO, 선명, 선종, 총톤수, DWT, ISM manager, 안전조직 적용 여부 등 앱에서 계산과 필터에 쓰는 기준값만 둔다.

`vessel_particulars`
: 정제된 제원. 길이, 흘수, 속도, MCR 등 계산 가능한 값은 숫자 컬럼과 단위 기준을 고정한다.

`vessel_particulars_raw`
: PDF/Excel/RightShip 등 원문 값은 JSON/text payload로 보관한다. 원문이 섞인 값을 typed 컬럼에 강제로 넣지 않는다.

### 안전조직/담당감독/RightShip

`vessel_supervisor_assignments`
: 선박별 담당감독 배정 이력. 현재 담당은 `effective_to IS NULL`로 조회한다.

`vessel_safety_roles`
: `MASTER`, `SAFETY_OFFICER`, `HEALTH_OFFICER`, `SAFETY_REP` 같은 고정 역할 코드.

`vessel_safety_assignments`
: 선박별 안전조직 역할 지정.

`vessel_rightship_profiles`
: RightShip overlay 데이터. `age`는 `"38.5 y/o"` 문자열 대신 `age_years REAL`로 저장한다.

## 전환 순서

1. `db/schema_v2.sql`을 별도 DB에 적용해서 스키마 문법과 FK를 먼저 검증한다.
2. 현재 `staff`에서 `people`을 생성한다. 기준은 `REPLACE(name_ko, ' ', '')`로 잡되, 최종 저장은 사람이 한 번만 생기도록 `person_key`를 부여한다.
3. 현재 `staff`를 `staff_assignments`로 이관한다. `combined`는 실제 회사가 아니라 조직도/집계용 assignment로 유지한다.
4. `duty_assignments.staff_name`, `backup_name`, `backup_names`를 `people.name_ko_key`로 매핑해 `duty_assignments`와 `duty_backup_people`로 이관한다.
5. `vessel_supervisor.primary_supt`, `backup_supt`도 같은 방식으로 `person_id`에 매핑한다.
6. `vessels`는 운영 기준값으로 이관하고, `vessel_particulars`는 숫자/날짜 파싱이 가능한 값만 typed 컬럼에 넣는다.
7. 원본 제원 값과 gap-fill 보정 내역은 `data_sources`와 `vessel_particulars_raw`에 남긴다.
8. backend route는 바로 테이블을 직접 보지 말고 `v_current_staff`, `v_vessel_supervisor`, `v_duty_assignments_api` 같은 v2 뷰부터 읽게 바꾼다.

## 적용 원칙

새로운 seed 파일에는 `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE`을 넣지 않는다. seed는 데이터만 넣고, 스키마 변경은 `schema_v2.sql` 또는 별도 migration 파일로만 처리한다.

사람, 팀, 선박을 참조할 때는 표시 이름을 키로 쓰지 않는다. 표시 이름은 언제든 공백, 한글/영문 표기, 직책 변경 때문에 달라질 수 있다.

선박 제원은 화면 표시용 raw 문자열과 계산용 숫자 컬럼을 분리한다. 출처가 불확실한 보정값은 `source_id`와 `confidence` 또는 `notes`에 남긴다.
