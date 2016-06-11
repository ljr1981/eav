note
	description: "[
		Abstract notion of an {EAV_COMMON}.
		]"

deferred class
	EAV_COMMON

inherit
	EAV_ANY

feature {EAV_DATA_MANAGER} -- Implementation

	parent_id,
	id: INTEGER_64
			-- Required `id' (or parent) of Current {EAV_COMMON}.
			-- `parent_id' is zero if detached `parent'.

	parent: detachable EAV_COMMON
			-- Optional (detachable) `parent' of Current {EAV_COMMON}.

	attached_parent: attached like parent
			-- Non-optional `parent'.
		require
			parent_id_set: parent_id > 0
		do
			check has_parent_but_void: attached parent as al_parent then Result := al_parent end
		end

	is_deleted: BOOLEAN
			-- `is_deleted'?

	modified_date: DATE_TIME
			-- `modified_date' and time.
		attribute
			create Result.make_now
		end

	modifier_id: INTEGER_64
			-- `modifier_id' of the modifying Entity instance.

feature -- Setters

	set_id (a_id: like id)
			-- `set_id' with `a_id'
		do
			id := a_id
		ensure
			set: id ~ a_id
		end

	set_parent_id (a_parent_id: like parent_id)
			-- `set_parent_id' with `a_parent_id'
		do
			parent_id := a_parent_id
		ensure
			set: parent_id ~ a_parent_id
		end

	set_parent (a_parent: like parent)
			-- `set_parent' with `a_parent'
		do
			parent := a_parent
		ensure
			set: parent ~ a_parent
		end

	set_is_deleted (a_is_deleted: like is_deleted)
			-- `set_is_deleted' with `a_is_deleted'
		do
			is_deleted := a_is_deleted
		ensure
			set: is_deleted ~ a_is_deleted
		end

	set_modified_date (a_modified_date: like modified_date)
			-- `set_modified_date' with `a_modified_date'
		do
			modified_date := a_modified_date
		ensure
			set: modified_date ~ a_modified_date
		end

	set_modifier_id (a_modifier_id: like modifier_id)
			-- `set_modifier_id' with `a_modifier_id'
		do
			modifier_id := a_modifier_id
		ensure
			set: modifier_id ~ a_modifier_id
		end

invariant
	valid_parent_id: not attached parent implies parent_id = 0
	id_consistency: modifier_id > 0 implies id > 0
	deletion_consistency: is_deleted implies (modifier_id > 0 and id > 0)

end
