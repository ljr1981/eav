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
				databases.force ([a_location, create {EAV_DATABASE}.make (a_location, ic_databases.item), ic_databases.item], ic_databases.cursor_index)
				check last_added_db: attached databases.at (ic_databases.cursor_index) as al_item then build_eav (al_item.db) end
			end
		end

feature -- Queries

	database_n (i: INTEGER): EAV_DATABASE
			-- `database_n' on `i'.
		require
			at_least_i: i > 0 and has_count (i)
		do
			check attached databases.at (i) as al_database then
				Result := al_database.db
			end
		end

	has_count (i: INTEGER): BOOLEAN
			-- `has_count' `i'?
		do
			Result := not databases.is_empty and then databases.count >= i
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

	databases: HASH_TABLE [TUPLE [location: STRING; db: EAV_DATABASE; name: STRING], INTEGER]
			-- `databases' based on {EAV_DATABASE} and a name.
		attribute
			create Result.make (10)
		end

end
