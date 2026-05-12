DROP TABLE IF EXISTS vessel_particulars;
DROP TABLE IF EXISTS duty_assignments;

CREATE TABLE vessel_particulars (
  imo TEXT PRIMARY KEY REFERENCES vessels(imo),
  vessel_name TEXT, flag TEXT, port_of_registry TEXT, call_sign TEXT,
  official_no TEXT, mmsi TEXT, owner TEXT, manager TEXT, operator TEXT,
  p_and_i TEXT, builder TEXT, built_year TEXT, keel_laid TEXT,
  class_society TEXT, vessel_type TEXT, gt TEXT, nt TEXT, dwt TEXT,
  loa TEXT, lbp TEXT, breadth TEXT, depth TEXT,
  draft_summer TEXT, draft_tropical TEXT, draft_winter TEXT,
  main_engine TEXT, service_speed TEXT, mcr TEXT,
  fuel_oil TEXT, diesel_oil TEXT, lub_oil TEXT,
  bow_thruster TEXT, hull_machinery TEXT, equipment_no TEXT, lightship TEXT
);

CREATE TABLE duty_assignments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  team_code TEXT NOT NULL REFERENCES teams(code),
  staff_name TEXT NOT NULL, role_ko TEXT,
  duty_area TEXT NOT NULL, duty_content TEXT,
  is_essential INTEGER DEFAULT 0,
  backup_name TEXT, backup_names TEXT, remarks TEXT,
  sort_order INTEGER
);
CREATE INDEX idx_duty_team ON duty_assignments(team_code);
CREATE INDEX idx_duty_staff ON duty_assignments(staff_name);

INSERT INTO vessel_particulars (imo,vessel_name,flag,port_of_registry,call_sign,official_no,mmsi,owner,manager,operator,p_and_i,builder,built_year,keel_laid,class_society,vessel_type,gt,nt,dwt,loa,lbp,breadth,depth,draft_summer,draft_tropical,draft_winter,main_engine,service_speed,mcr,fuel_oil,diesel_oil,lub_oil,bow_thruster,hull_machinery,equipment_no,lightship) VALUES ('8606056','GMT ASTRO','PANAMA','PANAMA','3FKQ7','42783-11-A','373817000','ASTRO MARITIME SERVICES SA','DORIKO LTD','SAMJOO MARITIME CO LTD','The Japan Shipowner''s Mutual P&I Association',NULL,'1987','2010-05-10 00:00:00','DNV (IACS)','PCTC (Pure Car & Truck Carrier)','48017','26226','16141','232.39mtrs','222.40mtrs','32.26mtrs','32.64mtrs','3.02','2.812','3.228','Hyundai -Man B&W 8S60ME-C8','17.0 Knots','19040 KW / 105 r/min',NULL,NULL,NULL,NULL,NULL,NULL,'7.899');
INSERT INTO vessel_particulars (imo,vessel_name,flag,port_of_registry,call_sign,official_no,mmsi,owner,manager,operator,p_and_i,builder,built_year,keel_laid,class_society,vessel_type,gt,nt,dwt,loa,lbp,breadth,depth,draft_summer,draft_tropical,draft_winter,main_engine,service_speed,mcr,fuel_oil,diesel_oil,lub_oil,bow_thruster,hull_machinery,equipment_no,lightship) VALUES ('9021332','YOUNG SHIN','PANAMA','Panama','3ELP9','20177-92-F','356005000','YOUNG SHIN MARINE SA','DORIKO LTD','SAMJOO MARITIME CO LTD','The London P&I Club.','Oshima Shipbuilding Co., Ltd.','1992','21.09.1991','IACS','PCTC (Pure Car & Truck Carrier)','47677','14304','14274',NULL,'170 m','32.2 m',NULL,'8.818 m','9.001 m','8.635 m','MITSUBISHI DISEL 7UEC60LA(PI)','19.05 Knots','14700 kw X 110 rpm','2054.6 m3','243.9 m3','112.2 m3','1780 hp/ 1320 KW, Motor Driven, Constant RPM, Controllable Pitch Type','DB Insurance Co., Ltd.',NULL,'FWA');
INSERT INTO vessel_particulars (imo,vessel_name,flag,port_of_registry,call_sign,official_no,mmsi,owner,manager,operator,p_and_i,builder,built_year,keel_laid,class_society,vessel_type,gt,nt,dwt,loa,lbp,breadth,depth,draft_summer,draft_tropical,draft_winter,main_engine,service_speed,mcr,fuel_oil,diesel_oil,lub_oil,bow_thruster,hull_machinery,equipment_no,lightship) VALUES ('9053505','HAE SHIN','PANAMA','PANAMA','3FWI3','21266-94-D','352808000','SC MARINE SA','DORIKO LTD','SAMJOO MARITIME CO LTD',NULL,NULL,'1994','1992-01-24 00:00:00','DNV (IACS)','PCTC (Pure Car & Truck Carrier)','41931','12580','17183','195.54mtrs','185.0mtrs','28.80mtrs','12.04mtrs','3.049','2.861','3.237','Kobe Diesel ( 7UEC 60LA PI)','18.0 Knots','14700 ps ( 10810kw) x 110 rpm',NULL,NULL,NULL,NULL,NULL,NULL,'6.87');
INSERT INTO vessel_particulars (imo,vessel_name,flag,port_of_registry,call_sign,official_no,mmsi,owner,manager,operator,p_and_i,builder,built_year,keel_laid,class_society,vessel_type,gt,nt,dwt,loa,lbp,breadth,depth,draft_summer,draft_tropical,draft_winter,main_engine,service_speed,mcr,fuel_oil,diesel_oil,lub_oil,bow_thruster,hull_machinery,equipment_no,lightship) VALUES ('9073701','SANG SHIN','PANAMA','Panama','3FUX9','44328-12-A','355297000','SANG SHIN MARINE SA','DORIKO LTD','SAMJOO MARITIME CO LTD','London P&I Club','KANASASHI CO. LTD, TOYOHASHI','1994','03.09.1993','DNV (IACS)','PCTC (Pure Car & Truck Carrier)','50308','15093','16178',NULL,'170.00 m','32.26 m',NULL,'9.222 m','9.414 m','9.030 m','7 UEC 60LS Kobe Diesel','18.5 Knots @ 93 rpm','11620 kw X 97 rpm','2622.33 m3','293.46 m3','88.41 m3','1800 hp/ 1325 KW, Motor Driven, Constant RPM, Controllable Pitch Type','Lead Insurance Services Ltd.',NULL,'FWA');
INSERT INTO vessel_particulars (imo,vessel_name,flag,port_of_registry,call_sign,official_no,mmsi,owner,manager,operator,p_and_i,builder,built_year,keel_laid,class_society,vessel_type,gt,nt,dwt,loa,lbp,breadth,depth,draft_summer,draft_tropical,draft_winter,main_engine,service_speed,mcr,fuel_oil,diesel_oil,lub_oil,bow_thruster,hull_machinery,equipment_no,lightship) VALUES ('9166704','SOO SHIN','PANAMA','Panama','3E3409','54523-PEXT-1','352001129','SOO SHIN MARITIME SA','DORIKO LTD','SAMJOO MARITIME CO LTD','London P&I Club','HASHIHAMA SHIPBUILDING CO., LTD','1998','1998-05-09 00:00:00','IACS','PCTC (Pure Car & Truck Carrier)','44219','13265','13680',NULL,'170.00 m','32.20 m',NULL,'8.77 m','8.952 m','8.588 m','MITSUI MAN B&W 7S60MC(MK5)','17.5 Knots @ 92 rpm','14000 kw X 105 rpm','2680.0 m3','460.0 m3','189.0 m3','Type KT-130B1, Side thrust 14.5 tonnes @ 920 kW','Lead Insurance Services Ltd.',NULL,'FWA');
INSERT INTO vessel_particulars (imo,vessel_name,flag,port_of_registry,call_sign,official_no,mmsi,owner,manager,operator,p_and_i,builder,built_year,keel_laid,class_society,vessel_type,gt,nt,dwt,loa,lbp,breadth,depth,draft_summer,draft_tropical,draft_winter,main_engine,service_speed,mcr,fuel_oil,diesel_oil,lub_oil,bow_thruster,hull_machinery,equipment_no,lightship) VALUES ('9177430','AH SHIN','PANAMA','PANAMA','3FBO9','26157-99-D','357170000','SC FUTURE SA','DORIKO LTD','DORIKO LTD','THE JAPAN SHIPOWNER''S MUTUAL PROTECTION & INDEMNITY ASSOCIATION','IMABARI SHIPBUILDING CO., LTD. MARUGAME HEADQUARTERS','1999','02 APRIL 1998','DNV (IACS)','PCTC (Pure Car & Truck Carrier)','57449','(INTL) 17235 M/T','21503','199.94 m','187.94 m','32.20 m','34.34 m','10.066 m',NULL,NULL,NULL,'19.5 Knots',NULL,NULL,NULL,NULL,NULL,NULL,'3568 (J2)','14237 MT');
INSERT INTO vessel_particulars (imo,vessel_name,flag,port_of_registry,call_sign,official_no,mmsi,owner,manager,operator,p_and_i,builder,built_year,keel_laid,class_society,vessel_type,gt,nt,dwt,loa,lbp,breadth,depth,draft_summer,draft_tropical,draft_winter,main_engine,service_speed,mcr,fuel_oil,diesel_oil,lub_oil,bow_thruster,hull_machinery,equipment_no,lightship) VALUES ('9310678','WOORI SUN','KOREA',NULL,'D7AP',NULL,'440080000','WOORI SHIPPING CO LTD','DORIKO LTD','WOORI SHIPPING CO LTD',NULL,'IWAGI ZOSEN CO., LTD, JAPAN','2004',NULL,'KR (IACS)','BULK CARRIER','29960','18840','53576',NULL,NULL,'32.26 m','17.30 m','12.303 m','12.838 m',NULL,'HITACHI-MAN B&W 6S50MC-C','12.5 Knots','9480 KW x 127 rpm','2063.4 m3','160.9 m3',NULL,NULL,NULL,NULL,NULL);
INSERT INTO vessel_particulars (imo,vessel_name,flag,port_of_registry,call_sign,official_no,mmsi,owner,manager,operator,p_and_i,builder,built_year,keel_laid,class_society,vessel_type,gt,nt,dwt,loa,lbp,breadth,depth,draft_summer,draft_tropical,draft_winter,main_engine,service_speed,mcr,fuel_oil,diesel_oil,lub_oil,bow_thruster,hull_machinery,equipment_no,lightship) VALUES ('9418729','SJ BUSAN','KOREA','JEJU','D7KH','JJR-241024','440354000','SAMJOO MARINE CO LTD','DORIKO LTD','SAMJOO MARINE CO LTD','The London P&I Club','DAEWOO SHIPBUILDING & MARINE','2008','30 OCT 2007','KR (IACS)','BULK CARRIER','31544','18,769 Ton','55940','186.48 mtr','181.48 mtr','32.26 m','18.10 m','5.427','5.162','5.692','DU-Wartsila 6RT-flex50 x 1 set','14.0 Knots','8890 kW x 116 rpm/min',NULL,NULL,NULL,NULL,NULL,NULL,'9938 Ton');
INSERT INTO vessel_particulars (imo,vessel_name,flag,port_of_registry,call_sign,official_no,mmsi,owner,manager,operator,p_and_i,builder,built_year,keel_laid,class_society,vessel_type,gt,nt,dwt,loa,lbp,breadth,depth,draft_summer,draft_tropical,draft_winter,main_engine,service_speed,mcr,fuel_oil,diesel_oil,lub_oil,bow_thruster,hull_machinery,equipment_no,lightship) VALUES ('9445394','G POSEIDON','PANAMA','PANAMA','HP6652','42783-11-A','354149000','G POSEIDON CORP','DORIKO LTD','DORIKO LTD','London P&I Club','HYUNDAI HEAVY INDUSTRIES CO., LTD','2011','2010-05-10 00:00:00','DNV (IACS)','PCTC (Pure Car & Truck Carrier)','72408','21722','27003','232.39 m','222.40 m','32.26 m','32.64 m','10.36 m','10.566 m','10.154 m','Hyundai - MAN B&W 8S60ME-C8','19.5 Knots','19040 KW x 105 rpm',NULL,NULL,NULL,NULL,NULL,NULL,'7.899');
INSERT INTO vessel_particulars (imo,vessel_name,flag,port_of_registry,call_sign,official_no,mmsi,owner,manager,operator,p_and_i,builder,built_year,keel_laid,class_society,vessel_type,gt,nt,dwt,loa,lbp,breadth,depth,draft_summer,draft_tropical,draft_winter,main_engine,service_speed,mcr,fuel_oil,diesel_oil,lub_oil,bow_thruster,hull_machinery,equipment_no,lightship) VALUES ('9478511','SJ COLOMBO','KOREA','JEJU','D7LH','JJR-201234','440897000','SAMJOO MARITIME CO LTD','DORIKO LTD','SAMJOO MARITIME CO LTD','The London Steamship Owners, Mutual Insurance Association Limited','DAEWOO SHIPBUILDING & MARINE','2010',NULL,'KR (IACS)','BULK CARRIER','31544','18765','55989','190.00 M','185.00 M','32.26 m','18.10 m','12.85 m','13.10 m',NULL,'DU-Wartsila 6RT-flex50 x 1 set','14.0 Knots','8890 kW x 116 rpm',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO vessel_particulars (imo,vessel_name,flag,port_of_registry,call_sign,official_no,mmsi,owner,manager,operator,p_and_i,builder,built_year,keel_laid,class_society,vessel_type,gt,nt,dwt,loa,lbp,breadth,depth,draft_summer,draft_tropical,draft_winter,main_engine,service_speed,mcr,fuel_oil,diesel_oil,lub_oil,bow_thruster,hull_machinery,equipment_no,lightship) VALUES ('9304538','SJ ASIA','KOREA','JEJU','D7MD','JJR-191070','440467000','SAMJOO MARITIME CO LTD','DOUBLERICHSHIPPING LTD','SAMJOO MARITIME CO LTD',NULL,NULL,'2005',NULL,'KR (IACS)','BULK CARRIER','88494',NULL,'177477',NULL,NULL,'45.00 m','24.40 m','17.975 m','18.349 m','17.601 m','Mitsui MAN B&W 6S70 MC x 1 set','15 Knots',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO vessel_particulars (imo,vessel_name,flag,port_of_registry,call_sign,official_no,mmsi,owner,manager,operator,p_and_i,builder,built_year,keel_laid,class_society,vessel_type,gt,nt,dwt,loa,lbp,breadth,depth,draft_summer,draft_tropical,draft_winter,main_engine,service_speed,mcr,fuel_oil,diesel_oil,lub_oil,bow_thruster,hull_machinery,equipment_no,lightship) VALUES ('9610561','DAEBO GLADSTONE','PANAMA','PANAMA','3FIE9','45486-14-B','354529000','KSF GLOBAL NO 31 SA','DOUBLERICHSHIPPING LTD','DAEBO L&amp;S CO LTD',NULL,'HYUNDAI SAMHO HEAVY INDUSTRIES CO., LTD','2013','1 AUG 2013','KR (IACS)','BULK CARRIER','44102','27208','81399','229.02 m','223.00 m','32.25 m','20.10 m','14.518 m','14.820 m','14.216 m',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO vessel_particulars (imo,vessel_name,flag,port_of_registry,call_sign,official_no,mmsi,owner,manager,operator,p_and_i,builder,built_year,keel_laid,class_society,vessel_type,gt,nt,dwt,loa,lbp,breadth,depth,draft_summer,draft_tropical,draft_winter,main_engine,service_speed,mcr,fuel_oil,diesel_oil,lub_oil,bow_thruster,hull_machinery,equipment_no,lightship) VALUES ('9710517','BT TREVIA','PANAMA',NULL,'3E7848',NULL,'352006244','KSF GLOBAL NO 42 SA','DOUBLERICHSHIPPING LTD','DOUBLERICHSHIPPING LTD',NULL,'CHENGXI SHIPYARD, JIANGYIN, JIANGSU, CHINA / CX0644','2016','1ST AUG. 2013','KR (IACS)','BULK CARRIER','36332','21626','63581','199.9 M / 194.5 M / 32.26 M / 18.5 M / ABT 49.9 M (FROM KEEL TO RADAR MAST)',NULL,NULL,NULL,'S','T','W','MAKER & TYPE',NULL,NULL,'LADEN (29.5 MT)-13.50 knots',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','연제만','팀장','안전품질','• 안전품질 업무 총괄
• 중대재해처벌법 대응 총괄 (안전보건관리체계 구축/이행)
• 경영검토 총괄
• 시스템 기획 총괄
• 3자 검사 총괄
• 육/해상 내부심사 및 사고조사 총괄
• 고객 불만 사항 처리',1,'노경수','["노경수"]',NULL,1);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','노경수','감독선장','PSC','• 선박 PSC 결함 사항에 대한 부적합 보고서 검토
• Right Ship 시정조치 보고서 송부 및 종결 확인',1,'민경진','["민경진"]',NULL,2);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','노경수','감독선장','Rightship','• 각 선박 Rightship 수검 준비 점검 및 검사 지원
• RSIQ 요건에 따른 절차서/서식 제,개정',0,'민경진','["민경진"]',NULL,3);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','노경수','감독선장','위험성 평가','• 위험성평가의 필요성 식별, 보고
• 위험성 평가 및 평가서 작성
• 위험성 평가서 검토
• 위험성 등록부 작성',0,'민경진','["민경진"]',NULL,4);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','노경수','감독선장','선박 안전운항 관리','• 선박 Stability 검토 및 확인
• 화물 적부/하역 안전관리 검토
• 항해 안전 검토 (항로 계획, 기상/해상 조건)
• 선박 비상훈련(Drill) 계획 수립 및 지원
• 선박 사고 조사 및 대책 수립 지원
• 선박 안전 운항 기술적 자문 제공',0,'연제만','["연제만"]',NULL,5);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','노경수','감독선장','규정/절차서 선박 적용 검토','• 국제협약(ISM/ISPS/SOLAS) 선박 적용 검토
• 선박 플랜 검토/관리
• 절차서 현장 이행 검토 및 개선 제안
• 선박 SHQ 목표 모니터링/관리',0,'함혁','["함혁"]',NULL,6);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','노경수','감독선장','교육/훈련 관리','• 선원 승선 전/후 교육 계획 수립 및 주관
• 교육자료(PSC/Rightship/ISM 등) 작성 및 관리
• 선박 비상훈련(Drill) 시나리오 작성
• 교육 실시 결과 기록 및 보고
• 신규 승선자 교육(Safety Familiarization) 지원
• 육상직원 안전교육 지원',0,'팽철호','["팽철호"]',NULL,7);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','민경진','감독','안전/보건 관리','• 선박, 인명, 환경오염 손실관리
• 안전관리 정책 수립/개선
• 안전관리 성과 Monitoring
• 안전관리시스템 운영 개선
• 육해상 비상대응 시스템 관리
• 제안제도 관리',1,'노경수','["노경수"]',NULL,8);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','민경진','감독','선박 IT/통신 System 관리','• 선박 IT system 교육
• IT system 개발/Upgrade/Maintenance
• IT system 업체 관리
• 선박 통신 시스템 관리
• 선박 통신 시스템 오류 해결 지원
• 선박 사이버 보안 관리 (IMO 2021 Cyber Risk Management 체계 운영)
• 사이버 보안 정책 수립 및 선대 이행 점검',0,'팽철호','["팽철호"]',NULL,9);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','민경진','감독','해사 정책/규정 관리','• 기국 규정 및 Circular 관리 (환경 제외)
• 보장증서(BCC, WRC 등) 발급/관리
• 국내외 규정/법규 변경 사항 관리 (환경/탄소규제 제외)',0,'함혁','["함혁"]',NULL,10);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','민경진','감독','시스템 유지/관리','• 국제 표준(ISO 9001/14001/45001) 유지/관리
• 관련 프로세스와 절차서의 개정
• 회사 증서 및 절차서/계획서 관리
• 사 회의체 운영',0,'함혁','["함혁"]',NULL,11);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','민경진','감독','심사','• 연간 내/외부심사계획서 작성
• 외부심사 신청 및 심사 참관
• 회사 내부 심사 주관
• 선박 내부 심사 주관
• 심사 지적 사항 종결 관리',0,'노경수','["노경수"]',NULL,12);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','민경진','감독','선박 보안 관리','• 선박 보안 평가
• 선박 보안 계획서 작성
• 선박 보안 정보 제공
• 선박 보안 통신 관리
• 선박 보안 장비의 관리
• 해적방지지침 유지/관리',0,'노경수','["노경수"]',NULL,13);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','민경진','감독','선박 인수/인도','• 선박인수일람표 작성
• 가국적증서, 가무선국증서 발급 절차
• 등록 및 국적증서, 무선국증서 발급
• 해상운송사업면허 변경
• 외항선자격 변경
• 안전관리대행업 등록
• 국제선박 등록
• ISM/ISPS 심사 및 증서 발급
• 인수 초기 물품 보급
• 선박 초기 시스템 정착 및 심사 지원',0,'함혁','["함혁"]',NULL,14);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','함혁','감독','환경 관리','• MARPOL 이행 관리
• 선박 환경설비(BWMS, Scrubber 등) 관리
• 환경오염 예방 및 사고 대응',1,'민경진','["민경진"]',NULL,15);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','함혁','감독','CII 관리','• 연간 CII 등급 산출 및 모니터링
• SEEMP Part III 작성/이행 점검
• CII 개선계획 수립/관리',0,'팽철호','["팽철호"]',NULL,16);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','함혁','감독','IMO DCS 관리','• IMO DCS 연료소모량 데이터 수집/검증
• 연간 보고서 작성 및 기국 제출
• SoC 발급/관리',0,'팽철호','["팽철호"]',NULL,17);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','함혁','감독','EU ETS / FuelEU','• EU ETS 배출권(EUA) 관리 및 제출
• MRV 보고서 관리
• FuelEU Maritime 준수 모니터링/보고',0,'민경진','["민경진"]',NULL,18);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','함혁','감독','EEXI / EEDI 관리','• EEXI 적합성 관리 및 증서 유지
• EEDI 검증 및 기술파일 관리
• 기술적 저감조치(EPL 등) 관리',0,'민경진','["민경진"]',NULL,19);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','함혁','감독','환경 규정 관리','• IMO MEPC 결의사항 모니터링 및 선박 적용 검토
• 환경 관련 국제협약/규제 변경사항 관리
• 탄소규제 동향 분석 및 대응전략 수립',0,'민경진','["민경진"]',NULL,20);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','팽철호','감독','문서/기록 관리','• 사매뉴얼과 절차서, 지침서 종합 관리
• 시스템 문서관리 (내부 결재 승인/선박배포/서버폴더,팀즈 업데이트)
• 기록 및 파일관리
• 선박 보고서 관리',1,'민경진','["민경진"]',NULL,21);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','팽철호','감독','안전품질팀 데이터 관리','• 내/외부 심사 부적합 사항 관리/분석 (매월 관리본부 송부)
• PSC 부적합 사항 관리/분석 (매월 관리본부 송부)
• Rightship Finding 사항 관리/분석 (분기별 관리본부 송부)
• 선박 사고 데이터 관리',0,'함혁','["함혁"]',NULL,22);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','팽철호','감독','기타','• 해사 관련 정보 수집
• 매뉴얼 개정사항 송부
• PSC 결함 사항에 대한 각 선박 시정조치 요청
• 기국 보고 확인 및 증빙 취합
• 해도, 수로서지 등 보급 지원',0,'노경수','["노경수"]',NULL,23);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','팽철호','감독','Near-miss 관리','• Near-miss(아차사고) 보고 접수 및 관리
• Near-miss 사례 통계/분석 및 트렌드 관리
• 재발방지 대책 수립 및 선대 전파
• 우수 보고 포상 제도 운영',0,'민경진','["민경진"]',NULL,24);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','팽철호','감독','선급/증서 관리','• 선급(KR, LR, DNV 등) 커뮤니케이션 창구
• 선급 검사 일정 관리 및 수검 지원
• 법정/선급 증서 유효기간 관리 및 갱신
• KR-CON 등 선급 규정 동향 모니터링',0,'함혁','["함혁"]',NULL,25);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('SQT','팽철호','감독','변경관리 (MOC)','• 변경관리(Management of Change) 절차 운영
• 선박/시스템/조직 변경사항 위험성 검토
• 변경 승인 및 이행 결과 추적
• 변경 이력 기록/관리',0,'노경수','["노경수"]',NULL,26);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','선내 불만 처리','- 선원 관리 총괄
- 선원 선내불만처리 총괄
- 마약 및 알코올 통제 총괄',1,'전정환','["전정환"]',NULL,27);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','채용 및 교대','- 월별 선원 채용/교대 계획 작성
- 연간선원 채용 계획 수립
- 분기별 선원 채용 계획서 작성
- 선원 채용과정 준비 및 시행
   (서류전형, 면담평가, 선내공용어 능력 평가, 신체검사)
- 선원 입사서류를 포함한 모든 기록 관리
- 교대 계획 수립 및 교대의 통보
- 승선자 준비 점검 (자격 및 증서 점검)
- 하선자 준비 점검 (자격 및 증서 점검)
- 선원의 동승 검토
- 초임사관 선발 및 채용, 면접
- 장학생/실습생 선발 및 채용, 면접',0,'전정환','["전정환", "이정은"]',NULL,28);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','진급, 징계 및 
퇴직','1. 선원 인사위원회 심사
- 선원 진급/승진 심사
- 선원 징계 심사

2. 퇴직자 관리
- 퇴직자 발생 예방 조치
- 재직율에 대한 연간 달성목표 KPI 수립 및 관리',0,'전정환','["전정환", "이정은"]',NULL,29);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','상병관리 및
의료지원','- P&I 및 선주사 통보
- 상병자 상황 파악
- 보상 및 상병비 지급
- 발생 비용 내역 정리 및 Invoice 발행',0,'이정은','["이정은", "임수현"]',NULL,30);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','선원관리사 및
외국선원관리','- 선원 관리사 Audit 시행',0,'전정환','["전정환"]',NULL,31);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','선원의 교육
및 훈련','- 법정 교육 및 증서 관리
- 사내/사외/심화 교육 관리 및 평가
- 사내 세미나 및 포럼
- 선원의 브리핑 및 브리핑 받기
- 휴가 중 교육훈련의 계획 수립',0,'이정은','["이정은", "이의진"]',NULL,32);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','선내 교육훈련','- 승무원 법정자격 및 교육 현황표 분기별 기록 관리',0,'이의진','["이의진"]',NULL,33);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','평가','- 업무 숙련도 및 업무수행능력평가',0,'전정환','["전정환", "이정은"]',NULL,34);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','마약 및 알코올
통제','- 마약 및 알코올 통제 및 감독',0,'전정환','["전정환", "이정은"]',NULL,35);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','근로 및 
휴식시간','- 근로/휴식시간 기록부 및 근로/휴식 및 시간외 근로시간 기록장부와 
  Deviation log 검토 및 이상 별견시 원인 분석 및 조치',0,'이정은','["이정은", "이의진"]',NULL,36);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','주부식 및 
사주 업무 관리','- 매월 주부식 위원회 결과 검토',0,'전정환','["전정환"]',NULL,37);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','복리후생','- 보상체계, 복지제도 검토 및 개선',0,'전정환','["전정환"]',NULL,38);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','대 선박 관리','- 방선 업무',0,'전정환','["전정환"]',NULL,39);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','대 관청 업무','- 근로감독 수검 및 관리
- 선박 관리 신고 사항 업무
- 노사정책 기초자료 검토 및 자료수집
- 노무관련 법규정 검토 및 대응
- 병무 업무 (실태조사 수검 및 편입, 복무관리)',0,'전정환','["전정환", "임수현"]',NULL,40);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','전산화
프로그램 관리','- 전산화 프로그램 기록 관리',0,'이정은','["이정은", "이의진"]',NULL,41);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','시스템 
유지/관리','- SHQE 문서의 개정/관리
- 팀내 부적합/개선사항 발행
- 해상인력관리실 경영검토 작성',0,'전정환','["전정환"]',NULL,42);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','원훈희','팀장','대외 업무','- 홍보 업무
- 관련업체 관리 및 감독',0,'전정환','["전정환", "이정은"]',NULL,43);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','전정환','감독','채용 및 교대','- 담당선박 : PCC선대 필리핀 선원 승선 선박
- 선원 교대 계획 수립 보조
- 연간/분기별 선원 채용 계획서 작성 보조
- 해상직원 채용과정 준비 보조
- ERP 입력 및 관리 보조
- 승선자/하선자 자격 및 증서 관리 보조',1,'원훈희','["원훈희"]',NULL,44);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','전정환','감독','해상직원 
교대관리','- 선원 황열 접종 및 신체 검사 보조
- 기국면허 신청 및 비자 발급 보조
- 선원수첩, 여권 및 각종 증서 발급 보조
- 승,하선자 점검표 작성 보조
- 임명장 발급 보조
- 신규승선자 대상 친숙화 CHECK LIST 작성 보조
- 신규 승선자 업무 숙련도 평가서 관리 보조',0,'원훈희','["원훈희"]',NULL,45);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','전정환','감독','해상직원
교육훈련','- 사내교육, 사외교육 관리
- 정기 집체 교육(교육계획 및 결과보고)
- 해상인력관리실 육상직원 교육 관리
- 월간교육일정표 작성
- 교육대상자에게 통보, 교육일정 주관
- 평가, 기록, 교육내용 등록',0,'이정은','["이정은"]',NULL,46);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','전정환','감독','대 관청업무','- 선원 승/하선 공인 (외국인 선원 포함)
- 수산청 자격증/면허 발급 업무 보조
- 선원선박관리신고 보조
  (증선 및 감선 신고)',0,'이의진','["이의진"]',NULL,47);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','전정환','감독','병무청','- 승선근무예비역 관리 (편입/승하선관리 등)
- 실태조사 시행',0,'이정은','["이정은"]',NULL,48);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','전정환','감독','대 선박관리','- 해상직원 고과관리 보조
- 하선/계승 신청서 관리 보조
- PCC 선대 마약&알코올 불시점검 보조
-  WORKING AND REST HOUR 관리 보조',0,'원훈희','["원훈희"]',NULL,49);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','전정환','감독','CBT 교육 관리','- 선원 교육 관리 보조',0,'이의진','["이의진"]',NULL,50);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','전정환','감독','대 선박관리','- 해상인력관리실 월말/분기/반기/연간 서류 관리 보조',0,'이의진','["이의진"]',NULL,51);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','임수현','대리','해상직원
급여','- 해상직원 급여, 후불성 급여 관리 
- 외국인 선원 급여, 대리점료의 송금',1,'원훈희','["원훈희"]',NULL,52);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','임수현','대리','해상직원 
교대관리','- 선원 교대 비용 송금 및 예산 반영
- 선원 신체검사 예약 관리',0,'원훈희','["원훈희"]',NULL,53);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','임수현','대리','대 선박관리','- 선박 경비 집행보고서 (검토, 품의서 작성 등)
- 수당 집행 (특별 수당 집행)
- 선용금 청구 및 송금 관리
- 선박관리 지출 품의(부산 사무소)',0,'원훈희','["원훈희"]',NULL,54);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','임수현','대리','대 관청 업무','- 선박 관리업 협회 실적 보고',0,'원훈희','["원훈희"]',NULL,55);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','임수현','대리','전산화
프로그램 관리','- 가족관계
- 사급품 관리',0,'원훈희','["원훈희", "이정은"]',NULL,56);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','임수현','대리','복리후생','- 자녀 학자금
- 경조사 관리
- 육상직/해상직 호텔예약',0,'원훈희','["원훈희", "이정은"]',NULL,57);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','임수현','대리','보급관리','- 해상직원 작업복 신청 및 보급',0,'이의진','["이의진"]',NULL,58);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','이정은','대리','채용 및 교대','- 담당선대 :  PCC  선대 러시아 선원 승선 선박
- 선원 교대 계획 수립 보조
- 연간/분기별 선원 채용 계획서 작성 및 보고
- 해상직원 채용과정 준비 및 보고
- ERP 입력 및 관리
- 승선자/하선자 자격 및 증서 관리 및 보고',1,'원훈희','["원훈희"]',NULL,59);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','이정은','대리','해상직원 
교대관리','- 선원 황열 접종 및 신체 검사
- 기국면허 신청 및 비자 발급
- 선원수첩, 여권 및 각종 증서 발급 및 관리
- 승,하선자 점검표 작성
- ECDIS 교육 예약
- 임명장 발급 및 보급
- 신규승선자 대상 친숙화 CHECK LIST 관리
- 신규 승선자 업무 숙련도 평가서 관리',0,'이의진','["이의진"]',NULL,60);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','이정은','대리','대 관청업무','- 선원/선박 관련 제증서 발급 업무
   (MSMC, 임금채권보장기금, 외국인TO운영승인서)
- 선원선박관리신고
  (증선 및 감선 신고)',0,'이의진','["이의진"]',NULL,61);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','이정은','대리','대 선박관리','- 해상직원 고과관리 및 보고 (업무숙련도평가서, 인사고과 등)
- 하선/계승 신청서 관리 및 보고
- PCC 선대 마약&알코올 불시점검 관리
-  WORKING AND REST HOUR 관리',0,'이의진','["이의진"]',NULL,62);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','이정은','대리','노조 업무','- 노조비 관리
- ITF 단체협약 관리 및 갱신',0,'임수현','["임수현"]',NULL,63);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','이정은','대리','전산화
프로그램 관리','- 신규입사자/기초데이터 및 증서/법정교육 (+외국 해상직원)',0,'이의진','["이의진"]',NULL,64);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','이의진','대리','해상직원
교육훈련','- 사내교육, 사외교육 관리
- 정기 집체 교육(교육계획 및 결과보고)
- 해상인력관리실 육상직원 교육 관리
- 월간교육일정표 작성
- 교육대상자에게 통보, 교육일정 주관
- 평가, 기록, 교육내용 등록',1,'이정은','["이정은"]',NULL,65);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','이의진','대리','전산화
프로그램 관리','- 신규입사자/기초데이터 및 증서/법정교육 (+외국 해상직원)',0,'이정은','["이정은"]',NULL,66);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','이의진','대리','CBT 교육 관리','- 선원 계정 생성
- 매달 교육 수강 이력 확인
- 최소 설치 및 사용 방법 안내
- 프로그램 사용 시 SUPPORT
- 교육 수료증 발급',0,'이정은','["이정은"]',NULL,67);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','이의진','대리','대 관청업무','- 선원 승.하선 공인 (외국인 선원 포함)
- 각종 자격증/면허 발급 업무',0,'전정환','["전정환"]',NULL,68);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','이의진','대리','대 선박관리','- MONTHLY REOPORT, QUETERLY REPORT, 
  WORKING AND REST HOUR 등 CMD REPORT 관리 
- 해상직원 고과관리 및 보고 (업무숙련도평가서, 인사고과 등)
- 하선/계승 신청서 관리 및 보고
- 마약&알코올 불시점검 관리 
- 승선 허가서 신청
- Rightship Inspection 지원
  (해상직원 필요 증서 Update, 마약&알코올 불시점검 관리 등)',0,'전정환','["전정환", "이정은"]',NULL,69);
INSERT INTO duty_assignments (team_code,staff_name,role_ko,duty_area,duty_content,is_essential,backup_name,backup_names,remarks,sort_order) VALUES ('CMT','이의진','대리','보급관리','- 한국선원 ID CARD 발급 및 보급 (외국선원 MANNING 진행)
- 해도 및 법정도서 보급
- 위생용품 보급
- 문서 수발신 및 선박보급',0,'이정은','["이정은"]',NULL,70);