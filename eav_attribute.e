note
	description: "[
		Representation of an effected {EAV_ATTRIBUTE}.
]"

class
	EAV_ATTRIBUTE

inherit
	EAV_ATTRIBUTE_ACCESSOR

create
	make_with_data,
	make_with_name

feature {NONE} -- Initialization

	make_with_name (a_entity: EAV_ENTITY_ACCESSOR; a_id: like id; a_name: like name; a_uuid: like uuid)
			-- `make_with_data' for `a_entity' as `a_id', named `a_name' and unique based on `a_uuid'.
		do
			make_with_data (a_entity, a_id, a_uuid)
			set_name (a_name)
		ensure
			name_set: name.same_string (a_name)
		end

feature -- Access

	name: STRING
			-- <Precursor>
		attribute
			create Result.make_empty
		end

feature -- Setters

	set_name (a_name: like name)
			-- `set_name' with `a_name'
		do
			name := a_name
		ensure
			set: name ~ a_name
		end

;note
	design_intent: "[
		Your_text_goes_here
]"

end
