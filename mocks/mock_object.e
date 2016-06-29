note
	description: "[
		Representation of a {MOCK_OBJECT}.
		]"

class
	MOCK_OBJECT

inherit
	EAV_DB_ENABLED

create
	make_with_reasonable_defaults

feature {NONE} -- Initialization

	make_with_reasonable_defaults
			-- <Precursor>
		do
			create first_name_dbe.make_empty
			create last_name_dbe.make_empty
		end

feature -- Access

	first_name_dbe: STRING
			-- `first_name_dbe', which is database enabled (dbe).

	last_name_dbe: STRING
			-- `last_name_dbe', which is database enabled (dbe).

	age_dbe: INTEGER
			-- `age_dbe', which is database enabled (dbe).

feature {TEST_SET_BRIDGE} -- Keys

	first_last_dbe_pk: STRING
			-- `first_last_pk'
		do
			Result := first_name_dbe + last_name_dbe
		end

feature -- Setters

	set_first_name_dbe (a_first_name: like first_name_dbe)
			-- `set_first_name_dbe' with `a_first_name'
		do
			first_name_dbe := a_first_name
		ensure
			set: first_name_dbe ~ a_first_name
		end

	set_last_name_dbe (a_last_name: like last_name_dbe)
			-- `set_last_name_dbe' with `a_last_name'
		do
			last_name_dbe := a_last_name
		ensure
			set: last_name_dbe ~ a_last_name
		end

	set_age_dbe (a_age: like age_dbe)
			-- `set_age_dbe' with `a_age'
		do
			age_dbe := a_age
		ensure
			set: age_dbe ~ a_age
		end

end
