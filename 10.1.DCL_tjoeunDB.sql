/*
  <DCL : DATA CONTROL LANGUAGE>
    데이터 제어 언어 
    
    데이터베이스의 Role에게 권한을 부여(grant)하거나 회수(REVOKE)하는 구문
 
    > 시스템권한 : 데이터베이스에 접속, 생성, Role 생성 및 관리 하는 권한
    > 객체 접근 권한 : 특정객체(테이블, 뷰, 시퀀스 등)에 접근하거나 조작할 수 있는 권한
    
    * 시스템 권한의 종류 
      - LOGIN : 데이터베이스에 접속할 수 있는 권한
      - CREATEDB : 데이터베이스를 생성할 수 있는 권한 
      - CREATE ON SCHEMA : 해당 스키마에 객체를 생성할 수 있는 권한
      - USAGE ON SCHEMA : 해당 스키마에 객체를 접근할 수 있는 권한 
      
    * Role 기반 권한 관리 
      - app_user    <- 애플리케이션이 사용하는 계정 
      - developer   <- 개발자들에게 공통 권한을 부여하는 그룹 
      - analyst		<- 데이터 분석가에게 공통 권한을 부여하는 그룹 
      - DBA         <- DB 관리 작업을 수행하는 관리자용   

*/
--=======================================================================================================
--      <시스템 권한 부여>
-------------------------------------------------------------------------------------------------
-- 사용자 생성 및 login 권한, 반드시 비밀번호 넣어줘야 함
create user sample with password '1234';
create role sample login password '1234'; -- 위와 동일

-- 사용자만 생성 
create user sample2;

-- 나중에 권한 부여
alter role sample2 login;
alter role sample2 with password '1234';

-- 전체 user 보기 
select rolname 
from pg_roles; 

-- 특정 사용자만 확인
select * 
from pg_roles 
where rolname = 'sample2';

--=======================================================================================================
--      <객체 접근 권한 부여>
-------------------------------------------------------------------------------------------------
/*
  객체 접근 권한 종류 
  특정 객체에 접근하여 조작할 수 있는 권한
  
  권한종류 
  select           조회      TABLE, VIEW, SEQUENCE
  INSERT           입력      TABLE, VIEW
  UPDATE           수정      TABLE, VIEW
  DELETE           삭제      TABLE, VIEW
  TRUNCATE         전체삭제   TABLE
  REFERENCES       FK 생성   TABLE
  TRIGGER         트리거생성   TABLE
  
  [표현식]
  GRANT 권한종류 ON 특정객체 TO 사용자;
 */
-- 2단계 : SAMPLE 계정에게 TJOEUN 데이터베이스에 접속할 수 있는 권한
grant connect on database TJOEUN to sample;

-- 3단계 : 스키마 사용 권한 부여
grant usage on schema public to sample;
-- public은 스키마에 접근할 수 있는 권한 

-- 4단계 : 테이블 권한 부여
-- 조회만 가능하게 부여 
grant select on table employee to sample;

-- 다른 ddl 권한 부여
grant insert, update, delete on table employee to sample; 

-- public 스키마의 모든 기존 테이블에 모든 권한 부여
grant all privileges on all tables in schema public to sample;

-- 앞으로 생성될 테이블에 권한 부여 
alter default privileges in schema public 
grant all privileges on tables to sample; 

-- 시퀀스 사용권한
grant usage, select on all sequences in schema public to sample; 

-- *** 대체적으로 3개를 부여하면 거의 모든 걸 사용가능
grant connect on database tjoeun to sample; 
grant usage on schema public to sample; 
grant all privileges on all tables in schema public to sample; 

------------------------------------------------------------------------------------
-- 권한 회수 
-- REVOKE 회수할 권한 ON 특정객체 FROM 계정명; 

-- 한 테이블의 권한을 개별적으로 회수 
revoke select on table employee from sample;

-- EMPLOYEE테이블의 모든 권한 회수 
revoke all on table employee from sample; 

-- 모든 테이블 권한 회수
revoke all on all tables in schema public from sample; 

-- 데이터베이스 접속 권한 회수
revoke connect on database tjoeun from sample; 

-- 스키마 사용 권한 회수 
revoke usage on schema public from sample; 

-- 사용자 삭제
-- 사용자에게 주었던 모든 권한을 회수 한 후에만 삭제 가능 
drop user sample;

revoke all on database postgres from sample;

alter default privileges for role postgres in schema public
revoke all on tables from sample; 







