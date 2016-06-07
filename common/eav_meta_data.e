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
		attribute
			Result := (create {RANDOMIZER}).uuid
		end

	name: STRING
			-- `name' of Current {EAV_META_DATA} item.
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

	set_uuid (a_uuid: like uuid)
			-- `set_uuid' with `a_uuid'
		do
			uuid := a_uuid
		ensure
			set: uuid ~ a_uuid
		end

	set_uuid_with_string (a_uuid_string: STRING)
			-- `set_uuid_with_string' `a_uuid_string'.
		do
			create uuid.make_from_string (a_uuid_string)
		ensure
			uuid_set: uuid.out.same_string (a_uuid_string)
		end

end
