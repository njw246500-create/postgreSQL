/*
 * DML 
INSERT : 테이블에 데이터 삽입 
UPDATE : 테이블의 데이터를 수정
DELETE : 테이블의 데이터(행)을 삭제

*/
--==================================================================
/*
	1. INSERT
	   테이블에 새로운 행을 추가하는 구문
	   
	   [표현식]
	   1) INSERT INTO 테이블명 VALUES (값1, 값2, 값3, .... ); 
	   테이블의 모든 컬럼에 대한 값을 직접 한꺼번에 넣고 할 때 사용
	   컬럼의 순서를 지켜 VALUES에 값을 나열해야함 
*/
insert into employee_copy values(300, '더조은','031103-3123456','tjoeun@google.com'
, '01056784689','D3','J9',3500000, 0.1, 208, '2025-08-15', null, default);

-------------------------------------------------------------------------------------
/*
    2) INSERT INTO 테이블명(컬럼명1, 컬럼명2, ...) VALUES (값1, 값2, ...);
      테이블에 내가 선택한 컬럼에 대한 값만 삽입할 때 사용
      그래도 한 행 단위로 추가됨.
      ** 주의 : NOT NULL인 컬럼은 반드시 값이 들어가야 함.
      - 기본값이 지정되어 있는 것은 값을 안넣으면 (컬럼을 아예 안넣음) 자동으로 기본값이 들어감.
 */
insert into employee_copy(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
values (301, '이티어', '051111-4123456','J5',CURRENT_DATE);

-- 컬럼을 제시할 때 순서와 상관없이 해도 됨.
-- 그러나 데이터값은 제시한 컬럼의 순서와 동일해야 됨. 
insert into employee_copy(EMP_NAME, EMP_ID, JOB_CODE, HIRE_DATE, EMP_NO)
values ('이티어', 303, 'J5', CURRENT_DATE, '051111-4123456');

insert into employee_copy(EMP_ID, EMP_NAME, EMP_NO, HIRE_DATE)
values (302, '황반가', '040111-4567845',CURRENT_DATE);
-- 오류 NOT NULL인 JOB_CODE를 안넣어서

-------------------------------------------------------------------------------------
/*
    3) INSERT INTO 테이블명 (서브쿼리);
       VALUES로 값을 직접 명시하는 대신에 서브쿼리로 조회된 결과값을 모두 INSERT 함. 
       여러행도 가능

*/
-- EMP_01 테이블 생성
create table EMP_01(
	EMP_ID VARCHAR(3),
	EMP_NAME VARCHAR(20),
	DEPT_NAME VARCHAR(35)
);
-- 전체 사원들의 사번, 이름, 부서명 조회
select EMP_ID, EMP_NAME, DEPT_TITLE
  from employee e 
  left join department on (dept_CODE = DEPT_ID); 

-- EMP_01 테이블에 데이터 삽입
insert into emp_01 
  select EMP_ID, EMP_NAME, DEPT_TITLE
  from employee e 
  left join department on (dept_CODE = DEPT_ID);

-------------------------------------------------------------------------------------
/* 
        4) WITH 절로 두개 이상의 테이블레 한꺼번에 INSERT
           WITH절 안에서 INSERT, UPDATE, DELETE 같은 데이터 변경 작업도 수행 가능 
           이를 CTE(DATA-MODIFYING) 라고 부름 
 */
-- 테이트할 테이블 2개 생성 -- 구조만 가지고 와서 테이블을 형성하는것. 
create table EMP_DEPT
as select EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
	from employee 
	where 1 = 0;

create table EMP_MANAGER
as select emp_ID, EMP_NAME, MANAGER_ID
	from employee
	where 1=0;


-- 부서코드가 D1인 사원들의 사번, 이름, 부서코드, 입사일, 사수사번 조회
select EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
from employee 
where dept_code = 'D1';

with DATA_INFO as (
	select EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
	from employee 
	where dept_code = 'D1' 
),
INFO1 as (
	insert into emp_DEPT (EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
	select EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
	  from DATA_INFO )
insert into emp_manager (emp_ID, EMP_NAME, MANAGER_ID)
	select emp_ID, EMP_NAME, MANAGER_ID -- commit 을 한 것임. 
	  from DATA_INFO ;	  
/* 테이블이 더 있으면 아래와 같이 계속 넣어주면 됨
INFO2 as (
   insert into emp_ETC ( EMP_ID, EMP_NAME, DEPT_CODE)
   select EMP_ID< EMP_NAME, DEPT_CODE
   	 from DATA_INFO
)
with 문 다음에는 반드시 select 가 와야함. 
10개 테이블에 각각 여러 정보를 넣을때 사용.  
note) framework : 문법이 정해져 있어서 정해진것을 따르는것 ex sql
      programming : 자유로움 ex python 
 */
--=======================================================================
/*
   2. UPDATE 
      테이블에 기록되어 있는 기존 데이터를 수정하는 구문 
      
      [표현식]
      UPDATE 테이블명 
      SET 컬럼명 = 바꿀값,
          컬럼명 = 바꿀값, 
          ....
 
      [WHERE 조건]; --> 주의 : 생략하면 전체 모든 행의 데이터가 변경됨
 */	  
-- 테이블 생성
create table DEPT_COPY
as select * from department;

-- D9 부서의 부서명을 '전략기획팀'으로 수정
update DEPT_COPY 
set DEPT_TITLE = '전략기획팀'

select * from dept_copy;

rollback;
select * from dept_copy;

update dept_copy
set dept_title = '전략기획팀'
where dept_id = 'D9';
commit;

-- 복사본 테이블 생성
create table EMP_SALARY
as select emp_id, emp_NAME, DEPT_CODE, SALARY, BONUS
	from EMPLOYEE; 
commit;

-- 지민재 사원의 급여를 200만원으로 변경
update EMP_SALARY 
set SALARY = 2000000
where EMP_NAME = '지민재';

select * from emp_salary; 

-- 이정하 사원의 급여를 700만원으로 변경, 보너스를 0.2로 넣기 
update EMP_SALARY 
set salary = 7000000, 
    bonus = 0.2
where EMP_NAME = '이정하'; 

select * from EMP_SALARY;

-- 전체 사원의 급여를 10% 인상 
update emp_SAlary 
set salary = salary * 1.1;
commit; -- 하면 데이터가 바뀐다. 

----------------------------------------------------------------------------------------
/*
-- UPDATE시 서브쿼리 사용 가능
   [표현법]
   UPDATE 테이블명 
   SET 컬럼명 = (서브쿼리)
   WHERE 조건; 
 
*/
-- 정훈 사원의 급여와 보너스를 조정연 사원의 급여와 보너스값으로 변경
-- 단일 컬럼 서브쿼리
update EMP_SALARY 
set salary = (select salary 
			    from emp_salary 
			   where emp_name = '조정연'),
     BONUS = (select bonus
                from emp_salary
               where emp_name = '조정연')
where emp_name = '정훈';
select * from emp_salary;

-- 다중열 서브쿼리
update EMP_SALARY
set (salary, bonus) = (select salary, bonus 
			             from emp_salary 
			            where emp_name = '조정연')
where emp_name = '황승현';

-- 전지연, 선우진, 현준혁, 배윤서, 전재민 사원들의 보너스와 급여를 홍지유 사원과 같은 금액으로 변경
update emp_salary 
set (salary, bonus) = (select salary, bonus 
                         from emp_salary 
                        where emp_name = '홍지유')
where emp_name in ('전지연', '선우진', '현준혁', '배윤서', '전재민')
 
-- ASIA 지역에 근무하는 사원들의 보너스를 0.6으로 변경
-- ASIA 지역에서 근무하는 사원
select emp_id, emp_name
from emp_salary 
join department on (dept_code = dept_id)
join location on (location_id = local_code)
where local_name like 'ASIA2';

update emp_SALARY 
set bonus = 0.6
where emp_id in (select emp_id
				from emp_salary 
				join department on (dept_code = dept_id)
				join location on (location_id = local_code)
				where local_name like 'ASIA2');

commit; --> 데이터베이스 확정적으로 고정 
-----------------------------------------------------------------------------------------
-- update시에도 해당 컬럼에 대한 제약조건에 위배되면 안됨
-- 사번이 200번인 사원의 이름을 null로 변경
update employee 
set emp_name = null
where emp_id = '200';

-- primary key 오류
update employee 
set emp_id = 200
where emp_name = '이정하';

-- foreign key(외래키) 오류
update employee 
set dept_code = 'D0'
where emp_name = '이정하';

----------------------------------------------------------------------------------------
/* 
  3. DELETE 
  	테이블의 데이터를 행 단위로 삭제하는 구문
  	
  	[표현식]
  	DELETE from 테이블명 
  	[where 조건]; -- 중요!!! -- 조건을 안 넣으면 테이블 전체 행이 삭제됨.
 */
rollback;

delete from employee_copy; 
where emp_id = '201';

select * from employee_copy; 

-- 외래키 때문에 삭제 거부됨
delete from department
where dept_id = 'D1';

/*   	
  * Truncate : 테이블 전체 행을 삭제할 때 사용하는 구문
    DELETE 보다 수행 속도가 빠름 
    ROLLBACK이 불가

	[표현식]
	TRUNCATE TABLE 테이블명;
 */
truncate table emp_salary; 

select * from emp_salary;

rollback;











