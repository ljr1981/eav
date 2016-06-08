note
	description: "[
		Tests of the {EAV_DB_ENABLED} class.
	]"
	testing: "type/manual"

class
	EAV_DB_ABLE_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		redefine
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
			create l_mock
			l_mock.set_first_name ("Bugs")
			l_mock.set_last_name ("Bunny")
			l_mock.set_age (74)
			create l_system.make ("system", "tests\data")
			l_mock.store_in_database (l_mock, l_system.first_database)
			l_system.close_all
			remove_data
		end

feature {NONE} -- Implementation

	on_clean
			-- <Precursor>
		do
			Precursor
			remove_data
		end

	remove_data
			-- `remove_data' from directory path.
		local
			l_path: PATH
			l_dir: DIRECTORY
		do
			create l_path.make_from_string ((create {EXECUTION_ENVIRONMENT}).current_working_path.name.out + "\tests\data\")
			create l_dir.make_with_path (l_path)
			l_dir.do_nothing
			--l_dir.delete_content
		end

end


