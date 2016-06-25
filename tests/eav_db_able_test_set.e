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

	creation_and_setter_tests
			-- `db_able_creation_tests'
		note
			testing:
				"execution/isolated",
				"execution/serial"
		local
			l_mock: MOCK_OBJECT
		do
			create l_mock.make_with_reasonable_defaults

				-- Ensure *_dbe fields are working for "getters" ...
			assert_integers_equal ("field_count", 3, l_mock.dbe_enabled_features (l_mock).count)
			assert_booleans_equal ("first_name", True, l_mock.dbe_enabled_features (l_mock).has_key ("first_name_dbe"))
			assert_booleans_equal ("last_name", True, l_mock.dbe_enabled_features (l_mock).has_key ("last_name_dbe"))
			assert_strings_equal ("last_name", "last_name", l_mock.dbe_enabled_features (l_mock).iteration_item (1).feature_name)
			assert_booleans_equal ("age_dbe", True, l_mock.dbe_enabled_features (l_mock).has_key ("age_dbe"))

				-- Ensure *_dbe feilds are working for "setters" ...
			assert_integers_equal ("setter_count", 3, l_mock.dbe_enabled_setter_features (l_mock).count)

		end

	setters_tests
			-- `setters_tests'.
		note
			testing:
				"execution/isolated",
				"execution/serial"
		local
			l_system: EAV_SYSTEM
			l_mock: MOCK_OBJECT
		do
			create l_system.make ("system", test_data_path)
			create l_mock.make_with_reasonable_defaults

			check attached {attached like tuple_anchor} l_mock.dbe_enabled_setter_features (l_mock).item ("age_dbe") as al_tuple then
				al_tuple.setter_agent.call ([27])
				assert_integers_equal ("27", 27, l_mock.age_dbe)
			end
			l_mock.set_field (l_mock, "age", 30)
			assert_integers_equal ("30", 30, l_mock.age_dbe)

			check attached {attached like tuple_anchor} l_mock.dbe_enabled_setter_features (l_mock).item ("first_name_dbe") as al_tuple then
				al_tuple.setter_agent.call (["fred"])
				assert_strings_equal ("fred", "fred", l_mock.first_name_dbe)
			end
			l_mock.set_field (l_mock, "first_name", "barney")
			assert_strings_equal ("barney", "barney", l_mock.first_name_dbe)

				-- Clean-up and housekeeping ...
			l_system.close_all
			remove_data
		end

feature {NONE} -- Test Support

	tuple_anchor: detachable TUPLE [setter_agent: PROCEDURE [detachable ANY]; setter_name: STRING_8]

feature -- Storable Tests

	db_enabled_store_tests
			-- `db_enabled_store_tests'
		note
			testing:
				"execution/isolated",
				"execution/serial"
		local
			l_system: EAV_SYSTEM
			l_mock: MOCK_OBJECT
		do
				-- Prep work ...
			create l_system.make ("system", test_data_path)

				-- Create Bugsy boy ...
			create l_mock.make_with_reasonable_defaults
			l_mock.set_first_name_dbe ("Bugs")
			l_mock.set_last_name_dbe ("Bunny")
			l_mock.set_age_dbe (74)
			l_mock.store_in_database (l_mock, l_system.database_n (1))

				-- Clean-up and housekeeping ...
			l_system.close_all
			remove_data
		end

	two_entities_tests
			-- `two_entities_tests'
		note
			testing:
				"execution/isolated",
				"execution/serial"
		local
			l_system: EAV_SYSTEM
			l_bugs,
			l_elmer: MOCK_OBJECT
		do
				-- Prep-work ...
			create l_system.make ("system", test_data_path)

				-- Handle Bugsy first ...
			create l_bugs.make_with_reasonable_defaults
			l_bugs.set_first_name_dbe ("Bugs")
			l_bugs.set_last_name_dbe ("Bunny")
			l_bugs.set_age_dbe (74)
			l_bugs.store_in_database (l_bugs, l_system.database_n (1))

				-- Now do Elmer ...
			create l_elmer.make_with_reasonable_defaults
			l_elmer.set_first_name_dbe ("Elmer")
			l_elmer.set_last_name_dbe ("Fudd")
			l_elmer.set_age_dbe (73)
			l_elmer.store_in_database (l_elmer, l_system.database_n (1))

				-- Cleanup
			l_system.close_all
			remove_data
		end

	changing_object_data_tests
			-- `changing_object_data_tests'
		note
			testing:
				"execution/isolated",
				"execution/serial"
		local
			l_system: EAV_SYSTEM
			l_mock: MOCK_OBJECT
		do
				-- Prep work ...
			create l_system.make ("system", test_data_path)

				-- Create Bugsy boy ...
			create l_mock.make_with_reasonable_defaults
			l_mock.set_first_name_dbe ("Bugs")
			l_mock.set_last_name_dbe ("Bunny")
			l_mock.set_age_dbe (74)
			l_mock.store_in_database (l_mock, l_system.database_n (1))

				-- Give us a change and ensure the same object is changed
				-- and not a new object created with the changed data.
			l_mock.set_age_dbe (29)
			l_mock.store_in_database (l_mock, l_system.database_n (1))

				-- Clean-up and housekeeping ...
			l_system.close_all
			remove_data
		end

end


