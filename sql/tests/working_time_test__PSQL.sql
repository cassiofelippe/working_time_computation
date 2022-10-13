CREATE OR REPLACE FUNCTION test_working_hours()
RETURNS text AS $$
	
	DECLARE
		start_date	timestamp;
		end_date	timestamp;
		time_result	interval;
		matches		boolean;
	
	BEGIN
		
		start_date := '2020-01-02 08:00'; end_date := '2020-01-03 17:00'; time_result := working_hours(start_date, end_date); matches := time_result = '18:00:00';
		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
		
		start_date := '2020-01-02 00:00'; end_date := '2020-01-03 23:59'; time_result := working_hours(start_date, end_date); matches := time_result = '18:00:00';
		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
		
		start_date := '2020-01-02 08:00'; end_date := '2020-01-02 23:59'; time_result := working_hours(start_date, end_date); matches := time_result = '09:00:00';
		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
		
		start_date := '2020-01-02 08:30'; end_date := '2020-01-02 16:45'; time_result := working_hours(start_date, end_date); matches := time_result = '08:15:00';
		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
		
		start_date := '2020-01-02 08:00'; end_date := '2020-01-06 12:00'; time_result := working_hours(start_date, end_date); matches := time_result = '22:00:00';
		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
		
		start_date := '2020-01-06 00:00'; end_date := '2020-01-10 23:59'; time_result := working_hours(start_date, end_date); matches := time_result = '45:00:00';
		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
		
		start_date := '2020-01-06 16:30'; end_date := '2020-01-10 09:55'; time_result := working_hours(start_date, end_date); matches := time_result = '29:25:00';
		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
		
		start_date := '2020-01-10 12:15'; end_date := '2020-01-13 11:00'; time_result := working_hours(start_date, end_date); matches := time_result = '07:45';
		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
		
		start_date := '2020-01-06 16:59'; end_date := '2020-01-07 08:01'; time_result := working_hours(start_date, end_date); matches := time_result = '00:02';
		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
		
		start_date := '2020-03-05 07:43'; end_date := '2020-03-05 08:12'; time_result := working_hours(start_date, end_date); matches := time_result = '00:12';
		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
		
		start_date := '2020-03-01 13:48'; end_date := '2020-04-01 16:11'; time_result := working_hours(start_date, end_date); matches := time_result = '206:11';
		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
		
		start_date := '2020-03-05 09:45'; end_date := '2020-03-06 15:22'; time_result := working_hours(start_date, end_date); matches := time_result = '14:37';
		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
		
		start_date := '2020-03-06 12:00'; end_date := '2020-03-08 09:30'; time_result := working_hours(start_date, end_date); matches := time_result = '05:00';
		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
		
--      BR HOLIDAYS

--		start_date := '2019-12-24 16:30'; end_date := '2019-12-26 10:00'; time_result := working_hours(start_date, end_date); matches := time_result = '02:30';
--		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
--		
--		start_date := '2019-12-31 14:23'; end_date := '2020-01-02 11:47'; time_result := working_hours(start_date, end_date); matches := time_result = '06:24';
--		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
		
--		start_date := '2020-01-01 00:00'; end_date := '2020-01-01 23:59'; time_result := working_hours(start_date, end_date); matches := time_result = '00:00';
--		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
--		
--		start_date := '2020-01-01 00:00'; end_date := '2020-01-02 07:00'; time_result := working_hours(start_date, end_date); matches := time_result = '00:00';
--		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
--		
--		start_date := '2020-01-01 00:00'; end_date := '2020-01-01 07:59'; time_result := working_hours(start_date, end_date); matches := time_result = '00:00';
--		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
--		
--		start_date := '2020-01-01 17:00'; end_date := '2020-01-01 23:59'; time_result := working_hours(start_date, end_date); matches := time_result = '00:00';
--		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
--		
--		start_date := '2020-01-01 17:00'; end_date := '2020-01-02 08:00'; time_result := working_hours(start_date, end_date); matches := time_result = '00:00';
--		RAISE NOTICE '>> %, % => %, %', start_date, end_date, time_result, matches; IF NOT matches THEN RETURN concat('FAILED! ', start_date, ' to ', end_date, ' => ', time_result); END IF;
	
		RETURN 'SUCCESS!';
	END;

$$ LANGUAGE plpgsql;

SELECT test_working_hours();