/*
 <GROUP BY절>
 그룹기준을 제시할 수 있는 구문 (그룹 기준별로 여러 그룹으로 묶을 수 있음)
 여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
*/

select SUM(SALARY)
from employee; 

--- 각 부서별 총 급여의 합
select dept_CODE, sum(salary)
from employee
group by DEPT_CODE;

-- 각 부서별 사원수
select DEPT_CODE, COUNT(*)
from employee
group by DEPT_CODE; 

-- 각 부서별 급여의 합과 사원수
select dept_code, sum(salary), COUNT(*)
from employee 
group by dept_code 
order by dept_code; -- 코드별로 오름차순 정렬

-- 직급별 인원수와 급여의 합
select JOB_CODE, COUNT(*), SUM(salary)
from employee
group by job_Code;

-- 각 직급별 총 사원수, 보너스를 받는 사원수, 급여합, 급여의 평균, 최저급여, 최고급여
select job_code
	   ,count(*) as 총사원수
	   , count(bonus) as "보너스를 받는 사원수"
	   , sum(salary) as 급여합
	   , round(avg(salary), -1) as 급여평균
	   , min(salary) as 최저급여
	   , max(salary) as 최고급여
from employee
group by job_code -- group by는 where 절은 안씀!
order by 1;

-- 남성, 여성별 사원수
select case when SUBSTR(EMP_NO, 8, 1) in('1','3') then '남' 
			when SUBSTR(EMP_NO, 8, 1) in('2','4') then '여'
	    end as 성별
	  , COUNT(*) as 사원수 -- case when 안붙이면 체크형식으로만 나옴.
from EMPLOYEE
group by 성별
order by 성별;

-- GROUP BY 절에 여러 컬럼 기술 가능
select DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
from employee
group by DEPT_CODE, JOB_CODE; -- 두개 넣으면 두개의 한 쌍이 고유해야함. 

-- 입사년도별 급여의 합계
select case when to_char(hire_date,'YYYY') >= '1990' and to_char(hire_date,'YYYY') <='1999' then '1900년대'
					  when to_char(hire_date,'YYYY') >= '2000' and to_char(hire_date,'YYYY') <='2009' then '2000년대'
					  when to_char(hire_date,'YYYY') >= '2010' and to_char(hire_date,'YYYY') <='2019' then '2010년대'
					  when to_char(hire_date,'YYYY') >= '2020' and to_char(hire_date,'YYYY') <='2029' then '2020년대'
			     end as 분류, sum(salary)
from employee
group by 분류
order by 1


----------------------------------------------------------------------------------------------------------------------------------------------
/*
 * <HAVING 절>
 * 그룹에 대한 조건을 제시할 때 사용 
 */
-- 각 부서별 급여 평균 조회 
select DEPT_code, AVG(salary)
from employee
group by DEPT_CODE; 

--- 각 부서별 평균급여가 300만원 이상인 부서들만 조회
/*
select DEPT_code, AVG(salary)
from employee
where AVG(salary) >= 3000000  -- 그룹에 대한 조건은 where 절 안됨. 
group by DEPT_CODE;
*/
-----------------------------------------------------------
select DEPT_CODE, ROUND(AVG(SALARY))
from employee
group by DEPT_CODE;
having AVG(SALARY) >= 3000000;

/*
 * <실행 순서>
 * FROM
 * WHERE
 * GROUP BY (SELECT에서 별칭을 사용할 수 있도록 예외로 둠)
 * HAVING
 * SELECT
 * DISTINCT
 * ORDER BY
 */

---------------------------------------------------- 실습문제 ----------------------------------------------

-- 1. 직급별 급여의 합 (조건 : 직급별 급여의 합이 1000만원 이상인 직급만 조회), 직급코드, 급여합 조회

-- 2. 부서별 보너스를 받는 사원이 없는 부서만 부서코드 조회 

select job_code, sum(salary)
from employee
group by job_code
having sum(salary) >= 10000000;
order by 1;
----------------------
select DEPT_CODE, COUNT(BONUS)
from employee
group by DEPT_CODE;
----------------------
select DEPT_CODE
from employee
group by DEPT_CODE
having COUNT(BONUS) = 0

--------------------------------------------------------------------------------------------------------------
/*
 * <집계함수>
 * 그룹별 산출된 결과 값에 중간집계를 계산해 주는 함수 
 * 
 * ROLLUP, CUBE
 * => GROUP BY 절에 기술하는 함수
 * 
 * - ROLLUP(컬럼1, 컬럼2) : 컬럼1을 가지고 중간집계를 내는 함수
 * - CUBE(컬럼1, 컬럼2) : 컬럼1을 가지고 중간집계내고, 컬럼2를 가지고도 중간집계를 냄. 
 * 
 */
-- 각 직급별 급여의 합
select job_code, sum(salary)
from employee
group by JOB_CODE; 

select job_code, sum(salary)
from employee 
group by cube(job_code);
-- 그룹 기준이 하나의 컬럼일때는 ROLLUP, CUBE 차이가 없음

select DEPT_CODE, JOB_CODE, SUM(SALARY) 
from employee 
group by DEPT_CODE, JOB_CODE; 

-- ROLLUP(컬럼1, 컬럼2) : 컬럼1만 중간집계
select DEPT_CODE, JOB_CODE, SUM(SALARY)
from employee 
group by rollup(dept_code,job_code)
order by DEPT_CODE, job_CODE nulls last;

-- CUBE(컬럼1, 컬럼2) : 컬럼1, 컬럼2 중간집계 
select DEPT_CODE, JOB_CODE, SUM(SALARY)
from employee 
group by cube(dept_code,job_code)
order by DEPT_CODE, job_CODE nulls last;

--------------------------------------------------------------------------------------------------------------
/*
 * <집합 연산자>
 * 여러개의 쿼리문을 가지고 하나의 쿼리문을 만드는 연산자
 * - UNION : 합집합(OR)
 * - INTERSECT : 교집합(AND)
 * - UNION ALL : 합집합 + 교집합 -> 겹치는건 두번 카운트 
 * - EXCEPT : 차집합
 * 
*/
-------------------------------------------------- 1. UNION
-- 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원의 사번, 사원명, 부서코드, 급여 조회
-- 부서코드가 D5인 사원 
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5';    -- 6명
-- 급여가 300만원 초과
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where SALARY >= 3000000 ; -- 8명

--UNION
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5'    -- 6명
UNION
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where SALARY >= 3000000 ;

-- OR의 결과와 동일
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5' or salary >= 3000000;

--------------------------------------------2. INTERSECT
-- 부서코드가 D5이면서 급여가 300만원 초과인 사원들 조회
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from employee 
where DEPT_CODE = 'D5'
intersect 
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from employee
where SALARY >+ 3000000; 

-- AND로도 가능
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from employee 
where DEPT_CODE = 'D5' and SALARY >+ 3000000; 

-- 집합연산자 사용시 유의사항
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from employee 
where DEPT_CODE = 'D5'
intersect 
select EMP_ID, EMP_NAME, DEPT_CODE
from EMPLOYEE
where SALARY >= 3000000 -- select 의 개수가 동일해야함.
-- 각 쿼리문의 select 절에 작성되는 컬럼의 갯수는 동일해야함. 
-- 컬럼의 갯수 뿐 아니라 각 컬럼마다 동일한 타입이 기술되어야 한다. 
-- 타입과 갯수가 동일해도 같은 컬럼이 아니면 오류나지 않지만 결과 set이 안나옴. 

--------------------------------------------3. UNION ALL
-- 부서코드가 D5이면서 급여가 300만원 초과인 사원들 모두(겹치는 데이터포함) 조회
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from employee 
where DEPT_CODE = 'D5'
union all
select EMP_ID, EMP_NAME, DEPT_CODE, salary
from EMPLOYEE
where SALARY >= 3000000
order by 1;

--------------------------------------------4. EXCEPT
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from employee 
where DEPT_CODE = 'D5'
EXCEPT
select EMP_ID, EMP_NAME, DEPT_CODE, salary
from EMPLOYEE
where SALARY >= 3000000
order by 1;

select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from employee 
where DEPT_CODE = 'D5' and SALARY < 3000000; 



