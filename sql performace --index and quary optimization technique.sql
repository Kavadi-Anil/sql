📌 What is an Index in SQL?

An index in SQL is a data structure that improves the speed of data retrieval operations on a table. 
It works like an index in a book — allowing the database engine to find data quickly without scanning the entire table.

🧠 Internally, whenever a table is indexed, the data is stored in a **B-Tree (Balanced Tree)** format and organized into **chunks/pages**. 
This structure enables **fast lookups, inserts, and range queries** by minimizing disk reads.

------------------------------------------------------------------

✅ Why are Indexes Useful?

Assume you have a table with **1 million records**:

If you run:
SELECT * FROM employees WHERE salary > 10000;

🔴 Without an index:
- SQL performs a **full table scan** — checks every row one by one.
- This can take **around 3 minutes** or more depending on system resources.

🟢 With an index on the `salary` column:
- SQL jumps directly to the matching values using the B-Tree.
- The query completes in **seconds** or less.

Trade-off:
- Indexes consume extra disk space.
- They slow down INSERT, UPDATE, DELETE operations due to index maintenance.

------------------------------------------------------------------

⚙️ Types of Indexes

1. Clustered Index:
--------------------
- Physically reorders the data in the table to match the index.
- Only one clustered index allowed per table.
- The table *is* the index.

📘 Example:
CREATE CLUSTERED INDEX idx_employee_id
ON employees(employee_id);

🧠 Analogy:
Imagine a **textbook where chapters are arranged sequentially** — Chapter 1, Chapter 2, ..., Chapter N.
You can read the book directly in order without needing a separate guide.

-------------------------------------------------------

2. Non-Clustered Index:
------------------------
- Creates a separate structure from the actual table data.
- Stores only the indexed columns and a pointer to the full row.
- Multiple non-clustered indexes can exist on a single table.

📘 Example:
CREATE NONCLUSTERED INDEX idx_last_name
ON employees(last_name);

🧠 Analogy:
Imagine a **textbook with an index at the back**. The index lists topics with page numbers.
The content is scattered, but you can jump to the exact page using the index.

------------------------------------------------------------------

🆚 Clustered vs Non-Clustered Index

| Feature                  | Clustered Index                          | Non-Clustered Index                          |
|--------------------------|------------------------------------------|----------------------------------------------|
| Data Storage             | Actual table data is sorted              | Only index + pointer to data                 |
| Number per Table         | One only                                 | Multiple allowed                             |
| Performance              | Faster for range queries                 | Slightly slower                              |
| Use Case                 | Primary key, sorting columns             | Frequently filtered/search columns           |
| Analogy                  | Book with chapters in order              | Book with a back-of-book topic index         |

------------------------------------------------------------------

✔️ Summary:
- Use clustered index for primary access pattern (e.g. primary key).
- Use non-clustered indexes for frequently searched/filter columns (e.g. name, email).
- All indexes internally use a **B-Tree** structure for efficient data lookup.
- Indexes make queries on large datasets much faster — turning minutes into seconds. 

















📌 Index Performance Example with Execution Plan

Assume you have the following `employee` table:

employee_id | name     | salary
------------|----------|--------
1           | Raj      | 9000
2           | Priya    | 10000
3           | Anil     | 11000
4           | Neha     | 12000
5           | John     | 13000
...         | ...      | ...
1000000     | Zubin    | 10000

🧠 The table has **1 million records**.

------------------------------------------------------------

🔍 How to Check Estimated Number of Rows to Read:

1. Write your SQL query.
2. Right-click anywhere on the query window.
3. Click **"Display Estimated Execution Plan"**.
4. Hover your mouse **over the operator** (e.g., Table Scan or Index Seek).
5. Look for **"Estimated Number of Rows to be Read"** in the popup.

------------------------------------------------------------

🔴 Without Index:

Query:
SELECT * FROM employee WHERE salary = 10000;

- No index on the `salary` column → SQL Server performs a **full table scan**.
- It must scan **all 1 million rows** to find matches.
- Execution Time: ⏳ **~3 minutes**
- Execution Plan:
  - **Operation Type**: Table Scan
  - **Estimated Number of Rows to Read**: 1,000,000
  - **Subtree Cost**: High

------------------------------------------------------------

🟢 With Index:

Create a non-clustered index on `salary`:
CREATE NONCLUSTERED INDEX idx_salary ON employee(salary);

Query:
SELECT * FROM employee WHERE salary = 10000;

- SQL now uses the **non-clustered index** for a faster lookup.
- Execution Time: ⚡ **Few milliseconds**
- Execution Plan:
  - **Operation Type**: Index Seek + Key Lookup
  - **Estimated Number of Rows to Read**: Significantly Lower
  - **Subtree Cost**: Much lower than full scan

------------------------------------------------------------

✔️ Summary:

| Criteria                         | Without Index         | With Non-Clustered Index         |
|----------------------------------|------------------------|----------------------------------|
| Query Time                       | ~3 minutes             | Few milliseconds                 |
| Rows Scanned                     | 1,000,000              | Much fewer                       |
| Execution Type                   | Table Scan             | Index Seek + Lookup              |
| Subtree Cost                     | High                   | Low                              |

✅ Creating indexes drastically improves performance by avoiding full table scans and leveraging fast B-Tree lookups. 




















📌 How SQL Server Uses Indexes in SELECT Queries

Let’s explore how index usage varies depending on SELECT and WHERE clause patterns:

------------------------------------------------------------

1️⃣ ONLY INDEXED COLUMN IN SELECT + WHERE
------------------------------------------
Index:
CREATE NONCLUSTERED INDEX idx_salary ON employee(salary);

Query:
SELECT salary FROM employee WHERE salary = 10000;

🧠 Behavior:
- Only the **indexed column (`salary`)** is used.
- SQL performs an **Index Seek** only (no lookup).
- Data is fetched directly from the index.
- ✅ **Very efficient**: Minimal I/O, low subtree cost.
- ✅ **Estimated Number of Rows to Read: Significantly Low**

------------------------------------------------------------

2️⃣ INDEXED COLUMN IN WHERE + ADDITIONAL COLUMN IN SELECT
----------------------------------------------------------
Index:
CREATE NONCLUSTERED INDEX idx_salary ON employee(salary);

Query:
SELECT employee_id, salary FROM employee WHERE salary = 10000;

🧠 Behavior:
- **Filter** is on indexed column (`salary`) → Index Seek
- But `employee_id` is **not in the index** → SQL needs to perform a **Key Lookup**
- SQL fetches extra column data from the base table

✅ Still efficient — filtering is fast due to index  
⚠️ Slight overhead due to lookup  
📉 **Estimated Rows Read: Moderate**
📉 **Subtree Cost: Slightly higher**

------------------------------------------------------------

3️⃣ FILTERING ON INDEXED + NON-INDEXED COLUMNS
----------------------------------------------
Index:
CREATE NONCLUSTERED INDEX idx_salary ON employee(salary);

Query:
SELECT * FROM employee WHERE salary = 10000 AND employee_id > 1332;

🧠 Behavior:
- `salary` is indexed → Index Seek
- `employee_id` is **not indexed** → SQL needs **additional filtering**
- SQL may perform **Index Seek + Lookup + Table Scan**

⚠️ Performance hit due to extra filtering and table access  
📉 **Estimated Rows Read: Higher**
📉 **Subtree Cost: Higher**

------------------------------------------------------------

⚙️ Optimizing Multi-Column Filters with Composite Index

To avoid lookup + table scan, create a **composite non-clustered index**:
CREATE NONCLUSTERED INDEX idx_multi ON employee(salary ASC, employee_id ASC);

Now run:
SELECT salary, employee_id FROM employee WHERE salary = 10000 AND employee_id > 12414;

🧠 Behavior:
- SQL performs an **Index Seek using both columns**
- No lookup or table scan needed
- ✅ **Very efficient**
- ✅ **Estimated Rows Read: Much Lower**
- ✅ **Subtree Cost: Very Low**

------------------------------------------------------------

✔️ Summary of Index Behavior:

| Query Type                                      | Operation Type                 | Performance Level     |
|------------------------------------------------|--------------------------------|------------------------|
| Indexed column in SELECT & WHERE               | Index Seek only                | ✅ Excellent           |
| Indexed column in WHERE + extra column SELECT  | Index Seek + Lookup            | ✅ Good                |
| Indexed + non-indexed column in WHERE          | Index Seek + Lookup + Scan     | ⚠️ Moderate            |
| Use composite index on both filtered columns   | Full Index Seek                | ✅✅ Best Performance   |

🎯 Pro Tip:
- Always check the execution plan → Right-click → **Display Estimated Execution Plan**
- Look for:
  - Estimated Number of Rows to Read
  - Operation Type (Index Seek / Lookup / Table Scan)
  - Subtree Cost















📌 Limitations of Indexes
==========================

- You can create **only ONE clustered index** per table.
- You can create **multiple non-clustered indexes** on a table.

🔎 LIKE behavior:
- name LIKE '%ank'      → ✅ Index Seek is used
- name LIKE '%ank%'     → ❌ Index not used (causes full table scan)

🔢 Range Queries:
- Queries using `<`, `>`, `BETWEEN` can still use **index seek**.
  Example: WHERE salary BETWEEN 10000 AND 30000

🐢 Insert Performance:
- Insertions in **indexed tables** are slower.
- Reason: When inserting data into the middle of a sorted structure,
  the table has to **reorder or maintain the B-Tree**, which adds overhead.

🛠️ Best Practice:
- If large insert operations are being performed, it’s better to:
  1. DROP the index temporarily.
  2. Perform all insertions.
  3. RECREATE the index after insert is complete.

-------------------------------------------------------

💡 Indexing Tips
================

- Always create indexes on **columns used in WHERE conditions**.
- Also create indexes on **columns used in JOIN conditions** to speed up joins.
  Example: JOIN on employee_id, customer_id, etc.

-------------------------------------------------------

🔐 Unique Non-Clustered Index
=============================

Use this when a column contains **unique values** (e.g., order_id, employee_id).

📘 Example:
CREATE UNIQUE NONCLUSTERED INDEX idx_customer_id
ON orders_index(customer_id);

🧠 Purpose:
- Ensures uniqueness at the database level.
- Improves performance when searching or joining on unique columns.

-------------------------------------------------------

✅ Summary:

| Concept                         | Behavior/Tip                                                  |
|---------------------------------|---------------------------------------------------------------|
| Clustered Index                 | Only one per table                                            |
| Non-Clustered Index             | Multiple allowed                                              |
| LIKE '%value'                   | ✅ Index used                                                 |
| LIKE '%value%'                  | ❌ Index not used                                             |
| Range queries (>, <, BETWEEN)   | ✅ Index used                                                 |
| Insert into indexed table       | 🐢 Slower due to reordering B-Tree                           |
| Bulk insert best practice       | Drop index → Insert → Recreate index                         |
| Create index on WHERE column    | ✅ Improves filter performance                                |
| Create index on JOIN column     | ✅ Speeds up joins                                            |
| Unique non-clustered index      | ✅ Use for unique values like employee_id, order_id          |


