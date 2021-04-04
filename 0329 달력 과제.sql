SELECT
    week_num,
    MIN(DECODE(day_num,1,month_day) ) sun,
    MIN(DECODE(day_num,2,month_day) ) mon,
    MIN(DECODE(day_num,3,month_day) ) tue,
    MIN(DECODE(day_num,4,month_day) ) wed,
    MIN(DECODE(day_num,5,month_day) ) thu,
    MIN(DECODE(day_num,6,month_day) ) fri,
    MIN(DECODE(day_num,7,month_day) ) sat
FROM
    (
        SELECT
            DECODE(day_num,1,week_num + 1,week_num) week_num,
            day_num,
            month_day
        FROM
            (
                SELECT
                    DECODE(january,'Y',
                        CASE
                            WHEN TO_CHAR(month_day,'DD') <= '31'
                                 AND TO_CHAR(month_day,'IW') > '06' THEN '00'
                            ELSE TO_CHAR(month_day,'IW')
                        END,TO_CHAR(month_day,'IW') ) week_num,
                    TO_CHAR(month_day,'D') day_num,
                    rnum month_day
                FROM
                    (
                        SELECT
                            a.start_dt + ( b.rnum - 1 ) month_day,
                            a.january,
                            b.rnum
                        FROM
                            (
                                SELECT
                                    TO_DATE(:yyyymm
                                    || '01','YYYYMMDD') start_dt,
                                    DECODE(substr(:yyyymm,5,2),'01','Y') january
                                FROM
                                    dual
                            ) a,
                            (
                                SELECT
                                    level rnum
                                FROM
                                    dual
                                CONNECT BY
                                    level <= (
                                        SELECT
                                            TO_CHAR(last_day(TO_DATE(:yyyymm
                                            || '01','YYYYMMDD') ),'DD')
                                        FROM
                                            dual
                                    )
                            ) b
                    )
            )
    )
GROUP BY
    week_num
ORDER BY
    week_num;