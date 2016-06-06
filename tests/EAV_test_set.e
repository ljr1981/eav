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
			l_system: MOCK_SYSTEM
			l_entity: MOCK_ENTITY
			l_entity_actual: EAV_ENTITY
			l_attribute: MOCK_ATTRIBUTE
			l_attribute_actual: EAV_ATTRIBUTE
		do
			create l_system.make_with_data (1, (create {RANDOMIZER}).uuid)
			create l_entity.make_with_data (l_system, 2, (create {RANDOMIZER}).uuid)

			create l_entity_actual.make_with_data (l_system, 2, (create {RANDOMIZER}).uuid)
			l_entity_actual.set_name ("entity")
			create l_entity_actual.make_with_name (l_system, 2, "entity", (create {RANDOMIZER}).uuid)


			create l_attribute.make_with_data (l_entity, 3, (create {RANDOMIZER}).uuid)
			create l_attribute_actual.make_with_data (l_entity, 4, (create {RANDOMIZER}).uuid)
			l_attribute_actual.set_name ("attribute")
			create l_attribute_actual.make_with_name (l_entity, 4, "attribute", (create {RANDOMIZER}).uuid)
		end

end
