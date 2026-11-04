/*
     <TCL : TRANSACTION CONTROL LANGUAGE> 
     트랜젝션 제어 언어 
     
     * 트랜젝션 
      - 데이터베이스의 논리적 연산 단위 
      - 여러 SQL작업을 하나의 작업 단위로 묶어서 처리
        > 트랜잭션이 존재하면 새로운 SQL 작업을 해당 트랜잭션에 포함
        > 트랜잭션이 존재하지 않으면 새로운 트랜잭션을 시작
        > COMMIT 할떄까지 변경사항을 관리 
     * 트랜잭션의 대상이 되는 SQL : (DML) INSERT, UPDATE, DELETE
     *                         (DDL) CREATE, ALTER, DROP, TRUNCATE 
     - COMMIT : 트랜잭션 종료 처리 후 확정
     - ROLLBACK : 현재 트랜잭션의 변경사항을 취소
     - SAVEPOINT : 현재 트랜잭션 내부의 중간 저장점을 만듬.
     - BEGIN : 트랜잭션의 시작 
*/

select * from emp_01;
-- EMP_ID가 222번 사원 삭제
delete from emp_01
where emp_ID = '222';

-- EMP_ID가 217번 사원 삭제
delete from emp_01
where emp_ID = '217';

-- 트랜잭션 취소 
rollback;

----------------------------------------------------------------------------------------------------------------
-- EMP_ID가 200번 사원 삭제 
delete from emp_01 
where emp_id = '200';

select * from EMP_01;

-- 행 삽입 
insert into emp_01
values(800, '홍길동', '총무부')

commit; 

rollback;

----------------------------------------------------------------------------------------------------------------
-- 217, 216, 214 사원 삭제
delete from emp_01 
where emp_id in ('217', '216', '214');

-- 임시저장점 만들기
savepoint SP1; 

-- 801번 사원추가 
insert into EMP_01 values('802','이세종','인사관리부'); 

select * from emp_01;

rollback to savepoint SP1;

commit;

-------------------------------------
begin; 

delete from emp_01 where emp_id = '800';
select * from emp_01;
savepoint SP1; 

insert into EMP_01 (EMP_ID) VALUES('900');

rollback to SP1;

commit;

rollback;



