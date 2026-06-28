-- ================================================
-- SQL for Data Analysts — Zero to Advanced
-- Episode 08 | SQL Joins Mastery
-- Topic: SELF JOIN
-- ================================================
-- YouTube : [YOUR CHANNEL LINK]
-- GitHub  : [YOUR REPO LINK]
-- ================================================

USE store_db;

-- ─────────────────────────────────────
-- SELF JOIN — joining a table with itself
-- Used when rows in a table relate to OTHER rows
-- in the SAME table
-- Common use cases:
--   → Employee — Manager hierarchy
--   → Product recommendations
--   → Category — Subcategory
-- ─────────────────────────────────────

-- First create a demo employees table
CREATE TABLE IF NOT EXISTS employees (
    emp_id     INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(50) NOT NULL,
    role       VARCHAR(50),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

-- Insert sample hierarchy
INSERT INTO employees (name, role, manager_id) VALUES
    ('Rahul',  'CEO',        NULL),
    ('Priya',  'VP Sales',   1),
    ('Ankit',  'VP Tech',    1),
    ('Sneha',  'Sales Lead', 2),
    ('Vikram', 'Developer',  3),
    ('Pooja',  'Developer',  3),
    ('Arjun',  'Sales Rep',  4);

SELECT * FROM employees;

-- ─────────────────────────────────────
-- Basic SELF JOIN — employee + their manager
-- ─────────────────────────────────────

-- INNER JOIN — top level (Rahul) excluded (no manager)
SELECT
    e.name AS employee,
    e.role AS employee_role,
    m.name AS manager
FROM   employees e
INNER JOIN employees m ON e.manager_id = m.emp_id
ORDER BY m.name, e.name;

-- LEFT JOIN — includes Rahul (no manager → NULL)
SELECT
    e.name AS employee,
    e.role AS employee_role,
    COALESCE(m.name, 'No Manager') AS manager
FROM   employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
ORDER BY manager, employee;

-- ─────────────────────────────────────
-- Find all direct reports for a given manager
-- ─────────────────────────────────────
SELECT
    m.name  AS manager,
    e.name  AS direct_report,
    e.role  AS report_role
FROM   employees e
INNER JOIN employees m ON e.manager_id = m.emp_id
WHERE  m.name = 'Rahul'
ORDER BY e.name;

-- ─────────────────────────────────────
-- SELF JOIN on customers — same city pairs
-- ─────────────────────────────────────
SELECT
    a.first_name AS customer_1,
    b.first_name AS customer_2,
    a.city
FROM   customers a
INNER JOIN customers b
    ON a.city = b.city
    AND a.customer_id < b.customer_id   -- avoids duplicates and self-pairs
ORDER BY a.city, a.first_name
LIMIT 15;

-- ─────────────────────────────────────
-- Cleanup
-- ─────────────────────────────────────
-- DROP TABLE IF EXISTS employees;
