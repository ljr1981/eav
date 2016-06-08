note
	description: "[
		Tests of the {EAV_DB_ENABLED} class.
	]"
	testing: "type/manual",
				"execution/serial",
				"execution/isolated"

class
	EAV_DB_ABLE_TEST_SET

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

feature -- Creation Tests

	db_able_creation_tests
			-- `db_able_creation_tests'
		local
			l_mock: MOCK_OBJECT
		do
			create l_mock
			assert_integers_equal ("field_count", 3, l_mock.db_enabled_features (l_mock).count)
			assert_booleans_equal ("first_name", True, l_mock.db_enabled_features (l_mock).has_key ("first_name_dbe"))
			assert_booleans_equal ("last_name", True, l_mock.db_enabled_features (l_mock).has_key ("last_name_dbe"))
			assert_strings_equal ("last_name", "last_name", l_mock.db_enabled_features (l_mock).iteration_item (1).feature_name)
			assert_booleans_equal ("age_dbe", True, l_mock.db_enabled_features (l_mock).has_key ("age_dbe"))
		end

feature -- Storable Tests

	db_enabled_store_tests
			-- `db_enabled_store_tests'
		local
			l_system: EAV_SYSTEM
			l_mock: MOCK_OBJECT
		do
				-- Prep work ...
			create l_system.make ("system", test_data_path)

				-- Create Bugsy boy ...
			create l_mock
			l_mock.set_first_name ("Bugs")
			l_mock.set_last_name ("Bunny")
			l_mock.set_age (74)
			l_mock.store_in_database (l_mock, l_system.first_database)

				-- Clean-up and housekeeping ...
			l_system.close_all
			remove_data
		end

	two_entities_tests
			-- `two_entities_tests'
		local
			l_system: EAV_SYSTEM
			l_bugs,
			l_elmer: MOCK_OBJECT
		do
				-- Prep-work ...
			create l_system.make ("system", test_data_path)

				-- Handle Bugsy first ...
			create l_bugs
			l_bugs.set_first_name ("Bugs")
			l_bugs.set_last_name ("Bunny")
			l_bugs.set_age (74)
			l_bugs.store_in_database (l_bugs, l_system.first_database)

				-- Now do Elmer ...
			create l_elmer
			l_elmer.set_first_name ("Elmer")
			l_elmer.set_last_name ("Fudd")
			l_elmer.set_age (73)
			l_elmer.store_in_database (l_elmer, l_system.first_database)

				-- Cleanup
			l_system.close_all
			remove_data
		end

	changing_object_data_tests
			-- `changing_object_data_tests'
		local
			l_system: EAV_SYSTEM
			l_mock: MOCK_OBJECT
		do
				-- Prep work ...
			create l_system.make ("system", test_data_path)

				-- Create Bugsy boy ...
			create l_mock
			l_mock.set_first_name ("Bugs")
			l_mock.set_last_name ("Bunny")
			l_mock.set_age (74)
			l_mock.store_in_database (l_mock, l_system.first_database)

				-- Give us a change and ensure the same object is changed
				-- and not a new object created with the changed data.
			l_mock.set_age (29)
			l_mock.store_in_database (l_mock, l_system.first_database)

				-- Clean-up and housekeeping ...
			l_system.close_all
			remove_data
		end

end


