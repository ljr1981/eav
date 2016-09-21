class
	EAV_DB_RELATION

inherit
	EAV_DB_ENABLED

create
	make

feature {NONE} -- Initialization

	make (a_parent_id, a_child_id: INTEGER)
			--
		do
			parent_id_dbe := a_parent_id
			child_id_dbe := a_child_id
		end

	make_with_reasonable_defaults
			-- <Precursor>
		require else
			do_not_call: False
		do
			do_nothing
		ensure then
			do_not_call: False
		end

feature -- Access

	parent_id_dbe: INTEGER

	child_id_dbe: INTEGER

invariant
	parent_not_child: parent_id_dbe /= child_id_dbe

end
