

SELECT ename, TO_CHAR(hiredate, 'yyyy/mm/dd hh24:mi:ss') hiredate,
        MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
        ADD_MONTHS(SYSDATE, 5) ADD_MONTHS,
        ADD_MONTHS(TO_DATE('2021-02-15', 'YYYY-MM-DD'), 5) ADD_MONTH2,
        NEXT_DAY(SYSDATE, 1) NEXT_DAY,
        LAST_DAY(SYSDATE) LAST_DAY,
        TO_DATE(TO_CHAR(SYSDATE, 'YYYYMM') || '01', 'YYYY-MM-DD') FIRST_DAY
FROM emp;

SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') hiredate,
        MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
        ADD_MONTHS(SYSDATE, 5) add_months,
        ADD_MONTHS(TO_DATE('2021-02-15', 'YYYY-MM-DD'), 5) add_months2,
        NEXT_DAY(SYSDATE, 1) next_day,
        NEXT_DAY(TO_DATE('2021-02-10', 'YYYY-MM-DD'), 1) next_day2,
        LAST_DAY(SYSDATE) last_day,
        TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD') || '01', 'YYYY-MM-DD') first_day
FROM emp;

SELECT :YYYYMM, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')
FROM dual;

SELECT :YYYYMM, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'MMDD')
FROM dual;

SELECT *
FROM emp
WHERE empno = '7369';

SELECT empno, comm, NVL(comm, 1), NVL(sal+comm, 0), sal + NVL(comm, 0)
FROM emp;

SELECT empno, sal, comm, 
        sal + NVL(comm, 0) nvl_sal_comm,
        NVL(sal+comm, 0) nv1_sal_comm2
FROM emp;

SELECT empno, sal, comm,W
        NVL2(comm, sal+comm, sal),
        sal + NVL(comm, 0)
FROM emp;





































