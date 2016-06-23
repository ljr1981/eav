note
	description: "[
		Representation of a {STRESS_LIBRARY_APPLICATION}.
		]"

class
	STRESS_LIBRARY_APPLICATION

inherit
	RANDOMIZER

	EAV_TEST_DATA_HELPER
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make
			-- `make' Current.
		local
			l_system: EAV_SYSTEM
			l_mock: MOCK_OBJECT
			l_start,
			l_end: DATE_TIME
			l_mocks: ARRAYED_LIST [MOCK_OBJECT]
			l_file: PLAIN_TEXT_FILE
		do
				-- Prep work ...
			create l_system.make ("system", test_data_path)
			create l_file.make_create_read_write ("stress_test_results.txt")

				-- 10_000 x test of 3x dbe features ...
			l_mocks := fresh_mocks (10_000)
			create l_start.make_now
			print ("%N" + l_start.out + "%N")

			l_system.database_n (1).store_objects (l_mocks)

			create l_end.make_now
			print (l_end.out + "%N")

			l_file.put_string ("10_000x%N")
			l_file.put_string ("start: " + l_start.fine_second.out + "%N")
			l_file.put_string ("end:   " + l_end.fine_second.out + "%N")
			l_file.put_string ("total: " + (l_end.fine_second - l_start.fine_second).out + "%N")

			l_file.close
			l_system.close_all
			remove_data
		end

feature {NONE} -- Implementation

	fresh_mocks (a_count: INTEGER): ARRAYED_LIST [MOCK_OBJECT]
			-- `fresh_mocks' for the slaughter.
		local
			l_randomizer: RANDOMIZER
			l_mock: MOCK_OBJECT
		do
			create Result.make (a_count)
			across
				1 |..| a_count as ic
			loop
				create l_mock.make_with_reasonable_defaults
				l_mock.set_first_name_dbe (random_first_name)
				l_mock.set_last_name_dbe (random_last_name)
				l_mock.set_age_dbe (random_integer_in_range (18 |..| 120))
				Result.force (l_mock)
			end
		end

end
