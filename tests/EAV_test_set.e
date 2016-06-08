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
			create l_system.make ("system", "tests\data")
			l_system.close_all
			remove_data
			create l_system.make_with_list ("system", "tests\data", <<"eeny", "meeny", "miny", "mo">>)
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
			l_dir.delete_content
		end

end
