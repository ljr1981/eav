note
	description: "Tests of {EAV}."
	testing: "type/manual"

class
	EAV_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

feature -- Test routines

	EAV_tests
			-- `EAV_tests'
		local
			l_system: EAV_SYSTEM
			l_entity: EAV_ENTITY
			l_attribute: EAV_ATTRIBUTE
		do
			create l_system
			l_system.set_name ("system")

			create l_entity
			l_entity.set_name ("entity")

			create l_attribute
			l_attribute.set_name ("attribute")
		end

end
