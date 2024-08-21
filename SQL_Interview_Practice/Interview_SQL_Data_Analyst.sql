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
select * from brand where brand not in (select brand from cte where flag =0)

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

