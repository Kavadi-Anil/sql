🔹 SQL Tip: Unlock the Power of LAG() Function! 🔹

Ever needed to compare a row with the previous one in SQL?
Instead of messy subqueries — meet your new friend: LAG()!

✅ What does LAG() do?
It allows you to access a value from a previous row without self-joins.

✅ Syntax:
LAG(column_name, offset, default_value) OVER (PARTITION BY ... ORDER BY ...)

Mastering window functions like LAG() makes your SQL smarter, faster, and cleaner. 💡

#SQL #DataEngineering #WindowFunctions #SQLTips #LearningEveryday


SELECT * FROM employee;

emp_id   emp_name   dept_id   salary   manager_id   emp_age   dob
---------------------------------------------------------------
1        Ankit      100       10000    4            39        1986-04-16
2        Mohit      100       15000    5            48        1977-04-16
3        Vikas      100       10000    4            37        1988-04-16
4        Rohit      100       5000     2            16        2009-04-16
5        Mudit      200       12000    6            55        1970-04-16
6        Agam       200       12000    2            14        2011-04-16
7        Sanjay     200       9000     2            13        2012-04-16
8        Ashish     200       5000     2            12        2013-04-16
9        Mukesh     300       6000     6            51        1974-04-16
10       Rakesh     500       7000     6            50        1975-04-16
11       Ramesh     300       5000     6            18        2007-04-16  







-- ✅ Using LEAD() to get next highest salary in descending salary order

SELECT 
    emp_id,
    emp_name,
    dept_id,
    salary,
    LEAD(salary, 1) OVER (ORDER BY salary DESC) AS salary_desc_lead
FROM employee;

-- 🧾 Output:

emp_id   emp_name   dept_id   salary   salary_desc_lead
--------------------------------------------------------
2        Mohit      100       15000    12000
5        Mudit      200       12000    12000
6        Agam       200       12000    10000
3        Vikas      100       10000    10000
1        Ankit      100       10000    9000
7        Sanjay     200       9000     7000
10       Rakesh     500       7000     6000
9        Mukesh     300       6000     5000
4        Rohit      100       5000     5000
8        Ashish     200       5000     5000
11       Ramesh     300       5000     NULL

-- 🧠 Explanation:
LEAD() is a window function that allows you to look forward in the result set.
- Here, we are ordering by salary in descending order.
- LEAD(salary,1) brings the **next lower salary** next to the current employee.
- When there is no next salary available (like for the last employee), it returns NULL.

✅ Very useful when you want to compare current and next values without messy joins! 




-- ✅ Using LEAD() to get next highest salary within each department

SELECT 
    emp_id,
    emp_name,
    dept_id,
    salary,
    LEAD(salary, 1) OVER (PARTITION BY dept_id ORDER BY salary DESC) AS salary_desc_lead
FROM employee;

-- 🧾 Output:

emp_id   emp_name   dept_id   salary   salary_desc_lead
--------------------------------------------------------
2        Mohit      100       15000    10000
3        Vikas      100       10000    10000
1        Ankit      100       10000    5000
4        Rohit      100       5000     NULL
5        Mudit      200       12000    12000
6        Agam       200       12000    9000
7        Sanjay     200       9000     5000
8        Ashish     200       5000     NULL
9        Mukesh     300       6000     5000
11       Ramesh     300       5000     NULL
10       Rakesh     500       7000     NULL

-- 🧠 Explanation:
LEAD() is used here along with PARTITION BY dept_id.
- It means within each department (dept_id), find the next lower salary.
- ORDER BY salary DESC ensures we look from highest to lowest salary within each department.
- NULL appears when there is no lower salary available within the department.

✅ This helps compare employees' salaries inside their own departments easily without complicated joins!




-- ✅ Using LEAD() to get next highest salary within each department, with default value for NULLs

SELECT 
    emp_id,
    emp_name,
    dept_id,
    salary,
    LEAD(salary, 1, 100) OVER (PARTITION BY dept_id ORDER BY salary DESC) AS salary_desc_lead
FROM employee;

-- 🧾 Output:

emp_id   emp_name   dept_id   salary   salary_desc_lead
--------------------------------------------------------
2        Mohit      100       15000    10000
3        Vikas      100       10000    10000
1        Ankit      100       10000    5000
4        Rohit      100       5000     100
5        Mudit      200       12000    12000
6        Agam       200       12000    9000
7        Sanjay     200       9000     5000
8        Ashish     200       5000     100
9        Mukesh     300       6000     5000
11       Ramesh     300       5000     100
10       Rakesh     500       7000     100

-- 🧠 Explanation:
LEAD() normally returns NULL when no next row exists.
- Here, by providing a third argument (`100`), we replace the NULLs with a **default value of 100**.
- So, if no next lower salary exists in the department, it shows `100` instead of NULL.

✅ This makes the data cleaner, avoids NULL handling later, and can be used for default calculations easily!





-- ✅ Using LAG() to get previous higher salary in descending salary order

SELECT 
    emp_id,
    emp_name,
    dept_id,
    salary,
    LAG(salary, 1) OVER (ORDER BY salary DESC) AS salary_desc_lead
FROM employee;

-- 🧾 Output:

emp_id   emp_name   dept_id   salary   salary_desc_lead
--------------------------------------------------------
2        Mohit      100       15000    NULL
5        Mudit      200       12000    15000
6        Agam       200       12000    12000
3        Vikas      100       10000    12000
1        Ankit      100       10000    10000
7        Sanjay     200       9000     10000
10       Rakesh     500       7000     9000
9        Mukesh     300       6000     7000
4        Rohit      100       5000     6000
8        Ashish     200       5000     5000
11       Ramesh     300       5000     5000

-- 🧠 Explanation:
LAG() is a window function that looks backward from the current row.
- Here, we are ordering by salary descending (highest to lowest).
- LAG(salary,1) brings the **previous higher salary** next to the current employee's salary.
- NULL appears for the top salary (because there is no higher salary before it).

✅ Very useful when comparing a value with its previous one in a sorted order (e.g., salary drop, sales trends)!



-- ✅ Using LAG() to get previous higher salary within each department

SELECT 
    emp_id,
    emp_name,
    dept_id,
    salary,
    LAG(salary, 1) OVER (PARTITION BY dept_id ORDER BY salary DESC) AS salary_desc_lead
FROM employee;

-- 🧾 Output:

emp_id   emp_name   dept_id   salary   salary_desc_lead
--------------------------------------------------------
2        Mohit      100       15000    NULL
3        Vikas      100       10000    15000
1        Ankit      100       10000    10000
4        Rohit      100       5000     10000
5        Mudit      200       12000    NULL
6        Agam       200       12000    12000
7        Sanjay     200       9000     12000
8        Ashish     200       5000     9000
9        Mukesh     300       6000     NULL
11       Ramesh     300       5000     6000
10       Rakesh     500       7000     NULL

-- 🧠 Explanation:
- LAG() looks backward within each department (partition by dept_id).
- The salary is ordered descendingly within each department.
- LAG(salary, 1) brings the previous higher salary from the same department.
- NULL appears for the first (highest) salary in each department because there is no higher salary before it.

✅ Useful for salary progression analysis, promotion planning, or internal department ranking!
