-- 1. 모든 사원의 사번, 사원명, 부서명을 조회하시오.
--    부서가 배정되지 않은 사원도 포함하고, 사번 오름차순으로 정렬하시오.
select emp_ID, EMP_NAME, DEPT_TITLE
from employee 
left join DEPARTMENT on (DEPT_CODE = DEPT_ID)
order by 1;

-- 2. 모든 사원의 사원명, 직급명을 조회하시오.
--    직급명이 '대리'인 사원만 조회하고 사원명 오름차순으로 정렬하시오.
select EMP_NAME, JOB_NAME
from employee 
join job using(job_code)
where job_name = '대리'
order by 1; -- 사원명이 첫번쨰 컬럼에 있어서

-- 3. 부서가 배정된 사원의 사원명, 부서명, 급여를 조회하시오.
--    급여가 3000000 이상인 사원만 급여 내림차순으로 정렬하시오.
select EMP_NAME, DEPT_TITLE, SALARY
from employee 
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
where salary >= 3000000
order by 3 desc;

-- 4. 모든 부서의 부서명과 소속 사원 수를 조회하시오.
--    사원이 한 명도 없는 부서도 0명으로 출력하고, 부서코드 오름차순으로 정렬하시오.
select DEPT_TITLE, count(EMP_ID) -- primary key 널값을 가지면 안되고, 고유해야함. 없는것도 나타남
from department 
left join employee on (dept_ID = DEPT_CODE)
group by dept_title
order by dept_title; 

-- 5. 사원명, 부서명, 직급명을 조회하시오.
--    부서가 배정되지 않은 사원도 포함하고 사번 오름차순으로 정렬하시오.
select EMP_NAME, DEPT_TITLE, JOB_NAME
from employee
left join DEPARTMENT on (DEPT_CODE = DEPT_ID)
join JOB using(JOB_CODE)
order by emp_ID

-- 6. 부서가 배정된 사원의 사원명, 부서명, 근무 지역명, 국가명을 조회하시오.
--    사번 오름차순으로 정렬하시오.
/*EMPLOYEE,    DEPT_CODE              JOB_CODE      SALARY
 * DEPARTMENT, DEPT_ID   LOCATION_ID
 * JOB                                JOB_CODE
 * LOACTION,             LOCAL_CODE   NATIONAL_CODE
 * NATIONAL                           NATIONAL_CODE 
 * SAL_GRADE                                        SEL_LEVEL
 */
select EMP_NAME, DEPT_TITLE, LOCAL_NAME, national_name
from employee
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
join location on (location_ID = LOCAL_CODE)
join national using(NATIONAL_CODE)
order by EMP_ID;

-- 7. 관리자 사번이 등록된 사원의 사원명과 관리자명을 조회하시오.
--    해당 관리자 사번을 가진 사원이 EMPLOYEE 테이블에 실제로 존재하는 경우만 출력하시오.
select 

-- 8. 모든 사원의 사원명, 급여, 급여등급을 조회하시오.
--    급여등급은 급여가 최소급여와 최대급여 사이에 있는 경우 매칭하고, 사번 오름차순으로 정렬하시오.


-- 9. 부서별 부서명, 평균급여를 조회하시오.
--    소속 사원이 2명 이상인 부서만 조회하고 평균급여 내림차순으로 정렬하시오.
select dept_title, round(avg(salary))
from employee 
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
group by dept_ID 
having count(EMP_ID) >= 2
order by 2 desc; 


-- 10. 모든 국가의 국가명과 해당 국가에 위치한 부서의 소속 사원 수를 조회하시오.
--     소속 사원이 없는 국가도 0명으로 출력하고, 사원 수 내림차순, 국가명 오름차순으로 정렬하시오.
select NATIONAL_NAME, COUNT(emp_ID) 소속사원수
from national
left join location using(national_code)
left join department on (local_code = location_id)
left join employee on (dept_ID = dept_code)
group by national_name 
order by 소속사원수 desc, NATIONAL_NAME; 








