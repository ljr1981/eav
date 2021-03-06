note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	EAV_DATA_MANAGER_TEST_SET

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

feature -- Test routines

	fetch_by_id_test
			-- `fetch_by_id_test'.
		note
			testing: "execution/isolated", "execution/serial"
		local
			l_system: EAV_SYSTEM
			l_manager: EAV_DATA_MANAGER
			l_mock: MOCK_OBJECT
		do
				-- Prep work ...
			remove_data
			create l_system.make ("system", test_data_path)

				-- Create Foghorn ...
			create l_mock.make_with_reasonable_defaults
			l_mock.set_database (l_system.database_n (1))
			l_mock.set_first_name_dbe ("Foghorn")
			l_mock.set_last_name_dbe ("Leghorn")
			l_mock.set_age_dbe (35)
			l_mock.store_in_database (l_mock, l_system.database_n (1))

			create l_manager
			l_manager.set_database (l_system.database_n (1))
			create l_mock.make_with_reasonable_defaults

				-- Ensure it is empty ...
			assert_strings_equal ("empty_first_name", "", l_mock.first_name_dbe)

				-- Fetch the `l_mock' #1 and entity_id based on `l_mock'
			l_manager.fetch_by_id (l_mock, 1, l_manager.entity_id (l_mock))
			assert_strings_equal ("first_name", "Foghorn", l_mock.first_name_dbe)
			assert_strings_equal ("last_name", "Leghorn", l_mock.last_name_dbe)
			assert_integers_equal ("age", 35, l_mock.age_dbe)

				-- Clean-up and housekeeping ...
			l_system.close_all
			remove_data
		end

end


