note
	description: "[
		Representation of an effected {EAV_CONSTANTS}.
		]"

class
	EAV_CONSTANTS

feature -- Constants

	SELECT_keyword_string: STRING = " SELECT "
	FROM_keyword_string: STRING = " FROM "
	SET_keyword_string: STRING = " SET "
	WHERE_keyword_string: STRING = " WHERE "

	entity_table_name: STRING = "Entity"
	entity_ent_id_field_name: STRING = "ent_id"
	entity_ent_uuid_field_name: STRING = "ent_uuid"
	entity_ent_name_field_name: STRING = "ent_name"
	entity_ent_count_field_name: STRING = "ent_count"

	attribute_atr_id_field_name: STRING = "atr_id"
	attribute_atr_uuid_field_name: STRING = "atr_uuid"
	attribute_atr_name_field_name: STRING = "atr_name"
	attribute_atr_value_table_field_name: STRING = "atr_value_table"

	value_val_id_field_name: STRING = "val_id"
	sys_id_field_name: STRING = "sys_id"
	instance_id_field_name: STRING = "instance_id"

	is_deleted_field_name: STRING = "is_deleted"
	modified_date_field_name: STRING = "modified_date"
	modifier_id_field_name: STRING = "modifier_id"


note
	design_intent: "[
		Your_text_goes_here
		]"

end
