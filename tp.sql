-- ex1


 CREATE TABLE top_salaries (
    salary INT
);

 
DELIMITER $$
CREATE PROCEDURE get_top_salaries()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE emp_salary INT;
    DECLARE emp_cursor CURSOR FOR 
        SELECT DISTINCT salary
        FROM employees
        ORDER BY salary DESC
        LIMIT 10;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN emp_cursor;
    read_loop: LOOP
        FETCH emp_cursor INTO emp_salary;
        IF done THEN
            LEAVE read_loop;
        END IF;
        INSERT INTO top_salaries (salary) VALUES (emp_salary);
    END LOOP;

    CLOSE emp_cursor;
END$$
DELIMITER ;

 

--ex2



SELECT AVG(salary) AS average_salary
FROM employees
WHERE department_id IN (10, 60);

--ex3



DELIMITER $$
CREATE PROCEDURE fetch_departments_and_employees()
BEGIN
    DECLARE done1 INT DEFAULT 0;
    DECLARE done2 INT DEFAULT 0;
    DECLARE dept_id INT;
    DECLARE dept_name VARCHAR(50);
    DECLARE emp_last_name VARCHAR(50);
    DECLARE emp_job_title VARCHAR(50);
    DECLARE emp_hire_date DATE;
    DECLARE emp_salary INT;

    DECLARE dept_cursor CURSOR FOR 
        SELECT department_id, department_name
        FROM departments
        WHERE department_id < 100;

    DECLARE emp_cursor CURSOR FOR 
        SELECT last_name, job_title, hire_date, salary
        FROM employees
        WHERE department_id = dept_id AND employee_id < 120;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done1 = 1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done2 = 1;

    OPEN dept_cursor;
    dept_loop: LOOP
        FETCH dept_cursor INTO dept_id, dept_name;
        IF done1 THEN
            LEAVE dept_loop;
        END IF;
        
        
        SELECT dept_id, dept_name;
        
         
        OPEN emp_cursor;
        emp_loop: LOOP
            FETCH emp_cursor INTO emp_last_name, emp_job_title, emp_hire_date, emp_salary;
            IF done2 THEN
                LEAVE emp_loop;
            END IF;

           
            SELECT emp_last_name, emp_job_title, emp_hire_date, emp_salary;
        END LOOP;
        CLOSE emp_cursor;
    END LOOP;

    CLOSE dept_cursor;
END$$
 

 
--ex4



DELIMITER $$
CREATE PROCEDURE check_employee_salary()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE emp_last_name VARCHAR(50);
    DECLARE emp_salary INT;
    DECLARE emp_manager_id INT;

    DECLARE emp_cursor CURSOR FOR 
        SELECT last_name, salary, manager_id
        FROM employees
        WHERE department_id = 90;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN emp_cursor;
    read_loop: LOOP
        FETCH emp_cursor INTO emp_last_name, emp_salary, emp_manager_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        IF emp_salary < 5000 AND (emp_manager_id = 100 OR emp_manager_id = 200) THEN
            SELECT CONCAT(emp_last_name, ': En raison d\'une augmentation') AS message;
        ELSE
            SELECT CONCAT(emp_last_name, ': Pas d\'augmentation') AS message;
        END IF;
    END LOOP;

    CLOSE emp_cursor;
END$$
 

 
