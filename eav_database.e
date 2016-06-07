note
	description: "[
		Representation of an effected {EAV_DATABASE}.
		]"

class
	EAV_DATABASE

create
	make

feature {NONE} -- Initialization

	make (a_location, a_file_name: READABLE_STRING_GENERAL)
			-- `make' at `a_location' (uri, file-spec, etc) using `a_file_name'.
			-- For now: This feature presumes a file-based database system.
		local
			l_env: EXECUTION_ENVIRONMENT
			l_full_name: STRING
		do
			create l_env
			l_full_name := l_env.current_working_path.name.out
			l_full_name.append_character ('\')
			l_full_name.append (a_location.out)
			l_full_name.append_character ('\')
			l_full_name.append (a_file_name.out)
			l_full_name.append_character ('.')
			l_full_name.append (extension)
			create last_database_path.make_from_string (l_full_name)
			create database.make_create_read_write (last_database_path.name)
		end

	last_database_path: PATH

feature -- EAV Build Operations

	build_eav_structure
			-- `build_eav_structure'.
		do
			build_entity
			build_attribute

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

	build_entity
			-- `build_entity' table (if needed).
		local
			l_modify: SQLITE_MODIFY_STATEMENT
		do
			create l_modify.make (modify_statement ("Entity", <<create_table, check_for_exists>>,
													<<
													integer_field ("ent_id") + primary_key + ascending_order + autoincrement,
													integer_field ("sys_id"),
													text_field ("ent_uuid"),
													text_field ("ent_name"),
													boolean_field ("is_deleted"),
													date_field ("modified_date"),
													integer_field ("modifier_id")
													>>), database)
			l_modify.execute
		end

	build_attribute
			-- `build_attribute' table (if needed).
		local
			l_modify: SQLITE_MODIFY_STATEMENT
		do
			create l_modify.make (modify_statement ("Attribute", <<create_table, check_for_exists>>,
													<<
													integer_field ("atr_id") + primary_key + ascending_order + autoincrement,
													integer_field ("ent_id"),
													text_field ("atr_uuid"),
													text_field ("atr_name"),
													boolean_field ("is_deleted"),
													date_field ("modified_date"),
													integer_field ("modifier_id")
													>>), database)
			l_modify.execute
		end

	build_date_value do build_value ("Value_date", agent date_field) end
	build_character_value do build_value ("Value_character", agent character_field) end
	build_varchar_value do build_value ("Value_varchar", agent varchar_field) end
	build_text_value do build_value ("Value_text", agent text_field) end
	build_numeric_value do build_value ("Value_numeric", agent numeric_field) end
	build_boolean_value do build_value ("Value_boolean", agent boolean_field) end
	build_integer_value do build_value ("Value_integer", agent integer_field) end
	build_float_value do build_value ("Value_float", agent float_field) end
	build_double_value do build_value ("Value_double", agent double_field) end
	build_real_value do build_value ("Value_real", agent real_field) end
	build_blob_value do build_value ("Value_blob", agent blob_field) end

	build_value (a_table_name: STRING; a_item_field_agent: FUNCTION [TUPLE [STRING], STRING])
			-- `build_varchar_value' table (if needed).
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
		end

feature {NONE} -- Implementation: Constants

	extension: STRING = "sqlite3"
	create_table: STRING = "CREATE TABLE "
	check_for_exists: STRING = "IF NOT EXISTS "
	primary_key: STRING = "PRIMARY KEY "
	ascending_order: STRING = "ASC "
	autoincrement: STRING = "AUTOINCREMENT "

	date_field,
	character_field,
	varchar_field,
	text_field (a_name: STRING): STRING
		do
			Result := a_name; Result.append (" TEXT ")
		end

	numeric_field (a_name: STRING): STRING
		do
			Result := a_name; Result.append (" NUMERIC ")
		end

	boolean_field,
	integer_field (a_name: STRING): STRING
		do
			Result := a_name; Result.append (" INTEGER ")
		end

	float_field,
	double_field,
	real_field (a_name: STRING): STRING
		do
			Result := a_name; Result.append (" REAL ")
		end

	blob_field (a_name: STRING): STRING
		do
			Result := a_name; Result.append (" BLOB ")
		end

feature {EAV_SYSTEM} -- Implementation: Access

	database: SQLITE_DATABASE
			-- `database'

;note
	design_intent: "[
		Your_text_goes_here
		]"

end
