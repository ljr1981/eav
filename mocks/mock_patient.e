note
	description: "[
		Representation of a {MOCK_PATIENT}.
		]"

class
	MOCK_PATIENT

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
			create gender_dbe.make_empty
			create race_dbe.make_empty
		end

feature -- Access

	first_name_dbe: STRING
			-- `first_name_dbe'.

	last_name_dbe: STRING
			-- `last_name_dbe'.

	gender_dbe: STRING
			-- `gender_dbe'.

	race_dbe: STRING
			-- `race_dbe'.

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

	set_gender_dbe (a_gender: like gender_dbe)
			-- `set_gender_dbe' with `a_gender'
		do
			gender_dbe := a_gender
		ensure
			set: gender_dbe ~ a_gender
		end

	set_race_dbe (a_race: like race_dbe)
			-- `set_race_dbe' with `a_race'
		do
			race_dbe := a_race
		ensure
			set: race_dbe ~ a_race
		end

end
