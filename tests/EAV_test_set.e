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
			l_table: EAV_COMMON
			l_meta: EAV_META_DATA
		do
			do_nothing
		end

end
