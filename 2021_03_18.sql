ROUND 
    년원일엥서도 반올림이 가능하다
    자주쓰이는건아닌다
TRUNC
    내림
    ㅇ위와 같다

/*    
날짜 관련 함수

MONTHS_BETWEEN : DATE 타입의 인자가 2개 들어간다 / start date, end date, 반환값 : 두 일자 사이의 개월수
--- 이놈은 숫자를 반환 / 잘안씀
--- 아래는 date 반환
ADD_MONTHS : 몇달뒤 몇일인가  ****
인자 : date, number 더할 개월수  == date뒤 부터 x개월 뒤의 날짜

date + 90 : 일수를 구할 수 있다.
1/15뒤 3개월 뒤 날짜 / 90일수도 잇꼬 아닐수도 있따.
그러니까 add먼뜨로 구하자

NEXT_DAY =   ***
인자 : date, number(weekday, 주간일자) == date이후의 가장 첫번째 주간일자에 해당하는 date를 반환
일요일 1 월 2 ~ 토 7
LAST_DAY  ***
인자 : date == date가 속한 월의 마지막 일자를 date로 반환

*/


-- 잘안쓰이지만 알아는 둬라
MONTHS_BETWEEN
SELECT ename, TO_CHAR(hiredate, 'yyyy/mm/dd HH24:mi:ss') hiredate,
        MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
        ADD_MONTHS(SYSDATE, 5) ADD_MONTHS,
        ADD_MONTHS(TO_DATE('2021-02-15', 'YYYY-MM-DD'), 5) ADD_MONTHS2,
        NEXT_DAY(SYSDATE, 1) NEXT_DAY,
        LAST_DAY(SYSDATE) LAST_DAY,
        TO_DATE(TO_CHAR(SYSDATE, 'YYYYMM') || '01', 'YYYY-MM-DD')FIRST_DAY
FROM EMP;

/*    
-- SYSDATE 이용 현대 월의 첫날구하기
-- SYSTDE 년원까지 문자 + || '01'
202103 || 01 --> 20210301
*/

-- 문제 파라미터 YYYYMM혁싱 문자사용 해당년월 ㅁ 마지막일자 구하시오 LAST_DAY(날짜)사용할라면 문자로 바꿔여ㅑ한다
SELECT :YYYYMM, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD')
FROM DUAL;
-- 원하는 값을 넣기위해 날짜를 문자로 바꾸고
-- 라스트데이로  마지막 일자를 뽑고
-- 투캐릭터로 원하는 포맷을 뽑는다.
-- 두번쨰값은 3월넣으며 31

SELECT :YYYYMM, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'MMDD')
FROM DUAL;
/*8
형변환(숫자 문자 날짜)
- 명시적 형변환
    - TO_DATE, TO_CHAR, TO_NUMBER
- 묵시적 형변환
    - 
 
 */
    
SELECT *
FROM EMP
WHERE empno = '7369';


-- NUMBER
    9 숫자 - 값을 모르면 많이넣느다
    0 강제로 0
    , 1000자리
    . 소수점 
    w 화페단위
    $ 달러표시
-- 잘 안쓴따


NULL 처리 함수 : 4가지
1. NVL(ecpr1(컬럼도 가능), expt2) // 1이 null값이 아니면 1쓰고, 1이 null값이면 2쓴다
자바 :  if(expr1 == null)
        sysout(expr2)
        else
        sysout(expr1)

-- emp테이블에서 comm컬럼의 값이 null일경우 0으로 대채해서 조회
SELECT empno, comm, NVL(comm, 1),
        NVL(sal+comm, 0), sal + nvl(comm,0)
FROM EMP;




emp 테이블에서 comm 컬럼의 값이 NULL일 경우 0으로 대체해서 조회하기

SELECT empno, sal, comm,
    sal + NVL(comm, 0) nvl_sal_comm,
    NVL(sal+comm, 0) nvl_sal_comm2
FROM emp;

NVL2(expr1, expr2, expr3)
if(expr1 != null
    System.out.println(expr2);
else
    System.out.println(expr3);
    
comm이 null이 아니면 sal+comm을 반환,
comm이 null 이면 sal을 반환

SELECT empno, sal, comm,
        NVL2(comm, sal+comm, sal),
        sal + NVL(comm, 0)
FROM emp;

NULLIF(expr1, expr2) == 인자가 2개이다 , 잘 안쓴다.
if(expr1 == expr2)
    System.out.println(null)
else
    System.out.println(expr1)
    
SELECT empno, sal, NULLIF(sal, 1250) -- NULL은 만들면 문제가 있는 녀석이라 일부러 문드는 NULLIF를 잘 사용하진 않는다.
FROM emp;

COALESCE (expr1, expr2, expr3....)-- 가변인자(인자의 갯수가 정해져있지 않다)
인자들 중에 가장먼저 등장하는 null이 아닌 인자를 반환
if(expr1 != null)
    System.out.println(expr1);
else
    COALESCE(expr2, expr3 ....);
    
if(expr2 != null)
    System.out.println(expr2);
else
    COALESCE(expr3 ....); 

-- 재기 함수 ==> 자신이 자기를 호출하는 함수

SELECT empno, sal, comm, COALESCE()
FORM emp;

--null 실습 fn4

emp테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요 (nv1, nv2, coalesce)

SELECT empno, ename, mgr,
        NVL(mgr, 9999) mgr_n, -- 매니저 값이 null일때 9999로 바꿔라
        NVL2(mgr, mgr, 9999) mgr_n_1,
        COALESCE(mgr, 9999) mgr_n_2
FROM emp;

--null 실습 fn5
users 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요 reg_dt가 null일 경우 sysdate를 적용

SELECT userid, usernm, reg_dt,
        NVL(reg_dt, sysdate) n_reg_dt       
FROM users
WHERE userid IN ('cony', 'sally', 'james', 'moon');

조건분기
1. CASE 절 -- 자바 if와 비슷
    CASE expr1 비교식(참거짓을 판단 할 수 있는 수식) THEN 사용할 값 ==> if
    CASE expr2 비교식(참거짓을 판단 할 수 있는 수식) THEN 사용할 값2 ==> else if
    CASE expr3 비교식(참거짓을 판단 할 수 있는 수식) THEN 사용할 값3 ==> else if
    ELSE 사용할 값4 ==> else
    END
    
2. DECODE 함수 ==> COALESCE 함수 처럼 가변인자 사용 -- 사용할 수 있는 사례가 한정적이다
    DECODE(expr1, search1, return1, search2, return2, search3, return3, ...[,default]
    
    DECODE(expr1,
                search1, return1,
                search2, return2,
                search3, return3,
                ...[,default]
    
if(expr1 == search1) -- 대소비교가 아니라 무조건 동등이다.
    System.out.println(return1)
else if(expr1 == search2)
    System.out.println(return2)
else if(expr1 == search3)
    System.out.println(return3)
else
    System.out.println(default)
    



if()
else if
else if
.
.
.
else

직원들의 급여를 인상하려고 한다.
job이 SALESMAN이면 현재 급여에서 5%를 인상
job이 MANAGER이면 현재 급여에서 10%를 인상
job이 PRESIDENT이면 현재 급여에서 20%를 인상
그 이외의 직군은 현재 급여를 유지

SELECT ename, job, sal,
        CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal * 1.0
        END sal_bonus
FROM emp; -- 자바에서는 == , sql에서는 =

SELECT ename, job, sal,
        CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal * 1.0
        END sal_bonus,
        DECODE(job, 
                'SALESMAN', sal * 1.05,
                'MANAGER', sal * 1.10,
                'PRESIDENT', sal * 1.20,
                sal * 1.0) sal_bonus_decode
FROM emp; -- 자바에서는 == , sql에서는 =

실습 cond1
-- emp 테이블을 이용하여 deptno에 따라 부서명으로 변경해서 다음과 같이 조회되는 쿼리를 작성하세요

SELECT empno, ename, deptno,
        CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END dname,
        DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') dname1
FROM emp;

실습 cond2
--emp 테이블을 이용하여 hiredate에 따라 올해 건강보험 검진 대상자 인지 조회하는 쿼리를 작성하세요. (생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다.)

SELECT empno, ename, hiredate,
        CASE
            WHEN
                MOD(TO_CHAR(hiredate, 'yyyy'), 2) = -- 짝수 홀수 나타낼때는 MOD연산을 하면 편리하다
                MOD(TO_CHAR(SYSDATE, 'yyyy'), 2) THEN '건강검진 대상자'
            ELSE '건강검진 비대상자'
        END CONTACT_TO_DOCTOR
        DECODE( MOD(TO_CHAR(hiredate, 'yyyy'), 2), MOD(TO_CHAR(SYSDATE, 'yyyy'), 2) '건강검진 대상자'
FROM emp;

SELECT empno, ename, hiredate,
        CASE
            WHEN
                MOD(TO_CHAR(hiredate, 'yyyy'), 2) = MOD(TO_CHAR(SYSDATE, 'yyyy'), 2) THEN '대상자'
                ELSE '비대상자'
        END CTD
FROM emp;

실습 cond3

--users 테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진 대상자 인지 조회하는 쿼리를 작성하세요.(생년을 기준으로 하나 여기서는 reg_dt를 기준으로 한다)

SELECT userid, usernm, reg_dt,
        CASE
            WHEN
            MOD(TO_CHAR(reg_dt, 'yyyy'), 2) = MOD(TO_CHAR(SYSDATE, 'yyyy'), 2) THEN '건강검진 대상자'
            ELSE '건강검진 비대상자'
        END contact_to_doctor
FROM users
WHERE userid IN ('brown', 'cony', 'sally', 'james', 'moon');
-- 조건분기 끝

GROUP FUNCTION -- 그룹함수 : 여러행을 그룹으로 하여 하나의 행으로 결과값을 반환하는 함수

ex) 부서별 직원수, 부서별 가장높은급여, 부서별 급여평균
그룹핑 기준이 가장 중요하다 -- 어떤 기준으로 할것인가

그룹함수
AVG : 평균
COUNT : 건수
MAX : 최대값
MIN : 최소값
SUM : 합

-왜어절 다음이 그룹바이이다

SELECT *
FROM emp;

-- GROUP BY 절에 나온 컬럼이 SELECT절에 그룹함수가 적용되지 않은채로 기술되면 에러 ==> 그룹바이에 컬림을 추가한다 ==> 그룹핑을 해도 자기밖에 안된다(empno) ==> 그룹함수로 지정을 해준다
SELECT deptno, MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno; -- 핵심 기준
-- 10,5000 ==> 20, 3000 ==> 30, 2850 순서가 뒤밖일수도 있다
-- 카운트 ==> 그룹핑된 행중에 sal컬럼의 값이 NULL이 아닌 행의 건수 ==> null이 빠진다 ==> 카운트 *은 그룹핑된 행 건수이다.

SELECT *
FROM emp;


--GROUP BY를 사용하지 않을 경우 테이블의 모든 행을 하나의 행으로 그룹핑한다.
SELECT MAX(deptno), COUNT(*), MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal)
FROM emp
GROUP BY deptno;

SELECT deptno, 'TEST', 100,  MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*),-- 문자는 문제가 없다
        SUM(comm), -- NVL 널처리를 안해도 된다.
        SUM (NVL(comm)),
        NVL (SUM(comm)m 0) -- 이 상황에서는 이게 가장 좋은 선택지이다
FROM emp
--WHERE LOWER(ename) = 'smith' -- 행을 제한하는 기준은 웨어절에 작성한다.
GROUP BY deptno; -- 핵심 기준 
HAVING COUNT(*) >=4;
-- null값을제외하고 진행 ==> null값을 포함한한 값은 null이 된다
-- 그룹함수의 조건은 웨어절이아니라 그룹바이 그룹 사이 해빙절에 해야한다.

그룹함수
-- 그룹함수에서 null 컬럼은 계산에서 제외된다
-- group by절에 작성된 컬럼 이외의 컬럼이 select 절에 올 수 없다
-- where절에 그룹함수를 조건으로 사용할 수 없다.
    --having 절 사용
        where sum(sal)>3000(X)
        having sum(sal)>3000(O)

그룹함수 실습 grp1
emp 테이블을 이용하여 다음을 구하시오
직원중 가낭 높은 급여
직원중 가장 낮은 급여
직원의 급여 평균(소수점 두자리까지 나오도록 반올림)
직원의 급여 합
직원중 급여가 있는 직원의 수(null 제외)
직원중 상급자가 있는 직원의 수 (null 제외)
전체 직원의 수

SELECT MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp;

grp2 그룹함수 실습
emp테이블을 이용하여 다음을 구하시오

SELECT deptno, MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno; 








