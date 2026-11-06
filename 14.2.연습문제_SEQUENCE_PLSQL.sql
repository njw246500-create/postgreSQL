-- 문제 1. 시작값 700, 증가값 3, 최댓값 715, NO CYCLE, CACHE 2인
-- SEQ_LOGIN_LOG 시퀀스를 생성하고 NEXTVAL을 2회 실행한 뒤 CURRVAL을 조회
create sequence SEQ_LOGIN_LOG
start with 700
increment by 5
maxvalue 715
no cycle
cache 2;

select NEXTVAL('SEQ_LOGIN_LOG');
select CURRVAL('SEQ_LOGIN_LOG');

-- 문제 2. LOGIN_HISTORY 테이블을 생성하고
-- SEQ_LOGIN_LOG의 NEXTVAL과 CURRENT_DATE를 사용하여
-- 사원번호 200, 201, 202의 로그인 기록을 각각 INSERT한 뒤 전체 조회
create table LOGIN_HISTORY (
     LOGIN_NUMBER primary key, 
     LOGIN_record numeric
);

insert into LOGIN_HISTORY (login_number, login_record)
values('200',700)


-- 문제 3. SEQ_LOGIN_LOG의 증가값을 4로 변경한 뒤 NEXTVAL을 조회
-- 이어서 RESTART WITH 900, MAXVALUE 950으로 변경하고 NEXTVAL을 조회
alter sequence SEQ_LOGIN_LOG 
increment by 4;
select NEXTVAL('SEQ_LOGIN_LOG'); ---709

alter sequence SEQ_LOGIN_LOG 
restart with 900
maxvalue 950;
select NEXTVAL('SEQ_LOGIN_LOG'); -- 900


-- 문제 4. VISIT_RECORD 테이블을 생성하고
-- VISIT_NO를 SERIAL PRIMARY KEY로 지정
-- 방문자명과 방문일을 입력하여 2건 INSERT한 뒤
-- PG_GET_SERIAL_SEQUENCE로 시퀀스 이름을 확인하고 전체 데이터 조회




-- 문제 5. SEQ_TEMP_ORDER 시퀀스를 생성하고 NEXTVAL을 1회 실행
-- 이후 해당 시퀀스를 삭제



-- 문제 6. DO 블록에서 EMPLOYEE의 EMP_ID%TYPE, EMP_NAME%TYPE,
-- SALARY%TYPE을 참조하는 변수를 선언
-- 사번이 '209'인 사원의 사번, 이름, 급여를 SELECT INTO로 조회하고
-- RAISE NOTICE로 세 값을 출력
do $$ 
declare 
   EID EMPLOYEE.EMP_ID%type;
   ENAME EMPLOYEE.EMP_NAME%type;
   ESALARY EMPLOYEE.SALARY%type; 
begin 
	select emp_Id, emp_name, salary 
	into EID, ENAME, ESALARY 
	from employee 
	where emp_ID = '209';
	
	raise notice '사원의 사번 : %, 사원의 이름 : %, 사원의 급여 : % ',EID, ENAME, ESALARY;
end;
$$;


-- 문제 7. DO 블록에서 EMPLOYEE%ROWTYPE 변수를 선언
-- 사번이 '212'인 사원의 전체 행을 조회하여 변수에 저장하고
-- 사원명, 직급코드, 입사일, 퇴직여부를 RAISE NOTICE로 출력

do $$ 
declare 
   E employee%ROWTYPE; 
begin 
	select * 
	into E 
	from employee 
	where emp_ID = ${사번};

    raise notice '사원명 : %, 직급코드 : %, 입사일 : %, 퇴직여부 : %', E.emp_name, E.job_code, E.hire_date, E.ent_yn;
end;
$$;


-- 문제 8. DO 블록에서 사번이 '205'인 사원의 급여와 급여등급을 조회
-- SAL_GRADE의 MIN_SAL, MAX_SAL 범위를 이용하여 급여등급(SAL_LEVEL)을 찾고
-- 급여와 급여등급을 RAISE NOTICE로 출력
do $$ 
declare 
    E employee%ROWTYPE; 
begin 




-- 문제 9. DO 블록에서 사번이 '207'인 사원의 직급코드와 직급명을 조회
-- CASE문을 사용하여 직급코드가 J1 또는 J2이면 '임원급',
-- J3 또는 J4이면 '관리자급', J5이면 '중간관리자급',
-- 그 외에는 '일반직원'으로 구분
-- 사원명, 직급명, 직급분류를 RAISE NOTICE로 출력


	
	
	

-- 문제 10. DO 블록에서 FOR LOOP를 사용하여 1부터 5까지 반복
-- 각 숫자에 3을 곱한 결과를 RAISE NOTICE로 출력
-- 단, 결과가 9인 경우에는 '9는 건너뜁니다'를 출력하고
-- 곱셈 결과는 출력하지 않도록 IF 조건문을 사용
	
	
	
	
	
	
	