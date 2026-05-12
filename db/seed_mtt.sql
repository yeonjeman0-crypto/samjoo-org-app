-- ============================================================
-- MTT (공무팀) duty assignments  ·  Rev. 2026.05.08
-- Source: 공무팀 개인별 업무분장.Rev2026.05.08.xlsx
-- ============================================================
DELETE FROM duty_assignments WHERE team_code = 'MTT';

INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최우종', '팀장', '공무팀', '• 경영검토
- 경영검토 자료 작성, 제출
- 자료수집 분석/배부
- 경영검토 회의 참석/ 의결', 1, '박해민', 1);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최우종', '팀장', '해상직원관리', '•해상직원관리
- 해상 직원 채용 시 면접
- 선원교대계획서 검토
- 선기장 하선 인사고과', 0, '', 2);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최우종', '팀장', '정비', '• 감독진행업무 검토 및 승인', 0, '', 3);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최우종', '팀장', '구매/보급', '• 감독진행업무 검토 및 승인', 0, '', 4);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최우종', '팀장', '협력업체
관리', '• 감독진행업무 검토 및 승인', 0, '', 5);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최우종', '팀장', '외부 검사 및
심사', '• 감독진행업무 검토 및 승인', 0, '', 6);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최우종', '팀장', '안전/보건
관리', '• 감독진행업무 검토 및 승인', 0, '', 7);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최우종', '팀장', '관리 선박의
인수 및 인도', '• 감독진행업무 검토 및 승인', 0, '', 8);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최우종', '팀장', '위험성
평가', '• 감독진행업무 검토 및 승인', 0, '', 9);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '박해민', '감독', '시스템
유지/관리', '• 국제 협약(ISM/ISPS) 유지/관리
• 국제 표준(ISO 9001/14001/45001) 유지/관리
• 관련 프로세스와 절차서의 개정
• 선박 SHQE 목표 모니터링/관리
• 회사 증서 및 절차서/계획서 관리
• 사 회의체 운영', 1, '최우종', 10);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '박해민', '감독', '해사 정책
/규정 검토', '• 국제협약(MSC/MEPC 등), 국내외 규정/법규 검토 및 관리
• 기국 규정 관리 및 Circular 관리
• 선박 플랜 제작/관리
• 보장증서(BCC, WRC 등) 발급/관리', 0, '', 11);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '박해민', '감독', '문서/기록
관리', '• 시스템 문서 작성/검토
• 사매뉴얼과 절차서, 지침서 종합관리', 0, '', 12);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '박해민', '감독', '협력업체
관리', '• 공급업체 선정/평가를 위한 자료, 검토, 분석
• 공급업체 선정 평가서 작성
• 부적합보고서에 대한 조치
• 공급업체 평가서 작성
• 공급업체 말소사유서 작성', 0, '', 13);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '박해민', '감독', '정비', '• 선비 예산 편성 및 실적 관리
• 입항지원 계획 수립/ 시행 및 결과 보고
• 선박 방선 계획 수립/ 시행 및 결과 보고
• 선박 보수정비 계획(연간, 월간) 수립 및 시행
• 선박 PMS 관리
• 중대설비 식별 및 위험성평가
• 중대설비 성능 유지
• 선박 Inventory 관리
• 수리신청서 검토, 견적, 승인
• 외주수리 진행, 감독, 측정, 종결
• 입거수리신청서 검토, 견적
• 입거수리 사양서 작성, 품의서 작성
• 입거수리 집행, 감독, 측정, 종결
• 외지수리 관세', 1, '최광식', 14);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '이주원', '감독', '정비', '• 선비 예산 편성 및 실적 관리
• 입항지원 계획 수립/ 시행 및 결과 보고
• 선박 방선 계획 수립/ 시행 및 결과 보고
• 선박 보수정비 계획(연간, 월간) 수립 및 시행
• 선박 PMS 관리
• 중대설비 식별 및 위험성평가
• 중대설비 성능 유지
• 선박 Inventory 관리
• 수리신청서 검토, 견적, 승인
• 외주수리 진행, 감독, 측정, 종결
• 입거수리신청서 검토, 견적
• 입거수리 사양서 작성, 품의서 작성
• 입거수리 집행, 감독, 측정, 종결
• 외지수리 관세', 0, '권순범', 15);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최광식', '감독', '정비', '• 선비 예산 편성 및 실적 관리
• 입항지원 계획 수립/ 시행 및 결과 보고
• 선박 방선 계획 수립/ 시행 및 결과 보고
• 선박 보수정비 계획(연간, 월간) 수립 및 시행
• 선박 PMS 관리
• 중대설비 식별 및 위험성평가
• 중대설비 성능 유지
• 선박 Inventory 관리
• 수리신청서 검토, 견적, 승인
• 외주수리 진행, 감독, 측정, 종결
• 입거수리신청서 검토, 견적
• 입거수리 사양서 작성, 품의서 작성
• 입거수리 집행, 감독, 측정, 종결
• 외지수리 관세', 0, '박해민', 16);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '김동현', '감독', '정비', '• 선비 예산 편성 및 실적 관리
• 입항지원 계획 수립/ 시행 및 결과 보고
• 선박 방선 계획 수립/ 시행 및 결과 보고
• 선박 보수정비 계획(연간, 월간) 수립 및 시행
• 선박 PMS 관리
• 중대설비 식별 및 위험성평가
• 중대설비 성능 유지
• 선박 Inventory 관리
• 수리신청서 검토, 견적, 승인
• 외주수리 진행, 감독, 측정, 종결
• 입거수리신청서 검토, 견적
• 입거수리 사양서 작성, 품의서 작성
• 입거수리 집행, 감독, 측정, 종결
• 외지수리 관세', 0, '팽철호', 17);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '권순범', '감독', '정비', '• 선비 예산 편성 및 실적 관리
• 입항지원 계획 수립/ 시행 및 결과 보고
• 선박 방선 계획 수립/ 시행 및 결과 보고
• 선박 보수정비 계획(연간, 월간) 수립 및 시행
• 선박 PMS 관리
• 중대설비 식별 및 위험성평가
• 중대설비 성능 유지
• 선박 Inventory 관리
• 수리신청서 검토, 견적, 승인
• 외주수리 진행, 감독, 측정, 종결
• 입거수리신청서 검토, 견적
• 입거수리 사양서 작성, 품의서 작성
• 입거수리 집행, 감독, 측정, 종결
• 외지수리 관세', 0, '이주원', 18);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '팽철호', '감독', '정비', '• 선비 예산 편성 및 실적 관리
• 입항지원 계획 수립/ 시행 및 결과 보고
• 선박 방선 계획 수립/ 시행 및 결과 보고
• 선박 보수정비 계획(연간, 월간) 수립 및 시행
• 선박 PMS 관리
• 중대설비 식별 및 위험성평가
• 중대설비 성능 유지
• 선박 Inventory 관리
• 수리신청서 검토, 견적, 승인
• 외주수리 진행, 감독, 측정, 종결
• 입거수리신청서 검토, 견적
• 입거수리 사양서 작성, 품의서 작성
• 입거수리 집행, 감독, 측정, 종결
• 외지수리 관세', 0, '김동현', 19);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '박해민', '감독', '구매/보급', '• 접수, 견적의뢰, 사정
• 보급승인
• 발주, 본선통보, 보급
• 검수 및 검수보고서 제출
• 연료유/윤활유 청구량 및 사양 검토
• 연료유/윤활유 검수인 수배여부 검토
• 연료유/윤활유 검수인 수배 승인
• 연료유/윤활유 분석업무 주관
• 재고목록표 검토
• 선용품, 기부속 비 집행 실적 분석
• 익년도 선용품, 기부속 비 예산 수립', 0, '최광식', 20);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '이주원', '감독', '구매/보급', '• 접수, 견적의뢰, 사정
• 보급승인
• 발주, 본선통보, 보급
• 검수 및 검수보고서 제출
• 연료유/윤활유 청구량 및 사양 검토
• 연료유/윤활유 검수인 수배여부 검토
• 연료유/윤활유 검수인 수배 승인
• 연료유/윤활유 분석업무 주관
• 재고목록표 검토
• 선용품, 기부속 비 집행 실적 분석
• 익년도 선용품, 기부속 비 예산 수립', 0, '권순범', 21);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최광식', '감독', '구매/보급', '• 접수, 견적의뢰, 사정
• 보급승인
• 발주, 본선통보, 보급
• 검수 및 검수보고서 제출
• 연료유/윤활유 청구량 및 사양 검토
• 연료유/윤활유 검수인 수배여부 검토
• 연료유/윤활유 검수인 수배 승인
• 연료유/윤활유 분석업무 주관
• 재고목록표 검토
• 선용품, 기부속 비 집행 실적 분석
• 익년도 선용품, 기부속 비 예산 수립', 0, '박해민', 22);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '김동현', '감독', '구매/보급', '• 접수, 견적의뢰, 사정
• 보급승인
• 발주, 본선통보, 보급
• 검수 및 검수보고서 제출
• 연료유/윤활유 청구량 및 사양 검토
• 연료유/윤활유 검수인 수배여부 검토
• 연료유/윤활유 검수인 수배 승인
• 연료유/윤활유 분석업무 주관
• 재고목록표 검토
• 선용품, 기부속 비 집행 실적 분석
• 익년도 선용품, 기부속 비 예산 수립', 0, '팽철호', 23);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '권순범', '감독', '구매/보급', '• 접수, 견적의뢰, 사정
• 보급승인
• 발주, 본선통보, 보급
• 검수 및 검수보고서 제출
• 연료유/윤활유 청구량 및 사양 검토
• 연료유/윤활유 검수인 수배여부 검토
• 연료유/윤활유 검수인 수배 승인
• 연료유/윤활유 분석업무 주관
• 재고목록표 검토
• 선용품, 기부속 비 집행 실적 분석
• 익년도 선용품, 기부속 비 예산 수립', 0, '이주원', 24);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '팽철호', '감독', '구매/보급', '• 접수, 견적의뢰, 사정
• 보급승인
• 발주, 본선통보, 보급
• 검수 및 검수보고서 제출
• 연료유/윤활유 청구량 및 사양 검토
• 연료유/윤활유 검수인 수배여부 검토
• 연료유/윤활유 검수인 수배 승인
• 연료유/윤활유 분석업무 주관
• 재고목록표 검토
• 선용품, 기부속 비 집행 실적 분석
• 익년도 선용품, 기부속 비 예산 수립', 0, '김동현', 25);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '박해민', '감독', '협력업체
관리', '• 공급업체 선정/평가를 위한 자료, 검토, 분석
• 공급업체 선정 평가서 작성
• 부적합보고서에 대한 조치
• 공급업체 평가서 작성
• 공급업체 말소사유서 작성', 0, '최광식', 26);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '이주원', '감독', '협력업체
관리', '• 공급업체 선정/평가를 위한 자료, 검토, 분석
• 공급업체 선정 평가서 작성
• 부적합보고서에 대한 조치
• 공급업체 평가서 작성
• 공급업체 말소사유서 작성', 0, '권순범', 27);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최광식', '감독', '협력업체
관리', '• 공급업체 선정/평가를 위한 자료, 검토, 분석
• 공급업체 선정 평가서 작성
• 부적합보고서에 대한 조치
• 공급업체 평가서 작성
• 공급업체 말소사유서 작성', 0, '박해민', 28);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '김동현', '감독', '협력업체
관리', '• 공급업체 선정/평가를 위한 자료, 검토, 분석
• 공급업체 선정 평가서 작성
• 부적합보고서에 대한 조치
• 공급업체 평가서 작성
• 공급업체 말소사유서 작성', 0, '팽철호', 29);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '권순범', '감독', '협력업체
관리', '• 공급업체 선정/평가를 위한 자료, 검토, 분석
• 공급업체 선정 평가서 작성
• 부적합보고서에 대한 조치
• 공급업체 평가서 작성
• 공급업체 말소사유서 작성', 0, '이주원', 30);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '팽철호', '감독', '협력업체
관리', '• 공급업체 선정/평가를 위한 자료, 검토, 분석
• 공급업체 선정 평가서 작성
• 부적합보고서에 대한 조치
• 공급업체 평가서 작성
• 공급업체 말소사유서 작성', 0, '김동현', 31);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '박해민', '감독', '외부 검사 및
심사', '• 선급검사 검사 상태 확인
• 연간 선급검사수검계획서 작성
• 선급검사 신청 및 참관
• 선급검사 지적 사항, NC 처리 및 종결 관측
• P&I 및 기타 외부검사 신청 및 참관
• P&I 및 외부검사에 의한 지적 사항 종결 관측
• PSC 수검보고, 처리 및 예방/대책 관리', 0, '최광식', 32);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '이주원', '감독', '외부 검사 및
심사', '• 선급검사 검사 상태 확인
• 연간 선급검사수검계획서 작성
• 선급검사 신청 및 참관
• 선급검사 지적 사항, NC 처리 및 종결 관측
• P&I 및 기타 외부검사 신청 및 참관
• P&I 및 외부검사에 의한 지적 사항 종결 관측
• PSC 수검보고, 처리 및 예방/대책 관리', 0, '권순범', 33);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최광식', '감독', '외부 검사 및
심사', '• 선급검사 검사 상태 확인
• 연간 선급검사수검계획서 작성
• 선급검사 신청 및 참관
• 선급검사 지적 사항, NC 처리 및 종결 관측
• P&I 및 기타 외부검사 신청 및 참관
• P&I 및 외부검사에 의한 지적 사항 종결 관측
• PSC 수검보고, 처리 및 예방/대책 관리', 0, '박해민', 34);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '김동현', '감독', '외부 검사 및
심사', '• 선급검사 검사 상태 확인
• 연간 선급검사수검계획서 작성
• 선급검사 신청 및 참관
• 선급검사 지적 사항, NC 처리 및 종결 관측
• P&I 및 기타 외부검사 신청 및 참관
• P&I 및 외부검사에 의한 지적 사항 종결 관측
• PSC 수검보고, 처리 및 예방/대책 관리', 0, '팽철호', 35);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '권순범', '감독', '외부 검사 및
심사', '• 선급검사 검사 상태 확인
• 연간 선급검사수검계획서 작성
• 선급검사 신청 및 참관
• 선급검사 지적 사항, NC 처리 및 종결 관측
• P&I 및 기타 외부검사 신청 및 참관
• P&I 및 외부검사에 의한 지적 사항 종결 관측
• PSC 수검보고, 처리 및 예방/대책 관리', 0, '이주원', 36);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '팽철호', '감독', '외부 검사 및
심사', '• 선급검사 검사 상태 확인
• 연간 선급검사수검계획서 작성
• 선급검사 신청 및 참관
• 선급검사 지적 사항, NC 처리 및 종결 관측
• P&I 및 기타 외부검사 신청 및 참관
• P&I 및 외부검사에 의한 지적 사항 종결 관측
• PSC 수검보고, 처리 및 예방/대책 관리', 0, '김동현', 37);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '박해민', '감독', '안전/보건
관리', '• 재해 방지 활동 상황 점검 및 재해 방지 조치
• 준사고, 부적합 사항 보고서 접수 및 검토 회신
• 선박 사고의 접수, 처리 및 조사
• 선박 비상대응 업무', 0, '최광식', 38);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '이주원', '감독', '안전/보건
관리', '• 재해 방지 활동 상황 점검 및 재해 방지 조치
• 준사고, 부적합 사항 보고서 접수 및 검토 회신
• 선박 사고의 접수, 처리 및 조사
• 선박 비상대응 업무', 0, '권순범', 39);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최광식', '감독', '안전/보건
관리', '• 재해 방지 활동 상황 점검 및 재해 방지 조치
• 준사고, 부적합 사항 보고서 접수 및 검토 회신
• 선박 사고의 접수, 처리 및 조사
• 선박 비상대응 업무', 0, '박해민', 40);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '김동현', '감독', '안전/보건
관리', '• 재해 방지 활동 상황 점검 및 재해 방지 조치
• 준사고, 부적합 사항 보고서 접수 및 검토 회신
• 선박 사고의 접수, 처리 및 조사
• 선박 비상대응 업무', 0, '팽철호', 41);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '권순범', '감독', '안전/보건
관리', '• 재해 방지 활동 상황 점검 및 재해 방지 조치
• 준사고, 부적합 사항 보고서 접수 및 검토 회신
• 선박 사고의 접수, 처리 및 조사
• 선박 비상대응 업무', 0, '이주원', 42);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '팽철호', '감독', '안전/보건
관리', '• 재해 방지 활동 상황 점검 및 재해 방지 조치
• 준사고, 부적합 사항 보고서 접수 및 검토 회신
• 선박 사고의 접수, 처리 및 조사
• 선박 비상대응 업무', 0, '김동현', 43);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '박해민', '감독', '관리 선박의
인수 및 인도', '• 신조선 사양서, 계약서, 도면 검토
• 신조선 현장 감독
• 중고선 매입 전 검선
• 적량측도 및 총톤수 계산, 톤수증서발급
• 외항선자격 변경, 통관
• 인수 전 선저 수중 검사
• 입급 검사 관련 업무
• P&I 검사, 증서 발급
• 인수 시 현장 감독
• 도면 정리 및 도면 목록 작성
• 인도 시 현장 감독', 1, '최광식', 44);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '이주원', '감독', '관리 선박의
인수 및 인도', '• 신조선 사양서, 계약서, 도면 검토
• 신조선 현장 감독
• 중고선 매입 전 검선
• 적량측도 및 총톤수 계산, 톤수증서발급
• 외항선자격 변경, 통관
• 인수 전 선저 수중 검사
• 입급 검사 관련 업무
• P&I 검사, 증서 발급
• 인수 시 현장 감독
• 도면 정리 및 도면 목록 작성
• 인도 시 현장 감독', 0, '권순범', 45);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최광식', '감독', '관리 선박의
인수 및 인도', '• 신조선 사양서, 계약서, 도면 검토
• 신조선 현장 감독
• 중고선 매입 전 검선
• 적량측도 및 총톤수 계산, 톤수증서발급
• 외항선자격 변경, 통관
• 인수 전 선저 수중 검사
• 입급 검사 관련 업무
• P&I 검사, 증서 발급
• 인수 시 현장 감독
• 도면 정리 및 도면 목록 작성
• 인도 시 현장 감독', 0, '박해민', 46);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '김동현', '감독', '관리 선박의
인수 및 인도', '• 신조선 사양서, 계약서, 도면 검토
• 신조선 현장 감독
• 중고선 매입 전 검선
• 적량측도 및 총톤수 계산, 톤수증서발급
• 외항선자격 변경, 통관
• 인수 전 선저 수중 검사
• 입급 검사 관련 업무
• P&I 검사, 증서 발급
• 인수 시 현장 감독
• 도면 정리 및 도면 목록 작성
• 인도 시 현장 감독', 0, '팽철호', 47);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '권순범', '감독', '관리 선박의
인수 및 인도', '• 신조선 사양서, 계약서, 도면 검토
• 신조선 현장 감독
• 중고선 매입 전 검선
• 적량측도 및 총톤수 계산, 톤수증서발급
• 외항선자격 변경, 통관
• 인수 전 선저 수중 검사
• 입급 검사 관련 업무
• P&I 검사, 증서 발급
• 인수 시 현장 감독
• 도면 정리 및 도면 목록 작성
• 인도 시 현장 감독', 0, '이주원', 48);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '팽철호', '감독', '관리 선박의
인수 및 인도', '• 신조선 사양서, 계약서, 도면 검토
• 신조선 현장 감독
• 중고선 매입 전 검선
• 적량측도 및 총톤수 계산, 톤수증서발급
• 외항선자격 변경, 통관
• 인수 전 선저 수중 검사
• 입급 검사 관련 업무
• P&I 검사, 증서 발급
• 인수 시 현장 감독
• 도면 정리 및 도면 목록 작성
• 인도 시 현장 감독', 0, '김동현', 49);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '박해민', '감독', '위험성
평가', '• 위험성평가의 필요성 식별, 보고
• 위험성 평가 및 평가서 작성
• 위험성 평가 검토', 0, '최광식', 50);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '이주원', '감독', '위험성
평가', '• 위험성평가의 필요성 식별, 보고
• 위험성 평가 및 평가서 작성
• 위험성 평가 검토', 0, '권순범', 51);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최광식', '감독', '위험성
평가', '• 위험성평가의 필요성 식별, 보고
• 위험성 평가 및 평가서 작성
• 위험성 평가 검토', 0, '박해민', 52);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '김동현', '감독', '위험성
평가', '• 위험성평가의 필요성 식별, 보고
• 위험성 평가 및 평가서 작성
• 위험성 평가 검토', 0, '팽철호', 53);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '권순범', '감독', '위험성
평가', '• 위험성평가의 필요성 식별, 보고
• 위험성 평가 및 평가서 작성
• 위험성 평가 검토', 0, '이주원', 54);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '팽철호', '감독', '위험성
평가', '• 위험성평가의 필요성 식별, 보고
• 위험성 평가 및 평가서 작성
• 위험성 평가 검토', 0, '김동현', 55);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '박해민', '감독', '기타', '• 선박 선급 증서, PLAN & MANUAL, 기타 증서 및 장비 증서 관리
• 관련 프로세스와 절차서의 개정
• 고객 불만사항 접수 및 처리
• 시스템 문서 작성/검토', 0, '최광식', 56);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '이주원', '감독', '기타', '• 선박 선급 증서, PLAN & MANUAL, 기타 증서 및 장비 증서 관리
• 관련 프로세스와 절차서의 개정
• 고객 불만사항 접수 및 처리
• 시스템 문서 작성/검토', 0, '권순범', 57);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '최광식', '감독', '기타', '• 선박 선급 증서, PLAN & MANUAL, 기타 증서 및 장비 증서 관리
• 관련 프로세스와 절차서의 개정
• 고객 불만사항 접수 및 처리
• 시스템 문서 작성/검토', 0, '박해민', 58);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '김동현', '감독', '기타', '• 선박 선급 증서, PLAN & MANUAL, 기타 증서 및 장비 증서 관리
• 관련 프로세스와 절차서의 개정
• 고객 불만사항 접수 및 처리
• 시스템 문서 작성/검토', 0, '팽철호', 59);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '권순범', '감독', '기타', '• 선박 선급 증서, PLAN & MANUAL, 기타 증서 및 장비 증서 관리
• 관련 프로세스와 절차서의 개정
• 고객 불만사항 접수 및 처리
• 시스템 문서 작성/검토', 0, '이주원', 60);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '팽철호', '감독', '기타', '• 선박 선급 증서, PLAN & MANUAL, 기타 증서 및 장비 증서 관리
• 관련 프로세스와 절차서의 개정
• 고객 불만사항 접수 및 처리
• 시스템 문서 작성/검토', 0, '김동현', 61);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '김가현', '대리', '경리보고', '• 선주사 자금청구 및 경리보고
• 발주품의서 작성 및 관리', 1, '박해민
이주원
최광식
김동현
권순범
팽철호', 62);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '김가현', '대리', '구매/보급
지원', '• 선용품/ 윤활유 견적 확인 및 발주, 보급 계획 수립
• 보급 이후 TALLY REPORT 취합 및 정리
• 윤활유/벙커/청구/냉각수 등 SAMPLE 분석취합 및 기록관리
• 윤활유/벙커 샘플 KIT 보급', 0, '', 63);
INSERT INTO duty_assignments (team_code, staff_name, role_ko, duty_area, duty_content, is_essential, backup_name, sort_order)
VALUES ('MTT', '김가현', '대리', '기타', '•선박 정기보고서 취합
•선박 연간 예산 입력, 업체 추가 입력
•각종 서류, 기부속, LO 샘플 등 택배, DHL 발송/통관
•행낭 수발신 및 목록 작성/보관
•MEDICINE CHEST CERT. 발급 요청 및 본선 전달
•매월 CLASS SURVEY REPORT 전선대 발송
•공무 감독 보조', 0, '', 64);
