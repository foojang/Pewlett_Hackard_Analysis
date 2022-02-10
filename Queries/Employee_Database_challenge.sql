--Deliverable 1
-- pull employee data
CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name  VARCHAR NOT NULL,
	last_name 	VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY 	(EMP_NO)
);

-- pull title data 
CREATE TABLE titles (
	emp_no INT NOT NULL, 
	title VARCHAR NOT NULL, 
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, from_date)
);

--create retirment_info table 
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- creat title table
SELECT title, from_date, to_date, emp_no
INTO title_info
FROM titles;

--join retirment_info and title table
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO retirement_title
FROM retirement_info as ri
LEFT JOIN title_info as ti
ON ri.emp_no = ti.emp_no;
	
select * from retirement_title

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (ri.emp_no) ri.emp_no,
ri.first_name,
ri.last_name,
ri.title

INTO unique_titles
FROM retirement_title as ri
WHERE (to_date = '9999-01-01')
ORDER BY emp_no, to_date DESC;

select * from unique_titles;

-- create table for retiring tables 
SELECT COUNT(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY count DESC

select * from retiring_titles

-- Deliverable 2

CREATE TABLE dept_Emp (
 	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	PRIMARY KEY (emp_no, from_date, dept_no),
FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);


-- create table for birthday 
SELECT emp_no, first_name, last_name, birth_date
INTO birthday_info
FROM employees
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31');

-- create table for dept
SELECT emp_no, from_date, to_date
INTO dept_dates
FROM dept_emp

--create table for title 
SELECT emp_no, title
INTO title_mentor
FROM titles;

-- distinct on for brithday info
SELECT DISTINCT ON (bi.emp_no) bi.emp_no,
bi.first_name,
bi.last_name,
bi.birth_date

INTO unique_birthday_info
FROM birthday_info as bi
ORDER BY emp_no;

-- distinct on for dept
SELECT DISTINCT ON (dd.emp_no) dd.emp_no,
dd.from_date,
dd.to_date

INTO unique_dept_dates
FROM dept_dates as dd
ORDER BY emp_no;

-- distinct on for title
SELECT DISTINCT ON (tt.emp_no) tt.emp_no,
tt.title

INTO unique_title_mentor
FROM title_mentor as tt
ORDER BY emp_no;

--join ubi and dd
SELECT ubi.emp_no,
	ubi.first_name,
	ubi.last_name,
	ubi.birth_date,
	dd.from_date,
	dd.to_date
INTO brithday_dates
FROM unique_birthday_info as ubi
LEFT JOIN unique_dept_dates as dd
ON ubi.emp_no = dd.emp_no
WHERE dd.to_date = ('9999-01-01');

--join bd and tt
SELECT bd.emp_no,
	bd.first_name,
	bd.last_name,
	bd.birth_date,
	bd.from_date,
	bd.to_date, 
	utt.title
INTO mentorship_eligibilty
FROM brithday_dates as bd
LEFT JOIN unique_title_mentor as utt
ON bd.emp_no = utt.emp_no
ORDER BY emp_no

SELECT * FROM mentorship_eligibilty
