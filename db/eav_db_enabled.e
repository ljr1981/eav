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

feature {NONE} -- Initialization

	make_with_reasonable_defaults
			-- `make_with_reasonable_defaults'.
		deferred
		end

feature {TEST_SET_BRIDGE} -- Implementation: Storable

	store_in_database (a_object: EAV_DB_ENABLED; a_database: attached like database)
			-- `store_in_database' `a_object' into `a_database'.
		do
			a_database.store (a_object)
		end

feature {EAV_DATABASE} -- Implementation: Storable

	entity_name: STRING
			-- `entity_name' for or from Metadata storage.
		deferred
		end

	instance_id: INTEGER_64
			-- `instance_id' of Current {EAV_DB_ENABLED} object.

	set_instance_id (a_instance_id: like instance_id)
			-- `set_instance_id' with `a_instance_id'
		do
			instance_id := a_instance_id
		ensure
			set: instance_id ~ a_instance_id
		end

	is_new: BOOLEAN
			-- `is_new'?
		do
			Result := instance_id = {EAV_DATABASE}.new_instance_id_constant
		end

feature {TEST_SET_BRIDGE, EAV_DATABASE} -- Implementation: INTERNAL

	feature_data (a_object: ANY): ARRAYED_LIST [TUPLE [attr_name: STRING; attr_value: detachable ANY]]
			-- `feature_data' of `a_object' as a list of `attr_name' and `attr_value'.
		do
			create Result.make (50)
			across
				db_enabled_features (a_object) as ic_features
			loop
				ic_features.item.feature_agent.call ([Void])
				Result.force (ic_features.item.feature_name, ic_features.item.feature_agent.last_result)
			end
		end

feature {TEST_SET_BRIDGE} -- Implementation: DB Feature Lists

	db_enabled_features (a_object: ANY): HASH_TABLE [TUPLE [feature_agent: FUNCTION [detachable ANY]; feature_name: STRING], STRING]
			-- A "hash" of *_dbe (database enabled) fields, recognizable by feature name suffix.
		once ("object")
			Result := db_features (a_object, db_enabled_feature_suffix)
		end

	db_primary_key_features (a_object: ANY): HASH_TABLE [TUPLE [feature_agent: FUNCTION [detachable ANY]; feature_name: STRING], STRING]
			-- A "hash" of *_pk (database enabled) fields, recognizable by feature name suffix.
		once ("object")
			Result := db_features (a_object, db_primary_key_suffix)
		end

	db_candidate_key_features (a_object: ANY): HASH_TABLE [TUPLE [feature_agent: FUNCTION [detachable ANY]; feature_name: STRING], STRING]
			-- A "hash" of *_pk (database enabled) fields, recognizable by feature name suffix.
		once ("object")
			Result := db_features (a_object, db_candidate_key_suffix)
		end

feature {NONE} -- Implementation: Feature lists

	db_features (a_object: ANY; a_suffix: STRING): HASH_TABLE [TUPLE [feature_agent: FUNCTION [detachable ANY]; feature_name: STRING], STRING]
			-- `db_features' of `a_object' for `a_suffix' in the feature name.
		do
			create Result.make (50)
			across
				1 |..| reflector.field_count (a_object) as ic_counter
			loop
				if
					attached {STRING} reflector.field_name (ic_counter.item, a_object) as al_name and then
					al_name.has_substring (a_suffix)
				then
					Result.force ([db_feature_agent (ic_counter.item, a_object), remove_suffixes (al_name)], al_name)
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
			not_has: not Result.has_substring (db_enabled_feature_suffix) and
						not Result.has_substring (db_primary_key_suffix) and
						not Result.has_substring (db_candidate_key_suffix)
			still_has: a_name.has_substring (Result)
		end

feature {NONE} -- Implementation: Database & Ops

	database: detachable EAV_DATABASE
			-- `database' to which Current belongs.

	store (a_object: EAV_DB_ENABLED)
			-- `store' `a_object' into `database'.
		do
			check has_database: attached database as al_database then
				store_in_database (a_object, al_database)
			end
		end

feature {NONE} -- Implementation: INTERNAL

	reflector: INTERNAL
			-- `reflector' for reflection of Current.
		once create Result end

	db_enabled_feature_suffix: STRING = "_dbe"
			-- `db_enabled_feature_suffix' found on feature names.

	db_primary_key_suffix: STRING = "_pk"
			-- `db_primary_key_suffix' found on feature names.

	db_candidate_key_suffix: STRING = "_ck"
			-- `db_candidate_key_suffix' found on feature names.

	db_feature_agent (a_field_number: INTEGER; a_object: ANY): attached like feature_agent_anchor
			-- `db_feature_agent' for `a_field_number' in `a_object'.
		do
			Result := agent reflector.field (a_field_number, a_object)
		end

	feature_agent_anchor: detachable FUNCTION [detachable ANY]
			-- `feature_agent_anchor' as type anchor.

;note
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
