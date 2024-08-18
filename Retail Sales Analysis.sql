--- SQL Retail Analysis - P1 ---
Create database sql_project_p1;

--- Create Table ---
Drop table if exists retail_sales;
Create table retail_sales 
				(
				transactions_id	int primary key,
				sale_date date,	
				sale_time time,	
				customer_id	int,
				gender varchar(50),	
				age	int,
				category varchar(50),	
				quantity int,
				price_per_unit	float,
				cogs float,
				total_sale float
				)


select * from retail_sales
limit 10;

select count(*) from retail_sales;


--- Data Cleaning ---
select * from retail_sales where quantiy is null;

alter table retail_sales rename column quantiy to quantity;

select * from retail_sales where quantity is null;

delete from retail_sales where quantity is null;

select * from retail_sales where quantity is null;

--- Data Exploration ---
--- How many sales we have? ---
select count(*) from retail_sales;

--- How many unique customers we have? ---
select count(distinct customer_id) from retail_sales;

select distinct category from retail_sales;

--- Data Analysis & Business Key Problems & Answers
--- Data Analysis & Findings

--- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select * from retail_sales 
where sale_date = '2022-11-05';

--- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select * from retail_sales 
where category like 'Clothing' and  
quantity >= 4 and 
to_char(sale_date, 'YYYY-MM') = '2022-11';

--- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:

select category, sum(total_sale) as net_sale, count(*) as total_orders from retail_sales
group by category;

--- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select round(avg(age),2) from retail_sales
where category = 'Beauty';

--- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select * from retail_sales
where total_sale > 1000;

--- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

select category, gender, count(transactions_id) from retail_sales 
group by category,gender
order by count(transactions_id) desc;

--- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

select * from
(
	select 
		extract(year from sale_date) as year,
		extract(month from sale_date) as month,
		avg(total_sale) as avg_sale,
		RANK() over(PARTITION by extract(year from sale_date) order by  avg(total_sale) desc) as rank
	from retail_sales
	group by year,month
)
where rank = 1;

--- 8. Write a SQL query to find the top 5 customers based on the highest total sales:

select customer_id, sum(total_sale) from retail_sales
group by customer_id
order by sum(total_sale) desc 
limit 5;


--- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:

select category, count(distinct customer_id) from retail_sales
group by category;

--- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

with hourly as
(
select *, case
	when extract(hour from sale_time) < 12 then 'Morning'
	when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
	end as shift
from retail_sales
)

select shift, count(*)
from hourly
group by shift


--- End of project





