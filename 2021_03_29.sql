0329 복습
-- 인덱스의 컬럼 순서는 중요하다

SELECT ename, job, ROWID
FROM emp
ORDER BY ename, job;

job,ename 컬럼으로 구성된 IDX_emp_03 인덱스 삭제

CREATE 객체타입(INDEX, TABLE...) 객체명
-- 자바 변수 선언과 비슷함
-- 객체 만들기
DROP 객체타입 객체명
-- 객체 삭제

DROP INDEX IDX_emp_03;

-- 인덱스 포지션이 중요하다

CREATE INDEX idx_emp_04 ON emp(ename,job);
-- 컬럼의 순서가 중요하다

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';
--실행계획보기

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);


Plan hash value: 4077983371
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       
-- 액세스로 바로 찾아감
-- 유니크로 안만들었기 때문에 논인덱스
-- 중복이 될 수 있기때문에 내려가면서 버릴거 버리고 찾아가서 넘어간다
-- 구성된 순서가 달라지면 시작하는 순서도 달라진다
-- 프럼절에 테이블이 1개인것만 진행중

SELECT ROWID, dept.*
FROM dept;

CREATE INDEX idx_dept_01 ON dept (deptno);

emp
    1. table full access
    2. idx_emp_01
    3. idx_emp_02
    4. idx_emp_04
    
dept
    1. table full access
    2. idx_dept_01

emp (4) ==> dept (2) : 8
dept (2) ==> emp (4) : 8
-- 5개 이상 조인했다면 접근방법 * 테이블^개수

-- 읽는 방법이 총 16가지이다.
-- 가장 빠른방법을 오라클이 계산한다
-- 16가지의 방법중 항상 정답을 나타낼 수는없다 (응답성이 크다)
-- 오라클은 응답성이 강해서 빠르게 답을 찾아내지만 확실한 정답이라고 할 수 없다

응답성 : OLTP (Online Transaction Processing)
-- 우리가 오라클을 쓰는 목적은 응답성이 크다
퍼포먼스 : OLAP (Online Analysis Processing)
            - 은행이자 계산
            
EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

-- 테이블을 동시에 읽지 못한다 (조인)
-- emp테이블의 1번 인덱스로 읽게 된다 ==> emp테이블을 읽고 나면 emp.deptno가 상수조건 20이 된다
-- 방법이 확실하지 않다 오라클이 오판을 할 수도있고 경우의 수가 많기 때문에

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);


Plan hash value: 951379666
 -- 읽는 순서 : 4 - 3 - 5 - 2 - 6 - 1 - 0
---------------------------------------------------------------------------------------------
| Id  | Operation                     | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |             |     1 |    33 |     3   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |             |       |       |            |          |
|   2 |   NESTED LOOPS                |             |     1 |    33 |     3   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP         |     1 |    13 |     2   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_EMP_01  |     1 |       |     1   (0)| 00:00:01 |
|*  5 |    INDEX RANGE SCAN           | IDX_DEPT_01 |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT        |     1 |    20 |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
   
--위치를 빠르게 찾을 수 있는 이유는 정렬이 되어있기때문이다
--부서테이블과 연결하기 위해 부서번호가 필요한것이다

--index 단점
-- 저장공간이 더 필요하다

Index Access
    소수의 데이터를 조회할 때 유리(응답속도가 필요할 때)
        Index를 사용하는 Input/Output Single Block I/O
    다량의 데이터를 인덱스로 접근할 경우 속도가 느리다(2 ~ 3000건) MAX치 이 건수가 넘어가면 테이블 엑세스보다 느릴수 있다
    웹개발자로서 웹시스템을 사용하는데 Index를 안쓸 수 없다

Table Access
    테이블의 모든 데이터를 읽고서 처리를 해야하는 경우 인덱스를 통해 모든 데이터를 테이블로 접근하는 경우보다 빠르다
        I/O 기준이 multi block
        
테이블에 인덱스가 많으면
인덱스가 정렬되는 위치에 가면 빠르지만 갯수가 많아질수록 부하가 커진다
1.  테이블의 빈공간을 찾아 데이터를 입력
2.  인덱스의 구성컬럼을 기준으로 정렬된 위치를 찾아 인덱스 저장
3.  인덱스는 B*트리 구조이고 root node부터 leaf node까지의 depth가 항상 같도록밸런스를 유지한다  // B*트리 == 밸런스 트리
4.  즉데이터 입력으로 밸런스가 무너질경우 밸런스를 맞추는 추가 작업이 필요
5.  2- 4 까지의 과정을 각 인덱스 별로 반복한다
6. 인덱스가 많아 질 경우 위 과정이 인덱스 개수 만큼 반복 되기 때문에 UPDATE,INSERT,DELETE시 부하가 커진다
인덱스는 SELECT 실행시 조회 성능개선에 유리하지만 데이터 변경시 부하가 생긴다

테이블에 과도한 수의 인덱스를 생성하는 것은 바람직 하지 않음

하나의 쿼리를 위한 인덱스 설계는 쉬움

시스템에서 실행되는 모든 쿼리를 분석하여 적절한 개수의 최적의 인덱스를 설계하는 것이 힘듬


-- (=)이퀄 조건에 앞에 위치한것을 선행컬럼으로 생각한다

-- 이진 트리 작은거는 왼쪽 큰거는 오른쪽
-- 큰 데이터만 들어오면 오른쪽으로 치우치는 우하향이 심해짐
-- 이때 B트리가 트리가 성장함에 따라 밸런스를 조정해줘서 골고루 분포하게 바꿔준다

과제
index 실습 idx3
시스템에서 사용하는 쿼리가 다음과 같다고 할 때 적절한 emp테이블에 필요하다고 생각되는 인덱스 생성 스크립트를 만들어보세요



달력쿼리

배우고자 하는 것
데이터의 행을 열로 바꾸는 방법
레포트 쿼리에서 활용 할 수 있는 예제 연습

주어진 상황
    년월 : 201905
    
하고 싶은 것
    해당 년월의 일자를 달력 형태로 출력
    
    요일을 맞춰 한줄에 한 주차씩 표현
        일반적인 달력
        
달력만들기
주어진것 : 년월 6자리 문자열 ex-202103
만들것 : 해당 년월에 해당하는 달력 (7칸 짜리 테이블)

20210301 - 날짜, 문자열
20210302
20210303
.
.
.
20210331
--(LEVEL은 1부터 시작)
SELECT dummy, LEVEL
FROM dual
CONNECT BY LEVEL <=10;

SELECT *
FROM emp;

'202103' ==> 31;
SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')
FROM dual;
-- 일자에 해당하는 값

SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) dt
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD');

주차 : IW
주간 요일 : D

SELECT dt, d
        일요일이면 dt 아니면 null, 월요일이면 dt 아니면 null
        DECODE(d, 1, dt) sun, DECODE(d, 2, dt) mon, 
        화요일이면 dt 아니면 null, 수요일이면 dt 아니면 null
        DECODE(d, 3, dt) tue, DECODE(d, 4, dt) wed, 
        목요일이면 dt 아니면 null, 금요일이면 dt 아니면 null
        DECODE(d, 5, dt) thu, DECODE(d, 6, dt) fri, 
        토요일이면 dt 아니면 null, 
        DECODE(d, 7, dt) sat
FROM
(SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'D') d/*,
         TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'IW') iw*/
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'));

-- 투데이트 문안을 자주 사용해서 인라인뷰로 감싼다 ==> 쿼리가 길어지는 것을 방지


SELECT DECODE(d,1, iw+1, iw),
        MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon, 
        MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wed, 
        MIN(DECODE(d, 5, dt)) thu, MIN(DECODE(d, 6, dt)) fri, 
        MIN(DECODE(d, 7, dt)) sat
FROM
(SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'D') d,
         TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'))
GROUP BY DECODE(d,1, iw+1, iw)
ORDER BY DECODE(d,1, iw+1, iw);

-- MAX보다 MIN을 오라클에서는 선호한다 // 둘다 같은 결과가 나올때
-- 일요일이 한칸씩 올라가있음 // 주의 시작이 월요일로 인식을 하고 있기 때문이다 // 국제 표준이다
-- 주차의 기준은 해당 주일의 목요일을 기준으로 한다 2020년 1월 2일

SELECT DECODE(d,1, iw+1, iw),
        MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon, 
        MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wed, 
        MIN(DECODE(d, 5, dt)) thu, MIN(DECODE(d, 6, dt)) fri, 
        MIN(DECODE(d, 7, dt)) sat
FROM
(SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'D') d,
         TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'))
GROUP BY DECODE(d,1, iw+1, iw)
ORDER BY DECODE(d,1, iw+1, iw);

계층쿼리 - 조직도, BOM(Bill of Material), 게시판(답변형 게시판)
        - 데이터의 상하 관계를 나타내는 쿼리
SELECT empno, ename, mgr
FROM emp;
--생산물류 부품조립시 자주 사용하는 쿼리이다
--BOM ==> 설명서
--오라클을 사용하는 이유중 하나는 계층쿼리이다

사용방법 : 1. 시작위치를 성정
            2. 행과 행의 연결 조건을 기술
            
PRIOR - 이전의, 사전의, 이미 읽은 데이터(오라클 해석)
CONNECT BY 내 읽은 행의 사번과 = 앞으로 읽을 행의 MGR 컬럼

SELECT empno, ename, mgr
FROM emp
START WITH empno = 7839
CONNECT BY PRIOR empno = mgr;
--START WITH mgr IS NULL

--부모 ==> 자식 순으로 나온다
--데이터 정렬로는 나태날수없다

이미 읽은 데이터 = 앞으로 읽어야 할 데이터
KING의 사번 = mgr 컬럼의 값이 KING의 사번인 녀석
empno = mgr
PRIOR - 이전의, 사전의, 이미 읽은 데이터(오라클 해석)
CONNECT BY 내 읽은 행의 사번과 = 앞으로 읽을 행의 MGR 컬럼;

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename, mgr, LEVEL
FROM emp
START WITH empno = 7839
CONNECT BY PRIOR empno = mgr;

-- CONNECT BY와 PRIOR는 세트가 아니다
-- PRIOR + 컬럼명이 세트이다
-- CONNECT BY = mgr PRIOR empno AND deptno = PRIOR deptno; // 이렇게 표현 할 수도 있다

-- 존스 기준
-- 계층쿼리이기 때문에 LEVEL 컬럼을 쓸 수있다
-- LEVEL컬럼을 사용하여 시각적으로 보기 좋게 만들기 (들여쓰기)

SELECT LPAD('TEST', 1*10)
FROM dual;

--LPAD를 써서 시각적효과를 내는 문제가 많다


계층쿼리 방향에 따른 분류

상향식 : 최하위 노드(leaf node)에서 자신의 부모를 방문하는 형태
하향식 : 최상위 노드(root node)에서 모든 자식 노드를 방문하는 형태

-- 상황에 따라 사용할 수 있다

상향식 쿼리
SMITH(7369)부터 시작하여 노드의 부모를 따라가는 계층형 쿼리 작성

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename, mgr, LEVEL
FROM emp
START WITH empno = 7369
CONNECT BY PRIOR mgr = empno;
CONNECT BY SMITH의 mgr 컬럼값 = 내 앞으로 읽을 행 empno


SELECT *
FROM dept_h;

최상위 노드부터 리프 노드까지 탐색하는 계층 쿼리를 작성 (LPAD를 이용한 시각적 표현까지 포함)

SELECT deptcd, LPAD(' ', (LEVEL-1)*4) || deptnm, p_deptcd, LEVEL
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

-- 선생님 풀이

SELECT LPAD(' ', (LEVEL-1)*4) || deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

//PSUEDO CODE - 가상코드
CONNECT BY 현재행의 deptcd = 앞으로 읽을 행의 p_deptcd

--

--가상코드를 보고 구현을 해보는 연습을 하자


계층쿼리 (실습 h_2)
정보시스템 부 하위의 부서계층을 구조를 조회하는 쿼리를 작성하세요

SELECT *
FROM dept_h;

SELECT LEVEL, deptcd, LPAD(' ', (LEVEL-1)*4) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

-- pre order 형식이다

계층쿼리 (실습 h_3)
디자인팀에서 시작하는 상향식 계층 쿼리를 작성하세요

SELECT *
FROM dept_h;

SELECT deptcd, LPAD(' ', (LEVEL-1)*4) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

-- 선생님 풀이

SELECT deptcd, LPAD(' ', (LEVEL-1)*4) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;
CONNECT BY 현재행의 부모(P_DEPDCD) = 앞으로 읽을 행의 부서코드(DEPT_CD)

--

SELECT *
FROM h_sum;

SELECT LPAD(' ', (LEVEL-1)*4) || s_id S_ID, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

DESC h_sum;
-- 문자인지 숫자인지 확인하자

-- 컬럼을 가공하지않는한 01이라는것은 올수 없다 01 = 1이 되기때문에 가공을 해서 문자로 만들어야한다
-- 인덱스는 좌변이 가공되어있으면 안된다