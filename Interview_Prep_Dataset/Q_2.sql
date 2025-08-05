drop table if exists employees_tbl;
CREATE TABLE employees_tbl (eid INT, ename VARCHAR(50), gender VARCHAR(10))

INSERT INTO employees_tbl VALUES (1, 'John Doe', 'Male'),(2, 'Jane Smith', 'Female'),
(3, 'Michael Johnson', 'Male'),(4, 'Emily Davis', 'Female'),(5, 'Robert Brown', 'Male'),
(6, 'Sophia Wilson', 'Female'),(7, 'David Lee', 'Male'),(8, 'Emma White', 'Female'),
(9, 'James Taylor', 'Male'),(10, 'William Clark', 'Male')


--Given us Employee table, We need to Find the percentage of Genders.

select * from employees_tbl;

select 
round(cast(SUM(case when gender = 'Male' then 1.0 else 0 end) as float) / (select COUNT(*) from employees_tbl)*100 , 2) as Male_percentage,
round(cast(SUM(case when gender = 'Female' then 1.0 else 0 end) as float) / (select COUNT(*) from employees_tbl)*100 , 2) as Female_percentage
from employees_tbl;

