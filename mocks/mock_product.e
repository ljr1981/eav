note
	description: "Summary description for {MOCK_PRODUCT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOCK_PRODUCT

inherit
	EAV_DB_ENABLED

create
	make_with_reasonable_defaults

feature {NONE} -- Initialization

	make_with_reasonable_defaults
			-- <Precursor>
		do
			create make_dbe.make_empty
			create model_dbe.make_empty
		end

feature -- Access

	make_dbe: STRING
			-- `first_name_dbe', which is database enabled (dbe).

	model_dbe: STRING
			-- `last_name_dbe', which is database enabled (dbe).

	count_dbe: INTEGER
			-- `count_dbe', which is database enabled (dbe).

feature -- Setters

	set_make_dbe (a_make_dbe: like make_dbe)
			-- `set_make_dbe' with `a_make_dbe'
		do
			make_dbe := a_make_dbe
		ensure
			set: make_dbe ~ a_make_dbe
		end

	set_model_dbe (a_model_dbe: like model_dbe)
			-- `set_model_dbe' with `a_model_dbe'
		do
			model_dbe := a_model_dbe
		ensure
			set: model_dbe ~ a_model_dbe
		end

	set_count_dbe (a_count_dbe: like count_dbe)
			-- `set_count_dbe' with `a_count_dbe'
		do
			count_dbe := a_count_dbe
		ensure
			set: count_dbe ~ a_count_dbe
		end

end
