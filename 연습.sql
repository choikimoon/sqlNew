연습
------------------0311------------------------------

-- 1. emp 테이블 조회하기 --
SELECT *
  FROM EMP;

-- 2. emp 테이블에서 empno, ename 조회하기 --
SELECT EMPNO, ENAME
  FROM EMP;
  
------------------0311-----------------------------

----------------0312-------------------------

--1.SEM 계정에 있는 PROD테이블의 모든 컬럼을 조회하는 SELECT 쿼리 작성
SELECT *
  FROM PROD;

--2.계정에 있는 PROD 테이블의 PROD_ID,PROD_NAME 두개의 컬럼만 조회하는 SELECT 쿼리 작성
SELECT PROD_ID, PROD_NAME
  FROM PROD;

--3.LPROD 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT *
FROM LPROD;

--4.BUYER테이블에서 BUYER_ID, BUYER_NAME 컬럼만 조회하는 쿼리를 작성하세요
SELECT BUYER_ID, BUYER_NAME
  FROM BUYER;

--5.CART 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT *
  FROM CART;

--6.MEMBER 테이블에서 MEM_ID, MEM_PASS, MEM_NAME컬럼만 조회하는 쿼리를 작성하세요
SELECT MEM_ID,MEM_PASS,MEM_NAME
  FROM MEMBER;
  
--7.PROD테이블에서 PROD_ID, PROD_NAME 두 칼럼을 조회하는 쿼리를 작성하시오
--(단, PROD_ID > ID, PROD_NAME > NAME으로 컬럼 별칭을 지정)
SELECT PROD_ID AS ID, PROD_NAME AS NAME
  FROM PROD;
  
--8.LPROD테이블에서 LPROD_GU, LPROD_NM 두 칼럼을 조회하는 쿼리를 작성하시오
--(단 LPROD_GU > GU, LPROD_NM > NM으로 컬럼 별칭을 지정
SELECT LPROD_GU AS gu, LPROD_NM AS nm
  FROM LPROD;

--9. BUTER테이블에서 BUYER_ID, BUYER_NAME 두 칼럼을 조회하는 쿼리를 작성하시오
--(단 BUYER_ID > 바이어아이디, BUYER_NAME > 이름으로 컬럼 별칭으로 지정
SELECT BUYER_ID AS 바이어아이디, BUYER_NAME AS 이름
  FROM BUYER;

--10. 문자열 결합을 이용하여 다음과 같이 조회 도도록 쿼리를 작성하시오
SELECT 'SELECT ' || '*' || 'FROM ' || TABLE_NAME || ';'
  FROM USER_TABLES;

SELECT 'SELECT * FROM ' || TABLE_NAME ||';',
        CONCAT('SELECT * FROM', TABLE_NAME)
  FROM USER_TABLES;
  
SELECT CONCAT(CONCAT('SELECT * FROM', TABLE_NAME), ';')
  FROM USER_TABLES;
  
SELECT CONCAT('SELECT * FROM', TABLE_NAME) || ';'
  FROM USER_TABLES;
  
SELECT 'SELECT * FROM ' || CONCAT(TABLE_NAME, ';'),
        CONCAT('SELECT * FROM ' || TABLE_NAME, ';')
  FROM USER_TABLES;

--11. 부서번호가 10인사람을 찾자
SELECT *
  FROM EMP
 WHERE DEPTNO = 10;

--12. USERS 테이블에서 USERID 컬럼의 값이 brown인 사용자만 조회
SELECT *
  FROM USERS
 WHERE USERID = 'brown';

--13. EMP테이블에서 부서번호가 20번보다 큰 부서에 속한 직원 조회
SELECT *
  FROM EMP
 WHERE DEPTNO > 20;

--14. EMP 테이블에서 부서번호가 20번 부서에 속하지 않는 직원 조회
SELECT *
  FROM EMP
 WHERE DEPTNO != 20;

--15. 1과 1은 같다는 참이다 = 항상 참이다.
SELECT *
  FROM EMP
 WHERE 1=1;

--16. 1과 2는 같다는 거짓이다 = 항상 거짓이다
SELECT *
  FROM EMP
 WHERE 1=2;

-----------------------------------0312---------------

--------------------------------0315-----------------------------

--1. 연산자 연습
SELECT EMPNO, ENAME, HIREDATE
  FROM EMP
 WHERE HIREDATE >= TO_DATE('1981/03/01', 'YYYY/MM/DD');

--2. 연산자 연습
SELECT *
  FROM EMP
 WHERE HIREDATE >= TO_DATE('1982/01/01', 'YYYY/MM/DD');
 
--3. EMP 테이블에서 입사 일자가 1982년 1월 1일 이후 부터 1983년 1월 1일 이전인 사원의 ENAME, HIREDATE 데이터를 조회하는
--쿼리를 작성하시오 단 연산자는 BETWEEN을 사용한다.
SELECT ENAME, HIREDATE
  FROM EMP
 WHERE HIREDATE BETWEEN TO_DATE('1982/01/01', 'YYYY/MM/DD') AND TO_DATE('1983/01/01', 'YYYY/MM//DD');

--4. 3번문제 BETWEEN 연산자 안쓰고 풀기
SELECT ENAME, HIREDATE
  FROM EMP
 WHERE HIREDATE >= TO_DATE('1982/01/01', 'YYYY/MM/DD')
   AND HIREDATE <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

--5. USERS테이블에서 USERID가 brown, cony, sally인 데이터를 다음과 같이 조회 하시오(IN 연산자 사용)
SELECT USERID AS 아이디, USERNM AS 이름, ALIAS AS 별명
  FROM USERS
 WHERE USERID IN('brown', 'cony', 'sally');

--6. 5번문제를 WHERE절로 표현하자
SELECT USERID AS 아이디, USERNM AS 이름, ALIAS AS 별명
  FROM USERS
 WHERE USERID = 'brown'
    OR USERID = 'cony' 
    OR USERID = 'sally';

--7. USERS 테이블의 USERID중 맨 첫글자가 c로 시작하는 것을 조회하자
SELECT *
  FROM USERS
 WHERE USERID LIKE 'c%';

--8. USERID가 c로 시작하면서 c이후에 3개의 글자가 오는 사용자
SELECT *
  FROM USERS
 WHERE USERID LIKE 'c___';

--9. USERID에 1이 들어가는 모든 사용자 조회
SELECT *
  FROM USERS
 WHERE USERID LIKE '%1%';

--10. MEMBER테이블에서 회원의 성이 [신]씨인 사람의 MEM_ID, MEM_NAME을 조회하는 쿼리를 작성하시오
--MEM_NAME의 첫글자가 신이고 뒤에는 뭐가 와도 상관없다.
SELECT MEM_ID, MEM_NAME
  FROM MEMBER
 WHERE MEM_NAME LIKE '신%';

--11. MEMBER테이블에서 회원의 이름에 글자[이]가 들어가는 모든 사람의 MEM_ID,MEM_NAME을 조회하는 쿼리를 작성하시오
SELECT MEM_ID, MEM_NAME
  FROM MEMBER
 WHERE MEM_NAME LIKE '%이%';

--12. EMP테이블에서 매니저가 없는 직원만 조회
SELECT *
  FROM EMP
 WHERE MGR IS NULL;

--13. EMP테이블에서 MGR의 사번이 7698이면서 SAL값이 1000보다 큰 직원만 조회
SELECT *
  FROM EMP
 WHERE MGR = 7698 AND SAL > 1000;

--14. SAL컬럼의 값이 1000보다 크거나 MGR의 사번이 7698인 직원조회
SELECT *
  FROM EMP
WHERE MGR = 7698 OR SAL > 1000;

--15. 직원의 부서번호가 30번이 아닌 직원들
SELECT *
  FROM EMP
 WHERE DEPTNO NOT IN (30);

--16. 15번의 내용을 연산자를 사용해서 풀어보자
SELECT *
  FROM EMP
 WHERE DEPTNO != 30;

--17.EMP테이블에서 JOB이 SALESMAN이고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
SELECT *
  FROM EMP
 WHERE JOB = 'SALESMAN' AND HIREDATE >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--18.EMP테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회 하세요
SELECT *
  FROM EMP
 WHERE DEPTNO != 10 AND HIREDATE >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--19.EMP테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
--(부서는 10 20 30 만 있다고 가정하고 IN 연산자를 사용)
SELECT *
  FROM EMP
 WHERE DEPTNO IN (20,30) AND HIREDATE >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--20.EMP 테이블에서 JOB이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회 하세요.
SELECT *
  FROM EMP
 WHERE JOB = 'SALESMAN' OR HIREDATE >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--21.EMP테이블에서 JOB이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회 하세요
SELECT *
  FROM EMP
 WHERE JOB = 'SALESMAN' OR EMPNO LIKE ('78%');

--22.EMP테이블에서 JOB이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 가팅 조회 하세요
--(LIKE 연산자 사용 금지)
SELECT *
  FROM EMP
 WHERE JOB = 'SALSEMAN' OR EMPNO BETWEEN 7800 AND 7899
                        OR EMPNO BETWEEN 780 AND 789
                        OR EMPNO = 78;
---------------------------0315---------------------------

-----------------------0316----------------------------

--1.EMP테이블에서 1.JOB이 SALESMAN이거나 2.사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인 직원의
--정보를 다음과 같이 조회하세요 (1번 조건 또는 2번 조건을 만족하는 직원)
SELECT *
  FROM EMP
 WHERE JOB = 'SALESMAN' OR EMPNO LIKE '78%' AND HIREDATE >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--2.DEPT테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요
SELECT *
  FROM DEPT
 ORDER BY DNAME;

--3.DEPT테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요
SELECT *
FROM DEPT
 ORDER BY LOC DESC;

--4.EMP테이블에서 상여(COMM)정보가 있는 사람들만 조회하고 상여(COMM)를 많이 받는 사람이 먼저 조회되도록
--정렬하고 상여가 같을 경우 사번으로 내림차순 정렬하세요(상여가 0인 사람은 상여가 없는 것으로 간주)
SELECT *
  FROM EMP
 WHERE COMM IS NOT NULL
   AND COMM !=0
 ORDER BY COMM DESC, EMPNO DESC;

--5.EMP테이블에서 관리자가 있는 사람들만 조회하고 직군(JOB)순으로 오름차순 정렬하고 직군이 같을 경우 사번이 큰
--사원이 먼저 조회 되도록 쿼리를 작성하세요
SELECT *
  FROM EMP
 WHERE MGR IS NOT NULL
 ORDER BY JOB, EMPNO DESC;

--6.EMP테이블에서 10번 부서(DEPTNO) 혹은 30번 부서에 속하는 사람중 급여(SAL)가 1500이 넘는 사람들만 조회하고
--이름으로 내림차순 정렬 되도록 쿼리를 작성하세요
SELECT *
  FROM EMP
 WHERE DEPTNO IN (10,30) AND SAL > 1500
 ORDER BY ENAME DESC;
 
--7. ROWNUM 연습
SELECT ROWNUM, EMPNO, ENAME
  FROM EMP
 WHERE ROWNUM BETWEEN 1 AND 5;
 
--8. ROWNUM 연습2
SELECT ROWNUM, EMPNO, ENAME
  FROM EMP
 WHERE ROWNUM >= 1;
 
--9. 실행순서 연습
SELECT ROWNUM, EMPNO, ENAME
  FROM EMP
 ORDER BY ENAME;

--10. EMP테이블에서 ROWNUM값이 1~10인 값만 조회하는 쿼리를 작성해 보세요(정렬없이 진행하세요)
SELECT ROWNUM AS RN, EMPNO, ENAME
  FROM EMP
 WHERE ROWNUM BETWEEN 1 AND 10;

--11. EMP테이블에서 ROWNUM값이 11~14인 값만 조회하는 쿼리를 작성해 보세요
SELECT *
FROM
    (SELECT ROWNUM AS RN, EMPNO, ENAME
       FROM EMP)
WHERE RN BETWEEN 11 AND 14;

--12. EMP테이블의 사원정보를 이름컬럼으로 오름차준 적용 했을 때의 11 ~ 14번 째행을 다음과 같이 조회하는 쿼리를 작성해보세요
SELECT *
FROM
    (SELECT ROWNUM RN, EMPNO, ENAME
       FROM
            (SELECT ROWNUM RN, EMPNO,ENAME
               FROM EMP
              ORDER BY ENAME))
WHERE RN BETWEEN 11 AND 14;

---------0316----------------------

------------0317----------------

--1. EMP테이블에 등록된 직원들 중에 직원의 이름의 길이가 5글자를 초과하는 직원들만 조회
SELECT *
  FROM EMP
 WHERE LENGTH(ENAME) > 5;
 
--2. EMP테이블에 등록된 직원중 smith를 대문자로 만드시오
SELECT *
  FROM EMP
 WHERE ENAME = UPPER('smith');
 
--3. 문자열 함수 모두 입력
SELECT 'HELLO' || ',' || 'WORLD',
        CONCAT('HELLO', CONCAT(',','WORLD')) AS CONCAT,
        SUBSTR('HELLO, WORLD', 1, 5) AS SUBSTR,
        LENGTH('HELLO, WORLD') AS LENGTH,
        INSTR('HELLO, WORLD', 'O') AS INSTR,
        LPAD('HELLO, WORLD', 15, '*') AS LPAD,
        RPAD('HELLO, WORLD', 15, '*') AS RPAD,
        REPLACE('HELLO, WORLD', 'O','X') AS REPLACE,
        TRIM('  HELLO, WORLD    ') AS TRIM,
        TRIM('D' FROM 'HELLO, WORLD') AS TRIM2
  FROM DUAL;

--4. 숫자 함수 연습
SELECT ROUND(105.54, 1) AS ROUND1,
       ROUND(105.55, 1) AS ROUND2,
       ROUND(105.54, 0) AS ROUND3,
       ROUND(105.54, -1) AS ROUND4
  FROM DUAL;

--5. 숫자 함수 연습2


