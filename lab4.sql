SET SERVEROUTPUT ON
SET VERIFY OFF
SET PAGESIZE 120

-- --1
-- CREATE OR REPLACE PROCEDURE mine(
--     v_expiry VARCHAR2,
--     v_obj VARCHAR2) IS

--     v_day VARCHAR2(10);
--     v_objnum NUMBER(3);
-- BEGIN
--     SELECT TO_CHAR(LAST_DAY(TO_DATE(v_expiry, 'MM/YY')), 'Day') INTO v_day
--     FROM DUAL;

--     DBMS_OUTPUT.PUT_LINE('Last day of the month '||v_expiry||' is '||v_day);
    
--     CASE
--         WHEN UPPER(v_obj) = 'P' THEN 
--             SELECT count(*) INTO v_objnum
--             FROM user_objects
--             WHERE object_type = 'PROCEDURE';
--             DBMS_OUTPUT.PUT_LINE('Number of stored objects of type '||UPPER(v_obj)||' is '||v_objnum);
--         WHEN UPPER(v_obj) = 'F' THEN 
--             SELECT count(*) INTO v_objnum
--             FROM user_objects
--             WHERE object_type = 'FUNCTION';
--             DBMS_OUTPUT.PUT_LINE('Number of stored objects of type '||UPPER(v_obj)||' is '||v_objnum);
--         WHEN UPPER(v_obj) = 'B' THEN 
--             SELECT count(*) INTO v_objnum
--             FROM user_objects
--             WHERE object_type = 'PACKAGE';
--             DBMS_OUTPUT.PUT_LINE('Number of stored objects of type '||UPPER(v_obj)||' is '||v_objnum);
--         ELSE
--             DBMS_OUTPUT.PUT_LINE('You have entered an Invalid letter for the stored object. Try P, F or B.');
--     END CASE;    
    
-- EXCEPTION
--     WHEN OTHERS THEN
--         DBMS_OUTPUT.PUT_LINE('You have entered an Invalid FORMAT for the MONTH and YEAR. Try MM/YY.');
-- END mine;
-- /

--2
/* no_data_found -> insert // what we want to do 
    zip_exist exception -> raise -> message
    i.e. 
    SELECT 'Y' INTO v_log
    FROM zipcode
    WHERE ZIP = P_ZIP;*/

-- CREATE OR REPLACE PROCEDURE add_zip(
    -- v_zip IN Zipcode.zip%TYPE,
    -- v_city IN Zipcode.city%TYPE,
    -- v_state IN Zipcode.state%TYPE,
    -- v_flag OUT VARCHAR2,
    -- v_num OUT NUMBER
-- ) IS 
--     v_exist char(1);
--     e_msg EXCEPTION;
-- BEGIN
--     SELECT 'Y' INTO v_exist
--     FROM Zipcode
--     WHERE zip = v_zip;

--     IF v_exist = 'Y' THEN
--         v_flag := 'FAILURE';
        
--         SELECT COUNT(*) INTO v_num
--         FROM Zipcode
--         WHERE state = 'MI';

--         RAISE e_msg;
--     END IF;

-- EXCEPTION
--     WHEN e_msg THEN 
--         DBMS_OUTPUT.PUT_LINE('This ZIPCODE '||v_zip||' is already in the Dataase. Try again.');
--     WHEN no_data_found THEN
--         v_flag := 'SUCCESS';

--         INSERT INTO Zipcode
--         VALUES(v_zip, v_city, v_state, USER, SYSDATE, USER, SYSDATE);

--         SELECT COUNT(*) INTO v_num
--         FROM Zipcode
--         WHERE state = 'MI';

-- END add_zip;
-- /
-- VARIABLE flag VARCHAR2(10)
-- VARIABLE num NUMBER
-- EXECUTE add_zip2 ('18104', 'Chicago', 'MI', :flag, :num)
-- PRINT flag num
-- SELECT * FROM Zipcode
-- WHERE state = 'MI'

-- VARIABLE flag VARCHAR2(10)
-- VARIABLE num NUMBER
-- EXECUTE add_zip2 ('48104', 'Ann Arbor', 'MI', :flag, :num)
-- PRINT flag num    

--3
-- CREATE OR REPLACE FUNCTION exist_zip(
--     p_zip Zipcode.zip%TYPE
-- )
-- RETURN BOOLEAN IS 
--     v_exist VARCHAR2(1);
-- BEGIN
--     SELECT 'Y' INTO v_exist
--     FROM Zipcode
--     WHERE zip = p_zip;

--     RETURN TRUE;
-- EXCEPTION
--     WHEN no_data_found THEN
--         RETURN FALSE;
-- END exist_zip;

-- CREATE OR REPLACE PROCEDURE add_zip2(
--     v_zip IN Zipcode.zip%TYPE,
--     v_city IN Zipcode.city%TYPE,
--     v_state IN Zipcode.state%TYPE,
--     v_flag OUT VARCHAR2,
--     v_num OUT NUMBER
-- ) IS
--     e_msg EXCEPTION;
-- BEGIN

--     IF exist_zip(v_zip) = TRUE THEN
--         v_flag := 'FAILURE';
        
--         SELECT COUNT(*) INTO v_num
--         FROM Zipcode
--         WHERE state = 'MI';

--         RAISE e_msg;
--     ELSE 
--         v_flag := 'SUCCESS';

--         INSERT INTO Zipcode
--         VALUES(v_zip, v_city, v_state, USER, SYSDATE, USER, SYSDATE);

--         SELECT COUNT(*) INTO v_num
--         FROM Zipcode
--         WHERE state = 'MI';
--     END IF;

-- EXCEPTION
--     WHEN e_msg THEN 
--         DBMS_OUTPUT.PUT_LINE('This ZIPCODE '||v_zip||' is already in the Dataase. Try again.');

-- END add_zip2;

--4
CREATE OR REPLACE FUNCTION instruct_status(
    p_fname Instructor.first_name%TYPE,
    p_lname Instructor.last_name%TYPE
) RETURN VARCHAR2 IS
    v_intId Instructor.instructor_id%TYPE;
    v_coursenum NUMBER;
    v_message VARCHAR2(75);
BEGIN
    SELECT instructor_id INTO v_intId
    FROM Instructor
    WHERE UPPER(first_name) = UPPER(p_fname) AND UPPER(last_name) = UPPER(p_lname);

    SELECT COUNT(section_id) INTO v_coursenum
    FROM Section
    WHERE instructor_id = v_intId;

    IF v_coursenum > 9 THEN
        v_message := 'This Instructor will teach '||v_coursenum||' course and needs a vacation';
    ELSIF v_coursenum = 0 THEN
        v_message := 'This Instructor is NOT scheduled to teach';
    ELSE
        v_message := 'This Instructor will teach '||v_coursenum||' courses.';
    END IF;

    RETURN v_message;
EXCEPTION
    WHEN no_data_found THEN
        v_message := 'There is NO such instructor';
        RETURN v_message;
END instruct_status;
/