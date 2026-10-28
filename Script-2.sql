------------------------------- 종합 문제 ----------------------------------
-- 1. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
select emp_name, emp_no,  LPAD(SUBSTR(emp_no,1,2),4,'19')생년,SUBSTR(emp_no,3,2)as 생월, SUBSTR(emp_no,5,2) as 생일
from employee 


-- 2. EMPLOYEE테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
select emp_name, emp_no, RPAD(SUBSTR(EMP_NO,1,7),15,'*')
from employee


-- 3. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
select emp_name, HIRE_DATE, FLOOR(current_date -HIRE_DATE) "근무일수1", FLOOR(ABS(HIRE_DATE - current_Date)) "근무일수2"
from employee;

--   (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)

-- 4. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
select *
from employee where right(emp_id,1) in ('1','3','5','7','9');

-- 5. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
select emp_name, HIRE_DATE
from employee where ABS(current_date - HIRE_DATE) >= 20*365;


-- 6. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
select emp_name, salary, TO_CHAR(salary,'FML9,999,999') 급여
from employee;


-- 7. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이 조회
--   (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며 
--   나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)

select emp_name, dept_code,TO_DATE(SUBSTR(emp_no,1,7),'YYMMDD') , TO_CHAR(TO_DATE(SUBSTR(emp_no,1,7),'YYMMDD'),'YYYY"년" MM"월" DD"일"')
, floor((current_date - TO_DATE(SUBSTR(emp_no,1,7),'YYMMDD'))/365)
from employee ;





-- 8. EMPLOYEE테이블에서 부서코드가 D5, D6, D9인 사원만 조회하되 D5면 총무부
--   , D6면 기획부, D9면 영업부로 처리(EMP_ID, EMP_NAME, DEPT_CODE, 총무부)
--    (단, 부서코드 오름차순으로 정렬)
select EMP_ID, EMP_NAME, DEPT_CODE
, case when dept_code = 'D5' then '총무부'
	 when dept_code = 'D6' then '기획부'
	 else '영업부'
	 end as 부서코드
from employee  where dept_code in ('D5','D6','D9')




-- 9. EMPLOYEE테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 합 조회
select sum(salary*(1+coalesce(BONUS,0)))
from employee  where dept_code = 'D5'




-- 10. EMPLOYEE테이블에서 직원들의 입사일로부터 년도만 가지고 각 년도별 입사 인원수 조회
--      전체 직원 수, 2001년, 2002년, 2003년, 2004년
select HIRE_DATE
from employee 

