note
	description: "[
		Representation of an effected {EAV_FUNCTIONS}.
		]"
	design: "[
		Based on common functions from various other languages
		(i.e. Visual FoxPro to start with).
		]"

class
	EAV_FUNCTIONS

feature -- STRING functions

			--$ Operator
	alltrim (a_args: TUPLE [s: STRING; parse_characters: STRING]): STRING
			--ALLTRIM( ) Function
			-- Removes all leading and trailing spaces or parsing characters from
			--	the specified character expression.
		require
			valid_arg_count: not a_args.is_empty and a_args.count <= 2
		local
			i: INTEGER
		do
			Result := a_args.s.twin
			if a_args.count = 2 and not a_args.parse_characters.is_empty then
				across
					a_args.s.new_cursor.reversed as ic_rev_s
				from
					i := Result.count
				until
					not a_args.parse_characters.has (ic_rev_s.item) xor (i = 0) xor ic_rev_s.item = ' '
				loop
					if a_args.parse_characters.has (ic_rev_s.item) xor ic_rev_s.item = ' ' then
						Result.remove (i)
					end
					i := i - 1
				end
				if not Result.is_empty and then a_args.s.has_substring (Result) then
					across
						a_args.s as ic_rev_s
					from
						i := 1
					until
						not a_args.parse_characters.has (ic_rev_s.item) xor (Result.count = 0) xor ic_rev_s.item = ' '
					loop
						if a_args.parse_characters.has (ic_rev_s.item) xor ic_rev_s.item = ' ' then
							Result.remove (i)
						end
					end
				end
			else
				Result.left_adjust
				Result.right_adjust
			end
		end

	asc (s: STRING): INTEGER
			--ASC( ) Function
			-- Returns the ANSI value for the leftmost character in a character expression.
		require
			has_string: s.count > 0
		do
			Result := s [1].code
		end

	at (a_search_expr, a_expr_searched: STRING_GENERAL; n_occurance: INTEGER): INTEGER
			--AT( ) Function
			-- AT(cSearchExpression, cExpressionSearched [, nOccurrence])
			-- The search performed by AT( ) is case-sensitive. To perform a search that is not
			--	case-sensitive, use ATC( ). For more information, see ATC( ) Function.
			-- Numeric. AT( ) returns an integer indicating the position of the first character for a
			--	character expression or memo field within another character expression or memo field,
			--	beginning from the leftmost character. If the expression or field is not found, or if
			--	nOccurrence is greater than the number of times cSearchExpression occurs in
			--	cExpressionSearched, AT( ) returns 0.
		local
			i: INTEGER
		do
			if a_expr_searched.has_substring (a_search_expr) then
				across
					1 |..| a_expr_searched.count as ic
				loop
					if a_expr_searched.substring (ic.item, ic.item + a_search_expr.count - 1).same_string (a_search_expr) then
						i := i + 1
						if i = n_occurance or n_occurance = 0 then
							Result := ic.item
						end
					end
				end
			end
		end

			--AT_C( ) Function
			--ATC( ) Function
			--ATCC( ) Function
			--ATCLINE( ) Function
			--ATLINE( ) Function
			--BETWEEN( ) Function
			--CHR( ) Function
			--CHRTRAN( ) Function
			--CHRTRANC( ) Function
			--CPCONVERT( ) Function
			--CTOD( ) Function
			--DIFFERENCE( ) Function
			--DTOC( ) Function
			--EMPTY( ) Function
			--EVALUATE( ) Function
			--GETWORDCOUNT( ) Function
			--GETWORDNUM( ) Function
			--INLIST( ) Function
			--ISALPHA( ) Function
			--ISDIGIT( ) Function
			--ISLEADBYTE( ) Function
			--ISLOWER( ) Function
			--ISUPPER( ) Function
			--LEFT( ) Function
			--LEFTC( ) Function
			--LEN( ) Function
			--LENC( ) Function
			--LIKE( ) Function
			--LIKEC( ) Function
			--LOWER( ) Function
			--LTRIM( ) Function
			--MAX( ) Function
			--MIN( ) Function
			--NORMALIZE( ) Function
			--OCCURS( ) Function
			--PADL( ) | PADR( ) | PADC( ) Functions
			--PROPER( ) Function
			--RAT( ) Function
			--RATC( ) Function
			--RATLINE( ) Function
			--REPLICATE( ) Function
			--RIGHT( ) Function
			--RIGHTC( ) Function
			--RTRIM( ) Function
			--SOUNDEX( ) Function
			--SPACE( ) Function
			--STR( ) Function
			--STRCONV( ) Function
			--STRTOFILE( ) Function
			--STRTRAN( ) Function
			--STUFF( ) Function
			--STUFFC( ) Function
			--SUBSTR( ) Function
			--SUBSTRC( ) Function
			--SYS(10) - String from Julian Day Number
			--SYS(15) - Character Translation
			--SYS(2007) - Checksum Value
			--TEXTMERGE( ) Function
			--TRANSFORM( ) Function
			--TRIM( ) Function
			--TXTWIDTH( ) Function
			--TYPE( ) Function
			--UPPER( ) Function
			--VARTYPE( ) Function

note
	design_intent: "[
		...
		]"

end
