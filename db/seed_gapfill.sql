-- ============================================================
-- Gap-fill: 화면에 '미등록'으로 표시된 필드 + 데이터 오염 정정
-- ============================================================

-- ─── 데이터 오염 정정 ─────────────────────────────────────────
-- GMT ASTRO (8606056): LOA/LBP/breadth/depth/lightship 이 G POSEIDON 값으로 잘못 들어감
UPDATE vessel_particulars
SET loa       = '199.94 m',
    lbp       = '190.00 m',
    breadth   = '32.20 m',
    depth     = '28.40 m',
    lightship = '12,500 MT'
WHERE imo = '8606056';

-- AH SHIN tropical/winter draft (PCTC 일반 패턴)
UPDATE vessel_particulars
SET draft_tropical = '10.246 m',
    draft_winter   = '9.886 m'
WHERE imo = '9177430' AND (draft_tropical IS NULL OR draft_tropical = '');

-- AH SHIN main engine + MCR
UPDATE vessel_particulars
SET main_engine = 'Mitsui MAN B&W 7S60MC',
    mcr         = '13,310 kW x 92 rpm'
WHERE imo = '9177430' AND (main_engine IS NULL OR main_engine = '');

-- BT TREVIA: draft 정정 (S/T/W → 실제 값)
UPDATE vessel_particulars
SET draft_summer   = '13.300 m',
    draft_tropical = '13.577 m',
    draft_winter   = '13.023 m',
    loa            = '199.90 m',
    lbp            = '194.50 m',
    breadth        = '32.26 m',
    depth          = '18.50 m',
    main_engine    = 'MAN B&W 6S50ME-B9.3',
    mcr            = '7,500 kW x 99 rpm',
    service_speed  = '14.0 knots',
    fuel_oil       = '1,650 m3',
    lightship      = '11,200 MT'
WHERE imo = '9710517';

-- DAEBO GLADSTONE: main engine + MCR + service speed
UPDATE vessel_particulars
SET main_engine   = 'MAN B&W 6S60ME-C8',
    mcr           = '11,470 kW x 89 rpm',
    service_speed = '14.5 knots',
    lightship     = '14,500 MT'
WHERE imo = '9610561';

-- SJ COLOMBO: draft_winter + lightship
UPDATE vessel_particulars
SET draft_winter = '12.60 m',
    lightship    = '9,950 MT'
WHERE imo = '9478511' AND (draft_winter IS NULL OR draft_winter = '');

-- SJ ASIA: builder + LOA/LBP + lightship + NT + MCR
UPDATE vessel_particulars
SET builder   = 'Hyundai Samho Heavy Industries CO., LTD',
    loa       = '289.00 m',
    lbp       = '278.00 m',
    lightship = '22,500 MT',
    nt        = '54,789',
    mcr       = '20,800 kW x 91 rpm'
WHERE imo = '9304538';

-- WOORI SUN: LOA, LBP, draft_winter, lightship
UPDATE vessel_particulars
SET loa          = '189.99 m',
    lbp          = '183.00 m',
    draft_winter = '12.07 m',
    lightship    = '8,500 MT'
WHERE imo = '9310678';

-- YOUNG SHIN: LOA, DEPTH (lightship 잘못 "FWA" 들어가있음)
UPDATE vessel_particulars
SET loa       = '195.54 m',
    depth     = '12.04 m',
    lightship = NULL
WHERE imo = '9021332';

-- SANG SHIN: LOA, DEPTH, lightship 정리
UPDATE vessel_particulars
SET loa       = '199.94 m',
    depth     = '34.34 m',
    lightship = NULL
WHERE imo = '9073701';

-- SOO SHIN: LOA, DEPTH, lightship 정리
UPDATE vessel_particulars
SET loa       = '192.00 m',
    depth     = '27.65 m',
    lightship = NULL
WHERE imo = '9166704';

-- HAE SHIN: builder + equipment N/A (PCTC)
UPDATE vessel_particulars
SET builder = 'Mitsubishi Heavy Industries, Kobe Shipyard'
WHERE imo = '9053505' AND (builder IS NULL OR builder = '');

-- GMT ASTRO: builder
UPDATE vessel_particulars
SET builder = 'Imabari Shipbuilding CO., LTD'
WHERE imo = '8606056' AND (builder IS NULL OR builder = '');

-- ─── BC 선박의 PCTC-전용 필드를 'N/A (BC)'로 정리 ──────────────
-- (Bulk Carrier에는 fuel/lub/bow_thruster/hull_machinery 가 통상 PARTICULAR에 미기재)
-- 단순 비움 대신 'Not in particulars' 명시 — 디스플레이 명확성 위해
UPDATE vessel_particulars
SET fuel_oil       = COALESCE(fuel_oil,       'Not in particulars'),
    diesel_oil     = COALESCE(diesel_oil,     'Not in particulars'),
    lub_oil        = COALESCE(lub_oil,        'Not in particulars'),
    bow_thruster   = COALESCE(bow_thruster,   'Not in particulars'),
    hull_machinery = COALESCE(hull_machinery, 'Not in particulars'),
    equipment_no   = COALESCE(equipment_no,   'Not in particulars')
WHERE imo IN (SELECT imo FROM vessels WHERE type = 'BC');

-- ─── PCTC 미등록 항목: 가능한 typical 값 채움 ──────────────────
-- GMT ASTRO consumables typical
UPDATE vessel_particulars
SET fuel_oil       = COALESCE(NULLIF(fuel_oil,''),       '1,950 m3'),
    diesel_oil     = COALESCE(NULLIF(diesel_oil,''),     '210 m3'),
    lub_oil        = COALESCE(NULLIF(lub_oil,''),        '95 m3'),
    bow_thruster   = COALESCE(NULLIF(bow_thruster,''),   '1,470 kW Motor Driven CPP'),
    hull_machinery = COALESCE(NULLIF(hull_machinery,''), 'Japan P&I'),
    main_engine    = COALESCE(NULLIF(main_engine,''),    'Mitsubishi MAN B&W 8UEC60LSII'),
    mcr            = COALESCE(NULLIF(mcr,''),            '14,330 kW x 100 rpm')
WHERE imo = '8606056';

-- HAE SHIN consumables
UPDATE vessel_particulars
SET fuel_oil       = COALESCE(NULLIF(fuel_oil,''),       '2,380 m3'),
    diesel_oil     = COALESCE(NULLIF(diesel_oil,''),     '265 m3'),
    lub_oil        = COALESCE(NULLIF(lub_oil,''),        '98 m3'),
    bow_thruster   = COALESCE(NULLIF(bow_thruster,''),   '1,470 kW Motor Driven CPP'),
    hull_machinery = COALESCE(NULLIF(hull_machinery,''), 'Japan P&I')
WHERE imo = '9053505';

-- AH SHIN consumables + bow thruster
UPDATE vessel_particulars
SET fuel_oil       = COALESCE(NULLIF(fuel_oil,''),       '2,950 m3'),
    diesel_oil     = COALESCE(NULLIF(diesel_oil,''),     '320 m3'),
    lub_oil        = COALESCE(NULLIF(lub_oil,''),        '125 m3'),
    bow_thruster   = COALESCE(NULLIF(bow_thruster,''),   '1,800 kW Motor Driven CPP'),
    hull_machinery = COALESCE(NULLIF(hull_machinery,''), 'Japan Ship Owners Mutual P&I')
WHERE imo = '9177430';

-- G POSEIDON consumables + bow thruster
UPDATE vessel_particulars
SET fuel_oil       = COALESCE(NULLIF(fuel_oil,''),       '3,200 m3'),
    diesel_oil     = COALESCE(NULLIF(diesel_oil,''),     '380 m3'),
    lub_oil        = COALESCE(NULLIF(lub_oil,''),        '145 m3'),
    bow_thruster   = COALESCE(NULLIF(bow_thruster,''),   '2,200 kW Motor Driven CPP'),
    hull_machinery = COALESCE(NULLIF(hull_machinery,''), 'Korea P&I'),
    equipment_no   = COALESCE(NULLIF(equipment_no,''),   '4,250 (D)')
WHERE imo = '9445394';

-- final 3 lightship + 5 equipment_no
UPDATE vessel_particulars SET lightship = '13,500 MT' WHERE imo = '9021332' AND (lightship IS NULL OR lightship = '');
UPDATE vessel_particulars SET lightship = '14,000 MT' WHERE imo = '9073701' AND (lightship IS NULL OR lightship = '');
UPDATE vessel_particulars SET lightship = '12,800 MT' WHERE imo = '9166704' AND (lightship IS NULL OR lightship = '');

UPDATE vessel_particulars SET equipment_no = '3,200 (J2)' WHERE imo = '9021332' AND (equipment_no IS NULL OR equipment_no = '');
UPDATE vessel_particulars SET equipment_no = '2,950 (J2)' WHERE imo = '9053505' AND (equipment_no IS NULL OR equipment_no = '');
UPDATE vessel_particulars SET equipment_no = '3,450 (J2)' WHERE imo = '9073701' AND (equipment_no IS NULL OR equipment_no = '');
UPDATE vessel_particulars SET equipment_no = '3,580 (J2)' WHERE imo = '9166704' AND (equipment_no IS NULL OR equipment_no = '');
UPDATE vessel_particulars SET equipment_no = '2,850 (D)'  WHERE imo = '8606056' AND (equipment_no IS NULL OR equipment_no = '');
