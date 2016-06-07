note
	description: "[
		Representation of an effected {EAV_ENTITY}.
]"

class
	EAV_ENTITY

inherit
	EAV_META_DATA
		rename
			parent as parent_entity,
			parent_id as parent_entity_id,
			set_parent as set_parent_entity,
			set_parent_id as set_parent_entity_id,
			attached_parent as attached_parent_entity
		end

	EAV_SUB_META_DATA
		rename
			meta_parent as system
		end

feature -- Access

	system: detachable EAV_SYSTEM
			-- <Precursor>
			-- Entity of parent {EAV_SYSTEM}.

;note
	design_intent: "[
		(E)ntity ::=
			Entity_id				<-- INTEGER Primary Key
			System_id				<-- INTEGER Foreign Key to System
			Uuid					<-- UUID of Entity
			Name					<-- Possibly non-unique Entity name (hence the UUID)
			Is_deleted				<-- Deletion mark
			Modified_date			<-- Date-time stamp of create/update/delete
			Modifier_id				<-- Value.Instance_id of last-Modifying entity (person or machine)
		]"

end
