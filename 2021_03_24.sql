2021 03 24 복습

WHERE, GROUP BY, JOIN -- 중요하다

문제]
SMITH가 속한 부서에 있는 직원들을 조회하기? ==> 20번 부서에 속하는 직원들 조회하기

1. SMITH가 속한 부서 이름을 알아 낸다.
2. 1번에서 알아낸 부서번호로 해당 부서에 속하는 직원을 emp테이블에서 검색한다.

1.
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

2.
SELECT *
FROM emp
WHERE deptno = 20;

SUBQUERY를 활용;
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
                
--- 연습

SELECT
    deptno
FROM
    emp
WHERE
    ename = 'SMITH';

SELECT
    *
FROM
    emp
WHERE
    deptno = (
        SELECT
            deptno
        FROM
            emp
        WHERE
            ename = 'SMITH'
    );
//서브쿼리 ==> 한결과를 가져다 쓰는것
// (=)를 쓰기때문에 2개의 값이 오면 안됨


SUBQUERY : 쿼리의 일부로 사용되는 쿼리
서브쿼리에서 사용하는 것을 메인쿼리라고 한다.
다른 개발자와 소통시 필요한점이 많다.
1. 사용위치에 따른 분류
    SELECT : 스칼라 서브 쿼리 - 서브쿼리의 실행결과가 하나의 행, 하나의 컬럼을 반환하는 쿼리
    FROM : 인라인 뷰
    WHERE : 서브쿼리
                메인쿼리의 컬럼을 가져다가 사용할 수 있다.
                반대로 서브쿼리의 컬럼을 메인쿼리에 가져가서 사용할 수 없다

2. 반환값에 따른 분류 (행, 컬럼의 개수에 따른 분류)
    행-다중행, 단일행, 컬럼 - 단일 컬럼, 복수 컬럼
다중행 / 단일 컬럼 IN, NOT IN
다중행 / 복수 컬럼 (pairwise)
단일행 / 단일 컬럼
단일행 / 복수 컬럼

3. main-sub query의 관계에 따른 분류
    상호 연관 서브 쿼리 - 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓴 경우 (correlated subquery)
        ==> 메인쿼리가 없으면 서브쿼리만 독자적으로 실행 불가능
    비상호 연관 서브 쿼리 - 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓰지 않은 경우 (non-correlated subquery)
        ==> 메인쿼리가 없어도 서브쿼리만 실행가능

서브쿼리 (실습 sub1)
급여 평균 보다 높은 사람 카운트

SELECT *
FROM emp; -- 테이블 확인

SELECT AVG(sal) -- 평균확인
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal >= 2073;  -- 서브 쿼리 안쓰고

SELECT COUNT(*)
FROM emp
WHERE sal >= (SELECT AVG(sal) -- 서브쿼리 쓰고 직원이 바뀔때마다 손을 안쓰고 자동으로 바꿔줌
                FROM emp);
                
-- 연습

SELECT
    *
FROM
    emp;

SELECT
    AVG(sal)
FROM
    emp;

SELECT
    COUNT(*)
FROM
    emp
WHERE
    sal >= 2073;

SELECT
    COUNT(*)
FROM
    emp
WHERE
    sal >= (
        SELECT
            AVG(sal)
        FROM
            emp
    );

서브쿼리 (실습 sub 2)
평균 급여보다 높은 급여를 받는 직원의 정보를 조회하세요

SELECT *
FROM emp; 

SELECT *
FROM emp
WHERE sal >= (SELECT AVG(sal) -- 위에서 카운트(그룹함수를 지운다)
                FROM emp);
                

서브쿼리 (실습 sub3)
SMITH와 WARD사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리를 다음과 같이 작성하세요.

SELECT *
FROM emp;

SELECT *
FROM emp m
WHERE m.deptno IN ('SMITH', 'WARD');
    
SELECT *
FROM emp m
WHERE m.deptno IN (SELECT s.deptno
                    FROM emp s
                    WHERE s.ename IN ('SMITH', 'WARD'));
                    

MULTI ROW 연산자
    IN : = + OR
    비교 연산자 ANY
    비교 연산자 ALL
    
SELECT *
FROM emp e
WHERE e.sal < ANY (SELECT s.sal
                    FROM emp s
                    WHERE s.ename IN ('SMITH', 'WARD'));
                
직원중에 급여값이 SMITH(800)나 WARD(1250)의 급여보다 작은 직원을 조회
    ==> 직원중에 급여값이 1250보다 작은 직원 조회

SELECT *
FROM emp e
WHERE e.sal < (SELECT MAX (s.sal)
                    FROM emp s
                    WHERE s.ename IN ('SMITH', 'WARD'));
-- ANY를 안써도 가능한 논리가 쓰게 되는 경우가 드물다 MAX로 대체가 되었다

직원의 급여가 800보다 작고 1250보다 작은 직원 조회
    ==> 직원의 급여가 800보다 작은 직원 조회
SELECT *
FROM emp e
WHERE e.sal < ALL (SELECT s.sal
                    FROM emp s
                    WHERE s.ename IN ('SMITH', 'WARD'));
                    
SELECT *
FROM emp e
WHERE e.sal < (SELECT MIN(s.sal)
                    FROM emp s
                    WHERE s.ename IN ('SMITH', 'WARD'));
-- 800보다 적게 받는 직원이 없다
-- MIN과 같은 의미로 쓰였다
-- 비상화라 서브쿼리를 독자적으로 실행할 수 있다.

subquery 사용시 주의점 NULL 값
IN ()
NOT IN ()

SELECT *
FROM emp
WHERE deptno IN (10,20,NULL);
    ==> deptno = 10 OR deptno = 20 OR deptno = NULL -- 결과는 FALSE
    
SELECT *
FROM emp
WHERE deptno NOT IN (10,20,NULL);
    ==>!(deptno = 10 OR deptno = 20 OR deptno = NULL) -- 결과는 FALSE
     ==> deptno != 10 AND deptno != 20 AND deptno AND NULL -- 결과는 FALSE
                                                FALSE -- AND 값에 하나가 폴스라 하나도 안나오는 것이다
                                                
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                    FROM emp);
-- 잘못한게 없는거 같은데 데이터가 안나오는 경우가 개발을 하다보면 많이 나온다
-- 안나오는게 보이면 NOT IN을 잘 확인 하자

누군가의 매니저가 아닌 사람들
SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr,9999)
                    FROM emp);
-- 두번째 시험에서 나온다. #############################
        

PAIR WISE : 순서쌍

SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
                FROM emp
                WHERE empno IN(7499,7782))
    AND deptno IN (SELECT deptno
                    FROM emp
                    WHERE empno IN(7499,7782));

--ALLEN (30, 7698), CLARK(10, 7839)               
SELECT ename, mgr, deptno
FROM emp
WHERE empno IN(7499, 7782);

SELECT *
FROM emp
WHERE mgr IN(7698, 7839)
    AND deptno IN (10, 30);
mgr, deptno
(7698, 10), (7698,30), (7839, 10), (7839,30) 
-- 4가지의 경우의 수를 보여준다
-- 2개는 경우의 수에 의해서 만들어진 수이다.

요구사항 : ALLEN 또는 CLARK의 소속 부서번호와 같으면서 상사도 같은 직원들을 조회
-- 지금까지 배운 조건으로는 안나온다 PAIR WISE를 사용해야한다.

SELECT *
FROM emp
WHERE (mgr, deptno) IN
                        (SELECT mgr, deptno
                        FROM emp
                        WHERE ename IN ('ALLEN', 'CLARK'));

-- PAIR WISE를 하여 순서쌍을 적용한 것이다
-- 이런 개념이 있었다 정도로 이해하자 // 수업시간에는 안나오지만 실무에 가서 나올수도 있다.

DISTINCT - 
        1. 설계가 잘못된 경우
        2. 개발자가 sql을 잘 작성하지 못하는 사람인 경우
        3. 요구사항이 이상한 경우
        
        
스칼라 서브쿼리 : SELECT 절에 사용된 쿼리, 하나의 행, 하나의 컬럼을 반환하는 서브쿼리(스칼라 서브쿼리)
-- 잘못 배우면 남용하는 사례가 많다 // 함부로 쓰면 독이 될 수가 있다.

SELECT empno, ename, SYSDATE
FROM emp;

SELECT SYSDATE
FROM dual;
-- 함수를 사용할 때 dual 테이블을 자주 사용한다

SELECT empno, ename, (SELECT SYSDATE FROM dual)
FROM emp;
-- 스칼라 서브쿼리를 여러줄로 써도 된다.

SELECT empno, ename, (SELECT SYSDATE, SYSDATE FROM dual)
FROM emp;
-- 하나의 행 하나의 컬럼을 반환하기때문에 2개가 들어가서 에러다.
-- 비상호 연관 서브 쿼리이다.
-- 스칼라 서브쿼리는 보통 상호 연관 서브쿼리로 사용하게 된다.

emp 테이블에는 해당 직원이 속한 부서번호는 관리하지만 해당 부서명 정보는 dept테이블에만 있다.
해당 직원이 속한 부서 이름을 알고 싶으면 dept 테이블과 조인을 해야한다.

-- 행을 확장하는것 JOIN

SELECT empno, ename, deptno
FROM emp;

-- 메인쿼리 1번에
-- 서브쿼리 행의 개수

상호연관 서브 쿼리는 항상 메인 쿼리가 먼저 실행된다.
SELECT empno, ename, deptno,
        (SELECT dname FROM dept WHERE dept.deptno=emp.deptno)
FROM emp;

-- JOIN을 안쓰고 스칼라 서브 쿼리로 가능하게 된거다
-- JOIN에 대한 두려움 때문에 쿼리를 너무 많이 작성하게 되면 독이 된다.
-- 행마다 실행이 된다 // 메인쿼리의 행을 가져다 써서 행마다 다른 결과를 낸다.
-- 메인은 1번 ==> 메인쿼리에 조회된게 14개 ==> 1 + 14 == 15번


비상호연과 서브쿼리는 메인쿼리가 먼저 실행 될 수도 있고
                    서브쿼리가 먼저 실행 될 수도 있다
                    ==> 성능측면에서 유리한 쪽으로 오라클이 선택
                    
SQL은 눈에보에는게 전부가 아니다
쿼리의 절차는 오라클이 하기때문에 공부를 열심히 해야된다.


인라인 뷰 : SELECT QUERY
    inline : 해당위치에 직접 기술 함
    inline view : 해당 위치에 직접 기술한 view
        view : QUERY ==> view table(x)

SELECT *
FROM
(SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno);

아래 쿼리는 전체 직원의 급여 평균보다 높은 급여를 받는 직원을 조회 하는 쿼리
SELECT  empno, ename, sal, deptno
FROM emp e
WHERE e.sal >= (SELECT AVG(sal) 
                FROM emp a);
                
-- 다 같이 실행 해야된다
                
직원이 속한 부서의 급여 평균보다 높은 급여를 받는 직원을 조회
SELECT  empno, ename, sal, deptno
FROM emp e
WHERE e.sal >= (SELECT AVG(sal) 
                FROM emp a
                WHERE a.deptno = e.deptno);
                
                
                
SELECT  e.empno, e.ename, e.sal, e.deptno, a.avg_sal
FROM emp e
WHERE e.sal >= (SELECT AVG(sal) avg_sal
                FROM emp a
                WHERE a.deptno = e.deptno);
    
-- 서브 쿼리의 컬럼을 메인쿼리에 사용할 수 없다



SELECT  e.empno, e.ename, e.sal, e.deptno,
        (SELECT AVG(sal) avg_sal
                FROM emp a
                WHERE a.deptno = e.deptno)
FROM emp e
WHERE e.sal >= (SELECT AVG(sal) avg_sal
                FROM emp a
                WHERE a.deptno = e.deptno);

-- 평균을 구하는것
-- 요구사항이 이래서 어쩔수 없이 두번을 사용하는 것이다. 어쩔수가 없다 조인으로는 간단하게 쓸 수 있다.
                
20번 부서의 급여 평균 (2175)
SELECT AVG (sal)
FROM emp
WHERE deptno = 20

10번 부서의 급여 평균 (2916.666)
SELECT AVG(sal)
FROM emp
WHERE 

서브쿼리
        상호 연관 서브 쿼리 == 서브쿼리에서 메인 쿼리를 참조
                쿼리 실행 순서가 정해져 있다
                메인 ==> 서브
                
        비상호 연관 서브 쿼리 = 서브쿼리에서 메인 쿼리를 참조하지 않음
                쿼리 실행 순서가 정해져있지않다 
                메인 ==> 서브
                서브 ==> 메인
                -- 오라클이 정해준다
                -- 요구사항에 만족하게 쓰는게 맞다 // 양방향이라 상호보다는 용이할수 있다

deptno, dname, loc
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT *
FROM dept;

10 20 30 40 99 이 들어있다

10 20 30 직원이 속해있음

서브 쿼리 실습 sub4
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
dept 테이블에는 신규 등록된 99번 부서에 속한 사람은 없음 직원이 속하지 않은 부서를 조회하는 쿼리를 작성해 보세요
==> 우리가 알 수 있는건 직원이 속한 부서

SELECT *
FROM dept
WHERE deptno NOT IN (10,20,30);
-- 하드 코딩하지 마라

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                        FROM emp);
-- 서브쿼리로 작성

SELECT deptno
FROM emp


서브쿼리 (실습 sub5)
cycle product 테이블을 이용하여 cid = 1인 고객이 애음하지 않는 제품을 조회하는 쿼리를 작성하세요

SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT pid
FROM cycle
WHERE cid = 1;

SELECT *
FROM product 
WHERE pid NOT
in

( SELECT
    pid
  FROM
    cycle
  WHERE
    cid = 1
);

















































