--1 학과 이름 계열 표시

select department_name, category from tb_department

--2 학과의 정원을 다음과 같은 형태로 출력하기 
/*
학과별 정원 
----- 
국어국문학과의 정원은 20명입니다. 
*/
 select department_name || '의 정원은' || capacity ||'입니다.' from tb_department
 
 --3 연체자들을 찾는 구문! 
 
 select student_name from tb_student where student_no in ('A513079','A513090','A513091','A513110','A513119')
 
 --4 입학정원이 20명 이상 30명 이하인 학과들의 학과 이름 계열
 
select department_name, category from tb_department where capacity between 20 and 30

 --5. 총장제외 모든 교수가 소속학과가 있음, 총장이름은?
select professor_name from 