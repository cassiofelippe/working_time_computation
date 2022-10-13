-- 2022-10-04

CREATE OR REPLACE FUNCTION is_weekday(target_date timestamp)
RETURNS boolean AS $$
	BEGIN
		RETURN EXTRACT(ISODOW FROM target_date) IN (1, 2, 3, 4, 5);
	END;
$$ LANGUAGE plpgsql;


-- TODO create a holiday database
CREATE OR REPLACE FUNCTION is_holiday(target_date timestamp)
RETURNS boolean AS $$
	BEGIN
		RETURN FALSE;
	END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION is_working_day(target_date timestamp)
RETURNS boolean AS $$
	BEGIN
		RETURN is_weekday(target_date) OR is_holiday(target_date);
	END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION initial_working_time(target_date timestamp)
RETURNS timestamp AS $$
	BEGIN
		target_date := target_date::date + to_timestamp('08:00:00', 'HH24:MI:SS')::time;
	
		RETURN target_date;
	END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION final_working_time(target_date timestamp)
RETURNS timestamp AS $$
	BEGIN
		target_date := target_date::date + to_timestamp('17:00:00', 'HH24:MI:SS "PM"')::time;
	
		RETURN target_date;
	END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION next_working_date(target_date timestamp)
RETURNS timestamp AS $$
	BEGIN
		target_date := initial_working_time(date(target_date) + 1);
	
		WHILE NOT is_working_day(target_date) LOOP
			target_date := initial_working_time(date(target_date) + 1);
		END LOOP;
	
		RETURN target_date;
	END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION last_working_date(target_date timestamp)
RETURNS timestamp AS $$
	BEGIN
		target_date := final_working_time(date(target_date) - 1);
	
		WHILE NOT is_working_day(target_date) LOOP
			target_date := final_working_time(date(target_date) - 1);
		END LOOP;
	
		RETURN target_date;
	END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION working_hours(start_date timestamp, end_date timestamp)
RETURNS interval AS $$
	
	DECLARE
		spent_time	interval;
		

	BEGIN
		spent_time := 0;
	
		IF start_date = end_date THEN
			RETURN 0;
		END IF;

	
		IF is_working_day(start_date) THEN
			start_date := start_date;
		ELSE
			start_date := next_working_date(start_date);
		END IF;
	

		IF start_date::time < '08:00:00' THEN
			start_date := initial_working_time(start_date);
		END IF;
	
		
		IF end_date::time > to_timestamp('17:00:00', 'HH24:MI:SS "PM"')::time THEN
			end_date := final_working_time(end_date);
		END IF;
	
	
		IF start_date::date = end_date::date THEN
			IF NOT is_working_day(start_date) THEN
				RETURN 0;
			END IF;
		
			spent_time := end_date - start_date;
		
			RETURN spent_time;
		END IF;
	
		
		IF NOT is_working_day(end_date) THEN
			end_date := last_working_date(end_date);
		END IF;


		WHILE TRUE LOOP
			IF start_date >= end_date THEN
				EXIT;
			END IF;
		
			IF start_date::date = end_date::date THEN
				spent_time := spent_time + (end_date - start_date);
				EXIT;
			END IF;
		
			spent_time := spent_time + (final_working_time(start_date) - start_date);
			
			start_date := next_working_date(start_date);
		END LOOP;
	
	
		RAISE NOTICE '>> final result %', spent_time;
	
		RETURN spent_time;
	
	END;

$$ LANGUAGE plpgsql;



--SELECT initial_working_time();
--SELECT is_working_day('2022-10-10');

--SELECT EXTRACT(ISODOW FROM current_date) IN (1, 2, 3, 4, 5);



