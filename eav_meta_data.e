note
	description: "[
		Abstract notion of an {EAV_META_DATA}.
		]"

deferred class
	EAV_META_DATA

inherit
	EAV_COMMON

feature -- Access

	uuid: UUID
			-- `uuid' of Current {EAV_META_DATA} item.

	name: STRING
			-- `name' of Current {EAV_META_DATA} item.

end
