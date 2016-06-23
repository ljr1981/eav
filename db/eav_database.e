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
		end

	make (a_location, a_file_name: READABLE_STRING_GENERAL)
			-- `make' at `a_location' (uri, file-spec, etc) using `a_file_name'.
			-- For now: This feature presumes a file-based database system.
		require
			real_location: (create {DIRECTORY}.make_open_read ((create {EXECUTION_ENVIRONMENT}).current_working_path.name.out + a_location)).exists
		local
			l_full_path: STRING
		do
			l_full_path := (create {EXECUTION_ENVIRONMENT}).current_working_path.name.out
			l_full_path.append_character ('\')
			l_full_path.append (a_location.out)
			l_full_path.append_character ('\')
			l_full_path.append (a_file_name.out)
			l_full_path.append_character ('.')
			l_full_path.append (extension)
			create last_database_path.make_from_string (l_full_path)
			create database.make_create_read_write (last_database_path.name)
		end

	last_database_path: PATH
			-- `last_database_path' used.
		attribute
			create Result.make_current
		end

feature {EAV_SYSTEM} -- Implementation: EAV Build Operations

	build_eav_structure
			-- `build_eav_structure'.
			-- Note these tables are constructed if they do not
			-- yet exist. If they do exist, they are left as-is.
			-- See {EAV_DOCS} for more information.
		do
				-- Build Metadata tables ...
			build_entity
			build_attribute

				-- Build Value tables ...
			build_date_value
			build_character_value
			build_varchar_value
			build_text_value
			build_numeric_value
			build_boolean_value
			build_integer_value
			build_float_value
			build_double_value
			build_real_value
			build_blob_value
		end

feature {NONE} -- Implementation: EAV Build Operations

	build_entity
			-- `build_entity' table (if needed).
			-- See {EAV_DOCS} for more information.
		local
			l_modify: SQLITE_MODIFY_STATEMENT
		do
			create l_modify.make (modify_statement ("Entity", <<create_table, check_for_exists>>,
													<<
													integer_field (entity_ent_id_field_name.twin) + primary_key + ascending_order + autoincrement,
													integer_field (sys_id_field_name.twin),
													text_field (entity_ent_uuid_field_name.twin),
													text_field (entity_ent_name_field_name.twin),
													integer_field (entity_ent_count_field_name.twin),
													boolean_field (is_deleted_field_name.twin),
													date_field (modified_date_field_name.twin),
													integer_field (modifier_id_field_name.twin)
													>>), database)
			l_modify.execute
		end

	build_attribute
			-- `build_attribute' table (if needed).
			-- See {EAV_DOCS} for more information.
		local
			l_modify: SQLITE_MODIFY_STATEMENT
		do
			create l_modify.make (modify_statement ("Attribute", <<create_table, check_for_exists>>,
													<<
													integer_field (attribute_atr_id_field_name.twin) + primary_key + ascending_order + autoincrement,
													integer_field (entity_ent_id_field_name.twin),
													text_field (attribute_atr_uuid_field_name.twin),
													text_field (attribute_atr_name_field_name.twin),
													text_field (attribute_atr_value_table_field_name.twin),
													boolean_field (is_deleted_field_name.twin),
													date_field (modified_date_field_name.twin),
													integer_field (modifier_id_field_name.twin)
													>>), database)
			l_modify.execute
		end

	build_date_value
			-- `build_date_value'.
		do build_value (date_value_table_name, agent date_field) end

	build_character_value
			-- `build_character_value'.
		do build_value (character_value_table_name.twin, agent character_field) end

	build_varchar_value
			-- `build_varchar_value'.
		do build_value (varchar_value_table_name.twin, agent varchar_field) end

	build_text_value
			-- `build_text_value'
		do build_value (text_value_table_name.twin, agent text_field) end

	build_numeric_value
			-- `build_numeric_value'.
		do build_value (number_value_table_name.twin, agent numeric_field) end

	build_boolean_value
			-- `build_boolean_value'.
		do build_value (boolean_value_table_name.twin, agent boolean_field) end

	build_integer_value
			-- `build_integer_value'.
		do build_value (integer_value_table_name.twin, agent integer_field) end

	build_float_value
			-- `build_float_value'.
		do build_value (float_value_table_name.twin, agent float_field) end

	build_double_value
			-- `build_double_value'.
		do build_value (double_value_table_name.twin, agent double_field) end

	build_real_value
			-- `build_real_value'.
		do build_value (real_value_table_name.twin, agent real_field) end

	build_blob_value
			-- `build_blob_value'.
		do build_value (blob_value_table_name.twin, agent blob_field) end

	build_value (a_table_name: STRING; a_item_field_agent: FUNCTION [TUPLE [STRING], STRING])
			-- `build_varchar_value' table (if needed).
			-- Services all higher `build_*' features (above).
		local
			l_modify: SQLITE_MODIFY_STATEMENT
			l_last_result: STRING
		do
			a_item_field_agent.call ("val_item")
			check has_result: attached {STRING} a_item_field_agent.last_result as al_result then l_last_result := al_result end
			create l_modify.make (modify_statement (a_table_name, <<create_table.twin, check_for_exists.twin>>,
													<<
													integer_field (value_val_id_field_name.twin) + primary_key.twin + ascending_order.twin + autoincrement.twin,
													integer_field (attribute_atr_id_field_name.twin),
													integer_field (instance_id_field_name.twin),
													l_last_result.twin,
													boolean_field (is_deleted_field_name.twin),
													date_field (modified_date_field_name.twin),
													integer_field (modifier_id_field_name.twin)
													>>), database)
			l_modify.execute
		end

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
			store_entity (a_object.computed_entity_name)

				-- New instance or existing?
			l_is_new := a_object.instance_id = new_instance_id_constant
			if a_object.instance_id = new_instance_id_constant then
				last_instance_count := next_entity_instance_id (a_object.Computed_entity_name)
				a_object.set_instance_id (last_instance_count)
				update_entity_instance_count (a_object.Computed_entity_name, a_object.instance_id)
			end
			check not_new_instance: not a_object.is_new end

				-- Then handle Attributes ...
			across
				a_object.feature_data (a_object) as ic_values
			loop
				store_attribute (ic_values.item.attr_name, ic_values.item.attr_value, a_object.instance_id, l_is_new)
			end
		end

	begin_transaction
			-- `begin_transaction' on `database'.
		do
			database.begin_transaction (False)
		end

	end_transaction
			-- `end_transaction' with `commit' on `database'.
		do
			database.commit
		end

feature {NONE} -- Implementation: Store Operations

	next_entity_instance_id (a_entity_name: STRING): INTEGER_64
			-- `next_entity_instance_id' for `a_entity_name'?
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_result: SQLITE_STATEMENT_ITERATION_CURSOR
			l_sql: STRING
		do
			l_sql := SELECT_keyword_string.twin
			l_sql.append_string_general (entity_ent_count_field_name)
			l_sql.append_string_general (FROM_keyword_string)
			l_sql.append_string_general (entity_table_name)
			l_sql.append_string_general (WHERE_keyword_string)
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
			incremented: Result > last_instance_count
		end

	last_instance_count: INTEGER_64
			-- `last_instance_count' of entity instance id's.

	update_entity_instance_count (a_entity_name: STRING; a_new_count: INTEGER_64)
			-- `update_entity_instance_count' for `a_entity_name' to `a_new_count'.
		local
			l_modify: SQLITE_MODIFY_STATEMENT
			l_sql: STRING
		do
			l_sql := "UPDATE "
			l_sql.append_string_general (entity_table_name)
			l_sql.append_string_general (SET_keyword_string)
			l_sql.append_string_general (entity_ent_count_field_name)
			l_sql.append_string_general (" = ")
			l_sql.append_string_general (a_new_count.out)
			l_sql.append_string_general (WHERE_keyword_string)
			l_sql.append_string_general (entity_ent_name_field_name)
			l_sql.append_string_general (" = '")
			l_sql.append_string_general (a_entity_name)
			l_sql.append_string_general ("';")
			create l_modify.make (l_sql, database)
			l_modify.execute
		end

feature -- Retrieve (fetch by ...) Operations

	fetch_by_instance_id (a_entity_id: INTEGER_64; a_setter: TUPLE [setter_agent: PROCEDURE [detachable ANY]; attribute_name: STRING]; a_instance_id: INTEGER_64)
			-- fetch_by_instance_id --> object
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_sql,
			l_value_table_name: STRING
			l_cursor: SQLITE_STATEMENT_ITERATION_CURSOR
		do
				-- Fetch the atr_value_table for entity_id and attribute name ...
			create l_sql.make_empty
			l_sql := "SELECT atr_value_table, atr_id FROM Attribute WHERE ent_id = " + a_entity_id.out + " and atr_name = '" + a_setter.attribute_name + "';"
			create l_query.make (l_sql, database)
			l_cursor := l_query.execute_new
			l_cursor.start
			check has_result: not l_cursor.after end
			check attached {STRING} l_cursor.item.value (1) as al_result then
				l_value_table_name := al_result
			end
			check attached {INTEGER_64} l_cursor.item.value (2) as al_atr_id then
					-- Now fetch the actual value ...
				l_sql := "SELECT val_item FROM " + l_value_table_name + " WHERE atr_id = " + al_atr_id.out + " and instance_id = " + a_instance_id.out + ";"
				create l_query.make (l_sql, database)
				l_cursor := l_query.execute_new
				l_cursor.start
				if not l_cursor.after then
					if attached {INTEGER_32} l_cursor.item.value (1) as al_integer then
						a_setter.setter_agent.call ([al_integer])
					elseif attached {INTEGER_64} l_cursor.item.value (1) as al_integer_64 then
						a_setter.setter_agent.call ([al_integer_64.as_integer_32])
					else
						a_setter.setter_agent.call ([l_cursor.item.value (1)])
					end
				end
			end
		end

			-- fetch_by_primary_key --> object
			-- fetch_by_candidate_key --> object
			-- fetch_by_filtered_key --> collection
			-- fetch_by_adhoc_query --> collection

feature {TEST_SET_BRIDGE} -- Implementation: Entity

	store_entity (a_entity_name: STRING)
			-- `store_entity' `a_entity_name'.
		do
			if has_entity (a_entity_name) then
				do_nothing -- soon: just get the ent_id
			else
				store_new_entity (a_entity_name)
				recently_found_entities.force (a_entity_name, a_entity_name.case_insensitive_hash_code)
			end
			last_entity_id := entity_id (a_entity_name)
		ensure
			has_entity: has_entity (a_entity_name)
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
				l_sql := SELECT_keyword_string.twin
				l_sql.append_string_general (entity_ent_name_field_name.twin)
				l_sql.append_string_general (FROM_keyword_string.twin)
				l_sql.append_string_general (entity_table_name.twin)
				l_sql.append_string_general (WHERE_keyword_string.twin)
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
			l_sql := SELECT_keyword_string.twin
			l_sql.append_string_general (entity_ent_id_field_name.twin)
			l_sql.append_string_general (FROM_keyword_string.twin)
			l_sql.append_string_general (entity_table_name.twin)
			l_sql.append_string_general (WHERE_keyword_string.twin)
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

	store_attribute (a_attribute_name: STRING; a_value: detachable ANY; a_entity_id: INTEGER_64; a_is_new: BOOLEAN)
			-- `store_attribute' named `a_attribute_name' and having (optional) `a_value'.
		do
				-- Compute attribute data type
			if attached {ABSOLUTE} a_value as al_value then
				value_table := date_value_table_name; value := al_value.out
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
			else
				check unknown_data_type: False end
			end

				-- Handle storage of attribute meta data
			store_attribute_name (a_attribute_name, a_entity_id, value_table)

				-- Store the actual attribute data
			store_with_modify_or_insert (value_table, value, last_attribute_id, a_entity_id, a_is_new)
		end

	value: STRING attribute create Result.make_empty end
	value_table: STRING attribute create Result.make_empty end

	store_with_modify_or_insert (a_table, a_value: STRING; a_attribute_id, a_entity_id: INTEGER_64; a_is_new: BOOLEAN)
			-- `store_with_modify_or_insert' of `a_value' for `a_attribute_id' and `a_entity_id'.
		local
			l_insert: SQLITE_INSERT_STATEMENT
			l_modify: SQLITE_MODIFY_STATEMENT
			l_sql: STRING
		do
			if a_is_new then
				l_sql := INSERT_keyword_string.twin
				l_sql.append_string_general (OR_keyword_string)
				l_sql.append_string_general (REPLACE_keyword_string)
				l_sql.append_string_general (INTO_keyword_string)
				l_sql.append_string_general (a_table)
				l_sql.append_string_general (" (atr_id, instance_id, val_item) VALUES (")
				l_sql.append_string_general (a_attribute_id.out)
				l_sql.append_character (comma)
				l_sql.append_string_general (a_entity_id.out)
				l_sql.append_character (comma)
				l_sql.append_character (open_single_quote)
				l_sql.append_string_general (a_value)
				l_sql.append_character (close_single_quote)
				l_sql.append_character (close_parenthesis)
				l_sql.append_character (semi_colon)
				create l_insert.make (l_sql, database)
				l_insert.execute
			else
				l_sql := UPDATE_keyword_string.twin
				l_sql.append_string_general (a_table)
				l_sql.append_string_general (SET_keyword_string.twin)
				l_sql.append_string_general (value_val_item_field_name.twin)
				l_sql.append_string_general (equals.twin)
				l_sql.append_character (open_single_quote)
				l_sql.append_string_general (a_value)
				l_sql.append_character (close_single_quote)
				l_sql.append_string_general (WHERE_keyword_string.twin)
				l_sql.append_string_general (attribute_atr_id_field_name.twin)
				l_sql.append_string_general (equals.twin)
				l_sql.append_string_general (a_attribute_id.out)
				l_sql.append_string_general (AND_keyword_string.twin)
				l_sql.append_string_general (instance_id_field_name.twin)
				l_sql.append_string_general (equals.twin)
				l_sql.append_string_general (a_entity_id.out)
				l_sql.append_character (semi_colon)

				create l_modify.make (l_sql, database)
				l_modify.execute
			end
		end

	store_attribute_name (a_name: STRING; a_entity_id: INTEGER_64; a_value_table: STRING)
			-- `store_entity' `a_name'.
		do
			if has_attribute (a_name) then
				do_nothing -- soon: just get the atr_id
			else
				store_new_attribute (a_name, a_entity_id, a_value_table)
				recently_found_attributes.force (a_name, a_name.case_insensitive_hash_code)
			end
			last_attribute_id := attribute_id (a_name)
		ensure
			has_attribute: has_attribute (a_name)
		end

	store_new_attribute (a_name: STRING; a_entity_id: INTEGER_64; a_value_table: STRING)
			-- `store_new_attribute' as `a_name'.
		require
			not_has: not has_attribute (a_name)
		local
			l_insert: SQLITE_INSERT_STATEMENT
		do
			create l_insert.make ("INSERT INTO Attribute (ent_id, atr_uuid, atr_name, atr_value_table, is_deleted, modified_date, modifier_id) VALUES (:ENT_ID, :ATR_UUID, :ATR_NAME, :ATR_VAL_TAB, :IS_DEL, :MOD_DATE, :MOD_ID);", database)
			check l_insert_is_compiled: l_insert.is_compiled end
			l_insert.execute_with_arguments ([
				create {SQLITE_INTEGER_ARG}.make (":ENT_ID", a_entity_id),
				create {SQLITE_STRING_ARG}.make (":ATR_UUID", uuid.out),
				create {SQLITE_STRING_ARG}.make (":ATR_NAME", a_name),
				create {SQLITE_STRING_ARG}.make (":ATR_VAL_TAB", a_value_table),
				create {SQLITE_INTEGER_ARG}.make (":IS_DEL", 0),
				create {SQLITE_STRING_ARG}.make (":MOD_DATE", (create {DATE_TIME}.make_now).out),
				create {SQLITE_INTEGER_ARG}.make (":MOD_BY", 1)
				])
			recently_found_attributes.force (a_name, a_name.case_insensitive_hash_code)
		end

	has_attribute (a_name: STRING): BOOLEAN
			-- `has_attribute' `a_name' in attributes table?
		local
			l_result: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			Result := recently_found_attributes.has (a_name.case_insensitive_hash_code)
			if not Result then
				l_result := SELECT_atr_id_FROM_attribute_WHERE_atr_name_equals_a_name (a_name)
				l_result.start
				Result := not l_result.after and then
							l_result.item.string_value (1).same_string (a_name)
			end
		end

	attribute_id (a_name: STRING): INTEGER_64
			-- `attribute_id' of attribute named `a_name'.
		local
			l_result: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			l_result := SELECT_atr_id_FROM_attribute_WHERE_atr_name_equals_a_name (a_name)
			l_result.start
			Result := l_result.item.integer_64_value (1)
		end

	SELECT_atr_id_FROM_attribute_WHERE_atr_name_equals_a_name (a_name: STRING): SQLITE_STATEMENT_ITERATION_CURSOR
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_result: SQLITE_STATEMENT_ITERATION_CURSOR
			l_sql: STRING
		do
			l_sql := SELECT_atr_id_FROM_attribute_WHERE_atr_name_equals.twin
			l_sql.append_string_general (a_name)
			l_sql.append_string_general (close_single_quote_semi_colon.twin)
			create l_query.make (l_sql, database)
			Result := l_query.execute_new
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

	new_instance_id_constant: INTEGER_64 = 0
			-- `new_instance_id_constant' is how Current recognizes "new" Entity instances.

	SELECT_atr_id_FROM_attribute_WHERE_atr_name_equals: STRING
			-- Front half of `select_atr_id_from_attribute_where_atr_name_equals'.
		once
			Result := SELECT_keyword_string.twin
			Result.append_string_general (attribute_atr_id_field_name.twin)
			Result.append_string_general (FROM_keyword_string.twin)
			Result.append_string_general (attribute_table_name.twin)
			Result.append_string_general (WHERE_keyword_string.twin)
			Result.append_string_general (attribute_atr_name_field_name.twin)
			Result.append_string_general (equals.twin)
			Result.append_character (open_single_quote)
		end

	close_single_quote_semi_colon: STRING
			-- Back half of `close_single_quote_semi_colon'.
		once
			create Result.make_empty
			Result.append_character (close_single_quote)
			Result.append_character (semi_colon)
		end

feature {NONE} -- Implementation: Constants

	ascending_order: STRING = "ASC "
		-- `ascending_order' magic number replacement constant.

	autoincrement: STRING = "AUTOINCREMENT "
		-- `autoincrement' magic number replacement constant.

	check_for_exists: STRING = "IF NOT EXISTS "
		-- `check_for_exists' magic number replacement constant.

	create_table: STRING = "CREATE TABLE "
		-- `create_table' magic number replacement constant.

	extension: STRING = "sqlite3"
		-- `extension' magic number replacement constant.

	primary_key: STRING = "PRIMARY KEY "
		-- `primary_key' magic number replacement constant.

	sqlite_blob_kw: STRING = " BLOB "
		-- `sqlite_blob_kw' magic number replacement constant.

	sqlite_integer_kw: STRING = " INTEGER "
		-- `sqlite_integer_kw' magic number replacement constant.

	sqlite_numeric_kw: STRING = " NUMERIC "
		-- `sqlite_numeric_kw' magic number replacement constant.

	sqlite_real_kw: STRING = " REAL "
		-- `sqlite_real_kw' magic number replacement constant.

	sqlite_text_kw: STRING = " TEXT "
		-- `sqlite_text_kw' magic number replacement constant.

	date_field,
	character_field,
	varchar_field,
	text_field (a_name: STRING): STRING
			-- Date, character, varchar, and text fields are all TEXT.
		do
			Result := a_name; Result.append (sqlite_text_kw)
		end

	numeric_field (a_name: STRING): STRING
			-- Numeric fields really need direct support as INTEGER, REAL, or DECIMAL.
		do
			Result := a_name; Result.append (sqlite_numeric_kw)
		end

	boolean_field,
	integer_field (a_name: STRING): STRING
			-- Boolean and integer fields are both INTEGER.
		do
			Result := a_name; Result.append (sqlite_integer_kw)
		end

	float_field,
	double_field,
	real_field (a_name: STRING): STRING
			-- Floats and doubles are reals.
		do
			Result := a_name; Result.append (sqlite_real_kw)
		end

	blob_field (a_name: STRING): STRING
			-- Blob fields of all sorts.
		do
			Result := a_name; Result.append (sqlite_blob_kw)
		end

feature {NONE} -- Implementation: Value Table Names

	blob_value_table_name: STRING = "Value_blob"
	boolean_value_table_name: STRING = "Value_boolean"
	character_value_table_name: STRING = "Value_character"
	date_value_table_name: STRING = "Value_date"
	double_value_table_name: STRING = "Value_double"
	float_value_table_name: STRING = "Value_float"
	integer_value_table_name: STRING = "Value_integer"
	number_value_table_name: STRING = "Value_numeric"
	real_value_table_name: STRING = "Value_real"
	text_value_table_name: STRING = "Value_text"
	varchar_value_table_name: STRING = "Value_varchar"

feature {EAV_SYSTEM, EAV_DATA_MANAGER} -- Implementation: Access

	database: SQLITE_DATABASE
			-- `database'

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
