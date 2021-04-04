아우터 조인 - 제조업체 월별실적

월별실적

                반도체     핸드폰     냉장고
2021년 1월 :      500       300       400
2021년 2월 :      0           0         0
2021년 3월 :      500       300       400
.
.
.
2021년 12월 :      500       300       400

테이블 : 

아우터조인1]

SELECT buyprod.buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, NVL(buyprod.buy_qty, 0)
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id 
    AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');
-- 아우터 조인으로 널값을 다 보여준다

아우터조인2]

SELECT TO_DATE(:yyyymmdd, 'YYYY/MM/DD'), buyprod.buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, NVL(buyprod.buy_qty, 0)
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id 
    AND buy_date(+) = TO_DATE(:yyyymmdd, 'YYYY/MM/DD');
    
아우터조인3]

SELECT TO_DATE(:yyyymmdd, 'YYYY/MM/DD'), buyprod.buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, NVL(buyprod.buy_qty, 0)
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id 
    AND buy_date(+) = TO_DATE(:yyyymmdd, 'YYYY/MM/DD');

아우터조인4]
cycle,product 테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고, 애음하지 않는 제품도 다음과 같이 조회되도록 쿼리를 작성하세요 (고객은 cid=1인 고객만 나오도록 제한, null 처리)

SELECT *
FROM cycle;

SELECT*
FROM product;

SELECT product.*, :cid, NVL(cycle.day, 0) day, NVL(cycle.cnt, 0) cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cid = :cid);
-- 마스터가 무엇이 되는지 확인을 잘 해야한다. 남아있는 데이터가 마스터
-- 안시 SQL

SELECT product.*, :cid, NVL(cycle.day, 0) day, NVL(cycle.cnt, 0) cnt
FROM product, cycle
WHERE product.pid = cycle.pid(+)
    AND cid(+) = :cid;
-- 오라클 문법

아우터5 조인5]
아우터조인4를 바탕으로 고객 이름 컬럼 추가하기
-- customer ==> 테이블을 3개 써야한다

SELECT product.*, :cid, NVL(cycle.day, 0) day, NVL(cycle.cnt, 0) cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cid = :cid)


중요한거 강조
WHERE, GROUP BY(그룹핑), JOIN

JOIN
카테고리
문법
: ANSI / ORACLE
논리적 형태
: SELF JOIN, NON-EQUI-JOIN <==> EQUI-JOIN
연결조건 성공 실패에 따라 조회여부 결정
: OUTERJOIN <===> INNER JOIN : 연결이 성공적으로 이루어진 행에 대해서만 조회가 되는 조인
-- 아우터 조인 이외는 전부 이너 조인
CROSS JOIN
별도의 연결조건이없는 조인
묻지마 조인
두 테이블의 행간 연결가능한 모든 경우의 수로 연결
    ==> CROSS JOIN의 결과는 두 테이블의 행의 수를 곱한 값과 같은 행이 반환된다.
데이터 복제를 위해 사용한다.

SELECT *
FROM emp CROSS JOIN dept;

-- emp에 있는 모든 행이 dept행에 모든 결과랑 연결이 된다. ==> 행 곱하기 행

crossjoin1]
customer,product 테이블을 이용하여 고객이 애음 가능한 모든 제품의 정보를 결합하여 다음과 같이 조회되도록 쿼리를 작성하세요

SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM customer CROSS JOIN product;

SELECT STORECATEGORY
FROM BURGERSTORE
WHERE SIDO = '대전'
GROUP BY STORECATEGORY;

--대전 중구
도시발전지수 : (KFC + 맥도날드 + 버거킹) / 롯데리아

SELECT *
FROM BURGERSTORE
WHERE SIDO = '대전'
    AND SIGUNGU = '중구';
    
SELECT SIDO, SIGUNGU
FROM BURGERSTORE
WHERE SIDO = '대전'
    AND SIGUNGU = '중구';
    
--

SELECT TO_NUMBER('1') from kfc
FROM BURGERSTORE
WHERE SIDO = '대전'
    AND SIGUNGU = '중구';

--

SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 2) di

FROM

(SELECT sido, sigungu, COUNT(*) cnt

 FROM burgerstore

 WHERE storecategory IN ( 'KFC', 'MACDONALD', 'BURGER KING')

 GROUP BY sido, sigungu) a,



(SELECT sido, sigungu, COUNT(*) cnt

 FROM burgerstore

 WHERE storecategory = 'LOTTERIA'

 GROUP BY sido, sigungu) b

WHERE a.sido = b.sido

AND a.sigungu = b.sigungu

AND a.sido = '대전'

AND a.sigungu = '중구'

ORDER BY di DESC;

--

DISTINCT ==> 98퍼 확률로 쿼리를 잘 못짠 상태라고 보인다.

-- 선생님 풀이
-- 테이블을 한개만 이용하는것 / 행을 컬럼으로 변경(PIVOT)

SELECT sido, sigungu, storecategory, 
        storecategory가 BURGER KING 이면 1, 0,
        storecategory가 KFC 이면 1, 0,
        storecategory가 MACDONALD 이면 1, 0,
        storecategory가 LOTTERIA 이면 1, 0,
FROM burgerstore;

----

SELECT sido, sigungu, storecategory,
        CASE
            WHEN storecategory = 'BURGER KING' THEN
            ELSE 0
        END bk
FROM burgerstore;

----- 도시발전지수 선생님 풀이

SELECT sido, sigungu,
       ROUND((SUM(DECODE(storecategory, 'BURGER KING', 1, 0)) +
        SUM(DECODE(storecategory, 'KFC', 1, 0)) +
        SUM(DECODE(storecategory, 'MACDONALD', 1, 0))) /
        DECODE(SUM(DECODE(storecategory, 'LOTTERIA', 1, 0)), 0, 1, SUM(DECODE(storecategory, 'LOTTERIA', 1, 0))), 2) idx
FROM burgerstore
GROUP BY sido, sigungu
ORDER BY idx DESC;




































