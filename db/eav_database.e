note
	description: "[
		Representation of an effected {EAV_DATABASE}.
		]"
	design: "See notes clause at the end of this class."

class
	EAV_DATABASE

inherit
	RANDOMIZER

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
													integer_field ("ent_id") + primary_key + ascending_order + autoincrement,
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
			create l_modify.make (modify_statement ("Attribute", <<create_table, check_for_exists>>,
													<<
													integer_field ("atr_id") + primary_key + ascending_order + autoincrement,
													integer_field ("ent_id"),
													text_field ("atr_uuid"),
													text_field ("atr_name"),
													text_field ("atr_value_table"),
													boolean_field ("is_deleted"),
													date_field ("modified_date"),
													integer_field ("modifier_id")
													>>), database)
			l_modify.execute
		end

	build_date_value
			-- `build_date_value'.
		do build_value (date_value_table_name, agent date_field) end

	build_character_value
			-- `build_character_value'.
		do build_value (character_value_table_name, agent character_field) end

	build_varchar_value
			-- `build_varchar_value'.
		do build_value (varchar_value_table_name, agent varchar_field) end

	build_text_value
			-- `build_text_value'
		do build_value (text_value_table_name, agent text_field) end

	build_numeric_value
			-- `build_numeric_value'.
		do build_value (number_value_table_name, agent numeric_field) end

	build_boolean_value
			-- `build_boolean_value'.
		do build_value (boolean_value_table_name, agent boolean_field) end

	build_integer_value
			-- `build_integer_value'.
		do build_value (integer_value_table_name, agent integer_field) end

	build_float_value
			-- `build_float_value'.
		do build_value (float_value_table_name, agent float_field) end

	build_double_value
			-- `build_double_value'.
		do build_value (double_value_table_name, agent double_field) end

	build_real_value
			-- `build_real_value'.
		do build_value (real_value_table_name, agent real_field) end

	build_blob_value
			-- `build_blob_value'.
		do build_value (blob_value_table_name, agent blob_field) end

	build_value (a_table_name: STRING; a_item_field_agent: FUNCTION [TUPLE [STRING], STRING])
			-- `build_varchar_value' table (if needed).
			-- Services all higher `build_*' features (above).
		local
			l_modify: SQLITE_MODIFY_STATEMENT
			l_last_result: STRING
		do
			a_item_field_agent.call ("val_item")
			check has_result: attached {STRING} a_item_field_agent.last_result as al_result then l_last_result := al_result end
			create l_modify.make (modify_statement (a_table_name, <<create_table, check_for_exists>>,
													<<
													integer_field ("val_id") + primary_key + ascending_order + autoincrement,
													integer_field ("atr_id"),
													integer_field ("instance_id"),
													l_last_result,
													boolean_field ("is_deleted"),
													date_field ("modified_date"),
													integer_field ("modifier_id")
													>>), database)
			l_modify.execute
		end

feature -- Store Operations

	store (a_object: EAV_DB_ENABLED)
			-- `store' `a_object' into `database'.
		do
			-- entity_name, feature_data (a_object).to_array
				-- Handle Entity first ...
			store_entity (a_object.computed_entity_name)

				-- New instance or existing?
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
				store_attribute (ic_values.item.attr_name, ic_values.item.attr_value, a_object.instance_id)
			end
		end

feature {NONE} -- Implementation: Store Operations

	next_entity_instance_id (a_entity_name: STRING): INTEGER_64
			-- `next_entity_instance_id' for `a_entity_name'?
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_result: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			create l_query.make ("SELECT ent_count FROM Entity WHERE ent_name = '" + a_entity_name + "';", database)
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
		do
			database.begin_transaction (False)
			create l_modify.make ("UPDATE Entity SET ent_count = " + a_new_count.out + " WHERE ent_name = '" + a_entity_name + "';", database)
			l_modify.execute
			database.commit
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
				recently_found_entities.force (a_entity_name)
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
			database.begin_transaction (False)
			l_insert.execute_with_arguments ([
				create {SQLITE_STRING_ARG}.make (":ENT_UUID", uuid.out),
				create {SQLITE_STRING_ARG}.make (":ENT_NAME", a_entity_name),
				create {SQLITE_INTEGER_ARG}.make (":ENT_CNT", 0),
				create {SQLITE_INTEGER_ARG}.make (":IS_DEL", 0),
				create {SQLITE_STRING_ARG}.make (":MOD_DATE", (create {DATE_TIME}.make_now).out)
				])
			database.commit
		end

	has_entity (a_entity_name: STRING): BOOLEAN
			-- `has_entity' `a_entity_name'?
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_result: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			Result := recently_found_entities.has (a_entity_name)
			if not Result then
				create l_query.make ("SELECT ent_name FROM entity WHERE ent_name = '" + a_entity_name + "';", database)
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
		do
			create l_query.make ("SELECT ent_id FROM entity WHERE ent_name = '" + a_entity_name + "';", database)
			l_result := l_query.execute_new
			l_result.start
			Result := l_result.item.integer_64_value (1)
		end

	last_entity_id: INTEGER_64
			-- `last_entity_id' of last accessed `entity_id'.

	recently_found_entities: ARRAYED_LIST [STRING]
			-- `recently_found_entities'.
		attribute
			create Result.make (50)
		end


feature {TEST_SET_BRIDGE} -- Implementation: Attribute

	store_attribute (a_attribute_name: STRING; a_value: detachable ANY; a_entity_id: INTEGER_64)
			-- `store_attribute' named `a_attribute_name' and having (optional) `a_value'.
		local
			l_value_table: STRING
			l_value: STRING
		do
			create l_value_table.make_empty
			create l_value.make_empty
				-- Compute attribute data type
			if attached {DATE} a_value as al_value then
				l_value_table := date_value_table_name; l_value := al_value.out
			elseif attached {DATE_TIME} a_value as al_value then
				l_value_table := date_value_table_name; l_value := al_value.out
			elseif attached {CHARACTER} a_value as al_value then
				l_value_table := text_value_table_name; l_value := al_value.out
			elseif attached {STRING} a_value as al_value then
				l_value_table := text_value_table_name; l_value := al_value.out
			elseif attached {INTEGER} a_value as al_value then
				l_value_table := integer_value_table_name; l_value := al_value.out
			elseif attached {REAL} a_value as al_value then
				l_value_table := real_value_table_name; l_value := al_value.out
			elseif attached {DECIMAL} a_value as al_value then
				l_value_table := real_value_table_name; l_value := al_value.out
			elseif attached {BOOLEAN} a_value as al_value then
				l_value_table := integer_value_table_name; l_value := al_value.to_integer.out
			elseif attached {NUMERIC} a_value as al_value then
				-- For now: Please choose between: INTEGER, REAL, or DECIMAL in the source object data type.
				check numeric_data_type: False end
			else
				check unknown_data_type: False end
			end

				-- Handle storage of attribute meta data
			store_attribute_name (a_attribute_name, a_entity_id, l_value_table)

				-- Store the actual attribute data
			database.begin_transaction (False)

			store_with_modify_or_insert (l_value_table, l_value, last_attribute_id, a_entity_id)

			database.commit
		end

	store_with_modify_or_insert (a_table, a_value: STRING; a_attribute_id, a_entity_id: INTEGER_64)
			-- `store_with_modify_or_insert' of `a_value' for `a_attribute_id' and `a_entity_id'.
		local
			l_insert: SQLITE_INSERT_STATEMENT
			l_modify: SQLITE_MODIFY_STATEMENT
		do
			create l_modify.make ("UPDATE " + a_table + " SET val_item = '" + a_value + "' WHERE  atr_id = " + a_attribute_id.out + " and instance_id = " + a_entity_id.out + ";", database)
			l_modify.execute
			if l_modify.changes_count = 0 then
				create l_insert.make ("INSERT OR REPLACE INTO " + a_table + " (atr_id, instance_id, val_item) VALUES (" + a_attribute_id.out + "," + a_entity_id.out + ",'" + a_value + "');", database)
				l_insert.execute
			end
		end

	store_attribute_name (a_name: STRING; a_entity_id: INTEGER_64; a_value_table: STRING)
			-- `store_entity' `a_name'.
		do
			if has_attribute (a_name) then
				do_nothing -- soon: just get the atr_id
			else
				store_new_attribute (a_name, a_entity_id, a_value_table)
				recently_found_attributes.force (a_name)
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
			database.begin_transaction (False)
			l_insert.execute_with_arguments ([
				create {SQLITE_INTEGER_ARG}.make (":ENT_ID", a_entity_id),
				create {SQLITE_STRING_ARG}.make (":ATR_UUID", uuid.out),
				create {SQLITE_STRING_ARG}.make (":ATR_NAME", a_name),
				create {SQLITE_STRING_ARG}.make (":ATR_VAL_TAB", a_value_table),
				create {SQLITE_INTEGER_ARG}.make (":IS_DEL", 0),
				create {SQLITE_STRING_ARG}.make (":MOD_DATE", (create {DATE_TIME}.make_now).out),
				create {SQLITE_INTEGER_ARG}.make (":MOD_BY", 1)
				])
			database.commit
		end

	has_attribute (a_name: STRING): BOOLEAN
			-- `has_attribute' `a_name'?
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_result: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			Result := recently_found_attributes.has (a_name)
			if not Result then
				create l_query.make ("SELECT atr_name FROM attribute WHERE atr_name = '" + a_name + "';", database)
				l_result := l_query.execute_new
				l_result.start
				Result := not l_result.after and then
							l_result.item.string_value (1).same_string (a_name)
			end
		end

	attribute_id (a_name: STRING): INTEGER_64
			-- `attribute_id' of `a_name'.
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_result: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			create l_query.make ("SELECT atr_id FROM attribute WHERE atr_name = '" + a_name + "';", database)
			l_result := l_query.execute_new
			l_result.start
			Result := l_result.item.integer_64_value (1)
		end

	last_attribute_id: INTEGER_64
			-- `last_attribute_id' of last accessed `attribute_id'.

	recently_found_attributes: ARRAYED_LIST [STRING]
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
