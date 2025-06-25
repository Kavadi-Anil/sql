# SQL Window Functions Notes (with Outputs Below Each Query)

---

## Sample Table

| emp_id | emp_name | dept_id | salary | manager_emp_id | emp_age | dob        |
|--------|----------|---------|--------|---------------|---------|------------|
| 1      | Ankit    | 100     | 10000  | 4             | 39      | 12/2/1983  |
| 2      | Mohit    | 100     | 15000  | 5             | 48      | 12/2/1974  |
| 3      | Vikas    | 100     | 10000  | 2             | 37      | 12/2/1985  |
| 4      | Rohit    | 100     | 5000   | 2             | 16      | 12/2/2006  |
| 5      | Mudit    | 200     | 12000  | 1             | 55      | 12/2/1967  |
| 6      | Agam     | 200     | 12000  | 2             | 14      | 12/2/2008  |
| 7      | Sanjay   | 200     | 9000   | 2             | 13      | 12/2/2009  |
| 8      | Ashish   | 200     | 5000   | 2             | 12      | 12/2/2010  |
| 9      | Mukesh   | 300     | 6000   | 6             | 51      | 12/2/1971  |
| 10     | Rakesh   | 700     | 7000   | 6             | 50      | 12/2/1972  |
| 11     | Ramesh   | 300     | 8000   | 6             | 52      | 12/2/1970  |

---

## 1. AVG Aggregation with Window Functions

```sql
SELECT *,
    SUM(salary) OVER(PARTITION BY dept_id) AS sum_salary,
    SUM(salary) OVER(PARTITION BY dept_id ORDER BY emp_id ASC) AS dep_running_salary,
    SUM(salary) OVER(ORDER BY emp_id ASC) AS dep_running_salary
FROM employee;
```

**Output:**

| emp_id | emp_name | dept_id | salary | manager_id | emp_age | dob         | sum_salary | dep_running_salary (partitioned) | dep_running_salary (overall) |
|--------|----------|---------|--------|------------|---------|-------------|------------|----------------------------------|------------------------------|
| 1      | Ankit    | 100     | 10000  | 4          | 39      | 1983-12-02  | 40000      | 10000                            | 10000                       |
| 2      | Mohit    | 100     | 15000  | 5          | 48      | 1974-12-02  | 40000      | 25000                            | 25000                       |
| 3      | Vikas    | 100     | 10000  | 2          | 37      | 1985-12-02  | 40000      | 35000                            | 35000                       |
| 4      | Rohit    | 100     | 5000   | 2          | 16      | 2006-12-02  | 40000      | 40000                            | 40000                       |
| 5      | Mudit    | 200     | 12000  | 1          | 55      | 1967-12-02  | 43000      | 12000                            | 52000                       |
| 6      | Agam     | 200     | 12000  | 2          | 14      | 2008-12-02  | 43000      | 24000                            | 64000                       |
| 7      | Sanjay   | 200     | 9000   | 2          | 13      | 2009-12-02  | 43000      | 33000                            | 73000                       |
| 8      | Ashish   | 200     | 5000   | 2          | 12      | 2010-12-02  | 43000      | 38000                            | 78000                       |
| 9      | Mukesh   | 300     | 6000   | 6          | 51      | 1971-12-02  | 14000      | 6000                             | 84000                       |
| 10     | Rakesh   | 700     | 7000   | 6          | 50      | 1972-12-02  | 7000       | 7000                             | 91000                       |
| 11     | Ramesh   | 300     | 8000   | 6          | 52      | 1970-12-02  | 14000      | 14000                            | 99000                       |

---

## 2. MAX Aggregation with Window Functions

```sql
SELECT *,
    MAX(salary) OVER(PARTITION BY dept_id) AS max_salary,
    MAX(salary) OVER(PARTITION BY dept_id ORDER BY emp_id ASC) AS dep_running_max_salary,
    MAX(salary) OVER(ORDER BY emp_id ASC) AS running_max_salary
FROM employee;
```

**Output:**

| emp_id | emp_name | dept_id | salary | manager_id | emp_age | dob         | max_salary | dep_running_max_salary | running_max_salary |
|--------|----------|---------|--------|------------|---------|-------------|------------|-----------------------|-------------------|
| 1      | Ankit    | 100     | 10000  | 4          | 39      | 1983-12-02  | 15000      | 10000                 | 10000             |
| 2      | Mohit    | 100     | 15000  | 5          | 48      | 1974-12-02  | 15000      | 15000                 | 15000             |
| 3      | Vikas    | 100     | 10000  | 2          | 37      | 1985-12-02  | 15000      | 15000                 | 15000             |
| 4      | Rohit    | 100     | 5000   | 2          | 16      | 2006-12-02  | 15000      | 15000                 | 15000             |
| 5      | Mudit    | 200     | 12000  | 1          | 55      | 1967-12-02  | 12000      | 12000                 | 15000             |
| 6      | Agam     | 200     | 12000  | 2          | 14      | 2008-12-02  | 12000      | 12000                 | 15000             |
| 7      | Sanjay   | 200     | 9000   | 2          | 13      | 2009-12-02  | 12000      | 12000                 | 15000             |
| 8      | Ashish   | 200     | 5000   | 2          | 12      | 2010-12-02  | 12000      | 12000                 | 15000             |
| 9      | Mukesh   | 300     | 6000   | 6          | 51      | 1971-12-02  | 8000       | 6000                  | 15000             |
| 10     | Rakesh   | 700     | 7000   | 6          | 50      | 1972-12-02  | 7000       | 7000                  | 15000             |
| 11     | Ramesh   | 300     | 8000   | 6          | 52      | 1970-12-02  | 8000       | 8000                  | 15000             |

---

```sql
SELECT *,  
         MAX(salary) OVER(ORDER BY salary DESC),
         MAX(salary) OVER(ORDER BY salary ASC) 
FROM employee_table;
```

**Output:**

| emp_id | emp_name | dept_id | salary | manager_emp_id | emp_age | dob        | (No column name) | (No column name) |
|--------|----------|---------|--------|---------------|---------|------------|------------------|------------------|
| 4      | Rohit    | 100     | 5000   | 2             | 16      | 2006-12-02 | 15000            | 5000             |
| 8      | Ashish   | 200     | 5000   | 2             | 12      | 2010-12-02 | 15000            | 5000             |
| 9      | Mukesh   | 300     | 6000   | 6             | 51      | 1971-12-02 | 15000            | 6000             |
| 10     | Rakesh   | 700     | 7000   | 6             | 50      | 1972-12-02 | 15000            | 7000             |
| 11     | Ramesh   | 300     | 8000   | 6             | 52      | 1970-12-02 | 15000            | 8000             |
| 7      | Sanjay   | 200     | 9000   | 2             | 13      | 2009-12-02 | 15000            | 9000             |
| 3      | Vikas    | 100     | 10000  | 2             | 37      | 1985-12-02 | 15000            | 10000            |
| 1      | Ankit    | 100     | 10000  | 4             | 39      | 1983-12-02 | 15000            | 10000            |
| 5      | Mudit    | 200     | 12000  | 1             | 55      | 1967-12-02 | 15000            | 12000            |
| 6      | Agam     | 200     | 12000  | 2             | 14      | 2008-12-02 | 15000            | 12000            |
| 2      | Mohit    | 100     | 15000  | 5             | 48      | 1974-12-02 | 15000            | 15000            |

---

## 3. Issue with Duplicates in the ORDER BY Column

```sql
SELECT *,  
         SUM(salary) OVER(ORDER BY salary DESC) 
FROM employee_table;
```

**Output:**

| emp_id | emp_name | dept_id | salary | manager_emp_id | emp_age | dob        | (No column name) |
|--------|----------|---------|--------|---------------|---------|------------|------------------|
| 2      | Mohit    | 100     | 15000  | 5             | 48      | 1974-12-02 | 15000            |
| 5      | Mudit    | 200     | 12000  | 1             | 55      | 1967-12-02 | 39000            |
| 6      | Agam     | 200     | 12000  | 2             | 14      | 2008-12-02 | 39000            |
| 3      | Vikas    | 100     | 10000  | 2             | 37      | 1985-12-02 | 59000            |
| 1      | Ankit    | 100     | 10000  | 4             | 39      | 1983-12-02 | 59000            |
| 7      | Sanjay   | 200     | 9000   | 2             | 13      | 2009-12-02 | 68000            |
| 11     | Ramesh   | 300     | 8000   | 6             | 52      | 1970-12-02 | 76000            |
| 10     | Rakesh   | 700     | 7000   | 6             | 50      | 1972-12-02 | 83000            |
| 9      | Mukesh   | 300     | 6000   | 6             | 51      | 1971-12-02 | 89000            |
| 4      | Rohit    | 100     | 5000   | 2             | 16      | 2006-12-02 | 99000            |
| 8      | Ashish   | 200     | 5000   | 2             | 12      | 2010-12-02 | 99000            |

---

**Problem solved by including a unique value in the ORDER BY clause:**

```sql
SELECT *,  
         SUM(salary) OVER(ORDER BY salary, emp_id DESC) 
FROM employee_table;
```

**Output:**

| emp_id | emp_name | dept_id | salary | manager_emp_id | emp_age | dob        | (No column name) |
|--------|----------|---------|--------|---------------|---------|------------|------------------|
| 8      | Ashish   | 200     | 5000   | 2             | 12      | 2010-12-02 | 5000             |
| 4      | Rohit    | 100     | 5000   | 2             | 16      | 2006-12-02 | 10000            |
| 9      | Mukesh   | 300     | 6000   | 6             | 51      | 1971-12-02 | 16000            |
| 10     | Rakesh   | 700     | 7000   | 6             | 50      | 1972-12-02 | 23000            |
| 11     | Ramesh   | 300     | 8000   | 6             | 52      | 1970-12-02 | 31000            |
| 7      | Sanjay   | 200     | 9000   | 2             | 13      | 2009-12-02 | 40000            |
| 3      | Vikas    | 100     | 10000  | 2             | 37      | 1985-12-02 | 50000            |
| 1      | Ankit    | 100     | 10000  | 4             | 39      | 1983-12-02 | 60000            |
| 6      | Agam     | 200     | 12000  | 2             | 14      | 2008-12-02 | 72000            |
| 5      | Mudit    | 200     | 12000  | 1             | 55      | 1967-12-02 | 84000            |
| 2      | Mohit    | 100     | 15000  | 5             | 48      | 1974-12-02 | 99000            |

---

## 4. Running Count

```sql
SELECT *,  
         COUNT(salary) OVER(PARTITION BY dept_id ORDER BY emp_id)  AS running_count
FROM employee_table;
```

**Output:**

| emp_id | emp_name | dept_id | salary | manager_emp_id | emp_age | dob        | running_count |
|--------|----------|---------|--------|---------------|---------|------------|---------------|
| 1      | Ankit    | 100     | 10000  | 4             | 39      | 1983-12-02 | 1             |
| 2      | Mohit    | 100     | 15000  | 5             | 48      | 1974-12-02 | 2             |
| 3      | Vikas    | 100     | 10000  | 2             | 37      | 1985-12-02 | 3             |
| 4      | Rohit    | 100     | 5000   | 2             | 16      | 2006-12-02 | 4             |
| 5      | Mudit    | 200     | 12000  | 1             | 55      | 1967-12-02 | 1             |
| 6      | Agam     | 200     | 12000  | 2             | 14      | 2008-12-02 | 2             |
| 7      | Sanjay   | 200     | 9000   | 2             | 13      | 2009-12-02 | 3             |
| 8      | Ashish   | 200     | 5000   | 2             | 12      | 2010-12-02 | 4             |
| 9      | Mukesh   | 300     | 6000   | 6             | 51      | 1971-12-02 | 1             |
| 11     | Ramesh   | 300     | 8000   | 6             | 52      | 1970-12-02 | 2             |
| 10     | Rakesh   | 700     | 7000   | 6             | 50      | 1972-12-02 | 1             |

---

## 5. Rolling Window: ROWS BETWEEN 2 PRECEDING AND CURRENT ROW

```sql
SELECT *,
         SUM(salary) OVER(ORDER BY emp_id) AS running_sum,
         SUM(salary) OVER(ORDER BY emp_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3_sum
FROM employee_table;
```

**Output:**

| emp_id | emp_name | dept_id | salary | manager_emp_id | emp_age | dob        | running_sum | rolling_3_sum |
|--------|----------|---------|--------|---------------|---------|------------|-------------|---------------|
| 1      | Ankit    | 100     | 10000  | 4             | 39      | 1983-12-02 | 10000       | 10000         |
| 2      | Mohit    | 100     | 15000  | 5             | 48      | 1974-12-02 | 25000       | 25000         |
| 3      | Vikas    | 100     | 10000  | 2             | 37      | 1985-12-02 | 35000       | 35000         |
| 4      | Rohit    | 100     | 5000   | 2             | 16      | 2006-12-02 | 40000       | 30000         |
| 5      | Mudit    | 200     | 12000  | 1             | 55      | 1967-12-02 | 52000       | 27000         |
| 6      | Agam     | 200     | 12000  | 2             | 14      | 2008-12-02 | 64000       | 29000         |
| 7      | Sanjay   | 200     | 9000   | 2             | 13      | 2009-12-02 | 73000       | 33000         |
| 8      | Ashish   | 200     | 5000   | 2             | 12      | 2010-12-02 | 78000       | 26000         |
| 9      | Mukesh   | 300     | 6000   | 6             | 51      | 1971-12-02 | 84000       | 20000         |
| 10     | Rakesh   | 700     | 7000   | 6             | 50      | 1972-12-02 | 91000       | 18000         |
| 11     | Ramesh   | 300     | 8000   | 6             | 52      | 1970-12-02 | 99000       | 21000         |

---

## 6. Rolling Window: ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING

```sql
SELECT *,
         SUM(salary) OVER(ORDER BY emp_id) AS running_sum,
         SUM(salary) OVER(ORDER BY emp_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS rolling_3_sum
FROM employee_table;
```

**Output:**

| emp_id | emp_name | dept_id | salary | manager_emp_id | emp_age | dob        | running_sum | rolling_3_sum |
|--------|----------|---------|--------|---------------|---------|------------|-------------|---------------|
| 1      | Ankit    | 100     | 10000  | 4             | 39      | 1983-12-02 | 10000       | 10000         |
| 2      | Mohit    | 100     | 15000  | 5             | 48      | 1974-12-02 | 25000       | 25000         |
| 3      | Vikas    | 100     | 10000  | 2             | 37      | 1985-12-02 | 35000       | 35000         |
| 4      | Rohit    | 100     | 5000   | 2             | 16      | 2006-12-02 | 40000       | 30000         |
| 5      | Mudit    | 200     | 12000  | 1             | 55      | 1967-12-02 | 52000       | 27000         |
| 6      | Agam     | 200     | 12000  | 2             | 14      | 2008-12-02 | 64000       | 29000         |
| 7      | Sanjay   | 200     | 9000   | 2             | 13      | 2009-12-02 | 73000       | 33000         |
| 8      | Ashish   | 200     | 5000   | 2             | 12      | 2010-12-02 | 78000       | 26000         |
| 9      | Mukesh   | 300     | 6000   | 6             | 51      | 1971-12-02 | 84000       | 20000         |
| 10     | Rakesh   | 700     | 7000   | 6             | 50      | 1972-12-02 | 91000       | 18000         |
| 11     | Ramesh   | 300     | 8000   | 6             | 52      | 1970-12-02 | 99000       | 21000         |

---

## 7. Rolling Window: ROWS BETWEEN 5 FOLLOWING AND 10 FOLLOWING

```sql
SELECT *,
         SUM(salary) OVER(ORDER BY emp_id) AS running_sum,
         SUM(salary) OVER(ORDER BY emp_id ROWS BETWEEN 5 FOLLOWING AND 10 FOLLOWING) AS rows_in_5_to_10
FROM employee_table;
```

**Output:**

| emp_id | emp_name | dept_id | salary | manager_emp_id | emp_age | dob        | running_sum | rows_in_5_to_10 |
|--------|----------|---------|--------|---------------|---------|------------|-------------|-----------------|
| 1      | Ankit    | 100     | 10000  | 4             | 39      | 1983-12-02 | 10000       | 47000           |
| 2      | Mohit    | 100     | 15000  | 5             | 48      | 1974-12-02 | 25000       | 35000           |
| 3      | Vikas    | 100     | 10000  | 2             | 37      | 1985-12-02 | 35000       | 26000           |
| 4      | Rohit    | 100     | 5000   | 2             | 16      | 2006-12-02 | 40000       | 21000           |
| 5      | Mudit    | 200     | 12000  | 1             | 55      | 1967-12-02 | 52000       | 15000           |
| 6      | Agam     | 200     | 12000  | 2             | 14      | 2008-12-02 | 64000       | 8000            |
| 7      | Sanjay   | 200     | 9000   | 2             | 13      | 2009-12-02 | 73000       | NULL            |
| 8      | Ashish   | 200     | 5000   | 2             | 12      | 2010-12-02 | 78000       | NULL            |
| 9      | Mukesh   | 300     | 6000   | 6             | 51      | 1971-12-02 | 84000       | NULL            |
| 10     | Rakesh   | 700     | 7000   | 6             | 50      | 1972-12-02 | 91000       | NULL            |
| 11     | Ramesh   | 300     | 8000   | 6             | 52      | 1970-12-02 | 99000       | NULL            |

---

## 8. Unbounded Preceding to Current Row

```sql
SELECT *,
         SUM(salary) OVER(ORDER BY emp_id) AS running_sum,
         SUM(salary) OVER(ORDER BY emp_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rows_from_top_current_rows,
         SUM(salary) OVER(ORDER BY emp_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM employee_table;
```

**Output:**

| emp_id | emp_name | dept_id | salary | manager_emp_id | emp_age | dob        | running_sum | rows_from_top_current_rows | (No column name) |
|--------|----------|---------|--------|---------------|---------|------------|-------------|----------------------------|------------------|
| 1      | Ankit    | 100     | 10000  | 4             | 39      | 1983-12-02 | 10000       | 10000                      | 99000            |
| 2      | Mohit    | 100     | 15000  | 5             | 48      | 1974-12-02 | 25000       | 25000                      | 99000            |
| 3      | Vikas    | 100     | 10000  | 2             | 37      | 1985-12-02 | 35000       | 35000                      | 99000            |
| 4      | Rohit    | 100     | 5000   | 2             | 16      | 2006-12-02 | 40000       | 40000                      | 99000            |
| 5      | Mudit    | 200     | 12000  | 1             | 55      | 1967-12-02 | 52000       | 52000                      | 99000            |
| 6      | Agam     | 200     | 12000  | 2             | 14      | 2008-12-02 | 64000       | 64000                      | 99000            |
| 7      | Sanjay   | 200     | 9000   | 2             | 13      | 2009-12-02 | 73000       | 73000                      | 99000            |
| 8      | Ashish   | 200     | 5000   | 2             | 12      | 2010-12-02 | 78000       | 78000                      | 99000            |
| 9      | Mukesh   | 300     | 6000   | 6             | 51      | 1971-12-02 | 84000       | 84000                      | 99000            |
| 10     | Rakesh   | 700     | 7000   | 6             | 50      | 1972-12-02 | 91000       | 91000                      | 99000            |
| 11     | Ramesh   | 300     | 8000   | 6             | 52      | 1970-12-02 | 99000       | 99000                      | 99000            |

---

## 9. Partition by dept_id ORDER BY emp_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

```sql
SELECT *,
         SUM(salary) OVER(PARTITION BY dept_id) AS running_sum,
         SUM(salary) OVER(PARTITION BY dept_id ORDER BY emp_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS unbounded_in_partitions
FROM employee_table;
```

**Output:**

| emp_id | emp_name | dept_id | salary | manager_emp_id | emp_age | dob        | running_sum | unbounded_in_partitions |
|--------|----------|---------|--------|---------------|---------|------------|-------------|------------------------|
| 1      | Ankit    | 100     | 10000  | 4             | 39      | 1983-12-02 | 40000       | 40000                  |
| 2      | Mohit    | 100     | 15000  | 5             | 48      | 1974-12-02 | 40000       | 40000                  |
| 3      | Vikas    | 100     | 10000  | 2             | 37      | 1985-12-02 | 40000       | 40000                  |
| 4      | Rohit    | 100     | 5000   | 2             | 16      | 2006-12-02 | 40000       | 40000                  |
| 5      | Mudit    | 200     | 12000  | 1             | 55      | 1967-12-02 | 38000       | 38000                  |
| 6      | Agam     | 200     | 12000  | 2             | 14      | 2008-12-02 | 38000       | 38000                  |
| 7      | Sanjay   | 200     | 9000   | 2             | 13      | 2009-12-02 | 38000       | 38000                  |
| 8      | Ashish   | 200     | 5000   | 2             | 12      | 2010-12-02 | 38000       | 38000                  |
| 9      | Mukesh   | 300     | 6000   | 6             | 51      | 1971-12-02 | 14000       | 14000                  |
| 11     | Ramesh   | 300     | 8000   | 6             | 52      | 1970-12-02 | 14000       | 14000                  |
| 10     | Rakesh   | 700     | 7000   | 6             | 50      | 1972-12-02 | 7000        | 7000                   |

---

## 10. FIRST_VALUE and LAST_VALUE

```sql
SELECT *,
         FIRST_VALUE(salary) OVER(ORDER BY salary) AS running_sum,
         FIRST_VALUE(salary) OVER(ORDER BY salary DESC) AS rows_from_top_current_rows,
         LAST_VALUE(salary) OVER(ORDER BY salary),
         LAST_VALUE(salary) OVER(ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
         LAST_VALUE(salary) OVER(ORDER BY salary ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM employee_table;
```

**Output:**

| emp_id | emp_name | dept_id | salary | manager_emp_id | emp_age | dob        | running_sum | rows_from_top_current_rows | (No column name) | (No column name) | (No column name) |
|--------|----------|---------|--------|---------------|---------|------------|-------------|----------------------------|------------------|------------------|------------------|
| 2      | Mohit    | 100     | 15000  | 5             | 48      | 1974-12-02 | 5000        | 15000                      | 15000            | 15000            | 15000            |
| 5      | Mudit    | 200     | 12000  | 1             | 55      | 1967-12-02 | 5000        | 15000                      | 12000            | 15000            | 15000            |
| 6      | Agam     | 200     | 12000  | 2             | 14      | 2008-12-02 | 5000        | 15000                      | 12000            | 15000            | 15000            |
| 3      | Vikas    | 100     | 10000  | 2             | 37      | 1985-12-02 | 5000        | 15000                      | 10000            | 15000            | 15000            |
| 1      | Ankit    | 100     | 10000  | 4             | 39      | 1983-12-02 | 5000        | 15000                      | 10000            | 15000            | 15000            |
| 7      | Sanjay   | 200     | 9000   | 2             | 13      | 2009-12-02 | 5000        | 15000                      | 9000             | 15000            | 15000            |
| 11     | Ramesh   | 300     | 8000   | 6             | 52      | 1970-12-02 | 5000        | 15000                      | 8000             | 15000            | 15000            |
| 10     | Rakesh   | 700     | 7000   | 6             | 50      | 1972-12-02 | 5000        | 15000                      | 7000             | 15000            | 15000            |
| 9      | Mukesh   | 300     | 6000   | 6             | 51      | 1971-12-02 | 5000        | 15000                      | 6000             | 15000            | 15000            |
| 4      | Rohit    | 100     | 5000   | 2             | 16      | 2006-12-02 | 5000        | 15000                      | 5000             | 15000            | 15000            |
| 8      | Ashish   | 200     | 5000   | 2             | 12      | 2010-12-02 | 5000        | 15000                      | 5000             | 15000            | 15000            |

---

## 11. Problem with Running SUM When Values Repeat

```sql
SELECT order_ID, sales, SUM(sales) OVER(ORDER BY order_ID) AS running_sum
FROM orders;
```

**Output:**

| order_ID         | sales    | running_sum |
|------------------|----------|-------------|
| CA-2018-100006   | 377.97   | 377.97      |
| CA-2018-100090   | 502.488  | 1077.162    |
| CA-2018-100090   | 196.704  | 1077.162    |
| CA-2018-100293   | 91.056   | 1168.218    |
| CA-2018-100328   | 3.928    | 1172.146    |
| CA-2018-100363   | 2.368    | 1193.522    |
| CA-2018-100363   | 19.008   | 1193.522    |

---

**Solution: Use UNBOUNDED PRECEDING AND CURRENT ROW in Window:**

```sql
SELECT order_ID, sales,
         SUM(sales) OVER(ORDER BY order_ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_sum
FROM orders;
```

**Output:**

| order_ID         | sales    | running_sum |
|------------------|----------|-------------|
| CA-2018-100006   | 377.97   | 377.97      |
| CA-2018-100090   | 502.488  | 880.458     |
| CA-2018-100090   | 196.704  | 1077.162    |
| CA-2018-100293   | 91.056   | 1168.218    |
| CA-2018-100328   | 3.928    | 1172.146    |
| CA-2018-100363   | 2.368    | 1174.514    |
| CA-2018-100363   | 19.008   | 1193.522    |
| CA-2018-100391   | 14.62    | 1208.142    |
| CA-2018-100678   | 2.688    | 1210.83     |

---

## 12. Rolling Aggregations by Month

```sql
WITH cte AS (
    SELECT DATEPART(year, order_date) AS year_part, 
           DATEPART(MONTH, order_date) AS month_part,
           SUM(sales) AS summ_by_month 
    FROM orders  
    GROUP BY DATEPART(YEAR, order_date), DATEPART(MONTH, order_date)
)
SELECT *, 
    SUM(summ_by_month) OVER(ORDER BY year_part, month_part ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS rolling_3_sum,
    LAG(summ_by_month,1) OVER(ORDER BY year_part, month_part) AS previous_month_sales_comparison
FROM cte;
```

**Output:**

| year_part | month_part | summ_by_month   | rolling_3_sum    | previous_month_sales_comparison |
|-----------|------------|----------------|------------------|-------------------------------|
| 2018      | 1          | 14236.895      | 14236.895        | NULL                          |
| 2018      | 2          | 4519.892       | 18756.787        | 14236.895                     |
| 2018      | 3          | 55691.009      | 74447.796        | 4519.892                      |
| 2018      | 4          | 28295.345      | 102743.141       | 55691.009                     |
| 2018      | 5          | 23648.287      | 112154.533       | 28295.345                     |
| 2018      | 6          | 34595.1276     | 142229.7686      | 23648.287                     |
| 2018      | 7          | 33946.393      | 120485.1526      | 34595.1276                    |
| 2018      | 8          | 27909.4685     | 120099.2761      | 33946.393                     |
| 2018      | 9          | 81777.3508     | 178228.3399      | 27909.4685                    |
| 2018      | 10         | 31453.393      | 175086.6053      | 81777.3508                    |
| 2018      | 11         | 78628.7167001  | 219768.929       | 31453.393                     |

---