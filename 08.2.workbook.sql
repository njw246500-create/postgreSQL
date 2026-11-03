/*
DML 워크북 문제풀이

*/

-- 1. 과목유형 테이블 (TB_CLASS_TYPE)에 아래와 같은 데이터를 만드시오

create table TB_CLASS_TYPE(
      CLASS_TYPE_NO numeric constraint class_type_PK primary key,
      CLASS_TYPe_NAME varchar(4)
);

insert into tb_class_type values(1,'전공필수');
insert into tb_class_type values(2,'전공선택');
insert into tb_class_type values(3,'교양필수');
insert into tb_class_type values(4,'교양선택');
insert into tb_class_type values(5,'논문지도');

select class_type_no, class_type_name
from tb_class_type 
left join tb_class on (class_type_name= class_type); 

--2 학생일반정보 테이블
/*
 * create table TB_학생일반정보(학번, 학생이름, 주소)
 * as select student_no, student_name, student_address
 *   from tb_student;
 */
create table TB_학생일반정보
as select student_no, student_name, student_address
	from tb_student; 
commit;


--3. 국어국문학과 정보 테이블
create table TB_국어국문학과
as select student_no, student_name, to_date(substr(student_ssn,1,2),'YY'), professor_name
	from tb_student s
    left join tb_professor on (coach_professor_no = professor_no) 
    where s.department_no = (select department_no from tb_department where department_name = '국어국문학과' )


/*
 * create table TB_국어국문학과(학번, 학생이름, 출생년도, 교수이름)
 * as select S.student_no, S.student_name
 *          , EXTRACT(year from TO_DATE(substr(S.student_ssn, 1, 2),'YY'))
 *          , P.professor_name
 * from tb_student S 
 * left join tb_professor P on (P.professor_no = S.coach_professor_no)
 * left join tb_department P using(D.department_no = S.department_no)
 * where D.department_name = '국어국문학과';
 */

-- 4. 현 학과의 정원 18% 증가
update tb_department
set capacity = round(capacity*1.18);
select capacity from tb_department
commit

--5. 학번 A413042 박건우 주소 '서울시 종로구 숭인동 181-21'로 변경하고자 한다. 
update TB_학생일반정보
set student_address = '서울시 종로구 숭인동 181-21'
where student_name = '박건우'and student_no = 'A413042'
commit;

--6. 학생테이블의 주민번호 뒷자리를 저장하지 않기로 하였다. 이를 반영할 문장 
update tb_student
set student_ssn = substr(student_ssn,1,6)
select student_ssn from tb_student
commit;


-- 7. 의학과 김명훈 학생 점수 잘못됨 -> 학점을 3.5로 변경 -- 어려움..  
update tb_grade
set point = 3.5
where student_no = (select student_no from tb_student where student_name = '김명훈') 
and department_no = (select D.department_no from tb_department D  where D.department_name = '의학과')
and class_no = (select class_no from tb_class where class_name = '피부생리학')
select point from tb_grade

/*
 * TB_STUDENT     DEPARTMENT_NO   STUDENT_NO
 * TB_DEPARTMENT  DEPARTMENT_NO
 * TB_CLASS       DEPARTMENT_NO
 * TB_GRADE                       STUDENT_NO
 * 
 */ 
select student_name, department_name, point
from tb_student
join tb_department using(department_no)
join tb_class using(department_no)
where student_name = '김명훈'
  and DEPARTMENT_NAME = '의학과';

-- 8. 성적테이블에서 휴학생 제거하기 
delete from TB_GRADE
where student_no in (select student_no 
                       from tb_student 
                      where absence_yn = 'Y');

select count(*)
from tb_student
join tb_grade using(student_no)
group by absence_yn
having absence_yn = 'Y'
