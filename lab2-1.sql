ACCEPT scale prompt 'Enter your input scale (C or F) for temperature: ';
ACCEPT t_in prompt 'Enter your temperature value to be converted: ';
DECLARE
    v_scale CHAR(1) := '&scale';
    v_temp NUMBER := &t_in;
    v_output NUMBER(3,1);
BEGIN
    IF UPPER(v_scale) = 'C' THEN
        v_output := (v_temp * 9/5) + 32;
        DBMS_OUTPUT.PUT_LINE('Your converted temperature in F is exactly ' || v_output);

    ELSIF UPPER(v_scale) = 'F' THEN
        v_output := (v_temp - 32) * 5/9;
        DBMS_OUTPUT.PUT_LINE('Your converted temperature in C is exactly ' || v_output);
        
    ELSE
        DBMS_OUTPUT.PUT_LINE (' This is NOT a valid scale. Must be C or F.');
    END IF;
END;
/