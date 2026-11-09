/*
   [문제]
   사원의 급여가 변경될 때마다 변경 전 급여와 변경 후 급여를
   별도의 이력 테이블에 자동으로 기록하는 트리거 작성하기.

   1. EMPLOYEE 테이블에서 사번, 사원명, 급여 컬럼만 복사하여 PRACTICE_EMPLOYEE 테이블 생성

   2. 급여 변경 이력을 저장할 PRACTICE_SALARY_LOG 테이블 생성
      컬럼:
      - EMP_ID       VARCHAR(3)
      - EMP_NAME     VARCHAR(20)
      - OLD_SALARY   NUMERIC
      - NEW_SALARY   NUMERIC
      - CHANGE_DATE  TIMESTAMP

   3. PRACTICE_EMPLOYEE 테이블에서 UPDATE가 발생한 후 실행되는 행 단위 트리거 작성

   4. 트리거 함수에서는 급여가 실제로 변경된 경우에만
      사번, 사원명, 변경 전 급여, 변경 후 급여, 현재 시각을
      PRACTICE_SALARY_LOG 테이블에 INSERT하기

   5. 사번이 200인 사원의 급여를 8,500,000으로 변경하기.

   6. PRACTICE_EMPLOYEE와 PRACTICE_SALARY_LOG를 조회하여
      급여 변경 및 이력 저장 결과 확인.

*/

-- 준비
DROP TABLE IF EXISTS PRACTICE_SALARY_LOG;
DROP TABLE IF EXISTS PRACTICE_EMPLOYEE;

create table PRACTICE_EMPLOYEE as 
select EMP_ID, EMP_NAME, SALARY
from employee; 

/*
   2. 급여 변경 이력을 저장할 PRACTICE_SALARY_LOG 테이블 생성
      컬럼:
      - EMP_ID       VARCHAR(3)
      - EMP_NAME     VARCHAR(20)
      - OLD_SALARY   NUMERIC
      - NEW_SALARY   NUMERIC
      - CHANGE_DATE  TIMESTAMP
*/
create table PRACTICE_SALARY_LOG (
	EMP_ID varchar(3),
	EMP_NAME varchar(20),
	OLD_SALARY numeric,
	new_salary numeric,
	change_DATe timestamp
);

create function FN_SALARY_LOG()
returns trigger as $$ 
begin 
	if old.salary is distinct from new.salary then  -- 두값을 비교하는 연산자! 같지않으면 참! 
       insert into PRACTICE_SALARY_LOG
       values(old.EMP_ID, old.emp_name, old.salary, new.salary, current_timestamp);
	end if;
	return new;
end; 
$$ language PLPGSQL; 

create trigger TRG_PRACTICE_SALARY
after update on PRACTICE_EMPLOYEE
for each row 
execute function FN_SALARY_LOG(); 

-- 사번이 200인 사원의 급여를 
update practice_employee 
set salary = 8500000
where emp_ID = '200'; 











