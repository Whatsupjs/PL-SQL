DECLARE
	v_string VARCHAR2(32);
	v_number NUMBER(8,2);
	v_const CONSTANT CHAR(4) := '704B';
	v_bool BOOLEAN;
	v_week DATE := SYSDATE + 7;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Initialized values: ');
	DBMS_OUTPUT.PUT_LINE('Constant: ' || v_const);
	DBMS_OUTPUT.PUT_LINE('Week from now: ' || v_week);
	
	v_string := 'C++ advanced';
	
	IF v_string LIKE '%SQL%' THEN 
		DBMS_OUTPUT.PUT_LINE('Name of the course: ' || v_string);
	ELSIF v_const = '704B' THEN 
		IF v_string is NOT NULL THEN
			DBMS_OUTPUT.PUT_LINE('Name of the course and room number: ' || v_string ||', '|| v_const);
		ELSE
			DBMS_OUTPUT.PUT_LINE('Name of the course and room number: Course is unknown, ' || v_const);
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('Course and location could not be determined');
	END IF;
END;

