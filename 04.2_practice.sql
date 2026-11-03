-- 1. EMPLOYEE 테이블에서 부서코드(DEPT_CODE)별 평균 급여를 구하시오. (단, 부서코드가 NULL인 사원은 제외)
select dept_code, avg(salary) 부서별 평균급여
from employee 
group by dept_code

-- 2. EMPLOYEE 테이블에서 직급코드(JOB_CODE)별 보너스를 받는 사원 수를 구하시오. 단, 보너스를 받는 사원이 2명 이상인 직급만 조회하시오.
select job_code, count(bonus)
from employee
group by job_code 
having count(bonus) >= 2;

-- 3. EMPLOYEE 테이블에서 부서코드(DEPT_CODE)별 평균 급여가 3,000,000원 이상인 부서의 부서코드와 평균 급여를 조회하시오.
select dept_code, round(avg(salary))
from employee
group by dept_code 
having round(avg(salary)) >= 3000000

-- 4. EMPLOYEE 테이블에서 부서코드(DEPT_CODE)와 직급코드(JOB_CODE)별 사원 수와, 부서별 소계 및 전체 총계를 함께 조회하시오. 
select dept_code, job_code, count(*) as 사원수
from employee
group by rollup(dept_code, job_code) -- 부서별 소계 rollup 
order by dept_code, job_code nulls last; 

-- 5. EMPLOYEE 테이블에서 부서코드(DEPT_CODE)와 직급코드(JOB_CODE)별 평균 급여를 구하되, 부서별 소계, 직급별 소계, 전체 총계가 모두 출력되도록 작성하시오.
select dept_code, job_code, round(avg(salary)) as 평균급여
from employee
group by cube(dept_code, job_code) -- 부서별 소계 rollup 
order by dept_code, job_code nulls last; 

-- 6. EMPLOYEE 테이블에서 부서코드가 'D5'인 사원 또는 직급코드가 'J7'인 사원들의 이름, 부서코드, 급여를 중복 없이 조회하시오.
select emp_name, dept_code, salary
from employee
where dept_code='D5' or job_code='J7'


-- 7. EMPLOYEE 테이블에서 급여가 3,000,000원 이상이면서 입사일(HIRE_DATE)이 2010년 1월 1일 이후인 사원의 사번,이름, 급여를 조회하시오
select emp_id, emp_name, salary, HIRE_DATE
from employee 
where salary >= 3000000 and HIRE_DATE >='2010-01-01'



-- 8. EMPLOYEE 테이블에서 전체 사원의 사번, 이름, 부서코드를 조회하되, 부서코드가 'D5'인 사원들은 제외하고 조회하시오.
select emp_id, emp_name, dept_code
from employee
where dept_code != 'D5'
-- 데이터베이스의 목적 : 중복된 정보는 하나로 취급, 업데이트한 정보는 업데이트 동안 주소에 접근하지 못하도록 함. 