note
	description: "[
		Abstraction notion of a {EAV_DB_ENABLED}.
	]"
	todo: "[
		(1) When fetching data back and deserializing it from the DB -> Object,
			what is needed and wanted is:
			
			(a) The setters must already be in place--that is--each *_dbe must have
				a corresponding setter, unless the *_dbe is a computed feature.
			(b) The setters must be in an agent hash just like the getter features.
	]"

deferred class
	EAV_DB_ENABLED

inherit
	EAV_CONSTANTS

feature {NONE} -- Initialization

	make_with_reasonable_defaults
			-- `make_with_reasonable_defaults'.
		deferred
		end

feature -- Queries

	is_new: BOOLEAN
			-- `is_new'?
		do
			Result := object_id = {EAV_DATABASE}.new_object_id_constant
		end

	is_defaulted: BOOLEAN
			-- `is_defaulted'?
			-- True when awaiting: A) Data load from DB or B) Cleansed for caching.

	has_database: BOOLEAN
			--
		do
			Result := attached database
		end

feature -- Storage

	save_in_database,
	store_in_database (a_object: EAV_DB_ENABLED; a_database: attached like database)
			-- `store_in_database' `a_object' into `a_database'.
		do
			a_database.store_object (a_object)
		end

feature -- Access

	entity_id: INTEGER_64
			-- `entity_id' of Current {EAV_DB_ENABLED} object.

feature {EAV_DB_ENABLED, EAV_DATABASE, EAV_DATA_MANAGER} -- Implementation: Storable

	entity_name: STRING
			-- `entity_name' from either `entity_name' (if not empty) or
			--	{ANY}.generating_type as a reasonable default.
		once ("object")
			create Result.make_empty
			Result.append_string_general (generating_type)
		end

	object_id: INTEGER_64
			-- `object_id' of Current {EAV_DB_ENABLED} object.

feature -- Setters

	set_database (a_database: EAV_DATABASE)
		do
			database := a_database
		ensure
			set: database ~ a_database
		end

feature {EAV_DB_ENABLED, TEST_SET_BRIDGE, EAV_DATABASE} -- Implementation: Setters

	set_object_id (a_object_id: like object_id)
			-- `set_object_id' with `a_object_id'
		do
			object_id := a_object_id
		ensure
			set: object_id ~ a_object_id
		end

	set_entity_id (a_entity_id: like entity_id)
			-- `set_entity_id' with `a_entity_id'
		do
			entity_id := a_entity_id
		ensure
			set: entity_id ~ a_entity_id
		end

	set_field (a_object: ANY; a_field_name: STRING; a_data: detachable ANY)
			-- Using `dbe_enabled_setter_features', find `a_field_name' and
			-- call the reflection-setter agent for it with `a_data'.
		note
			testing: "[
				(1) When testing types which are not reflected in the attachment conditions
					below, you will want to access the Eiffel Studio main menu:
					Exectution --> Exception handling ... --> Ensure both "Disable catcall ..."
					are checked to disable catcall detection (for the time being).
			]"
		require
			has_database: has_database
		do
			across
				dbe_enabled_setter_features (a_object) as ic_setters
			loop
				if ic_setters.item.setter_name.same_string (a_field_name) then
					if attached {INTEGER} a_data as al_data then
						ic_setters.item.setter_agent.call ([al_data])
					elseif attached {INTEGER_8} a_data as al_data then
						ic_setters.item.setter_agent.call ([al_data])
					elseif attached {INTEGER_16} a_data as al_data then
						ic_setters.item.setter_agent.call ([al_data])
					elseif attached {INTEGER_32} a_data as al_data then
						ic_setters.item.setter_agent.call ([al_data])
					elseif attached {INTEGER_64} a_data as al_data then
							-- We may have put an {INTEGER_32} into the database, but we might
							-- get an {INTEGER_64} back. Even so, the feature is still {INTEGER_32}
							-- and its setter argument open operands will bear this out. So, we test
							-- the valid_arguments precondition ourselves. If True, then we do have
							-- a valid {INTEGER_64} argument to pass. Otherwise, we convert down to
							-- {INTEGER_32}. We may have to dig further to {INTEGER_16} and {INTEGER_8}
						if ic_setters.item.setter_agent.valid_arguments ([al_data]) then
							ic_setters.item.setter_agent.call ([al_data])
						elseif ic_setters.item.setter_agent.valid_arguments ([al_data.to_integer_32]) then
							ic_setters.item.setter_agent.call ([al_data.to_integer_32])
						elseif ic_setters.item.setter_agent.valid_arguments ([al_data.to_integer_16]) then
							ic_setters.item.setter_agent.call ([al_data.to_integer_16])
						elseif ic_setters.item.setter_agent.valid_arguments ([al_data.to_integer_8]) then
							ic_setters.item.setter_agent.call ([al_data.to_integer_8])
						else
							-- We now have potential reference object
							if al_data > 0 then
								check has_reference:
									attached database as al_database and then
										attached al_database.fetch_with_object_id (al_data) as al_reference
								then
									ic_setters.item.setter_agent.call ([al_reference])
								end
							else
								ic_setters.item.setter_agent.call ([Void])
							end
						end
					elseif attached {REAL} a_data as al_data then
						ic_setters.item.setter_agent.call ([al_data])
					elseif attached {REAL_32} a_data as al_data then
						ic_setters.item.setter_agent.call ([al_data])
					elseif attached {REAL_64} a_data as al_data then
						ic_setters.item.setter_agent.call ([al_data])
					elseif attached {CHARACTER} a_data as al_data then
						ic_setters.item.setter_agent.call ([al_data])
					elseif attached {CHARACTER_8} a_data as al_data then
						ic_setters.item.setter_agent.call ([al_data])
					elseif attached {CHARACTER_32} a_data as al_data then
						ic_setters.item.setter_agent.call ([al_data])
					else
						ic_setters.item.setter_agent.call ([a_data])
					end
				end
			end
		end

feature {TEST_SET_BRIDGE, EAV_DATABASE} -- Implementation: DB Feature Lists

	feature_data (a_object: ANY): ARRAYED_LIST [TUPLE [attr_name: STRING; attr_value: detachable ANY]]
			-- `feature_data' of `a_object' as a list of `attr_name' and `attr_value'.
		do
			create Result.make (50)
			across
				dbe_enabled_features (a_object) as ic_features
			loop
				ic_features.item.feature_agent.call ([Void])
				Result.force (ic_features.item.feature_name, ic_features.item.feature_agent.last_result)
			end
		end

feature {TEST_SET_BRIDGE, EAV_DATA_MANAGER} -- Implementation: DB Feature Lists

	dbe_enabled_features (a_object: ANY): HASH_TABLE [TUPLE [feature_agent: FUNCTION [detachable ANY]; feature_name: STRING; value_type_code: INTEGER], STRING]
			-- A "hash" of *_dbe (database enabled) fields, recognizable by feature name suffix.
		once ("object")
			Result := db_features (a_object, db_enabled_feature_suffix)
		end

	dbe_enabled_setter_features (a_object: ANY): HASH_TABLE [TUPLE [setter_agent: PROCEDURE [detachable ANY]; setter_name: STRING; setter_type_code: INTEGER], STRING]
			-- A "hash" of *_dbe "setters" (e.g. with setter prefix on same feature name).
			-- For the purpose of "setting-from-the-DB-source", there is no reason to utilize
			--	any hand-coded setters. We have setter features on the INTERNAL reflector that
			-- 	we can utilize as-needed. You still need setters for other clients, but not for
			-- 	the purposes of DB-sourced settings.
		note
			design: "[
				The design is fairly simple:
				
				(1) Iterate over the features of `a_object' ...
				(2) For each one that has a `db_enabled_feature_suffix' ...
				(3) Determine the "type" by testing reflector field-type = reflector type-constant ...
				(4) If they are equal, then create a "set_*" agent with an open-argument for the data to later be "set"
				
				All of the basic types are covered by direct if/else-if constructs, otherwise the else handles all
				reference types (like {STRING}s and other non-basic types).
			]"
		local
			l_count,
			l_index: INTEGER
			l_getters: HASH_TABLE [TUPLE [feature_agent: FUNCTION [detachable ANY]; feature_name: STRING_8; value_type_code: INTEGER_32], STRING_8]
			l_reflector_field,
			l_getter_field: STRING
		once ("object")
			create Result.make (50)
			l_getters := dbe_enabled_features (a_object)
			across
				dbe_enabled_features (a_object) as ic_getters
			loop
				l_count := reflector.field_count (a_object)
				across
					1 |..| reflector.field_count (a_object) as ic_counter
				loop
					l_index := ic_counter.item
					l_reflector_field := reflector.field_name (ic_counter.item, a_object)
					l_getter_field := ic_getters.item.feature_name
					if
						attached {STRING} reflector.field_name (ic_counter.item, a_object) as al_name and then
							al_name.tail (db_enabled_feature_suffix.count).same_string (db_enabled_feature_suffix) and then
							al_name.has_substring (ic_getters.item.feature_name)
					then
							-- BOOLEAN
						if reflector.field_type (ic_counter.item, a_object) = reflector.Boolean_type then
							Result.force ([agent reflector.set_boolean_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)

							-- CHARACTER_*
						elseif reflector.field_type (ic_counter.item, a_object) = reflector.character_8_type then
							Result.force ([agent reflector.set_character_8_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)
						elseif reflector.field_type (ic_counter.item, a_object) = reflector.character_32_type then
							Result.force ([agent reflector.set_character_32_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)
						elseif reflector.field_type (ic_counter.item, a_object) = reflector.character_type then
							Result.force ([agent reflector.set_character_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)

							-- INTEGER_*
						elseif reflector.field_type (ic_counter.item, a_object) = reflector.integer_8_type then
							Result.force ([agent reflector.set_integer_8_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)
						elseif reflector.field_type (ic_counter.item, a_object) = reflector.integer_16_type then
							Result.force ([agent reflector.set_integer_16_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)
						elseif reflector.field_type (ic_counter.item, a_object) = reflector.integer_32_type then
							Result.force ([agent reflector.set_integer_32_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)
						elseif reflector.field_type (ic_counter.item, a_object) = reflector.integer_64_type then
							Result.force ([agent reflector.set_integer_64_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)
						elseif reflector.field_type (ic_counter.item, a_object) = reflector.integer_type then
							Result.force ([agent reflector.set_integer_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)

							-- NATURAL_*
						elseif reflector.field_type (ic_counter.item, a_object) = reflector.natural_8_type then
							Result.force ([agent reflector.set_natural_8_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)
						elseif reflector.field_type (ic_counter.item, a_object) = reflector.natural_16_type then
							Result.force ([agent reflector.set_natural_16_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)
						elseif reflector.field_type (ic_counter.item, a_object) = reflector.natural_32_type then
							Result.force ([agent reflector.set_natural_32_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)
						elseif reflector.field_type (ic_counter.item, a_object) = reflector.natural_64_type then
							Result.force ([agent reflector.set_natural_64_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)

							-- REAL_*
						elseif reflector.field_type (ic_counter.item, a_object) = reflector.real_32_type then
							Result.force ([agent reflector.set_real_32_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)
						elseif reflector.field_type (ic_counter.item, a_object) = reflector.real_64_type then
							Result.force ([agent reflector.set_real_64_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)
						elseif reflector.field_type (ic_counter.item, a_object) = reflector.real_type then
							Result.force ([agent reflector.set_real_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)

							-- Reference types (like STRINGs and other things)
						else
							Result.force ([agent reflector.set_reference_field (ic_counter.item, a_object, ?), remove_suffixes (al_name), ic_getters.item.value_type_code], al_name)
						end
					end
				end
			end
		end

	pk_primary_key_features (a_object: ANY): HASH_TABLE [TUPLE [feature_agent: FUNCTION [detachable ANY]; feature_name: STRING], STRING]
			-- A "hash" of *_pk (database enabled) fields, recognizable by feature name suffix.
		once ("object")
			Result := db_features (a_object, db_primary_key_suffix)
		end

	ck_candidate_key_features (a_object: ANY): HASH_TABLE [TUPLE [feature_agent: FUNCTION [detachable ANY]; feature_name: STRING], STRING]
			-- A "hash" of *_pk (database enabled) fields, recognizable by feature name suffix.
		once ("object")
			Result := db_features (a_object, db_candidate_key_suffix)
		end

feature {NONE} -- Implementation: Feature lists

	db_features (a_object: ANY; a_suffix: STRING): HASH_TABLE [TUPLE [feature_agent: FUNCTION [detachable ANY]; feature_name: STRING; value_type_code: INTEGER], STRING]
			-- `db_features' of `a_object' for `a_suffix' in the feature name.
		local
			l_field: detachable ANY
			l_type_value: INTEGER
		do
			create Result.make (50)
			across
				1 |..| reflector.field_count (a_object) as ic_counter
			loop
				if
					attached {STRING} reflector.field_name (ic_counter.item, a_object) as al_name
						and then al_name.tail (a_suffix.count).same_string (a_suffix)
				then
					l_field := reflector.field (ic_counter.item, a_object)
					if attached {BOOLEAN} l_field then
						l_type_value := BOOLEAN_value_type_code
					elseif attached {INTEGER} l_field then
						l_type_value := INTEGER_value_type_code
					elseif attached {NUMERIC} l_field then
						l_type_value := REAL_value_type_code
					elseif attached {STRING} l_field then
						l_type_value := TEXT_value_type_code
					elseif attached {CHARACTER} l_field then
						l_type_value := TEXT_value_type_code
					elseif not attached {ANY} l_field then
						l_type_value := REFERENCE_value_type_code
					elseif attached {EAV_DB_ENABLED} l_field then
						l_type_value := REFERENCE_value_type_code
					else
						check unknown_type_in_EAV_DB_ENABLED_db_features: False end
					end
					Result.force ([db_feature_agent (ic_counter.item, a_object), remove_suffixes (al_name), l_type_value], al_name)
				end
			end
		ensure
			no_more_than: reflector.field_count (a_object) >= Result.count
		end

feature {NONE} -- Implementation: Feature Name Management

	remove_suffixes (a_name: STRING): STRING
			-- `remove_suffixes' from `a_name'.
			-- Removes `db_enabled_feature_suffix', `db_primary_key_suffix', and `db_candidate_key_suffix'.
		do
			Result := a_name.twin
			Result.replace_substring_all (db_enabled_feature_suffix, "")
			Result.replace_substring_all (db_primary_key_suffix, "")
			Result.replace_substring_all (db_candidate_key_suffix, "")
		ensure
			not_has: not Result.has_substring (db_enabled_feature_suffix) and not Result.has_substring (db_primary_key_suffix) and not Result.has_substring (db_candidate_key_suffix)
			still_has: a_name.has_substring (Result)
		end

feature {NONE} -- Implementation: Database & Ops

	database: detachable EAV_DATABASE
			-- `database' to which Current belongs.

	store (a_object: EAV_DB_ENABLED)
			-- `store_object' `a_object' into `database'.
		do
			check
				has_database: attached database as al_database
			then
				store_in_database (a_object, al_database)
			end
		end

feature {NONE} -- Implementation: INTERNAL

	reflector: INTERNAL
			-- `reflector' for reflection of Current.
		once
			create Result
		end

	db_enabled_feature_suffix: STRING = "_dbe"
			-- `db_enabled_feature_suffix' found on feature names.

	db_primary_key_suffix: STRING = "_pk"
			-- `db_primary_key_suffix' found on feature names.

	db_candidate_key_suffix: STRING = "_ck"
			-- `db_candidate_key_suffix' found on feature names.

	db_feature_agent (a_field_number: INTEGER; a_object: ANY): attached like feature_agent_anchor
			-- `db_feature_agent' for `a_field_number' in `a_object'.
		do
			Result := agent reflector.field(a_field_number, a_object)
		end

	feature_agent_anchor: detachable FUNCTION [detachable ANY]
			-- `feature_agent_anchor' as type anchor.

;

note
	design_intent: "[
		An object that is "db-able" simply means the object has fields that need to be
		stored and retrieved from a data repository (e.g. database like SQLite3/PostGreSQL/etc).
		
		The intent here is to provide a stable feature name suffix, which is used as a signal
		to the code of this class, indicating each feature needing to be stored and retrieved
		from the database.
		
		Further intent is that objects needing data storage simply inherit from this class (or
		one of its descendents) and then provide features with the appropriate feature name
		suffixes. This can be direct fields, or it may also be aliased field names, such as:
		
		my_field_dbe,
		my_field: STRING
		
		In the case (above), the STRING-object stored has two feature pointers, where one is
		suffixed with *_dbe, which indicates to the code of this class that the designer intends
		for the STRING-object to be store/retrieved from the data repository.
	]"

end
