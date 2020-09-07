SET SERVEROUTPUT ON
SET VERIFY OFF
SET PAGESIZE 120

--1

-- CREATE OR REPLACE FUNCTION Get_Descr(
--     p_sectionId Section.section_id%TYPE
-- ) RETURN VARCHAR2 IS
--     v_coursedesc Course.description%TYPE;
--     v_output VARCHAR2(75);
-- BEGIN
--     SELECT description INTO v_coursedesc
--     FROM Course c JOIN Section s
--     ON c.course_no = s.course_no
--     WHERE s.section_id = p_sectionId;

--     v_output:= 'Course Description for Section Id '||p_sectionId||' is Intro to Java Programming';
--     DBMS_OUTPUT.PUT_LINE(v_output);
--     RETURN v_output;

-- EXCEPTION
--     WHEN no_data_found THEN
--         v_output:= 'There is NO such Section id: '||p_sectionId;
--         DBMS_OUTPUT.PUT_LINE(v_output);
--         RETURN v_output;
-- END Get_Descr;

--2

-- CREATE OR REPLACE PROCEDURE show_bizdays(
--     p_startdate DATE DEFAULT SYSDATE,
--     p_nextdate NUMBER DEFAULT 30
-- ) IS 
--     TYPE date_tab_type IS TABLE OF
--         DATE INDEX BY PLS_INTEGER;
--     v_date date_tab_type;
--     v_checkdate DATE;
--     v_counter NUMBER := 0;
--     v_counter2 NUMBER := 0;
-- BEGIN
--     WHILE v_counter < p_nextdate
--     LOOP
--         v_counter2 := v_counter2 + 1;
--         v_checkdate := p_startdate + v_counter2;

--         IF TO_CHAR(v_checkdate, 'd') NOT IN ('1', '7') THEN
--             v_counter := v_counter + 1;
--             v_date(v_counter) := p_startdate + v_counter2;
--             DBMS_OUTPUT.PUT_LINE('The index is : '||v_counter||' and the table value is: '|| v_date(v_counter));
--         END IF;

--     END LOOP;
-- END show_bizdays;

--3A
-- CREATE OR REPLACE PACKAGE Lab5 IS
--     FUNCTION Get_Descr(
--         p_sectionId Section.section_id%TYPE
--     ) RETURN VARCHAR2;

--     PROCEDURE show_bizdays(
--         p_startdate IN DATE DEFAULT SYSDATE,
--         p_nextdate IN NUMBER DEFAULT 30
--     );

--     PROCEDURE show_bizdays(
--         p_startdate2 DATE
--     );
-- END Lab5;
-- /
--3B
CREATE OR REPLACE PACKAGE BODY Lab5 IS
    FUNCTION Get_Descr(
        p_sectionId Section.section_id%TYPE
    ) RETURN VARCHAR2 IS
        v_coursedesc Course.description%TYPE;
        v_output VARCHAR2(75);
    BEGIN
        SELECT description INTO v_coursedesc
        FROM Course c JOIN Section s
        ON c.course_no = s.course_no
        WHERE s.section_id = p_sectionId;

        v_output:= 'Course Description for Section Id '||p_sectionId||' is Intro to Java Programming';
        DBMS_OUTPUT.PUT_LINE(v_output);
        RETURN v_output;

    EXCEPTION
        WHEN no_data_found THEN
            v_output:= 'There is NO such Section id: '||p_sectionId;
            DBMS_OUTPUT.PUT_LINE(v_output);
            RETURN v_output;
    END Get_Descr;

    PROCEDURE show_bizdays(
        p_startdate DATE DEFAULT SYSDATE,
        p_nextdate NUMBER DEFAULT 30
    ) IS 
        TYPE date_tab_type IS TABLE OF
            DATE INDEX BY PLS_INTEGER;
        v_date date_tab_type;
        v_checkdate DATE;
        v_counter NUMBER := 0;
        v_counter2 NUMBER := 0;
    BEGIN
        WHILE v_counter < p_nextdate
        LOOP
            v_counter2 := v_counter2 + 1;
            v_checkdate := p_startdate + v_counter2;

            IF TO_CHAR(v_checkdate, 'd') NOT IN ('1', '7') THEN
                v_counter := v_counter + 1;
                v_date(v_counter) := p_startdate + v_counter2;
                DBMS_OUTPUT.PUT_LINE('The index is : '||v_counter||' and the table value is: '|| v_date(v_counter));
            END IF;

        END LOOP;
    END show_bizdays;

    PROCEDURE show_bizdays(
        p_startdate2 DATE
    ) IS 
        TYPE date_tab_type IS TABLE OF
            DATE INDEX BY PLS_INTEGER;
        v_date date_tab_type;
        v_checkdate DATE;
        v_counter NUMBER := 0;
        v_counter2 NUMBER := 0;
        v_ndays NUMBER := &numdays;
    BEGIN
        WHILE v_counter < v_ndays
        LOOP
            v_counter2 := v_counter2 + 1;
            v_checkdate := p_startdate2 + v_counter2;

            IF TO_CHAR(v_checkdate, 'd') NOT IN ('1', '7') THEN
                v_counter := v_counter + 1;
                v_date(v_counter) := p_startdate2 + v_counter2;
                DBMS_OUTPUT.PUT_LINE('The index is : '||v_counter||' and the table value is: '|| v_date(v_counter));
            END IF;

        END LOOP;
    END show_bizdays;
END Lab5;
/