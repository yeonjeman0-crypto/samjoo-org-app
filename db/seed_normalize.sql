-- ============================================================
-- seed_normalize.sql · normalize imported vessel particulars
-- ============================================================
-- 목적:
--  - 같은 제원 칸에서 PANAMA/Panama, M/mtr/mtrs처럼 섞여 보이지 않게 한다.
--  - 선명/기국/항적 같은 고유명사는 대문자 기준으로 맞춘다.
--  - 길이/흘수 단위는 SI 표기인 소문자 "m"으로 통일한다.
--  - 날짜는 YYYY-MM-DD로 통일한다.

-- Countries / registry ports
UPDATE vessel_particulars
SET flag = CASE
  WHEN UPPER(flag) LIKE '%PANAMA%' THEN 'PANAMA'
  WHEN UPPER(flag) LIKE '%KOREA%'  THEN 'KOREA'
  ELSE UPPER(TRIM(flag))
END
WHERE flag IS NOT NULL AND TRIM(flag) <> '';

UPDATE vessel_particulars
SET port_of_registry = CASE
  WHEN UPPER(port_of_registry) LIKE '%PANAMA%' THEN 'PANAMA'
  WHEN UPPER(port_of_registry) LIKE '%JEJU%'   THEN 'JEJU'
  WHEN UPPER(port_of_registry) LIKE '%KOREA%'  THEN 'KOREA'
  ELSE UPPER(TRIM(port_of_registry))
END
WHERE port_of_registry IS NOT NULL AND TRIM(port_of_registry) <> '';

-- Vessel names / call signs are identifiers.
UPDATE vessel_particulars
SET vessel_name = UPPER(TRIM(vessel_name))
WHERE vessel_name IS NOT NULL AND TRIM(vessel_name) <> '';

UPDATE vessel_particulars
SET call_sign = UPPER(TRIM(call_sign))
WHERE call_sign IS NOT NULL AND TRIM(call_sign) <> '';

-- Proper noun / identifier fields shown in particulars.
UPDATE vessel_particulars
SET owner = UPPER(REPLACE(TRIM(owner), '&amp;', '&'))
WHERE owner IS NOT NULL AND TRIM(owner) <> '';

UPDATE vessel_particulars
SET manager = UPPER(REPLACE(TRIM(manager), '&amp;', '&'))
WHERE manager IS NOT NULL AND TRIM(manager) <> '';

UPDATE vessel_particulars
SET operator = UPPER(REPLACE(TRIM(operator), '&amp;', '&'))
WHERE operator IS NOT NULL AND TRIM(operator) <> '';

UPDATE vessel_particulars
SET p_and_i = UPPER(REPLACE(TRIM(p_and_i), '&amp;', '&'))
WHERE p_and_i IS NOT NULL AND TRIM(p_and_i) <> '';

UPDATE vessel_particulars
SET builder = UPPER(REPLACE(TRIM(builder), '&amp;', '&'))
WHERE builder IS NOT NULL AND TRIM(builder) <> '';

UPDATE vessel_particulars
SET p_and_i = RTRIM(p_and_i, '.')
WHERE p_and_i IS NOT NULL AND TRIM(p_and_i) <> '';

UPDATE vessel_particulars
SET builder = RTRIM(builder, '.')
WHERE builder IS NOT NULL AND TRIM(builder) <> '';

UPDATE vessel_particulars
SET main_engine = UPPER(REPLACE(REPLACE(TRIM(main_engine), '&amp;', '&'), 'DISEL', 'DIESEL'))
WHERE main_engine IS NOT NULL AND TRIM(main_engine) <> '';

UPDATE vessel_rightship
SET doc_company = UPPER(REPLACE(TRIM(doc_company), '&amp;', '&')),
    commercial_manager = UPPER(REPLACE(TRIM(commercial_manager), '&amp;', '&')),
    technical_manager = UPPER(REPLACE(TRIM(technical_manager), '&amp;', '&')),
    commercial_operator = UPPER(REPLACE(TRIM(commercial_operator), '&amp;', '&')),
    beneficial_owner = UPPER(REPLACE(TRIM(beneficial_owner), '&amp;', '&')),
    registered_owner_rs = UPPER(REPLACE(TRIM(registered_owner_rs), '&amp;', '&')),
    statcode5 = UPPER(TRIM(statcode5)),
    lead_sister_ship = UPPER(TRIM(lead_sister_ship));

-- Keel laid dates from RightShip are DD/MM/YYYY; output uses ISO YYYY-MM-DD.
UPDATE vessel_particulars SET keel_laid = '1986-06-27' WHERE imo = '8606056';
UPDATE vessel_particulars SET keel_laid = '1991-09-02' WHERE imo = '9021332';
UPDATE vessel_particulars SET keel_laid = '1992-01-24' WHERE imo = '9053505';
UPDATE vessel_particulars SET keel_laid = '1993-09-03' WHERE imo = '9073701';
UPDATE vessel_particulars SET keel_laid = '1998-05-09' WHERE imo = '9166704';
UPDATE vessel_particulars SET keel_laid = '1998-04-02' WHERE imo = '9177430';
UPDATE vessel_particulars SET keel_laid = '2004-12-01' WHERE imo = '9304538';
UPDATE vessel_particulars SET keel_laid = '2004-04-21' WHERE imo = '9310678';
UPDATE vessel_particulars SET keel_laid = '2007-10-30' WHERE imo = '9418729';
UPDATE vessel_particulars SET keel_laid = '2010-05-10' WHERE imo = '9445394';
UPDATE vessel_particulars SET keel_laid = '2009-08-25' WHERE imo = '9478511';
UPDATE vessel_particulars SET keel_laid = '2013-08-01' WHERE imo = '9610561';
UPDATE vessel_particulars SET keel_laid = '2015-10-28' WHERE imo = '9710517';

-- Main engine model text cleanup after uppercasing.
UPDATE vessel_particulars SET main_engine = 'HYUNDAI-MAN B&W 8S60ME-C8' WHERE imo IN ('8606056', '9445394');
UPDATE vessel_particulars SET main_engine = 'MITSUBISHI DIESEL 7UEC60LA (PI)' WHERE imo = '9021332';
UPDATE vessel_particulars SET main_engine = 'KOBE DIESEL 7UEC60LA PI' WHERE imo = '9053505';
UPDATE vessel_particulars SET main_engine = 'KOBE DIESEL 7UEC60LS' WHERE imo = '9073701';
UPDATE vessel_particulars SET main_engine = 'MITSUI MAN B&W 7S60MC (MK5)' WHERE imo = '9166704';
UPDATE vessel_particulars SET main_engine = 'MITSUI MAN B&W 7S60MC' WHERE imo = '9177430';
UPDATE vessel_particulars SET main_engine = 'MITSUI MAN B&W 6S70MC X 1 SET' WHERE imo = '9304538';
UPDATE vessel_particulars SET main_engine = 'HITACHI-MAN B&W 6S50MC-C' WHERE imo = '9310678';
UPDATE vessel_particulars SET main_engine = 'DU-WARTSILA 6RT-FLEX50 X 1 SET' WHERE imo IN ('9418729', '9478511');
UPDATE vessel_particulars SET main_engine = 'MAN B&W 6S60ME-C8' WHERE imo = '9610561';
UPDATE vessel_particulars SET main_engine = 'MAN B&W 6S50ME-B9.3' WHERE imo = '9710517';

-- Unit fixes by vessel for imported rows that used mtr/mtrs/M or omitted draft units.
UPDATE vessel_particulars
SET draft_summer = '3.020 m',
    draft_tropical = '2.812 m',
    draft_winter = '3.228 m',
    service_speed = '17.0 knots',
    mcr = '19,040 kW / 105 rpm',
    lightship = '12,500 MT'
WHERE imo = '8606056';

UPDATE vessel_particulars
SET lbp = '170.00 m',
    breadth = '32.20 m',
    service_speed = '19.05 knots',
    mcr = '14,700 kW x 110 rpm',
    lightship = '13,500 MT'
WHERE imo = '9021332';

UPDATE vessel_particulars
SET loa = '195.54 m',
    lbp = '185.00 m',
    breadth = '28.80 m',
    depth = '12.04 m',
    draft_summer = '3.049 m',
    draft_tropical = '2.861 m',
    draft_winter = '3.237 m',
    service_speed = '18.0 knots',
    mcr = '14,700 PS (10,810 kW) x 110 rpm',
    lightship = '6,870 MT'
WHERE imo = '9053505';

UPDATE vessel_particulars
SET service_speed = '18.5 knots @ 93 rpm',
    mcr = '11,620 kW x 97 rpm',
    lightship = '14,000 MT'
WHERE imo = '9073701';

UPDATE vessel_particulars
SET service_speed = '17.5 knots @ 92 rpm',
    mcr = '14,000 kW x 105 rpm',
    lightship = '12,800 MT'
WHERE imo = '9166704';

UPDATE vessel_particulars
SET service_speed = '19.5 knots',
    mcr = '13,310 kW x 92 rpm',
    lightship = '14,237 MT'
WHERE imo = '9177430';

UPDATE vessel_particulars
SET service_speed = '12.5 knots',
    mcr = '9,480 kW x 127 rpm',
    lightship = '8,500 MT'
WHERE imo = '9310678';

UPDATE vessel_particulars
SET loa = '186.48 m',
    lbp = '181.48 m',
    draft_summer = '5.427 m',
    draft_tropical = '5.162 m',
    draft_winter = '5.692 m',
    service_speed = '14.0 knots',
    mcr = '8,890 kW x 116 rpm',
    lightship = '9,938 MT'
WHERE imo = '9418729';

UPDATE vessel_particulars
SET service_speed = '19.5 knots',
    mcr = '19,040 kW x 105 rpm',
    lightship = '7,899 MT'
WHERE imo = '9445394';

UPDATE vessel_particulars
SET loa = '190.00 m',
    lbp = '185.00 m',
    service_speed = '14.0 knots',
    mcr = '8,890 kW x 116 rpm',
    lightship = '9,950 MT'
WHERE imo = '9478511';

UPDATE vessel_particulars
SET service_speed = '15.0 knots',
    mcr = '20,800 kW x 91 rpm',
    lightship = '22,500 MT'
WHERE imo = '9304538';

UPDATE vessel_particulars
SET service_speed = '14.5 knots',
    mcr = '11,470 kW x 89 rpm',
    lightship = '14,500 MT'
WHERE imo = '9610561';

UPDATE vessel_particulars
SET service_speed = '14.0 knots',
    mcr = '7,500 kW x 99 rpm',
    lightship = '11,200 MT'
WHERE imo = '9710517';
