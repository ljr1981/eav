note
	description: "Tests of {EAV}."
	testing: "type/manual",
				"execution/serial",
				"execution/isolated"

class
	EAV_TEST_SET

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

	creation_tests
			-- `creation_tests'.
		local
			l_entity: EAV_ENTITY
			l_attribute: EAV_ATTRIBUTE
		do
			create l_entity
			l_entity.set_name ("entity")
			remove_data

			create l_attribute
			l_attribute.set_name ("attribute")
			remove_data
		end

	eav_system_tests
			-- `eav_system_tests'
		local
			l_system: EAV_SYSTEM
		do
			create l_system.make ("system", test_data_path)
			l_system.close_all
			remove_data
			create l_system.make_with_list ("system", test_data_path, <<"eeny", "meeny", "miny", "mo">>)
			l_system.close_all
			remove_data
		end

end
