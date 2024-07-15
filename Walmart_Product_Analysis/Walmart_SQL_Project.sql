--select * from walmart_sql_project..walmartsalesdata

--------------------Create new time_of_day column---------------------------

alter table walmart_sql_project..walmartsalesdata alter column
Time time;

--Checking the data for time_of_day column

select Time, (
CASE
 WHEN Time between '00:00:00' and '12:00:00' THEN 'Morning'
 WHEN Time between '12:01:00' and '16:00:00' THEN 'Afternoon'
 ELSE 'Evening'
END
) as time_of_day from walmart_sql_project..walmartsalesdata

--Create time_of_day column in existing table

ALTER table walmart_sql_project..walmartsalesdata add time_of_day nvarchar(255)

--Update new column "time_of_day"

UPDATE walmart_sql_project..walmartsalesdata SET time_of_day = (
CASE
 WHEN Time between '00:00:00' and '12:00:00' THEN 'Morning'
 WHEN Time between '12:01:00' and '16:00:00' THEN 'Afternoon'
 ELSE 'Evening'
END
)

------------------------- Create "day_name" Column -------------------------------

--select format(date,'ddd') as day from walmart_sql_project..walmartsalesdata
--select DATENAME(w,date) as day from walmart_sql_project..walmartsalesdata

--Create day_name column in existing table

ALTER table walmart_sql_project..walmartsalesdata add day_name nvarchar(255)

--Update data in day_name new column

UPDATE walmart_sql_project..walmartsalesdata SET day_name = format(date,'ddd')

------------------------- Create "month_name" Column -------------------------------

--Create month_name column in existing table

ALTER table walmart_sql_project..walmartsalesdata add month_name nvarchar(255)

--Update data in month_name new column

UPDATE walmart_sql_project..walmartsalesdata SET month_name = format(date,'MMM')


---------------------------Generic Question-------------------------------------

--How many unique cities does the data have?
select count(distinct city) as "Unique_City" from walmart_sql_project..walmartsalesdata

--Ans: 3 unique Cities are present in this Dataset.

--In which city is each branch?

select distinct city, Branch from walmart_sql_project..walmartsalesdata;

/* Ans: 
city	Branch
Mandalay	B
Naypyitaw	C
Yangon	    A
*/

------------------------------------ Product Related Analysis ----------------------------------------

select * from walmart_sql_project..walmartsalesdata;

--How many unique product lines does the data have?

select count(distinct "Product line") as "Unique_Product_Line" from walmart_sql_project..walmartsalesdata;

--Ans: 6 Unique Product Lines are present in this Dataset.

--What is the most common payment method?

select top 1 payment, count("Invoice ID") as "Total_Count" from walmart_sql_project..walmartsalesdata
group by payment order by count("Invoice ID") desc;

--Ans: Ewallet is the most common Payment method.

--What is the most selling product line?
select top 1 "product line", sum(Quantity) as "Total_Quantity" from walmart_sql_project..walmartsalesdata
group by "product line" order by sum(Quantity) desc;

--Ans: Electronic accessories is most selling product line

--What is the total revenue by month?

select  month_name, round(sum(Total),2) as "Total_Revenue" from walmart_sql_project..walmartsalesdata
group by month_name order by sum(Total) desc;

/* Ans: 
month_name	Total_Revenue
Jan	116291.87
Mar	109455.51
Feb	97219.37
*/

--What month had the largest COGS?

select top 1 month_name, round(sum(cogs),2) as "Total_cogs" from walmart_sql_project..walmartsalesdata
group by month_name order by sum(cogs) desc;

--Ans: Jan month had the largest GOGS.

--What product line had the largest revenue?

select top 1 "Product line", round(sum(Total),2) as "Total_Revenue" from walmart_sql_project..walmartsalesdata
group by "Product line" order by sum(Total) desc;

--Ans: Food and beverages had the largest with 56144.84 revenue.

--What is the city with the largest revenue?

select top 1 City, round(sum(Total),2) as "Total_Revenue" from walmart_sql_project..walmartsalesdata
group by City order by sum(Total) desc;

--Ans: Naypyitaw is the city with the largest revenue.

--What product line had the largest VAT?

select top 1 "Product line", round(sum([Tax 5%]),2) as "Total_VAT" from walmart_sql_project..walmartsalesdata
group by [Product line] order by sum([Tax 5%]) desc;

--Ans: Food and beverages had the largest VAT.

--Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

select AVG(Quantity) from walmart_sql_project..walmartsalesdata


select "product line",
(case
when AVG(Quantity) > 5.5 then 'Good'
else 'Bad'
end) as remark from walmart_sql_project..walmartsalesdata 
group by "product line"

--Which branch sold more products than average product sold?

select branch, sum(quantity) "Total Sold" from walmart_sql_project..walmartsalesdata group by branch
having sum(quantity) > (select AVG(Quantity) from walmart_sql_project..walmartsalesdata) order by sum(quantity);

-- Ans: B branch sold more products than average product sold.

--What is the most common product line by gender?

select Gender, "Product line",  COUNT(Gender) "Count of Gender" from walmart_sql_project..walmartsalesdata
group by [Product line],Gender order by COUNT(Gender) desc;

--What is the average rating of each product line?
select "Product line",  round(avg(Rating),3) "Avg Rating" from walmart_sql_project..walmartsalesdata
group by [Product line] order by avg(Rating) desc;
