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
		note
			testing: "execution/isolated", "execution/serial"
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

	grapheme_conversion_tests
			-- `grapheme_conversion_tests' determines if grapheme-based hashing works as-billed!
		note
			testing: "execution/isolated", "execution/serial"
		local
			l_graph: EAV_GRAPHEME
			l_result: ARRAYED_LIST [INTEGER_32]
		do
			create l_graph

			l_result := l_graph.convert_to_hash ("caughaoiairt")
			assert_integers_equal ("aughoiair_count", 6, l_result.count)
			assert_integers_equal ("caughaoiairt_99", 99, l_result [1])					-- c
			assert_integers_equal ("caughaoiairt_1635084136", 1635084136, l_result [2])	-- augh
			assert_integers_equal ("caughaoiairt_97", 97, l_result [3])					-- a
			assert_integers_equal ("caughaoiairt_28521", 28521, l_result [4])			-- oi
			assert_integers_equal ("caughaoiairt_6383986", 6383986, l_result [5])		-- air
			assert_integers_equal ("caughaoiairt_116", 116, l_result [6])				-- t

			l_result := l_graph.convert_to_hash ("aughoiair")
			assert_integers_equal ("aughoiair_count", 3, l_result.count)
			assert_integers_equal ("aughoiair_1635084136", 1635084136, l_result [1])
			assert_integers_equal ("aughoiair_28521", 28521, l_result [2])
			assert_integers_equal ("aughoiair_6383986", 6383986, l_result [3])

			l_result := l_graph.convert_to_hash ("augh")
			assert_integers_equal ("augh_count", 1, l_result.count)
			assert_integers_equal ("augh_1635084136", 1635084136, l_result [1])

			l_result := l_graph.convert_to_hash ("eigh")
			assert_integers_equal ("eigh_count", 1, l_result.count)
			assert_integers_equal ("eigh_1701406568", 1701406568, l_result [1])

			l_result := l_graph.convert_to_hash ("eighaugh")
			assert_integers_equal ("eighaugh_count", 2, l_result.count)
			assert_integers_equal ("eighaugh_1701406568", 1701406568, l_result [1])
			assert_integers_equal ("eighaugh_1635084136", 1635084136, l_result [2])

			l_result := l_graph.convert_to_hash ("air")
			assert_integers_equal ("air_count", 1, l_result.count)
			assert_integers_equal ("air_6383986", 6383986, l_result [1])

			l_result := l_graph.convert_to_hash ("airear")
			assert_integers_equal ("airear_count", 2, l_result.count)
			assert_integers_equal ("airear_6383986", 6383986, l_result [1])
			assert_integers_equal ("airear_6644082", 6644082, l_result [2])

			l_result := l_graph.convert_to_hash ("oi")
			assert_integers_equal ("oi_count", 1, l_result.count)
			assert_integers_equal ("oi_28521", 28521, l_result [1])

			l_result := l_graph.convert_to_hash ("rh")
			assert_integers_equal ("rh_count", 1, l_result.count)
			assert_integers_equal ("rh_29288", 29288, l_result [1])

			l_result := l_graph.convert_to_hash ("rhoi")
			assert_integers_equal ("rhoi_count", 2, l_result.count)
			assert_integers_equal ("rhoi_29288", 29288, l_result [1])
			assert_integers_equal ("rhoi_28521", 28521, l_result [2])

			l_result := l_graph.convert_to_hash ("cat")
			assert_integers_equal ("cat_count", 3, l_result.count)
			assert_integers_equal ("c_99", 99, l_result [1])
			assert_integers_equal ("a_97", 97, l_result [2])
			assert_integers_equal ("t_116", 116, l_result [3])

			l_result := l_graph.convert_to_hash ("Pneumonoultramicroscopicsilicovolcanoconiosis")
			assert_integers_equal ("longest_word_count", 39, l_result.count)
			assert_integers_equal ("string_hash", 1320010867, ("Pneumonoultramicroscopicsilicovolcanoconiosis").hash_code)
		end

	grapheme_uniqueness_test
			-- `grapheme_uniqueness_test' testing uniqueness of twos, threes, and fours.
		note
			testing: "execution/isolated", "execution/serial"
		local
			l_graph: EAV_GRAPHEME
			l_grapheme_1,
			l_grapheme_2: STRING
		do
			create l_graph

			l_graph.grapheme_twos.do_nothing
			assert_integers_equal ("twos_count", 80, l_graph.grapheme_twos.count)
			l_graph.grapheme_twos_hash_codes.do_nothing
			assert_integers_equal ("twos_hash_count", 80, l_graph.grapheme_twos_hash_codes.count)
				-- Ensure that the lists match precisely!
			across
				l_graph.grapheme_twos as ic
			loop
				assert_32 ("twos_grapheme", l_graph.grapheme_twos_hash_codes.has_key (ic.item))
				l_grapheme_1 := ic.item
				check attached l_graph.grapheme_twos.at (l_graph.grapheme_twos_hash_codes.at (l_grapheme_1)) as al_grapheme_2 then
					assert_strings_equal ("same_graphemes", l_grapheme_1, al_grapheme_2)
				end
			end

			l_graph.grapheme_threes.do_nothing
			assert_integers_equal ("threes_count", 26, l_graph.grapheme_threes.count)
			l_graph.grapheme_threes_hash_codes.do_nothing
			assert_integers_equal ("threes_hash_count", 26, l_graph.grapheme_threes_hash_codes.count)
				-- Ensure that the lists match precisely!
			across
				l_graph.grapheme_threes as ic
			loop
				assert_32 ("threes_grapheme", l_graph.grapheme_threes_hash_codes.has_key (ic.item))
				l_grapheme_1 := ic.item
				check attached l_graph.grapheme_threes.at (l_graph.grapheme_threes_hash_codes.at (l_grapheme_1)) as al_grapheme_2 then
					assert_strings_equal ("same_graphemes", l_grapheme_1, al_grapheme_2)
				end
			end

			l_graph.grapheme_fours.do_nothing
			assert_integers_equal ("fours_count", 5, l_graph.grapheme_fours.count)
			l_graph.grapheme_fours_hash_codes.do_nothing
			assert_integers_equal ("fours_hash_count", 5, l_graph.grapheme_fours_hash_codes.count)
				-- Ensure that the lists match precisely!
			across
				l_graph.grapheme_fours as ic
			loop
				assert_32 ("threes_grapheme", l_graph.grapheme_fours_hash_codes.has_key (ic.item))
				l_grapheme_1 := ic.item
				check attached l_graph.grapheme_fours.at (l_graph.grapheme_fours_hash_codes.at (l_grapheme_1)) as al_grapheme_2 then
					assert_strings_equal ("same_graphemes", l_grapheme_1, al_grapheme_2)
				end
			end
		end

	primes_testing
			-- `general_testing' proving that we have Prime numbers.
		note
			testing: "execution/isolated", "execution/serial"
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
