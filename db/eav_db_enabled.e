note
	description: "[
		Abstraction notion of a {EAV_DB_ENABLED}.
		]"

deferred class
	EAV_DB_ENABLED

feature {TEST_SET_BRIDGE} -- Implementation: Storable

	store_in_database (a_object: ANY; a_database: attached like database)
		do
			a_database.store (entity_name, feature_data (a_object).to_array)
		end

feature {NONE} -- Implementation: Storable

	entity_name: STRING
		deferred
		end

	database: detachable EAV_DATABASE
			-- `database' to which Current belongs.

	store (a_object: ANY)
			-- `store' `a_object' into `database'.
		do
			check has_database: attached database as al_database then
				store_in_database (a_object, al_database)
			end
		end

feature {TEST_SET_BRIDGE} -- Implementation: INTERNAL

	feature_data (a_object: ANY): ARRAYED_LIST [TUPLE [attr_name: STRING; attr_value: detachable ANY]]
			-- `feature_data' of `a_object' as a list of `attr_name' and `attr_value'.
		local
			l_value: detachable ANY
			l_feature: FUNCTION [detachable ANY]
		do
			create Result.make (50)
			across
				db_enabled_features (a_object) as ic_features
			loop
				l_feature := ic_features.item.feature_agent
				l_feature.call ([Void])
				l_value := l_feature.last_result
				check attached {FUNCTION [detachable ANY]} l_value as al_value then
					al_value.call ([Void])
					Result.force (ic_features.item.feature_name, al_value.last_result)
				end

			end
		end

	db_enabled_features (a_object: ANY): HASH_TABLE [TUPLE [feature_agent: FUNCTION [detachable ANY]; feature_name: STRING], STRING]
			-- A "hash" of *_dbe (database enabled) fields, recognizable by feature name suffix.
		once
			Result := db_features (a_object, db_enabled_feature_suffix)
		end

	db_primary_key_features (a_object: ANY): HASH_TABLE [TUPLE [feature_agent: FUNCTION [detachable ANY]; feature_name: STRING], STRING]
			-- A "hash" of *_pk (database enabled) fields, recognizable by feature name suffix.
		once
			Result := db_features (a_object, db_primary_key_suffix)
		end

	db_candidate_key_features (a_object: ANY): HASH_TABLE [TUPLE [feature_agent: FUNCTION [detachable ANY]; feature_name: STRING], STRING]
			-- A "hash" of *_pk (database enabled) fields, recognizable by feature name suffix.
		once
			Result := db_features (a_object, db_candidate_key_suffix)
		end

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
					Result.force ([agent db_feature_agent (ic_counter.item, a_object), remove_suffixes (al_name)], al_name)
				end
			end
		end

	remove_suffixes (a_name: STRING): STRING
			-- `remove_suffixes' from `a_name'.
			-- Removes `db_enabled_feature_suffix', `db_primary_key_suffix', and `db_candidate_key_suffix'.
		do
			Result := a_name.twin
			Result.replace_substring_all (db_enabled_feature_suffix, "")
			Result.replace_substring_all (db_primary_key_suffix, "")
			Result.replace_substring_all (db_candidate_key_suffix, "")
		end

feature {NONE} -- Implementation: INTERNAL

	reflector: INTERNAL once create Result end
			-- `reflector' for reflection of Current.

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
