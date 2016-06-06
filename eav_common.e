note
	description: "[
		Abstract notion of an {EAV_COMMON}.
		]"

deferred class
	EAV_COMMON

inherit
	EAV_ANY

feature -- Access

	parent_id,
	id: INTEGER_64
			-- Required `id' (or parent) of Current {EAV_COMMON}.
			-- `parent_id' is zero if detached `parent'.

	parent: detachable like Current
			-- Optional (detachable) `parent' of Current {EAV_COMMON}.

	is_deleted: BOOLEAN
			-- `is_deleted'?

	modified_date: DATE_TIME
			-- `modified_date' and time.
		attribute
			create Result.make_now
		end

	modifier_id: INTEGER_64
			-- `modifier_id' of the modifying Entity instance.

invariant
	valid_parent_id: not attached parent implies parent_id = 0
	id_consistency: modifier_id > 0 implies id > 0
	deletion_consistency: is_deleted implies (modifier_id > 0 and id > 0)

end
