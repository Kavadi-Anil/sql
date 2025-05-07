-- Create the employee table
CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary INT,
    manager_id INT,
    emp_age INT,
    dob DATE
);

-- Insert data into the employee table
INSERT INTO employee (emp_id, emp_name, dept_id, salary, manager_id, emp_age, dob)
VALUES
(1, 'Ankit', 100, 10000, 4, 39, '1986-04-16'),
(2, 'Mohit', 100, 15000, 5, 48, '1977-04-16'),
(3, 'Vikas', 100, 10000, 4, 37, '1988-04-16'),
(4, 'Rohit', 100, 5000, 2, 16, '2009-04-16'),
(5, 'Mudit', 200, 12000, 6, 55, '1970-04-16'),
(6, 'Agam', 200, 12000, 2, 14, '2011-04-16'),
(7, 'Sanjay', 200, 9000, 2, 13, '2012-04-16'),
(8, 'Ashish', 200, 5000, 2, 12, '2013-04-16'),
(9, 'Mukesh', 300, 6000, 6, 51, '1974-04-16'),
(10, 'Rakesh', 500, 7000, 6, 50, '1975-04-16'),
(11, 'ramesh', 300, 5000, 6, 18, '2007-04-16');
