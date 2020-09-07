SET SERVEROUTPUT ON
SET VERIFY OFF
SET PAGESIZE 120
/*
--1
DECLARE
    v_country Countries.country_id%TYPE := '&country';
    v_city Locations.city%TYPE;
    v_state Locations.state_province%TYPE;
    v_length NUMBER(2);
BEGIN
    SELECT city, LENGTH(street_address) INTO v_city, v_length
    FROM Locations
    WHERE country_id = UPPER(v_country) AND state_province IS NULL;

    IF v_city LIKE 'A%' OR v_city LIKE 'B%' OR v_city LIKE 'E%' OR v_city LIKE 'F%' THEN
        FOR i IN 1..v_length LOOP
            v_state := v_state || '*';
        END LOOP;

        UPDATE Locations
        SET state_province = v_state
        WHERE city = v_city;

        DBMS_OUTPUT.PUT_LINE('City '||v_city|| ' has modified its province to ' || v_state);

    ELSIF v_city LIKE 'C%' OR v_city LIKE 'D%' OR v_city LIKE 'G%' OR v_city LIKE 'H%' THEN
        FOR i IN 1..v_length LOOP
            v_state := v_state || '&';
        END LOOP;

        UPDATE Locations
        SET state_province = v_state
        WHERE city = v_city;

        DBMS_OUTPUT.PUT_LINE('City '||v_city|| ' has modified its province to ' || v_state);
    ELSE
        FOR i IN 1..v_length LOOP
            v_state := v_state || '#';
        END LOOP;

        UPDATE Locations
        SET state_province = v_state
        WHERE city = v_city;

        DBMS_OUTPUT.PUT_LINE('City '||v_city|| ' has modified its province to ' || v_state);
    END IF;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('This country has MORE THAN ONE City without province listed.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('This country has NO cities listed.');
END;
/
SELECT *
FROM Locations
WHERE state_province LIKE '&%' OR state_province LIKE '#%' OR state_province LIKE '*%';
ROLLBACK;
*/

--2 DO NOT CURSOR

-- ALTER TABLE Countries
--   ADD FLAG CHAR(7);
/*
DECLARE
    v_regionId Countries.region_id%TYPE := '&region';
    v_countryid Countries.country_id%TYPE;
    v_cname Countries.country_name%TYPE;
    v_count NUMBER(2);
    v_maxregion Countries.region_id%TYPE;
BEGIN
    SELECT c.country_id, c.country_name INTO v_countryid, v_cname
    FROM Countries c LEFT JOIN Locations l
    ON c.country_id = l.country_id
    WHERE l.city IS NULL AND region_id = v_regionId;

    DBMS_OUTPUT.PUT_LINE('In the region '||v_regionId||' there is ONE country '||v_cname||' with NO city.');
    
    BEGIN
        SELECT count(*), MAX(region_id) INTO v_count, v_maxregion
        FROM Countries c LEFT JOIN Locations l
        ON c.country_id = l.country_id
        WHERE l.city IS NULL;

        DBMS_OUTPUT.PUT_LINE('Number of countries with NO cities listed is: '||v_count);
    END;

    FOR i IN 1..v_maxregion
    LOOP
        UPDATE Countries
        SET Flag = 'EMPTY_'||i
        WHERE region_id = i AND country_id IN (SELECT c.country_id
                                                FROM Countries c LEFT JOIN Locations l
                                                ON c.country_id = l.country_id
                                                WHERE l.city IS NULL);
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('This region ID does NOT exist: '|| v_regionId);
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('This region ID has MORE THAN ONE country without cities listed: '||v_regionId);
END;
/

SELECT *
FROM Countries
WHERE flag IS NOT NULL
ORDER BY region_id;
ROLLBACK;
*/
--3
-- 1 or 2 cursors
-- DECLARE
--     v_regionId Countries.region_id%TYPE := '&region';
--     v_count NUMBER(2) := 1;
--     v_total NUMBER(2) := 0;
--     v_data NUMBER(2);

--     TYPE countries_tab_type IS TABLE OF 
--         Countries.country_name%TYPE
--         INDEX BY PLS_INTEGER;
    
--     country_tab countries_tab_type;

--     Cursor c1 IS
--     SELECT c.country_id, c.country_name, c.region_id
--     FROM Countries c LEFT JOIN Locations l
--     ON c.country_id = l.country_id
--     WHERE l.city IS NULL
--     ORDER BY c.country_name;

--     Cursor c2 IS
--     SELECT c.country_id, c.country_name, c.region_id
--     FROM Countries c LEFT JOIN Locations l
--     ON c.country_id = l.country_id
--     WHERE l.city IS NULL AND region_id = v_regionId
--     ORDER BY c.country_name;

-- BEGIN
--     SELECT COUNT(region_id) INTO v_data
--     FROM Regions
--     WHERE region_id = v_regionId;

--     IF v_data = 1 THEN
--         FOR c_rec IN c1
--         LOOP
--             country_tab(v_count) := c_rec.country_name;
--             DBMS_OUTPUT.PUT_LINE('Index Table Key: '||v_count||' has a value of '||country_tab(v_count));

--             UPDATE Countries
--             SET Flag = 'Empty_'||c_rec.region_id
--             WHERE country_name = c_rec.country_name;

--             v_count := v_count + 5;
--         END LOOP;

--         DBMS_OUTPUT.PUT_LINE('======================================================================');
--         DBMS_OUTPUT.PUT_LINE('Total number of elements in the Index Table or Number of countries with NO cities listed is: '||country_tab.COUNT);
--         DBMS_OUTPUT.PUT_LINE('Second element (Country) in the Index Table is: '||country_tab(country_tab.first+5));
--         DBMS_OUTPUT.PUT_LINE('Before the last element (Country) in the Index table is: '||country_tab(country_tab.last-5));
--         DBMS_OUTPUT.PUT_LINE('======================================================================');

--         FOR c_rec2 IN c2
--         LOOP
--             v_total := v_total + 1;
--             DBMS_OUTPUT.PUT_LINE('In the region '||c_rec2.region_id||' there is ONE country '||c_rec2.country_name||' with NO city.');
--         END LOOP;
--         DBMS_OUTPUT.PUT_LINE('======================================================================');
--         DBMS_OUTPUT.PUT_LINE('Total number of countries with NO cities listed in the Region '||v_regionId||' is: '||v_total);
--     ELSE 
--         DBMS_OUTPUT.PUT_LINE('This region ID does NOT exist: '|| v_regionId);
--     END IF;
-- END;
-- /

-- SELECT *
-- FROM Countries
-- WHERE flag IS NOT NULL
-- ORDER BY region_id, country_name;
-- ROLLBACK;

--Q4 - nested for loops with 2 cursors, 2nd cursor with parmeter *************
-- ACCEPT course PROMPT 'Enter the piece of the course description in UPPER case:'
-- ACCEPT lname PROMPT 'Enter the beginning of Instructor last name in UPPER CASE:'
-- DECLARE
--     v_course Course.description%TYPE;
--     v_lname Instructor.last_name%TYPE;
--     v_total NUMBER(3) := 0;
--     v_data NUMBER := 0;

--     CURSOR c1 IS
--     SELECT s.course_no, c.description, s.section_id, i.last_name, s.section_no
--     FROM Section s JOIN Course c 
--     ON s.course_no = c.course_no JOIN  Instructor i 
--     ON i.instructor_id = s.instructor_id
--     WHERE UPPER(i.last_name) LIKE '&lname%' AND UPPER(c.description) LIKE '%&course%'
--     ORDER BY c.description; 

--     CURSOR c2(p_sid NUMBER) IS
--     SELECT COUNT(student_id) enrolled
--     FROM enrollment
--     WHERE section_id = p_sid;

-- BEGIN
--     FOR c_rec IN c1
--     LOOP
--         v_data := v_data + 1;
--         DBMS_OUTPUT.PUT_LINE('Course No: '||c_rec.course_no||' '||c_rec.description||' with Section Id: '
--             ||c_rec.section_id||' is taught by '||c_rec.last_name||' in the Course Section: '||c_rec.section_no);
        
--         FOR c_rec2 IN c2(c_rec.section_id)
--         LOOP
--             DBMS_OUTPUT.PUT_LINE('This Section Id has an enrollment of: '||c_rec2.enrolled);
--             v_total := v_total + c_rec2.enrolled;
--         END LOOP;

--         DBMS_OUTPUT.PUT_LINE('*********************************************************************');
--     END LOOP;
    
--     IF v_data > 0 THEN
--         DBMS_OUTPUT.PUT_LINE('This input match has a total enrollment of: '||v_total||' students');
--     ELSE 
--         DBMS_OUTPUT.PUT_LINE('There is NO data for this input match between the course description piece and the surname start of Instructor. Try again!');
--     END IF;
-- END;
ACCEPT course PROMPT 'Enter the piece of the course description in UPPER case:'
ACCEPT lname PROMPT 'Enter the beginning of Instructor last name in UPPER CASE:'
DECLARE
    v_course Course.description%TYPE;
    v_lname Instructor.last_name%TYPE;
    v_total NUMBER(3) := 0;
    v_data NUMBER := 0;

    CURSOR c1 IS
    SELECT s.course_no, c.description, s.section_id, i.last_name, s.section_no
    FROM Section s JOIN Course c 
    ON s.course_no = c.course_no JOIN  Instructor i 
    ON i.instructor_id = s.instructor_id
    WHERE UPPER(i.last_name) LIKE '&lname%' AND UPPER(c.description) LIKE '%&course%'
    ORDER BY c.description; 

    CURSOR c2(p_sid NUMBER) IS
    SELECT COUNT(student_id) enrolled
    FROM enrollment
    WHERE section_id = p_sid;

BEGIN
    FOR c_rec IN c1
    LOOP
        v_data := v_data + 1;
        DBMS_OUTPUT.PUT_LINE('Course No: '||c_rec.course_no||' '||c_rec.description||' with Section Id: '
            ||c_rec.section_id||' is taught by '||c_rec.last_name||' in the Course Section: '||c_rec.section_no);
        
        FOR c_rec2 IN c2(c_rec.section_id)
        LOOP
            DBMS_OUTPUT.PUT_LINE('This Section Id has an enrollment of: '||c_rec2.enrolled);
            v_total := v_total + c_rec2.enrolled;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('*********************************************************************');
    END LOOP;
    
    IF v_data > 0 THEN
        DBMS_OUTPUT.PUT_LINE('This input match has a total enrollment of: '||v_total||' students');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('There is NO data for this input match between the course description piece and the surname start of Instructor. Try again!');
    END IF;
END;
/



