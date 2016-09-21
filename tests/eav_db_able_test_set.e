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
				"execution/serial/group_1"
		local
			l_mock: MOCK_OBJECT
		do
			create l_mock.make_with_reasonable_defaults

				-- Ensure *_dbe fields are working for "getters" ...
			assert_integers_equal ("field_count", 4, l_mock.dbe_enabled_features (l_mock).count)
			assert_booleans_equal ("first_name", True, l_mock.dbe_enabled_features (l_mock).has_key ("first_name_dbe"))
			assert_booleans_equal ("last_name", True, l_mock.dbe_enabled_features (l_mock).has_key ("last_name_dbe"))
			assert_strings_equal ("last_name", "last_name", l_mock.dbe_enabled_features (l_mock).iteration_item (1).feature_name)
			assert_booleans_equal ("age_dbe", True, l_mock.dbe_enabled_features (l_mock).has_key ("age_dbe"))

				-- Ensure *_dbe feilds are working for "setters" ...
			assert_integers_equal ("setter_count", 4, l_mock.dbe_enabled_setter_features (l_mock).count)

		end

	setters_tests
			-- `setters_tests'.
		note
			testing:
				"execution/isolated",
				"execution/serial/group_1"
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

	test_SELECT_generation
		note
			testing:
				"execution/isolated",
				"execution/serial/group_1"
		local
			l_mock: MOCK_OBJECT
			l_system: EAV_SYSTEM
			l_manager: EAV_DATA_MANAGER
		do
			create l_system.make ("system", test_data_path)
			create l_manager
			l_manager.set_database (l_system.database_n (1))

			create l_mock.make_with_reasonable_defaults
			l_mock.set_first_name_dbe ("test_first")
			l_mock.set_last_name_dbe ("test_last")
			l_mock.set_age_dbe (1)
			l_mock.save_in_database (l_mock, l_system.database_n (1))

			assert_strings_equal ("SQL_SELECT", select_test_string, l_manager.SELECT_all_columns_with_filters (l_mock, <<["p1.instance_id", "=", "1", ""]>>).text)

			l_system.close_all
			remove_data
		end

	test_SELECT_operation
		note
			testing:
				"execution/isolated",
				"execution/serial/group_1"
		local
			l_mock: MOCK_OBJECT
			l_system: EAV_SYSTEM
			l_manager: EAV_DATA_MANAGER
			l_results: ARRAYED_LIST [EAV_DB_ENABLED]
			l_TUPLE_Results: ARRAYED_LIST [TUPLE]
		do
			create l_system.make ("system", test_data_path)
			create l_manager
			l_manager.set_database (l_system.database_n (1))

			create l_mock.make_with_reasonable_defaults
			l_mock.set_first_name_dbe ("Fred")
			l_mock.set_last_name_dbe ("Flintstone")
			l_mock.set_age_dbe (30)
			l_mock.save_in_database (l_mock, l_system.database_n (1))

			create l_mock.make_with_reasonable_defaults
			l_mock.set_first_name_dbe ("Wilma")
			l_mock.set_last_name_dbe ("Flintstone")
			l_mock.set_age_dbe (29)
			l_mock.save_in_database (l_mock, l_system.database_n (1))

			create l_mock.make_with_reasonable_defaults
			l_results := l_manager.database.fetch_Object_list_by_SELECT (l_mock, l_manager.SELECT_all_columns_with_filters (l_mock, <<>>))

			assert_integers_equal ("two_objects", 2, l_results.count)

			check is_mock_object_1: attached {MOCK_OBJECT} l_results [1] as al_mock_object then
				assert_strings_equal ("fred", "Fred", al_mock_object.first_name_dbe)
				assert_strings_equal ("fred_flintstone", "Flintstone", al_mock_object.last_name_dbe)
				assert_integers_equal ("fred_age", 30, al_mock_object.age_dbe)
			end
			check is_mock_object_1: attached {MOCK_OBJECT} l_results [2] as al_mock_object then
				assert_strings_equal ("wilma", "Wilma", al_mock_object.first_name_dbe)
				assert_strings_equal ("wilma_flintstone", "Flintstone", al_mock_object.last_name_dbe)
				assert_integers_equal ("wilma_age", 29, al_mock_object.age_dbe)
			end

			create l_mock.make_with_reasonable_defaults
			l_results := l_manager.database.fetch_Object_list_by_SELECT (l_mock, l_manager.SELECT_all_columns_with_filters (l_mock, <<["first_name", "=", "'Fred'", ""]>>))

			assert_integers_equal ("one_object", 1, l_results.count)

			check is_mock_object_1b: attached {MOCK_OBJECT} l_results [1] as al_mock_object then
				assert_strings_equal ("fred_2", "Fred", al_mock_object.first_name_dbe)
				assert_strings_equal ("fred_flintstone_2", "Flintstone", al_mock_object.last_name_dbe)
				assert_integers_equal ("fred_age_2", 30, al_mock_object.age_dbe)
			end

			create l_mock.make_with_reasonable_defaults
			l_results := l_manager.database.fetch_Object_list_by_SELECT (l_mock, l_manager.SELECT_all_columns_with_filters (l_mock, <<["age", "=", "30", ""]>>))

			assert_integers_equal ("one_object_2", 1, l_results.count)

			check is_mock_object_1b: attached {MOCK_OBJECT} l_results [1] as al_mock_object then
				assert_strings_equal ("fred_3", "Fred", al_mock_object.first_name_dbe)
				assert_strings_equal ("fred_flintstone_3", "Flintstone", al_mock_object.last_name_dbe)
				assert_integers_equal ("fred_age_3", 30, al_mock_object.age_dbe)
			end

			create l_mock.make_with_reasonable_defaults
			l_mock.set_first_name_dbe ("Barney")
			l_mock.set_last_name_dbe ("Rubble")
			l_mock.set_age_dbe (30)
			l_mock.save_in_database (l_mock, l_system.database_n (1))

			create l_mock.make_with_reasonable_defaults
			l_mock.set_first_name_dbe ("Betty")
			l_mock.set_last_name_dbe ("Rubble")
			l_mock.set_age_dbe (29)
			l_mock.save_in_database (l_mock, l_system.database_n (1))


			create l_mock.make_with_reasonable_defaults
			l_results := l_manager.database.fetch_Object_list_by_SELECT (l_mock, l_manager.SELECT_all_columns_with_filters (l_mock, <<["age", "=", "30", ""]>>))

			assert_integers_equal ("two_object_2", 2, l_results.count)

			check is_mock_object_1b: attached {MOCK_OBJECT} l_results [1] as al_mock_object then
				assert_strings_equal ("fred_4", "Fred", al_mock_object.first_name_dbe)
				assert_strings_equal ("fred_flintstone_4", "Flintstone", al_mock_object.last_name_dbe)
				assert_integers_equal ("fred_age_4", 30, al_mock_object.age_dbe)
			end
			check is_mock_object_1b: attached {MOCK_OBJECT} l_results [2] as al_mock_object then
				assert_strings_equal ("barney", "Barney", al_mock_object.first_name_dbe)
				assert_strings_equal ("barney_rubble", "Rubble", al_mock_object.last_name_dbe)
				assert_integers_equal ("barney_age", 30, al_mock_object.age_dbe)
			end

			create l_mock.make_with_reasonable_defaults
			l_results := l_manager.database.fetch_Object_list_by_SELECT (l_mock, l_manager.SELECT_some_columns_with_filters (l_mock, <<>>, <<["age", "=", "30", ""]>>))
			assert_integers_equal ("some_two_object_1", 2, l_results.count)

			create l_mock.make_with_reasonable_defaults
			l_results := l_manager.database.fetch_Object_list_by_SELECT (l_mock, l_manager.SELECT_some_columns_with_filters (l_mock, <<"*">>, <<["age", "=", "30", ""]>>))
			assert_integers_equal ("some_two_object_2", 2, l_results.count)

			create l_mock.make_with_reasonable_defaults
			l_TUPLE_Results := l_manager.database.fetch_tuples_by_select (l_mock, l_manager.select_some_columns_with_filters (l_mock, <<"age">>, <<["age", "=", "30", ""]>>))
			assert_integers_equal ("some_TUPLE_two_object_1", 2, l_TUPLE_Results.count)
			if attached {TUPLE} l_TUPLE_Results.at (1) as al_inner and then attached {INTEGER} al_inner.at (1) as al_instance_id then
				assert_integers_equal ("instance_id_is_1", 1, al_instance_id)
			end
			if attached {TUPLE} l_TUPLE_Results.at (2) as al_inner and then attached {INTEGER} al_inner.at (1) as al_instance_id then
				assert_integers_equal ("instance_id_is_2", 3, al_instance_id)
			end

			l_system.close_all
			remove_data
		end

feature {NONE} -- Testing: SELECT support

	select_test_string: STRING = "SELECT p1.instance_id, p1.val_item AS first_name,p2.val_item AS last_name,p3.val_item AS parent_id,p4.val_item AS age FROM Attribute JOIN Value_text AS p1 ON p1.atr_id = 1 JOIN Value_text AS p2 ON p1.instance_id = p2.instance_id AND p2.atr_id = 2 JOIN Value_integer AS p3 ON p1.instance_id = p3.instance_id AND p3.atr_id = 3 JOIN Value_integer AS p4 ON p1.instance_id = p4.instance_id AND p4.atr_id = 4    WHERE  p1.instance_id = 1  GROUP BY p1.instance_id;"

feature {NONE} -- Test Support

	tuple_anchor: detachable TUPLE [setter_agent: PROCEDURE [detachable ANY]; setter_name: STRING_8]

feature -- Storable Tests

	db_enabled_store_tests
			-- `db_enabled_store_tests'
		note
			testing:
				"execution/isolated",
				"execution/serial/group_1"
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
				"execution/serial/group_1"
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
				"execution/serial/group_1"
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


