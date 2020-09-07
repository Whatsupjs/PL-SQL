SET SERVEROUTPUT ON
SET VERIFY OFF
SET PAGESIZE 120

-- --1 

-- CREATE OR REPLACE PROCEDURE modify_sal(
--     p_deptId Departments.department_id%TYPE
-- ) IS 
--     CURSOR c_salary IS
--     SELECT first_name, last_name, salary
--     FROM Employees
--     WHERE department_id = p_deptId
--     ORDER BY salary DESC, last_name
--     FOR UPDATE OF salary NOWAIT;

--     v_deptexist Departments.department_id%TYPE;
--     v_avgsalary NUMBER;
--     v_empcount NUMBER;
--     v_counter NUMBER := 0;
--     e_empty EXCEPTION;
-- BEGIN
--     SELECT department_id INTO v_deptexist
--     FROM Departments
--     WHERE department_id = p_deptId;

--     SELECT COUNT(employee_id) INTO v_empcount
--     FROM Employees
--     WHERE department_id = p_deptId;

--     IF v_empcount = 0 THEN
--         RAISE e_empty;
--     END IF;

--     SELECT AVG(NVL(salary,0)) INTO v_avgsalary
--     FROM Employees
--     WHERE department_id = p_deptId;

--     FOR c_rec IN c_salary
--     LOOP
--         IF c_rec.salary < v_avgsalary THEN
--             DBMS_OUTPUT.PUT_LINE('Employee '||c_rec.first_name||' '||c_rec.last_name||' just got an increase of $'||(v_avgsalary - c_rec.salary));
            
--             UPDATE Employees
--             SET salary = v_avgsalary
--             WHERE CURRENT OF c_salary;

--             v_counter := v_counter + 1;
--         END IF;

--     END LOOP;

--     IF v_counter > 0 THEN
--         DBMS_OUTPUT.PUT_LINE('Total # of employees who received salary increase is: '|| v_counter);
--     ELSE
--         DBMS_OUTPUT.PUT_LINE('No salary was modified in Department: '||p_deptId);
--     END IF;

-- EXCEPTION
--     WHEN no_data_found THEN
--         DBMS_OUTPUT.PUT_LINE('This Department Id is invalid: '||p_deptId);
--     WHEN e_empty THEN
--         DBMS_OUTPUT.PUT_LINE('This Department is EMPTY: '||p_deptId);
-- END modify_sal;
-- /

-- --2
-- CREATE OR REPLACE FUNCTION Total_Cost(
--     p_studentid Student.student_id%TYPE
-- ) RETURN NUMBER IS
--     v_validate NUMBER;
--     v_totalcost NUMBER;
--     v_enrolled NUMBER;
-- BEGIN
--     SELECT student_id INTO v_validate
--     FROM Student
--     WHERE student_id = p_studentid;

--     SELECT COUNT(student_id) INTO v_enrolled
--     FROM Enrollment
--     WHERE student_id = p_studentid;

--     IF v_enrolled = 0 THEN
--         RETURN 0;
--     ELSE 
--         SELECT SUM(cost) INTO v_totalcost
--         FROM Course c JOIN Section s
--         ON c.course_no = s.course_no
--             JOIN Enrollment e
--             ON s.section_id = e.section_id
--         WHERE e.student_id = p_studentid;

--         RETURN v_totalcost;
--     END IF;

-- EXCEPTION
--     WHEN no_data_found THEN
--         RETURN -1;
-- END Total_Cost;
-- /

--3a

-- CREATE OR REPLACE PACKAGE My_pack IS 
--     PROCEDURE modify_sal(
--         p_deptId Departments.department_id%TYPE);
    
--     FUNCTION Total_Cost(
--         p_studentid Student.student_id%TYPE
--     ) RETURN NUMBER;

--     FUNCTION Total_Cost(
--         p_firstname Student.first_name%TYPE,
--         p_lastname Student.last_name%TYPE
--     ) RETURN NUMBER;

--     FUNCTION Total_Cost(
--         p_zip Student.zip%TYPE
--     ) RETURN NUMBER;
-- END My_pack;
-- /
--3b

-- CREATE OR REPLACE PACKAGE BODY My_pack IS
--     PROCEDURE modify_sal(
--     p_deptId Departments.department_id%TYPE
--     ) IS 
--         CURSOR c_salary IS
--         SELECT first_name, last_name, salary
--         FROM Employees
--         WHERE department_id = p_deptId
--         ORDER BY salary DESC, last_name
--         FOR UPDATE OF salary NOWAIT;

--         v_deptexist Departments.department_id%TYPE;
--         v_avgsalary NUMBER;
--         v_empcount NUMBER;
--         v_counter NUMBER := 0;
--         e_empty EXCEPTION;
--     BEGIN
--         SELECT department_id INTO v_deptexist
--         FROM Departments
--         WHERE department_id = p_deptId;

--         SELECT COUNT(employee_id) INTO v_empcount
--         FROM Employees
--         WHERE department_id = p_deptId;

--         IF v_empcount = 0 THEN
--             RAISE e_empty;
--         END IF;

--         SELECT AVG(NVL(salary,0)) INTO v_avgsalary
--         FROM Employees
--         WHERE department_id = p_deptId;

--         FOR c_rec IN c_salary
--         LOOP
--             IF c_rec.salary < v_avgsalary THEN
--                 DBMS_OUTPUT.PUT_LINE('Employee '||c_rec.first_name||' '||c_rec.last_name||' just got an increase of $'||(v_avgsalary - c_rec.salary));
                
--                 UPDATE Employees
--                 SET salary = v_avgsalary
--                 WHERE CURRENT OF c_salary;

--                 v_counter := v_counter + 1;
--             END IF;

--         END LOOP;

--         IF v_counter > 0 THEN
--             DBMS_OUTPUT.PUT_LINE('Total # of employees who received salary increase is: '|| v_counter);
--         ELSE
--             DBMS_OUTPUT.PUT_LINE('No salary was modified in Department: '||p_deptId);
--         END IF;

--     EXCEPTION
--         WHEN no_data_found THEN
--             DBMS_OUTPUT.PUT_LINE('This Department Id is invalid: '||p_deptId);
--         WHEN e_empty THEN
--             DBMS_OUTPUT.PUT_LINE('This Department is EMPTY: '||p_deptId);
--     END modify_sal;

--     FUNCTION Total_Cost(
--         p_studentid Student.student_id%TYPE
--     ) RETURN NUMBER IS
--         v_validate NUMBER;
--         v_totalcost NUMBER;
--         v_enrolled NUMBER;
--     BEGIN
--         SELECT student_id INTO v_validate
--         FROM Student
--         WHERE student_id = p_studentid;

--         SELECT COUNT(student_id) INTO v_enrolled
--         FROM Enrollment
--         WHERE student_id = p_studentid;

--         IF v_enrolled = 0 THEN
--             RETURN 0;
--         ELSE 
--             SELECT SUM(cost) INTO v_totalcost
--             FROM Course c JOIN Section s
--             ON c.course_no = s.course_no
--                 JOIN Enrollment e
--                 ON s.section_id = e.section_id
--             WHERE e.student_id = p_studentid;

--             RETURN v_totalcost;
--         END IF;

--     EXCEPTION
--         WHEN no_data_found THEN
--             RETURN -1;
--     END Total_Cost;

--     FUNCTION Total_Cost(
--         p_firstname Student.first_name%TYPE,
--         p_lastname Student.last_name%TYPE
--     ) RETURN NUMBER IS
--         v_validate NUMBER;
--         v_totalcost NUMBER;
--         v_enrolled NUMBER;
--     BEGIN
--         SELECT student_id INTO v_validate
--         FROM Student
--         WHERE UPPER(first_name) = p_firstname AND UPPER(last_name) = p_lastname;

--         SELECT COUNT(student_id) INTO v_enrolled
--         FROM Enrollment
--         WHERE student_id = v_validate;

--         IF v_enrolled = 0 THEN
--             RETURN 0;
--         ELSE 
--             SELECT SUM(cost) INTO v_totalcost
--             FROM Course c JOIN Section s
--             ON c.course_no = s.course_no
--                 JOIN Enrollment e
--                 ON s.section_id = e.section_id
--             WHERE e.student_id = v_validate;

--             RETURN v_totalcost;
--         END IF;

--     EXCEPTION
--         WHEN no_data_found THEN
--             RETURN -1;
--     END Total_Cost;
    
--     FUNCTION Total_Cost(
--         p_zip Student.zip%TYPE
--     ) RETURN NUMBER IS
--         v_validate NUMBER;
--         v_cost NUMBER;
--         v_totalcost NUMBER := 0;

--         CURSOR student_cursor IS
--             SELECT student_id
--             FROM Student
--             WHERE zip = p_zip;
        
--     BEGIN
--         SELECT COUNT(student_id) INTO v_validate
--         FROM Student
--         WHERE zip = p_zip;

--         IF v_validate = 0 THEN
--             RETURN -1;
--         ELSE
--             For c_rec IN student_cursor
--             LOOP
--             SELECT SUM(cost) INTO v_cost
--             FROM Course c JOIN Section s
--             ON c.course_no = s.course_no
--                 JOIN Enrollment e
--                 ON s.section_id = e.section_id
--             WHERE e.student_id = c_rec.student_id;

--             IF v_cost IS NULL THEN 
--                 v_cost := 0;
--             END IF;

--             v_totalcost := v_totalcost + v_cost;
--             END LOOP;
--         END IF;

--         RETURN v_totalcost;
    
--     END Total_Cost;
-- END My_pack;
-- /

--5

CREATE OR REPLACE PROCEDURE mod_grade(
    p_courseno Course.course_no%TYPE,
    p_grade Enrollment.final_grade%TYPE
) IS
    CURSOR section_cursor IS
        SELECT e.section_id
        FROM Enrollment e JOIN Section s
        ON e.section_id = s.section_id
        WHERE s.course_no = p_courseno
        GROUP BY e.section_id;
    
    CURSOR grade_cursor(p_sectionid NUMBER) IS
        SELECT student_id, final_grade
        FROM Enrollment
        WHERE section_id = p_sectionid;

    v_validcourse NUMBER;
    v_studcount NUMBER;
    v_updatecount NUMBER := 0;
    e_course EXCEPTION;
    e_grade EXCEPTION;

BEGIN
    SELECT COUNT(course_no) INTO v_validcourse
    FROM Course
    WHERE course_no = p_courseno;

    IF v_validcourse = 0 THEN
        RAISE e_course;
    END IF;

    IF p_grade >= 0 AND p_grade <= 100 THEN
        SELECT COUNT(student_id) INTO v_studcount
        FROM Enrollment e JOIN Section s
        ON e.section_id = s.section_id
        WHERE s.course_no = p_courseno;

        IF v_studcount = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('This Course has NOBODY enrolled so far: '||p_courseno);
        ELSE
            FOR c_rec IN section_cursor
            LOOP
                FOR c_rec2 IN grade_cursor(c_rec.section_id)
                LOOP
                    UPDATE Enrollment
                    SET final_grade = p_grade
                    WHERE section_id = c_rec.section_id;

                    v_updatecount := v_updatecount + 1;
                END LOOP;
            END LOOP;

            DBMS_OUTPUT.PUT_LINE('Total # of grades changed to '||p_grade||' for course number '||p_courseno||' is '||v_updatecount);
        END IF;       
    ELSE
        RAISE e_grade;
    END IF;      

EXCEPTION
    WHEN e_course THEN
        DBMS_OUTPUT.PUT_LINE('This Course Number is invalid: '||p_courseno);
    WHEN e_grade THEN
        DBMS_OUTPUT.PUT_LINE('The Grade invalid: '||p_grade||'  It must between 0 and 100. Try again.');
END mod_grade;
/