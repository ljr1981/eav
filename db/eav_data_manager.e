note
	description: "[
		Representation of an effected {EAV_DATA_MANAGER}.
		]"

class
	EAV_DATA_MANAGER

inherit
	EAV_CONSTANTS

feature -- Basic Operations

	fetch_objects_by_ids (a_objects: ARRAY [TUPLE [object: EAV_DB_ENABLED; id: INTEGER_64]])
			-- `fetch_objects_by_ids' in `a_objects', filling in each `object' with data from `id'.
			-- Each `object' passed will be updated with its data. Objects not updated will still
			-- be {EAV_DB_ENABLED}.is_new = True and {EAV_DB_ENABLED}.is_defaulted = True.
		require
			has_object: a_objects.count > 0
		local
			l_ent_id: INTEGER_64
		do
			l_ent_id := entity_id (a_objects [1].object)
			across
				a_objects as ic_objects
			loop
				fetch_by_id (ic_objects.item.object, ic_objects.item.id, l_ent_id)
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
				fetch_by_id (l_object, ic_ids.item, entity_id (l_object))
				Result.force (l_object)
			end
		end

	fetch_by_id (a_object: EAV_DB_ENABLED; a_id, a_ent_id: INTEGER_64)
			-- `fetch_by_id' of `a_id' into `a_object'.
		require
			is_new_default: a_object.is_new and not a_object.is_defaulted
		do
				-- Walk each `a_object' attribute and fetch the data for `a_id'.
			across
				a_object.dbe_enabled_setter_features (a_object) as ic_setters
			loop
				database.fetch_by_instance_id (a_ent_id, ic_setters.item, a_id)
			end
		end

	entity_id (a_object: EAV_DB_ENABLED): INTEGER_64
			-- `entity_id' for `a_object'.
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_sql: STRING
			l_cursor: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			if attached {INTEGER_64} previously_fetched_entity_ids.has (a_object.computed_entity_name.hash_code) as al_entity_id then
				Result := al_entity_id
			else
				l_sql := SELECT_kw.twin
				l_sql.append_string_general (entity_ent_id_field_name)
				l_sql.append_string_general (FROM_kw)
				l_sql.append_string_general (entity_table_name)
				l_sql.append_string_general (WHERE_kw)
				l_sql.append_string_general (entity_ent_name_field_name)
				l_sql.append_string_general (equals)
				l_sql.append_character (open_single_quote)
				l_sql.append_string_general (a_object.computed_entity_name)
				l_sql.append_character (close_single_quote)
				l_sql.append_character (semi_colon)

				create l_query.make (l_sql, database.database)
				l_cursor := l_query.execute_new
				l_cursor.start
				check has_result: not l_cursor.after end
				check attached {INTEGER_64} l_cursor.item.value (ent_id_column_number) as al_result then
					Result := al_result
					previously_fetched_entity_ids.force (Result, a_object.computed_entity_name.hash_code)
				end
			end
		end

	previously_fetched_entity_ids: HASH_TABLE [INTEGER_64, INTEGER]
			-- `previously_fetched_entity_ids'.
		attribute
			create Result.make (100)
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
