2021 04 13 보충수업

조인
- 다수개의 테이블로 부터 필요한 자료추출
- rdbms에서 가장 중요한 연산

1. 내부 조인
    조인조건을 만족하지 않는 행은 무시
예) 상품테이블에서 상품의 분류별 상품의 수를 조회하시오
    Alias는 분류코드, 분류명, 상품의 수
** 상품테이블에서 사용한 분류코드의 종류
SELECT DISTINCT PROD_LGU
  FROM PROD;
  -- 7가지의 분류코드
  
SELECT A.LPROD_GU AS 분류코드,
       A.LPROD_NM AS 분류명,
       COUNT(*) AS "상품의 수"
  FROM LPROD A, PROD B
 WHERE LPROD_GU=PROD_LGU
 GROUP BY A.LPROD_GU, A.LPROD_NM
 ORDER BY 1;
  -- 외부조인은 많은 곳을써야함
  -- 공백이 들어간 아스테리스는 쌍따옴표("")로 묶어준다
  
  예) 2005년 5월 매출자료와 거래처테이블을 이용하여 거래처별 상품매출정보를 조회하시오
  Alias는 거래처 코드, 거래처명, 매출액
  
SELECT B.PROD_BUYER AS 거래처코드,
       C.BUYER_NAME AS 거래처명,
       SUM(A.CART_QTY*B.PROD_PRICE) AS 매출액
  FROM CART A, PROD B, BUYER C
 WHERE A.CART_PROD=B.PROD_ID -- 단가
   AND B.PROD_BUYER=C.BUYER_ID -- 거래처명
   AND A.CART_NO LIKE '200505%'
 GROUP BY B.PROD_BUYER,C.BUYER_NAME
 ORDER BY 1;
 
 (ANSI 내부조인)
 SELECT 컬럼LIST
   FROM 테이블명1
  INNER JOIN 테이블명2 ON(조인조건 -- 1과 조인
   [AND 일반조건])
  INNER JOIN 테이블명3 ON (조인조건 -- 1과 2의 조인된결과와 조인
   [AND 일반조건]) -- WHERE도 상관없다
        :
    WHERE 조건;
    
    
    SELECT B.PROD_BUYER AS 거래처코드,
       C.BUYER_NAME AS 거래처명,
       SUM(A.CART_QTY*B.PROD_PRICE) AS 매출액
  FROM CART A
  INNER JOIN PROD B ON (A.CART_PROD=B.PROD_ID
  AND A.CART_NO LIKE '200505%')
  INNER JOIN BUYER C ON (B.PROD_BUYER=C.BUYER_ID) -- 바이어는 카드와 공통된 컬럼이 없다
 GROUP BY B.PROD_BUYER,C.BUYER_NAME
 ORDER BY 1;
 
 문제1] 2005년 1월 ~ 3월 거래처별 매입정보를 조회하시오 -- BUYPROD
        Alias는 거래처코드, 거래처명, 매입금액합계이고
        매입금액 합계가 500만원 이상인 거래처만 검색하시오
        
SELECT B.PROD_BUYER AS 거래처코드,
       C.BUYER_NAME AS 거래처명,
       SUM(A.BUY_QTY*A.BUY_COST) AS 매입금액합계
  FROM BUYPROD A, PROD B, BUYER C
 WHERE A.BUY_PROD=B.PROD_ID
 GROUP BY B.PROD_BUYER,C.BUYER_NAME
 ORDER BY 1;
 
        
 문제2] 사원테이블(EMPLOYEES)에서 부서별 평균급여보다 급여를 많이 받는 직원들의 수를 
        부서별로 조회하시오 -- 서브쿼리
        Alias는 부서코드,부서명,부서평균급여,인원수 -- AVG, COUNT