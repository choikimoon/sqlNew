adad
grp3 그룹함수 실습
--emp 테이블을 이용하여 다음을 구하시오 grp2에서 작성한 쿼리를 활용하여 deptno 대신 부서명이 나올수 있도록 수정하시요
SELECT
        CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END dname, MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*) -- 디코드로도 가능
FROM emp
GROUP BY deptno;

grp4 그룹함수
--emp 테이블을 이용하여 다음을 구하시오 / 직원의 입사 년월별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작서하세요

SELECT TO_CHAR(hiredate, 'YYYYMMDD') hire_yyyymm, COUNT(*)cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMMDD');


grp5 그룹함수
--emp 테이블을 이용하여 다음을 구하시오 / 직원의 입사 년별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요

SELECT TO_CHAR(hiredate, 'YYYYMMDD') hire_yyyymm, COUNT(*)cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMMDD');

grp6
--회사에 존재하는 부서의 개수는 몇개인지 조회하는 쿼리를 작성하시오

SELECT COUNT(*)
FROM emp;

grp7
--직원이 속한 부서의 개수를 조회하는 쿼리를 작성하시오 / emp 테이블 사용

SELECT 
    CASE
        WHEN deptno = '10' THEN COUNT(deptno)
        WHEN deptno = '20' THEN COUNT(deptno)
        WHEN deptno = '30' THEN COUNT(deptno)
        ELSE null
        END cut
FROM emp
GROUP BY deptno;

SELECT *
FROM emp;

SELECT COUNT(*) 
FROM
(SELECT deptno
FROM emp
GROUP BY deptno); -- 인라인으로 묶어서 그룹핑된 행의 갯수를 찾는다

데이터 결합
    JOIN
        RDBMS는 중복을 최소화하는 형태의 데이터 베이스
        다른 테이블과 결합하여 데이터를 조회
        -- 쿼리를 짤때 조인이 없는 쿼리는 없다고 보면 된다
        -- 프럼절에 테이블이 1개밖에 없던것이 이제는 많이 써야한다
        -- ex ) 부서의 이름과 부서의 위치를 하나의 테이블에 관리를 하게 되면 상관은 없다 하지만 부서 자체는 1개있데 바꿔야하는 사람은 6명 데이터의 중복이 일어남
        -- 중복을 어떻게 잘 해결하고 깔끔하게 할까 생각해서 나온게 RDBMS
        -- JOIN은 결합을 할 수 있는 한 방법
        
    데이터를 확장(결합)
    1. 컬럼에 대한 확장 : JOIN
    2. 행에 대한 확장 : 집합연산자(UNION ALL, UNION, MINUS, INTERSECT(교집합))
    
    데이터 결합
    테이블에 중복된 데이터가 있다면
    emp 테이블에 부서명이 존재
    조직개편에 따라 sales부서의 이름이 marketsales로 변격된다면?
    sales 부서의 갯수가 업데이트 해야된다. (6회)
    
    JOIN
        중복을 최소화 하는 RDBMS방식으로 설계한 경우
        emp테이블에는 부서코드만 존재, 부서정보를 담은 dept 테이블 별도로 생성
        emp 테이블과 dept테이블의 연결고리(deptno)로 조인하여 실제 부서명을 조회한다
        --emp와 dept를 나누긴했지만 연결고리를 조인으로 놔둔상태로 진행한다.
        
JOIN 
1. 표준 SQL ==> ANSI SQL -- ansi는 단체이름이다. 미국
2. 비표쥰 SQL - DBMS를 만드는 회사에서 만든 고유의 SQL 문법 -- 실제 사용시 더 간결하다(케바케) -- 데이터베이스를 사용하다가 다른 데이터베이스로 바꾸는건 큰 일이다 -- SQL을 쓰는 문법중 비표준이 더 파워풀한것이 많다
-- 비표준과 표준 문법이 맵핑이 잘 안되는경우가 있다

ECMA ==> 공부하면서 많이 들을것이다 단체이름 유럽

ANSI : SQL
ORACLE : SQL
-- 안시부터 말하고 오라클

ANSI - NATURAL JOIN
- 조인하고자 하는 테이블에 연결컬럼 명(타입도 동일)이 동일한 경우(emp,deptno,dept,deptno)
- 연결 컬럼의 값이 동일한 때(=) 컬럼이 확장된다.(연결된다)

SELECT ename, dname
FROM emp NATURAL JOIN dept;

SELECT emp.empno, emp.ename, emp.deptno  -- deptno 연결자라 안된다 , 한정자를 붙일 수도 있고 없다 ==> 내츄럴 조인에서는 에러
FROM emp NATURAL JOIN dept;

SELECT*
FROM emp;

SELECT *
FROM emp NATURAL JOIN dept;

ORACLE join :
1. FROM절에 조인할 테이블을 (,)콤마로 구분하여 나열
2. WHERE : 조인할 테이블의 연결조건을 기술 -- 행에 대한 제한, 두 테이블에 연결조건

SELECT *
FROM emp, dept
WHERE emp.deptno = emp.deptno; -- 한정자를 붙여야(emp.) 에러가 안나온다 (왼쪽 8개 emp테이블, 오른쪽 dept)

7369 SMITH, 7902 FORD
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno; -- 테이블 별칭을 써야한다 같은 emp컬럼이기 때문에
-- 킹의 매니저는 널이었다 ==> 조인에 실패를 한것이다

ANSI SQL : JOIN WITH USING -- 내츄럴 조인이랑 비슷하지만 잘 안쓴다
조인 하려고 하는 테이블의 컬럼명과 타입이 같은 컬럼이 두개 이상인 상황에서 두 컬럼을 모두 조인 조건으로 참여시키지 않고 개발자가 원하는 특정 컬럼으로만 연결을 시키고 싶을 때 사용한다

SELECT * -- 한정자를 사용할 수 없다
FROM emp JOIN dept USING(deptno); -- 내츄럴 조인과 결과가 비슷하다

-- 내츄럴조인과 조인위드유징은 대체할 것 있다.

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

JOIN WITH ON : NATURAL JOIN, JOIN WITH USING을 대체할 수 있는 보편적인 문법
조인 컬럼은 조건을 개발자가 임의로 지정

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno); -- 오라클 조인과 차이점 ON이 들어가는 것 , WHERE절을 사용하는 것

--사원 번호, 사원 이름, 해당사원의 상사 사번, 해당사원의 상사 이름 : JOIN WITH ON을 이용하여 쿼리 작성 / 단 사원의 번호가 7369에서 7698 사원들만 조회

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;

==> 실행대기 
-- 컴퓨터는 한순한게 하나의 일을 한다
-- 내가 먼저 기술했다고 무조건 먼저 읽는게 아니다 속도 처리가 빠른거를 먼저 실행된다, 예측이 불가능하다(경험이 많은 사람은 예측이 가능하다
-- 옵팉마이저 ==> 룰베이스 ==> (1 ~ 15개 정도 있었다.
-- 코스트 베이스 옵티마이저

-- 더닝 트루거 이펙트

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m  
WHERE e.empno BETWEEN 7369 AND 7698
    AND e.mgr = m.empno;
    
논리적인 조인 형태
1. SELF JOIN : 조인 테이블이 같은 경우 -- 조인 테이블이 같으면 셀프조인이다
    -계층구조 
2. NONEQUI-JOIN : 조인 조건이 = (equals)가 아닌 조인 -- 만힝 쓰인다
 
SELECT *
FROM emp, dept
WHERE emp.deptno != dept.deptno; --> 한 사원은 3개씩 연결이 됨 ==> 시험에 나온다

SELECT *
FROM salgrade; -- 급여 테이블

--salgrade를 이용하여 직원의 급여 등급 구하기
--empno, ename, sal, 급여등급
--ansi, oracle

SELECT *
FROM emp;

emp.sal>=salgrade.losal AND emp.sal <= salgrade.hisal == emp.sal BETWEEN salgrade.losal AND salgrade.hisal

SELECT e.empno, e.ename, e.sal
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal; -- 엑셀에 데이터를 보고 대입해보면서 해야한다

SELECT e.empno, e.ename, e.sal
FROM emp e JOIN salgrade s ON ( e.sal BETWEEN s.losal AND s.hisal); -- where절을 빼고 조인 온 넣기

실습 join0
--emp, dept 테이블을 이용하여 다음과 같이 조회 되도록 쿼리를 작성하세요

SELECT e.empno, e.ename, e.deptno, d.dname -- deptno는 두개 다 가지고 있기 때문이다
FROM emp e, dept d
WHERE e.deptno = d.deptno;
-- 명확한 컬럼을 사용해야 된다. 한정자를 안쓰면 에러다(간단히 생각하면)

실습 join0_1
emp, dept테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요 (부서번호가 10,30인 데이터만 조회)

SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
    AND e.deptno IN (10, 30)
    AND d.deptno IN (10, 30); -- 두개 써도 되고 둘중 1개 써도 문제가 없다
    
    
실습 join0_2
SELECT e.empno, e.ename, e.deptno, e.sal, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
    AND e.sal > 2500;

실습 join0_3
    SELECT e.empno, e.ename, e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
    AND e.sal > 2500
    AND e.empno > 7600;

실습 join0_4
--emp, dept 테이블을 이용하여 다음과 같이 조회되는 쿼리를 작성하세요 (급여 2500 초과, 사번 76000보다 크고 , research 부서에 속하는 직원)
 SELECT e.empno, e.ename, e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
    AND e.sal > 2500
    AND e.empno > 7600
    AND e.deptno = 20
    AND d.dname = 'RESEARCH';
    
-- 버츄얼
-- 오라클 간단히 설치하는 방법
-- 가상화 ==> 플4로 게임안에서 주인공이 플1으로 게임을 하고있다
가상화가 도입된 이유 -- 윈도 안에 리눅스를 프로그램처럼 설치할거다 -- 리눅스 안에다 오라클을 설치한다 -- 삭제하기 용이하다 속도는 느리다
    물리적인 컴퓨터는 동시에 하나의 OS만 실행 가능
    성능이 좋은 컴퓨터(서버)라도 하드웨어 자원의 활용이 낮음 : 15 ~ 20 %
    컴퓨터는 냉방이 중요
    서버가 늘어날 수록유지 관리가 힘듬 ==> 클라우드 서비스
    성능이 좋은 컴퓨터(서버) 자원의 활용도를 높일 수 있는 방법
    성능이 좋은 서버를 논리적으로 잘게 나눈다
    하나의 OS에 여러개의 OS를 설치할수 있게 함 ==> 가상화
    하드웨어 자원을 효율적으로 사용할 수 있다.
    
Virtual BOX ==> 오라클무료 프로그램 ==> 환경설정 ==> 확장 ==> 확장팩 설치 (초록) ==> 가상시스템 가져오기 오라클 디벨로퍼 데이 ==> 시작하면 창이 뜸 ==> 그냥 둬야된다 잘못되면 빠져나오기 힘듬 ==> 1513 orcl

언제든지 지우고 쓸수있어서 혼자쓰기 용이

포트 ==> 2^16 == 65000정도 ==> 미리 예약된것은 100개정도 ==> 포트는 쓰고있으면 다른곳에서는 못쓴다 ==> 제품마다 고유의 포트가 있다
포트 포워딩 ==> 가상화 상태를 컴터 포트에 연결 ==> 설정 네트워크 고급  ==> 호스트에 임의, 게스트에 가상과 연결 
-- 자주듣는 숫자 2^10 == 1024
-- 네코제, OKKYCON 년에 1번씩 세미나를 하고있다. ==> 오라클 디벨로퍼 데이

가상화의 단점을 보완하기 위해 독커가 나왔다

docker
==> 리눅스를 사용
docker 장점
==> 도커 허브에 있는 것을 다운 받아 쓸수도 있고 만들수도 있고 공유도 가능하다

모델링 투 ==> 테이블을 직접 만들어야 할 때 사용 ==> 이클립스기반






























