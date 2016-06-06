note
	description: "[
		Representation of an {EAV_SYSTEM} meta table.
		]"

class
	EAV_SYSTEM

inherit
	EAV_META_DATA

create
	make_with_data

feature {NONE} -- Initialization

	make_with_data (a_id: like id; a_name: like name; a_uuid: like uuid)
			-- `make_with_data' `a_name' and `a_uuid'.
		do
			id := a_id
			name := a_name
			uuid := a_uuid
		ensure
			id_set: id = a_id
			name_set: name.same_string (a_name)
			uuid_set: uuid ~ a_uuid
		end

end
