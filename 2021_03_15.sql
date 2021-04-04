2021-03-12 복습
조건에 맞는 데이터 조회 : WHERE 절 - ;

--row : 14개, col : 8개

SELECT *
FROM emp
WHERE 1 = 1;

SELECT *
FROM emp
WHERE deptno = 30;

SELECT *
FROM emp
WHERE deptno = deptno;  -- 14건이 나옴 1=1과 같다

SELECT *
FROM emp
WHERE deptno != deptno; -- 항상 거짓이다
WHERE 1 != 1

int a = 20; --숫자는 그냥 숫자로 표기한다.
String a = "20" -- 자바에서는 ""로 문자를 표기
'20'; -- sql에서는 ''(싱글)로 표기

SELECT 'SELECT * FROM' || table_name || ';' --''(싱글)을 잘 써야함
FROM user_tables;

-- 데드락 == 서버 사용시 서로 작업을 할때 서로의 자원을 사용하는데 기다리는 현상 ==> 이런 상황이 발생하지 않게 DB관리하는 사람이 잘 짜야함 == 락을 제거하는 방법을 분류형식으로 할 수 있다.

SELECT 'SELECT * FROM' + table_name + ';' -- 자바에서는 ||가 +가 된다.
FROM user_tables;

-- 날짜 == 환경설정 ==> 데이터베이스에서 포맷대로 써야함

'81/03/01' -- 국가마다 날짜를 표기하는 표시가 달라진다
-- 문자를 날짜로 바꿔주는 함수의 사용방법을 알았다.

TO_DATE('81/03/01', 'YY/MM/DD'); -- 컴퓨터는 알맞는 명령을 지정해줘야 잘 적용한다.

-- WORKING AREA ==> STAGING AREA ==> LOCAL REPOSITORY ==> REMOTE REPOSITORY
--(                       GIT                          )    (      GITHUB      )
--             ADD              COMMIT                 PUSH

--입사일자가 1982년 1월 1일 이후인 모든 직원 조회 하는 SELECT 쿼리를 작성하세요
SELECT *
FROM emp;

SELECT 'SELECT * FROM' || hiredate ||';'
FROM emp
WHERE hiredate >= '82/01/01' ;

-- 30 > 20 == 숫자 > 숫자
-- 날짜 > 날짜 == 2021-03-15 > 2021-03-12

--정답
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');
WHERE hiredate >= TO_DATE('1982-01-01', 'YYYY-MM-DD')
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD')

-- YY !== YYYY ==> YY는 앞자리 2자리가 서버 날짜의 녀도 앞 두자리를 사용하므로 YYYY로 확실하게 표현하는게 좋다
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('820101', 'YYMMDD'); -- X

-- WHERE절에서 사용 가능한 연산자
--(비교 ( =, !=, >, < ....) ==> 연산자를 사용할때 몇항 연산자인지 생각하면서 쓰는것이 좋다
-- + ==> 2개의 항이 필요한 2항 연산자라고 부른다 ex) a + b; 피연산자 연산자 피연산자
-- a++ ==> a = a + 1;
-- ++a ==> a = a + 1; ==> 단항 연산자
 
-- BETWEEN AND ==> 3항 연산자

SELECT *
FROM emp
WHERE >= TO_DATE('820101', 'YYMMDD'); -- >= 50 2항 연산자인데 1항만써서 정의에 안 맞는 상황

SELECT *
FROM emp
WHERE TO_DATE('820101', 'YYMMDD') =< hiredate ; -- 가능

-- 비교대상 BETWEEN 비교대상의 허용 시작값 AND 비교대상의 허용 종료값
ex : 부서번호가 10번에서 20번 사이의 속한 직원들만 조회
    10, 11, 12......20

SELECT *
FROM emp
WHERE deptno BETWEEN 10 AND 20;

emp 테이블에서 급여(sal)가 1000보다 크거나 같고 2000보다 작거나 같은 직원들만 조회
-- sal >= 1000 AND
-- sal <= 2000
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000; -- 3항 연산자이다

SELECT *
FROM emp
WHERE sal >= 1000
AND sal <= 2000
AND deptno = 10;

true AND true ==> true -- 결과는 참이다
true AND true ==> false -- 둘다 참이면 참이다 하나라도 아니면 아니다

true OR false ==> true

-- 조건에 맞는 데이터 조회하기(BETWEEN AND 실습 where1)
-- emp 테이블에서 입사 일자가 1982년 1월 1일 이후 부터 1983년 1월 1일 이전인 사원의 ename, hiredate 데이터를 조회하는 쿼리를 작성하시오 단 연산자는 between을 사용한다

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01', 'YYYY/MM/DD') AND TO_DATE('1983/01/01', 'YYYY/MM/DD');

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD') 
AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

BETWEEN AND : 포함(이상, 이하)
            초과, 미만의 개념을 적용하려면 비교연산자를 사용해야 한다.
            
IN 연산자
대상자 IN (대상자와 비교할 값1, 대상자와 비교할 값2, 대상자와 비교할 값3....)
deptno IN (10, 20) ==> deptno 값이 10이나 20번이면 TRUE;

SELECT *
FROM emp
WHERE deptno IN (10, 20);

SELECT *
FROM emp
WHERE deptno = 10
OR deptno = 20;

SELECT *
FROM emp
WHERE 10 IN (10, 20); -- 10은 10과 같거나 20과 같다 ==> TRUE OR FALSE ==> TRUE

-- 조건에 맞는 데이터 조회하기 (IN 실습 where3)
-- users 테이블에서 userid가 brown, cony, sally인 데이터를 다음과 같이 조회 하시오(IN 연산자 사용)

SELECT userid AS 아이디, usernm AS 이름, alias AS 별명 -- as 뒤에 별칭을 써준다 (결과값 수정 가능)
FROM users
WHERE userid IN ('brown', 'cony', 'sally'); -- 유저 아이디를 대문자로 입력하면 값이 틀리게 된다.

--userid = 'brown' 이거나 userid = 'cony' 이거나 userid 'sally'

WHERE userid = 'brown'
OR userid = 'cony'
OR userid = 'sally'

SELECT *
FROM users; -- 세미콜롬이 잘못 찍힘
WHERE userid = 'brown'; 

-- IN은 2항 연산자다.

LIKE 연산자 : 문자열 매칭 조회 -- ~~와 유사하다
게시글 : 제목 검색, 내용 검색 == 제목에 [맥북에어]가 들어가는 게시글만 조회

ex) 1. 얼마 안된 맥북에어 팔아요
2. 맥북에어 팔아요
3. 팝니다 맥북에어

-- 테이블 : 게시글
-- 제목 컬럼 : 제목
-- 내용 컬럼 : 내용

SELECT *
FROM 게시글
WHERE 제목 LIKE '%맥북에어%'
or 내용 LIKE '%맥북에어%' -- 제목 또는 내용에 [맥북에어]라는 단어가 있는지

제목  내용
1       2 
TRUE or   TRUE     TRUE
TRUE or   FALSE   TRUE
FALSE or   TRUE   TRUE
FALSE or   FALSE   FALSE

제목  내용
1       2 
TRUE and   TRUE     TRUE
TRUE and  FALSE   FALSE
FALSE and   TRUE   FALSE
FALSE and  FALSE   FALSE

% : 0개 이상의 문자
_ : 1개의 문자

c%
--맨 첫글자 c로 시작하는 것을 보고싶다
SELECT *
FROM users
WHERE userid LIKE 'c%'; -- LIKE는 2항 연산자이다. 패턴을 지정하는 형태

--userid가 c로 시작하면서 c이후에 3개의 글자가 오는 사용자
SELECT *
FROM users
WHERE userid LIKE 'c___';

--userid에 l이 들어가는 모든 사용자 조회
-- '%l%' ==> 앞뒤로 있을수도 있고 없을수도 있는 상태 ==> 0개이상의문자l0개이상의문자
SELECT *
FROM users
WHERE userid LIKE '%l%';

-- 조건에 맞는 데이터 조회하기 (LIKE, %, _, 실습 where4)
-- member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오

-- mem_name의 첫글자가 신이고 뒤에는 뭐가 와도 상관없다

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

-- 조건에 맞는 데이터 조회하기 (LIKE, %, _ 실습 where5)
-- member 테이블에서 회원의 이름에 글자[이]가 들어가는 모든 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

IS (NULL 비교)
emp 테이블에서 comm 컬럼의 값이 NULL인 사람만 조회

SELECT *
FROM emp
WHERE comm IS NOT NULL; -- NULL은 IS를 사용해야하는데 NOT을 붙여 부정할수 있다 == 0은 NULL과 다르다
        sal = 1000
        sal != 1000
        
emp 테이블에서 매니저가 없는 직원만 조회

SELECT *
FROM emp
WHERE mgr IS NULL;

BETWEEN AND, IN, LIKE, IS

논리연산자 : AND, OR, NOT
AND : 두가지 조건을 동시에 만족시키는지 확인할 때
    조건1 AND 조건2
OR : 두가지 조건중 하나라도 만족 시키는지 확인할 때
    조건1 OR 조건2
NOT : 부정형 논리연산자, 특정 조건을 부정
    mgr IS NULL : mgr 컬럼의 값이 NULL이 아닌 사람만 조회
    
emp 테이블에서 mgr의 사번이 7698이면서 sal값이 1000보다 큰 직원만 조회

--조건의 순서는 결과와 무관하다
SELECT *
FROM emp
WHERE mgr = 7698 AND sal > 1000; -- 순서의 관련이 없다 (집합)

-- sal 컬럼의 값이 1000보다 크거나 mgr의 사번이 7698인 직원조회 
SELECT *
FROM emp
WHERE mgr = 7698 or sal > 1000;

AND 조건이 많아지면 : 조회되는 데이터 건수는 줄어든다
OR 조건이 많아지면 : 조회되는 데이터 건수는 많아진다

NOT : 부정형 연산자, 다른 연산자와 결합하여 쓰인다
    IS NOT, NOT IN, NOT LIKE
    
--직원의 부서번호가 30번이 아닌 직원들
SELECT *
FROM emp
WHERE depto NOT IN (30);

SELECT *
FROM emp
WHERE depto != 30; -- 위와 같은 내용

SELECT *
FROM emp
WHERE ename NOT LIKE 'S%';

NOT IN 연산자 사용시 주의점 : 비교값중에 NULL이 포함되면 데이터가 조회되지 않는다

SELECT *
FROM emp
WHERE mgr IN (7698, 7839, NULL); -- 널이 안나옴 == IN연산자는 OR과 동일하다

==> mgr = 7698 OR mgr = 7839 OR mgr = NULL -- NULL을 인식못함

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL); -- 데이터가 안나온다 == 이면서의 값을 가진다 AND

==> !(mgr = 7698 OR mgr = 7839 OR mgr = NULL)
==> mgr !=7698 AND mgr !=7839 AND mgr != NULL -- NULL은 무조건 FALSE
TRUE FALSE 의미가 없음 AND FALSE 이기 때문에

mgr = 7698 ==> mgr != 7698
OR         ==> AND

SELECT *
FROM emp
WHERE mgr IN (SELECT deptno FROM dept);

-- IN연산자 , NOT IN연산자는 해석을 잘 생각해야한다.

--논리연산 (AND OR 실습 where7)
--emp 테이블에서 job이 SALESMAN 이고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요

SELECT *
FROM emp
WHERE JOB = 'SALESMAN' AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD'); -- 틀렸으므로 잘 숙지하기

--논리연산 (AND, OR, 실습 where8)
--emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회 하세요.

SELECT *
FROM emp
WHERE deptno != 10 AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD'); -- depno NOT IN (10) NOT IN으로 치환한다면

SELECT *
FROM emp
WHERE JOB LIKE 'SALESMAN'; -- job = 'SALESMAN'으로 해석한다

-- 쿼리 트랜스폼 형식이 나름대로 프로그램이 변환을 한다.

--논리연산 (AND, OR 실습 where10)
--emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요(부서는 10 20 30 만 있다고 가정하고 IN 연산자를 사용)

SELECT *
FROM emp
WHERE deptno IN (20, 30) AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD'); -- deptno NOT IN (10)

--논리연산 (AND, OR 실습 where11)
--emp 테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회 하세요.

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

WHERE 12] 풀면 좋고, 못풀어도 괜찮은 문제
--논리연산 (AND, OR 실습 where12)
--emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회 하세요

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE ('78%'); -- empno는 숫자를 사용하는데 문자열로 사용함
-- 숫자열로된 문자열이고 자동으로 형변환이 된 것이다.

--논리연산 (AND, OR 실습 where13) -- 데이터타입에 대한 고민 , empno 최대의 값이 얼마인가, 풀면 좋고, 못풀어도 괜찮은 문제 -- 과제
--논리연산 (AND, OR 실습 where13)
--emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회 하세요 (LIKE 연산자 사용 금지)

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno BETWEEN 7800 AND 7899; -- 오답 (이러면 두자리의 78과 세자리의 780을 조회할수가없다.)

SELECT *
FROM emp
WHERE job = 'SALESMAN' 
    OR empno BETWEEN 7800 AND 7899
    OR empno BETWEEN 780 AND 789
    OR empno = 78; -- 정답









