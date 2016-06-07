note
	description: "[
		Representation of an effected {EAV_DATABASE}.
		]"

class
	EAV_DATABASE

create
	make

feature {NONE} -- Initialization

	make (a_location, a_file_name: READABLE_STRING_GENERAL)
			-- `make'
		local
			l_path: PATH
			l_env: EXECUTION_ENVIRONMENT
		do
			create l_env
			create l_path.make_from_string (l_env.current_working_path.name + "\" + a_location + "\" + a_file_name + ".sqlite3")
			create database.make_create_read_write (l_path.name)
		end

feature -- Basic Operations

	database: SQLITE_DATABASE
			-- `database'

;note
	design_intent: "[
		Your_text_goes_here
		]"

end
