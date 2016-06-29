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
			l_manager: EAV_DATA_MANAGER
			l_mock: MOCK_OBJECT
			l_start,
			l_end: DATE_TIME
			l_mocks: ARRAYED_LIST [MOCK_OBJECT]
			l_ids: ARRAYED_LIST [INTEGER_64]
			l_file: PLAIN_TEXT_FILE
		do
				-- Prep work ...
			create l_system.make ("system", test_data_path)
			create l_file.make_create_read_write ("stress_test_results.txt")

				-- write test ...
			l_mocks := fresh_mocks (Object_count)
			from
				create l_start.make_now
				print (l_start.fine_second.out + " ... waiting until 0.000 ...")
			until
				l_start.fine_second < 1
			loop
				create l_start.make_now
			end
			print ("%N" + l_start.out + "%N")

			l_system.database_n (1).store_objects (l_mocks)

			create l_end.make_now
			print (l_end.out + "%N")

			l_file.put_string (Object_count.out + "x%N")
			l_file.put_string ("start: " + l_start.fine_second.out + "%N")
			l_file.put_string ("end:   " + l_end.fine_second.out + "%N")
			l_file.put_string ("total: " + (l_end.fine_second - l_start.fine_second).out + "%N")

			l_file.close

				-- Read test
--			create l_file.make_create_read_write ("stress_read_results.txt")
--			create l_manager
--			l_manager.set_database (l_system.database_n (1))
--			create l_mock.make_with_reasonable_defaults
--			create l_ids.make (Object_count)
--			across 1 |..| Object_count as ic loop l_ids.force (ic.item.to_integer_64) end

--			create l_start.make_now
--			print ("%N" + l_start.out + "%N")

--			l_system.database_n (1).begin_transaction
--			if attached {ARRAYED_LIST [MOCK_OBJECT]} l_manager.fetch_by_ids (l_mock, l_ids.to_array) as al_array then
--				l_system.database_n (1).end_transaction
--				create l_end.make_now
--				print (l_end.out + "%N")
--				l_mocks := al_array
--			end
--			l_file.put_string (Object_count.out + "x%N")
--			l_file.put_string ("start: " + l_start.fine_second.out + "%N")
--			l_file.put_string ("end:   " + l_end.fine_second.out + "%N")
--			l_file.put_string ("total: " + (l_end.fine_second - l_start.fine_second).out + "%N")

----			across
----				l_mocks as ic
----			loop
----				l_file.put_string (ic.item.first_name_dbe + "%N")
----			end

--			l_file.close

			l_system.close_all
--			remove_data
		end

feature {NONE} -- Implementation

	Object_count: INTEGER = 10_000

	fresh_mocks (a_count: INTEGER): ARRAYED_LIST [MOCK_OBJECT]
			-- `fresh_mocks' for the slaughter.
		local
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
