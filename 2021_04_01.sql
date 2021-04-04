2021-04-01-001

view]객체
- TABLE과 유사한 기능 제공
- 보안, QUERY 실행의 효율성, TABLE의 은닉성을 위하여 사용

(사용형식)
CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW 뷰이름 [(컬럼LIST)]
AS
    SELECT 문;
    [WITH CHECK OPTION;]
    [WITH READ ONLY;]
    
 - 'OR REPLACE' : 뷰가 존재하면 대치되고 없으면 신규로 생성
 - 'FORCE|NOFORCE' : 원본 테이블의 존재하지 않아도 뷰를 생성(FORCE), 생성불가(NOFORCE)
 - '컬럼LIST' : 생성된 뷰의 컬럼명
 - 'WITH CHECK OPTION' : SELECT문의 조건절에 위배되는 DML명령 실행 거부
 - 'WITH READ ONLY' : 읽기 전용 뷰 생성
 
사용예)사원테이블에서 부모부서코드가 90번 부서에 속한 사원정보를 조회하시오.
        조회항 데이터 : 사원번호,사원명,부서명,급여
        -- 샘플 데이터베이스 설치후 다시 진행
        
사용예)회원테이블에서 마일리지가 3000이상인 회원의 회원번호, 회원명, 직업, 마일리지를 조회하시오.
SELECT mem_id AS 회원번호,
        mem_name AS 회원명,
        mem_job AS 직업,
        mem_mileage AS 마일리지
    FROM member
WHERE mem_mileage>=3000;

--- 저장이 안되는 뷰(재사용이 불가능하다)

=> 뷰생성

CREATE OR REPLACE VIEW V_MEMBER01
AS
    SELECT mem_id AS 회원번호,
           mem_name AS 회원명,
           mem_job AS 직업,
           mem_mileage AS 마일리지
    FROM member
WHERE mem_mileage>=3000;
-- 뷰를 만들껀데 같은 이름이 있으면 덮어써라
-- 뷰를 나타내기 위해 (V_) 를 사용한다

SELECT * FROM V_MEMBER01;
(신용환회원의 자료 검색)
SELECT mem_name, mem_job, mem_mileage
    FROM member
 WHERE UPPER(MEM_ID)='C001'
 --(대문자라 나오지 않는다)
 --(소문자를 대문자로 바꾸는 UPPER 함수를 사용하여 해결한다)
 
 (MEMBER 테이블에서 신용환의 마일리지를 10000으로 변경)
 -- UPDATE 사용한다
 
UPDATE MEMBER
   SET MEM_MILEAGE = 3000
 WHERE MEM_NAME = '신용환';
-- 모든 회원의 마일리지를 1만으로 바꾸는 상태 (웨어절이 없을때)
-- 테이블을 바꾼것이다 // 뷰에가면 바껴있다

 (VIEW V_MEMBER01에서 신용환의 마일리지를 500으로 변경)
UPDATE V_MEMBER01
   SET 마일리지 = 3000
 WHERE 회원명 = '신용환';
   
--컬럼명을 뷰의 기준으로 써야한다
--뷰의 웨어절 기준에 안맞아서 안나오지만 테이블에서는 수정되어 나온다
--뷰의 데이터를 막 만지면 테이블도 망가질수 있다

--WIHT CHECK OPTION 사용 VIEW 생성

CREATE OR REPLACE VIEW V_MEMBER01(MID,MNAME,MJOB,MILE)
AS
    SELECT mem_id AS 회원번호,
           mem_name AS 회원명,
           mem_job AS 직업,
           mem_mileage AS 마일리지
    FROM member
    WHERE mem_mileage>=3000
    WITH CHECK OPTION;
    
    ROLLBACK;

SELECT * FROM V_MEMBER01;

(뷰 V_MEMBER01에서 신용환 회원의 마일리지를 2000으로 변경)

UPDATE V_MEMBER01
   SET MILE = 2000
 WHERE UPPER(MID) = 'C001';
 
 -- 3000이상인 뷰인데 2000을 넣기때문에 조건에 부적합해서 업데이트가 안된다
 
 (테이블 MEMBER에서 신용환 회원의 마일리지를 2000으로 변경)
UPDATE MEMBER
   SET MEM_MILEAGE = 2000
WHERE UPPER(MEM_ID) = 'C001';

-- 뷰의 존재와 상관없이 원본에 있는 자료들은 데이터 조작이 가능해야한다

SELECT *
FROM V_MEMBER01;

-- 원본 데이터가 변경되어서 뷰의 구성조건에 위배되어 뷰에서 지워진다

--WIHT READ ONLY 사용 VIEW 생성

CREATE OR REPLACE VIEW V_MEMBER01(MID,MNAME,MJOB,MILE)
AS
    SELECT mem_id AS 회원번호,
           mem_name AS 회원명,
           mem_job AS 직업,
           mem_mileage AS 마일리지
    FROM member
    WHERE mem_mileage>=3000
    WITH READ ONLY
    WITH CHECK OPTION;
-- 같이 사용 불가능

ROLLBACK;

SELECT MEM_NAME, MEM_MILEAGE
FROM MEMBER;

SELECT * FROM V_MEMBER01;

(뷰 V_MEMBER01에서 오철희 회원의 마일리지를 5700으로 변경
UPDATE V_MEMBER01
   SET MILE = 5700
 WHERE UPPER(MID) = 'K001';

-- 리드 온니 옵션이 사용되어진 뷰는 인서트 딜리트 업데이트가 제한된다

SELECT HR.DEPARTMENTS.DEPARTMENT_ID, 
       DEPARTMENT_NAME
  FROM HR.DEPARTMENTS;
        --(생략가능)
        
2021-04-01-002

문제] HR계정의 사원테이블(EMLPOYEES)에서 50번 부서에 속한 사원 중 급여가 5000이상인 사원번호,사원명,입사일,
급여를 읽기 전용 뷰로 생성하시오. 뷰이름은 V_EMP_SAL01이고 컬럼명은 원본테이블의 컬럼명을 사용
뷰가 생성된 후 뷰와 테이블을 이용하여 해당 사원의 사원번호, 사원명, 직무명, 급여를 출력하는 SQL작성

-- 뷰를 만들고 테이블이랑 조인을 해야한다

CREATE OR REPLACE VIEW V_EMP_SAL01
AS
    SELECT EMPLOYEE_ID AS 사원번호,
           EMP_NAME AS 사원명,
           HIRE_DATE AS 입사일,
           SALARY AS 급여
    FROM EMPLOYEES
    WHERE SALARY>=5000 
    AND DEPARTMENT_ID = 50
    WITH READ ONLY;
    
SELECT *
  FROM EMPLOYEES;
  
create synonym DEPARTMETS FOR HR.DEPARTMENTS;
-- 계정에 안되는 사람만 한다

SELECT * FROM V_EMP_SAL01;

--- 선생님 풀이

(뷰생성)
CREATE OR REPLACE VIEW V_EMP_SAL01
AS
    SELECT EMPLOYEE_ID,
           EMP_NAME,
           HIRE_DATE,
           SALARY 
    FROM EMPLOYEES
    WHERE SALARY>=5000 
    AND DEPARTMENT_ID = 50
    WITH READ ONLY;
    
SELECT C.EMPLOYEE_ID AS 사원번호,
       C.EMP_NAME AS 사원명,
       B.JOB_TITLE AS 직무명,
       C.SALARY AS 급여
  FROM EMPLOYEES A, JOBS B, V_EMP_SAL01 C
 WHERE A.EMPLOYEE_ID = C.EMPLOYEE_ID
   AND A.JOB_ID = B.JOB_ID;
-- 임플로이는 직무코드를 얻기 위해 사용






