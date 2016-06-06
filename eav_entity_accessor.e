note
	description: "[
		Abstract notion of an deferred {EAV_ENTITY_ACCESSOR}.
]"

deferred class
	EAV_ENTITY_ACCESSOR

inherit
	EAV_META_DATA

	EAV_SUB_META_DATA
		rename
			meta_parent as system
		end

feature {NONE} -- Initialization

	make_with_data (a_system: EAV_SYSTEM_ACCESSOR; a_id: like id; a_uuid: like uuid)
			-- `make_with_data' for `a_system' as `a_id', named `a_name' and unique based on `a_uuid'.
		do
			system := a_system
			id := a_id
			uuid := a_uuid
		ensure
			system_set: system ~ a_system
			id_set: id = a_id
			uuid_set: uuid ~ a_uuid
		end

feature -- Access

	system: EAV_SYSTEM_ACCESSOR
			-- <Precursor>
			-- Entity of parent {EAV_SYSTEM_ACCESSOR}.

;note
	design_intent: "[
		Your_text_goes_here
]"

end
