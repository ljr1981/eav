﻿note
	description: "[
		Representation of an effected {EAV_DATABASE}.
		]"
	design: "See notes clause at the end of this class."

class
	EAV_DATABASE

inherit
	RANDOMIZER

	EAV_CONSTANTS

create
	make_empty,
	make

feature {NONE} -- Initialization

	make_empty
			-- `make_empty' in reasonable default state.
		do
			create database.make_open_read_write ("system")
			set_pragma_status_off
			set_pragma_journal_mode_memory
		end

	make (a_location, a_file_name: READABLE_STRING_GENERAL)
			-- `make' at `a_location' (uri, file-spec, etc) using `a_file_name'.
			-- For now: This feature presumes a file-based database system.
		require
			not_empty: not a_location.is_empty
			real_location: (create {DIRECTORY}.make_open_read ((create {EXECUTION_ENVIRONMENT}).current_working_path.name.out + a_location)).exists
		local
			l_full_path: STRING
			l_oe: OPERATING_ENVIRONMENT
		do
			create l_oe
			l_full_path := (create {EXECUTION_ENVIRONMENT}).current_working_path.name.out
			if a_location.item (1) /= l_oe.directory_separator then
				l_full_path.append_character (l_oe.directory_separator)
			end
			l_full_path.append (a_location.out)
			if a_location.item (a_location.count) /= l_oe.directory_separator then
				l_full_path.append_character (l_oe.directory_separator)
			end
			l_full_path.append (a_file_name.out)
			l_full_path.append_character ('.')
			l_full_path.append (extension)
			create last_database_path.make_from_string (l_full_path)
			create database.make_create_read_write (last_database_path.name)
			set_pragma_status_off
			set_pragma_journal_mode_memory
		end

	last_database_path: PATH
			-- `last_database_path' used.
		attribute
			create Result.make_current
		end

feature {EAV_DATA_MANAGER} -- Access: Database Info

	entities: HASH_TABLE [TUPLE [ent_id: INTEGER_64], STRING]
			-- `entities' in memory; sync'd with DB.
		attribute
			create Result.make (100)
		end

	attributes: HASH_TABLE [TUPLE [atr_id: INTEGER_64; name, value_table_name: STRING], INTEGER_32]
			-- `attributes' in memory; sync'd with DB.
		attribute
			create Result.make (1_000)
		end

feature {EAV_SYSTEM} -- Implementation: EAV Build Operations

	build_eav_structure
			-- `build_eav_structure'.
			-- Note these tables are constructed if they do not
			-- yet exist. If they do exist, they are left as-is.
			-- See {EAV_DOCS} for more information.
		do
				-- Build Metadata tables ...
			build_object
			build_entity
			build_attribute

				-- Build Value tables ...
			--build_date_value
			build_text_value
			build_boolean_value
			build_integer_value
			build_real_value
			build_blob_value
		end

feature {NONE} -- Implementation: EAV Build Operations

	set_pragma_status_off
		local
			l_modify: SQLITE_MODIFY_STATEMENT
		do
			create l_modify.make ("PRAGMA synchronous = OFF;", database)
			l_modify.execute
		end

	set_pragma_journal_mode_memory
		local
			l_modify: SQLITE_MODIFY_STATEMENT
		do
			create l_modify.make ("PRAGMA journal_mode = MEMORY;", database)
			l_modify.execute
		end

	build_object
			-- `build_object' table (if needed).
			-- See {EAV_DOCS} for more information.
		require
			not_built_yet: not is_built_once
		local
			l_modify: SQLITE_MODIFY_STATEMENT
		do
			create l_modify.make (modify_statement ("Object", <<create_table_kw, IF_NOT_EXISTS_kw_phrase>>,
													<<
													integer_field ("obj_id") + primary_key_kw + ASC_kw + autoincrement_kw,
													integer_field ("obj_count"),
													boolean_field ("is_deleted"),
													date_field ("modified_date"),
													integer_field ("modifier_id")
													>>), database)
			l_modify.execute
			create l_modify.make ("INSERT INTO Object (obj_count) VALUES (0);", database)
			l_modify.execute
			is_built_once := True
		end

	is_built_once: BOOLEAN

	build_entity
			-- `build_entity' table (if needed).
			-- See {EAV_DOCS} for more information.
		local
			l_modify: SQLITE_MODIFY_STATEMENT
		do
			create l_modify.make (modify_statement ("Entity", <<create_table_kw, IF_NOT_EXISTS_kw_phrase>>,
													<<
													integer_field ("ent_id") + primary_key_kw + ASC_kw + autoincrement_kw,
													integer_field ("sys_id"),
													text_field ("ent_uuid"),
													text_field ("ent_name"),
													integer_field ("ent_count"),
													boolean_field ("is_deleted"),
													date_field ("modified_date"),
													integer_field ("modifier_id")
													>>), database)
			l_modify.execute
		end

	build_attribute
			-- `build_attribute' table (if needed).
			-- See {EAV_DOCS} for more information.
		local
			l_modify: SQLITE_MODIFY_STATEMENT
		do
			create l_modify.make (modify_statement ("Attribute", <<create_table_kw, IF_NOT_EXISTS_kw_phrase>>,
													<<
													integer_field ("atr_id") + primary_key_kw + ASC_kw + autoincrement_kw,
													text_field ("atr_uuid"),
													text_field ("atr_name"),
													text_field ("atr_value_table"),
													boolean_field ("is_deleted"),
													date_field ("modified_date"),
													integer_field ("modifier_id")
													>>), database)
			l_modify.execute
		end

	build_text_value
			-- `build_text_value'
		do build_value (text_value_table_name.twin, agent text_field) end

	build_boolean_value
			-- `build_boolean_value'.
		do build_value (boolean_value_table_name.twin, agent boolean_field) end

	build_integer_value
			-- `build_integer_value'.
		do build_value (integer_value_table_name.twin, agent integer_field) end

	build_real_value
			-- `build_real_value'.
		do build_value (real_value_table_name.twin, agent real_field) end

	build_blob_value
			-- `build_blob_value'.
		do build_value (Blob_value_table_name.twin, agent blob_field) end

	build_value (a_table_name: STRING; a_item_field_agent: FUNCTION [TUPLE [STRING], STRING])
			-- `build_varchar_value' table (if needed).
			-- Services all higher `build_*' features (above).
		local
			l_modify: SQLITE_MODIFY_STATEMENT
			l_last_result: STRING
			l_sql: STRING
		do
			a_item_field_agent.call ("val_item")
			check has_result: attached {STRING} a_item_field_agent.last_result as al_result then l_last_result := al_result end
			create l_modify.make (modify_statement (a_table_name, <<create_table_kw, IF_NOT_EXISTS_kw_phrase>>,
													<<
													integer_field ("val_id") + primary_key_kw + ASC_kw + autoincrement_kw,
													integer_field ("atr_id"),
													integer_field ("object_id"),
													l_last_result.twin,
													boolean_field ("is_deleted"),
													date_field ("modified_date"),
													integer_field ("modifier_id")
													>>), database)
			l_modify.execute

			l_sql := create_index_sql.twin
			l_sql.replace_substring_all ("<<TABLE_NAME>>", a_table_name)
			create l_modify.make (l_sql, database)
			l_modify.execute
		end

	create_index_sql: STRING = "CREATE UNIQUE INDEX <<TABLE_NAME>>_atr_instance ON <<TABLE_NAME>> (atr_id, object_id);"

feature -- Store Operations

	store_objects (a_objects: ITERABLE [EAV_DB_ENABLED])
			-- `store_objects' in `a_objects' with `store_object'.
		do
			begin_transaction
			across
				a_objects as ic
			loop
				store_object (ic.item)
			end
			end_transaction
		end

	store_object (a_object: EAV_DB_ENABLED)
			-- `store_object' `a_object' into `database'.
		local
			l_is_new: BOOLEAN
		do
			-- entity_name, feature_data (a_object).to_array
				-- Handle Entity first ...
			store_entity (a_object)

				-- New instance or existing?
			l_is_new := a_object.object_id = new_object_id_constant
			if l_is_new then
					-- Entity-instance count
				update_entity_instance_count (a_object.entity_name, next_entity_id (a_object.entity_name))
					-- Object count
				a_object.set_object_id (next_object_id)
				update_object_count (a_object.object_id)
			end
			check not_new_instance: not a_object.is_new end

				-- Then handle Attributes ...
			across
				a_object.feature_data (a_object) as ic_values
			loop
				store_attribute (ic_values.item.attr_name, ic_values.item.attr_value, a_object, l_is_new)
			end
		ensure
			stored_entity: not a_object.entity_name.is_empty and then a_object.entity_id > 0
		end

	begin_transaction
			-- `begin_transaction' on `database'.
		do
			database.begin_transaction (as_exclusive_transaction)
		end

	as_exclusive_transaction: BOOLEAN = False
	as_deferred_transaction: BOOLEAN = True

	end_transaction
			-- `end_transaction' with `commit' on `database'.
		do
			database.commit
		end

feature {NONE} -- Implementation: Store Operations

	next_object_id: INTEGER_64
			-- `next_object_id' for `a_entity_name'?
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_result: SQLITE_STATEMENT_ITERATION_CURSOR
			l_sql: STRING
		do
			l_sql := "SELECT obj_count FROM Object;"
			create l_query.make (l_sql, database)
			l_result := l_query.execute_new
			l_result.start
			check has_result: not l_result.after then
				Result := l_result.item.integer_64_value (1) + 1
			end
		ensure
			positive_result: Result > 0
		end

	next_entity_id (a_entity_name: STRING): INTEGER_64
			-- `next_entity_id' for `a_entity_name'?
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_result: SQLITE_STATEMENT_ITERATION_CURSOR
			l_sql: STRING
		do
			l_sql := SELECT_kw.twin
			l_sql.append_string_general (entity_ent_count_field_name)
			l_sql.append_string_general (FROM_kw)
			l_sql.append_string_general (entity_table_name)
			l_sql.append_string_general (WHERE_kw)
			l_sql.append_string_general (entity_ent_name_field_name)
			l_sql.append_string_general (" = '")
			l_sql.append_string_general (a_entity_name)
			l_sql.append_string_general ("';")
			create l_query.make (l_sql, database)
			l_result := l_query.execute_new
			l_result.start
			if not l_result.after then
				Result := l_result.item.integer_64_value (1) + 1
			end
		ensure
			positive_result: Result > 0
		end

	last_object_count: INTEGER_64
			-- `last_object_count' of all objects.

	last_instance_count: INTEGER_64
			-- `last_instance_count' of entity instance id's.

	update_entity_instance_count (a_entity_name: STRING; a_new_count: INTEGER_64)
			-- `update_entity_instance_count' for `a_entity_name' to `a_new_count'.
		local
			l_modify: SQLITE_MODIFY_STATEMENT
			l_sql: STRING
		do
			l_sql := UPDATE_kw.twin
			l_sql.append_string_general (entity_table_name)
			l_sql.append_string_general (SET_kw)
			l_sql.append_string_general (entity_ent_count_field_name)
			l_sql.append_string_general (equals)
			l_sql.append_string_general (a_new_count.out)
			l_sql.append_string_general (WHERE_kw)
			l_sql.append_string_general (entity_ent_name_field_name)
			l_sql.append_string_general (equals)
			l_sql.append_character (open_single_quote)
			l_sql.append_string_general (a_entity_name)
			l_sql.append_character (close_single_quote)
			l_sql.append_character (semi_colon)
			create l_modify.make (l_sql, database)
			l_modify.execute
		end

	update_object_count (a_new_count: INTEGER_64)
			-- `update_object_count' with `a_new_count'.
		local
			l_modify: SQLITE_MODIFY_STATEMENT
		do
			create l_modify.make ("UPDATE Object SET obj_count = " + a_new_count.out + " WHERE obj_id = 1;", database)
			l_modify.execute
		end

feature -- Retrieve (fetch by ...) Operations

	fetch_with_object_id (a_object_id: INTEGER_64): detachable EAV_DB_ENABLED
		do
			check fetch_object_id: False end
		end

	fetch_by_object_id (a_entity_id: INTEGER_64; a_setter: TUPLE [setter_agent: PROCEDURE [detachable ANY]; attribute_name: STRING; setter_type_code: INTEGER]; a_object_id: INTEGER_64)
			-- fetch_by_object_id --> object
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_sql,
			l_value_table_name: STRING
			l_cursor: SQLITE_STATEMENT_ITERATION_CURSOR
			l_atr_name: STRING
		do
				-- Fetch the atr_value_table for entity_id and attribute name ...
			inspect
				a_setter.setter_type_code
			when BOOLEAN_value_type_code then
				l_value_table_name := "Value_boolean"
			when INTEGER_value_type_code then
				l_value_table_name := "Value_integer"
			when REAL_value_type_code then
				l_value_table_name := "Value_real"
			when TEXT_value_type_code then
				l_value_table_name := "Value_text"
			when BLOB_value_type_code then
				l_value_table_name := "Value_blob"
			when REFERENCE_value_type_code then
				l_value_table_name := "Value_integer"
			else
				l_value_table_name := "Value_text"
				check unknown_a_setter_dot_setter_type_code_in_EAV_DATABASE_fetch_by_object_id: False end
			end

					-- Now fetch the actual value ...
			l_atr_name := a_setter.attribute_name
			check has_atr_id: attached (l_atr_name + l_value_table_name).hash_code as al_key and then attached attributes.at (al_key) as al_attributes then
				l_sql := "SELECT val_item FROM " + l_value_table_name + " WHERE atr_id = " + al_attributes.atr_id.out + " and object_id = " + a_object_id.out + ";"
				create l_query.make (l_sql, database)
				l_cursor := l_query.execute_new
				l_cursor.start
				if not l_cursor.after then
					if
							attached {INTEGER_32} l_cursor.item.value (1) as al_integer and then
							a_setter.setter_type_code = INTEGER_value_type_code
						then
							a_setter.setter_agent.call ([al_integer])
					elseif
							attached {INTEGER_64} l_cursor.item.value (1) as al_integer_64 and then
							a_setter.setter_type_code = INTEGER_value_type_code
						then
							a_setter.setter_agent.call ([al_integer_64.as_integer_32])
					elseif
							attached {INTEGER_64} l_cursor.item.value (1) as al_ref_integer_64 and then
							a_setter.setter_type_code = REFERENCE_value_type_code
						then
							if al_ref_integer_64 = 0 then
								a_setter.setter_agent.call ([Void]) -- This is a Void or NULL reference object
							else
								-- Locate the object of the reference
								-- Load it
								-- Set it into the setter
								check do_we_really_need_to: False end
							end
					else
						a_setter.setter_agent.call ([l_cursor.item.value (1)])
					end
				end
			end
		end

	fetch_Object_list_by_SELECT (a_object: EAV_DB_ENABLED; a_query: TUPLE [text: STRING; feature_names: ARRAYED_LIST [STRING]]): ARRAYED_LIST [EAV_DB_ENABLED]
			-- `fetch_Object_list_by_SELECT' results in a list of objects like `a_object' for `a_query' with query `text' for `feature_names'
		local
			l_object: EAV_DB_ENABLED
			l_column: TUPLE
			l_TUPLEs_Result: ARRAYED_LIST [TUPLE]
		do
			l_TUPLEs_Result := fetch_TUPLEs_by_SELECT (a_object, a_query)
			create Result.make (l_TUPLEs_Result.count)
			across
				l_TUPLEs_Result as ic_tuple_rows
			loop
				l_object := a_object.twin
				check is_tuple: attached {TUPLE} ic_tuple_rows.item [1] as al_column then
					across
						al_column as ic_column
					loop
						if ic_column.cursor_index = 1  then
							check is_object_id: attached {INTEGER_64} ic_column.item as al_object_id then
								l_object.set_object_id (al_object_id)
							end
						else
							l_object.set_field (l_object, a_query.feature_names [ic_column.cursor_index - 1], ic_column.item)
						end
					end
				end
				Result.force (l_object)
			end
		end

	fetch_TUPLEs_by_SELECT (a_object: EAV_DB_ENABLED; a_query: TUPLE [text: STRING; feature_names: ARRAYED_LIST [STRING]]): ARRAYED_LIST [TUPLE]
			-- `fetch_TUPLEs_by_SELECT'.
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_sql,
			l_value_table_name: STRING
			l_row_cursor: SQLITE_STATEMENT_ITERATION_CURSOR
			l_row: SQLITE_RESULT_ROW
			l_index: INTEGER_32
			l_result: ARRAYED_LIST [detachable TUPLE]
			l_result_row: detachable TUPLE
		do
			create l_query.make (a_query.text, database)
			l_row_cursor := l_query.execute_new
			create Result.make (1_000)
			from
				l_row_cursor.start
			until
				l_row_cursor.after
			loop
				l_row := l_row_cursor.item
				create l_result_row
				if attached {INTEGER_64} l_row.value ((1).as_natural_32) as al_object_id then
					check has_result_row: attached {TUPLE} l_result_row as al_result_row then
						l_result_row := al_result_row.plus ([al_object_id])
					end
				end
				across
					2 |..| l_row.count.as_integer_32 as ic
				loop
					l_index := ic.item
					check has_result_row: attached {TUPLE} l_result_row as al_result_row then
						l_result_row := al_result_row.plus ([l_row.value (l_index.as_natural_32)])
					end
				end
				Result.force (l_result_row)
				l_row_cursor.forth
			end
		end

	-- fetch_by_primary_key		--> Single "thing"
	-- fetch_by_candidate_key	--> Single "thing"
	-- fetch_by_filtered_key	--> Collection of "things"
	-- fetch_by_adhoc_query		--> Collection of "things"
		-- f(n) =|/=|<|>|=<|>=|etc.

	-- QUESTION: Fetch what "thing"? What is returned?
		-- fetch ID or ID-list
		-- fetch Field or Field-list (a single field per object for 0:1:M objects)
		-- fetch Fields or Fields-list (a list of fields per object for 0:1:M objects) (some or all fields)
		-- fetch Computed Field/Fields as a list of agents applied to ...

feature {TEST_SET_BRIDGE} -- Implementation: Entity

	store_entity (a_object: EAV_DB_ENABLED)
			-- `store_entity' `a_entity_name'.
		do
			if has_entity (a_object.entity_name) then
				do_nothing -- soon: just get the ent_id
			else
				store_new_entity (a_object.entity_name)
				recently_found_entities.force (a_object.entity_name, a_object.entity_name.case_insensitive_hash_code)
			end
			a_object.set_entity_id (entity_id (a_object.entity_name))
		ensure
			has_entity: has_entity (a_object.entity_name) implies a_object.entity_id > 0
		end

	store_new_entity (a_entity_name: STRING)
			-- `store_new_entity' as `a_entity_name'.
		require
			not_has: not has_entity (a_entity_name)
		local
			l_insert: SQLITE_INSERT_STATEMENT
		do
			create l_insert.make ("INSERT INTO Entity (ent_uuid, ent_name, ent_count, is_deleted, modified_date) VALUES (:ENT_UUID, :ENT_NAME, :ENT_CNT, :IS_DEL, :MOD_DATE);", database)
			check l_insert_is_compiled: l_insert.is_compiled end
			l_insert.execute_with_arguments ([
				create {SQLITE_STRING_ARG}.make (":ENT_UUID", uuid.out),
				create {SQLITE_STRING_ARG}.make (":ENT_NAME", a_entity_name),
				create {SQLITE_INTEGER_ARG}.make (":ENT_CNT", 0),
				create {SQLITE_INTEGER_ARG}.make (":IS_DEL", 0),
				create {SQLITE_STRING_ARG}.make (":MOD_DATE", (create {DATE_TIME}.make_now).out)
				])
			entities.force (entity_id (a_entity_name), a_entity_name)
		end

	has_entity (a_entity_name: STRING): BOOLEAN
			-- `has_entity' `a_entity_name'?
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_result: SQLITE_STATEMENT_ITERATION_CURSOR
			l_sql: STRING
		do
			Result := recently_found_entities.has (a_entity_name.case_insensitive_hash_code)
			if not Result then
				-- SELECT entity_name FROM entity WHERE entity_name = '<<a_entity_name>>';
				l_sql := SELECT_kw.twin
				l_sql.append_string_general (entity_ent_name_field_name.twin)
				l_sql.append_string_general (FROM_kw.twin)
				l_sql.append_string_general (entity_table_name.twin)
				l_sql.append_string_general (WHERE_kw.twin)
				l_sql.append_string_general (entity_ent_name_field_name.twin)
				l_sql.append_string_general (equals)
				l_sql.append_character (open_single_quote)
				l_sql.append_string_general (a_entity_name.twin)
				l_sql.append_character (close_single_quote)
				l_sql.append_character (semi_colon)
				create l_query.make (l_sql, database)
				l_result := l_query.execute_new
				l_result.start
				Result := not l_result.after and then
							l_result.item.string_value (1).same_string (a_entity_name)
			end
		end

	entity_id (a_entity_name: STRING): INTEGER_64
			-- `entity_id' of `a_entity_name'.
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_result: SQLITE_STATEMENT_ITERATION_CURSOR
			l_sql: STRING
		do
			l_sql := SELECT_kw.twin
			l_sql.append_string_general (entity_ent_id_field_name.twin)
			l_sql.append_string_general (FROM_kw.twin)
			l_sql.append_string_general (entity_table_name.twin)
			l_sql.append_string_general (WHERE_kw.twin)
			l_sql.append_string_general (entity_ent_name_field_name.twin)
			l_sql.append_string_general (equals)
			l_sql.append_character (open_single_quote)
			l_sql.append_string_general (a_entity_name.twin)
			l_sql.append_character (close_single_quote)
			l_sql.append_character (semi_colon)
			create l_query.make (l_sql, database)
			l_result := l_query.execute_new
			l_result.start
			Result := l_result.item.integer_64_value (1)
		end

	last_entity_id: INTEGER_64
			-- `last_entity_id' of last accessed `entity_id'.

	recently_found_entities: HASH_TABLE [STRING, INTEGER]
			-- `recently_found_entities'.
		attribute
			create Result.make (50)
		end


feature {TEST_SET_BRIDGE} -- Implementation: Attribute

	store_attribute (a_attribute_name: STRING; a_value: detachable ANY; a_object: EAV_DB_ENABLED; a_is_new: BOOLEAN)
			-- `store_attribute' named `a_attribute_name' and having (optional) `a_value'.
		do
				-- Compute attribute data type
			if attached {ABSOLUTE} a_value as al_value then
				value_table := text_value_table_name; value := al_value.out --date_value_table_name
			elseif attached {STRING} a_value as al_value then
				value_table := text_value_table_name; value := al_value.out
			elseif attached {INTEGER} a_value as al_value then
				value_table := integer_value_table_name; value := al_value.out
			elseif attached {NUMERIC} a_value as al_value then -- Forms of {REAL} and {DECIMAL}
				value_table := real_value_table_name; value := al_value.out
			elseif attached {BOOLEAN} a_value as al_value then
				value_table := integer_value_table_name; value := al_value.to_integer.out
			elseif attached {CHARACTER} a_value as al_value then
				value_table := text_value_table_name; value := al_value.out
			elseif attached {EAV_DB_ENABLED} a_value as al_value then
				value_table := integer_value_table_name; value := al_value.object_id.out
			elseif not attached {ANY} a_value then
				value_table := integer_value_table_name; value := (0).out
			else
				check unknown_data_type: False end
			end

				-- Handle storage of attribute meta data
			store_attribute_name (a_attribute_name, value_table)

				-- Store the actual attribute data
			store_with_modify_or_insert (value_table, value, last_attribute_id, a_object, a_is_new)
		end

	value: STRING attribute create Result.make_empty end
	value_table: STRING attribute create Result.make_empty end

	store_with_modify_or_insert (a_table, a_value: STRING; a_attribute_id: INTEGER_64; a_object: EAV_DB_ENABLED; a_is_new: BOOLEAN)
			-- `store_with_modify_or_insert' of `a_value' for `a_attribute_id' and `a_entity_id'.
		local
			l_insert: SQLITE_INSERT_STATEMENT
			l_modify: SQLITE_MODIFY_STATEMENT
			l_sql: STRING
		do
			if a_is_new then
				l_sql := store_with_insert_1.twin
				l_sql.append_string_general (a_table)
				l_sql.append_string_general (store_with_insert_2)
				l_sql.append_string_general (a_attribute_id.out)
				l_sql.append_character (comma)
				l_sql.append_string_general (a_object.object_id.out)
				l_sql.append_string_general (store_with_insert_3)
				l_sql.append_string_general (a_value)
				l_sql.append_string_general (store_with_insert_4)
				create l_insert.make (l_sql, database)
				l_insert.execute
			else
				l_sql := UPDATE_kw.twin
				l_sql.append_string_general (a_table)
				l_sql.append_string_general (store_with_modify_1)
				l_sql.append_string_general (a_value)
				l_sql.append_string_general (store_with_modify_2)
				l_sql.append_string_general (a_attribute_id.out)
				l_sql.append_string_general (store_with_modify_3)
				l_sql.append_string_general (a_object.object_id.out)
				l_sql.append_character (semi_colon)

				create l_modify.make (l_sql, database)
				l_modify.execute
			end
		end

	store_with_insert_1: STRING
		once
			Result := INSERT_kw.twin
			Result.append_string_general (OR_kw)
			Result.append_string_general (REPLACE_kw)
			Result.append_string_general (INTO_kw)
		end

	store_with_insert_2: STRING
		once
			Result := space.out.twin
			Result.append_character (open_parenthesis)
			Result.append_string_general (attribute_atr_id_field_name.twin)
			Result.append_character (comma)
			Result.append_string_general (object_id_field_name)
			Result.append_character (comma)
			Result.append_string_general (value_val_item_field_name)
			Result.append_character (close_parenthesis)
			Result.append_character (space)
			Result.append_string_general (VALUES_kw)
			Result.append_character (space)
			Result.append_character (open_parenthesis)
		end

	store_with_insert_3: STRING
		once
			Result := comma.out.twin
			Result.append_character (open_single_quote)
		end

	store_with_insert_4: STRING
		once
			Result := close_single_quote.out.twin
			Result.append_character (close_parenthesis)
			Result.append_character (semi_colon)
		end

	store_with_modify_1: STRING
		once
			Result := SET_kw.twin
			Result.append_string_general (value_val_item_field_name)
			Result.append_string_general (equals)
			Result.append_character (open_single_quote)
		end

	store_with_modify_2: STRING
		once
			Result := close_single_quote.out.twin
			Result.append_string_general (WHERE_kw)
			Result.append_string_general (attribute_atr_id_field_name)
			Result.append_string_general (equals)
		end

	store_with_modify_3: STRING
		once
			Result := AND_kw.twin
			Result.append_string_general (object_id_field_name)
			Result.append_string_general (equals)
		end

	store_attribute_name (a_name: STRING; a_value_table: STRING)
			-- `store_entity' `a_name'.
		do
			if not has_attribute (a_name, a_value_table) then
				create_new_entity_attribute (a_name, a_value_table)
			end
			check has_attribute: has_attribute (a_name, a_value_table) end
			last_attribute_id := attribute_id (a_name, a_value_table)
		ensure
			has_last: last_attribute_id > 0
		end

	create_new_entity_attribute (a_name: STRING; a_value_table: STRING)
			-- `create_new_entity_attribute' as `a_name'.
		require
			--not_has: not has_attribute_name_for_entity (a_name, a_value_table)
		local
			l_insert: SQLITE_INSERT_STATEMENT
		do
			create l_insert.make ("INSERT INTO Attribute (atr_uuid, atr_name, atr_value_table, is_deleted, modified_date, modifier_id) VALUES (:ATR_UUID, :ATR_NAME, :ATR_VAL_TAB, :IS_DEL, :MOD_DATE, :MOD_ID);", database)
			check l_insert_is_compiled: l_insert.is_compiled end
			l_insert.execute_with_arguments ([
				create {SQLITE_STRING_ARG}.make (":ATR_UUID", uuid.out),
				create {SQLITE_STRING_ARG}.make (":ATR_NAME", a_name),
				create {SQLITE_STRING_ARG}.make (":ATR_VAL_TAB", a_value_table),
				create {SQLITE_INTEGER_ARG}.make (":IS_DEL", 0),
				create {SQLITE_STRING_ARG}.make (":MOD_DATE", (create {DATE_TIME}.make_now).out),
				create {SQLITE_INTEGER_ARG}.make (":MOD_BY", 1)
				])
			attributes.force ([attribute_id (a_name, a_value_table), a_name, a_value_table], (a_name + a_value_table).hash_code)
		ensure
			has_attribute (a_name, a_value_table)
		end

	has_attribute (a_name, a_value_table: STRING): BOOLEAN
		local
			l_result: SQLITE_STATEMENT_ITERATION_CURSOR
			l_select: SQLITE_QUERY_STATEMENT
			l_sql: STRING
		do
			Result := attributes.has ( (a_name + a_value_table).hash_code)
			if not Result then
				l_sql := "SELECT count(*) FROM Attribute WHERE atr_name = '" + a_name + "' and atr_value_table = '" + a_value_table + "';"
				create l_select.make (l_sql, database)
				l_result := l_select.execute_new
				l_result.start
				Result := (not l_result.after) and (l_result.item.integer_value (1) = 1)
			end
		end

	attribute_id (a_name, a_value_table: STRING): INTEGER_64
			-- `attribute_id' for `a_name' and `a_value_table'.
		local
			l_result: SQLITE_STATEMENT_ITERATION_CURSOR
			l_select: SQLITE_QUERY_STATEMENT
			l_sql: STRING
		do
			l_sql := "SELECT atr_id FROM Attribute WHERE atr_name = '" + a_name + "' and atr_value_table = '" + a_value_table + "';"
			create l_select.make (l_sql, database)
			l_result := l_select.execute_new
			l_result.start
			Result := l_result.item.integer_64_value (1)
		end

	last_attribute_id: INTEGER_64
			-- `last_attribute_id' of last accessed `attribute_id'.

	recently_found_attributes: HASH_TABLE [STRING, INTEGER]
			-- `recently_found_attributes'.
		attribute
			create Result.make (50)
		end

feature {NONE} -- Implementation: Basic Operations

	modify_statement (a_table: STRING; a_parts: ARRAY [STRING]; a_fields: ARRAY [STRING]): STRING
			-- Build `modify_statement' for `a_table' with `a_parts' and `a_fields'.
		do
			create Result.make_empty
			across
				a_parts as ic_parts
			loop
				Result.append (ic_parts.item)
			end
			Result.append_character (' ')
			Result.append (a_table)
			Result.append_character (' ')
			Result.append_character ('(')
			across
				a_fields as ic_fields
			loop
				Result.append (ic_fields.item)
				Result.append_character (',')
			end
			if not a_fields.is_empty then
				Result.remove_tail (1)
			end
			Result.append_character (')')
			Result.append_character (';')
		ensure
			has_parts: across a_parts as ic all Result.has_substring (ic.item) end
			has_fields: across a_fields as ic all Result.has_substring (ic.item) end
			all_commas: across 1 |..| (a_fields.count - 1) as ic all Result.has_substring (a_fields [ic.item] + ",") end
			no_tail: not Result.has_substring (a_fields [a_fields.count] + ",")
			closing_semicolon: Result [Result.count] = ';'
		end

feature {EAV_DB_ENABLED} -- Implementation: Constants

	SELECT_atr_id_FROM_attribute_WHERE_atr_name_equals: STRING
			-- Front half of `select_atr_id_from_attribute_where_atr_name_equals'.
		once
			Result := SELECT_kw.twin
			Result.append_string_general (attribute_atr_id_field_name)
			Result.append_string_general (FROM_kw)
			Result.append_string_general (attribute_table_name)
			Result.append_string_general (WHERE_kw)
			Result.append_string_general (attribute_atr_name_field_name)
			Result.append_string_general (equals)
			Result.append_character (open_single_quote)
		end

	close_single_quote_semi_colon: STRING
			-- Back half of `close_single_quote_semi_colon'.
		once
			create Result.make_empty
			Result.append_character (close_single_quote)
			Result.append_character (semi_colon)
		end

feature {NONE} -- Implementation: Field constructs

	date_field,
	text_field (a_name: STRING): STRING
			-- Date, character, varchar, and text fields are all TEXT.
		do
			Result := a_name; Result.append (TEXT_kw)
		end

	boolean_field,
	integer_field (a_name: STRING): STRING
			-- Boolean and integer fields are both INTEGER.
		do
			Result := a_name; Result.append (INTEGER_kw)
		end

	real_field (a_name: STRING): STRING
			-- Floats and doubles are reals.
		do
			Result := a_name; Result.append (REAL_kw)
		end

	blob_field (a_name: STRING): STRING
			-- Blob fields of all sorts.
		do
			Result := a_name; Result.append (BLOB_kw)
		end

feature {EAV_SYSTEM, EAV_DATA_MANAGER} -- Implementation: Access

	database: SQLITE_DATABASE
			-- `database'

invariant
	mutexed: as_exclusive_transaction /= as_deferred_transaction implies not as_exclusive_transaction and as_deferred_transaction

;note
	design_intent: "[
		The intent of this class is representation of a generic or abstract database.
		The clients of this class ought to never know precisely what database they are
		connecting to and utilizing.
		
		NOTE: To start with, we will be using SQLite3 exclusively. However, that will
				soon change to where the DB can be switched underneath by way of a bridge
				pattern.
		]"

end
