SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET PAGESIZE 120;
/*
--1
DECLARE
    CURSOR c_coursedesc_cursor IS
    SELECT description 
    FROM Course
    WHERE prerequisite IS NULL
    ORDER BY description;
    v_coursedesc Course.description%TYPE;
    v_counter NUMBER(2) := 0;
BEGIN
    OPEN c_coursedesc_cursor;
    LOOP
        FETCH c_coursedesc_cursor INTO v_coursedesc;
        EXIT WHEN c_coursedesc_cursor%NOTFOUND;
        v_counter := v_counter + 1;
        DBMS_OUTPUT.PUT_LINE('Course Description : '||v_counter||': '||v_coursedesc);
    END LOOP;
    CLOSE c_coursedesc_cursor;

    DBMS_OUTPUT.PUT_LINE('************************************');
    DBMS_OUTPUT.PUT_LINE('Total # of Courses without the Prerequisite is: '||v_counter);
END;
*/
/*
--2
DECLARE
    CURSOR c_coursedesc_cursor IS
    SELECT description 
    FROM Course
    WHERE prerequisite IS NULL
    ORDER BY description;

    TYPE course_table_type IS TABLE OF
        Course.description%TYPE INDEX BY PLS_INTEGER;
    my_course_table course_table_type;
    
    v_counter NUMBER(2) := 0;
BEGIN
    FOR course_record IN c_coursedesc_cursor
    LOOP
        v_counter := v_counter + 1;    
        my_course_table(v_counter) := course_record.description;
        DBMS_OUTPUT.PUT_LINE('Course Description : '||v_counter||': '||my_course_table(v_counter));
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('************************************');
    DBMS_OUTPUT.PUT_LINE('Total # of Courses without the Prerequisite is: '|| my_course_table.count);
END;
*/
--3 join student and zip table
--4 check chap 7 example check lesson 6 q2,q6 for assignment **
/*
--3
ACCEPT zipcode PROMPT 'Enter first 3 digits for zipcode: '
DECLARE
    CURSOR zip_cursor IS
    SELECT zip, COUNT(student_id) studentcount
    FROM Student
    WHERE zip LIKE '&zipcode%'
    GROUP BY zip
    ORDER BY zip;
    
    TYPE t_rec IS RECORD(
        zip NUMBER,
        studentcount NUMBER(3)
    );

    zip_rec t_rec;
    tot_stud NUMBER(3) := 0;
    tot_zip NUMBER(3) := 0;
    e_nodata EXCEPTION;
BEGIN
    OPEN zip_cursor;
    LOOP
        FETCH zip_cursor INTO zip_rec;
        EXIT WHEN zip_cursor%NOTFOUND;
        tot_stud := tot_stud + zip_rec.studentcount;
        tot_zip := tot_zip + 1;
        DBMS_OUTPUT.PUT_LINE('Zip code : '||zip_rec.zip||' has exactly '||zip_rec.studentcount||' students enrolled.');
    END LOOP;
    IF tot_zip = 0 THEN 
        RAISE e_nodata;
    ELSE
        DBMS_OUTPUT.PUT_LINE('*************************************');
        DBMS_OUTPUT.PUT_LINE('Total # of zip codes under '||'&zipcode'||' is '|| tot_zip);
        DBMS_OUTPUT.PUT_LINE('Total # of Students under zip code '||'&zipcode'||' is '||tot_stud);
    END IF;
    CLOSE zip_cursor;
EXCEPTION
    WHEN e_nodata THEN
        DBMS_OUTPUT.PUT_LINE('This zip area is student empty. Please, try again.');
END;
*/

--4 No need for JOIN to Zipcode table. 
ACCEPT zipcode PROMPT 'Enter first 3 digits for zipcode: '
DECLARE
    CURSOR zip_cursor IS
    SELECT zip, COUNT(student_id) studentcount
    FROM Student
    WHERE zip LIKE '&zipcode%'
    GROUP BY zip
    ORDER BY zip;
    
    TYPE zip_table_type IS TABLE OF
        zip_cursor%ROWTYPE
        INDEX BY PLS_INTEGER;

    zip_table zip_table_type;
    tot_stud NUMBER(3) := 0;
    v_counter NUMBER(3) := 0;

    e_nodata EXCEPTION;
BEGIN
    FOR zip_rec in zip_cursor
    LOOP
        v_counter := v_counter + 1;
        zip_table(v_counter) := zip_rec;
        tot_stud := tot_stud + zip_table(v_counter).studentcount;
        DBMS_OUTPUT.PUT_LINE('Zip code : '||zip_table(v_counter).zip||' has exactly '||zip_table(v_counter).studentcount||' students enrolled.');
    END LOOP;
    IF zip_table.count = 0 THEN 
        RAISE e_nodata;
    ELSE
        DBMS_OUTPUT.PUT_LINE('*************************************');
        DBMS_OUTPUT.PUT_LINE('Total # of zip codes under '||'&zipcode'||' is '||zip_table.count);
        DBMS_OUTPUT.PUT_LINE('Total # of Students under zip code '||'&zipcode'||' is '||tot_stud);
    END IF;
EXCEPTION
    WHEN e_nodata THEN
        DBMS_OUTPUT.PUT_LINE('This zip area is student empty. Please, try again.');
END;
/

