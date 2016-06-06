note
	description: "[
		Abstract notion of an deferred {EAV_ATTRIBUTE_ACCESSOR}.
]"

deferred class
	EAV_ATTRIBUTE_ACCESSOR

inherit
	EAV_META_DATA

	EAV_SUB_META_DATA
		rename
			meta_parent as entity
		end

feature {NONE} -- Initialization

	make_with_data (a_entity: EAV_ENTITY_ACCESSOR; a_id: like id; a_uuid: like uuid)
			-- `make_with_data' for `a_entity' as `a_id', and unique based on `a_uuid'.
		do
			entity := a_entity
			id := a_id
			uuid := a_uuid
		ensure
			entity_set: entity ~ a_entity
			id_set: id = a_id
			uuid_set: uuid ~ a_uuid
		end

feature -- Access

	entity: EAV_ENTITY_ACCESSOR
			-- <Precursor>
			-- Entity of parent {EAV_SYSTEM}.

;note
	design_intent: "[
		Your_text_goes_here
]"

end
