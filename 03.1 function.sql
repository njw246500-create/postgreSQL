/*
 < 함수 Function >
 
 전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환
 
 - 단일행 함수 : N개의 값을 읽어 들여 N개의 결과값 반환 ( 매 행마다 함수 실행 )
 - 그룹 함수 : N개의 값을 읽어들여 1개의 결과값 반환 ( 그룹별로 함수 실행 )



 >> SELECT 절에 단행함수와 그룹함수를 함께 사용할 수 없음
 >> 함수식을 기술할 수 있는 위치. SELECT절, WHERE절, ORDER BY 절, HAVING절 
 
 
---------------------------------- 단일행 함수 -----------------------------------------

======================================================================================
--                                  <문자처리함수>

=======================================================================================

/*
 * LENGTH/ OCTET_LENGTH => INTEGER로 반환
 
   LENGTH(컬럼명 | '문자열') : 해당 글자수 반환
   OCTET_LENGTH(컬럼명 | '문자열') : 해당 문자열의 BYTE수 반환 
   	- 한글 : 1글자당 3byte / 영문, 숫자 : 1글자당 1byte 
   
   
  */

*/

select LENGTH('데이터베이스'), OCTET_LENGTH('데이터베이스');

select LENGTH('postgreSQL'), OCTET_LENGTH('postgreSQL');

select emp_name, length(emp_name), OCTET_LENGTH(emp_name)
      ,email, length(email),OCTET_LENGTH(email)
from employee; 


-------------------------------------------------------------------------------------------------------
/*
 * LEFT / RIGHT('문자열', 글자수) : 왼쪽/오른쪽 끝에서 부터 지정한 개수만큼 문자열 반환
 * >> 글자수에 음수를 넣으면 맨 뒤/앞의 글자수만큼 제외하고 나머지 전부 

 */

select LEFT('databasepostgresql',4);
select right('databasepostgresql',3);
select RIGHT('서울특별시',3);

select left('DATABASESQL',-3); -- 맨 뒤의 글자 3개를 제외하고 
select RIGHT('DATABASEPostgreSQL',-8); -- 맨 앞의 글자 8개를 제외하고 

select RIGHT('DATA', 100); -- 커도 상관없음
select RIGHT('DATA',0);   -- 빈 문자열 반환

-------------------------------------------------------------------------------------------------------
/*
  * POSITION / STRPOS : 문자열로부터 특정 문자의 시작 위치(INDEX)를 찾아서 반환(1부터 시작, 없으면 0)
 */

select position ('A' in 'DATABASE'); 
select STRPOS('DATABASE', 'A'); -- 결과동일
select POSITION('A' in REVERSE('DATABASE')) -- 결과 3 : ESABATAD 에서 A의 위치 - > 3

select EMAIL 
	   ,position('_' in EMAIL) as "_위치"
       ,position('@' in EMAIL) as "@위치"
from EMPLOYEE;  

-----------------------------------------------------------------------------------------------------
/*
 * SUBSTR / SUBSTRING : 문자열에서 특정 문자열을 추출 
 - SUBSTR('문자열', POSITION, [LENGTH])
  > POSITION : 문자열을 추출할 시작 위치 INDEX 
  > LENGTH : 추출할 문자 갯수 ( 생략 시 맨 끝까지 추출 ) 
  
  - SUBSTRING('문자열', from POSITION [for LENGTH])
 */

select substr('DATABASESQL', 5);
select SUBSTRING('DATABASESQL'from 5);

select SUBSTR('DATABASESQL', 5, 4);
select SUBSTRING('DATABASESQL' from 5 for 4); 

select SUBSTR('DATABASESQL', 3, 6);
select SUBSTRING('DATABASESQL' from 3 for 6)

-- EMPLOYEE 테이블에서 주민번호에 성별만 추출하여 주민번호, 사원명, 성별 조회 
select emp_name , emp_no, SUBSTR(EMP_NO, 8, 1) 성별 
from EMPLOYEE;

select emp_name , emp_no, SUBSTRING(EMP_NO from 8 for 1) 성별 
from EMPLOYEE;

-- EMPLOYEE 테이블에서 여자 사원들만 사번, 사원명, 성별(1-4중 하나) 조회
select emp_id, emp_name , SUBSTR(EMP_NO, 8, 1) 성별 
from EMPLOYEE
where SUBSTRING(EMP_NO from 8 for 1) = '2' or SUBSTRING(EMP_NO from 8 for 1) = '4';

-- EMPLOYEE 테이블에서 남자 사원들만 사번, 사원명, 성별(1-4중 하나) 조회
select emp_Id ,emp_name , emp_no, SUBSTR(EMP_NO, 8, 1) 성별 
from EMPLOYEE
where SUBSTR(EMP_NO, 8, 1) = '1' or SUBSTR(EMP_NO, 8, 1) = '3';


-- EMPLOYEE 테이블에서 EMAIL의 아이디만 추출하여 사원명, 이메일 아이디 조회
select EMP_NAME, EMAIL, SUBSTR(EMAIL,1, position('@' in EMAIL)-1) 아이디-- @ 바로 앞까지 가져오기
from EMPLOYEE;

select EMP_NAME, EMAIL, SUBSTRING(EMAIL from 1 for  position('@' in EMAIL)-1) 아이디-- @ 바로 앞까지 가져오기
from EMPLOYEE;

----------------------------------------------------------------------------------------------
/*
 * LPAD / RPAD : 문자열 조회할 때 길이를 맞춰 통일감있게 조회하고자 할때 
   
   LPAD / RPAD('문자열', 최종반환할 문자의 길이, [덧붙이고자 하는 문자])
   
 * 
 */
-- 25길이에 맞춰 EMAIL을 오른쪽 정렬하고 앞부분은 공백으로 채워서 출력
select EMP_NAME, LPAD(EMAIL, 25) -- 덧붙이고자 하는 문자 생략시 기본값은 공백
from EMPLOYEE; 

select EMP_NAME, LPAD(EMAIL,25, '#')
from employee;

select EMP_name, RPAD(EMAIL, 25, '#')
from employee;

-- EMPLOYEE 테이블에서 사번, 사원명, 주민번호 출력 ( 주민번호는 123456-1****** 의 형식으로)
select EMP_ID, EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') As 주민번호
from employee; 

select EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 1, 8) || '******' As 주민번호
from employee;

/*
 * LTRIM / RTRIM : 문자열에서 특정 문자를 제거하고 반환
 * TRIM : 문자의 앞/뒤 양쪽에 있는 특정 문자들을 제거한 나머지 반환   
 
   LTRIM / RTRIM('문자열', 제거하고자 하는 문자) -> 제거하고자 하는 문자 생략시 공백제거 
   TRIM([LEADING|TRAILING|BOTH] 제거하고자 하는 문자 FROM '문자열')
 * 
 */
SELECT LTRIM('     TJOEUN      ') || '컴퓨터아카데이'; 
SELECT RTRIM('     TJOEUN      ') || '컴퓨터아카데이'; 

select LTRIM('DATADATABASE', 'DATA');
select LTRIM('BACABAADEIASDJ', 'ABC'); 
select LTRIM('3752153158SKFEJGRA294','0123456789');
select RTRIM('3752153158SKFEJGRA294', '0123456789');
select TRIM('          TJOEUN          ')||'컴퓨터아카데미'; -- 기본값, 양쪽 제거

-- 방향 지정 
select TRIM(leading 'A' from 'AAAAABBSEF287AAA1');
select TRIM(trailing 'A' from 'AAAAABBSEF287AAAAA' );
select TRIM(both 'A' from 'AAAAABBSEF287AAAAA'); -- 기본값
select TRIM('A' from 'AAAAABBSEF287AAAAA')

-----------------------------------------------------------------------------------------------------------------------
/*
 * LOWER / UPPER / INITCAP : 문자열을 대소문자로 벼환 및 단어의 앞글자만 대문자로 변환
 * LOWER('문자열')
 */

select LOWER('DATABASE PostgreSQL');
select upper('DATABASE PostgreSQL'); 
select initcap('database postgresql');

-----------------------------------------------------------------------------------------------------------------------
/*
 * CONCAT : 문자열 두개를 하나로 합친 결과 반환
 * 
 * CONCAT('문자열', '문자열', ...)
 */

select CONCAT('SQL', '포스트그레');
select concat('PostgreSQL','데이터베이스','02-1234-3456');

select 'SQL' || '포스트그레';

-----------------------------------------------------------------------------------------------------------------------
/*
 * REPLACE : 기존 문자열을 새로운 문자열로 변경
 *
 * [표현법] 
 * REPLACE('문자열', '기존문자열', '바꿀 문자열') 
 */

select EMP_NAME, EMAIL, REPLACE(EMAIL, 'google.com','naver.com') -- 데이터가 바뀐것이 아님. 
from employee;

--======================================================================================================================
--                                                      <숫자 처리 함수> 
--=======================================================================================================================
/*
 * ABS : 숫자의 절댓값을 구해주는 함수 
 * ABS(NUMBER)
 * 
 */
select ABS(-19);
select ABS(-13.67);

------------------------------------------------------------------------------------------------------------------------
/*
 * MOD / % : 나머지 값 반환
 * 
 */
select MOD(10,3);
select 10 % 3;  -- postgreSQL에서만 사용 
--------------------------------------------------------------------------------------------------------------------------
/*
 * ROUND : 반올림한 결과 반환 
 * 
 * [표현법]
 * ROUND(NUMBER, [위치])
 *   
 */

select ROUND(1234.56);
select ROUND(12.34);

select ROUND(1234.5667, 2);
select ROUND(1234.56, 4);

select ROUND(1234.56, -2);
select ROUNd(1237.56,-1);

--------------------------------------------------------------------------------------------------------------------------
/*
 * CEIL : 올림한 결과 반환 <큰숫자로!, 음수조심>
 * FLOOR : 내림한 결과 반환
 * 
 */
select CEIL(123.234);
select CEIL(-123.234);

select FLOOR(123.234);
select FLOOR(-123.234);

--------------------------------------------------------------------------------------------------------------------------
/*
 * TRUNC: 버림
 * TRUNC(NUMBER, [위치])
 */

select TRUNC(123.789);
select TRUNC(123.789, 1);

select TRUNC(-123.789);
select TRUNC(125.456,-1);

--======================================================================================================================
 --                                                     <날짜 처리 함수> 
--=======================================================================================================================
/*
 * CURRENT_DATE : 시스템 날짜  
 * NOW() : 시스템 날짜와 시간
 */
select CURRENT_DATE; 
select NOW();

select EMP_NAME, HIRE_DATE, current_DATE - HIRE_DATE 근무일수
from EMPLOYEE; 

--------------------------------------------------------------------------------------------------------------------------
/*
 * INTERVAL 'n MONTH' : 특정 날짜에 해당 숫자만큼 개월수를 더해 날짜를 리턴
 * 
 */
select CURRENT_DATE + interval '1 MONTH' as 다음달;
select (CURRENT_DATE + interval '1 MONTH')::DATE as 다음달;

-- EMPLOYEE에서 사원명,  입사일, 입사후 정직원된 날짜(6개월 후) 조회
select EMP_NAME, HIRE_DATE, HIRE_DATE + interval '6 MONTH' "정직원된 날짜"
from EMPLOYEE;

--------------------------------------------------------------------------------------------------------------------------
/* 
 * EXTRACT :특정날짜로 부터 년|월|일 값을 추출하여 반환
 * 
 * EXTRACT(YEAR FROM DATE) : 년도만 추출
 * EXTRACT(MONTH FROM DATE) : 월만 추출
 * EXTRACT(DAY FROM DATE) : 달만 추출
 */

-- EMPLOYEE에서 사원명, 입사년도, 입사월, 입사일 조회 
select EMP_NAME
	, EXTRACT(year from HIRE_DATE)::TEXT as 입사년도 -- 숫자는 오른쪽, 문자는 왼쪽 정렬이 default
--  , EXTRACT(year from HIRE_DATE)::TEXT as 입사년도 --> 문자열로 반환
	, extract(month from HIRE_DATE) as 입사월
	, extract(day from HIRE_DATE) as 입사일
from EMPLOYEE;

--======================================================================================================================
 --                                                     <형 변환 함수> 
--=======================================================================================================================
/*
 * TO_CHAR : 숫자 또는 날짜를 문자로 변환
 * 
 *   - 특정 형식에 맞게 출력 가능
 *   TO_CHAR(숫자|날짜,[포맷])
 */
-------------------------------------------------------- 숫자타입 -> 문자타입
/*
 * 9 : 해당 자리의 숫자를 의미 
 * 	  - 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0으로 표시
 * 0 : 해당 자리의 숫자를 의미
 *    - 값이 없을 경우 0으로 표시 
 * FM : 해당 자리에 값이 없을 경우 자리차지하지 않음
 *
 */
select to_char(1234, '99999'), to_char(1234,'00000');
select to_char(123.45,'99999.9999'), TO_CHAR(123.45, '00000.0000');
select to_char(0.12, '9.99'), TO_CHAR(0.12,'0.00'); 

select '￦' || to_char(1234,'99,999'); -- 맑은 고딕으로 설정하면 역슬래시가 원표시로 보이게된다.

select EMP_NAME 
	, '￦' || TO_CHAR(salary, '999,999,999') as 급여
	, '￦' || TO_CHAR(salary*12, '999,999,999') as 연봉
from EMPLOYEE ; 

select to_char(0.1000, '999,990.999');

select TO_CHAR(123.456,'FM99990.999')
	  ,TO_CHAR(1234.56, 'FM9990.99')
	  ,TO_CHAR(0.1000, 'FM9990.999')
	  ,TO_CHAR(0.1000, 'FM9999.999'); 


--- PostgreSQL 에서만 사용
--- FML : L(LOCAL의 설정에 따라 통화 기호 나타냄)
select TO_CHAR(1234,'FML999,999');

-------------------------------------------------------- 날짜타입 -> 문자타입
-- 대소문자 안가림
-- 요일만 대소문자 가림
select TO_char(NOW(),'YYYY') as 년도4자리
	  ,TO_CHAR(NOW(),'YY') as 년도2자리
	  ,TO_CHAR(NOW(),'MM') as 월
	  ,TO_CHAR(NOW(),'DD') as 일
	  ,TO_CHAr(NOW(),'DAY') as 요일 --day 이면 소문자로 요일, DAY 이면 대문자로 요일
	  ,TO_CHAR(now(),'HH') as 시
	  ,TO_CHAr(NOW(),'MI') as 분
	  ,TO_CHAR(now(),'SS') as 초;

-- 시간
select to_char(now(),'AM HH:MI:SS'); -- AM or PM 어떤것들 쓰던 상관없음
select to_char(now(),'HH12:MI:SS'); -- 12시간제, AM or PM 없이
select to_char(now(),'HH24:MI:SS'); -- 24시간제, AM or PM 없이

-- 날짜
select to_char(now(), 'YYYY-MM-DD DAY');
select to_char(now(), 'YYYY"년" MM"월" DD"일" DAY'); -- 안에 들어가는 데이터는 작은따옴표! 안에 글자는 큰따옴표

-- EMPLOYEE에서 사원명, 입사일(형식 25-10-28) 조회
select EMP_NAME, to_char(HIRE_DATE, 'YY-MM-DD') 입사일
from EMPLOYEE;

-- EMPLOYEE에서 사원명, 입사년도(4자리), 입사월, 입사일 조회
select EMP_NAME
	, to_char(HIRE_DATE, 'YYYY') 입사년도
	, to_char(HIRE_DATE, 'MM') 입사월
	, to_char(HIRE_DATE, 'DD') 입사일
from EMPLOYEE;

---------------------------------------------------------------------------------------------
/*
 * TO_DATE : 문자열을 날짜로 변경
 * : 숫자를 바로 넣는 것은 허용하지 않음. 반드시 문자열로 넣어야됨. 
 * 
 * TO_DATE('문자열','포맷')
 * 
 */
select TO_DATE('261028', 'YYYYMMDD');
select TO_DATE('261028 152850','YYMMDD HH24MISS'); --HH24는 형식을 의미함. 
	-- TO_DATE() 함수의 특성상 시간정보는 버려짐. 년월일만 출력
select TO_DATE(20261028::TEXT, 'YYYYMMDD');

---------------------------------------------------------------------------------------------
/* 
 * TO_TIMESTAMP() : 문자열로 표현된 날짜와 시간을 포맷으로 변환
 * TO_TIMESTAMP('문자열','포맷')
 */
 
select TO_TIMESTAMP('2026-10-28 15:12:30','YYYY-MM-DD HH24:MI:SS');

select TO_TIMESTAMP('20261028151230','YYYYMMDDHH24MISS');

select TO_TIMESTAMP('2026-10-28 PM 03:14','YYYY-MM-DD AM HH:MI');

-------------------------------------------------------- 문자타입 -> 숫자타입
/*
 * TO_NUMBER : 문자열을 숫자로 변환
 * 
 */
select TO_NUMBER('012341234','9999999999999');
select TO_NUMBER('1,000,000', '999,999,999') + TO_NUMBER('550000','999,999,999');

select '1000000'::INTEGER + '550000'::INTEGER;

--======================================================================================================================
 --                                                <NULL 처리 함수> 
--=======================================================================================================================
/*
 *COALESCE(컬럼, 해당컬럼값이 NULL일때 반환할 값) 
 */

-- EMPLOYEE에서 사원명, 보너스(NULL이면 0으로 출력)
select EMP_NAME, coalesce(BONUS, 0)
from EMPLOYEE;

-- EMPLOYEE에서 사원명, 보너스포함 연봉 조회
select EMP_NAME, To_CHAR((SALARY + SALARY*coalesce(BONUS,0))*12,'FML999,999,999') as 연봉
from EMPLOYEE;

-- EMPLOYEE 에서 사원명, 부서코드(NULL이면 '부서없음'), 입사일 조회
select EMP_NAME, COALESCE(DEPT_CODE, '부서없음') as 부서, HIRE_DATE
from EMPLOYEE;

--======================================================================================================================
 --                                                     <선택 함수> 
--======================================================================================================================
/*
 * CASE WHEN THEN
 * ...
 * END 
 * 
 * ex) 
 * CASE WHEN 조건식1 THEN 결과값1
 * 		WHEN 조건식2 THEN 결과값2 
 * 		...
 * 		ELSE 결과값N
 * END
 * 
 * IF-ELSE와 같음
 */
--- EMPLOYEE에서 급여가 350만원 미만이면 '초급',
--- 350만원 이상 500만원 미만이면 '중급',
--- 500만원 이상이면 '고급'
select EMP_NAME, SALARY
	   ,case when SALARY >= 5000000 then '고급'
	   		 when SALARY >= 3500000 then '중급'
	   		 else '초급'
		end as 급수
from EMPLOYEE;

--======================================================================================================================
--                                                     <그룹 함수> 
--======================================================================================================================
/*
 * SUM(컬럼(숫자타입의 컬럼)) : 컬럼들의 총 합계를 반환
 */

-- EMPLOYEE에서 전사원의 총 급여의 합
select SUM(SALARY) "급여의 합계" from EMPLOYEE;

-- EMPLOYEE 에서 남자 사원의 총 급여의 합 
select SUM(SALARY)
from employee
where SUBSTR(EMP_NO, 8, 1) IN('1','3');

-- EMPLOYEE 에서 부서코드가 D5인 사원들의 총 연봉(보너스 포함)의 합
select SUM(SALARY*12)
from employee
where DEPT_CODE = 'D5'; 


select TO_CHAR(SUM(SALARY*(1+coalesce(BONUS,0))*12),'FML999,999,999') "총 연봉" 
from employee 
where dept_code = 'D5'

/*
 * AVG(숫자타입의 칼럼) : 평균반환 
 */
select AVG(SALARY) from EMPLOYEE;
select ROUND(AVG(SALARY), -1) from EMPLOYEE;

/*
 * MIN / MAX(모든타입의 컬럼) : 최소값과 최대값
 */
select MIN(EMP_NAME), MIN(SALARY), MIN(HIRE_DATE) from EMPLOYEE;

select MAX(EMP_NAME), MAX(SALARY), MAX(HIRE_DATE) from EMPLOYEE;

/*
 * COUNT(* | 컬럼 | DISTINCT 컬럼) : 행 갯수 반환
 * COUNT(*) : 조회된 결과의 모든 행의 갯수 반환
 * COUNT(컬럼) : 컬럼의 값이 NULL인 것을 제외한 행의 갯수 반환
 * COUNT(DISTINCT 컬럼) : 중복을 제거한 행의 갯수 반환
 */

-- EMPLOYEE의 전체 사원수
select COUNT(*) from EMPLOYEE; 

-- 보너스를 받는 사원의 수 
select COUNT(BONUS) from EMPLOYEE;

-- 부서 배치를 받은 사원의 수 
select COUNT(DEPT_CODE) from EMPLOYEE; 

-- 중복 제거한 부서의 수 
select COUNT(distinct dept_CODE) from EMPLOYEE;

-- 여성 사원의 수 
select COUNT(*)
from EMPLOYEE 
where SUBSTR(EMP_NO, 8,1) in ('2','4');


--======================================================================================================================
--                                                     <PostgreSQL에서 형변환> 
--======================================================================================================================
-- 숫자 자료형
::int or :: integer => 정수 4byte
::numeric 			=> 소수(정수)
::real   			=> 실수 4byte

-- 문자 자료형
::TEXT				=> 길이 제한이 없는 문자열
::VARCHAR			=> 가변길이 문자열 
::VARCHAR(n)		=> 가변길이이지만 최대 n글자까지만 넣을 수 있음. 
::char(n)			=> 고정길이(n길이만큼)

-- 날짜 시간
::date				=> 날짜만 표시
::TIME 				=> 시간만 표시
::TIMESTAMP			=> 날짜와 시간 표시 
::INTERVAL			=> '1 MONTH'::INTERVAL

-- 기타 자료형
::BOOLEAN 			=> 참, 거짓
::JSON				=> JSON 자료형 '{"AGE" : 25}' :: JSON







