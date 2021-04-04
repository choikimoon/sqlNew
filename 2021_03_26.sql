0326 복습

INSERT 단건, 여러건

INSERT INTO 테이블명
SELECT ......

UPDATE 테이블명 SET 컬럼명1 = 'TEST'
-- 셀렉트 쿼리로 할 수있다 == 컬럼 1 행 1 스칼라 서브쿼리

UPDATE 테이블명 SET 컬럼명1 = (스칼라 서브쿼리),
                    컬럼명2 = (스칼라 서브쿼리),
                    컬럼명3 = 'TEST';
                    
9999사번(empno)을 갖는 brown 직원(ename)을 입력

INSERT INTO emp (empno, ename) VALUES (9999, 'brown');
INSERT INTO emp (ename, empno) VALUES ('brown', 9999); -- 테이블 순서를 바꿔도 되지만 값도 순서대로 바꿔줘야된다.

DESC emp;
--선언된 순서로 나온다

SELECT *
FROM emp;

9999번 직원의 deptno와 job 정보를 SMITH 사원의 deptno, job 정보로 업데이트

--서브쿼리 이용 기본 틀
SELECT deptno, job
FROM emp
WHERE ename = 'SMITH';

UPDATE emp SET deptno = (SELECT deptno
                        FROM emp
                        WHERE ename = 'SMITH'),
                job = (SELECT job
                        FROM emp
                        WHERE ename = 'SMITH')
WHERE empno = 9999;

-- 자주 나오는 사례가 아니다
-- 사람이 많아지면 서브쿼리를 여러개 작성해야 해서 비효율이다.

SELECT *
FROM emp
WHERE empno = 9999;

MERGE -- 업데이트를 효율적으로 할 수 있게해줌

DELETE : 기존에 존재하는 데이터를 삭제
-- 업데이트와 딜리트는 이미 가공되어있는 정보를 건드는것
-- WHERE절이 매우 중요하다
-- 행을 지운다 == 컬럼에 대한 기술이 없다

DELETE 테이블명
WHERE 조건;

DELETE 테이블명;
-- 테이블의 모든행을 지운다

ROLLBACK
-- 마지막 롤백 이후, 커밋부터 롤백을 해준다
-- SQL에서는 인서트나 업데이트를 시작하는 순간 트랜잭션이 시작된다 끝나는건 롤백과 커밋이 되면


삭제 테스트를 위한 데이터 입력
INSERT INTO emp (empno, ename) VALUES (9999, 'brown');

DELETE emp
WHERE empno = 9999;

mgr가 7698사번(BLAKE)인 직원들 모두 삭제
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE mgr = 7698;
-- 문법적인 관점

SELECT *
FROM emp
WHERE empno IN (SELECT empno
                FROM emp
                WHERE mgr = 7698);
-- 서브쿼리 관점
-- 서브쿼리 안에 머가 삭제될지 미리 보는 습관을 들이자

DELETE emp
WHERE empno IN (SELECT empno
                FROM emp
                WHERE mgr = 7698);

ROLLBACK;

DBMS는 DML 문장을 실행하게 되면 LOG를 남긴다
오라클 버전에서는 UNDO(REDO) LOG

오라클 DBMS 구조*********


로그를 남기지 않고 더 빠르게 데이터를 삭제하는 방법 : TRUNCATE
    DML이 아니고 DDL이다.
    ROLLBACK이 불가능하다.(복구 불가)
    주로 테스트 환경에서 사용

TRUNCATE TABLE 테이블명;
    
CREATE TABLE emp_test AS
SELECT *
FROM emp;
-- 테이블이 만들짐

SELECT *
FROM emp_test;

TRUNCATE TABLE emp_test;

ROLLBACK;

-- 살아나지 않는다
-- 우측상단 접속한 계정을 잘 봐야한다 매우 조심해야한다

트랜잭션
    DML문장이 시작이 될때 (오라클)
    논리적인 일의 단위
    
    아래 사항에서 트랜잭션 발생
    
        관련된 여러 DML문장을 하나로 처리하기 위해 사용
            첫번째 DML문을 실행함과 동시에 트랜잭션 시작
            이후 다른 DML문을 실행
            commit : 트랜잭션을 종료, 데이터를 확정
            rollback : 트랜잭션에서 실행한 DML문을 취소하고 트랜잭션을 종료
            
        트랜잭션 예시
            게시글 입력시 (제목, 내용, 복수개의 첨부파일)
            게시클 테이블, 게시글 첨부파일 테이블
            1.DML : 게시글 입력
            2.DML :게시글 첨부파일 입력
            1번 DML은 정상적으로 실행 후 2번 DML실행시 에러가 발생한다면 ??
            
        DCL / DDL
            자동 commit(묵시적 commit)
            rollback 불가
            
        읽기 일관성 (어렵다)
        sql창을 2개 띄워놓고 같은 계정을 접속하면 2명으로 인식을 한다
        커밋을 해야 인서트로 추가한 행을 다른 계정에서 볼 수 있다
        
        --DAP 네이버 카페
        
읽기 일관성 레델 ( 0 -> 3 )
트랜잭션에서 실행한 결과가 다른 트랜잭션에 어떻게 영향을 미치는지 정의한 레벨(단계)

LEVEL 0 : READ UNCOMMITED
    dirty(변경이 가해졌다) read
    커밋을 하지 않은 변경 사항도 다른 트랜잭션에서 확인 가능
    oracle에서는 지원하지 않음
    
LEVEL 1 : READ COMMITED
    대부분의 DBMS 읽기 일관성 설정 레벨
    커밋한 데이터만 다른 트랜잭션에서 읽을 수 있다.
    커밋하지 않은 데이터는 다른 트랜잭션에서 볼 수 없다
    
LEVEL 2 : Reapeatable Read 
    선행 트랜잭션에서 읽은 데이터를 후행 트랜잭션에서 수정하지 못하도록 방지
    선행 트랜잭션에서 읽었던 데이터를 트랜잭션의 마지막에서 다시 조회를 해도 동일한 결과가 나오게끔 유지
    신규 입력 데이터에 대해서는 막을 수 없음
    ==> Phantom Read (유령 읽기) - 없던 데이터가 조회 되는 현상
    
    기존 데이터에 대해서는 동일한 데이터가 조회되도록 유지
    
    oracle에서는 LEVEL2에 대해 공식적으로 지원하지 않으나 FOR UPDATE 구문을 이용하여 효과를 만들어 낼 수 있다
    트랜잭션을 끝내야 업데이트가 실행 된다


LEVEL3 : Serializable Read 직렬화 읽기
    후행 트랜잭션에서 수정, 입력 삭제한 데이터가 선행 트랜잭션에 영향을 주지 않음
    
    선 : 데이터 조회(14)
    후 : 신규에 입력(15)
    선 : 데이터 조회(14)

인덱스
    눈에 안보인다
    테이블의 일부 컬럼을 사용하여 데이터를 정렬한 객체
    ==> 원하는 데이터를 빠르게 찾을 수 있다
    일부 컬럼과 함께 그 컬럼의 행을 찾을 수 있는 ROWID가 같이 저장됨
    
    ROWID : 테이블에 저장된 행의 물리적 위치, 집 주소 같은 개념
            주소를 통해서 해당 행의 위치로 빠르게 접근하는 것이 가능하다
            데이터가 입력이 될 때 생성
    
    
SELECT ROWNUM, emp.*
FROM emp;

-- 한정자가 필요하다

SELECT ROWID, emp.*
FROM emp;

SELECT emp.*
FROM emp
WHERE ROWID = 'AAAE5gAAFAAAACPAAA';


SELECT emp.*
FROM emp
WHERE empno = 7782;

SELECT empno, ROWID
FROM emp
WHERE empno = 7782;

-- 값이 정렬되어있기에 찾아가는게 매우 빠르다
-- 오라클은 정렬 되어있기에 순차적으로 가는것보다 이진트리처럼 빠르게 간다

SELECT *
FROM emp
WHERE ROWID = 'AAAE5gAAFAAAACPAAC';

-- 인덱스를 만든다는 어떤 테이블을 만든다라는 의미이다

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

-- 밑에 있는 sql에 대해 실행계획을 만든다

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);
    
-- 패키지를 뜻한다 (DBMS_XPLAN) / 실행계획과 관련된 패키지

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7782)
   
-- Rows 예측값 ==> 복잡한 DB를 하면 틀려져서 안보면 된다
-- 1번 ~ 0번으로 읽는것이다 (자신부터)
-- TABLE ACCESS FULL ==> 테이블의 내용을 다 읽은 것 ==> 매우 비효율적

오라클 객체 생성

CREATE 객체 타입 (INDEX, TABLE .....) 객체명
-- 자바 버전
        int     변수명

인덱스 생성
CREATE [UNIQUE] INDEX  인덱스이름 ON 테이블명(컬럼1, 컬럼2);

CREATE  UNIQUE INDEX PK_emp ON emp(empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
   
-- 자식부터 읽는다 2 ==> 1 ==> 0
-- access 빠르게 접근했다


DDL (Index가 없다면)

1. 테이블에는 순서가 없다.
2. 테이블을 끝까지 찾아보고 나서야 쿼리가 종료된다

DDL (Index가 있다면 : PK = unique + not null
1. 정렬이 되었기에 빠르게 쿼리가 종료된다

-- SQL은 겉으로는 티가 안나지만 분석을해야 좋은 효율을 뽑아낸다

SELECT *
FROM emp;


EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 56244932
 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)

-- 오퍼레이션 읽는 방법 ==> 밑에서 아래 들여쓰기 된 순서 ( 1 ~ 0 )
-- 인덱스만 접근하였기 때문에 2번으로 줄어든거다


DROP INDEX PK_EMP;
-- 인덱스를 삭제

-- 중복이 있으면 유니크 인덱스를 만들수 없다

CREATE INDEX IDX_emp_01 ON emp (empno);
-- 중복이 가능한 인덱스이다 (논 인덱스)

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
--|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 | (유니크 인덱스와의 차이점)
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)

-- 바뀐점 : 
-- 인덱스의 이름
-- |*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 | (유니크 인덱스와의 차이점)
-- 인덱스를 한건 읽나 여러건읽나의 차이 (논 인덱스가 여러건)


job 컬럼에 인덱스 생성
CREATE INDEX IDX_emp_02 ON emp (job);

SELECT job, ROWID
FROM emp
ORDER BY job;
-- 인덱스의 형태를 흉내

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);



Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     3 |   114 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     3 |   114 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')


-- 오라클에서 2번째 인덱스를 읽은것이다 (1번은 empno기준 정렬인덱스라 그렇다)

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);



Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%') -- 3건을 읽고 테이블에 접근해서 버린것
   2 - access("JOB"='MANAGER')

-- 필터가 추가 되었다
--인덱스는 4건 ==> 테이블은 3건 ==> 실제값을 1건준거다.

CREATE INDEX IDX_EMP_03 ON emp (job, ename);
-- 인덱스 1개가 추가 되었다

SELECT job, ename, ROWID
FROM emp
ORDER BY job, ename;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);



Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
       
-- 인덱스 3번을 읽음
--인덱스를 2건 읽음 C로 시작하지 않기때문에 매니저에서 2번째까지만 읽는다
-- 필터는 읽고 나서 버린것 , 액세스는 찾아갈때 것


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE '%C';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
       filter("ENAME" LIKE '%c' AND "ENAME" IS NOT NULL)
       
-- 정렬의 의미가 별로 없다 (앞에 머가 올지 모르기 때문에 액세스 조건으로 쓰기 좋지않다)
-- 액세스 조건을 매니저만 쓴거다
-- 인덱스만 읽고 조건에 안맞아서 테이블까지 안간다
-- 테이블에 접근할만한 정보가 없었다.