# SQL-JOINS-PROJECT

📊 SQL Joins Project

📌 Project Overview

This project demonstrates the use of SQL Joins in a realistic  Projects database scenario.
The schema models:

Locations → Company offices

Departments → HR, IT, Finance, etc.

Employees → With manager hierarchy

Projects → Department-owned or independent

Employee_Project → Many-to-many assignments of employees to projects


Through a set of SQL queries, we answer practical business questions using INNER JOIN, LEFT JOIN, FULL OUTER JOIN, SELF JOIN, and Aggregations.


---

🏗 Database Schema

location (location_id, city, country)
department (dept_id, dept_name, location_id)
employee (emp_id, name, hire_date, salary, dept_id, manager_id)
project (proj_id, proj_name, dept_id, budget)
employee_project (emp_id, proj_id, assigned_on)


---

✅ Queries Implemented

1. Show each employee's name, department, and hire date (if no department, show (NO DEPT)).

SELECT e.name,
       e.hire_date,
       COALESCE(d.dept_name, '(NO DEPT)') AS department
FROM employee e
LEFT JOIN department d ON e.dept_id = d.dept_id;

2. List all departments that currently have no employees assigned.

SELECT d.dept_name
FROM department d
LEFT JOIN employee e ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;

3. Find employees who don't have a manager.

SELECT e.name,
       COALESCE(m.name, '(Top Level)') AS manager
FROM employee e
LEFT JOIN employee m ON e.manager_id = m.emp_id;

4. Show each department and the total salary of employees (0 if no employees).

SELECT d.dept_name,
       COALESCE(SUM(e.salary),0) AS totalsalary
FROM department d
LEFT JOIN employee e ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

5. Show employees with their department's location.

SELECT e.name AS employee,
       d.dept_name,
       l.city,
       l.country
FROM employee e
LEFT JOIN department d ON d.dept_id = e.dept_id
LEFT JOIN location l ON d.location_id = l.location_id;

6. Show projects with no employees assigned.

SELECT p.proj_name
FROM project p
LEFT JOIN employee_project ep ON p.proj_id = ep.proj_id
WHERE ep.emp_id IS NULL;

7. Show each employee with the projects they are working on (include employees with no projects).

SELECT e.name AS employee,
       p.proj_name
FROM employee e
LEFT JOIN employee_project ep ON e.emp_id = ep.emp_id
LEFT JOIN project p ON p.proj_id = ep.proj_id
ORDER BY employee;

8. Find employees who work on multiple projects.

SELECT e.name AS employee,
       COUNT(ep.proj_id) AS project_count
FROM employee e
LEFT JOIN employee_project ep ON e.emp_id = ep.emp_id
GROUP BY e.name
HAVING COUNT(ep.proj_id) > 1;

9. Find the highest-paid employees in each department.

SELECT e.name,
       d.dept_name,
       e.salary
FROM department d
JOIN employee e ON e.dept_id = d.dept_id
WHERE e.salary = (
    SELECT MAX(salary)
    FROM employee
    WHERE dept_id = d.dept_id
);

10. Show all employees who work in the same department as "Frank".

SELECT e.name,
       d.dept_name
FROM employee e
JOIN department d ON e.dept_id = d.dept_id
WHERE e.dept_id = (
    SELECT dept_id
    FROM employee
    WHERE name = 'Frank'
);


---

🚀 What This Project Demonstrates

Use of INNER JOIN, LEFT JOIN, FULL OUTER JOIN, SELF JOIN

Handling NULL values with COALESCE()

Aggregations with SUM(), COUNT(), MAX()

Many-to-many joins with a junction table

Realistic HR + Projects scenario



---

📂 How to Run

1. Clone this repo:

git clone https://github.com/your-username/sql-joins-project.git
cd sql-joins-project


2. Run the DDL & sample data script in PostgreSQL/MySQL.


3. Execute queries one by one to explore results.




---

🌟 Future Enhancements

Add views for common reports.

Add stored procedures for HR analytics.

Visualize results with Power BI / Tableau.



---

Would you like me to also create a sample ER diagram image (schema diagram of your tables + relationships) that you can put in the README? That will make your GitHub project stand out even more.
