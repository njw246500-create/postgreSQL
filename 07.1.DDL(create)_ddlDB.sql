/*
DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어 
PostgreSQL에서 제공하는 객체(object)를 만들고 (create), 구조를 변경하고(alter), 구조 자체를 삭제(drop)하는 언어 
즉, 실제 데이터값이 아니라 구조 자체를 정의하는 언어 
주로 DB 관리자, 설계자가 사용함

객체(object) : 테이블(TABLE), 뷰(VIEW), 인덱스(INDEX), 패키지(PACKAGE), 트리거(TRIGGER), 프로시저(PROCEDURE), 함수(FUNCTION) 등

*/
--------------------------------------------------------------------------------------------------------------------
-- <CREATE>
-- 객체를 생성하는 구문
--------------------------------------------------------------------------------------------------------------------
/*
 1. 테이블 생성
   	- 테이블이란 : 행(ROW)과 열(COLUMN)로 구성된 가장 기본적인 데이터베이스 객체
   	            모든 데이터들은 테이블을 통해 저장됨.
   	[표현식] 
   	(CREATE 객체명)
   	CREATE TABLE 테이블명 (
   	   컬럼명 자료형(크기), 
   	   컬럼명 자료형(크기), 
   	   컬럼명 자료형,
   	   ... 
   	);
   	
   	* 테이블 생성시 자주 사용하는 자료형
   	  1. 문자형 데이터 타입
   	     데이터타입         설명            예시
   	     ----------------------------------------------
   	     CHAR(n)     고정길이 문자열       char(3)
         VARCHAR(n)  최대 n글자까지 저장    VARCHAR(20)  --> 가변길이(들어오는 글자에 따라 저장공간이 됨)
         VARCHAR     길이 제한 없이 저장    VARCHAR
         TEXT        길이 제한 없이 저장    TEXT
         
       2. 숫자형 데이터 타입
         데이터타입                              설명                   예시
   	     -------------------------------------------------------------------
         NUMERIC([전체자리수, 소수자리수])     정확한 숫자 저장            NUMBERIC
         SERIAL                           자동 증가하는 정수          SERIAL
         
       3. 날짜 데이터 타입
         데이터타입                    설명                   예시
   	     -------------------------------------------------------------------  
   	     DATE                    날짜 저장                2026-11-02
   	     TIMESTAMP               날짜 + 시간 저장          2026-11-02 12:42:43
   	     
   	    4. 기타 데이터 타입
         BOOLEAN : 자료형이 아니라 값이 없거나 알 수 없다는 의미 
           값        의미
         ---------------------------
         TRUE      참
         FALSE     거짓
         NULL  	   알 수 없음, 값이 없음
   
 */ 
-- 회원 테이블 MEMBER 생성
create table member (
	MEM_NO NUMERIC, 
	MEM_ID VARCHAR(20), 
	MEM_PWD VARCHAR(20),
	MEM_NAME VARCHAR(20),
	GENDER CHAR(1),
	PHONE VARCHAR(13), 
	EMAIL VARCHAR(50),
	MEM_DATE DATE
); 

create table member2 (
	MEM_NO NUMERIC, 
	MEM_ID VARCHAR, 
	MEM_PWD VARCHAR,
	MEM_NAME VARCHAR,
	GENDER CHAR(3),
	PHONE VARCHAR, 
	EMAIL VARCHAR,
	MEM_DATE DATE
); 

create table member3 (
	MEM_NO NUMERIC, 
	MEM_ID TEXT, 
	MEM_PWD TEXT,
	MEM_NAME TEXT,
	GENDER CHAR(3),
	PHONE TEXT, 
	EMAIL TEXT,
	MEM_DATE DATE
); 

create table member4 (
	MEM_NO SERIAL, 
	MEM_ID TEXT, 
	MEM_PWD TEXT,
	MEM_NAME TEXT,
	GENDER CHAR(3),
	PHONE TEXT, 
	EMAIL TEXT,
	SALARY numeric(10, 2), -- 정수 8자리 + 소수 2자리
	SALARY2 numeric,
	MEM_DATE TIMESTAMP, 
	ACTIVE BOOLEAN
); 

---------------------------------------------------------------------------------------------------------------------
/*
 2. 컬럼에 주석달기 (컬럼에 대한 설명)
   
   [표현법]
   COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
   
   >> 잘못 작성시 수정 후 다시 실행하면 됨 
   

 */

comment on column member.mem_no is '회원번호';
comment on column member.mem_id is '회원아이디';
comment on column member.mem_pwd is '회원비밀번호';
comment on column member.gender is '성별(남,여)';
comment on column member.phone is '전화번호';
comment on column member.email is '이메일';
comment on column member.mem_date is '회원가입일';
comment on column member.mem_name is '회원명';
-- 실행시에는 드래그 하고 실행하기 
comment on column member.mem_name is '회원이름';
-- 잘못쓰면 수정가능

insert into member values(1,'USER01','pwd01',
'강효순','여','010-1234-5678',' user01@naver.com',
'2026-11-02');
insert into member values(2,'USER02','pwd02',
'남길동','남', null,null,current_date);
insert into member values(3,null,null,null,null,null,null,null);

-----------------------------------------------------------------
/*
  <제약조건 CONSTRAINTS> 
  - 원하는 데이터값(유효한 형식의 값)만 유지하기 위해 특정 컬럼에 설정하는 제약
  - 데이터 무결성 보장을 목적으로 함. 
    : 데이터의 결함이 없는 상태, 즉 데이터가 정확하고 유효하게 유지된 상태
   1)개체 무결성 제약 조건 : NOT NULL, UNIQUE, PRIMARY KEY(notnull unique 합친거) 조건위배
   2)참조 무결성 제약 조건 : FOREIGN KEY(외래키) 조건 위배 
   
   * 제약조건 종류 : NOT NULL, UNIQUE, PRIMARY KEY, CHECK(조건), FOREIGN KEY(외래키)
   * 
   * 제약조건을 부여하는 2가지 방식
     1) 컬럼 레벨 방식 : 컬럼명의 자료형 옆에 기술
     2) 테이블 레벨 방식 : 모든 컬럼들을 나열한 후 마지막에 기술           
*/

---------------------------------------------------------------------
/*
 * NOT NULL 제약조건
 * : 해당 컬럼에 반드시 값이 존재해야 한다. (절대 NULL이면 안됨)
 * 
 * >> *** 주의사항 : 오로지 컬럼 레벨 방식만 사용가능
 */ 
create table mem_notnull(
MEM_NO numeric not null, 
MEM_ID VARCHAR(20) not null,
MEM_PWD VARCHAR(20) not null,
MEM_NAME VARCHAR(20) not null,
GENDER CHAR(1),
PHONE VARCHAR(13),
EMAIL VARCHAR(30)
);

insert into MEM_NOTNULL values(1,'USER01','PWD01','최명길','여','010-3456-6856','user01@naver.com');
insert into MEM_NOTNULL values(2,'USER02','PWD02',NULL,NULL,NULL,NULL);
-- not null 제약조건 위배로 오류발생
insert into MEM_NOTNULL values(2,'USER02','PWD02','김말동','남','010-3456-5566','user02@naver.com');
insert into MEM_NOTNULL values(2,'USER03','PWD03','이순실','남','010-3456-5566','user02@naver.com');
-- mem_no가 고유하게 등록되어야함. 지금은 겹침.. 
----- id가 중복되었음에도 잘 추가됨 
-----------------------------------------------------------------
/*
* unique 제약조건 
*  : 해당 컬럼에 중복된 값이 들어가서는 안되는 경우 
*  컬럼값에 중복을 제한하는 제약조건
 */


-- 컬럼 레벨 방식 
create table MEM_UNIQUE(
	MEM_NO numeric not null UNIQUE, 
	MEM_ID varchar(20) not null UNIQUE,
	MEM_PWD varchar(20) not null,
	MEM_NAME varchar(20) not null, 
	GENDER char(1),
	PHONE varchar(13),
	EMAIL varchar(30)
);

-- 테이블 레벨 방식
create table MEM_UNIQUE2(
	MEM_NO numeric not null constraint MEMNO_UQ unique, -- 컬럼레벨방식
	MEM_ID varchar(20) not null,
	MEM_PWD varchar(20) not null,
	MEM_NAME varchar(20) not null, 
	GENDER char(1),
	PHONE varchar(13),
	EMAIL varchar(30), 
	constraint MEMID_UQ unique (MEM_ID) -- 테이블 레벨 방식 
	-- unique (MEM_no), 
	--unique (mem_id), 
	-- unique (mem_no,mem_id) -- 한쌍이 고유하다는 의미, 각각을 정의할때랑은 다름! 
	
);

insert into mem_unique values(1,'user01','pwd01',
'황미남','남','010-2345-5678','user01@google.com');

insert into mem_unique values(1,'user02','pwd02',
'이미남','남','010-2345-4678','user02@google.com');

insert into mem_unique values(2,'user01','pwd02',
'이미남','남','010-2345-4678','user02@google.com');

insert into mem_unique values(3,'user03','pwd03',
'양진수','k',null,null);
--> 성별이 유효한 값이 아니어도 입력됨

---------------------------------------------------------
/*
 * check(조건식) 제약 조건
   해당 컬럼에 들어올 수 있는 값에 대한 조건 제시해 둘 수 있다.  

 */
create table mem_check(
   MEM_NO numeric not null, 
   mem_id varchar(20) not null unique, 
   mem_pwd varchar(20) not null, 
   mem_name varchar(20) not null, 
   gender char(1) check(gender in ('남','여')), -- 컬럼 레벨방식 
   PHONE varchar(13), 
   EMAIL varchar(30),
   check(GENDER in ('남','여'))
);
create table mem_check2(
   MEM_NO numeric not null, 
   mem_id varchar(20) not null unique, 
   mem_pwd varchar(20) not null, 
   mem_name varchar(20) not null, 
   gender char(1),
   PHONE varchar(13), 
   EMAIL varchar(30),
   check(GENDER in ('남','여')) -- 테이블 레벨 방식
);

insert into mem_check values(2,'user01','pwd01',
'황미남','남','010-2345-5678','user01@google.com');

insert into mem_check values(3,'user01','pwd01',
'황미남','o','010-2345-5678','user01@google.com');

/*
 * 제약조건에 제약조건명까지 지어주는 방법
 * >> 컬럼레벨 방식
 * create table 테이블명(
 *    컬럼명 자료형 [constraint 제약조건명] 제약조건, 
 *    컬럼명 자료형 
 * ); 
 * 
 * >> 테이블레벨 방식
 * create table 테이블명(
 *    컬럼명 자료형 
 *    컬럼명 자료형
 *    [constraint 제약조건명] 제약조건(컬럼명),  
 * ); 
 */
create table MEM_UNIQUE3(
	MEM_NO numeric not null constraint MEMNO_UQ unique, -- 컬럼레벨방식
	MEM_ID varchar(20) not null,
	MEM_PWD varchar(20) not null,
	MEM_NAME varchar(20) not null, 
	GENDER char(1),
	PHONE varchar(13),
	EMAIL varchar(30), 
	constraint MEMID_UQ unique (MEM_ID) -- 테이블 레벨 방식 
);
create table mem_check3(
   MEM_NO numeric not null, 
   mem_id varchar(20) not null unique, 
   mem_pwd varchar(20) not null, 
   mem_name varchar(20) not null, 
   gender char(1),
   PHONE varchar(13), 
   EMAIL varchar(30),
   constraint gender_CHK check(GENDER in ('남','여')) -- 테이블 레벨 방식
);
-----------------------------------------------------------------------------------
/*
 * PRIMARY KEY(기본키) 제약 조건
   테이블에서 각 행들을 식별하기 위해 사용될 컬럼에 부여하는 제약조건(식별자의 역할)
   
   EX ) 회원번호, 학번, 사원번호, 부서코드, 직급코드, 주문번호, 예약번호, 운송장번호...
   
   PRIMARY KEY는 NOT NULL + UNIQUE의 제약조건을 의미
     >> 대체적으로 검색, 삭제, 수정 등에 기본키의 컬럼값을 이용함. 
     
   >> *** 유의사항 : 한 테이블당 오로지 한개만 설정 가능 

 */

create table MEM_PRIKEY(
    MEM_NO numeric constraint memno_pk primary key, 
    mem_id varchar(20) not null unique, -- primary key 또 못씀
    mem_pwd varchar(20) not null,
    mem_name varchar(20) not null, 
    gender char(1) check(gender in ('남','여')), 
    PHONE varchar(13),
    EMAIL varchar(30)
    -- primary key (mem_no) -- 테이블 레벨방식
    -- constraint memno_pk primary key(mem_no) -- 키의 이름 부여 
); 

insert into MEM_PRIKEY values(1, 'user01','pwd01','홍길동','남',null,null);
insert into MEM_PRIKEY values(1, 'user02','pwd02','이길동','남',null,null);
-- primary key 제약 조건 위배(unique)
insert into MEM_PRIKEY values(null, 'user02','pwd02','이길동','남',null,null);
insert into mem_prikey values(2, 'user02','pwd02','이길동','남',null,null); 

/*
-- [참고] 하나의 테이블에 primary key 키워드를 2개 이상 컬럼에 따로 적을수 없음
--       테이블 방식으로 2개의 컬럼을 넣을 수 있음
   * 복합키
     : 기본키에 2개 이상의 컬럼을 묶어서 사용
     
    -- 사용자가 어떤 물품을 찜했는지 보관할 때 
    1, A
    1, A 부적합 
    1, B   
    1, C 
    2, A
    2, B
    2, C 
    2, B 부적합
*/
create table TB_LIKE(
	MEM_NO numeric, 
	PRODUCT_NAME VARCHAR(20), 
	like_DATE DATE,
	primary key (MEM_NO, PRODUCT_NAME)
);
insert into TB_LIKE values(1, 'A', Current_date);
insert into TB_LIKE values(1, 'B', Current_date);
insert into TB_LIKE values(2, 'B', Current_date);
insert into TB_LIKE values(1, 'B', Current_date);

-----------------------------------------------------------------------------------
-- 회원 등급에 대한 데이터를 따로 보관하는 테이블 생성
create table mem_grade(
   GRADE_CODE numeric primary key, 
   GRADE_NAME VARCHAR(30) not null
); 
insert into mem_grade values(10, '일반회원');
insert into mem_grade values(20, '우수회원'); 
insert into mem_grade values(30, '특별회원');

create table mem(
   MEM_NO numeric primary key,
   mem_id varchar(20) not null unique, 
   mem_pwd varchar(20) not null, 
   mem_name varchar(20) not null,
   gender char(1) check(gender in ('남','여')),
   PHONE varchar(13), 
   EMAIL varchar(30),
   grade_ID numeric
);

insert into mem values(1, 'user01', 'pwd01','홍길동','남',null,null,null);
insert into mem values(2, 'user02', 'pwd01','홍길동','남',null,null,10);
insert into mem values(3, 'user03', 'pwd01','홍길동','남',null,null,40);
-- 유효한 회원등급번호가 아님에도 입력됨( 원래 입력되면 안됨 ) 

-----------------------------------------------------------------------------------
/*
 * Foreign key(기본키) 제약조건
 * 다른 테이블에 존재하는 값만 들어와야되는 특정 컬럼에 부여하는 제약조건
 * 
 * >> 컬럼 레벨 방식
 *    컬럼명 자료형 REFERENCES 참조할테이블명[(참조할컬럼명)]
 *    컬럼명 자료형 [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명[(참조할컬럼명)]
 * 
 * >> 테이블레벨 방식
 *    FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명[(참조할컬럼명)]
 *    [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명[(참조할컬럼명)]
 */ 
create table mem2(
  mem_no numeric primary key, 
  mem_id varchar(20) not null unique,
  mem_pwd varchar(20) not null,
  mem_name varchar(20) not null,
  gender char(1) check(gender in ('남','여')),
  phone varchar(13),
  email varchar(30),
  grade_id numeric references mem_grade(grade_code)
);

insert into mem2 values(1, 'user01', 'pwd01','홍길동','남',null,null,null);
insert into mem2 values(2, 'user02', 'pwd01','홍길동','남',null,null,10);
insert into mem2 values(3, 'user03', 'pwd01','홍길동','남',null,null,70);
-- 오류
-- MEM_GRAGE (부모테이블) --|----<-MEM2(자식테이블)
--> 이때 부모 테이블(mem_grade), 자식테이블(mem2)
--> 이때 부모테이블에서 데이터값을 삭제할 경우 문제 발생
-- 데이터삭제 : DELETE FROM 테이블명 WHERE 조건; -- 데이터베이스는 백업이 굉장히 중요, 최소한 2개 이상에 해놓아야함.

--> MEM_GRADE 테이블에서 10번 등급 삭제 
delete from mem_grade 
where grade_code = 10; --자식테이블에 걸려있음
-- 자식테이블에 10이라는 값을 사용하고 있기 때문에 삭제 안됨. 

delete from mem_grade 
where grade_code = 20;
-- 자식테이블에 20이라는 값을 사용하고 있지 않기 때문에 삭제 가능. 

-----------------------------------------------------------------------------------
/* 
 * 자식테이블 생성시 외래키 제약조건 부여할 때 삭제 옵션 지정 가능
   - 삭제 옵션 : 부모테이블의 데이터를 삭제시 그 데이터를 사용하고 있는 자식테이블의 값을 어떻게 처리할 지 
   
   > ON DELETE RESTRICT(기본값) : 자식에 데이터를 쓰고 있으면 부모 삭제 안됨.
   > ON DELETE SET NULL : 자식이 데이터를 쓰고 있으면 자식의 데이터값을 NULL로 변경하고 부모값 삭제
   > ON DELETE CASCADE : 자식이 데이터를 쓰고 있으면 자식도 삭제(행), 부모도 삭제 -- 보통 잘 안씀.. 
 */

drop table if exists MEM; 
drop table if exists MEM2; 

create table mem(
  MEM_NO numeric primary key,
  mem_ID varchar(20) not null unique, 
  mem_PWD varchar(20) not null,
  mem_name varchar(20) not null, 
  GENDER char(1) check(gender in ('남','여')),
  PHONE varchar(13),
  EMAIL varchar(30),
  GRADE_ID numeric references mem_grade on delete set null
);

insert into mem values(1, 'user01', 'pwd01','홍길동','남',null,null,null);
insert into mem values(2, 'user02', 'pwd02','김길동','남',null,null,10);
insert into mem values(3, 'user03', 'pwd03','최길동','남',null,null,20);
insert into mem values(4, 'user04', 'pwd04','박순희','여',null,null,10);

delete from mem_grade 
where grade_code = 10;

insert into mem_grade VALUES(10, '일반회원');

create table mem2(
  MEM_NO numeric primary key,
  mem_ID varchar(20) not null unique, 
  mem_PWD varchar(20) not null,
  mem_name varchar(20) not null, 
  GENDER char(1) check(gender in ('남','여')),
  PHONE varchar(13),
  EMAIL varchar(30),
  GRADE_ID numeric references mem_grade on delete cascade
);

insert into mem2 values(1, 'user01', 'pwd01','홍길동','남',null,null,null);
insert into mem2 values(2, 'user02', 'pwd02','김길동','남',null,null,10);
insert into mem2 values(3, 'user03', 'pwd03','최길동','남',null,null,20);
insert into mem2 values(4, 'user04', 'pwd04','박순희','여',null,null,10);

delete from mem_grade 
where grade_code = 10; -- 자식의 행이 완전삭제, 행을 삭제해도 되는것인지 반드시 확인해야함. 

-----------------------------------------------------------------------------------
/* 
 * DEFAULT (기본값) -> 제약조건 아님
 * 컬럼의 값을 넣을때 NULL이 아닌 기본값을 넣고자 할 때 기본값을 미리 세팅해 둘 수 있다. 
 * 
 * 컬럼명 자료형 DEFAULT 값 [제약조건]
 *   --> 다른 제약조건보다 앞에 기술해야 됨.
 * 
 */ 

create table member5(
    mem_no numeric primary key, 
    mem_name varchar(20) not null,
    mem_age numeric, 
    hobby varchar(20) default '없음', 
    mem_date date default current_date 
);
insert into MEMBER5 values(1, '고길동', 20, '운동', '2026-11-01'); 
insert into member5 values(2, '왕길동', null, null, null);
insert into member5 values(3, '강길동', null, default, default);

insert into member5 (mem_no, mem_name) values (4, '최길동');

----------------------------------------------------------------------------
--========================================= tjoeunDB로 바꾸어서 실행 
/*
<subquerry>를 이용한 테이블 생성
테이블을 복사하는 개념

  [표현식]
  create table 테이블명
  AS 서브쿼리;

 */ 
-- EMPLOYEE 테이블의 컬럼명, 자료형, 데이터 복사 

create table employee_copy
as select *
    from employee; 
-- 컬럼, 데이터값 복사 
-- 제약조건에서는 NOT NULL 안됨.
-- DEFAULT, COMMENT 안됨.

-- EMPLOYEE 테이블의 구조만 복사하고자 할 때 
create table employee_copy2
as select *
    from employee
    where 1 = 0; -- 구조만 갖고 오겠다는 뜻
    
create table employee_copy3
as select emp_id, emp_name, salary, bonus
    from employee
    where 1 = 0; -- 구조만 갖고 오겠다는 뜻
    
create table employee_copy4
as select emp_id, emp_name, salary, salary*12
    from employee
    where 1 = 0; -- 구조만 갖고 오겠다는 뜻

-------------------------------------------------------
/*
 * 테이블을 다 생성한 후 제약 조건 추가
   ALTER TABLE 테이블명 변경할 내용 ;
   
   - PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명)
   - FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명 [(참조할컬럼명)];
   - UNIQUE : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명)
   - CHECK : ALTER TABLE 테이블명 ADD CHECK(컬럼에 대한 조건식) 
   - NOT NULL : ALTER TABLE 테이블명 ALTER COLUMN 컬럼명 SET NOT NULL 
   
 */
-- EMPLOYEE_COPY테이블에 PRIMARY KEY 제약조건 추가
alter table employee_copy add primary key(emp_id);

-- EMPLOYEE 테이블에 DEPT_CODE에 외래키제약조건 추가
alter table employee add foreign key(DEPT_CODE) references DEPARTMENT; 
-- 부모테이블에 PRIMARY KEY로 되어 있으면 컬럼 생략가능

-- DEFAULT 값 
-- EMPLOYEE_COPY테이블에 DEFAULT 값 
alter table employee_copy alter column ent_yn set default 'N'; 

-- employee_copy 테이블에 EMP_ID, emp_no의 컬럼에 comment 넣기 
comment on column employee_copy4.emp_id is '회원아이디';
comment on column employee_copy4.emp_name is '회원이름';
comment on column employee_copy4.salary is '급여';





