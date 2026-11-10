/*
<VIEW>
 : SELECT문을 저장해 두는 데이터베이스 객체
 
 - 자주 사용하는 복잡하고 긴 SELECT문을 VIEW로 만들어
  매번 긴 쿼리를 작성하지 않아도 편하게 조회할 수 있음
 - 실제 데이터를 별도로 저장하는게 아니라 저장된 SELECT 
  통행 데이터를 조회하는 가상 테이블
 - 원본 테이블의 데이터가 변경되면 VIEW 조회 결과에도 반영됨 

*/
-- 한국에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회

select EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATION_NAME
    from EMPLOYEE
    join DEPARTMENT on (DEPT_CODE = DEPT_ID)
    join location on (LOCATION_ID = LOCAL_CODE)
    join national using (NATIONAL_CODE)
  where national_NAME = '한국';

-- 러시아에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
select EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
    from EMPLOYEE
    join DEPARTMENT on (DEPT_CODE = DEPT_ID)
    join location on (LOCATION_ID = local_code)
    join national using (NATIONAL_CODE)
  where national_name = '일본';

---------------------------------------------------------------
/*
   1. VIEW 생성 방법
   
   [표현식]
   create VIEW 뷰명 
   AS 서브쿼리;

 */ -- 매번 사용하는 쿼리를 간단하게 볼 수 있게 하는 것임. 
create view VW_EMPLOYEE 
as select EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
   from employee
   join DEPARTMENT on (DEPT_CODE = DEPT_ID)
   join location on (LOCATION_ID = local_CODE)
   join national using (NATIONAL_CODE);

select * from VW_EMPLOYEE;

select * from VW_EMPLOYEE
where NATIONAL_NAME = '한국';

select * from VW_EMPLOYEE
where NATIONAL_NAME = '러시아';

select * from VW_EMPLOYEE
where NATIONAL_NAME = '중국';

------------------------------------------------------------------
/*
* 뷰 컬럼에 별칭 
  서브쿼리의 select절에 함수식이나 산술연산식이 기술되었다면 되도록이면 별칭을 부여하는게 편함.
  별칭을 안넣으면 알아서 붙여주기는 함. 
 */
-- 전 사원의 사번, 이름, 직급명, 성별(남/여), 근무년수를 조회할 수 있는 뷰(VW_EMP_JOB) 생성

create view VW_EMP_JOB
as select EMP_ID, EMP_NAME, JOB_NAME, 
		  case when SUBSTR(EMP_NO, 8, 1) in ('1','3') then '남'
		       when SUBSTR(EMP_NO, 8, 1) in ('2','4') then '여'
          end,
          EXTRACT(year from CURRENT_DATE) - EXTRACT(year from HIRE_DATE)
    from employee
    join JOB USING(job_code);

select * from vw_emp_job;
select "case" from vw_emp_job;
select "?column?" from vw_emp_job;

drop view VW_EMP_JOB;
drop view VW_JOB;

create view VW_EMP_JOB
as select EMP_ID, EMP_NAME, job_NAME, 
		          case when SUBSTR(EMP_NO, 8, 1) in ('1','3') then '남'
		               when SUBSTR(EMP_NO, 8, 1) in ('2','4') then '여'
		          end as 성별, 
		          EXTRACT(year from CURRENT_DATE) - EXTRACT(year from HIRE_DATE) as 근무년수
          from employee
          join JOB USING(JOB_CODE); 

-- or 
create view VW_EMP_JOB2 (사번, 사원명, 직급명, 성별, 근무년수)
as select EMP_ID, EMP_NAME, JOB_NAME,
					case when SUBSTR(EMP_NO, 8, 1) in ('1', '3') then '남'
							 when SUBSTR(EMP_NO, 8, 1) in ('2', '4') then '여'
					end,
					EXTRACT(year from CURRENT_DATE) - EXTRACT(year from HIRE_DATE)
		 from employee
		 join JOB USING(JOB_CODE);

select * from VW_EMP_JOB;
select * from employee

select * from VW_EMP_JOB where 성별 = '여';
select * from VW_EMP_JOB where 근무년수 >= 20;
-----------------------------------------------------------------------------
/*
 - AGE() 함수 : 두 날짜 사이의 차이를 연도, 월, 일 단위로 계산해 주는 함수
   AGE(현재날짜, 과거날짜)

 */

select AGE(CURRENT_DATE, DATE'2020-05-10');

select EMP_ID, EMP_NAME, JOB_NAME,
					case when SUBSTR(EMP_NO, 8, 1) in ('1', '3') then '남'
							 when SUBSTR(EMP_NO, 8, 1) in ('2', '4') then '여'
					end as 성별,
					EXTRACT(year FROM AGE(CURRENT_DATE, HIRE_DATE)) as 근무년수
		 from employee
		 join JOB USING(JOB_CODE);

----------------------------------------------------------------
/*
* VIEW 삭제 
* DROP VIEW 뷰명

 */
drop view VW_EMP_JOB;

------------------------------------------------------------------
-- 생성된 뷰를 통해 INSERT, UPDATE, DELETE 가능 
create view VW_JOB
as select JOB_CODE, JOB_NAME
        from JOB;

-- 뷰를 통한 INSERT
insert into VW_JOB values ('J8','인턴');

select * from VW_JOB;
select * from JOB;

-- 뷰를 통한 UPDATE 
update vw_JOB
set job_NAME = '알바'
where job_code = 'jb'

-- 뷰를 통한 DELETE 
delete from vw_job where JOB_CODE = 'JB';

/*
	- DML 명령어로 조작이 불가능한 경우
	1) 뷰에 정의되어 있지 ㅇ낳은 컬럼 조작하고자 할 떄
	2) 뷰에 정의되어 있지 않은 컬럼 중에 원본테이블상에 NOT NULL 제약조건이 지정되어 있는 경우 INSERT 불가
	3) 산술식 또는 함수식으로 정의 되어있는 경우
	4) 그룹함수나 GROUP BY 절에 포함되어 있는 경우 
	5) DISTINCT 구문이 포함 되어 있는 경우
	6) JOIN을 이용하여 여러 테이블을 연결시켜놓은 경우

 */
 -- 뷰 생성
create view VW_JOB2
as select JOB_CODE
		from job;

select * from vw_job2;
select * from job;

-- 1) 뷰에 정의되어 있지 않은 컬럼을 조작하려고 할 때 오류 
-- INSERT 
insert into VW_JOB2 (JOB_CODE,JOB_NAME) values ('JB','인턴'); 

-- UPDATE 
update VW_JOB2
set JOB_NAME = '인턴'
where JOB_CODE = 'J7';

-- DELETE
delete from vw_job2
where job_name = '대리';

-- 2) 뷰에 정의되어 있지 않은 컬럼 중에 원본테이블상에 NOT NULL제약조건이 지정되어 있는 경우
create view vw_job3
as select job_name 
		from job; 

select * from VW_JOB3;
select * from job; 

rollback;

-- 3) 산술식 또는 함수식으로 정의 되어있는 경우
 drop view vw_emp_SAL; 

create 











