note
	description: "[
		Representation of an effected {EAV_CONSTANTS}.
		]"

class
	EAV_CONSTANTS

feature -- Constants

	new_instance_id_constant: INTEGER_64 = 0
			-- `new_instance_id_constant' is how Current recognizes "new" Entity instances.

	new_object_id_constant: INTEGER_64 = 0
			-- `new_object_id_constant' is how Current recognizes "new" Object instances.

	AND_kw: STRING = " AND "
	ASC_kw: STRING = " ASC "
	AUTOINCREMENT_kw: STRING = " AUTOINCREMENT "
	BLOB_kw: STRING = " BLOB "
	CREATE_TABLE_kw: STRING = " CREATE TABLE "
	FROM_kw: STRING = " FROM "
	IF_NOT_EXISTS_kw_phrase: STRING = " IF NOT EXISTS "
	INSERT_kw: STRING = " INSERT "
	INTEGER_kw: STRING = " INTEGER "
	INTO_kw: STRING = " INTO "
	NUMERIC_kw: STRING = " NUMERIC "
	OR_kw: STRING = " OR "
	PRIMARY_KEY_kw: STRING = " PRIMARY KEY "
	REAL_kw: STRING = " REAL "
	REPLACE_kw: STRING = " REPLACE "
	SELECT_kw: STRING = " SELECT "
	SET_kw: STRING = " SET "
	TEXT_kw: STRING = " TEXT "
	UPDATE_kw: STRING = " UPDATE "
	VALUES_kw: STRING = " VALUES "
	WHERE_kw: STRING = " WHERE "

	extension: STRING = "sqlite3"

	open_parenthesis: CHARACTER = '('
	close_parenthesis: CHARACTER = ')'
	semi_colon: CHARACTER = ';'
	colon: CHARACTER = ':'
	comma: CHARACTER = ','
	space: CHARACTER = ' '
	open_single_quote,
	close_single_quote: CHARACTER = '''
	equals: STRING = " = "

	entity_table_name: STRING = "Entity"
	entity_ent_id_field_name: STRING = "ent_id"
	entity_ent_uuid_field_name: STRING = "ent_uuid"
	entity_ent_name_field_name: STRING = "ent_name"
	entity_ent_count_field_name: STRING = "ent_count"

	attribute_table_name: STRING = "Attribute"
	attribute_atr_id_field_name: STRING = "atr_id"
	attribute_atr_uuid_field_name: STRING = "atr_uuid"
	attribute_atr_name_field_name: STRING = "atr_name"
	attribute_atr_value_table_field_name: STRING = "atr_value_table"

	value_val_id_field_name: STRING = "val_id"
	value_val_item_field_name: STRING = "val_item"
	sys_id_field_name: STRING = "sys_id"
	instance_id_field_name: STRING = "instance_id"
	object_id_field_name: STRING = "object_id"

	is_deleted_field_name: STRING = "is_deleted"
	modified_date_field_name: STRING = "modified_date"
	modifier_id_field_name: STRING = "modifier_id"

	boolean_value_table_name: STRING = "Value_boolean"
	integer_value_table_name: STRING = "Value_integer"
	real_value_table_name: STRING = "Value_real"
	text_value_table_name: STRING = "Value_text"
	blob_value_table_name: STRING = "Value_blob"

	BOOLEAN_value_type_code: INTEGER = 1
	INTEGER_value_type_code: INTEGER = 2
	REAL_value_type_code: INTEGER = 3
	TEXT_value_type_code: INTEGER = 4
	BLOB_value_type_code: INTEGER = 5
	REFERENCE_value_type_code: INTEGER = 6 -- Reserved for object-graph reference features

feature -- Lists

	comparison_operators: HASH_TABLE [STRING, INTEGER]
			-- `comparison_operators' hash.
		once
			create Result.make (10)
			Result.force ("==", ("==").hash_code)
			Result.force ("=", ("=").hash_code)
			Result.force ("!=", ("!=").hash_code)
			Result.force ("<>", ("<>").hash_code)
			Result.force (">", (">").hash_code)
			Result.force ("<", ("<").hash_code)
			Result.force (">=", (">=").hash_code)
			Result.force ("<=", ("<=").hash_code)
			Result.force ("!<", ("!<").hash_code)
			Result.force ("!>", ("!>").hash_code)
		end

	logical_operators: HASH_TABLE [STRING, INTEGER]
		once
			create Result.make (10)
			Result.force ("AND", ("AND").hash_code)
			Result.force ("BETWEEN",("BETWEEN").hash_code)
			Result.force ("EXISTS",	("EXISTS").hash_code)
			Result.force ("IN",	("IN").hash_code)
			Result.force ("NOT IN", ("NOT IN").hash_code)
			Result.force ("LIKE", ("LIKE").hash_code)
			Result.force ("GLOB", ("GLOB").hash_code)
			Result.force ("NOT", ("NOT").hash_code)
			Result.force ("OR", ("OR").hash_code)
			Result.force ("IS NULL", ("IS NULL").hash_code)
			Result.force ("IS", ("IS").hash_code)
			Result.force ("IS NOT", ("IS NOT").hash_code)
			Result.force ("||", ("||").hash_code)
			Result.force ("UNIQUE", ("UNIQUE").hash_code)

		end

note
	design_intent: "[
		Your_text_goes_here
		]"

end
