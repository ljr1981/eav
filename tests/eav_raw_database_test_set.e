note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	EAV_RAW_DATABASE_TEST_SET

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

	RANDOMIZER
		undefine
			default_create
		end

feature -- Testing raw writing

	raw_write_test
			-- `raw_write_test'.
		note
			testing:
				"execution/isolated",
				"execution/serial"
		local
			l_database: detachable SQLITE_DATABASE
			l_sql: STRING
			l_modify: SQLITE_MODIFY_STATEMENT
			l_start,
			l_end: DATE_TIME
		do
				-- create the database
			create l_database.make_create_read_write ((create {EXECUTION_ENVIRONMENT}).current_working_path.name.out + test_data_path + "raw_write_test.sqlite3")
			check attached {SQLITE_DATABASE} l_database as al_database then

				-- Create the test table
				l_sql := "CREATE TABLE IF NOT EXISTS test_table (tsttab_number INTEGER);"
				create l_modify.make (l_sql, al_database)
				l_modify.execute

				l_sql := "INSERT OR ROLLBACK INTO test_table (tsttab_number) VALUES ("
				l_database.begin_transaction (False)
				create l_start.make_now
				across
					1 |..| 1_000 as ic
				loop
					create l_modify.make ("INSERT OR ROLLBACK INTO test_table (tsttab_number) VALUES (" + ic.item.out + ");", al_database)
					l_modify.execute
				end
				l_database.commit
				create l_end.make_now

				print (l_end.fine_second - l_start.fine_second)
--				al_database.close
--				check closed: al_database.is_closed end
			end
			l_database := Void

			--remove_data
		end

feature {NONE} -- Implementation

	remove_data
			-- `remove_data' from directory path.
		local
			l_path: PATH
			l_dir: DIRECTORY
		do
			create l_path.make_from_string ((create {EXECUTION_ENVIRONMENT}).current_working_path.name.out + test_data_path)
			create l_dir.make_with_path (l_path)
			l_dir.delete_content
		end

feature {EQA_TEST_SET} -- Implementation: Constants

	test_data_path: STRING = "\tests\data\"
			-- `test_data_path' location on file system.

end


