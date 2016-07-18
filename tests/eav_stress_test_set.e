note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	EAV_STRESS_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		undefine
			on_clean
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

	EAV_TEST_DATA_HELPER
		undefine
			default_create
		end

	RANDOMIZER
		undefine
			default_create
		end

feature -- Testing: EAV writing

	write_test
			-- `write_test'
		note
			testing:
				"execution/isolated",
				"execution/serial/group_1"
		local
			l_system: EAV_SYSTEM
			l_manager: EAV_DATA_MANAGER
			l_mock: MOCK_OBJECT
			l_start,
			l_end: DATE_TIME
			l_mocks: ARRAYED_LIST [MOCK_OBJECT]
		do
				-- Prep work ...
			create l_system.make ("system", test_data_path)

				-- 10x test of 3x dbe features ...
			l_mocks := fresh_mocks (10)
			create l_start.make_now
			l_system.database_n (1).store_objects (l_mocks)
			create l_end.make_now
			print ("start: " + l_start.fine_second.out + "%N")
			print ("end:   " + l_end.fine_second.out + "%N")
			assert_32 ("10x_not_less", (l_end.fine_second - l_start.fine_second) < 0.15) -- 0.8421 */- = 0.08421/object = 712/objects-per-minute

				-- 10x test of 3x dbe features ...
			l_mocks := fresh_mocks (712)
			create l_start.make_now
			l_system.database_n (1).store_objects (l_mocks)
			create l_end.make_now
			print ("start: " + l_start.fine_second.out + "%N")
			print ("end:   " + l_end.fine_second.out + "%N")
			assert_32 ("10x_not_less", (l_end.fine_second - l_start.fine_second) < 2.1) -- 0.8421 */- = 0.08421/object = 712/objects-per-minute

			l_system.close_all
			remove_data
		end

feature {NONE} -- Test Support - `write_test'

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


