note
	description: "[
		Representation of an effected {EAV_ATTRIBUTE}.
]"

class
	EAV_ATTRIBUTE

inherit
	EAV_META_DATA
		rename
			parent as renamed_attribute,
			parent_id as renamed_attribute_id,
			set_parent as set_renamed_attribute,
			set_parent_id as set_renamed_attribute_id,
			attached_parent as attached_renamed_attribute
		end

	EAV_SUB_META_DATA
		rename
			meta_parent as entity
		end

feature -- Access

	entity: detachable EAV_ENTITY
			-- <Precursor>
			-- Entity of parent {EAV_SYSTEM}.

;note
	design_intent: "[
		(A)ttribute ::=
			Attribute_id			<-- INTEGER Primary Key
			Entity_id				<-- INTEGER Foreign Key to Entity
			Uuid					<-- UUID of Attribute
			Name					<-- Possibly non-unique Attribute name (hence the UUID)
			Is_deleted				<-- Deletion mark
			Modified_date			<-- Date-time stamp of create/update/delete
			Modifier_id				<-- Value.Instance_id of last-Modifying entity (person or machine)
		]"

end
