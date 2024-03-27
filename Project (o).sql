USE portfolio;

CREATE TABLE IF NOT EXISTS amazon(
    INVOICE_ID VARCHAR(30) NOT NULL PRIMARY KEY,
    BRANCH VARCHAR(5) NOT NULL,
    CITY VARCHAR(30) NOT NULL,
    CUSTOMER_TYPE VARCHAR(30) NOT NULL,
    GENDER VARCHAR(30) NOT NULL,
    PRODUCT_LINE VARCHAR(100) NOT NULL,
    UNIT_PRICE DECIMAL(10,2) NOT NULL,
    QUANTITY INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    TOTAL DECIMAL(12, 4) NOT NULL,
    DATE DATETIME NOT NULL,
    TIME TIME NOT NULL,
    PAYMENT VARCHAR(15) NOT NULL,
    COGS DECIMAL(10,2) NOT NULL,
    GROSS_MARGIN_PERCENTAGE FLOAT(11,9),
    GROSS_INCOME DECIMAL(10, 4),
    RATING FLOAT(2, 1)
);

-- Time-of-day --
SELECT
    TIME,
    CASE 
        WHEN TIME BETWEEN "00:00:00" AND "11:59:59" THEN "Morning" 
        WHEN TIME BETWEEN "12:00:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening" 
    END AS TIME_OF_DAY
FROM
    AMAZON;

-- Adding a new column
ALTER TABLE AMAZON
ADD COLUMN TIME_OF_DAY VARCHAR(20);

-- Updating the values into the column
UPDATE AMAZON
SET TIME_OF_DAY = (CASE 
                    WHEN `TIME` BETWEEN "00:00:00" AND "11:59:59" THEN "Morning" 
                    WHEN `TIME` BETWEEN "12:00:00" AND "16:00:00" THEN "Afternoon"
                    ELSE "Evening" 
                    END);

-- Day Name --
SELECT 
    DATE,
    DAYNAME(DATE) 
FROM 
    AMAZON;

-- Adding a new column
ALTER TABLE AMAZON
ADD COLUMN DAY_NAME VARCHAR(10);

-- Updating the values into the column
UPDATE AMAZON
SET DAY_NAME = DAYNAME(DATE);

-- Month Name --
SELECT 
    MONTHNAME(DATE) 
FROM 
    AMAZON;

-- Adding a new column 
ALTER TABLE AMAZON
ADD COLUMN MONTH_NAME VARCHAR(10);

-- Updating values into the column
UPDATE AMAZON
SET MONTH_NAME = MONTHNAME(DATE);

-- What is the count of distinct cities in the dataset?
SELECT 
    COUNT(DISTINCT CITY) 
FROM 
    AMAZON;

-- For each branch, what is the corresponding city?
SELECT 
    DISTINCT BRANCH, 
    CITY 
FROM 
    AMAZON;

-- What is the count of distinct product lines in the dataset?
SELECT  
    COUNT(DISTINCT PRODUCT_LINE) 
FROM 
    AMAZON;

-- Which payment method occurs most frequently?
SELECT 
    PAYMENT, 
    COUNT(*) AS NO_OF_TIMES
FROM 
    AMAZON
GROUP BY 
    PAYMENT
ORDER BY 
    NO_OF_TIMES DESC ;

-- Which product line has the highest sales?
SELECT 
    PRODUCT_LINE,
    ROUND(SUM(TOTAL),2) AS TOTAL_SALES
FROM 
    AMAZON
GROUP BY 
    PRODUCT_LINE
ORDER BY 
    TOTAL_SALES DESC;

-- How much revenue is generated each month?
SELECT 
    MONTH_NAME,
    ROUND(SUM(TOTAL),2) AS TOTAL_SALES
FROM 
    AMAZON 
GROUP BY 
    MONTH_NAME
ORDER BY 
    FIELD(MONTH_NAME, 'January', 'February', 'March');

-- In which month did the cost of goods sold reach its peak?
SELECT 
    MONTH_NAME,
    SUM(COGS) AS COGS
FROM 
    AMAZON 
GROUP BY 
    MONTH_NAME
ORDER BY 
    COGS DESC 
LIMIT 1;

-- Which product line generated the highest revenue?
SELECT 
    PRODUCT_LINE, 
    SUM(TOTAL) AS REVENUE 
FROM 
    AMAZON 
GROUP BY 
    PRODUCT_LINE 
ORDER BY 
    REVENUE DESC ;

-- In which city was the highest revenue recorded?
SELECT 
    CITY, 
    ROUND(SUM(TOTAL)) AS REVENUE 
FROM 
    AMAZON 
GROUP BY  
    CITY 
ORDER BY 
    REVENUE DESC ;

-- Which product line incurred the highest Value Added Tax?
SELECT 
    PRODUCT_LINE, 
    MAX(VAT) AS VAT
FROM 
    AMAZON 
GROUP BY 
    PRODUCT_LINE
ORDER BY 
    VAT DESC ; 

-- For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
SELECT 
    PRODUCT_LINE,
    CASE 
        WHEN SUM(TOTAL) > (SELECT AVG(TOTAL) AS AVG_SALES FROM AMAZON) THEN 'Good'
        ELSE 'Bad'
    END AS SALES_QUALITY
FROM 
    AMAZON
GROUP BY 
    PRODUCT_LINE;


-- Identify the branch that exceeded the average number of products sold.
SELECT 
    BRANCH, 
    SUM(QUANTITY) AS PRODUCTS_SOLD
FROM 
    AMAZON 
GROUP BY 
    BRANCH 
HAVING 
    PRODUCTS_SOLD > (SELECT AVG(QUANTITY) FROM AMAZON) ;

-- Which product line is most frequently associated with each gender?
WITH GENDER AS (
    SELECT 
        PRODUCT_LINE , 
        SUM(CASE WHEN GENDER = 'male' THEN 1 ELSE 0 END ) AS MALE_COUNT,
        SUM(CASE WHEN GENDER = 'female' THEN 1 ELSE 0 END) AS FEMALE_COUNT
    FROM 
        AMAZON
    GROUP BY 
        PRODUCT_LINE 
)

SELECT 
    PRODUCT_LINE,
    CASE 
        WHEN MALE_COUNT > FEMALE_COUNT THEN 'Male'
        ELSE 'Female'
    END AS MOST_FREQUENT_GENDER
FROM 
    GENDER;

-- Calculate the average rating for each product line.
SELECT 
    PRODUCT_LINE , 
    ROUND(AVG(RATING),2) AS AVG_RATING
FROM 
    AMAZON
GROUP BY 
    PRODUCT_LINE
ORDER BY 
    AVG_RATING DESC ;

-- Count the sales occurrences for each time of day on every weekday.
SELECT 
    TIME_OF_DAY , 
    COUNT(TOTAL) AS SALES 
FROM 
    AMAZON 
WHERE 
    TIME_OF_DAY NOT IN ("Saturday","Sunday")
GROUP BY 
    TIME_OF_DAY ;

-- Identify the customer type contributing the highest revenue.
SELECT 
    CUSTOMER_TYPE , 
    ROUND(SUM(TOTAL),2) AS REVENUE 
FROM 
    AMAZON 
GROUP BY 
    CUSTOMER_TYPE
ORDER BY 
    REVENUE DESC  ; 

-- Determine the city with the highest VAT percentage.
SELECT 
    CITY , 
    MAX(VAT) AS VAT 
FROM 
    AMAZON 
GROUP BY 
    CITY 
ORDER BY 
    VAT DESC ;

-- Identify the customer type with the highest VAT payments.
SELECT 
    CUSTOMER_TYPE , 
    MAX(VAT) AS VAT 
FROM 
    AMAZON 
GROUP BY 
    CUSTOMER_TYPE 
ORDER BY 
    VAT DESC ;

-- What is the count of distinct customer types in the dataset?
SELECT 
    COUNT(DISTINCT CUSTOMER_TYPE) AS CNT_CUSTOMER_TYPE 
FROM 
    AMAZON;

-- What is the count of distinct payment methods in the dataset?
SELECT 
    COUNT(DISTINCT PAYMENT) AS METHOD_OF_PAYMENT
FROM 
    AMAZON ;

-- Which customer type occurs most frequently?
SELECT 
    CUSTOMER_TYPE , 
    COUNT(*) AS OCCURANCE_COUNT
FROM 
    AMAZON 
GROUP BY 
    CUSTOMER_TYPE
ORDER BY 
    OCCURANCE_COUNT DESC 
LIMIT 1 ;

-- Identify the customer type with the highest purchase frequency.
SELECT 
    CUSTOMER_TYPE , 
    COUNT(*) AS PURCHASE_FREQUENCY
FROM 
    AMAZON 
GROUP BY 
    CUSTOMER_TYPE
ORDER BY 
    PURCHASE_FREQUENCY DESC 
LIMIT 1 ;

-- Determine the predominant gender among customers.
SELECT 
    GENDER , 
    COUNT(GENDER) AS GENDER_CNT
FROM 
    AMAZON 
GROUP BY 
    GENDER 
ORDER BY 
    GENDER_CNT DESC 
LIMIT 1 ;

-- Examine the distribution of genders within each branch.
SELECT 
    BRANCH , 
    SUM(CASE WHEN GENDER = 'male' THEN 1 ELSE 0 END ) AS MALE_CNT,
    SUM(CASE WHEN GENDER = 'female' THEN 1 ELSE 0 END) AS FEMALE_CNT
FROM 
    AMAZON 
GROUP BY 
    BRANCH ;

-- Identify the time of day when customers provide the most ratings.
SELECT 
    TIME_OF_DAY , 
    COUNT(RATING) AS RATING_CNT
FROM 
    AMAZON 
GROUP BY 
    TIME_OF_DAY
ORDER BY 
    RATING_CNT DESC ;

-- Determine the time of day with the highest customer ratings for each branch.
WITH CTE AS (
    SELECT 
        BRANCH ,
        TIME_OF_DAY , 
        COUNT(RATING) AS RATING_CNT, 
        ROW_NUMBER() OVER(PARTITION BY BRANCH ORDER BY COUNT(RATING) DESC) AS RN
    FROM 
        AMAZON 
    GROUP BY 
        BRANCH , 
        TIME_OF_DAY
    ORDER BY 
        BRANCH,
        RATING_CNT DESC 
)

SELECT 
    BRANCH , 
    TIME_OF_DAY , 
    RATING_CNT
FROM 
    CTE 
WHERE 
    RN = 1;

-- Identify the day of the week with the highest average ratings.
SELECT 
    DAY_NAME , 
    AVG(RATING) AS MAX_AVG_RATING
FROM 
    AMAZON 
GROUP BY 
    DAY_NAME 
ORDER BY 
    MAX_AVG_RATING DESC 
LIMIT 1 ;

-- Determine the day of the week with the highest average ratings for each branch.
WITH CTE AS (
    SELECT 
        BRANCH,
        DAY_NAME , 
        AVG(RATING) AS MAX_AVG_RATING, 
        ROW_NUMBER() OVER(PARTITION BY BRANCH ORDER BY AVG(RATING) DESC) AS RN
    FROM 
        AMAZON 
    GROUP BY 
        BRANCH,
        DAY_NAME 
    ORDER BY 
        BRANCH,
        MAX_AVG_RATING DESC 
)

SELECT 
    BRANCH,
    DAY_NAME,
    MAX_AVG_RATING 
FROM 
    CTE 
WHERE 
    RN = 1;




