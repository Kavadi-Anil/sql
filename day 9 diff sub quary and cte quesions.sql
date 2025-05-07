

1- write a query to find premium customers from orders data. Premium customers are those who have done more orders than average no of orders per customer. 
=============================================================================================================================================================

only using sub quary
---------------------
SELECT 
    Customer_Name,
    COUNT(order_id) AS total_orders_per_customers
FROM 
    Orders
GROUP BY 
    Customer_Name
HAVING 
    COUNT(order_id) > (
        --------------------------------------------
        -- Subquery: Calculates average orders per customer
        --------------------------------------------
        SELECT 
            AVG(total_orders_per_customerss)
        FROM (
            --------------------------------------------
            -- Inner Subquery: Counts orders per customer
            --------------------------------------------
            SELECT  
                COUNT(order_id) AS total_orders_per_customerss
            FROM 
                Orders
            GROUP BY 
                Customer_Name
        ) AS orders_counts
    )
ORDER BY 
    total_orders_per_customers DESC; 





✅ With CTE – Clean Version
------------------------------
WITH orders_count AS ( 
    SELECT  
        Customer_Name,
        COUNT(order_id) AS total_orders_per_customerss
    FROM 
        Orders
    GROUP BY 
        Customer_Name
)

SELECT 
    *  
FROM 
    orders_count  
WHERE  
    total_orders_per_customerss > (
        SELECT 
            AVG(total_orders_per_customerss) 
        FROM  
            orders_count
    )
ORDER BY  
    total_orders_per_customerss DESC;



2- write a query to find employees whose salary is more than average salary of employees in their department
=================================================================================================================

-- ✅ 1. Using Subquery + Join
SELECT * 
FROM employee AS E
INNER JOIN (
    SELECT 
        dept_id, 
        AVG(salary) AS avg_salary_dept_wise
    FROM employee 
    GROUP BY dept_id
) AS G
ON E.dept_id = G.dept_id
WHERE E.salary > G.avg_salary_dept_wise;


-- ✅ 2. Using CTE + Join
WITH cte AS (
    SELECT 
        dept_id, 
        AVG(salary) AS avg_salary_dept_wise
    FROM employee 
    GROUP BY dept_id
)
SELECT * 
FROM employee AS E
INNER JOIN cte
    ON E.dept_id = cte.dept_id 
WHERE E.salary > avg_salary_dept_wise;


-- ❌ Invalid: Window function inside WHERE (will throw error)
-- SQL does not allow window functions in WHERE clause
-- because WHERE is evaluated before window functions.
-- The following will NOT work:

-- SELECT *,
--        AVG(salary) OVER (PARTITION BY dept_id) AS avg_salary_dept_wise
-- FROM employee 
-- WHERE salary > AVG(salary) OVER (PARTITION BY dept_id);


-- ✅ 3. Using Window Function (Subquery Wrapper)
SELECT *
FROM (
    SELECT *,
           AVG(salary) OVER (PARTITION BY dept_id) AS avg_salary_dept_wise
    FROM employee
) AS emp_with_avg
WHERE salary > avg_salary_dept_wise;


-- ✅ 4. Using Window Function (CTE Version)
WITH emp_with_avg AS (
    SELECT *,
           AVG(salary) OVER (PARTITION BY dept_id) AS avg_salary_dept_wise
    FROM employee
)
SELECT *
FROM emp_with_avg
WHERE salary > avg_salary_dept_wise;






3- write a query to find employees whose age is more than average age of all the employees.
====================================================================================================

-- ✅ Using Subquery
-- Get employees whose age is greater than the average age
SELECT * 
FROM employee 
WHERE emp_age > (
    SELECT AVG(emp_age) 
    FROM employee
);


-- ✅ Using Window Function + CTE
-- Add average age as a column, then filter those older than average
WITH cte AS (
    SELECT *, 
           AVG(emp_age) OVER () AS avg_age
    FROM employee
)
SELECT * 
FROM cte 
WHERE emp_age > avg_age;






4- write a query to print emp name, salary and dep id of highest salaried employee in each department  
============================================================================================================


-- ✅ 1. Using Subquery + Join
SELECT 
    emp_name,
    salary,
    E.dept_id,
    highest_salary_dept_wise
FROM employee AS E
INNER JOIN (
    SELECT  
        dept_id, 
        MAX(salary) AS highest_salary_dept_wise 
    FROM employee 
    GROUP BY dept_id
) AS GP 
ON E.dept_id = GP.dept_id
WHERE salary = highest_salary_dept_wise;


-- ✅ 2. Using CTE + Join
WITH cte AS (
    SELECT  
        dept_id, 
        MAX(salary) AS highest_salary_dept_wise 
    FROM employee 
    GROUP BY dept_id
)
SELECT 
    emp_name,
    salary,
    E.dept_id,
    highest_salary_dept_wise
FROM employee AS E
INNER JOIN cte 
    ON E.dept_id = cte.dept_id
WHERE salary = highest_salary_dept_wise;


-- ✅ 3. Using Window Function
WITH cte AS (
    SELECT *, 
           MAX(salary) OVER (PARTITION BY dept_id) AS highest_salary_dept_wise
    FROM employee
)
SELECT 
    emp_name,
    salary,
    dept_id,
    highest_salary_dept_wise
FROM cte
WHERE salary = highest_salary_dept_wise;


-- 📋 Summary:

-- | Approach          | Works Correctly? | Notes                         |
-- |-------------------|------------------|-------------------------------|
-- | Subquery + Join   | ✅               | Classic approach              |
-- | CTE + Join        | ✅               | Cleaner with same logic       |
-- | Window Function   | ✅               | Most efficient and modern     |




5- write a query to print emp name, salary and dep id of highest salaried overall 
===================================================================================

-- ✅ 1. Using Subquery
SELECT emp_name, salary, dept_id
FROM employee
WHERE salary = (
    SELECT MAX(salary)
    FROM employee
);


-- ✅ 2. Using CTE
WITH cte AS (
    SELECT MAX(salary) AS highest_salary
    FROM employee
)
SELECT emp_name, salary, dept_id
FROM employee, cte
WHERE employee.salary = cte.highest_salary;


-- ✅ 3. Using Window Function
WITH cte AS (
    SELECT *,
           MAX(salary) OVER () AS highest_salary
    FROM employee
)
SELECT emp_name, salary, dept_id
FROM cte
WHERE salary = highest_salary;


-- 📋 Summary:

-- | Approach          | Works Correctly? | Notes                         |
-- |-------------------|------------------|-------------------------------|
-- | Subquery          | ✅               | Simple and direct             |
-- | CTE               | ✅               | Clean separation of logic     |
-- | Window Function   | ✅               | Efficient for more complex queries

6- write a query to print product id and total sales of highest selling products (by no of units sold) in each category
==============================================================================================================================

WITH product_quantity AS (
    SELECT 
        category,
        product_id,
        SUM(quantity) AS total_quantity
    FROM orders 
    GROUP BY category, product_id
),
cat_max_quantity AS (
    SELECT 
        category,
        MAX(total_quantity) AS max_quantity 
    FROM product_quantity 
    GROUP BY category
)
SELECT *
FROM product_quantity pq
INNER JOIN cat_max_quantity cmq 
    ON pq.category = cmq.category
WHERE pq.total_quantity = cmq.max_quantity;





