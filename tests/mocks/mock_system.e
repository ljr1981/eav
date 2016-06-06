note
	description: "[
		Representation of an effected {MOCK_SYSTEM}.
]"

class
	MOCK_SYSTEM

inherit
	EAV_SYSTEM_ACCESSOR

create
	make_with_data

feature -- Access

	name: STRING = "system"
			-- <Precursor>

;note
	design_intent: "[
		Your_text_goes_here
]"

end
