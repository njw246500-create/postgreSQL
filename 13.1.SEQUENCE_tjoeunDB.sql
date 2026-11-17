/*
	<SEQUENCE>
	자동으로 번호 발생시켜주는 역할을 하는 객체
	정수값을 순차적으로 일정값씩 증가시키면서 생성해줌
	
	EX ) 회원번호, 사원번호, 게시글번호, ....
	
	1. SEQUENCE 생성
		[표현식]
		CREATE SEQUENCE 시퀀스명		
		[START WITH 시작 숫자]			-> 처음 발생시킬 시작값 지정(기본값1)
		[INCREMENT BY 증가값]			-> 몇씩 증가시킬것인지(기본값1)
		[MAXVALUE 숫자] 				-> 최대값 지정(기본값 무지큼)
		[MINVALUE 숫자]				-> 최소값 지정(기본값1)
		[CYCLE | NO CYCLE]			-> 값 순환 여부 지정(기본값 NO CYCLE)
		[CACHE 미리만들어둘번호의개수]		-> 미리 확보할 시퀀스 번호 개수
		
		테이블명 : TB_
		뷰명 : VW_
		시퀀스명 : SEQ_
		트리거명 : TRG_
*/
create sequence SEQ_TEST;

create sequence SEQ_EMPNO
start with 300
increment by 5
maxvalue 310
no cycle
cache 1; 

/*
	2. 시퀀스 사용 
		시퀀스명.CURRVAL : 현재 시퀀스 값(마지막 성공적으로 수행된 NEXTVAL의 값)
		시퀀스명.NEXTVAL : 시퀀스값에 일정값을 증가시켜서 발생된 값 
									현재 시퀀스 값에서 INCREMENT BY 값 만큼 증가된 값 
									= 시퀀스명.CURRVAL + INCREMENT BY 값
									
 */

select CURRVAL('SEQ_EMPNO'); -- NEXTVAL한번도 한적이 없어서 보여줄 값이 없음(오류)
-- CURRVAL은 마지막으로 성공한 NEXTVAL의 값을 저장해서 보여주는 임시값

select NEXTVAL('SEQ_EMPNO'); -- 300
select CURRVAL('SEQ_EMPNO'); -- 300
select NEXTVAL('SEQ_EMPNO'); 
select NEXTVAL('SEQ_EMPNO'); -- 310

select NEXTVAL('SEQ_EMPNO'); -- MAXVAL값을 초과하여 오류
select CURRVAL('SEQ_EMPNO'); -- 310

/*
	3. 시퀀스 구조 변경
	
	ALTER SEQUENCE 시퀀스명
	[INCREMENT BY 증가값]     -> 몇씩 증가시킬것인지(기본값1)
	[MAXVALUE 숫자]          -> 최대값 지정(기본값 무지큼)
	[MINVALUE 숫자]          -> 최소값 지정(기본값1)
	[CYCLE | NO CYCLE]      -> 값 순환 여부 지정(기본값 NO CYCLE)
	[CACHE 미리만들어둘번호의개수] -> 미리 확보할 시퀀스 번호 개수
	[RESTART WITH 시작할숫자]  -> 시작 번호 재설정
 */
alter sequence SEQ_EMPNO
increment by 10
maxvalue 400;

select NEXTVAL('SEQ_EMPNO'); --310 + 10

-- 4. 시퀀스 삭제 
drop sequence SEQ_EMPNO; 

-------------------------------------------------------------
--- 사원번호로 활용할 시퀀스 생성 
create sequence SEQ_EID
start with 400; 

insert into EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE)
values (NEXTVAL('SEQ_EID'), '박수형', '111111-1111111', 'J1');

select * from EMPLOYEE; 

insert into EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE)
values (NEXTVAL('SEQ_EID'), '이만수', '222222-2222222','J2');

--============================================================
/* 
	<SERIAL>
	- 자동으로 번호를 생성하는 PostgreSQL 자료형
	- 내부적으로 SEQUENCE 객체를 자동 생성
	- INSERT시 번호를 자동으로 증가시켜 부여
 */

-- 회원정보 테이블 생성
create table MEMBER(
	MEM_NO SERIAL primary key,
	MEM_NAME VARCHAR(20) not null, 
	PHONE VARCHAR(20)
);

insert into member (MEM_NAME, PHONE)
values ('김철수','010-1234-1234'); 

select * from member;

insert into member(MEM_NAME, PHONE)
values('이영희','010-1233-2643');

insert into member(MEM_NAME, PHONE)
values('박민수', '010-1233-2643'); 

-- 시퀀스 이름 확인 
select PG_GET_SERIAL_SEQUENCE('member','mem_no');

-- serial의 시작값과 증가 간격 변경 
alter sequence member_mem_no_seq
restart with 100; 

alter sequence member_mem_no_seq
increment by 5; 

insert into member(MEM_NAME,PHONE)
values ('양수영', '010-1233-2643');

insert into member(MEM_NAME, PHONE)
values ('최상민','010-1233-2643');

select * from member;











