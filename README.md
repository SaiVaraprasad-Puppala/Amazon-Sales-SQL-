# Amazon Sales Data Analysis

## Purpose
The primary objective of this project is to gain insights into the sales data of Amazon, specifically focusing on understanding the various factors influencing sales across different branches.

## About the Data
The dataset contains sales transactions from three different branches of Amazon, located in Mandalay, Yangon, and Naypyitaw. It consists of 17 columns and 1000 rows, detailing various aspects of each transaction, such as invoice ID, branch, city, customer type, product line, sales quantity, pricing, tax information, date, time, payment method, cost of goods sold, gross margin percentage, gross income, and rating.

## Analysis List
### Product Analysis
- Analyze different product lines, identifying top-performing and underperforming ones.
### Sales Analysis
- Understand sales trends to evaluate the effectiveness of sales strategies and identify areas for improvement.
### Customer Analysis
- Uncover customer segments, purchase trends, and segment profitability.

## Approach Used
### Data Wrangling
- Inspection of data to handle NULL values and missing values.
- Database creation and table insertion with NOT NULL constraints.

### Feature Engineering
- Creation of new columns to derive insights:
  - 'timeofday' to analyze sales patterns during different parts of the day.
  - 'dayname' to identify the busiest days of the week for each branch.
  - 'monthname' to determine sales and profit trends across different months.

### Exploratory Data Analysis (EDA)
- Conducted to answer specific business questions and achieve project objectives.

## Business Questions To Answer
1. Count of distinct cities in the dataset.
2. Corresponding city for each branch.
3. Count of distinct product lines.
4. Most frequently occurring payment method.
5. Product line with the highest sales.
6. Monthly revenue generation.
7. Peak month for cost of goods sold.
8. Product line generating the highest revenue.
9. City with the highest revenue.
10. Product line with the highest Value Added Tax (VAT).
11. Branch exceeding the average number of products sold.
12. Product line most associated with each gender.
13. Average rating for each product line.
14. Sales occurrences for each time of day on every weekday.
15. Customer type contributing the highest revenue.
16. City with the highest VAT percentage.
17. Customer type with the highest VAT payments.
18. Count of distinct customer types.
19. Count of distinct payment methods.
20. Most frequently occurring customer type.
21. Customer type with the highest purchase frequency.
22. Predominant gender among customers.
23. Distribution of genders within each branch.
24. Time of day when customers provide the most ratings.
25. Time of day with the highest customer ratings for each branch.
26. Day of the week with the highest average ratings.
27. Day of the week with the highest average ratings for each branch.

## Conclusion
This comprehensive analysis aims to provide actionable insights to optimize sales strategies, improve customer segmentation, and enhance overall business performance for Amazon across its branches.
