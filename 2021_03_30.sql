FROM ==> [START WITH] ==> WHERE ==> GROUP BY ==> SELECT ==> ORDER BY

-- 스타트위드가 상황에 따라 다르지만 프럼과 웨어절에 중간에 실행순서가 오게 된다

SELECT
FROM
WHERE
START WITH
CONNECT BY
GROUP BY
ORDER BY


가지치기 : Pruning branch

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename AS ename, mgr, deptno, job
FROM emp
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr;

-- 계층쿼리에 조건을 넣는 방법(2가지 WHERE CONNECT BY)
-- where절 ==> 계층쿼리가 만들어 지고 나서 적용

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename AS ename, mgr, deptno, job
FROM emp
WHERE job != 'ANALYST'
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr;

--CONNNECT BY 절 ==> 계층쿼리가 만들때 적용이된다

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename AS ename, mgr, deptno, job
FROM emp
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr AND job != 'ANALYST';

-- 계층쿼리간 웨어절은 많이 사용되지 않았다

계층 쿼리와 관련된 특수 함수
1. CONNECT_BY_ROOT(컬럼) : 최상위 노드의 해당 컬럼 값

SELECT LPAD(' ', (LEVEL-1)*4) || ename AS ename, CONNECT_BY_ROOT(ename) root_ename
FROM emp
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr;

-- 하향식 쿼리에서 루트가 하나가 아닐수도 있다

2. SYS_CONNECT_BY_PATH(컬럼, '구분자문자열') : 최상위 행부터 현재 행까지의 해당 컬럼의 값을 구분자로 연결한 문자열

SELECT LPAD(' ', (LEVEL-1)*4) || ename AS ename, 
        CONNECT_BY_ROOT(ename) root_ename,
        LTRIM(SYS_CONNECT_BY_PATH(ename, '-'), '-') path_ename
        INSTR('TEST','T'),
        INSTR('TEST','T',2)
FROM emp
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr;

-- 좌측 구분자를 지우기위해 LTRIM을 사용한다
-- 패스에서 (-)를 지우기 위해 INSTR를 사용한다 , SUBSTR도 사용하여 가공한다

3. CONNECT_BY_ISLEAF : CHILD가 없는 leaf node 여부 0 - false(no leaf node) / 1 - true(leaf node)
-- 오라클에는 불이원(트루/폴스)개념이 없어서 0과 1로 구분한다

SELECT LPAD(' ', (LEVEL-1)*4) || ename AS ename, 
        CONNECT_BY_ROOT(ename) root_ename,
        LTRIM(SYS_CONNECT_BY_PATH(ename, '-'), '-') path_ename,
        CONNECT_BY_ISLEAF isleaf
FROM emp
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr;

-- sql의 쿼리중에 계층쿼리의 비중이 높다

SELECT *
FROM board_test;

SELECT gn, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY gn DESC, seq ASC;

-- 계층쿼리는 부모만 따라가기때문에 깊이를 정해주지 않아도 된다
-- 다른 DB는 start with, connect by절이 안되서 오라클이 매우 편한것이다
-- ORDER siblings BY ==> 형제를 유지한다 ==> 그냥 오더바이하면 계층구조가 깨지기 때문에 새로운 키워드로 입력해야한다

시작(ROOT) 글은 작성 순서의 역순으로
답글은 작성 순서대로 정렬

SELECT seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY seq DESC;

시작글부터 관련 답글까지 그룹번호를 부여하기 위해 새로운 컬럼 추가

ALTER TABLE board_test ADD (gn NUMBER);
DESC board_test;

UPDATE board_test SET gn = 1
WHERE seq (1, 9);

UPDATE board_test SET gn = 2
WHERE seq (2, 3);

UPDATE board_test SET gn = 4
WHERE seq NOT IN (1, 2, 3, 9);

COMMIT;

SELECT *
FROM
(SELECT CONNECT_BY_ROOT(seq) root_seq, 
        seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq)
ORDER BY root_seq DESC, seq ASC;

--connet by root를 오더바이를 쓸 수 없다


SELECT gn, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY gn DESC, seq ASC;

---

SELECT *
FROM
(SELECT CONNECT_BY_ROOT(seq) root_seq, 
        seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq)
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY root_seq DESC, seq ASC;

--

SELECT *
FROM emp
WHERE deptno = 10
AND sal= (SELECT MAX(sal)
FROM emp
WHERE deptno = 10);

분석함수(window 함수)
    SQL에서 행간 연산을 지원하는 함수
    
    해당 행의 범위를 넘어서 다른 행과 연산이 가능
    SQL의 약점을 보완
    이전행의 특정컬럼을 참조
    특정 범위의 행들의 컬럼의 합
    특정 범위의 행중 특정 컬럼을 기준으로 순위, 행번호 부여
    
    SUM, COUNT, AVG, MAX, MIN
    RANK, LEAD, LAG .... ~
    

SELECT ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank
FROM emp;
/*ORDER BY deptno, sal DESC;*/ -- 오라클 내부에서 분석함수에 의해 정렬이 되므로 안해도 된다

--분석 함수는 오버라는 키워드가 들어간다
-- RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) 한 컬럼이다
PARTITION BY deptno : 같은 부서코드를 갖는 row를 그룹으로 묶는다
ORDER BY sal DESC : 그룹내에서 sal로 row의 순서를 내림차순으로 정한다
RANK() : 파티션 단위안에서 정렬 순서대로 순위를 부여한다

SELECT
    a.ename,
    a.sal,
    a.deptno,
    b.rank
FROM
    (
        SELECT
            a.*,
            ROWNUM rn
        FROM
            (
                SELECT
                    ename,
                    sal,
                    deptno
                FROM
                    emp
                ORDER BY
                    deptno,
                    sal DESC
            ) a
    ) a,
    (
        SELECT
            ROWNUM rn,
            rank
        FROM
            (
                SELECT
                    a.rn rank
                FROM
                    (
                        SELECT
                            ROWNUM rn
                        FROM
                            emp
                    ) a,
                    (
                        SELECT
                            deptno,
                            COUNT(*) cnt
                        FROM
                            emp
                        GROUP BY
                            deptno
                        ORDER BY
                            deptno
                    ) b
                WHERE
                    a.rn <= b.cnt
                ORDER BY
                    b.deptno,
                    a.rn
            )
    ) b
WHERE
    a.rn = b.rn;

-- 분석함수를 쓰면 간단하고 효율적으로 사용가능하지만 잘못된건아니다

분석 함수

    영역 설정
        PARTITION BY 컬럼코드
        
    순서 설정
        ORDER BY 컬럼 코드 [DESC | ASC]
        
    범위 설정(WINDOWING) - rows 와 range


순위 관련된 함수 (중복값을 어떻게 처리하는가)
RANK : 동일 값에 대해 동일 순위 부여하고, 후순위는 동일값만 건너 뛴다. // 1등이 2명이면 그 다음순위는 3위
DENSE_RANK : 동일 값에 대해 동일 순위를 부여하고, 후순위는 이어서 부여한다 // 1등이 2명이면 그 다음 순위는 2위
ROW_NUMBER : 중복 없이 행에 순차적인 번호를 부여(ROWNUM)

-- 자격증 시험에 자주 나온다

SELECT ename, sal, deptno,
        RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_dense_rank,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_row_number
FROM emp;

SELECT WINDOW_FUCNTION([인자]) OVER ([PARTITION BY 컬럼] [ORDER BY 컬럼])
FROM ....

PARTITION BY : 영역 설정
ORDER BY (ASC/DESC) : 영역 안에서 순서 정하기

anal]

SELECT *
FROM
(SELECT ename, sal, deptno,
        RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_dense_rank,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_row_number
FROM emp)
ORDER BY sal DESC;

---- 선생님 풀이

SELECT COUNT(*)
FROM emp;

SELECT empno, ename, sal, deptno,
        RANK() OVER (ORDER BY sal DESC, empno) sal_rank,
        DENSE_RANK() OVER (ORDER BY sal DESC, empno) sal_dense_rank,
        ROW_NUMBER() OVER (ORDER BY sal DESC, empno) sal_row_number
FROM emp;

분석함수 / window함수 (실습 no_ana2)

기존의 배운 내용을 활용하여, 모든사원에 대해 사원번호, 사원이름, 해당 사원이 속한 부서의 사원수를 조회하는 쿼리를 작성하세요

SELECT *
FROM emp;

SELECT COUNT(*)
FROM emp;

SELECT emp.empno, emp.ename, emp.deptno, b.cnt
FROM emp,
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) b
WHERE emp.deptno = b. deptno
ORDER BY emp.deptno;

SELECT empno, ename, deptno,
        COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;









