use all_functions;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
select * from retail_sales;

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * 
from retail_sales 
where sale_date = "2022-11-05";

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
-- the quantity sold is more than 4 in the month of Nov-2022:
select *
from retail_sales 
where category = "Clothing" 
and extract(month from sale_date) = 11 
and quantity>=3;

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:
select 
category,
sum(total_sale) total_sale 
from retail_sales 
group by category;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select 
category, 
avg(age) avg_age 
from retail_sales
where category = "Beauty" 
group by category;

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * 
from retail_sales 
where total_sale >1000;
-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

select 
category,
sum(case when gender = "Male" then 1 else 0 end) Male_count,
sum(case when gender = "Female" then 1 else 0 end) Female_count
from retail_sales 
group by category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

select years,months, sale from (select 
extract(year from sale_date) years,
monthname(sale_date) months,
round(avg(total_sale),0) sale,
rank() over(partition by extract(year from sale_date) order by round(avg(total_sale),0) desc)  rn from retail_sales 
group by monthname(sale_date),extract(year from sale_date)) as rn1
where rn = 1
;
-- **Write a SQL query to find the top 5 customers based on the highest total sales **:
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;
-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

with CTE as (select *,
case 
	when extract(hour from sale_time)<12 then "morning"
	when extract(hour from sale_time) between 12 and 17 then "afternoon"
    else "evening"
    end as shift
from retail_sales
)
select shift , count(transactions_id) as count
from CTE
group by shift;






