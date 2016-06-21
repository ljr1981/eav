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

create
	make,
	make_with_list,
	make_empty,
	make_empty_with_system_database

feature {NONE} -- Initialization

	make_empty
			-- `make_empty'.
		do
			do_nothing
		end

	make_empty_with_system_database
			-- `make_empty_with_system_database'.
		do
			make ("system", (create {PATH}.make_current).name.out)
		end

	make (a_name, a_location: STRING)
			-- `make' with `a_name'.
		do
			make_with_list (a_name, a_location, <<a_name>>)
		end

	make_with_list (a_name, a_location: STRING; a_databases: ARRAY [STRING])
			-- `make_with_list' of `a_databases'.
		do
			set_name (a_name)
			across
				a_databases as ic_databases
			loop
				databases.force ([a_location, create {EAV_DATABASE}.make (a_location, ic_databases.item)], ic_databases.item)
				check last_added_db: attached databases.at (ic_databases.item) as al_item then build_eav (al_item.db) end
			end
		end

feature -- Queries

	first_database: EAV_DATABASE
			-- `last_database'
		once ("object")
			check has_content: not databases.is_empty end
			databases.start
			Result := databases.item_for_iteration.db
		end

feature -- Basic Operations

	build_eav (a_database: EAV_DATABASE)
			-- `build_eav' into `a_database', if needed.
		do
			a_database.build_eav_structure
		end

	close_all
			-- `close_all' `databases'.
		do
			across
				databases as ic_databases
			loop
				ic_databases.item.db.database.close
			end
		end

feature {NONE} -- Implementation

	databases: HASH_TABLE [TUPLE [location: STRING; db: EAV_DATABASE], STRING]
			-- `databases' based on {EAV_DATABASE} and a name.
		attribute
			create Result.make (10)
		end

;note
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
