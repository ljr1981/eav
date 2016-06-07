note
	description: "[
		Representation of an effected {EAV_SYSTEM}.
	]"

class
	EAV_SYSTEM

inherit
	EAV_META_DATA
		rename
			parent as parent_system,
			parent_id as parent_system_id,
			set_parent as set_parent_system,
			set_parent_id as set_parent_system_id,
			attached_parent as attached_parent_system
		end

note
	design_intent: "[
		EAV_data_model ::=
			{Meta_data}+			<-- Tables that describe (S)ystems + (E)ntities + (A)ttributes (SEA-key)
			{Value}+				<-- Tables having the Values of the SEA-keys above.
		
		Meta_data ::=				<-- That is--SEA-keys
			(S)ystem				<-- One EAV may service 1:M "(S)ystems".
			(E)ntity				<-- Each EAV System may have 1:M (E)ntities (Models).
			(A)ttribute				<-- Each EAV Model may have 1:M (A)ttributes (e.g. fields).
		
		(S)ystem ::=
			System_id				<-- INTEGER Primary Key
			Id_parent				<-- INTEGER Foreign Key to a possible super-system (e.g. detachable or Void)
			Uuid					<-- UUID of System
			Name					<-- Possibly non-unique System name (hence the UUID)
			Is_deleted				<-- Deletion mark
			Modified_date			<-- Date-time stamp of create/update/delete
			Modifier_id				<-- Value.Instance_id of last-Modifying entity (person or machine)

		]"

end
