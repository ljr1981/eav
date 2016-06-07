note
	description: "[
		Representation of a {MOCK_OBJECT}.
		]"

class
	MOCK_OBJECT

inherit
	EAV_DB_ENABLED

feature {TEST_SET_BRIDGE} -- Access

	first_name_dbe,
	first_name: STRING
			-- `first_name', which is database enabled.
		attribute create Result.make_empty end

	last_name_dbe,
	last_name: STRING
			-- `last_name', which is database enabled.
		attribute create Result.make_empty end

	age_dbe,
	age: INTEGER

feature -- Setters

	set_first_name (a_first_name: like first_name)
			-- `set_first_name' with `a_first_name'
		do
			first_name := a_first_name
		ensure
			set: first_name ~ a_first_name
		end

	set_last_name (a_last_name: like last_name)
			-- `set_last_name' with `a_last_name'
		do
			last_name := a_last_name
		ensure
			set: last_name ~ a_last_name
		end

	set_age (a_age: like age)
			-- `set_age' with `a_age'
		do
			age := a_age
		ensure
			set: age ~ a_age
		end

feature {TEST_SET_BRIDGE, EAV_DB_ENABLED} -- Implementation

	entity_name: STRING = "mock_object"
			-- <Precursor>

end
