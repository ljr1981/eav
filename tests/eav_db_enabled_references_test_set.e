note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	EAV_DB_ENABLED_REFERENCES_TEST_SET

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

	multi_mock_type_tests
			-- New test routine
		note
			testing:
				"execution/isolated",
				"execution/serial"
		local
			l_fred,
			l_wilma,
			l_barney,
			l_betty,
			l_pebbles,
			l_bambam,
			l_parent: MOCK_OBJECT

			l_product: MOCK_PRODUCT

			l_patient: MOCK_PATIENT

			l_system: EAV_SYSTEM
			l_manager: EAV_DATA_MANAGER
			l_results: ARRAYED_LIST [MOCK_OBJECT]
			l_TUPLE_Results: ARRAYED_LIST [TUPLE]
		do
			create l_system.make ("system", test_data_path)
			create l_manager
			l_manager.set_database (l_system.database_n (1))

			create l_fred.make_with_reasonable_defaults
			l_fred.set_first_name_dbe ("Fred")
			l_fred.set_last_name_dbe ("Flintstone")
			l_fred.set_age_dbe (30)
			l_fred.save_in_database (l_fred, l_system.database_n (1))

			create l_product.make_with_reasonable_defaults
			l_product.set_make_dbe ("my_make")
			l_product.set_model_dbe ("my_model")
			l_product.set_count_dbe (1_000)
			l_product.save_in_database (l_product, l_system.database_n (1))

			create l_patient.make_with_reasonable_defaults
			l_patient.set_first_name_dbe ("my_first_name")
			l_patient.save_in_database (l_patient, l_system.database_n (1))

				-- Clean-up and housekeeping ...
			l_system.close_all
			remove_data
		end

	reference_object_tests
			-- New test routine
		note
			testing:
				"execution/isolated",
				"execution/serial"
		local
			l_fred,
			l_wilma,
			l_barney,
			l_betty,
			l_pebbles,
			l_bambam,
			l_parent: MOCK_OBJECT

			l_system: EAV_SYSTEM
			l_manager: EAV_DATA_MANAGER
			l_results: ARRAYED_LIST [MOCK_OBJECT]
			l_TUPLE_Results: ARRAYED_LIST [TUPLE]
		do
			create l_system.make ("system", test_data_path)
			create l_manager
			l_manager.set_database (l_system.database_n (1))

			create l_fred.make_with_reasonable_defaults
			l_fred.set_first_name_dbe ("Fred")
			l_fred.set_last_name_dbe ("Flintstone")
			l_fred.set_age_dbe (30)
			l_fred.save_in_database (l_fred, l_system.database_n (1))

			create l_wilma.make_with_reasonable_defaults
			l_wilma.set_first_name_dbe ("Wilma")
			l_wilma.set_last_name_dbe ("Flintstone")
			l_wilma.set_age_dbe (29)
			l_wilma.save_in_database (l_wilma, l_system.database_n (1))

			l_fred.set_child (l_wilma)
			l_fred.save_in_database (l_fred, l_system.database_n (1))
			l_wilma.save_in_database (l_wilma, l_system.database_n (1))

			create l_barney.make_with_reasonable_defaults
			l_barney.set_first_name_dbe ("Barney")
			l_barney.set_last_name_dbe ("Rubble")
			l_barney.set_age_dbe (29)
			l_barney.save_in_database (l_barney, l_system.database_n (1))

			create l_betty.make_with_reasonable_defaults
			l_betty.set_first_name_dbe ("Betty")
			l_betty.set_last_name_dbe ("Rubble")
			l_betty.set_age_dbe (29)
			l_betty.save_in_database (l_betty, l_system.database_n (1))

			l_barney.set_child (l_betty)
			l_barney.save_in_database (l_barney, l_system.database_n (1))
			l_betty.save_in_database (l_betty, l_system.database_n (1))

				-- Clean-up and housekeeping ...
			l_system.close_all
			remove_data
		end

end


