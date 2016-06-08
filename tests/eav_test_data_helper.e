note
	description: "[
		Abstract notion of an {EAV_TEST_DATA_HELPER}
		]"
	design: "Has features to help with managing test data."

deferred class
	EAV_TEST_DATA_HELPER

feature {NONE} -- Implementation

	on_clean
			-- <Precursor>
		do
			remove_data
		end

	remove_data
			-- `remove_data' from directory path.
		local
			l_path: PATH
			l_dir: DIRECTORY
		do
			create l_path.make_from_string ((create {EXECUTION_ENVIRONMENT}).current_working_path.name.out + test_data_path)
			create l_dir.make_with_path (l_path)
			l_dir.do_nothing
			l_dir.delete_content
		end

feature {NONE} -- Implementation: Constants

	test_data_path: STRING = "\tests\data\"

end
