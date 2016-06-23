note
	description: "Tests of {EAV_GRAPHEME_TESTS}."
	testing: "type/manual"

class
	EAV_GRAPHEME_TESTS

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

	RANDOMIZER
		undefine
			default_create
		end

feature -- Generic Testing

	creation_test
		local
			l_data_manager: EAV_DATA_MANAGER
		do
			create l_data_manager
		end

	hash_test
		local
			l_list: HASH_TABLE [STRING, INTEGER]
			l_name: STRING
			l_count: INTEGER
		do
			l_count := 100
			create l_list.make (l_count)
			across
				1 |..| l_count as ic
			loop
				l_name := random_city_name
				l_list.force (l_name, l_name.hash_code)
			end
			assert_integers_equal ("x_count", l_count, l_list.count)
		end

	general_testing
			-- `general_testing' proving that we have Prime numbers.
		local
			l_graph: EAV_GRAPHEME
		do
			create l_graph
			assert_integers_equal ("prime_1", 2, l_graph.primes_generator.i_th (1))
			assert_integers_equal ("prime_2", 3, l_graph.primes_generator.i_th (2))
			assert_integers_equal ("prime_3", 5, l_graph.primes_generator.i_th (3))
			assert_integers_equal ("prime_4", 7, l_graph.primes_generator.i_th (4))
			assert_integers_equal ("prime_5", 11, l_graph.primes_generator.i_th (5))
			assert_integers_equal ("prime_6", 13, l_graph.primes_generator.i_th (6))
			assert_integers_equal ("prime_7", 17, l_graph.primes_generator.i_th (7))
			assert_integers_equal ("prime_8", 19, l_graph.primes_generator.i_th (8))
			assert_integers_equal ("prime_9", 23, l_graph.primes_generator.i_th (9))
			assert_integers_equal ("prime_10", 29, l_graph.primes_generator.i_th (10))
			assert_integers_equal ("prime_11", 31, l_graph.primes_generator.i_th (11))
			assert_integers_equal ("prime_12", 37, l_graph.primes_generator.i_th (12))
			assert_integers_equal ("prime_13", 41, l_graph.primes_generator.i_th (13))
			assert_integers_equal ("prime_14", 43, l_graph.primes_generator.i_th (14))
			assert_integers_equal ("prime_15", 47, l_graph.primes_generator.i_th (15))
			assert_integers_equal ("prime_16", 53, l_graph.primes_generator.i_th (16))
			assert_integers_equal ("prime_17", 59, l_graph.primes_generator.i_th (17))
			assert_integers_equal ("prime_18", 61, l_graph.primes_generator.i_th (18))
			assert_integers_equal ("prime_19", 67, l_graph.primes_generator.i_th (19))
			assert_integers_equal ("prime_2", 71, l_graph.primes_generator.i_th (20))
		end

end
