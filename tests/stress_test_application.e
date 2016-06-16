note
	description: "Summary description for {STRESS_TEST_APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STRESS_TEST_APPLICATION

inherit
	RANDOMIZER

create
	make

feature {NONE} -- Initialization

	make
			-- `make' Current.
		local
			l_system: EAV_SYSTEM
			l_manager: EAV_DATA_MANAGER [MOCK_OBJECT]
			l_mock: MOCK_OBJECT
			l_start,
			l_end: DATE_TIME
			l_mocks: ARRAYED_LIST [MOCK_OBJECT]
			l_file: PLAIN_TEXT_FILE
		do
				-- Prep work ...
			create l_system.make ("system", "\tests\data\")
			create l_file.make_create_read_write ("stress_test_results.txt")

				-- 10x test of 3x dbe features ...
			l_mocks := fresh_mocks (10)
			create l_start.make_now
			across
				l_mocks as ic_mocks
			loop
				ic_mocks.item.store_in_database (ic_mocks.item, l_system.first_database)
			end
			create l_end.make_now
			l_file.put_string ("10x%N")
			l_file.put_string ("start: " + l_start.fine_second.out + "%N")
			l_file.put_string ("end:   " + l_end.fine_second.out + "%N")
			l_file.put_string ("total: " + (l_end.fine_second - l_start.fine_second).out + "%N")

				-- 712x test of 3x dbe features ...
			l_mocks := fresh_mocks (712)
			create l_start.make_now
			across
				l_mocks as ic_mocks
			loop
				ic_mocks.item.store_in_database (ic_mocks.item, l_system.first_database)
			end
			create l_end.make_now
			l_file.put_string ("712x%N")
			l_file.put_string ("start: " + l_start.fine_second.out + "%N")
			l_file.put_string ("end:   " + l_end.fine_second.out + "%N")
			l_file.put_string ("total: " + (l_end.fine_second - l_start.fine_second).out + "%N")



			l_file.close
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
