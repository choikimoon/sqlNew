0325
윈 머지 ==> 비교툴 조별과제할때 이용

sub6]
cycle 테이블을 이용하여 cid=1 인 고객이 애음하는 제품중 cid=2인 고객도 애음하는 제품의 애음정보를 조회하는 쿼리를 작성하세요

SELECT *
FROM cycle;

SELECT *
FROM cycle;

SELECT *
FROM cycle
WHERE cid = 1;

SELECT *
FROM cycle
WHERE cid = 2;

--- 선생님 풀이

SELECT
    *
FROM
    cycle
WHERE
    cid = 1;
2번 고객이 먹는 제품에 대해서만 1번 고객이 먹는 애음 정보 조회

SELECT
    *
FROM
    cycle
WHERE
    cid = 2;

SELECT
    *
FROM
    cycle
WHERE
    cid = 1
    AND   pid IN (
        SELECT
            pid
        FROM
            cycle
        WHERE
            cid = 2
    );
    
SELECT
    *
FROM
    cycle
WHERE
    cid = 1
    AND   pid IN (
        100,
        200
    );

-- 하드 코딩

서브쿼리] 실습 sub 7
customer, cycle, product 테이블을 이용하여 cid=1인 고객이 애음하는 제품중 cid=2인 고객도 애음하는 제품의 애음정보를 조회하고 고객명과 제품명까지 포함하는 쿼리를 작성하세요

SELECT
    *
FROM
    cycle c, customer s, product p -- 순서는 중요하지 않다 오라클에서 효율적으로 실행해준다
WHERE
    c.cid = 1  -- 5 * 3 * 4 == 60 크로스 조인
    AND c. cid = s.cid -- 5 * 4 == 20 프로덕트는 연결점이 없다
    AND c. pid = p.pid -- 조인을 쓰는것이 어려우면 스프레드 시트를 계속해서 작성해보자
    AND   pid IN (
        SELECT
            pid
        FROM
            cycle
        WHERE
            cid = 2
    );
    
SELECT *
FROM customer;

SELECT *
FROM product;

EXISTS 서브쿼리 연산자 : 단항 -- 존재한다라는 뜻
[NOT] IN : WHERE 컬럼 | EXPRESSION IN (값1, 값2, 값3 .....) -- 부정 연산자로 바꿀수있다
[NOT] EXISTS : WHERE EXISTS (서브쿼리) -- 부정 연산자로 바꿀수있다
        ==> 서브쿼리의 실행결과로 조회되는 행이 ******하나라도****** 있으면 TRUE, 없으면 FALSE
        EXISTS 연산자와 사용되는 서브쿼리는 상호연관, 비상호연관 서브쿼리 둘다 사용 가능하지만
        행을 제한하기 위해서 상호연과 서브쿼리와 사용되는 경우가 일반적이다.
        
        서브 쿼리에서 EXISTS 연산자를 만족하는 행을 하나라도 발견을 하면 더이상 진행하지 않고 효율적으로 일을 끊어 버린다.
        서브 쿼리가 1000건이라 하더라도 10번째 행에서 EXISTS 연산을 만족한는 행을 발견하면 나머지 9990 건정도의 데이터를 확인 안한다.
        -- IN 연산자랑 비슷하다
        -- 값이 중요한게 아니다
함수 : 1. 함수 이름을 보고 뭐하는지
        2. 어떤 인자가 필요한지

연산자 : 1. 몇항인가를 고민해보자
1 + 5 // 2항 == > ? ==> 3항 == Java
++, == : 단항 연산자

-- 매니저가 존재하는 직원
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X' 
                FROM emp m
                WHERE e.mgr = m.empno);
                -- 상호 연관 서브 쿼리
                
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'  
                FROM emp m
                WHERE null = m.empno);
                -- 킹을 제외한 13개의 건이 나온다 null이기 때문에 행이 없다
                
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X' -- EXISTS 서브쿼리에는 관습적으로 SELECT 절에 'X'라고 많이 쓴다.
                FROM dual);
                -- 프럼 듀얼은 항상 참으로 인식이 된다.
                -- 비상호 연관쿼리로 사용할 수는 있지만 잘 사용하지 않고 상호 연관쿼리로 대부분 사용한다
                -- All or noting

SELECT COUNT(*)
FROM emp
WHERE deptno = 10;

-- if문을 사용했을때 1억건이라고 생각하면 모든 데이터를 읽어야한다.

SELECT *
FROM dual
WHERE EXISTS (SELECT 'X' FROM emp WHERE deptno = 10);

-- 많은 데이터에서 조건을 뽑을때는 EXISTS를 사용하는게 효율적이다.

서브쿼리 실습 sub9
cycle, product 테이블을 이용하여 cid = 1인 고객이 애음하는 제품을 조회하는 쿼리를 EXISTS 연산자를 이용하여 작성하세요

SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT
    *
FROM
    product
WHERE
    EXISTS (
        SELECT
            'X'
        FROM
            cycle
        WHERE
            cid = 1
            AND   product.pid = cycle.pid
    );
    
SELECT
    *
FROM
    product
WHERE
    NOT EXISTS (
        SELECT
            'X'
        FROM
            cycle
        WHERE
            cid = 1
            AND   product.pid = cycle.pid
    );
    
    -- 1번 고객이 먹지 않는 제품
--서브쿼리를 사용하면 논리적으로 우리가 유리하게 사용할 수 있다.

집합연산
1. UNION / UNION ALL
                합집합
                UNION ALL : 중복을 허용한다
                UNION : 중복을 허용하지 않는다
2. INTERSECT
                교집합
3. MINUS
                차집합
-- 집합은 중복을 허용하지 않는다.

집합연산

        데이터를 확장하는 sql의 한 방법
        수학시간에 배운 집합의 개념과 동일
        집합에는 중복, 순서가 없다
            {1,2}, {2,1}은 동일하다
            
        집합연산
            행(row)을 확장 ==> 위 아래
                위 아래 집합의 col의 개수와 타입이 일치해야 한다.
            
        join
            열(col)을 확장 ==> 양 옆
        
        union
            합집합
            중복을 제거
        
        union all
        합집합
        중복을 제거하지 않음 ==> union 연산자에 비해 속도가 바르다
        
        intersect
        교집합 : 두집합의 공통된 부분
        
        minus
        차집합 : 한 집합에만 속하는 데이터
        
        -- 개발을 하기 때문에 상황을 잘 알아야한다. 오라클은 모르기 때문에 개발자가 판단을 잘하고 연산자를 잘 활용해야한다.
        
-- 실습
UNION : 합집합, 두개의 SELECT 결과를 하나로 합친다, 단 중복되는 데이터는 중복을 제거한다.
        ==> 수학적 집합 개념과 동일
        
SELECT empno, ename , null
FROM emp
WHERE empno IN (7369, 7499)

UNION -- 위아래 전체가 쿼리이다.

SELECT empno, ename, deptno -- 에러
FROM emp
WHERE empno IN (7369, 7521);

-- 컬럼의 개수가 맞아야 한다
-- 개수가 안 맞는 경우에는 가짜 컬럼을 넣어줘서 데이터를 맞춰준다

UNION ALL : 중복을 허용하는 합집합
            중복 제거 로직이 없기 때문에 속도가 빠르다
            합집합 하려는 집합간 중복이 없다는 것을 알고 있을 경우 UNION 연산자 보다 UNION ALL 연산자가 유리하다
            
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

UNION  ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);

-- 실행속도가 더 좋다

INTERSECT 두개의 집합중 중복되는 부분만 조회

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);


MINUS : 한쪽 집합에서 다른 한쪽 집합을 제외한 나머지 요소들을 반환


SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);


교환 법칙
A U B == B U A (UNION,UNION ALL)
A ^ B == B ^ A
A - B != B - A ==> 집합의 순서에 따라 결과가 달라질 수 있다 [주의]



집한연산 특징
1. 집합연산의 결과로 조회되는 데이터의 컬럼 이름은 첫번째 집합의 컬럼을 따른다

SELECT empno e, ename enm
FROM emp
WHERE empno IN (7369, 7499)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);

-- 알리아스는 위에만 주면 된다

2. 집합 연산의 결과를 정렬하고 싶으면 가장 마지막 집합 뒤에 ORDER BY를 기술한다.
    개별 집합에 ORDER BY를 사용한 경우 에러
    단 ORDER BY를 적용한 인라인뷰를 사용하는 것은 가능

SELECT empno e, ename enm
FROM emp
WHERE empno IN (7369, 7499)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521)
ORDER BY e;

-- 위를 하나의 컬럼으로 보기때문에 마지막에 쓴다

SELECT e, enm
FROM
(SELECT empno e, ename enm
FROM emp
WHERE empno IN (7369, 7499)
ORDER BY e)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521)
ORDER BY e;

-- 인라인뷰로 묶기가 가능

3. 중복은 제거가 된다. (예외 UNION ALL)

[참고]4.9i 이전 버전 그룹연산을 하게되면 기본적으로 오름차순으로 정렬되어 나온다
            이후 버전 ==> 정렬을 보장하지 않음
            -- 튜닝에 대한 포인트 ==> 버전을 이용하여 효율적으로 데이터 관리

8i - Internet
--------------- 획기적인 변화
9i - Internet
10g - Grid
11g - Grid
12c - Cloud


DML
        SELECT
        데이터 신규 입력 : INSERT
        기존 데이터 수정 : UPDATE
        기존 데이터 삭제 : DELETE
        
INSERT 문법

INSERT INTO 테이블명 (컬럼명1, 컬럼명2, 컬럼명3.....)
            VALUES (값1, 값2, 값3 ....)

만약 테이블에 존재하는 모든 컬럼에 데이터를 입력하는 경우 컬럼명은 생략 가능하고
값을 기술하는 순서를 테이블에 정의된 컬럼 순서와 일치시킨다.

INSERT INTO 테이블명 VALUES (값1, 값2, 값3);


INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
-- 아래

INSERT INTO dept (deptno, dname, loc) 
            VALUES (99, 'ddit', 'daejeon');

SELECT *
FROM dept;

-- 데이터가 중복되는 이유는 기능을 활성화 안했기 때문이다


INSERT INTO 테이블명 [({column})] VALUES ({value, ...)

DESC dept;

--DESC 결과를 보고 널값이 비어있으면 들어갈 수 있다는 소리이다.

INSERT INTO emp(ename, job) VALUES ('brown', 'RANGER');

-- 널값이 들어가지 못해서 안됨 empno

INSERT INTO emp(empno,ename, job) 
            VALUES (9999, 'brown', 'RANGER');

SELECT *
FROM emp;


INSERT INTO emp(empno,ename, job, hiredate, sal, comm) 
            VALUES (9998, 'sally', 'RANGER', TO_DATE('2021-03-24', 'YYYY-MM-DD'), 1000, NULL);
            
-- 날짜에 SYSDATE 도 들어갈수있다

여러건을 한번에 입력하기
INSERT INTO 테이블명
SELECT 쿼리

-- 셀렉트로 조회된 쿼리를 한번에 테이블에 넣을 수 있다.

INSERT INTO dept
SELECT 90, 'DDIT', '대전' FROM dual UNION ALL
SELECT 80, 'DDIT8', '대전' FROM dual;

-- 한번에 2개가 들어갔다
-- 한번에 하나보다는 여러개를 한번에 하는것이 빠르다
-- 데이터를 가공해서 집어 넣는 일이 많다

SELECT *
FROM dept;


---
커밋을 안한 이유 ==> 지울꺼기 때문에

COMMIT 는 확정 // 롤백 지우는 것
위에 쿼리들이 다 트랜잭션에 묶여있는것이다.

ROLLBACK;

SELECT *
FROM dept;

SELECT *
FROM emp;


UPDATE : 테이블에 존재하는 기존 데이터의 값을 변경

UPDATE 테이블명 SET 컬럼명1=값1, 컬럼명2=값2, 컬럼명3=값3.....
WHERE ;

SELECT *
FROM dept;

부서번호 99번 부서정보를 부서명=대덕IT로, loc = 영민빌딩으로 변경

UPDATE dept SET dname = '대덕IT', loc = '영민빌딩' -- where 절이 없어서 테이블에 있는 모든 내용을 바꾼다
WHERE deptno = 99;
-- 트랜잭션이 유지가 된 상태 롤백이 가능
-- mysql, 마리아는 오토커밋이다. -- 잘못입력하면 위험하니 설정을 바꾸거나 조심해야한다.
-- 오라클은 한번 돌릴수있다는 장점이 있다

주의할점 : WHERE절이 누락이 되었는지 확인해야한다.
            WHERE 절이 누락 된 경우 테이블의 모든 행에 대해 업데이트 진행


의사소통의 중요성




