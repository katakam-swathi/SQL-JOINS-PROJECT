--JOINS SQL PROJECT--

-- Drop if re-running
DROP TABLE IF EXISTS employee_project;
DROP TABLE IF EXISTS project;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS location;

-- 1) Reference tables
CREATE TABLE location (
  location_id   INT PRIMARY KEY,
  city          VARCHAR(50) NOT NULL,
  country       VARCHAR(50) NOT NULL
);

CREATE TABLE department (
  dept_id       INT PRIMARY KEY,
  dept_name     VARCHAR(50) UNIQUE NOT NULL,
  location_id   INT REFERENCES location(location_id)
);

-- 2) Core entities
CREATE TABLE employee (
  emp_id        INT PRIMARY KEY,
  name          VARCHAR(50) NOT NULL,
  hire_date     DATE NOT NULL,
  salary        NUMERIC(10,2) NOT NULL,
  dept_id       INT REFERENCES department(dept_id),
  manager_id    INT REFERENCES employee(emp_id)
);

CREATE TABLE project (
  proj_id       INT PRIMARY KEY,
  proj_name     VARCHAR(80) NOT NULL,
  dept_id       INT REFERENCES department(dept_id),
  budget        NUMERIC(12,2) NOT NULL
);

-- 3) Junction (many-to-many)
CREATE TABLE employee_project (
  emp_id        INT REFERENCES employee(emp_id),
  proj_id       INT REFERENCES project(proj_id),
  assigned_on   DATE NOT NULL DEFAULT CURRENT_DATE,
  PRIMARY KEY (emp_id, proj_id)
);
INSERT INTO location VALUES
(1,'Hyderabad','India'),
(2,'Bengaluru','India'),
(3,'Pune','India');

INSERT INTO department VALUES
(10,'HR',1),
(20,'IT',2),
(30,'Finance',1),
(40,'Marketing',3),
(50,'Legal',1),
(60,'R&D',2),        -- no employees (to test LEFT/FULL OUTER)
(70,'Support',3);    -- no employees

-- Managers first (so manager_id FK will work for others)
INSERT INTO employee (emp_id,name,hire_date,salary,dept_id,manager_id) VALUES
(1,'Alice',  '2020-01-01',150000,NULL, NULL),  -- CEO, no dept
(2,'Bob',    '2021-05-10', 90000, 10,   1),    -- HR Manager
(3,'Carol',  '2021-06-15',100000, 20,   1),    -- IT Manager
(4,'Dan',    '2021-07-20',110000, 30,   1);    -- Finance Manager

-- ICs
INSERT INTO employee VALUES
(5,'Erin',  '2022-02-01',60000, 10, 2),
(6,'Frank', '2022-03-12',65000, 20, 3),
(7,'Grace', '2022-09-01',72000, 20, 3),
(8,'Henry', '2022-11-11',58000, 40, 1),
(9,'Ivy',   '2023-01-20',62000, 30, 4),
(10,'John', '2023-06-01',30000, NULL,2),  -- employee without department
(11,'Kiran','2023-08-12',61000, 50, 1),
(12,'Leela','2024-02-02',45000, NULL,NULL); -- no dept, no manager

INSERT INTO project VALUES
(100,'HR Policy Refresh',   10, 20000),
(101,'Corporate Website',   20, 80000),
(102,'ERP Implementation',  30, 50000),
(103,'Rebranding Campaign', 40, 30000),
(104,'Skunkworks Alpha',   NULL, 90000),  -- project with no owning dept
(105,'Legal Compliance',    50, 20000);

INSERT INTO employee_project (emp_id, proj_id, assigned_on) VALUES
(5,100,'2022-02-05'),
(2,100,'2021-05-15'),
(6,101,'2022-03-15'),
(7,101,'2022-09-05'),
(9,102,'2023-01-21'),
(8,103,'2022-11-20'),
(11,105,'2023-08-20'),
(6,102,'2023-02-01'),     -- Frank on two projects
(10,104,'2023-06-05');    -- John on a project with no dept

SELECT * FROM location;
SELECT * FROM department;
SELECT * FROM employee;
SELECT * FROM project;
SELECT * FROM employee_project;


---Solving Problem---

1.Show each employee's name,department,and hire date.If no department, show(NO DEPT)

SELECT 
	e.name,
	e.hire_date,
	COALESCE(d.dept_name, '(NO DEPT)') AS department
FROM employee e
LEFT JOIN department d ON e.dept_id = d.dept_id;

2.List all departments that currently have no employees assigned.

SELECT d.dept_name,
	COALESCE(e.name,'NO EMPLOYEES') AS employee
FROM department d
LEFT JOIN employee e ON e.dept_id = d.dept_id;

3.Find employees who don't have a manager.

SELECT 
	e.name,
	COALESCE(m.name, '(Top Level)') AS manager
FROM employee e
LEFT JOIN employee m ON e.manager_id = m.emp_id;

4.Show each department and the total salary of employees.If no employees,show 0.

SELECT
	d.dept_name,
	COALESCE(SUM(e.salary), '0') AS totalsalary
FROM department d
LEFT JOIN employee e ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

5.Show employees with their department's location.

SELECT 
	e.name AS employee,
	d.dept_name,
	l.city,
	l.country
FROM employee e
LEFT JOIN department d ON d.dept_id = e.dept_id
LEFT JOIN location l ON d.location_id = l.location_id;

6.Show projects with no employees assigned.

SELECT
	DISTINCT proj_name
FROM project p
LEFT JOIN employee_project ep ON p.proj_id = ep.proj_id
WHERE ep.emp_id IS NULL;

7.Show each employee with the projects they are working on(include employees with no projects)

SELECT
	e.name as employee,
	p.proj_name
FROM employee e
LEFT JOIN employee_project ep ON e.emp_id = ep.emp_id
LEFT JOIN project p ON p.proj_id  = ep.proj_id
ORDER BY employee;

8.Find employees who work on multiple projects.

SELECT 
	e.name AS employee,
	COUNT(ep.proj_id) as project_count
FROM employee e
LEFT JOIN employee_project ep ON e.emp_id = ep.emp_id
GROUP BY e.name
HAVING COUNT(ep.proj_id) > 1;

9.Find the highest-paid employees in each department.

SELECT 
	e.name,
	d.dept_name,
	e.salary
FROM department d
LEFT JOIN employee e ON e.dept_id = d.dept_id
WHERE e.salary =(
		SELECT MAX(salary)
		FROM employee
		WHERE dept_id = d.dept_id
);

10.Show all employees who work in the same department as "Frank"

SELECT 
	e.name,
	d.dept_name
FROM employee e
LEFT JOIN department d ON e.dept_id = d.dept_id
WHERE e.dept_id =(
 SELECT dept_id FROM employee WHERE name ='Frank'
);
	
---END OF PROJECT---
	



	







