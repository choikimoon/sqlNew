데이터 결합 (실습 join8) -- 끝
erd 다이어그램을 참고하여 countries, regions 테이블을 이용하여 지역별 소속국가를 다음과 같은 결과가 나오도록
쿼리를 작성해 보세요 (지역은 유럽만 한정)

SELECT countries.country_name
FROM countries;

SELECT regions.region_id, regions.region_name
FROM regions;

SELECT regions.region_id, regions.region_name,countries.country_name
FROM countries, regions
WHERE regions.region_id = countries.region_id
    AND regions.region_name IN ('Europe');
    
데이터 결합 (실습 join9)-- 끝
erd 다이어그램을 참고하여 countries, regions, locations 테이블을 이용하여 지역별 소속 국가,
국가에 소속된 도시 이름을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요 (지역은 유럽만 한정)

SELECT regions.region_id, regions.region_name,countries.country_name, locations.city
FROM countries, regions, locations
WHERE regions.region_id = countries.region_id
    AND countries.country_id = locations.country_id
    AND regions.region_name IN ('Europe');
    
SELECT *
FROM locations;

데이터 결합 (실습 join10) -- 끝
erd 다이어그램을 참고하여 countries, regions, locations, departments 테이블을 이용하여
지역별 소속국가, 국가에 소속된 도시 이름 및 도시에 있는 부서를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
(지역은 유럽만  한정)

SELECT regions.region_id, regions.region_name,countries.country_name, locations.city, departments.department_name
FROM countries, regions, locations, departments
WHERE regions.region_id = countries.region_id
    AND countries.country_id = locations.country_id
    AND locations.location_id = departments.location_id
    AND regions.region_name IN ('Europe');

SELECT *
FROM departments;

데이터 결합 (실습 join11) -- 끝
erd 다이어그램을 참고하여 countries, regions, locations, departments, employees 테이블을 이용하여
지역별 소속국가, 국가에 소속된 도시 이름 및 도시에 있는 부서, 부서에 소속된 직원 정보를 다음과 같은 결과가
나오도록 쿼리를 작성해 보세요 (지역은 유럽만 한정)

SELECT regions.region_id, regions.region_name,countries.country_name, locations.city, departments.department_name, concat(first_name,last_name) name
FROM countries, regions, locations, departments, employees
WHERE regions.region_id = countries.region_id
    AND countries.country_id = locations.country_id
    AND locations.location_id = departments.location_id
    AND departments.department_id = employees.department_id
    AND regions.region_name IN ('Europe');
    
SELECT *
FROM employees;

데이터 결합(실습 join12) -- 끝
erd 다이어 그램을 참고하여 employees, jobs 테이블을 이용하여 직원의 담당업무 며칭을 포함하여
다음과 같은 결과가 나오도록 쿼리를 작성해보세요.

SELECT e.employee_id, concat(first_name,last_name), j.job_id, j.job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id;

SELECT * 
FROM employees;

SELECT *
FROM jobs;

데이터 결합 (실습 join13) -- 대기

SELECT e.manager_id mgr_id, concat(first_name,last_name) mgr_name, e.employee_id, concat(first_name,last_name) name, j.job_id, j.job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id
    AND NOT e.manager_id IS NULL;



SELECT * 
FROM employees;

SELECT *
FROM jobs;
















