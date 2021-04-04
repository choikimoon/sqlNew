0322 복습
도커 ==> 우클릭 대쉬보드 ==> 이미지 실행 ==> 포트 1522 / xe
이클립스 exerd 워크스페이스 오라클 밑으로 바꿈
프로젝트를 워크스페이스 밑으로 굳이 할 필요는 없다.

이클립스
왼쪽 프로젝스 익스플로러 뷰 , 가운데 
우측 상단에 퍼스팩티브라는 뷰를 정리해둔 것
디버그 퍼스팩티브를 많이 사용하게 된다. ==> 혼자서라도 공부를 하는게 좋다
단축키 컨트롤 F8 ==> 퍼스팩티브를 효율적으로 교체할수있다
컨트롤 M ==> 뷰를 최대화 할 수 있음
컨트롤 F7 ==> 뷰간 포커스 이동
F12 ==> 에디터 뷰로 바로 포커스 이동
컨트롤 + 페이지 업다운 ==> 에디터뷰 파일 이동
F3 ==> 메소드의 코드를 알 수 있다. / 작업 위치를 알려준다.
알트 + 왼쪽, 오른쪽 화살표 ==> 뒤로가기 앞으로가기
컨트롤 w ==> 탭을 닫는다.
컨트롤 쉬프트 w ==> 탭을 모두 닫는다.
링크 위드 에디터 ==> 클래스가 어디 패키지에 있는지 찾을 수 있다.
컨트롤 쉬프트 r ==> 오픈리소스에 아는 이름을 쓴다.

모델링
논리모델링 , 물리모델링 (모드)

논리모드 ==> 다른사람이 이해하기 쉽게 자연어에 가까운 언어로 설명한 모드
설계서를 보고 이게 무엇과 연결되어있는지 자신이 직접 알아야한다

선연결 ==> 관계선이라고 한다. ==> 두 테이블은 선이라는 컬럼으로 연결되어있다
이름을 바꿔도 설계도이기 때문에 연결된 것을 알려준다.

--데이터 결합 (base_tables.sql, 실습 join1)
erd 다이어 그램을 참고하여 prod테이블과 lprod테이블을 조인하여 다음과 같은 결과가 나오는 쿼리를 작성해보세요

SELECT prod.prod_id, prod.prod_name, prod.prod_lgu
FROM prod;

SELECT lprod.lprod_gu, lprod.lprod_nm
FROM lprod;

SELECT lprod.lprod_gu, lprod.lprod_nm,
        prod.prod_id, prod.prod_name
FROM prod, lprod
WHERE lprod.lprod_gu = prod.prod_lgu; -- 설계도의 연결된 것을 보고 조인을 한다

취업시 프로그램이 만들어져있던게 있다 ==> 유지보수를 제대로 리뉴얼 하지 않으면 다음사람이 많이 힘들어진다.

--데이터 결합 (실습 join2)
erd 다이어그램을 참고하여 buyer,prod테이블을 조인하여 buyer별 담당하는 제품 정보를 다음과 같은 결과가
나오도록 쿼리를 작성해 보세요

SELECT buyer.buyer_id, buyer_name
FROM buyer;

SELECT prod_id, prod_name
FROM prod;

SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name
FROM buyer, prod
WHERE buyer.buyer_id = prod.prod_buyer;

밑 결과에 컨트롤 엔드를 누르면 전체 결과를 보여준다 ==> 50개를 먼저 보여주고 밑에 더 있다
툴에 페이징 처리가 되어있는것

웹프로그래밍 예제 ==> 게시판 / 쇼핑몰을 주로 한다

회원 제품 회원별 제풍 ==> 필수

--데이터 결합 (실습 join3)
erd 다이어그램을 참고하여 member,cart,prod 테이블을 조인하여 회원별 장바구니에 담은 제품 정보를 다음과 같은
결과가 나오는 쿼리를 작성해보세요


SELECT member.mem_id, member.mem_name
FROM member;

SELECT cart.cart_qty
FROM cart;

SELECT prod.prod_id, prod.prod_name
FROM prod;

SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, cart, prod -- 조인을 할때는 조인할 테이블을 프럼절에 적는다.
WHERE prod.prod_id = cart.cart_prod -- 설계도에 연결과 관계선에 따라 적는다
    AND cart.cart_member = member.mem_id; -- 오류가 나면 해석해서 잘못을 수정한다.
    
안시 sql

FROM [member JOIN cart ON (....)] ==> 1개의 테이블로 생각하자

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN prod ON (prod.prod_id = cart.cart_prod)
            JOIN cart ON (cart.cart_member = member.mem_id);
            
실습 4 ~ 7번까지 진행 / 8 ~ 13번까지 과제 // 실습파일 배치 테이블 커밋

SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM cycle; --ex 1번 고객이 100번 제품을 월수금 1번씩 먹는다 day 숫자 요일 1 일요일 ~

데이터 결합 (실습 join4)
erd 다이어그램을 참고하여 customer, cycle 테이블을 조인하여 고객별 애음 제품, 애음요일, 개수를 다음과
같은 결과가 나오도록 쿼리를 작성해 보세요(고객명이 brown,sally인 고객만 조회), (정렬과 관계없이 값이 맞으면 정답)

SELECT customer.cid, customer.cnm
FROM customer;

SELECT cycle.pid, cycle.day, cycle.cnt
FROM cycle;

SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
    AND customer.cid IN (1,2);

-- 선생님 풀이
SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
    AND customer.cnm IN ('brown', 'sally');
    
데이터 결합 (실습 join5)
erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여 고객별 애음 제품, 애음요일, 개수,
제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요 (고객명이 brown,sally인 고객만 조회)

SELECT *
FROM product;

SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
    AND product.pid = cycle.pid
    AND customer.cid IN (1,2);

-- 선생님 풀이
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
    AND product.pid = cycle.pid
    AND customer.cnm IN ('brown', 'sally');

조인이 헷갈리면 시트에 정리해서 구별하기
    
데이터 결합 (실습 join 6)
erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여 애음요일과 관계없이 고객별 애음 제품별,
개수의 합과, 제품명을 다음과 같은 결과가 나오도록 쿼리는 작성해보세요 (정렬과 관계없이 값이 맞으면 정답)

SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.cnt,
    CASE
        WHEN cycle = '100' COUNT(cycle)
        WHEN cycle = '200' COUNT(cycle)   
        WHEN cycle = '300' COUNT(cycle)
        WHEN cycle = '100' COUNT(cycle)
        ELSE null
        END
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
    AND product.pid = cycle.pid
GROUP BY cycle;

--선생님 풀이

SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
    AND product.pid = cycle.pid
    AND customer.cnm IN ('brown', 'sally')
    GROUP BY customer.cid, customer.cnm, cycle.pid, product.pnm;

데이터 결합 (실습 join7)
erd 다이어그램을 참고하여 cycle, product 테이블을 이용하여 제품별 개수의 합과 제품명을 다음과 같은 결과가
나오도록 쿼리를 작성해보세요 (정렬과 관계없이 값이 맞으면 정답)

--선생님 풀이
SELECT cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM cycle, product
WHERE product.pid = cycle.pid
    GROUP BY cycle.pid, product.pnm;
    
SELECT cycle.pid, product.pnm,cycle.cnt
FROM cycle, product
WHERE product.pid = cycle.pid;

hr계정을 확인하고 비활성화 되있는계정을 살려야한다 ==> 시스템계정으로 작업해야한다

SELECT *
FROM dba_users; ==> hr 계정 확인

ALTER USER hr ACCOUNT UNLOCK; ==> hr락을 푸는 명령어
ALTER USER hr IDENTIFIED BY java; ==> hr 계정의 비밀번호를 자바로 바꾸겠다

일반적인 조인은 1개가 빠지면 안나오는데 아우터 조인으로 빠져도 출력이 가능하게 나오게 할 수 있다.
이너 조인 , 아우터 조인

OUTER JOIN : 컬럼 연결이 실패해도 [기준]이 되는 테이블 쪽의 컬럼 정보는 나오도록 하는 조인
LEFT OUTER JOIN : 기준이 왼쪽에 기술한 테이블이 되는 OUTER JOIN // 하나밖에 모르겠다면 레프트라도
RIGHT OUTER JOIN : 기준이 오른쪽에 기술한 테이블이 되는 OUTER JOIN
FULL OUTER JOIN : 사용 빈도가 떨어짐 // 나중에 설명 : LEFT OUTER + RIGHT OUTER - 중복데이터 제거 , 정의정도는 기억을 하자

테이블1 JOIN 테이블2
테이블1 LEFT OUTER JOIN 테이블2
==
테이블2 RIGHT OUTER JOIN 테이블1 -- 같다


직원의 이름, 직원의 상사 이름 두개의 컬럼이 나오도록 join query 작성

-- 선생님 풀이
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE m.empno = e.mgr;

SELECT *
FROM emp;

SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);

--ORACLE SQL OUTER JOIN 표기 : (+)
--OUTER 조인으로 인해 데이터가 안나오는 쪽 컬럼에 (+)를 붙여준다
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE m.empno(+) = e.mgr; 
-- 여기서 시작을하면된다
-- 누락이 되는 테이블에 플러스를 붙여준다

SELECT e.ename, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno AND m.deptno = 10);

SELECT e.ename, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
WHERE m.deptno = 10;
-- 웨어절은 행을 제한한다
-- 아우터의 연결 조건으로 행이 나오는지 웨어절로 추가해서 행이 안나오는지 차이가 난다

SELECT empno, ename, deptno
FROM emp;

SELECT e.ename, m.ename, m.deptno
FROM emp e, emp m
WHERE m.empno(+) = e.mgr
    AND m.deptno(+) = 10; 
-- 검색 결과가 실패하더라도 나오게 할려면 컬럼에 (+)를 붙인다 == 안시 sql
-- 조건을 온전히 붙였냐, 웨어절에 붙였냐에 따라 다른 결과를 받는다
-- +가 보편적이고 , 위에 방식이 많이 사용하지 않는다

SELECT e.ename, m.ename, m.deptno
FROM emp m RIGHT OUTER JOIN emp e ON(e.mgr = m.empno)
--레프트하면 굳이 라이를 할 이유가 없다

SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno);

SELECT *
FROM emp;

-- 라이트를 설명한 이유는 풀아우터때문이다.

-- FULL OUTER : LEFT OUTER + RIGHT OUTER - 중복 데이터 1개만 남기고 제거
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

-- 레프트 14개 + 라이트 21개 - 중복 데이터 1개만 남기고 제거 (13) = 22

SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

-- KING (null) 단 한개가 중복이 안되는 것이다. // 레프트에도 나오고 라이트에도 나온다

SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

-- FULL OUTER 조인은 오라클 SQL 문법으로 제공하지 않는다.
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr(+) = m.empno(+); -- 안됨

outer join1] 실습

SELECT *
FROM buyprod
WHERE buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD');

SELECT *
FROM prod
WHERE prod_id = 'P202000001';

모든 제품을 다 보여주고, 실제 구매가 있을 때는 구매수량을 조회 없음 경우 null로 표현
제품 코드 : 수량

SELECT *
FROM prod;

SELECT *
FROM buyprod;

SELECT buyprod.buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id AND buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD'));

SELECT buyprod.buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id 
    AND buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD');