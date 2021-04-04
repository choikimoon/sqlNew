2021-03-16 복습
-- 항이 몇개인지 생각하자
-- 뭔가를 할 때 뭘하고 있는지 인식을 하면서 해야한다.
-- 본인이 무엇을 짜야하는지 생각하고 문제를 접근하자.
-- 암기보다는 논리적으로 해석하는데 초점을 맞추자.
-- NOT IN 시험

-- 연산자 우선순위 (쓰면서 체감 해야한다) (AND가 OR보다 우선순위가 높다)
==> 헷갈리면 ()를 사용하여 우선순위를 조정하자

SELECT *
FROM emp
WHERE ename = 'SMITH' -- (1 +(OR))
    OR ename = 'ALLEN' -- (2 *(AND))
    AND job = 'SALESMAN'; -- (3)
==> 직원의 이름이 ALLEN 이면서 job이 SALESMAN 이거나 직원의 이름이 SMITH인 직원 정보를 조회

==> 직원의 이름이 ALLEN 이거나 SMITH 이면서 job이 SALESMAN 인 직원 정보를 조회

SELECT *
FROM emp
WHERE (ename = 'SMITH' -- (1 +(OR))
    OR ename = 'ALLEN') -- (2 *(AND))
    AND job = 'SALESMAN'; -- (3)
    
--논리연산 (AND,OR 실습 where14)
--emp 테이블에서 1. job이 SALESMAN이거나 2. 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인 지원의 정보를 다음과 같이 조회하세요 (1번 조건 또는 2번 조건을 만족하는 직원)

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR (empno LIKE ('78%') AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD')); -- 괄호를 빼도 되지만 헷갈리면써라 (where절의 기초를 한것이다)

--데이터 정렬 (페이징 처리할때 쓰인다)
--TABLE 객체에는 데이터를 저장/조회시 (순서를 보장하지 않음)**
--보편적으로 데이터가 입력된 순서대로 조회됨
--데이터가 항상 동일한 순서로 조회되는 것을 보장하지 않는다
--데이터가 삭제되고 다른 데이터가 들어 올 수도 있음

--블럭에는 여러가지 행 데이터가 저장이 된다. 기본 8kbyte
--내가 1개를 보고싶어도 블럭은에 모든 데이터를 봐야한다 (한건으로만 되있으면 다른 데이터를 재사용할 확률이 높다)
--테이블에 데이터를 넣고 한번도 수정을 안해서 지금은 고정으로 나오는것처럼 보이는것이다
--데이터베이스를 배우는 이유 ==> 동시에 여러사람이 접솝하는 환경을 관리하기 위해
--RDBS와 동일한 형태
--okjsp ==> jsp ==> java server page

--데이터 정령(ORDER BY)
--ORDER BY
    --ASC : 오름차순(기본)
    --DESC : 내림차순
    
    --ORDER BY {정렬기준 컬럼 OR alias OR 컬럼번호}[ASC OR DESC].
    
데이터 정렬이 필요한 이유? -- 왜라는것에 대한 생각을 잘 하자
1.table 객체는 순서를 보장하지 않는다. -- 입력에는 장점이 있지만 정렬할때는 단점이다.
    ==> 오늘 실행한 쿼리를 내일 실행할 경우 동일한 순서로 조회가 되지 않을 수도 있다.
2.현실세계에서는 정렬된 데이터가 필요한 경우가 있다.
    ==> 게시판의 게시글은 보편적으로 가장 최신글이 처음에나오고, 가장 오래된 글이 맨 밑에 있다.
    
SQL 에서 정렬 : ORDER BY ==> SELECT ==> FROM ==> [WHERE](있을 수도 없을 수도있다.) ==> ORDER BY
정렬 방법 : ORDER BY 컬럼면 | 컬럼인덱스(순서) | 별칭 [정령순서]
정렬 순서 : 기본 ASC(오름차순), DESC(내림차순)

SELECT *
FROM emp
ORDER BY job DESC, sal ASC, ename ASC; 
A ==> B ==> C ==> [D] ==> ...Z
1 ==> 2 ==> ...100 : 오름차순 (ASC ==> DEFAULT)
100 ==> 99 ==> ...1 : 내림차순 (DESC ==> 명시)==> 디스크라이브 , 디센딩 어디에 쓰냐에 따라 해석이다르다.
-- 두개 이상을 사용할 때 콤마를 붙인다

정렬 : 컬럼명이 아니라 select 절의 컬럼 순서(index)
SELECT empno, job, mgr AS m -- ==> 2번째가 잡이 되어버림 -- alias를 쓸때는 alias 명칭으로도 정렬이 가능하다
FROM emp
ORDER BY m; -- 컬럼의 순서 ==> 숫자 (추천하지않는듯) select 절의 컬럼을 바꾸면 바뀌기때문

데이터 정렬(ORDER BY 실습 orderby1)
-- dept테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요
-- dept테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요
-- 컬럼명을 명시하지 않았습니다 지난수업시간에 배운 내용으로 올바른 컬럼을 찾아보세요

SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY loc DESC;

데이터 정렬(ORDER BY 실습 orderby2)
-- emp 테이블에서 상여(comm) 정보가 있는 사람들만 조회하고 상여(comm)를 만힝 받는 사람이 먼저 조회되도록 정렬하고 상여가 같을 경우 사번으로 내림차순 정렬하세요 (상여가 0인 사람은 상여가 없는 것으로 간주)

SELECT *
FROM emp
WHERE comm IS NOT NULL 
    AND comm != 0
    ORDER BY comm DESC, empno DESC;
    
데이터 정렬(ORDER BY 실습 orderby3)
-- emp 테이블에서 관리자가 있는 사람들만 조회하고, 직군(job) 순으로 오름차순 정렬하고 직군이 같을 경우 사번이 큰 사원이 먼저 조회되도록 쿼리를 작성하세요

SELECT *
FROM emp
WHERE mgr IS NOT NULL
    ORDER BY job, empno DESC;
    
데이터정렬 (ORDER BY 실습 orderby4)
--emp 테이블에서 10번 부서(deptno) 혹은 30번 부서에 속하는 사람중 급여(sal)가 1500이 넘는 사람들만 조회하고 이름으로 내림차순 정렬 되도록 쿼리를 작성하세요

SELECT *
FROM emp
WHERE deptno = 10
    OR deptno = 30
    AND sal > 1500
    ORDER BY ename DESC; -- 오답
    
SELECT *
FROM emp
WHERE deptno IN (10,30)
    AND sal > 1500
    ORDER BY ename DESC;
 
페이징 처리 : 전체 데이터를 조회하는게 아니라 페이지 사리즈가 정해졌을 때 원하는 페이지의 데이터만 가져오는 방법
(1. 400건을 다 조회하고 필요한 20것만 사용하는 방법 ==> 전체조회(400)
    2. 400건의 데이터중 원하는 페이지의 20건만 조회 ==> 페이징 처리(20)
페이징 처리(게시글) ==> 정렬의 기준이 무엇인가 (일반적으로는 게시글의 작성일시 역순)
페이징 처리시 고려할 변수 : 페이지 번호, 페이지 사이즈

ROWNUM : 행번호를 부여하는 특수 키워드 (오라클에서만 제공)
    *제약사항
    ROWNUM은 WHERE 절에서도 사용 가능하다.
        단 ROWNUM 사용을 1부터 사용하는 경우에만 사용 가능
        WHERE ROWNUM BETWEEN 1 AND 5 ==> O
        WHERE ROWNUM BETWEEN 6 AND 10 ==> X
        WHERE ROWNUM = 1; ==> O
        WHERE ROWNUM = 2; ==> X
        WHERE ROWNUM <[=] 10; ==> O
        WHERE ROWNUM >[=] 10; ==> X
        
        SQL 절은 다음의 순서로 실행된다.
        FROM ==> WHERE ==> SELECT ==> ORDER BY
        ORDER BY와 ROWNUM을 동시에 사용하면 정렬된 기준으로 ROWNUM이 부여되지 않는다
        (SELECT 절이 먼저 실행되므로 ROWNUM이 부여된 상태에서 ORDER BY 절에 의해 정렬이 된다)
        
전체 데이터 : 14건
페이지사이즈 : 5건
1번 페이지 : 1~5
2번 페이지 : 6~10
3번 페이지 : 11~15(14)

인라인 뷰 -- 실행순서로 인해 인라인 뷰를 사용해야한다.
ALIAS

데이터 정렬
-- 

SELECT ROWNUM, empno, ename -- 오라클에서만 제공하는 특수 키워드
FROM emp
WHERE ROWNUM BETWEEN 11 AND 15;

SELECT ROWNUM, empno, ename -- 오라클에서만 제공하는 특수 키워드
FROM emp
WHERE ROWNUM > 15;

FROM ==> SELECT -- 실행순서
SELECT ROWNUM, empno, ename -- ROWNUM이 먼저 실행되고 ORDER BY가 적용되었기 때문
FROM emp
ORDER BY ename;

SELECT deptno -- 에러가 난다
FROM (SELECT empno, ename -- ()로 묶으면 테이블이라고 인식한다 ==> FROM절에 올수 있다 ==> 인라인뷰로 만든 상태 ==> 뷰라는 것은 SELECT 쿼리이다.
FROM emp); -- emp테이블에서 2개의 컬럼만 존재를 한다

SELECT*
FROM
(SELECT ROWNUM, empno, ename -- SQL의 실행순서
FROM (SELECT empno, ename  
        FROM emp
        ORDER BY ename));
WHERE ROWNUM BETWEEN 1 AND 10        

SELECT *
FROM
(SELECT ROWNUM rn, empno, ename -- alias 적용해서 WHERE절의 이름을 확실히 한다
FROM (SELECT empno, ename  
        FROM emp
        ORDER BY ename))
WHERE rn BETWEEN (:page-1)*:pageSize + 1 AND :page*:pageSize; -- 앞에 (:)콜론을 붙여주면 변수가 된다 -- 숫자를 입력안하고 공백이있으면 문자열로 에러가남
-- 바인딩 변수라고 한다
        
        
WHERE rn BETWEEN 11 AND 15 -- 페이지 처리 기본



SELECT *
FROM
(SELECT ROWNUM jb, job, sal
FROM (SELECT job, sal
        FROM emp
        ORDER BY job))
WHERE jb BETWEEN 8 AND 15; -- 연습

SELECT *
FROM
(SELECT ROWNUM dep, hiredate, deptno
FROM(SELECT hiredate, deptno
        FROM emp
        ORDER BY hiredate))
WHERE dep BETWEEN 1 AND 5; -- 연습

--셀렉트절이 오더바이보다 빠르게 실행이 되서 정렬이 안되느 인라인뷰를 적용 ==> 별칭을 지정해 주지 않으면 왜어 절에서 로우넘을 사용할 수가없으므로 셀렉트 절을 인라인뷰 적용 ==> 로우넘에 아리아스 넣어줘서 별칭으로 웨어절에서 적용
        
pageSize : 5건
1. page : dep BETWEEN 1 AND 5
2. page : dep BETWEEN 6 AND 10
3. page : dep BETWEEN 11 AND 15
n. page : dep BETWEEN n*pageSize-4 AND n*pageSize
                        (n-1)*pageSize + 1

rn BETWEEN (page-1)*pageSize + 1 AND page*pageSize; == 페이지값의 공식

n*pageSize-(pageSize -1)
n*pageSize-pageSize + 1

데이터 정렬 (가상컬럼 ROWNUM 실습 row_1)
-- emp테이블엣 ROWNUM값이 1~10인 값만 조회하는 쿼리를 작성해보세요 (정렬없지 진행하세요, 결과는 화면과 다를수 있습니다.)

SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

데이터 정렬 (가상컬럼 ROWNUM 실습 row_2)

SELECT * 
FROM(SELECT ROWNUM rn, empno, ename
FROM emp)
WHERE rn BETWEEN 11 AND 14;

데이터 정렬 (가상컬럼 ROWNUM 실습 row_3)
--emp 테이블의 사원 정보를 이름컬럼으로 오름차순 적용 했을 때의 11~14번째 행을 다음과 같이 조회하는 쿼리를 작상해보세요

SELECT *
FROM
(SELECT ROWNUM rn, empno, ename
FROM
(SELECT ROWNUM rn, empno, ename
FROM emp
ORDER BY ename))
WHERE rn BETWEEN 11 AND 14;

데이터 정렬 (가상컬럼 ROWNUM) -- 먼 미래의 이야기

ROWNUM 용도
    페이징 처리(row_1~3)
    다른 행과 구분되는 유일한 가상의 컬럼 생성 활용
    튜닝시 ==> 인라인뷰 안에서 로우넘 사용시 뷰멀징이 일어나지 않는다.
    
SELECT ROWNUM, emp.* -- 에러가 난다 오라클의 문법, 아스테리스가 어디에서 오는지 정해줘야된다 // 한정자라고 이야기한다. // 아스테리스에 한정자를 붙여야 된다.
FROM emp;

SELECT ROWNUM rn, e.* -- 테이블에도 알리아스를 줄 수가 있다 -- emp가 e로 바뀌었기 때문에 아스테리스도 바꿔줘야된다, 조인을 배울때 테이블에 이름이 같은게 올수가있으므로 알리아스로 구분을 지어준다.
FROM emp e;

SELECT ROWNUM rn, e.empno
FROM emp e, emp m, dept;

SELECT a.*
FROM
(SELECT ROWNUM rn, empno, ename
FROM
(SELECT ROWNUM rn, empno, ename
FROM emp
ORDER BY ename)) a
WHERE rn BETWEEN 11 AND 14;  -- 인라인 뷰에도 (테이블) 아스테리스를 쓸 수가있다.


SELECT *
FROM emp

SELECT *
FROM
(SELECT ROWNUM rn, empno, ename -- alias 적용해서 WHERE절의 이름을 확실히 한다
FROM (SELECT empno, ename  
        FROM emp
        ORDER BY ename))
WHERE rn BETWEEN (:page-1)*:pageSize + 1 AND :page*:pageSize; -- 앞에 (:)콜론을 붙여주면 변수가 된다 -- 숫자를 입력안하고 공백이있으면 문자열로 에러가남
-- 바인딩 변수라고 한다

SELECT *
FROM
(SELECT ROWNUM ty, mgr, sal, ename
FROM(SELECT mgr, sal, ename
    FROM emp
    ORDER BY mgr))
WHERE ty BETWEEN (:page-1) * :pageSize + 1 AND :page * :pageSize;

SELECT *
FROM
(SELECT ROWNUM qw, job, hiredate
FROM(SELECT job, hiredate
    FROM emp
    ORDER BY job DESC))
WHERE qw BETWEEN (:page-1) * :pageSize + 1 AND :page * :pageSize;

SELECT *
FROM
(SELECT ROWNUM km, empno, job, mgr
    FROM(SELECT empno, job, mgr
     FROM emp
     Order by job DESC))
WHERE km BETWEEN (:page-1) * :pageSize + 1 AND :page * :pageSize;

