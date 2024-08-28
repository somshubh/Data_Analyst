--create table team(
--team_Name nvarchar(255)
--);

--insert into dbo.team values('India'), ('Pak'), ('Aus'), ('Eng')

-- select * from team;

with cte as (
select *,
row_number() over(order by team_Name) as rank
from team
)
select a.team_Name as "Team A", b.team_Name as "Team B" from cte a join cte b
on a.team_name <> b.team_name
where a.rank <b.rank
order by a.team_name

------------------------------------------------------------
create table Employee(
emp_Name nvarchar(255)
);

alter table Employee add emp_Name nvarchar(255);

alter table employee drop column emp_Name;
---------------------------------
insert into Employee values(1, 'Emp1'), (2, 'Emp2'), (3, 'Emp3'), (4, 'Emp4'), (5, 'Emp5'), (6, 'Emp6'), (7, 'Emp7'), (8, 'Emp8');
----------------------
select * from employee

================================================
with cte as (
select *,
concat(ID, ' ', emp_name) as emp_con_name,
Ntile(4) over(order by ID) as rnk from employee
)
select string_agg(emp_con_name, ', ') as "result", rnk as "groups" from cte
group by rnk;

---------------------------------

CREATE TABLE Employee_1 (
EmpID int NOT NULL,
EmpName Varchar,
Gender Char,
Salary int,
City Char(20) )

alter table Employee_1 alter column EmpName nvarchar(255)

INSERT INTO Employee_1
VALUES (1, 'Arjun', 'M', 75000, 'Pune'),
(2, 'Ekadanta', 'M', 125000, 'Bangalore'),
(3, 'Lalita', 'F', 150000 , 'Mathura'),
(4, 'Madhav', 'M', 250000 , 'Delhi'),
(5, 'Visakha', 'F', 120000 , 'Mathura')

-- select * from Employee_1

--------------------

CREATE TABLE EmployeeDetail (
EmpID int NOT NULL,
Project nvarchar(255),
EmpPosition Char(20),
DOJ date );

alter table EmployeeDetail alter column DOJ nvarchar(255)

INSERT INTO EmployeeDetail
VALUES (1, 'P1', 'Executive', '26-01-2019'),
(2, 'P2', 'Executive', '04-05-2020'),
(3, 'P1', 'Lead', '21-10-2021'),
(4, 'P3', 'Manager', '29-11-2019'),
(5, 'P2', 'Manager', '01-08-2020');

select empname, salary from Employee_1 where salary between 200000 and 300000;

-----------------

select a.* from employee_1 a join employee_1 b on a.city = b.city
where a.empid != b.empid;
-----------
select count(*) as "Null_Count" from employee_1 where empid is null;
----------

select * from employee_1;

with cte as (
select *,
sum(salary) over(order by empid) as cumalative
from employee_1
)
select empid, salary, cumalative from cte
------------------------

-- select * from employee_1

with cte as(
select
sum(case when gender = 'M' then 1 else 0 end)*100/count(*) Male_pct,
sum(case when gender = 'F' then 1 else 0 end)*100/count(*) Female_pct
from employee_1)
select * from cte;

--------------
-- 50 % row need to show

-- select * from employee_1

with cte as (
select *,
row_number() over(order by empid) as rnk
from employee_1
)
select * from cte where rnk%2 != 0;

--- Using Subquery Approach

select * from (
select *,
row_number() over(order by empid) as rnk
from employee_1
) emp
where emp.rnk % 2 != 0

INSERT INTO EmployeeDetail
VALUES (6, 'P3', 'Delivary Manager', '26-01-2019');

INSERT INTO Employee_1
VALUES (6, 'Somshubhra', 'M', 7500000, 'Kolkata');

select * from employee_1 where empid <= (select count(empid)/2 from employee_1)

-----------

-- Name Start with vowles and end with vowles
select * from employee_1
update employee_1 set empname = 'Visakha' where empid =5
select * from employee_1 where empname like '[aeiou]%[aeiou]'

-- show Nth Highest salary record

-- with top

select top 1 * from employee_1 order by salary desc;

with cte as (
select *,
rank() over(order by salary desc) as rnk
from employee_1
)
select * from cte where rnk =1

select * from(
select *,
rank() over(order by salary desc) as rnk
from employee_1
) as emp where emp.rnk = 1

--select salary from employee_1 emp1 where
--2 = (select count(distinct(em2.salary)) from employee_1 emp2
--where emp2.salary > em1.salary)

select * from employee_1

with cte as(
select *,
count(*) as Duplicate_count
from employee_1 group by empid, empname, gender, salary, city
)
-- select * from cte
delete from employee_1 where empid in (
select empid from cte where duplicate_count = 2)

---------------------
-- Remove Duplicate using Partition by

with cte as(
select *,
row_number() over(partition by empid, empname order by  empid ) as Duplicate_count
-- row_number() over (order by  empid) as rnk
from employee_1
)
delete from employee_1 where empid in (
select distinct empid from cte where duplicate_count > 1
)

select * from employee_1 order by  salary desc Offset 2 rows
FETCH NEXT 4 ROWS ONLY;
---------
select * from employee_1
delete from 

-------------
with cte as (
select e.empid, e.empname, ed.project from employeedetail ed join employee_1 e on e.empid = ed.empid
)
--select * from cte
select c1.empname, c1.project from cte c1, cte c2 where c1.project = c2.project
and c1.empid != c2.empid and c1.empid < c2.empid
union
select c2.empname, c2.project from cte c1, cte c2 where c1.project = c2.project
and c1.empid != c2.empid and c1.empid < c2.empid

---------------
select ed.project, max(e.salary) as "Max_Project_Salary" from employee_1 e join employeedetail ed on e.empid = ed.empid
group by ed.project

-------------
with cte as(
select project, empname, salary,
row_number() over(partition by project order by salary desc) rnk
from employee_1 e join employeedetail ed
on e.empid = ed.empid
)
select cte.project, cte.empname, cte.salary from cte where rnk =1

select right(doj,4) as "Year", count(e.empid) "Employee_Count" from employee_1 e join employeedetail ed on e.empid = ed.empid
group by right(doj,4)

select doj from employeedetail

--alter table employeedetail alter column doj date

select *,
(case 
when salary < 100000 then 'Low'
when salary between 100000 and 200000 then 'Medium'
when salary > 100000 then 'High'
end) as "Salary_status"
from employee_1

alter table employee_1  add "Salary_Status" nvarchar(255)

select * from employee_1

update employee_1 set salary_status = 
(case 
when salary < 100000 then 'Low'
when salary between 100000 and 200000 then 'Medium'
when salary > 100000 then 'High'
end)
-------------------

select * from employee_1

with cte as(
select empname,salary,
sum(salary) over(order by empid) as "cumalative_amount"
from employee_1
)
select * from cte;
------------------------------------------------
select * from employee

--------------------
create table Address(
address nvarchar(255)
)

insert into Address values
('156 Liluha Howrah-kolkata-IND-98768589994-123455'),
('156 Hinjawadi-Pune-IND-98768589994-123455');

-- select * from Address;

select 
(case
when trim(substring(address,1,charindex('-',address)-1)) like '%Howrah%' then trim(substring(address,1,charindex('Howrah',address)-1))
else trim(substring(address,1,charindex('-',address)-1))
end) as "Street",
substring(substring(address,charindex('-',address)+1, len(address)),
1,
charindex('-',substring(address,charindex('-',address)+1, len(address)))-1) as "City",
substring(substring(address,
len(substring(address,1,charindex('-',address)-1))+len(substring(substring(address,charindex('-',address)+1, len(address)),
1,
charindex('-',substring(address,charindex('-',address)+1, len(address)))+2)),len(address)),1,charindex('-',substring(address,
len(substring(address,1,charindex('-',address)-1))+len(substring(substring(address,charindex('-',address)+1, len(address)),
1,
charindex('-',substring(address,charindex('-',address)+1, len(address)))+2)),len(address)))-1) as Country
from address

--select charindex('-',address, charindex('-',address, 10))  from address

--select substring(address,charindex('-',address)+1, len(address)) from address

--select parsename(replace(address, '-', '.'),5) from Address

--select substring(address,charindex('-',address)+1, )
--select * from address

--create table Address_Check(
--address_name nvarchar(255)
--)

--insert into Address_Check values('AdventureWorks 2022-Person-Person')

--select replace(Address_name, '-', '.') from address_check


--from address;

--select reverse(address) from address

select len(substring(address,1,charindex('-',address)-1))+len(substring(substring(address,charindex('-',address)+1, len(address)),
1,
charindex('-',substring(address,charindex('-',address)+1, len(address)))-1)) from address

select substring(address,1,charindex('-',address)-1),
len(substring(address,1,charindex('-',address)-1)),
substring(substring(address,charindex('-',address)+1, len(address)),
1,
charindex('-',substring(address,charindex('-',address)+1, len(address)))-1),
len(substring(substring(address,charindex('-',address)+1, len(address)),
1,
charindex('-',substring(address,charindex('-',address)+1, len(address)))-1))
from address

select substring(trim(address),1,17) from address

select address,
reverse(address) from address;
select address, charindex('-', address) from address








----------------------

--create table brand(
--year nvarchar(255),
--brand nvarchar(255),
--Amount int
--)

insert into brand values('2018','Apple',27000),
('2019','Apple',22500),
('2020','Apple',30000),
('2018','Samsung',40000),
('2019','Samsung',42500),
('2020','Samsung',50000),
('2018','Lenovo',41000),
('2019','Lenovo',42500),
('2020','Lenovo',48000);

-- delete from brand;

-- select * from brand;
with cte as(
select *, 
(Case
	when amount < LEAD(amount, 1, amount+1) over(partition by brand order by year) then 1
	 else 0
 end) as flag
from brand)
-- select * from cte
select * from brand where brand not in (select brand from cte where flag =0)

--select *, LEAD(amount, 1, amount+1) over(partition by brand order by year) from brand

------------
-- 1. Remove duplicate Records
drop table if exists cars;
create table cars
(
	model_id		int primary key,
	model_name		nvarchar(100),
	color			nvarchar(100),
	brand			nvarchar(100)
);
insert into cars values(1,'Leaf', 'Black', 'Nissan');
insert into cars values(2,'Leaf', 'Black', 'Nissan');
insert into cars values(3,'Model S', 'Black', 'Tesla');
insert into cars values(4,'Model X', 'White', 'Tesla');
insert into cars values(5,'Ioniq 5', 'Black', 'Hyundai');
insert into cars values(6,'Ioniq 5', 'Black', 'Hyundai');
insert into cars values(7,'Ioniq 6', 'White', 'Hyundai');

select * from cars;

with cte as(
select *,
row_number() over(partition by model_name, color, brand order by model_name) as flag
from cars)
delete from cars where model_id in (select model_id from cte where flag = 2);

------------------------------
-- 2. Find Max and Min Salary for each Role

drop table if exists employee;
create table employee
(
	id 			int IDENTITY(1,1) primary key,
	name 		nvarchar(100),
	dept 		nvarchar(100),
	salary 		int
);
insert into employee (name, dept, salary) values('Alexander', 'Admin', 6500);
insert into employee (name, dept, salary)  values('Leo', 'Finance', 7000);
insert into employee (name, dept, salary)  values('Robin', 'IT', 2000);
insert into employee (name, dept, salary)  values('Ali', 'IT', 4000);
insert into employee (name, dept, salary)  values('Maria', 'IT', 6000);
insert into employee (name, dept, salary)  values('Alice', 'Admin', 5000);
insert into employee (name, dept, salary)  values('Sebastian', 'HR', 3000);
insert into employee (name, dept, salary)  values('Emma', 'Finance', 4000);
insert into employee (name, dept, salary)  values('John', 'HR', 4500);
insert into employee (name, dept, salary) values('Kabir', 'IT', 8000);

select * from employee

with cte as (
select *,
max(Salary) over(partition by dept order by salary desc) High_Salary,
min(Salary) over(partition by dept order by salary asc) Low_Salary
from employee
)
select * from cte;


select dept, max(salary) Max_Salary, min(Salary) Min_Salary from employee group by dept;

-----------------
-- 3. Actual Distance Travel

drop table if exists  car_travels;
create table car_travels
(
    cars                    nvarchar(40),
    days                    nvarchar(10),
    cumulative_distance     int
);
insert into car_travels values ('Car1', 'Day1', 50);
insert into car_travels values ('Car1', 'Day2', 100);
insert into car_travels values ('Car1', 'Day3', 200);
insert into car_travels values ('Car2', 'Day1', 0);
insert into car_travels values ('Car3', 'Day1', 0);
insert into car_travels values ('Car3', 'Day2', 50);
insert into car_travels values ('Car3', 'Day3', 50);
insert into car_travels values ('Car3', 'Day4', 100);
select * from car_travels;

with cte as(
select *,
cumulative_distance - lag(cumulative_distance, 1, 0) over(partition by cars order by days) as Actual_travel
from car_travels
)
select * from cte;

------------------------------------------
drop table if exists src_dest_distance;
create table src_dest_distance
(
    source          nvarchar(20),
    destination     nvarchar(20),
    distance        int
);
insert into src_dest_distance values ('Bangalore', 'Hyderbad', 400);
insert into src_dest_distance values ('Hyderbad', 'Bangalore', 400);
insert into src_dest_distance values ('Mumbai', 'Delhi', 400);
insert into src_dest_distance values ('Delhi', 'Mumbai', 400);
insert into src_dest_distance values ('Chennai', 'Pune', 400);
insert into src_dest_distance values ('Pune', 'Chennai', 400);

select * from src_dest_distance
with cte as (
select least(source, destination) over (order by source) as source,
select greatest(source, destination) over (order by source) as destination
from src_dest_distance
)
select * from cte;

select least(source, destination) as source,  greatest(source, destination) as destination, min(distance) distance from src_dest_distance
group by least(source, destination),  greatest(source, destination);

-----------------
-- Ungroup the data
drop table if exists travel_items;
create table travel_items
(
	id              int,
	item_name       nvarchar(50),
	total_count     int
);
insert into travel_items values (1, 'Water Bottle', 2);
insert into travel_items values (2, 'Tent', 1);
insert into travel_items values (3, 'Apple', 4);

select * from travel_items;

with cte as (
select id, item_name, total_count, 1 as Lavel from travel_items
union all
select id, item_name, total_count - 1, (Lavel + 10) from cte where cte.total_count > 1
)
select * from cte order by total_count asc, item_name desc;

--------------

-- Pivot Tabel
drop table if exists sales_data;
create table sales_data
    (
        sales_date      date,
        customer_id     varchar(30),
        amount          varchar(30)
    );
insert into sales_data values ('01-Jan-2021', 'Cust-1', '50$');
insert into sales_data values ('02-Jan-2021', 'Cust-1', '50$');
insert into sales_data values ('03-Jan-2021', 'Cust-1', '50$');
insert into sales_data values ('01-Jan-2021', 'Cust-2', '100$');
insert into sales_data values ('02-Jan-2021', 'Cust-2', '100$');
insert into sales_data values ('03-Jan-2021', 'Cust-2', '100$');
insert into sales_data values ('01-Feb-2021', 'Cust-2', '-100$');
insert into sales_data values ('02-Feb-2021', 'Cust-2', '-100$');
insert into sales_data values ('03-Feb-2021', 'Cust-2', '-100$');
insert into sales_data values ('01-Mar-2021', 'Cust-3', '1$');
insert into sales_data values ('01-Apr-2021', 'Cust-3', '1$');
insert into sales_data values ('01-May-2021', 'Cust-3', '1$');
insert into sales_data values ('01-Jun-2021', 'Cust-3', '1$');
insert into sales_data values ('01-Jul-2021', 'Cust-3', '-1$');
insert into sales_data values ('01-Aug-2021', 'Cust-3', '-1$');
insert into sales_data values ('01-Sep-2021', 'Cust-3', '-1$');
insert into sales_data values ('01-Oct-2021', 'Cust-3', '-1$');
insert into sales_data values ('01-Nov-2021', 'Cust-3', '-1$');
insert into sales_data values ('01-Dec-2021', 'Cust-3', '-1$');

select * from sales_data;

select * from
(
select  sales_date, customer_id, sales_amount_new from sales_data
) as main
pivot
(
sum(sales_amount_new) for sales_date IN([2021-01-01],[2021-01-02],[2021-01-03],[2021-02-01],[2021-02-02],[2021-02-03],[2021-03-01],[2021-04-01],[2021-05-01],[2021-06-01],[2021-07-01],[2021-08-01],[2021-09-01],[2021-10-01],[2021-11-01],[2021-12-01])
) as p

alter table sales_data add sales_amount_new int

update sales_data set sales_amount_new = convert(int, replace(amount,'$',''))

select * from sales_data

-- Dynamic Pivot Table

declare @Month nvarchar(max)='',
        @SqlQuery nvarchar(max) = '';
with month_cte as(
select distinct sales_date sales_date from sales_data
)

select @month+=quotename(sales_date)+',' from month_cte
set @month = left(@month, len(@month)-1)

set @SqlQuery = 
'
select * from
(
select  sales_date, customer_id, sales_amount_new from sales_data
) as main
pivot
(
sum(sales_amount_new) for sales_date in ('+ @month +')
)as p
'
execute @SqlQuery

-----------------------------------------
drop table if exists Salary
create table Salary(
Role Nvarchar(255),
Employee_DC Nvarchar(255),
salary int
)

insert into Salary values('Manager', 'Kolkata', 9000)

('HR', 'Pune', 2500),
('Manager', 'Pune', 6000),
('TL', 'Pune', 5000),
('System Engineer', 'Pune', 3000),
('HR', 'Kolkata', 2500),
('Manager', 'Kolkata', 6000),
('TL', 'Kolkata', 5000),
('System Engineer', 'Kolkata', 3000)

select * from salary

select * from
(
select "role", Employee_DC, salary from salary
) as main
pivot
(
sum(salary) for "role" in ([HR], [Manager], [TL], [System Engineer])
)as p

-------------
-- Dynamic Pivot Table

DECLARE @RoleName Nvarchar(max) = '',
        @DynamicPivot Nvarchar(Max) = '';

with role_cte as(
select distinct role from salary
)
select @RoleName += quotename(role) +',' from role_cte
set @RoleName = left(@RoleName,len(@RoleName)-1)
-- print @RoleName

set  @DynamicPivot = 
'
select * from
(
select "role", Employee_DC, salary from salary
) as main
pivot
(
sum(salary) for "role" in ('+@RoleName+')
)as p
'
execute sp_executesql @DynamicPivot

----------------------
--Microsoft Interview question

drop table if exists Billing
create table Billing(
customer_id int,
customer_name nvarchar(255),
billing_id nvarchar(255),
billing_creation_date date,
billing_amount int
);
------------

-- insert data

insert into billing(customer_id, customer_name, billing_id, billing_creation_date, billing_amount)values
(1,'A', 'id1', '10-10-2020', 100),
(1,'A', 'id2', '11-11-2020', 150),
(1,'A', 'id3', '12-11-2021', 100),
(2,'B', 'id4', '10-11-2019', 150),
(2,'B', 'id5', '11-11-2020', 200),
(2,'B', 'id6', '12-11-2021', 250),
(3,'C', 'id7', '01-01-2018', 100),
(3,'C', 'id8', '05-01-2019', 250),
(3,'C', 'id9', '06-01-2021', 300);

select * from Billing

with cte as(
select customer_id, customer_name,
sum(case when year(billing_creation_date) = '2019' then billing_amount else 0 end) as sum_2019,
sum(case when year(billing_creation_date) = '2020' then billing_amount else 0 end) as sum_2020,
sum(case when year(billing_creation_date) = '2021' then billing_amount else 0 end) as sum_2021,
count(case when year(billing_creation_date) = '2019' then billing_amount else null end) as cnt_2019,
count(case when year(billing_creation_date) = '2020' then billing_amount else null end) as cnt_2020,
count(case when year(billing_creation_date) = '2021' then billing_amount else null end) as cnt_2021
from billing
group by customer_name, customer_id)

select customer_id, customer_name,
(sum_2019 + sum_2020 + sum_2021)
/ (
case when cnt_2019 = 0 then 1 else cnt_2019 end +
case when cnt_2020 = 0 then 1 else cnt_2020 end +
case when cnt_2021 = 0 then 1 else cnt_2021 end
) as Avg_Billing_Amount 
from cte;

-----------------------------

create table dbo.Vote(
voter nvarchar(255),
candidate nvarchar(255)
);


insert into vote values('Somshubhra Giri',null),
('Suresh', 'Modi'),
('Suresh', 'Arvind'),
('Suresh', 'Mamata'),
('Subham', 'Modi'),
('rounak', 'Mamata'),
('Rohit', 'Biman'),
('Rohit', 'Mamata');

select * from vote;
-- if the ome votar gives vote multiple candidates then it's equally distribute for each candidate

with cte as(
select voter, candidate, round(1/convert(float,count(candidate) over (partition by voter)),2) as vote_count
from vote
where candidate is not null
),
cte2 as(
select candidate, sum(vote_count) "Total_votes", dense_rank() over(order by sum(vote_count) desc) ds_rn
from cte
group by candidate
)
select * from cte2 where ds_rn = 1

-----------------------------------------------------

create table category(
category nvarchar(255),
subcategory nvarchar(255)
)

insert into category values('chocolate','Kitkat'),
(null,'Perk'),
('chocolate','Munch'),
(null,'Daiery Milk'),
('Biscuite', 'Good Day'),
(null, 'JimJam'),
(null, 'Hide & Sick');


with cte as(
select *,
row_number() over(order by (select null)) as id
from category
),
cte2 as(
select *, lead(id,1) over(order by id) as next_id from cte
where category is not null
)
select c2.*, c1.* from cte c1 join cte2 c2 on c1.id >= c2.id and (c1.id <= c2.next_id -1 or c2.next_id is null)
-- select c1.category, c2.category from category c1 join category c2 on c1.subcategory = c2.subcategory

------------------------------
--drop table if exists Salary;
--create table Salary(
--empName nvarchar(255),
--deptid int,
--salary int
--);

insert into salary values('Siva', 1, 30000),
('Ravi', 2, 40000),
('Prasad', 1, 50000),
('Sai', 2, 20000),
('Anna', 2, 10000);

select * from salary;


with cte as(
select *,
row_number() over(partition by deptid order by salary desc) rn_desc,
row_number() over(partition by deptid order by salary asc) rn_asc
from salary
),
cte2 as(
select (
case
when rn_desc = 1 then concat(empName, ' - ', 'Max Salary',' - ','Dept ', convert(varchar,cte.deptid))
end
) max_salary_empname,
 (
case
when rn_asc = 1 then concat(empName, '-', 'Min Salary',' - ','Dept ', convert(varchar,cte.deptid))
end
) min_salary_empname
from cte)
select cte2.max_salary_empname as "Employee_Name" from cte2
where max_salary_empname is not null
union
select cte2.min_salary_empname as "Employee_Name" from cte2
where min_salary_empname is not null;

---------------------
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  category VARCHAR(50)
);

INSERT INTO products (product_id, product_name, category) VALUES
  (1, 'Laptops', 'Electronics'),
  (2, 'Jeans', 'Clothing'),
  (3, 'Chairs', 'Home Appliances');


CREATE TABLE sales (
  product_id INT,
  year INT,
  total_sales_revenue DECIMAL(10, 2),
  PRIMARY KEY (product_id, year),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO sales (product_id, year, total_sales_revenue) VALUES
  (1, 2019, 1000.00),
  (1, 2020, 1200.00),
  (1, 2021, 1100.00),
  (2, 2019, 500.00),
  (2, 2020, 600.00),
  (2, 2021, 900.00),
  (3, 2019, 300.00),
  (3, 2020, 450.00),
  (3, 2021, 400.00);

  select * from sales;

  with cte as (
  select *,
  (case
   when total_sales_revenue < lead(total_sales_revenue,1,total_sales_revenue+1) over(partition by product_id order by year) then 1
   else 0
   end
  ) as flag
  from sales
  )
  select distinct p.product_name from sales s join products p
  on p.product_id = s.product_id
  where s.product_id not in (select product_id from cte where flag = 0);

  -------------------

  CREATE TABLE AttendanceLogs (
    UserID INT,
    LogDate DATE,
    LoggedIn CHAR
);

-- DML (Data Manipulation Language) Statements
-- Insert dummy records into the Logs table
INSERT INTO AttendanceLogs (LoggedIn, LogDate, UserID)
VALUES
 ('Y', '2023-01-01', 101),
 ('N', '2023-01-01', 102),
 ('N', '2023-01-01', 103),
 ('Y', '2023-01-01', 104),
 ('Y', '2023-01-01', 105),
 ('N', '2023-01-02', 101),
 ('Y', '2023-01-02', 102),
 ('N', '2023-01-02', 103),
 ('Y', '2023-01-02', 104),
 ('N', '2023-01-02', 105),
 ('Y', '2023-01-03', 101),
 ('Y', '2023-01-03', 102),
 ('N', '2023-01-03', 103),
 ('Y', '2023-01-03', 104),
 ('N', '2023-01-03', 105),
 ('N', '2023-01-04', 101),
 ('N', '2023-01-04', 102),
 ('N', '2023-01-04', 103),
 ('Y', '2023-01-04', 104),
 ('Y', '2023-01-04', 105),
 ('Y', '2023-01-05', 101),
 ('Y', '2023-01-05', 102),
 ('Y', '2023-01-05', 103),
 ('N', '2023-01-05', 104),
 ('N', '2023-01-05', 105),
 ('N', '2023-01-06', 101),
 ('Y', '2023-01-06', 102),
 ('Y', '2023-01-06', 103),
 ('Y', '2023-01-06', 104),
 ('N', '2023-01-06', 105),
 ('N', '2023-01-07', 101),
 ('Y', '2023-01-07', 102),
 ('N', '2023-01-07', 103),
 ('N', '2023-01-07', 104),
 ('Y', '2023-01-07', 105);

 with cte as(
 select *,
 case when loggedin = 'N' then 1 else 0 end as flag,
 concat('Group',sum(case when loggedin = 'N' then 1 else 0 end) over (partition by userid order by logdate)) as cuma_flag
 from AttendanceLogs)

 select Userid,count(*) student_Count,
   min(logdate) as Date_Start,
   max(logdate) as Date_End
   from cte where loggedin = 'Y'
   group by userid,cuma_flag
   having count(*) >=2;

create table reportlog(
student_id int,
name nvarchar(255),
manager_id int
)

insert into reportlog values(1,'Suresh',null),
(2,'Mahesh',1),
(3,'Ratul',1),
(4,'Rockey',2),
(5,'Somesh',3),
(6,'Sourav',3);

select * from reportlog;

select r2.name, count(r1.student_id) from reportlog r1 join reportlog r2 on r1.manager_id = r2.student_id
where r1.manager_id is not null
group by r2.name

---------------------

CREATE TABLE city_population (
 state VARCHAR(50),
 city VARCHAR(50),
 population INT
);

-- Insert the data
INSERT INTO city_population (state, city, population) VALUES ('haryana', 'ambala', 100);
INSERT INTO city_population (state, city, population) VALUES ('haryana', 'panipat', 200);
INSERT INTO city_population (state, city, population) VALUES ('haryana', 'gurgaon', 300);
INSERT INTO city_population (state, city, population) VALUES ('punjab', 'amritsar', 150);
INSERT INTO city_population (state, city, population) VALUES ('punjab', 'ludhiana', 400);
INSERT INTO city_population (state, city, population) VALUES ('punjab', 'jalandhar', 250);
INSERT INTO city_population (state, city, population) VALUES ('maharashtra', 'mumbai', 1000);
INSERT INTO city_population (state, city, population) VALUES ('maharashtra', 'pune', 600);
INSERT INTO city_population (state, city, population) VALUES ('maharashtra', 'nagpur', 300);
INSERT INTO city_population (state, city, population) VALUES ('karnataka', 'bangalore', 900);
INSERT INTO city_population (state, city, population) VALUES ('karnataka', 'mysore', 400);
INSERT INTO city_population (state, city, population) VALUES ('karnataka', 'mangalore', 200);

select * from city_population;

with cte as(
select *,
row_number() over(partition by state order by population desc) rn_desc,
row_number() over(partition by state order by population asc) rn_asc
from city_population
),
cte2 as(
select state,
case when rn_desc = 1 then city end as max_City,
case when rn_asc = 1 then city end as min_City 
from cte
)

select * from cte2 where max_city is not null or min_city is not null

----------------------
WITH CTE AS(
SELECT state, FIRST_VALUE(city) OVER(PARTITION BY state ORDER BY population DESC) AS [City Max(Population)],
FIRST_VALUE(city) OVER(PARTITION BY state ORDER BY population) AS [City Min(Population)]
FROM city_population)
select distinct state, [City Max(Population)], [City Min(Population)] from cte;
--, CTE2 AS(
--SELECT *, row_number() OVER(PARTITION BY state ORDER BY (SELECT NULL)) AS RN
--FROM CTE)
--select * from cte2

--SELECT state, [City Max(Population)], [City Min(Population)]
--FROM CTE2
--WHERE RN = 1

-----------------------------

CREATE TABLE dbo.events (
ID int,
event varchar(255),
YEAR INt,
GOLD varchar(255),
SILVER varchar(255),
BRONZE varchar(255)
);

-- delete from events;

INSERT INTO events VALUES (1,'100m',2016, 'Amthhew Mcgarray','donald','barbara');
INSERT INTO events VALUES (2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith');
INSERT INTO events VALUES (3,'500m',2016, 'Charles','Nichole','Susana');
INSERT INTO events VALUES (4,'100m',2016, 'Ronald','maria','paula');
INSERT INTO events VALUES (5,'200m',2016, 'Alfred','carol','Steven');
INSERT INTO events VALUES (6,'500m',2016, 'Nichole','Alfred','Brandon');
INSERT INTO events VALUES (7,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (8,'200m',2016, 'Thomas','Dawn','catherine');
INSERT INTO events VALUES (9,'500m',2016, 'Thomas','Dennis','paula');
INSERT INTO events VALUES (10,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (11,'200m',2016, 'jessica','Donald','Stefeney');
INSERT INTO events VALUES (12,'500m',2016,'Thomas','Steven','Catherine');

select * from events

with cte as(
select *,
count(*) over(partition by gold order by id) rn
from events
)
select * from cte;
select gold, max(rn) as Medal_count from cte 
where gold not in (select bronze from events union all select silver from events)
group by gold;

create table dbo.tickets
(
ticket_id varchar(10),
create_date date,
resolved_date date
);
delete from tickets;
insert into tickets values
(1,'2022-08-01','2022-08-03')
,(2,'2022-08-01','2022-08-12')
,(3,'2022-08-01','2022-08-16');
create table holidays
(
holiday_date date
,reason varchar(100)
);
delete from holidays;
insert into holidays values
('2022-08-11','Rakhi'),('2022-08-15','Independence day');

select * from tickets;

select * from holidays;

with cte as(
select ticket_id, create_date, resolved_date,holiday_date,
count(holiday_date) over(partition by ticket_id, create_date, resolved_date) as holiday_count
from tickets t left join holidays h on h.holiday_date between t.create_date and t.resolved_date
),
cte2 as (
select *,
(case
	when datename(weekday, holiday_date) = 'Sunday' then holiday_count-1
	when datename(weekday, holiday_date) = 'Saturday' then holiday_count-1
	else holiday_count
end
) as weekend_holiday_count,
row_number() over(partition by ticket_id, create_date, resolved_date order by ticket_id) rn
from cte
),
cte3 as (
select *,
row_number() over (partition by ticket_id, create_date, resolved_date order by rn desc) rn_actual
from cte2
)
select distinct ticket_id, create_date, resolved_date,
datediff(day,create_date, resolved_date) - 2*(datediff(week,create_date, resolved_date)) - weekend_holiday_count as Business_day 
from cte3 where rn_actual =1

select *, datename(weekday, holiday_date) weekday from holidays;

update holidays set holiday_date = '2022-08-14' where holiday_date = '2022-08-15'
update holidays set holiday_date = '2022-08-13' where holiday_date = '2022-08-11'
--datediff(day,create_date, resolved_date) as Actual_Date,
--datediff(week,create_date, resolved_date) as week_diff,

-----------------------
create table hospital ( emp_id int
, action varchar(10)
, time datetime);

insert into hospital values ('1', 'in', '2019-12-22 09:00:00');
insert into hospital values ('1', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:00:00');
insert into hospital values ('2', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:30:00');
insert into hospital values ('3', 'out', '2019-12-22 09:00:00');
insert into hospital values ('3', 'in', '2019-12-22 09:15:00');
insert into hospital values ('3', 'out', '2019-12-22 09:30:00');
insert into hospital values ('3', 'in', '2019-12-22 09:45:00');
insert into hospital values ('4', 'in', '2019-12-22 09:45:00');
insert into hospital values ('5', 'out', '2019-12-22 09:40:00');
with cte as(
select emp_id,
max(case when action = 'in' then time end) as intime,
max(case when action = 'out' then time end) as outtime
from hospital
group by emp_id
)
select * from cte where intime > outtime or outtime is null
-------------------

create table airbnb_searches 
(
user_id int,
date_searched date,
filter_room_types varchar(200)
);
-- delete from airbnb_searches;
insert into airbnb_searches values
(1,'2022-01-01','entire home,private room')
,(2,'2022-01-02','entire home,shared room')
,(3,'2022-01-02','private room,shared room')
,(4,'2022-01-03','private room');

-- select STRING_SPLIT(filter_room_types, ',') from airbnb_searches;

with cte as(
SELECT * from airbnb_searches
 Cross apply STRING_SPLIT(filter_room_types, ',')
 )
 select value as Room_Type, count(value) No_of_Search from cte
 group by value
 order by count(value) desc;

 ---------------------------------

 create table orders(
 order_id  int primary key,
 customer_id int,
 order_date date,
 order_amount int,
 department_id int
 );

 create table departments(
 department_id int,
 department_name nvarchar(255)
 );

 create table customers(
 customer_id int,
 last_name nvarchar(255),
 first_name nvarchar(255)
 );

 insert into departments values (1, 'Electronics'),
 (2, 'Hardware'),
 (3, 'Software');

 select * from departments;

 insert into customers values (1, 'Giri', 'Somshubhra'),
 (2, 'Saha', 'Ritwik'),
 (3, 'Patra', 'Subhajit');

 select * from customers;

 insert into orders values (8, 2, '2022-09-12', 7800, 1),
 (2, 1, '2021-03-14', 5600, 2),
 (3, 2, '2022-09-12', 7800, 1),
 (4, 3, '2020-03-14', 76909, 3),
 (5, 3, '2020-07-18', 76909, 2);

 select * from orders;
 select * from customers;
 select * from departments;

 with cte as(
 select o.department_id, o.customer_id, o.order_date, c.first_name, c.last_name
 from orders o join customers c on c.customer_id = o.customer_id
 where year(order_date) = '2021'
 )
  select department_name, count(c.department_id) from cte c join departments d on d.department_id = c.department_id
  group by department_name
 -- select * from cte

 select department_name, count(department_name) as Customers_Number from departments where department_id in (select department_id from cte )
 group by department_name;

 select dateadd(day,-10,getdate())

 select * from orders where order_date between dateadd(day,-10,(select max(order_date) from orders)) 
 and (select max(order_date) from orders);