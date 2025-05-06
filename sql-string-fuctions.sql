#sql 
🔤 SQL Server String Functions


Function         | Description                                     | Example
-----------------|-------------------------------------------------|-------------------------------
LEN()            | Returns the length of a string                  | LEN('hello') → 5
CHARINDEX()      | Finds the position of a substring               | CHARINDEX('a', 'banana') → 2
LEFT()           | Extracts N characters from the left             | LEFT('hello', 2) → 'he'
RIGHT()          | Extracts N characters from the right            | RIGHT('hello', 2) → 'lo'
SUBSTRING()      | Extracts part of a string                       | SUBSTRING('hello', 2, 3) → 'ell'
LTRIM()          | Removes leading spaces                          | LTRIM('  abc') → 'abc'
RTRIM()          | Removes trailing spaces                         | RTRIM('abc  ') → 'abc'
TRIM()           | Removes both leading and trailing spaces        | TRIM('  abc  ') → 'abc'  *(SQL 2017+)*
UPPER()          | Converts text to uppercase                      | UPPER('sql') → 'SQL'
LOWER()          | Converts text to lowercase                      | LOWER('SQL') → 'sql'
REPLACE()        | Replaces a substring within a string            | REPLACE('cat', 'c', 'b') → 'bat'
REPLICATE()      | Repeats a string N times                        | REPLICATE('*', 3) → '***'
CONCAT()         | Joins multiple strings                          | CONCAT('hello', ' ', 'world') → 'hello world'
FORMAT()         | Formats values (e.g., date or number) as string | FORMAT(GETDATE(), 'yyyy-MM')



-- 🗃️ Input Table: people

full_name
---------------
kavadi anil
max sam
david Kicthen

-- ✅ SQL Query:
SELECT 
    full_name,
    CHARINDEX(' ', full_name) AS space_position
FROM people;

-- 📤 Output Table:

full_name       | space_position
----------------|----------------
kavadi anil     | 7
max sam         | 4
david Kicthen   | 6 



-- 🗃️ Input Table: people

full_name
---------------
kavadi anil
max sam
david Kicthen

-- ✅ SQL Query:
SELECT 
    full_name,
    SUBSTRING(full_name, CHARINDEX(' ', full_name) + 1, LEN(full_name)) AS last_name,
    LEFT(full_name, CHARINDEX(' ', full_name) - 1) AS first_name
FROM people;

-- 📤 Output Table:

full_name       | last_name  | first_name
----------------|------------|------------
kavadi anil     | anil       | kavadi
max sam         | sam        | max
david Kicthen   | Kicthen    | david
