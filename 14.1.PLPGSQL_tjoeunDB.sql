---------------------- 문제
/*
	레퍼런스타입변수로 EID, ENAME, JCODE, SAL, DTITLE을 선언하고
	각 자료형에 EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE(DEPARTMENT)
	
	사용자가 입력한 사번의 사번, 사원명, 직급코드, 급여, 부서명을 출력
 */
-- 윈도우 환경설정 SQL 편집기 parameter 체크해야 가능함. 

do $$
declare 
   EID EMPLOYEE.EMP_ID%type;
   ENAME EMPLOYEE.EMP_NAME%type;
   JCODE EMPLOYEE.JOB_CODE%type;
   SAL EMPLOYEE.SALARY%type;
   DTITLE DEPARTMENT.DEPT_TITLE%type; 
begin 
   select emp_ID, EMP_NAME, job_CODE, salary, DEPT_TITLE
     into EID, ENAME, JCODE, SAL, DTITLE
     from EMPLOYEE
     join DEPARTMENT on (DEPT_CODE = DEPT_ID)
    where EMP_ID = ${사번};
    
    raise notice '%, %, %, %, %',EID, ENAME, JCODE, SAL, DTITLE;
end;
$$ 


-------------------------------------------------------------------
/*
  1.3) ROW 타입 변수 선언
      테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수
      [표현식]
      변수명 테이블명%ROWTYPE; 
      
*/

do $$ -- 쿼리에 사번을 입력해야함! 
declare 
   E EMPLOYEE%ROWTYPE;
begin 
	select * 
	into E
	from employee
	where emp_ID = ${사번};
	
	raise notice '사원명 : %', E.EMP_NAME;
	raise notice '급여 : %', E.SALARY;
	-- raise notice '보너스 : %', COALESCE(E.BONUS, '없음'); -- 타입이 안맞아서 그래
	raise notice '보너스 : %', COALESCE(E.BONUS, 0);
end;
$$

-- 값이 제대로 안나옴 
do $$ -- 쿼리에 사번을 입력해야함! 
declare 
   E EMPLOYEE%ROWTYPE;
begin 
	select emp_NAME, SALARY, BONUS -- 무조건 *을 사용해야 한다. 
	into E
	from employee
	where emp_ID = ${사번};
	
	raise notice '사원명 : %', E.EMP_NAME;
	raise notice '급여 : %', E.SALARY;
	raise notice '보너스 : %', COALESCE(E.BONUS, 0);
end;
$$

/*
  EMP_ID = 사원명
  EMP_NAME = 급여 
  EMP_NO = 보너스 
  EMAIL = 안들어감
  .... 
  SALARY = 안들어감
  BONUS = 안들어감 
*/

--------------------------------------------------------------------------
-- 2. BEGIN 
/*
  <조건문> 
  1) IF 조건식 THEN 실행내용 END IF;   (단일 IF문)  
 */ 
-- 사번 입력 하면 사번, 이름, 급여, 보너스율(%)출력 
-- 단, 보너스를 받지 않는 사원은 보너스율 출력전 '보너스를 받지 않는 사원입니다'출력 

do $$
declare 
  EID EMPLOYEE.EMP_ID%type; 
  ENAME EMPLOYEE.EMP_NAME%type;
  SAL EMPLOYEE.SALARY%type;
  INCENTIVE EMPLOYEE.BONUS%type;
begin
	select EMP_ID, EMP_NAME, SALARY, COALESCE(BONUS, 0)
	  into EID, ENAME, SAL, INCENTIVE
	  from EMPLOYEE
	  where EMP_ID = ${사번};
	  
	  raise notice '사번 : %', EID; 
	  raise notice '이름 : %', ENAME; 
	  raise notice '급여 : %', SAL;
	  IF INCENTIVE = 0 
	    then RAISE NOTICE '보너스를 받지 않는 사원입니다';
	  END IF; 
	  raise notice '보너스율 : %', INCENTIVE*100 || '%'; 
end
$$

-- 2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF; (IF-ELSE문)
do $$ 
declare 
  EID EMPLOYEE.EMP_ID%type;
  ENAME EMPLOYEE.EMP_NAME%type;
  SAL EMPLOYEE.SALARY%type;
  INCENTIVE EMPLOYEE.BONUS%type;
begin 
	select EMP_ID, EMP_NAME, SALARY, COALESCE(BONUS, 0)
	into EID, ENAME, SAL, INCENTIVE
	from employee
	where emp_id = ${사번};

    raise notice '사번 : %', EID;
    raise notice '이름 : %', ENAME; 
    raise notice '급여 : %', SAL;
    if incentive = 0
      then raise notice '보너스를 받지 않는 사원입니다';
    else
      raise notice '보너스율 : %', INCENTIVE*100 || '%';
    end if;
end; 
$$ 

------------------------------- 실습문제 

/*
  레퍼런스 변수 : EID, ENAME, DTITLE, NCODE
  참조컬럼 : EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
  일반변수 : TEAM(소속)
  
  실행 : 사용자가 입력한 사번의 사번, 이름, 부서명, 근무국가코드를 변수에 대입
       단) NCODE값이 KO일 경우 => TEAM에 '국내팀'
           NCODE값이 KO가 아닐경우 -> TEAM '해외팀'
  출력 : 사번, 이름, 부서명, 소속 출력 
 */

do $$ 
declare 
   EID EMPLOYEE.EMP_ID%type; 
   ENAME EMPLOYEE.EMP_NAME%type;
   DTITLE DEPARTMENT.DEPT_TITLE%type;
   NCODE location.NATIONAL_CODE%type; 
   team varchar(10);   -- 일반변수 선언

begin 
	select emp_Id, emp_name, dept_title, national_code 
    into EID, ENAME, DTITLE, NCODE 
    from employee 
    join department on (dept_code = dept_id)
    join location on (location_id = local_code)
    where emp_id = ${사번}; 
 

    if NCODE = 'KO' 
     then TEAM := '국내팀';
    else 
     TEAM := '해외팀';
    end if;
    
    raise notice '사번 : %', EID;
    raise notice '이름 : %', ENAME;
    raise notice '부서명 : %', DTITLE;
    raise notice '소속 : %', TEAM;    
end;
$$

/*
  3) IF-ELSE IF 조건문
  IF 조건식1 THEN 실행내용1; 
  ELSIF 조건식2 THEN 실행내용2; 
  ELSIF 조건식3 THEN 실행내용3;
  ELSE 실행내용4; 
  END IF; 

 */
-- 사용자로부터 점수를 입력받아 학점을 출력 
do $$ 
declare 
  score numeric; 
  GRADE VARCHAR(1);
begin
  score := ${점수};

  if score >= 90 then GRADE := 'A';
  elsif SCORE >= 80 then GRADE := 'B';
  elsif SCORE >= 70 then GRADE := 'C';
  elsif SCORE >= 60 then GRADE := 'D';
  else grade := 'F';
  end if; 
  
  --- 당신의 점수는 ?점이고, 학점은 ?학점입니다 
  
  raise notice '당신의 점수는 %점이고, 학점은 %학점입니다', SCORE, GRADE;
end;
$$

---------------------------------------------
/*
  사용자로부터 입력받은 사번의 사원의 급여를 조회하여 SAL 변수에 대입
  500만원 이상이면 '고급'
  300만원 이상이면 '중급' 
  300만원 미만이면 '초급'
  출력 : ? 사원의 급여 등급은 ?입니다. 
 */

do $$ 
declare 
    ENAME employee.emp_name%type;
    EID employee.emp_id%type; 
    sal employee.salary%type; 
    grade varchar(2);
begin 
   select emp_id, salary, emp_NAMe
   into EID, SAL, ENAME
   from employee 
   where emp_id = ${사번};

   if sal >= 5000000 then grade := '고급';
   elsif sal >= 3000000 then grade := '중급';
   else grade :='초급';
   end if;
   
   raise notice '%사원의 급여 등급은 %입니다',ENAME, GRADE;


end;
$$

/*
  <CASE 문>
  CASE 비교대상자 
     when 비교할값1 THEN 실행내용1
     when 비교할값2 THEN 실행내용2
     when 비교할값3 THEN 실행내용3
     ELSE 실행내용4 
  END; 
 */

do $$ -- switch case 문이라고 생각하면 된다. 
declare 
   E EMPLOYEE%ROWTYPE; -- 행전체 갖고오기
   DNAME VARCHAR(20);
begin
   select * 
   into E 
   from employee
   where emp_ID = ${사번};

   DNAME := case E.DEPT_CODE 
     when 'D1' then '인사관리부'
     when 'D2' then '회계관리부'     
     when 'D3' then '마케팅부'     
     when 'D4' then '국내영업부' 
     when 'D8' then '기술지원부' 
     when 'D9' then '총무부' 
     else '해외영업부'
    end; 
   
    raise notice '%은 %입니다',E.EMP_NAME, DNAME;
end;
$$

--=============================================================
/*
  <반복문>
  
  - LOOP (BASIC LOOP문)
  [표현식]
  LOOP
    반복적으로 실행할 구문; 
    * 반복을 빠져나갈 구문; 
  END LOOP; 
  
  > 반복문을 빠져나오는 조건 
  1) IF 조건식 THEN EXIT; END IF; 
  2) EXIT WHEN 조건식;
*/
-- 1~5까지 1씩 증가하면서 출력 
--    1) IF 조건식으로 
do $$ 
declare 
  I numeric := 1; 
begin 
   loop
	   raise notice '%', I;
       I := I+1;

	   if I = 6 then exit;
	   end if;
    end loop;
end;
$$;

--    1) EXIT로 
do $$ 
declare 
  I numeric := 1; 
begin 
   loop
	   raise notice '%', I;
       I := I+1;

	   exit when I = 6;  
    end loop;
end;
$$;

----------------------------------------------------------------------------------------
/*
  2) FOR LOOP문
  
  [표현식]
  FOR 변수 IN [REVERSE] 초기값..최종값 
  LOOP
   반복할 실행문;
  END LOOP; 

*/

do $$ 
begin 
	for I in 1..10
	loop
      raise notice '%', I;
    end loop;

end;
$$; 

do $$ 
begin 
	for I in reverse 5..1
	loop 
      raise notice '%',I;
	end loop;
	
end;
$$;

create table test (
   TNO numeric primary key, 
   Tdate date 

)

create sequence SEQ_TNO
increment by 2;

do $$ 
begin 
	for I in 1..100
	loop 
	  insert into test values(nextval('SEQ_TNO'),CURRENt_DATE);
		
	end loop;
	
end;
$$

select * from TEST; 

----------------------------------------------------------------------------------------
/*
   3) WHILE LOOP문
   
   [표현식]
   WHILE 반복문이 수행될 조건 
   LOOP
     반복 실행 구문;
   END LOOP; 
*/   

do $$ 
declare 
  I numeric := 1; 
begin 
	while I < 6 
	loop 
	  raise notice '%', I; 
      I := I+1; 
	end loop;
	
end;
$$;

----------------------------------------------------------------------------------------
/*
  3. 예외처리부
     : 실행중 발생하는 오류
     
     [표현식]
     EXCEPTION
       WHEN 예외명1 THEN 예외처리구문1; 
       WHEN 예외명2 THEN 예외처리구문2;
       WHEN OTHERS THEN 예외처리구문N;  
       
       * 시스템예외
         - NO_DATA_FOUND : SELECT한 결과가 한 행도 없을 경우 
         - TOO_MANY_ROWS : SELECT한 결과가 여러행 일때 
         - ZERO_DIVIDE : 0으로 나눌때 
         - DUP_VAL_ON_INDEX : UNIQUE 제약조건에 위배되었을 때 
*/

do $$ 
declare 
  result1 numeric;
  INPUT_NUM numeric := ${숫자};
begin
	result1 := 10/INPUT_NUM;
	raise notice '결과 : %', result1; 
exception 
  when DIVISION_BY_ZERO then raise notice '0으로 나눌 수 없습니다'; 
end;
$$;

-- UNIQUE 제약조건 위반 
do $$ 
begin 
	update EMPLOYEE 
	set EMP_ID = ${사번}
	where EMP_NAME = '이정하';	
end;
$$;


-- 사수 211:1명, 200:여러명, 213:없음
do $$ 
declare 
  EID EMPLOYEE.EMP_ID%type;
  ENAME EMPLOYEE.EMP_NAME%type; 
begin 
	select emp_ID, emp_NAME 
	into EID, ENAME 
	from employee 
	where manager_ID = '213'; 

    raise notice '사번:%', EID;
    raise notice '이름:%', ENAME;
end;
$$;

-- 사수 200:여러명, 213:없음
-- INTO STRICT 딱 한행 아닐때 오류발생 시킴 
do $$ 
declare 
  EID EMPLOYEE.EMP_ID%type;
  ENAME EMPLOYEE.EMP_NAME%type; 
begin 
	select emp_ID, emp_NAME 
	into strict EID, ENAME 
	from employee 
	where manager_ID = ${사번}; 

    raise notice '사번:%', EID;
    raise notice '이름:%', ENAME;
exception 
    when TOO_MANY_ROWS then 
       raise notice '너무 많은 행이 조회되었습니다';
    when NO_DATA_FOUND then
       raise notice '조회 결과가 없습니다.';
end;
$$;

-- 연습문제 
/*
  1. 사원의 연봉을 구하는 PL/PGSQL블럭 작성, 보너스가 있는 사원은 보너스도 포함하여 계산
  2. 구구단 짝수단 출력 
       1) FOR LOOP
       2) WHILE LOOP
 */
-- 1번 
--1)
do $$
declare 
   EID employee.emp_ID%TYPE;
   ENAME employee.emp_name%type;
   EBONUS employee.bonus%TYPE; 
   ESALARY employee.salary%TYPE; 
   total numeric; 
begin 
	select emp_ID, EMP_NAME, bonus,salary
	into EID, ENAME, EBONUS, ESALARY
	from employee 
	where emp_ID = ${사번};
	
	total = ESALARY + ESALARY*EBONUS; 
	raise notice '% 사번인 %사원의 연봉은 %원 입니다.', EID,ENAME,total;
end;
$$; 



--2)

-- 1.
do $$ 
declare 
    I numeric := 2;
    J numeric := 1;
begin 
	while I < 10
	loop 
	    j = 1;
	    while j<10
	    loop 
		    raise notice '% * % = %',i,j,I*J;
		    j := j+1;
	    end loop;
    I := I+1;    
	end loop;
end;
$$;


--2. 
do $$ 
declare 
	I numeric := 2;
    j numeric := 1;
begin 
	for i in 2..9
    loop 
	    for j in 1..9
        loop
        	raise notice '% * % = %',i,j,i*j;
        end loop;
    end loop;
end;
$$;

-- 선생님답 
do $$ 
begin 
	for DAN in 2..9 by 2
	loop 
		for SU in 1..9
		loop 
			raise notice '% * % = %', DAN, SU, (DAN*SU);
        end loop;
			
		raise notice ''; 
		
	end loop;
end;
$$; 

do $$ 
declare 
	DAN numeric := 2;
	SU NUMERIC := 1; 
begin 
	while DAN < 10 
	LOOP 
	   SU := 1;
	   IF MOD(DAN, 2) = 0 THEN 
	     WHILE SU <= 9
	     LOOP
	       RAISE NOTICE '% * % = %', DAN, SU, (DAN*SU);
	       SU := SU +1 ; 
		 END LOOP; 
		 raise notice ''; 
	  DAN := DAN +1;
	END LOOP; 
end;
$$; 


