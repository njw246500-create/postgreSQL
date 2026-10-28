/*
	여러줄 주석 : ctrl+shift+/
*/
--  한줄 주석 : ctrl + /
/*
 * DML(Data Manipulation Language) : 데이터 조작언어
   : 테이블에 값을 검색(select), 삽입(insert), 수정(update), 삭제(delete)하는 구문
*/
--====================================================================
/*
 (') 홑따옴표 : 문자열을 감싸주는 기호
 (") 쌍따옴표 : 컬럼명 등을 감싸주는 기호
*/

/*
 	<select>
   데이터 조회할 때 사용
   
   >> Result set : 행들의 집합
   
   [표현법]
   SELECT 조회하고자하는 컬럼, 컬럼, ...
   FROM 테이블명;
 */

-- EMPLOYEE테이블에 있는 모든 컬럼(*)조회
select *
from EMPLOYEE;

-- EMPLOYEE테이블에서 사번, 이름, 급여 조회
select EMP_ID, EMP_NAME, SALARY
from EMPLOYEE;

-- JOB테이블의 모든 컬럼 조회
select *
from JOB;

---------------- 실습문제 -------------------
-- 1. JOB테이블에서 직급명만 조회
select JOB_NAME 
from JOB;

-- 2. DEPARTMENT테이블에서 모든 컬럼 조회
select * from department;

-- 3. DEPARTMENT테이블에서 테이블의 부서코드, 부서명 조회
select DEPT_ID, DEPT_TITLE from DEPARTMENT;

-- 4. EMPLOYEE테이블에서 사번, 사원명, 이메일, 전화번호, 입사일, 급여 조회
select EMP_ID, EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY
from EMPLOYEE;

/*
  <컬럼값을 통한 산술연산>
  SELECT절 컬럼명 작성부분에 산술연산 쓸수 있다
*/
-- EPLOYEE테이블에서 사원명, 사원의 연봉 조회
select EMP_NAME, SALARY*12
from EMPLOYEE;

-- EMPLYEE에서 사원명, 보너스, 급여 조회
select EMP_NAME, BONUS, SALARY
from EMPLOYEE;

-- EMPLOYEE에서 사원명, 급여, 보너스, 연봉, 보너스가포함된연봉 조회
select EMP_NAME, SALARY, BONUS, SALARY*12, (BONUS*SALARY+SALARY)*12
from EMPLOYEE;

-- EMPLOYEE에서 사원명, 입사일, 근무일수
-- DATE형식끼리 연산 가능 : +, -
-- 오늘 날짜 CURRENT_DATE
select EMP_NAME, HIRE_DATE, CURRENT_DATE - HIRE_DATE
from EMPLOYEE;

-----------------------------------------------------------------
/*
  <컬럼명에 별칭 지정하기>
  산술연산시 컬럼명이 ?column?으로 나옴. 이때 별칭을 부여하여 처리
  
  [표현법]
  컬럼명 별칭 / 컬럼명 as 별칭 / 컬럼명 "별칭" / 컬럼명 as "별칭"
  
  * 반드시 별칭에 쌍따옴표("")가 들어가야 할 때
     -> 별칭에 띄어쓰기가 들어 있던지, 특수문자가 포함되어 있는 경우, as = alias
 */

select EMP_NAME
			,SALARY
			,BONUS
			,SALARY*12 연봉
			,(BONUS*SALARY+SALARY)*12 총소득
from EMPLOYEE;

select EMP_NAME, SALARY, BONUS, SALARY*12 "연봉(원)", (BONUS*SALARY+SALARY)*12 "총 소득"
from EMPLOYEE;

------------------------------------------------------------------
/*
 	<리터럴>
 	임의로 지정한 문자열(')
 	
 	select절에 리터럴을 제시하면 마치 테이블상에 존재하는 데이터 처럼 조회가능
 	조회된 result set의 모든 행에 반복적으로 같이 출력
 */

-- employee에 사번, 사원명, 급여 조회
select emp_id, emp_name, salary, '원' 단위
from employee;

----------------------------------------------------------------
/*
 	<연결 연산자 : ||>
 	여러 컬럼값들을 마치 하나의 컬럼인것처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있음
 	* 숫자를 그냥 결합하면 타입에러
 	  숫자형을 문자로 명시적 변환(::text)
 */
-- employee에서 사번, 이름, 급여를 하나의 컬럼으로 조회
select emp_id || emp_name || salary as id_name
from employee;

-- 컬럼값과 리터럴을 연결
select emp_name || '의 월급은' || salary || '원 입니다' as salary
from employee;

-----------------------------------------------------------------
/*
  	<DISTINCT> 
  	컬럼에 중복된 값들을 한번씩만 표시하고자 할 때
 */
-- EMPLOYEE에서 직급코드 조회
select JOB_CODE from EMPLOYEE;

-- 위에서 중복 제거
select distinct JOB_CODE from EMPLOYEE;

-- 부서코드도 중복제거
select distinct DEPT_CODE from EMPLOYEE;

-- DISTINCT는 SELECT절에 딱 한번만 기술할 수 있음.
-- DEPT_CODE, JOB_CODE가 쌍으로 되어있는 값의 중복제거
select distinct DEPT_CODE, JOB_CODE from EMPLOYEE;

-----------------------------------------------------------------
/*
 	<WHERE 절>
 	조회하고자 하는 테이블로부터 특정 조건에 만족하는 데이터만 조회할 때
 	WHERE절에 조건식을 씀
 	조건식에는 다양한 연산자 사용 가능
 	
 	[표현법]
 	SELECT 컬럼, 컬럼, ...
 	FROM 테이블명
 	WHERE 조건식;
 	
 	* 비교연산자
 	>, <, >=, <=    --> 대소 비교
 	=								--> 같은지 비교
 	!=, <>					--> 같지 않은지 비교
*/

-- EMPLOYEE에서 부서코드가 'D9'인 사원의 모든 컬럼 조회
select *
from EMPLOYEE
where DEPT_CODE = 'D9';

-- EMPLOYEE에서 부서코드가 'D1'인 사원의 사원명, 급여, 부서코드 조회
select EMP_NAME, SALARY, DEPT_CODE
from employee
where DEPT_CODE = 'D1';

-- EMPLOYEE에서 부서코드가 'D1'이 아닌 사원의 사원명, 급여, 부서코드 조회
select EMP_NAME, SALARY, DEPT_CODE
from employee
where DEPT_CODE != 'D1';

-- EMPLOYEE에서 급여가 400만원 이상인 사원의 사원명, 급여, 입사일 조회
select EMP_NAME, SALARY, HIRE_DATE
from employee
where SALARY >= 4000000;

-- EMPLOYEE에서 재직중인 사원들의 사번, 사원명, 입사일, 퇴직여부 조회
select EMP_ID, EMP_NAME, HIRE_DATE, ENT_YN
from employee
where ENT_YN = 'N';

---------------------------- 실습문제 ---------------------------
-- 1. 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, 연봉 조회
select emp_name, salary, hire_date, salary*12 연봉
from employee
where salary >= 3000000;

-- 2. 연봉이 5000만원 이상인 사원들의 사원명, 급여, 연봉, 부서코드 조회
select emp_name, salary, salary*12 연봉, dept_code
from employee
where salary*12 >= 50000000;

-- 3. 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급코드, 퇴사여부 조회
select emp_id, emp_name, job_code, ent_yn
from employee
where job_code != 'J3';

----------------------------------------------------------------
/*
 <논리 연산자>
 여러개의 조건을 제시하고자 할 때
 
 AND (~이면서, 그리고)
 OR (~이거나, 또는)
*/

-- 부서코드가 'D9'이면서 급여가 500만원 이상인 사원의 사원명, 부서코드, 급여 조회
select EMP_NAME, DEPT_CODE, SALARY
from employee
where DEPT_CODE = 'D9' and SALARY >= 5000000;

-- 부서코드가 'D6'이거나 급여가 300만원 이상인 사원의 사원명, 부서코드, 급여 조회
select EMP_NAME, DEPT_CODE, SALARY
from employee
where DEPT_CODE = 'D6' or SALARY >= 3000000;

-- 급여가 350만원 이상, 600만원 이하인 사원들의 사원명, 사번, 급여 조회
select EMP_NAME, EMP_ID, SALARY
from employee
where SALARY >= 3500000 AND SALARY <= 6000000; -- 파이썬처럼 중간에 35 <= 600 < 이런식으로 쓰면 x

------------------------------------------------------------------
/*
	<BETWEEN AND>
	조건식에서 사용되는 구문으로
	~이상 ~이하인 범위에 대한 조건을 제시할 때 사용되는 연산자
	
	[표현법]
	비교대상컬럼 BETWEEN 하한값 AND 상한값
*/

-- 급여가 350만원 이상, 600만원 이하인 사원들의 사원명, 사번, 급여 조회
select EMP_NAME, EMP_ID, SALARY
from employee
where SALARY between 3500000 AND 6000000;

-- 급여가 350만원 이상, 600만원 이하인 사원을 제외한 나머지 사원들의 사원명, 사번, 급여 조회
select EMP_NAME, EMP_ID, SALARY
from employee
where not SALARY between 3500000 AND 6000000;

-- 입사일이 '1990-01-01 ~ 2004-12-31'
select *
from employee
where HIRE_DATE between '1990-01-01' and '2004-12-31';

---------------------------------------------------------------
/*
	<LIKE>
	비교하고자하는 컬럼값이 내가 제시한 특정 패턴에 만족하는 경우 조회
	
	 [표현법]
	 비교대상컬럼 LIKE '특정패턴'
	 : '특정패턴'에는 와일드카드(%, _)로 쓸수 있음
	 
	 * % : 0글자 이상
	   ex) 비교대상컬럼 LIKE '문자%' => 비교대상의 컬럼값이 '문자'로 시작되는 것 조회
	   		 비교대상컬럼 LIKE '%문자' => 비교대상의 컬럼값이 '문자'로 끝나는 것 조회
	   		 비교대상컬럼 LIKE '%문자%' => 비교대상의 컬럼값이 '문자'가 포함되어 있는 것 조회
	   		 
	 * _ : 1글자
	 	 ex) 비교대상컬럼 LIKE '_문자' => 비교대상의 컬럼값이 '문자'앞에 무조건 한글자가 올 경우 조회
	 	 		 비교대상컬럼 LIKE '__문자' => 비교대상의 컬럼값이 '문자'앞에 무조건 두글자가 올 경우 조회
	 	 		 비교대상컬럼 LIKE '_문자_' => 비교대상의 컬럼값이 '문자'앞과 뒤에 무조건 한글자가 올 경우 조회
*/
-- 사원들 중 성이 전씨인 사원의 사원명, 급여, 입사일 조회
select EMP_NAME, SALARY, HIRE_DATE
from employee
where EMP_NAME like '전%';

-- 사원들 이름중에 '하'가 포함되어 있는 사원의 사번, 사원명, 전화번호 조회
select EMP_ID, EMP_NAME, PHONE
from employee
where EMP_NAME like '%하%';

-- 사원들 중 이름의 가운데에 '하'가 들어있는 사원의 사번, 사원명, 이메일 조회
select EMP_ID, EMP_NAME, EMAIL
from employee
where EMP_NAME like '_하_';

-- 사원의 전화번호의 3번째 자리가 1인 사원의 사번, 사원명, 전화번호, 이메일 조회
select EMP_ID, EMP_NAME, PHONE, EMAIL
from employee
where PHONE like '__1%';

-- 이메일 중 _(언더바)앞에 글자가 3글자인 사원들의 사번, 이름, 이메일 조회
select EMP_ID, EMP_NAME, EMAIL
from EMPLOYEE
where EMAIL like '____%';
	-- 와일드카드로 사용되는 문자와 컬럼값에 들어있는 문자가 동일하기 때문에 조회가 안됨
	--  >> 어떤것이 와일드카드이고 데이터값인지 구분해줘야 함
	--	>> 데이터값으로 취급하고자하는 값 앞에 나만의 와일드카드(아무거나 숫자,문자,특수기호)를 넣어줌
	--			나만의 와일드카드를 ESCAPE에 등록

select EMP_ID, EMP_NAME, EMAIL
from EMPLOYEE
where EMAIL like '___$_%' escape '$';

-- 위의 사원을 제외한 사원들 조회 
select EMP_ID, EMP_NAME, EMAIL
from EMPLOYEE
where not EMAIL like '___$_%' escape '$';

--------------------------- 실습문제 ------------------------------
-- 1. employee에서 이름이 '연'으로 끝나는 사원들의 사번, 사원명, 입사일 조회
			select emp_id, emp_name, hire_date
			from employee
			where emp_name like '%연';

-- 2. employee에서 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
			select emp_name, phone
			from employee
			where phone not like '010%';

-- 3. employee에서 이름에 '하'가 포함되어 있고 급여가 240만원 이상인 사원의 
--		사번, 사원명, 급여 조회
			select emp_id, emp_name, salary
			from employee
			where emp_name like '%하%' and salary >= 2400000;

-- 4. department에서 해외영업부인 부서들의 부서코드, 부서명 조회
			select dept_id, dept_title
			from department
			where dept_title like '해외영업%';

----------------------------------------------------------------
/*
	<IS NULL / IS NOT NULL>
	컬럼값에 NULL이 있을 경우 NULL값 비교에 이용하는 연산자, NULL 은 = NULL 이라고 작성하면 안된다. 
*/
-- EMPLOYEE에서 보너스를 받지 않는 사원들의 사번, 이름, 급여, 보너스 조회
select EMP_ID, EMP_NAME, SALARY, BONUS
from employee
where BONUS IS NULL;

-- EMPLOYEE에서 보너스를 받는 사원들의 사번, 이름, 급여, 보너스 조회
select EMP_ID, EMP_NAME, SALARY, BONUS
from employee
where BONUS is NOT NULL;

-- EMPLOYEE에서 사수가 없는 사원의 사원명, 부서코드, 사수 조회
select EMP_NAME, DEPT_CODE, MANAGER_ID
from employee
where MANAGER_ID is null;

-- EMPLOYEE에서 부서배치를 받지 않았지만 보너스는 받는 사원들의 이름, 보너스, 부서코드 조회
select EMP_NAME, BONUS, DEPT_CODE
from employee
where DEPT_CODE is null and BONUS is not null;

------------------------------------------------------------------
/*
	<IN / NOT IN>
	IN : 컬럼값이 내가 제시한 목록중에 일치하는 값이 있는것만 조회
	NOT IN : 컬럼값이 내가 제시한 목록중에 일치하는 값을 제외한 나머지 조회
	
	 [표현법]
	 비교대상컬럼 IN ('값1', '값2', '값3', ...) 
*/

-- EMPLOYEE에서 부서코드가 D6이거나 D8이거나 D5인 사원의 이름, 부서코드, 급여 조회
select EMP_NAME, DEPT_CODE, SALARY
from employee
--where DEPT_CODE = 'D6' or DEPT_CODE = 'D8' or DEPT_CODE = 'D5';
where DEPT_CODE in ('D6', 'D8', 'D5');

-- EMPLOYEE에서 위의 사원 제외한 사원들
select EMP_NAME, DEPT_CODE, SALARY
from employee
where DEPT_CODE not in ('D6', 'D8', 'D5');

-----------------------------------------------------------------
/*
	<연산자 우선순위>
	1. ()
	2. 산술 연산자
	3. 연결 연사자
	4. 비교 연산자
	5. IS NULL / LIKE '패턴' / IN
	6. BETWEEN AND
	7. NOT(논리연산자)
	8. AND(논리연산자)
	9. OR(논리연산자)
 */

-- 직급코드가 J7이거나 J2인 사원들 중 급여가 200만원 이상인 사원들의 모든컬럼 조회
select *
from employee
where (JOB_CODE = 'J7' or JOB_CODE = 'J2') and SALARY >= 2000000; -- and의 우선순위가 더 높다. 

-------------------------- 실습문제------------------------
-- 1. 사수가 없고 부서배치도 받지 않은 사원들의 사원명, 사수사번, 부서코드 조회
			select emp_name, manager_id, dept_code
			from employee
			where manager_id is null and dept_code is null;

-- 2. 연봉(보너스포함X)이 3000만원 이상이고 보너스를 받지 않은 사원들의 
--		사번, 사원명, 연봉, 보너스 조회
			select EMP_ID, EMP_NAME, SALARY*12 연봉, BONUS
			from employee
			where SALARY*12 >= 30000000 and BONUS is null;
			
-- 3. 입사일이 1995-01-01 이상이고 부서배치를 받은 사원들의 
--		사번, 사원명, 입사일, 부서코드 조회
			select EMP_ID, EMP_NAME, HIRE_DATE, DEPT_CODE
			from employee
			where HIRE_DATE >= '1995-01-01' and DEPT_CODE is not null;

-- 4. 급여가 200만원 이상 500만원 이하고 입사일이 2001-01-01 이상이고 
--		보너스를 받지 않는 사원들의 사번, 사원명, 급여, 입사일, 보너스 조회
			select EMP_ID, EMP_NAME, SALARY, HIRE_DATE, BONUS
			from employee
			where SALARY between 2000000 and 5000000
				and HIRE_DATE >= '2001-01-01'
				and BONUS is null;

-- 5. 보너스포함 연봉이 NULL이 아니고 이름에 '하'가 포함되어 있는 사원들의 
--		사번, 사원명, 급여, 보너스포함연봉 조회 (별칭부여)
			select EMP_ID, EMP_NAME, SALARY, (BONUS*SALARY+SALARY)*12 "보너스포함 연봉"
			  from employee
			 where (BONUS*SALARY+SALARY)*12 is not null
			   and EMP_NAME like '%하%';

----------------------------------------------------------------------------------------
/*
	<order by 절>
	정렬하여 보여줌. 
	SELECT문 가장 마지막줄에 작성함. 실행순서도 맨 마지막에 실행
	
	[표현법]
	SELECT 조회할 컬럼, 컬럼, ...
	FROM 테이블명
	WHERE 조건식
	ORDER BY 정렬 기준의 컬럼명 | 별칭 | 컬럼순서 [ASC | DESC] [NULLS FIRST | NULLS LAST];
	
	- ASC : 오름차순 정렬(생략시 기본값)
	- DESC : 내림차순 정렬
	
	- NULLS FIRST : NULL데이터를 맨 앞에 배치(생략시 DESC 기본값)
	- NULLS LAST : NULL데이터를 맨 끝에 배치(생략시 ASC 기본값)
*/
select *
from EMPLOYEE
-- order by BONUS;
-- order by BONUS ASC;
-- order by BONUS nulls FIRST;
-- order by BONUS desc;
order by BONUS desc, SALARY;	-- 기준정렬 여러개 사용 가능

-- 전 사원의 사원명, 연봉조회 (연봉의 내림차순 정렬 조회)
select EMP_NAME, SALARY*12 연봉
from employee
-- order by SALARY*12 desc;
-- order by 연봉 desc;
order by 2 desc;		-- 3개 모두 사용 가능