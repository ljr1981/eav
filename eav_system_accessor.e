note
	description: "[
		Abstract notion of a deferred {EAV_SYSTEM_ACCESSOR} meta.
		]"

deferred class
	EAV_SYSTEM_ACCESSOR

inherit
	EAV_META_DATA

feature {NONE} -- Initialization

	make_with_data (a_id: like id; a_uuid: like uuid)
			-- `make_with_data' `a_name' and `a_uuid'.
		do
			id := a_id
			uuid := a_uuid
		ensure
			id_set: id = a_id
			uuid_set: uuid ~ a_uuid
		end

end
