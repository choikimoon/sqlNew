WHERE 조건1 : 10건

WHERE 조건1
    AND 조건2 : 10건을 넘을수 없음
    
WHERE depno = 10
    AND sal > 500
    
AND : 넣으면 넣을수록 행의 조건이 줄어든다
OR : 넣으면 넣을수록 행의 조건이 늘어난다

자바 프레임워크에서는 :(콜론)이 #{}(샵중괄호)로 바뀐다

ROWNUM 유의점
--where절에서도 사용 가능하다.
--select절 이후에 order by가 실행이 된다.
--order by결과를 반영하려면 inline view를 사용한다.
--## 트랜잭션, NOT IN, 페이징 처리 == 시험에 낸다.

Function
-- Sungle row function
단일행을 기준으로 작업하고, 행당 하나의 결과를 반환
특정 컬럼의 문자열 길이 : length(ename)

Multi row function
여러행을 기준으로 작업하고, 하나의 결과를 반환
그룹함수 : count, sum, avg

##자바에서는 함수를 == 메서드라고 한다.== 메인메서드
##메서드를 함수로 빼두면 ==> 내용 수정이 용이하다 ==> 메서드를 사용하고싶은사람에게 제어권을 준다 ==> 코드를 분리하면 유지보수하는데 도움이 된다
##반환값을 돌려주는것

함수명을 보고
1. 파라미터가 어떤게 들어갈까?
2. 몇개의 파라미터가 들어갈까?
3. 반환되는 값은 무엇일까?
//대입되는 값 == 인자 == 파라미터라고 한다

character
대소문자
LOWER == 입력되는 값 반환되는 값 문자 == 소문자로 바꿔줌
UPPER == 대문자
INITCAT == 첫글자를 대문자로 바꿔준다

-- SELECT == 셀렉트에는 * | [column | expression]
SELECT ename, LOWER(ename), UPPER(ename), INITCAP(ename)
FROM emp;
-- LOWER 한 항마다 실행이 된것이다 (스미스 1번 , 알렌 1번 와드 1번 ....)

SELECT ename, LOWER(ename), LOWER('TEST') -- 문자열 리터럴(상수)
FROM emp;

문자열 조작
CONCAT == 연결한다(연쇄) == 문자열이 2개 반화되는 값은 문자가 결합된 1개
SUBSTR == 문자열에서 빼내는 것 == 인자는 3개지만 2개만 쓸수도있다 == 몇자리에서 몇자리까지
LENGTH == 특정 문자열에 들어가서 길이를 반환해주는 함수
INSTR == 특정 문자열에 검색하고 싶은 문자열이 있는지 알려주는 함수
LPAD | RPAD == 왼쪽 오른쪽 넣고 싶은 것 넣는 함수
TRIM == 문자열의 시작 종료 부분 공백 함수
REPLACE == 문자열의 특정 문자열을 내가 원하는 문자열로 치환을 하는 것 (인자 3개 대상문자열 바꿀문자열 치환문자열)

SELECT ename, LOWER(ename), LOWER('TEST'),
        SUBSTR(ename, 1 , 3),
        SUBSTR(ename, 2),
        REPLACE(ename, 'S', 'T')
FROM emp;

DUAL table
sys 계정에 있는 테이블
누구나 사용 가능
DUMMY 컬럼 하나만 존재하며 값은 X이며 데이터는  한 행만 존재

사용용도
    데이터와 관련 없이
        함수 실행
        시퀀스 실행
    merge 문에서 -- 인설트 업데이트 합쳐서 부른다
    데이터 복제시(connect by level) ==> 1건을 더 늘려서 복제할수있다
    
SELECT *
FROM dual; -- 함수에 대해 테스트 목적으로 많이 사용한다

SELECT LOWER('TEST') -- 14건이 나오는것 행의 건수의 영향을주는건 WHERE절이다.
FROM emp;

SELECT LENGTH ('TEST') 
FROM dual; -- 듀얼테이블을 사용하여 불필요한 결과를 줄인다

SINGLE ROW FUNCTION : WHERE 절에서도 사용 가능

emp 테이블에 등록된 직원들 중에 직원의 이름의 길이가 5글자를 초과하는 직원들만 조회
SELECT *
FROM emp
WHERE LENGTH(ename) > 5; 

//

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith'; -- 테이블 컬럼을 가공하지 말아라
// 멀티 함수는 불가능 하다 == 그 이유는 생각해보자


SELECT *
FROM emp
WHERE ename = UPPER('smith');

//둘 중 하나는 권장하지 않는다 == 함수의 실행 횟수 == 첫번째가 아니다 == ename 컬럼에 붙어 14번이 적용되어버림 == 밑은 smith라는 인자에 1번만 되기 때문에 밑이 가장 이상적이다

SQL 칠거지악 == 개발자들이 하지 않아야 할 칠거지악
엔코아 컨설팅
엔코아 ==> 우리나라 1세데 ==> 엔코아 부사장 ==> b2en회사 ==> b2en 대표컨설턴트 : dbian ; == 데이터베이스 컨설턴트

ORACLE 문자열 함수

SELECT 'HELLO' || ',' || 'WORLD',
        CONCAT('HELLO', CONCAT(',' ,'WORLD')) CONCAT,
        SUBSTR('HELLO, WORLD', 1, 5) SUBSTR,
        LENGTH('HELLO, WORLD') LENGTH,
        INSTR('HELLO, WORLD', 'O') INSTR,
        INSTR('HELLO, WORLD', 'O') INSTR2,
        LPAD('HELLO, WORLD', 15, '*') LPAD,
        RPAD('HELLO, WORLD', 15, '*') RPAD,
        REPLACE('HELLO, WORLD', 'o', 'x') REPLACE,
        TRIM('  HELLO, WORLD    ') TRIM, -- 공백을 제거, 문자열의 앞과 뒷부분에 있는 공백만 제거한다. (문자열 가운데에 있는 공백은 건들지 않는다)
        TRIM('D' FROM 'HELLO, WORLD') TRIM -- 공백 대신 제거할 문자열을 넣을 수 있다 (D를 제거한 상태)
FROM dual;

--외울려하지말자 프로그램마다 출력되는것을 보고 이해하고 생각하자


숫자 함수 (number)
    숫자 조작
    ROUND == 반올림 == 인자 == 대상 숫자, 몇번째에서 할지 == 2개
    TRUNC == 내림 == 인자 == 대상 숫자, 몇번째 내릴지 == 2개
    MOD == 나눗셈의 나머지 == 인자 == 대상숫자, 나눌 숫자 == 2개
    
    피제수, 제수
    SELECT MOD(10,3) == 피제수(나눔을 당하는 수),제수
    FROM dual;
    
SELECT *
FROM emp
WHERE ename = SMITH; -- 잘못된 상태 == 스미스에 콤마로 문자열을 만들어줘야함

--emp테이블에 있는 컬럼의 이름 (시험)

SELECT
ROUND(105.54, 1) round1,-- 반올림 결과가 소수점 첫번째 자리까지 나오도록 : 둘째자리에서반올림 : 105.5
ROUND(105.55, 1) round2,-- 반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째자리에서 반올림 : 105.6
ROUND(105.54, 0) round3,-- 반올림 결과가 첫번째 자리(일의 자리)까지 나오도록 : 소수점 첫째 자리에서 반올림 : 106
ROUND(105.54, -1) round4 -- 반올림 결과가 두번째 자리(십의 자리)까지 나오도록 : 정수 첫째 자리에서 반올림 : 110
FROM dual;

-- 이클립스 알트 쉬프트 A 세로편집 모드

SELECT
TRUNC(105.54, 1) trunc1,-- 절삭 결과가 소수점 첫번째 자리까지 나오도록 : 둘째자리에서절삭 : 105.5
TRUNC(105.55, 1) trunc2,-- 절삭 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째자리에서 절삭 : 105.5
TRUNC(105.54, 0) trunc3,-- 절삭 결과가 첫번째 자리(일의 자리)까지 나오도록 : 소수점 첫째 자리에서 절삭 : 105
TRUNC(105.54, -1) trunc4, -- 절삭 결과가 두번째 자리(십의 자리)까지 나오도록 : 정수 첫째 자리에서 절삭 : 100
TRUNC(105.55) trun5 -- 두번째 인자가 생각되면 자동으로 0이 된다. (소수점 첫번째 자리에서 반올림 혹은 절삭) 1의 자리 표현
FROM dual;

--ex : 7499, ALLEN, 1600, 1, 600
SELECT empno, ename, sal, sal을 1000으로 나눴을 때의 몫, sal으 1000으로 나눴을 때의 나머지
FROM emp;

SELECT empno, ename, sal, TRUNC(sal/1000), MOD(sal, 1000)
FROM emp;

날짜함수
특수함수를 배우고 문자를 날짜로 바꾸는 방법을 배운다
날짜 <==> 문자를 == 많이 한다 == 
서버의 현재 시간을 잘 구해야된다 : SYSDATE(서버의 현재 시간 날짜를 조회해주는 함수)

LENGTH() -- 오라클에서는 인자가 없는 함수는 괄호를 안쓴다 !== 자바에서는 괄호를 넣는다
SYSDATE -- 오라클에서 제공해주는 함수

SELECT SYSDATE + 1 -- 하루가 추가됨(정수가 일수임
FROM dual; -- 날짜 포맷이 시간이 안되있음 -- 도구 ==> 윈도우 ==> 데이터베이스 ==> NLS ==> YYYY/MM/DD HH24:MI:SS 설정

SELECT SYSDATE, SYSDATE + 1/24 -- 1시간
FROM dual;

SELECT SYSDATE, SYSDATE + 1/24/60 -- 1분
FROM dual;

SELECT SYSDATE, SYSDATE + 1/24/60/60 -- 1초
FROM dual;

--Function (date 실습 fn1)
1. 2019년 12월 31일을 date 형으로 표현
2. 2019년 12월 31일을 date 형으로 표현하고 5일 이전 날짜
3. 현재 날짜
4. 현재 날짜에서 3일 전 값

위 4개 컬럼을 생성하여 다음과 같이 조회하는 쿼리를 작성하세요(PT예시는 현재 날짜가 2019/10/24)

SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY,
        TO_DATE('2019/12/31', 'YYYY/MM/DD') -5 LASTDAY_BEFORE5,
        SYSDATE NOW,
        SYSDATE -3 NOW_BEFORE3
FROM dual;

TO_DATE : 인자-문자, 문자의 형식 -- 날짜를 숫자에 합치거나 할때
TO_CHAR : 인자-날짜, 문자의 형식 -- 날짜를 문자에

-- 개발자가 힘들어 하는거 ##

SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD')
FROM dual;

SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY')
FROM dual;

SELECT SYSDATE, TO_CHAR(SYSDATE, 'MM')
FROM dual;

--1년 == 52주 ~ 53주
-- 0- 일요일, 1-월요일, 2-화요일 ..... 6-토요일 : 주간요일(D)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'IW'), TO_CHAR(SYSDATE, 'D')
FROM dual;

date
    format
        YYYY:4자리년도
        MM:2자리월
        DD:2자리 일자
        D:주간 일자 1~7
        IW:주차(1~53)
        HH,HH12:2자리 시간(12시간표현)
        HH24 : 2자리 시간(24시간표현)
        MI:2자리 분
        SS:2자리 초
        -- 외우기 , 오라클에서는 대소문자가 상관없는데 자바에서는 다르다 (헷갈리면 힘들다)
        
        (date 실습 fn2)
        오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오
        1. 년-월-일
        2. 년-월-일 시간(24)-분-초
        3. 일-월-년
            
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH,
        TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24-MI-SS') DT_DASH_WITH_TIME,
        TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;

TO_DATE(문자열,문자열 포맷)

SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')
FROM dual;

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')
FROM dual;

'2021-03-17' ==> '2021-03-17 12:41:00' ==> 문자를 날짜로 바꾸고 시간을 입력하고 싶을때

SELECT TO_CHAR(TO_DATE('2021-03-17', 'YYYY-MM-DD'), 'YYYY-MM-DD HH24:MI:SS')
FROM dual;

SELECT SYSDATE, TO_DATE(TO_CHAR(SYSDATE-5, 'YYYYMMDD'), 'YYYYMMDD')
FROM dual;

where cs_rcv dt between
    to date(to_char(sysdate-5, 'YYYYMMDD'


        






