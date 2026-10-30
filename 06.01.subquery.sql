/*
 <SUBQUERY>
 - 하나의 SQL 문 안에 포함된 또 다른 SELECT 문 
 - 메인 SQL문을 위해 보조 역할을 하는 QUERY 문

*/

-- 박서준과 같은 부서에 속한 사원들을 이름 조회 
-- 1. 박서준의 부서코드 조회
select DEPT_CODE
from EMPLOYEE 
where emp_name = '박서준';  -- D9

-- 2. 부서코드가 D9인 사원들 조회
select EMP_NAME
from employee
where DEPT_CODE = 'D9'; 

select EMP_NAME
from employee
where DEPT_CODE = (select DEPT_CODE
					from EMPLOYEE 
					where emp_name = '박서준');

-- 전 직웑의 평균급여보다 더 많은 급여를 받는 사원들의 사번, 사원명, 급여를 조회
-- 1. 평균 급여
select AVG(SALARY)
from employee; --3047663 

-- 2. 급여가 3047662보다 많이 받는 사람
select EMP_ID, EMP_NAME, SALARY
from employee 
where salary > 3047662; 


--> 위의 단계를 하나의 쿼리문으로 
select EMP_ID, EMP_NAME, SALARY
from employee 
where salary > (select AVG(SALARY)
				from employee);

------------------------------------------------------------------------------------------------------------------------------
/*
 * 서브쿼리의 구분 
 * : 서브쿼리를 수행한 결과값이 몇행 몇열 이냐에 따라 구분 
 * 
 * - 단일행 서브쿼리 : 서브쿼리의 결과값이 오로지 1개 일때(한행 한열)
 * - 다중행 서브쿼리 : 서브쿼리의 결과값이 여러행 일때(여러행 한열)
 * - 다중열 서브쿼리 : 서브쿼리의 결과값이 여러열 일때(한행 여러열)
 * - 다중행 다중열 서브쿼리 : 서브쿼리의 결과값이 여러행 여러열 일 때 (여러행 여러열)
 * 
 * >> 서브쿼리의 종류에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
 */

/*
 * 1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
 * 	  : 서브쿼리의 결과값이 오로지 1개 일때(한행 한열)
 *    일반 비교언산자 사용
 *    =, !=, >, ...
 */

--1) 전 직원의 평균급여보다 급여를 적게 받는 사원들의 사원명, 직급코드, 급여 조회 
select emp_name, job_code, salary
from employee 
where salary < (select avg(salary)
                 from employee )
order by salary; 

--2) 최저급여를 받는 사원의 사번, 사원명, 급여, 입사일 조회
select emp_id, emp_name, salary, hire_date 
from employee
where salary = (select min(salary) from employee);

--3) 조정연 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 부서코드, 급여조회
select emp_id, emp_name,dept_code, salary
from employee
where salary > (select salary from employee where emp_name = '조정연');

-- JOIN
-- 4) 조정연 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 부서명, 급여 조회
select emp_ID, emp_NAME, dept_title, salary
from employee
join department on (dept_code = DEPT_ID)
where salary > (select salary from employee where emp_name = '조정연');

--5) 왕건우 사원과 같은 부서원들의 사번, 사원명, 전화번호, 입사일, 부서명 조회. 왕건우 제외
select emp_ID, emp_NAME, phone, HIRE_DATE, DEPT_TITLE
from employee
join department on (dept_code = dept_ID)
where dept_code = (select dept_code from employee where emp_name = '왕건우')
and emp_name != '왕건우';

-- GROUP BY
-- 6) 부서별 급여 합계가 가장 큰 부서의 부서코드, 급여의합 조회 
-- 6.1 부서별 급여합 중에서 가장 큰 값 하나만 조회
/* 안됨. 
select DEPT_CODE, max(sum(salary))
from employee 
group by DEPT_CODE; 
*/

select sum(salary)
from employee
group by dept_CODE 
order by sum(salary) desc
-- limit 1 -- 한 행만 가지고 오시오. -> 17,700,000
limit 2  

select max(총급여)
from ( select dept_code, sum(salary) as 총급여
		from employee
		group by dept_code)

-- 6.2 
select dept_code, sum(salary)
from employee 
group by dept_code 
having sum(salary) = 17700000;


select dept_code, sum(salary)
from employee 
group by dept_code 
having sum(salary) = (select sum(salary)
from employee
group by dept_CODE 
order by sum(salary) desc
limit 1 );		

-----------------------------------------------------------------------------------------------------------------------------

/*
 * 2. 다중행 서브쿼리
 *  : 서브쿼리의 결과값이 여러행 일 때 (여러행 한열)
 *  -IN 서브쿼리 : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면
 *   > ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 클 경우 
 *                  (여러개의 결과값 중 가장 작은값 보다 클 경우)
 *   < ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 작을 경우 
 *                  (여러개의 결과값 중 가장 큰값보다 작을 경우)
 *   비교대상 > ANY (ARRAY[값1, 값2, 값3 ...])
 * 	 비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3 
 */ 

-- 1) 조정연 또는 전지연 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여 조회 
-- 1.1 조정연 또는 전지연 사원의 직급
select job_CODE
from employee
where emp_name in ('조정연', '전지연');

-- 1.2 J3, J7인 사원들 조회
select emp_ID, EMP_NAME, job_CODE, SALARY
from employee
where job_code in ('J3','J7')

select emp_ID, EMP_NAME, job_CODE, SALARY
from employee
where job_code in (select job_CODE
				   from employee
				   where emp_name in ('조정연', '전지연'))			
				   
-- 2) 대리 직급임에도 불구하고 과정 직급 급여들 중 최소 급여보다 많이 받는 직원의 사번, 사원명, 직급, 급여를 조회하시오.
-- 2.1 과장 직급인 사원들의 급여 조회 
select salary
from employee 
join job using(job_code)
where job_NAME = '과장' ; -- 2,200 2,500 3,760

-- 2.2 직급이 대리이면서 급여값이 위의 목록들 중에 하나라도 큰 급여를 받는 사원

-- > 위의 쿼리문을 하나로
select emp_ID, EMP_NAME, job_NAME, salary
from employee 
join job using(job_code)
where job_name = '대리'
  and salary > any(array[2200000, 2500000,3760000]);


-- > 단일행 쿼리로도 가능				   
select emp_ID, EMP_NAME, job_NAME, salary
from employee 
join job using(job_code)
where job_name = '대리'
  and salary > any(select min(salary)
				   from employee 
				   join job using(job_code)
				   where job_NAME = '과장'); -- array 라는 말 꼭 안써도 괜찮음.

-- 3) 차장 직급임에도 과장직급의 급여보다 적게 받는 사원의 사번, 사원명, 직급명, 급여를 조회하시오. 
select emp_id, emp_name, job_name, salary
from employee e
join job using(job_code)
where job_name = '차장'
  and salary < any(select salary 
  				    from employee
                    join job using (job_code)
                    where job_name = '과장');

-- 4) 과장 직급임에도 차장 직급인 사원들의 
-- 모든 급여보다 더 많이 받는 사원의 사번, 사원명, 직급명, 급여 조회 
select emp_id, emp_name, job_name, salary
from employee 
join job using(job_code)
where job_name = '과장'
  and salary > any(select salary
  				   from employee
  				   join job using(job_code)
  				   where job_name = '차장');

-- 차장의 가장 많이 받는 급여보다 더 많이 받는 과정
-- > ANY : 비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
--         가장 작은값보다 큰값은 모두
-- ALL : 비교대상 > 값1 AND 비교대상 > 값2 AND 비교대상 > 값3
--         가장 큰값보다 큰값은 모두
select emp_id, emp_name, job_name, salary
from employee 
join job using(job_code)
where job_name = '과장'
  and salary > ALL(select salary
  				   from employee
  				   join job using(job_code)
  				   where job_name = '차장');				   
				   
-----------------------------------------------------------------------------------------------------------------------------

/*
 * 3. 다중열 서브쿼리
 *   : 한행 여러열
 */ 				   
-- 1) 장예은 사원과 같은 부서코드, 같은 직급코드에 해당하는 직원들의 
-- 사원명, 부서코드, 직급코드, 입사일 조회 
select emp_name, dept_code, job_code, HIRE_DATE
from employee 
where dept_code = (select dept_code from employee where emp_name = '장예은') 
	and job_code = (select job_code from employee where emp_name = '장예은') 
				   
-->> 다중열 서브쿼리로 
select emp_name, dept_code, job_code, HIRE_DATE
from employee 
where (DEPT_CODE, JOB_CODE) = (select dept_code, JOB_CODE from employee where emp_name = '장예은')
				   
-- 지민재 사원과 같은 직급코드, 같은 사수를 가지고 있는 사원들의 
-- 사번, 사원명, 직급코드, 사수번호 조회		

select emp_id, emp_name, job_code, manager_id
from employee
where (job_code, manager_id) = (select job_code, manager_id from employee where emp_name = '지민재')

-----------------------------------------------------------------------------------------------------------------------------

/*
 * 4. 다중행 다중열 서브쿼리
 * : 여러행, 여러열
 */ 
--1) 각 직급별 최소급여 금액을 받는 사원들의 사번, 사원명, 직급코드, 급여 조회 
-- 1.1 각 직급별 최소급여 금액과 직급코드 조회 
select job_code, min(salary)
from employee
group by job_code;
order by 1 desc; 


select emp_id, emp_name, job_code, salary
from employee 
group by job_code = 'J1' and salary = 8000000
	  or job_code = 'J2' and salary = 3700000
	  ....; 

select emp_id, emp_name, job_code, salary
from employee 
where (job_code, salary) = ('J1',8000000)
   or (job_code, salary) = ('J2',3700000)
   ...;

select emp_id, emp_name, job_code, salary
from employee 
where (job_code, salary) in (('J1',8000000),('J2',3700000)...)

-- >> 서브쿼리 적용
select emp_id, emp_name, job_code, salary
from employee 
where (job_code, salary) in (select JOB_CODE, min(SALARY)
                                 from employee e 
                                 group by job_code)
order by 3;

-- 2) 각 부서별 최고 급여를 받는 사원들의 사번, 사원명, 부서코드, 급여 조회

select emp_id, emp_name, dept_code, salary
from employee 
where (dept_code, salary) in (select dept_CODE, max(SALARY)
                                 from employee e 
                                 group by dept_code)
order by 3;
-----------------------------------------------------------------------------------------------------------------------------
/*
 * 5. INLINE VIEW
 *  FROM 절에 서브쿼리 작성
 * 서브쿼리를 수행한 결과를 마치 테이블처럼 사용 
 * 
 * * PostgreSQL 16버전 이상은 인라인뷰에 별칭을 안붙여도 알아서 매칭
 * * PostgreSQL 16버전 미만 이거나 다른 DBMS(My SQL등) 반드시 인라인뷰에 별칭을 붙여줘야 됨. 
 */
-- 사원들의 사번, 이름, 보너스를 포함한 연봉(별칭부여), 부서코드 조회
-- 단, 보너스포함 연봉이 3000만원 이상인 사원들만 조회


select emp_id, emp_name, salary*coalesce(1+BONUS, 1)*12 연봉,dept_code
from employee
where salary*coalesce(1+BONUS, 1)*12 >= 30000000;

-- WHERE 절에 별칭을 사용하려면 INLINE VIEW 사용
select EMP_NAME, E. 연봉
from (select emp_id, emp_name, salary*coalesce(1+BONUS, 1)*12 연봉,dept_code
        from employee) E
where 연봉 >= 40000000;
-- INLINE VIEW 서브쿼리의 컬럼명만 메인 쿼리에서 호출가능

-----------------------------------------------------------------------------------------------------------------------------
/*
 6. WITH
   서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름으로 FROM 절에 기술가능
   
   WITH 이름 (마음대로) AS (서브쿼리)
   최종실행 메인쿼리; 
   
   with 이름(마음대로) AS (서브쿼리),
        이름(마음대로) AS (서브쿼리)
   최종실행메인쿼리; 
   
 */ 
with TOPN_SAL1 as (select DEPT_CODE, round(AVG(SALARY)) 평균급여
				    from employee 
				    group by dept_code 
				    order by 2 desc)
select * 
from TOPN_SAL1 
limit 2;
				    
with TOPN_SAL1 as (select DEPT_CODE, round(AVG(SALARY)) 평균급여
				    from employee 
				    group by dept_code 
				    order by 2 desc
				    limit 2)				    
   
-----------------------------------------------------------------------------------------------------------------------------
/*
 7. 순위 매기는 함수 (WINDOW FUNCTION) 
   RANK(), OVER(정렬기준) | DENSE_RANK() OVER(정렬기준)
   - RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원수 만큼 건너띄고 순위계산
   						   EX) 공동1위가 2명이면 그 다음 순위는 3위
   - DENSE_RANK() OVER(정렬기준) : 동일한 순위가 있어도 다음 등수는 무조건 1씩 증가
   						   EX) 공동1위가 2명이면 그 다음 순위는 2위
   >> SELECT절에서만 사용 가능
 */
-- 급여가 높은 순서대로 순위를 매겨서 사원명, 급여, 순위 조회 
select emp_name, salary, rank() over(order by SALARY desc) 순위
from employee; 

select emp_name, salary, DENSE_rank() over(order by SALARY desc) 순위
from employee;

-- 급여가 상위 5위인 사원의 사원명, 급여, 순위 조회
--select emp_name, salary, rank() over(order by salary desc) 순위
--from employee
--where rank() over(order by salary desc) <= 5
---- 오류 SELECT 절에서만 사용가능

--> INLINE VIEW 사용
select *
from (select emp_name, salary, rank() over(order by SALARY desc) 순위
      from employee)
where 순위 <= 5;

-->> WITH로 사용
with TOPN_SAL as (select emp_name, salary, rank() over(order by SALARY desc) 순위
      from employee)
select * 
from TOPN_SAL
where 순위 <= 5;

-- >> TOP-N 분석 
/*
 * 원하는 기능                 PostgreSQL문법
 * ---------------------------------------------------------------------
 * 상위 5개                   LIMIT 5
 * 상위 3개                   LIMIT 3
 * 상위 6~10위                LIMIT 5 OFFSET 5 
 * 결과에 순번 출력             ROW_NUMBER() OVER(정렬기준)
 * 표준 SQL 상위 5개           FETCH FIRST 5 ROWS ONLY
 * 
 */

-- 급여가 높은 상위 5명 조회 
select emp_name, salary
from employee 
order by salary desc
limit 5; 

--순번까지 출력 
select row_number() over(order by SALARY DESC) 순위, emp_name, salary
from employee 
order by salary desc
limit 5;

--- 가장 최근에 입사한 사원 5명의 사원명, 급여, 입사일 조회 
select emp_name, salary, hire_date
from employee
order by hire_date desc
limit 5;

-- 부서별 평균급여가 높은 상위 3개 부서 조회
select dept_code, round(avg(salary)) 평균급여
from employee 
group by dept_code
order by 평균급여 desc
limit 3;

-- 급여가 높은 상위 6위 ~ 8위까지 조회
select emp_name, salary
from employee 
order by salary desc
limit 4 offset 5; 

---------------------- INLINE 

-- 급여가 높은 상위 5행 조회
select emp_name, salary
from employee 
order by salary desc
limit 6; 
-- 5위 2명이어도 5행만 가져옴
-- 정확히 5위까지 가져오려면 INLINE VIEW 사용해야됨. 
select * 
from (select emp_name, salary, DENSE_RANK() over(order by SALARY desc) 순위
      from employee)
where 순위 <= 5; 

-- 2) 집계(GROUP BY) 후 다른 테이블과 조인(JOIN 할 때)
-- 부서별 평균급여를 구한 뒤에 부서 정보와 조인 : 
select * 
from (select DEPT_CODE, ROUND(AVG(SALARY)) 평균급여
	  from employee
	  group by dept_code)
join DEPARTMENT on (dept_code = dept_id); 

-- 3) 급여 구간별 인원수 
select 급여구간, count(*) 인원수 
from (select emp_name, 
	    case when salary >= 5000000 then '고급급여'
	         when salary >= 3000000 then '중급급여'
	         else '초급급여'
	    end 급여구간
	   from employee)
group by 급여구간; 

-- 4) 사원명, 급여, 부서평균
select emp_NAME, SALARY, 부서평균
from employee E 
join (select DEPT_CODE, ROUND(AVG(SALARY)) 부서평균
        from employee
      group by DEPT_CODE
      ) Using (DEPT_CODE)
where SALARY > 부서평균; 








