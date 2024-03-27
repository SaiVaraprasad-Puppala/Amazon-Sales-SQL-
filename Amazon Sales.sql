use portfolio;

CREATE TABLE IF NOT EXISTS amazon(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    vat FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_percentage FLOAT(11,9),
    gross_income DECIMAL(10, 4),
    rating FLOAT(2, 1)
);


-------------------------------------------- Feature Engineering ----------------------------------------------
-- Time-of-day --
select time,
	case when time between "00:00:00" and "11:59:59" then "Morning" 
         when time between "12:00:00" and "16:00:00" then "Afteroon"
         else "Evening" 
         end as time_of_day
    from amazon;

-- Adding a new column
ALTER TABLE amazon
ADD COLUMN time_of_day varchar(20);

-- updating the values in to the column
UPDATE amazon
SET time_of_day = (case when `time` between "00:00:00" and "11:59:59" then "Morning" 
                        when `time` between "12:00:00" and "16:00:00" then "Afteroon"
                        else "Evening" 
                        end);


-- Day Name --
select date,dayname(date) from amazon;

-- Adding a new column
ALTER TABLE amazon
ADD COLUMN day_name VARCHAR(10);


-- -- updating the values in to the column
UPDATE amazon
SET day_name = dayname(date);

-- Month name --
select monthname(date) from amazon;

-- Ading a new column 
ALTER TABLE amazon
ADD COLUMN month_name VARCHAR(10);

-- updating values in to the column
UPDATE amazon
SET month_name = monthname(date);
-- ------------------------------------------------------------------------------------------------

-- What is the count of distinct cities in the dataset?
select count(distinct city) from amazon;

-- For each branch, what is the corresponding city?
select distinct branch , city from amazon;

-- What is the count of distinct product lines in the dataset?
select  count(distinct product_line) from amazon;

-- Which payment method occurs most frequently?
select payment ,count(*) as No_of_times
from amazon
group by payment
order by No_of_times desc ;

-- Which product line has the highest sales?
select product_line,round(sum(total),2)as total_sales
from amazon
group by product_line
order by total_sales desc;

-- How much revenue is generated each month?
select month_name ,round(sum(total),2) as total_sales
from amazon 
group by month_name
order by FIELD(month_name, 'January', 'February', 'March');

-- In which month did the cost of goods sold reach its peak?
select month_name , sum(cogs) as cogs
from amazon 
group by month_name
order by cogs desc 
limit 1;

-- Which product line generated the highest revenue?
select product_line , sum(total) as revenue 
from amazon 
group by product_line 
order by revenue desc ;

-- In which city was the highest revenue recorded?
select city , round(sum(total)) as revenue 
from amazon 
group by  city 
order by revenue desc ;

-- Which product line incurred the highest Value Added Tax?
select product_line , max(vat) as vat
from amazon 
group by product_line
order by vat desc ; 

-- For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
select product_line ,
case when total > (select avg(total) as avg_sales from amazon) then "good"
	else "bad"
    end as sales_quality
from amazon
order by product_line asc ;

-- ------------------------------- OR ------------------------------------------- 
SELECT
    product_line,
    total,
    CASE
        WHEN total > AVG(total) OVER (PARTITION BY product_line) THEN 'Good'
        ELSE 'Bad'
    END AS sales_quality
FROM
    amazon
ORDER BY
    product_line ASC;


-- Identify the branch that exceeded the average number of products sold.
select branch , sum(quantity) as products_sold
from amazon 
group by branch 
having products_sold > (select avg(quantity) from amazon) ;

-- Which product line is most frequently associated with each gender?
with gender as (
select product_line , 
sum(case when gender = 'male' then 1 else 0 end ) as male_count,
sum(case when gender = 'female' then 1 else 0 end ) as female_count
from amazon
group by product_line )

select product_line,
case when male_count > female_count then 'male'
else 'female'
end as most_frequent_gender
from gender;

select * from amazon;














