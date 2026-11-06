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

 */
create view VW_EMPLOYEE 
as select EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
   from employee
   join DEPARTMENT on (DEPT_CODE = DEPT_ID)
   join location on (LOCATION_ID = local_CODE)
   join national using (NATIONAL_CODE);

