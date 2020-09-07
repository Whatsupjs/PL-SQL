	-- c-a
DECLARE
	v_id Lab1_tab.Id%TYPE;
	v_lname Lab1_tab.LName%TYPE;
BEGIN
	-- c-b
	BEGIN
		SELECT last_name INTO v_lname
		FROM STUDENT
		WHERE student_id IN (
			SELECT student_id
			FROM ENROLLMENT
			GROUP BY student_id
			HAVING COUNT(*) = (SELECT MAX(COUNT(*))
				FROM ENROLLMENT
				GROUP BY student_id)
		AND LENGTH(last_name) < 9);
	EXCEPTION
		WHEN TOO_MANY_ROWS THEN
			v_lname := 'Multiple Names';
	END;
	INSERT INTO Lab1_tab
	VALUES(Lab1_seq.NEXTVAL, v_lname);
	
	-- c-c
	BEGIN
		SELECT last_name INTO v_lname
		FROM STUDENT
		WHERE student_id IN (
			SELECT student_id
			FROM ENROLLMENT
			GROUP BY student_id
			HAVING COUNT(*) = (SELECT MIN(COUNT(*))
				FROM ENROLLMENT
				GROUP BY student_id));
	EXCEPTION
		WHEN TOO_MANY_ROWS THEN
			v_lname := 'Multiple Names';
	END;
	INSERT INTO Lab1_tab
	VALUES(Lab1_seq.NEXTVAL, v_lname);
	
	-- c-d
	BEGIN
		SELECT last_name INTO v_lname
		FROM INSTRUCTOR
		WHERE instructor_id IN (
			SELECT instructor_id
			FROM SECTION
			GROUP BY instructor_id
			HAVING COUNT(*) = (SELECT MIN(COUNT(*))
				FROM SECTION
				GROUP BY instructor_id))
		AND last_name NOT LIKE '%s';
	EXCEPTION
		WHEN TOO_MANY_ROWS THEN
			v_lname := 'Multiple Names';
	END;
	INSERT INTO Lab1_tab
	VALUES(v_id, v_lname);
	
	-- c-e
	BEGIN
		SELECT last_name INTO v_lname
		FROM INSTRUCTOR
		WHERE instructor_id IN (
			SELECT instructor_id
			FROM SECTION
			GROUP BY instructor_id
			HAVING COUNT(*) = (SELECT MAX(COUNT(*))
				FROM SECTION
				GROUP BY instructor_id));
	EXCEPTION
		WHEN TOO_MANY_ROWS THEN
			v_lname := 'Multiple Names';
	END;
	INSERT INTO Lab1_tab
	VALUES(Lab1_seq.NEXTVAL, v_lname);
		
END;