-- This SQL query is for exploring sales data and comparing it to budget data.

-- Check first 10 rows to get an understanding of the sales table.
select * from sales_table
limit 10;


-- Check first 10 rows to get an understanding of the budget table.
select * from budget_table
limit 10;

-- Calculate number of sales and sales sum per year.
select left(sale_date, 4) as sale_year,
	count(sale_id) as number_of_sales,
	round(sum(quantity * unit_price * (1-discount))) as sale_sum
from sales_table
group by sale_year
order by sale_year asc;


-- Compare sales sum per year to budget sum per year.
-- Create a table for annual budget sum.
with b as (
	select left(budget_date, 4) as budget_year,
	round(sum(budget_sum)) as budget_sum
	from budget_table
	group by budget_year
	)
-- Create a table for annual sale sum.
,s as (
	select left(sale_date, 4) as sale_year,
	round(sum(quantity * unit_price * (1-discount))) as sale_sum
	from sales_table
	group by sale_year
	)
-- Select the annual budget sum and annual sale sum into one table and compare the results.
select b.budget_year, b.budget_sum, s.sale_sum, s.sale_sum - b.budget_sum as difference_from_budget
from b
left join s on b.budget_year = s.sale_year;

--How many sales have quantity higher than 5?
select count(sale_id)
from sales_table
where quantity > 5;  

--What is the average, minimum and maximum quantity sold by product in 2025?
select product_id, round(avg(quantity)), min(quantity), max(quantity)
from sales_table
where sale_date >= '2025-01-01' 
group by product_id;  