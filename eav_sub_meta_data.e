note
	description: "[
		Representation of an effected {EAV_SUB_META_DATA}.
]"

deferred class
	EAV_SUB_META_DATA

inherit
	EAV_META_DATA

feature -- Access

	meta_parent: EAV_META_DATA
			-- `meta_parent'
		deferred
		end

note
	design_intent: "[
		Your_text_goes_here
]"

end
