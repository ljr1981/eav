note
	description: "[
		Representation of an effected {EAV_DATA_MANAGER}.
		]"

class
	EAV_DATA_MANAGER

feature -- Basic Operations

	fetch_objects_by_ids (a_objects: ARRAY [TUPLE [object: EAV_DB_ENABLED; id: INTEGER_64]])
			-- `fetch_objects_by_ids' in `a_objects', filling in each `object' with data from `id'.
			-- Each `object' passed will be updated with its data. Objects not updated will still
			-- be {EAV_DB_ENABLED}.is_new = True and {EAV_DB_ENABLED}.is_defaulted = True.
		do
			across
				a_objects as ic_objects
			loop
				fetch_by_id (ic_objects.item.object, ic_objects.item.id)
			end
		end

	fetch_by_ids (a_object: EAV_DB_ENABLED; a_ids: ARRAY [INTEGER_64]): ARRAYED_LIST [EAV_DB_ENABLED]
			-- `fetch_by_ids' using `a_object' as a "twinning" template, fetching the
			-- data from some data source by the {INTEGER_64} `id' in `a_ids', and
			-- loading each twinned `a_object' into the Result list.
		local
			l_object: EAV_DB_ENABLED
		do
			create Result.make (a_ids.count)
			across
				a_ids as ic_ids
			loop
				l_object := a_object.twin
				fetch_by_id (l_object, ic_ids.item)
				Result.force (l_object)
			end
		end

	fetch_by_id (a_object: EAV_DB_ENABLED; a_id: INTEGER_64)
			-- `fetch_by_id' of `a_id' into `a_object'.
		require
			is_new_default: a_object.is_new and not a_object.is_defaulted
		do
				-- Walk each `a_object' attribute and fetch the data for `a_id'.
			across
				a_object.dbe_enabled_setter_features (a_object) as ic_attributes
			loop
				database.fetch_by_instance_id (entity_id (a_object), ic_attributes.item, a_id)
			end
		end

	entity_id (a_object: EAV_DB_ENABLED): INTEGER_64
			-- ??
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_sql: STRING
			l_cursor: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			l_sql := "SELECT ent_id FROM Entity WHERE ent_name = '" + a_object.computed_entity_name + "';"
			create l_query.make (l_sql, database.database)
			l_cursor := l_query.execute_new
			l_cursor.start
			check has_result: not l_cursor.after end
			check attached {INTEGER_64} l_cursor.item.value (ent_id_column_number) as al_result then Result := al_result end
		end

	ent_id_column_number: NATURAL_32 = 1

feature -- Access

	database: attached like database_type_anchor
			--`database' of Current.
			-- Created empty if no `database' supplied through `set_database'.
		attribute
			create Result.make_empty
		end

feature -- Setters

	set_database (a_database: like database)
			-- `set_database' with `a_database'
		do
			database := a_database
		ensure
			set: database ~ a_database
		end

feature {NONE} -- Implementation: Type Anchors

	database_type_anchor: detachable EAV_DATABASE
			-- `database_type_anchor' for `database' and `set_database'.

;note
	design_intent: "[
		Features that manage DBE things. The "management" duties include
		"haz" attributes about or operations that do:
		
		(1) Do fetch_by_id, ... by_* (* = pk, ck, filter, ad-hoc)
		(2) Do save_item (a_item: DBE), save_items (a_items: ARRAY [DBE])
		(3) "Haz" phoneme
		]"

end
