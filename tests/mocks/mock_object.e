note
	description: "[
		Representation of a {MOCK_OBJECT}.
		]"

class
	MOCK_OBJECT

inherit
	EAV_DB_ENABLED

feature {TEST_SET_BRIDGE} -- Access

	first_name_dbe: STRING
			-- `first_name_dbe', which is database enabled (dbe).
		attribute create Result.make_empty end

	last_name_dbe: STRING
			-- `last_name_dbe', which is database enabled (dbe).
		attribute create Result.make_empty end

	age_dbe: INTEGER
			-- `age_dbe', which is database enabled (dbe).

feature {TEST_SET_BRIDGE} -- Keys

	first_last_dbe_pk: STRING
			-- `first_last_pk'
		do
			Result := first_name_dbe + last_name_dbe
		end

feature -- Setters

	set_first_name (a_first_name: like first_name_dbe)
			-- `set_first_name' with `a_first_name'
		do
			first_name_dbe := a_first_name
		ensure
			set: first_name_dbe ~ a_first_name
		end

	set_last_name (a_last_name: like last_name_dbe)
			-- `set_last_name' with `a_last_name'
		do
			last_name_dbe := a_last_name
		ensure
			set: last_name_dbe ~ a_last_name
		end

	set_age (a_age: like age_dbe)
			-- `set_age' with `a_age'
		do
			age_dbe := a_age
		ensure
			set: age_dbe ~ a_age
		end

feature {TEST_SET_BRIDGE, EAV_DB_ENABLED} -- Implementation

	entity_name: STRING = "mock_object"
			-- <Precursor>

end
