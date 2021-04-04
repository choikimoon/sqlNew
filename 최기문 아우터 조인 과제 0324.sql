아우터5 조인5]
아우터조인4를 바탕으로 고객 이름 컬럼 추가하기
-- customer ==> 테이블을 3개 써야한다


SELECT
    p.*,
    :cid,
    nvl(c.day,0) day,
    nvl(c.cnt,0) cnt,
    t.cnm
FROM
    product p,
    cycle c,
    customer t
WHERE
    p.pid = c.pid (+)
    AND   c.cid (+) =:cid
    AND   :cid = t.cid -- 1건이라 크로스가 된다.
ORDER BY
    day;
    
SELECT
    p.*,
    :cid,
    nvl(c.day,0) day,
    nvl(c.cnt,0) cnt,
    t.cnm
FROM
    product p
    LEFT OUTER JOIN cycle c ON ( p.pid = c.pid
                                 AND c.cid =:cid )
    LEFT OUTER JOIN customer t ON (:cid = t.cid )
ORDER BY
    day;
        
SELECT
    *
FROM
    customer;

SELECT
    *
FROM
    cycle;

SELECT
    *
FROM
    product;