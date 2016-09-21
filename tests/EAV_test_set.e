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

	EAV_FUNCTIONS
		undefine
			default_create
		end

feature -- Creation Tests

	eav_system_tests
			-- `eav_system_tests'
		note
			testing:
				"execution/isolated",
				"execution/serial/group_1"
		local
			l_system: EAV_SYSTEM
		do
			create l_system.make ("system", test_data_path)
			l_system.close_all
			remove_data

			create l_system.make_with_list ("system", test_data_path, <<"eeny", "meeny", "miny", "mo">>)
			l_system.close_all
			remove_data

			create l_system.make_empty
			l_system.close_all
			remove_data

--			create l_system.make_empty_with_system_database
--			l_system.close_all
		end

	functions_alltrim_test
			-- `functions_alltrim_test'
		note
			testing:
				"execution/isolated",
				"execution/serial/group_1"
		do
			assert_strings_equal ("alltrim_inner_spaces_only", "a b c", alltrim(["3323xa b cx2233", "3x2"]))
			assert_strings_equal ("alltrim_no_spaces_only", "abc", alltrim(["3323xabcx2233", "3x2"]))
			assert_strings_equal ("alltrim_spaces_mixed_chars", "abc", alltrim(["332  3xabcx2   233", "3x2"]))
			assert_strings_equal ("alltrim_spaces_chars", "abc", alltrim(["  3xabcx2   ", "3x2"]))
			assert_strings_equal ("alltrim_spaces_one_char", "abc", alltrim(["  xabcx   ", "x"]))
			assert_strings_equal ("alltrim_spaces_only", "abc", alltrim(["  abc   ", ""]))
		end

	functions_at_test
		note
			testing:
				"execution/isolated",
				"execution/serial/group_1"
		do
			assert_integers_equal ("at_a_1", 1, at ("a", "abc", 0))
			assert_integers_equal ("at_b_2", 2, at ("b", "abc", 0))
			assert_integers_equal ("at_c_3", 3, at ("c", "abc", 0))

			assert_integers_equal ("at_a_4", 4, at ("a", "abca", 2))
			assert_integers_equal ("at_aa_4", 4, at ("aa", "aabaaca", 2))
			assert_integers_equal ("at_aa_4b", 4, at ("aa", "aabaacaa", 2))
		end

end
