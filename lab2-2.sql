/*
ACCEPT InstructorId PROMPT 'Please enter the Instructor Id: '
DECLARE
    v_id Instructor.instructor_id%TYPE := '&InstructorId';
    v_fname Instructor.first_name%TYPE;
    v_lname Instructor.last_name%TYPE;
    v_section NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_section
        FROM SECTION
        WHERE instructor_id = v_id;
    
    BEGIN  
        SELECT first_name, last_name into v_fname,v_lname
        FROM Instructor
        WHERE instructor_id = v_id;    
    
        DBMS_OUTPUT.PUT_LINE('Instructor, ' || v_fname ||' '|| v_lname ||', teaches ' || v_section || ' section(s)' );
        
        CASE
            WHEN v_section >= 10 THEN
                DBMS_OUTPUT.PUT_LINE('This instructor needs to rest in the next term.');
            WHEN v_section < 3 THEN
                DBMS_OUTPUT.PUT_LINE('This instructor may teach more sections.');
            ELSE
                DBMS_OUTPUT.PUT_LINE('This instructor teaches enough sections.');
        END CASE;
    END;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('This is not a valid instructor');
END;*/
/*
--3
ACCEPT p_int PROMPT 'Please enter a Positive Integer: '
DECLARE
    v_int NUMBER := &p_int;
    v_intog NUMBER := v_int;
    v_result NUMBER := 0;
BEGIN
    WHILE v_int > 0
    LOOP
        v_result := v_result + v_int;
        v_int := v_int - 2;
    END LOOP;
    IF MOD(v_intog,2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('The sum of Even integers between 1 and ' || v_intog || ' is ' || v_result );
    ELSE
        DBMS_OUTPUT.PUT_LINE('The sum of Odd integers between 1 and ' || v_intog || ' is ' || v_result );
    END IF;    
END;
*/
--4
-- 40 = 2400 
-- 70 = 2700
UPDATE Departments
SET location_id = 1400
WHERE department_id IN (40,70);

ACCEPT loc_id PROMPT 'Please enter valid Location Id: '
DECLARE
    v_loc_id Departments.location_id%TYPE := &loc_id;
    v_dbound NUMBER(3);
    v_ebound NUMBER(3);
BEGIN
    SELECT COUNT(*) INTO v_dbound
    FROM Departments
    WHERE location_id = v_loc_id;

    SELECT COUNT(*) INTO v_ebound
    FROM Employees
    WHERE department_id IN (
        SELECT department_id
        FROM Departments
        WHERE location_id = v_loc_id);

    FOR i IN 1..v_dbound
    LOOP
        DBMS_OUTPUT.PUT_LINE('Outer Loop: Department #' || i);
        
        FOR j IN 1..v_ebound
        LOOP
            DBMS_OUTPUT.PUT_LINE('* Inner Loop: Employee #' || j);
        END LOOP;
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No departments found');
END;
/
ROLLBACK;
/