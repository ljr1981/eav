note
	description: "[
		EAV Documentation.
		]"

class
	EAV_DOCS

feature {NONE} -- Implementation

	documentation: detachable EAV_DOCS
			-- `documentation' for Current {EAV_DOCS}.
;note
	design: "[
		See EIS link below.
		
		Essentials
		==========
		The entire notion of EAV consists of (A) Entity meta data (B) Attribute value data.
		Essentially, we have the notion of Key:Value pairs, where the keys must be described
		not only as end-of-line keys, but identified by what entity and system they belong to.
		For example: A field (attribute) has a value, but above it, the attribute belongs to
		an entity, which (in turn) belongs to a system. We do not track meta data above the
		notion of system. For that we have the notion of a "Super-system", which is a heirarchal
		system-of-systems.
		
		EAV_data_model ::=
			{Meta_data}+			<-- Tables that describe (S)ystems + (E)ntities + (A)ttributes (SEA-key)
			{Value}+				<-- Tables having the Values of the SEA-keys above.
		
		Meta_data ::=				<-- That is--SEA-keys
			(S)ystem				<-- One EAV may service 1:M "(S)ystems".
			(E)ntity				<-- Each EAV System may have 1:M (E)ntities (Models).
			(A)ttribute				<-- Each EAV Model may have 1:M (A)ttributes (e.g. fields).
		
		(S)ystem ::=
			System_id				<-- INTEGER Primary Key
			Id_parent				<-- INTEGER Foreign Key to a possible super-system (e.g. detachable or Void)
			Uuid					<-- UUID of System
			Name					<-- Possibly non-unique System name (hence the UUID)
			Is_deleted				<-- Deletion mark
			Modified_date			<-- Date-time stamp of create/update/delete
			Modifier_id				<-- Value.Instance_id of last-Modifying entity (person or machine)
		
		(E)ntity ::=
			Entity_id				<-- INTEGER Primary Key
			System_id				<-- INTEGER Foreign Key to System
			Uuid					<-- UUID of Entity
			Name					<-- Possibly non-unique Entity name (hence the UUID)
			Is_deleted				<-- Deletion mark
			Modified_date			<-- Date-time stamp of create/update/delete
			Modifier_id				<-- Value.Instance_id of last-Modifying entity (person or machine)
		
		Entity_key ::=
			Entity_key_id			<-- INTEGER Primary Key of Entity_key for ...
			Entity_id				<-- INTEGER Foreign Key to Entity
		
		Entity_Attribute_key ::=
			Entity_Attribute_key_id	<-- INTEGER Primary Key of Entity_Attribute_key for ...
			Entity_key_id			<-- INTEGER Foreign Key to Entity_key and for ...
			Attribute_id (1)		<-- INTEGER Foreign Key to Attribute, which is participating in the Entity_key
			Is_primary (2)			<-- Is Current a "Primary Key" of Entity through Entity_key?
			Is_partial (3)			<-- Is Current a "Partial Key", which is another name for "Filter"
			
		-------------------------
		(1) An Entity_key (and Entity) can have but one (or none) single-attribute Primary_key (e.g. Is_primary)
		
		(A)ttribute ::=
			Attribute_id			<-- INTEGER Primary Key
			Entity_id				<-- INTEGER Foreign Key to Entity
			Uuid					<-- UUID of Attribute
			Name					<-- Possibly non-unique Attribute name (hence the UUID)
			Is_deleted				<-- Deletion mark
			Modified_date			<-- Date-time stamp of create/update/delete
			Modifier_id				<-- Value.Instance_id of last-Modifying entity (person or machine)

		Value ::=
			Value_id				<-- INTEGER Primary Key of Value item
			Attribute_id			<-- INTEGER Foreign Key to Attribute (which is the SEA-key)
			Instance_id	(1)			<-- INTEGER Foreign Key (this is an actual instance of an SEA object)
			Value					<-- Actual value being stored for Instance_id of an SEA_id "type"
			Is_deleted				<-- Deletion mark
			Modified_date			<-- Date-time stamp of create/update/delete
			Modifier_id				<-- Value.Instance_id of last-Modifying entity (person or machine)
		
		-------------------------
		(1) Notice that there is no Instance or Entity_instance table. This is because there is no need.
			Instances are known from their external unique identifiers (e.g. Customer Number, VIN#, etc.).
			Some UUID values are single values, while others are compound. Some entities have primary
			keys, while they may also have candidate keys (alternate means of UUID).
		
		Relation ::=
			Relation_id				<-- INTEGER Primary Key of Relation
			Attribute_id_parent		<-- INTEGER Foreign Key to Attribute (SEA-key) as parent "type"
			Instance_id_parent		<-- INTEGER Foreign Key to Value as parent "instance" of "type"
			Attribute_id_child		<-- INTEGER Foreign Key to Attribute (SEA-key) as child "type"
			Instance_id_child		<-- INTEGER Foreign Key to Value as child "instance" of "type"
			Relation_type_id		<-- INTEGER Foreign Key to Relation_type
			Is_deleted				<-- Deletion mark
			Modified_date			<-- Date-time stamp of create/update/delete
			Modifier_id				<-- Value.Instance_id of last-Modifying entity (person or machine)
		
		RELATION_TYPE (1) ::=
			Relation_type_id		<-- INTEGER Primary Key to Relation_type (see once'd-constant features below)
			Name					<-- "1", "+", or "*" (One, One-or-more, Zero-one-or-more) as in: Single-reference or an ARRAY [ANY]
										As a static set, the Relation_type_id values are: #1, #2, #3 (e.g. "1", "+", or "*")
										As a class, it has three frozen once'd-constant features: only_one, one_or_more, zero_one_or_more: INTEGER
		
		-------------------------
		(1) There are just three types of relationships between entities, so this table has three records.
			Truthfully, this does not have to be a "table", but can be a class (and then object) which is used to
			set (define) the Relation_type_id of the Relation table.
		
		EXAMPLE:
		========
		
		System							Entity						Attribute
		======							======						=========
		#0-#100:"UUID","Dealership"		#100-#201:"UUID","Car"		#201-#334:"UUID","VIN_no"
																	#201-#335:"UUID","Make"
																	#201-#336:"UUID","Model"
																	#201-#337:"UUID","Year"
			Value (as STRING values)
			========================
		┌─►	#335-#1-#4:"Ford"
		├─►	#336-#1-#5:"Fusion"
		├─►	#334-#1-#1:"1FTDF15Y2KKB34438"		<-- Represents a Specific "VIN_no" attribute of a "Car" entity in a "Dealership" system
		│
		│	#334-#2-#2:"WDBCB20D8FA134438"		<-- The #1/#2/#3 Instance_id's are the ID of the Entity in the SEA.
	Car─┤	#334-#3-#3:"2FTEF15G0ECA38795"
		│
		│	Value (as INTEGER values)
		│	=========================
		└─►	#337-#1-#1:2013
		]"
	drawing_palette: "─ │ ┌ ┐ └ ┘ ├ ┤ ┬ ┴ ┼ ═ ║ ╒ ╓ ╔ ╕ ╖ ╗ ╘ ╙ ╚ ╛ ╜ ╝ ╞ ╟ ╠ ╡ ╢ ╣ ╤ ╥ ╦ ╧ ╨ ╩ ╪ ╫ ╬ "
	EIS: "src=https://en.wikipedia.org/wiki/Entity-attribute-value_model"
	CRUD: "[
		CRUD, as applied to data in tables, is only part of what is needed.
		We also require Create, Read, Update, Delete for:
		
		(1) Databases (e.g. create a new DB, read data about it, update that data, and deletion of it)
		(2) Tables (e.g. create a new Table, read data about it, update that data, and deletion of it)
		
					Create			Read		Update			Delete
		Database	  x				 x			  x				  x
		Table		  x				 x			  x				  x
		Data		  x				 x			  x				  x
		
		STEP #1: Give this library the code to do CRUD with databases.
		]"

end
