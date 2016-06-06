note
	description: "[
		Abstract notion of an {EAV_COMMON}.
		]"

deferred class
	EAV_COMMON

inherit
	EAV_ANY

feature -- Access

	parent,
	id: INTEGER_64
			-- `id' (or parent) of Current {EAV_COMMON}.

	is_deleted: BOOLEAN
			-- `is_deleted'?

	modified_date: DATE_TIME
			-- `modified_date' and time.
		attribute
			create Result.make_now
		end

	modifier_id: INTEGER_64
			-- `modifier_id' of the modifying Entity instance.

end
