-- SUBQUERY_연습문제
-- 1. 70년대 생(1970~1979) 중 여자이면서 이씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회 
select emp_name, emp_no, dept_code, job_code 
from employee 
where emp_name = (select emp_name from employee 
where emp_no like '7%' and SUBSTR(emp_no,8,1) in ('2','4') and emp_name like'이%');

-- where substr(emp_no, 1,2) >= '70' and substr(emp_no, 1,2) <= '79' and substr(emp_no, 8,1) in ('2','4') and

--EXTRACT()
select emp_name, emp_no, dept_title, job_name
from employee
join department on (dept_code = dept_id)
join job using (job_code)
where extract(year from to_date('19' || substr(emp_no, 1, 2),'YYYY')) -- 정확히 하려면 
	  between 1970 and 1979
	  and substr(emp_No,8,1) in ('2','4')
	  and emp_name like '이%';

-- TO_CHAR() 사용
select emp_name, emp_no, dept_title, job_name
from employee
join department on (dept_code = dept_id)
join job using(job_code)
where to_char('19' || to_date(substr(emp_no, 1, 2),'YY'), 'YYYY') ::INT
	  between '1970' and '1979'
	  and substr(emp_no, 8, 1) in ('2','4')
	  and emp_name like '이%';


-- 2. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회-- 
select emp_id, emp_name, emp_no , dept_code, job_code  
from employee 
where 

-- 정답 -> extract 는 연도만 같은 사람만 나옴, 
select emp_ID, emp_name, (current_DATE - to_date(substr(emp_no,1,6),'YYMMDD'))/365 나이, dept_title, job_name
from employee 
join department on (dept_code = dept_id)
join job using(job_code)
order by 3 asc;

-- extract(year from current_date) - extract(year from to_date(substr(emp_no,1,2),'YY')), dept_title, job_name

-- 3. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회
select emp_id, emp_name, job_name
from employee
join job using(job_code) -- join 이후 겹치는거 있다고 작성하기!! 
where emp_name like '%하%' ---> new 

-- 4. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
select emp_name, job_name, dept_code, dept_title
from employee
join department on (dept_code = dept_id)
join job using(job_code)
where dept_code in ('D5', 'D6');


-- 5. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
select emp_name, bonus, dept_title, local_name
from employee 
left join department on (dept_code = dept_id)
left join location on (location_id = local_code) -- join 은 바로앞에꺼까지 겹치는거 표시하기
where bonus is not null;   -- 부서명 지역명 없는사람 존재해서 left join으로 적용해야함. 


-- 6. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회
select emp_name, job_name , dept_title, local_name
from employee
left join department on (dept_code = dept_id)
left join job using(job_code)
left join location on (location_id = local_code);

-- 7. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회 
select emp_name, dept_title, local_name, national_name
from employee
join department on (dept_code = dept_id)
join location on (location_id = local_code)
join national using(national_code)
where national_name in ('한국','일본')


-- 8. 하정연 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회 -- 서브쿼리이용하기
select emp_name, dept_code
from employee e 
where dept_code = (select dept_code from employee where emp_name = '하정연');

-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 사원명, 직급명, 급여 조회
select emp_name, job_name, salary
from employee
join job using (job_code)
where bonus is null and job_code in ('J4','J7');

-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
select ent_yn, count(*)
from employee 
group by ent_yn;

-- 11. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회
select *
from ( select emp_id, emp_name, dept_title, job_name, hire_date, 
		row_number() over(order by (salary + (salary * coalesce(BONUS, 0))*12) desc
		) as 연봉
		from employee
		join department on (dept_code = dept_ID)
		join job using(job_code)
)
limit 5;
-- 서브쿼리로 안해도 ㅇㅋ
select emp_id, emp_name, dept_title, job_name, hire_date, 
		row_number() over(order by (salary + (salary * coalesce(BONUS, 0))*12) desc
		) as 연봉
from employee
join department on (dept_code = dept_ID)
join job using(job_code)
limit 5;



-- 12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--	12-1. JOIN과 HAVING 사용                

select dept_title, sum(Salary)
from employee 
join department on (dept_code = dept_id) 
group by dept_title
having sum(salary) > (select sum(salary) * 0.2
						from employee)
						
--	12-2. 인라인 뷰 사용
select *
from (select dept_title, sum(Salary) 급여총합
	  from employee 
	  join department on (dept_code = dept_id) 
	  group by dept_title)
where 급여총합 > (select sum(salary) * 0.2 from employee); 						
								
--	12-3. WITH 사용
with TOTAL_SAL as (
	  select dept_title, sum(Salary) 급여총합
	  from employee 
	  join department on (dept_code = dept_id) 
	  group by dept_title
	  )
select * 
from TOTAL_SAL 
where 급여총합 > (select sum(salary) * 0.2 from employee); 			

-- 13. 부서명별 급여 합계 조회(NULL도 조회되도록) -> left join 이용하기
select dept_title, sum(salary) as 급여합계
from employee 
left join department on (dept_code = dept_id)
group by dept_title; 

-- 14. WITH를 이용하여 급여합과 급여평균 조회
-- 1) UNION 사용하여 2행에
with sum_sal as (select '급여합계'as 구분, sum(salary) as 금액 from employee), 
	 avg_sal as (select '급여평균'as 구분, round(avg(salary)) as 금액 from employee)
select * from sum_sal 
union
select * from avg_sal; 

-- 2) 1행에 2열로 
with sum_avg as (select sum(salary) as 급여합계, round(avg(salary)) as 급여평균 from employee)
select * from sum_avg;







