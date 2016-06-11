note
	description: "[
		Representation of an effected {EAV_GRAPHEME}.
]"

class
	EAV_GRAPHEME

feature -- Basic Operations

	convert_to_hash (a_identifier: STRING): INTEGER_64
			-- `convert_to_hash' `a_identifier' to hash-code as {INTEGER_64}.
		do
				-- 4-letter
				-- 3-letter
				-- 2-letter
		end

feature -- Constants

	phoneme_list: HASH_TABLE [STRING, INTEGER]
			-- Phonemes of various forms.
		note
			EIS: "src=file:$(USERPROFILE)\Documents\GitHub\eav\docs\table_of_phonemes.pdf", "protocol=PDF"
		do
			create Result.make (44)
		end

	phoneme_consonants_list: HASH_TABLE [STRING, INTEGER]
			-- Phoneme consonants.
		do
			create Result.make (24)
			Result.force ("b", 1)
		end



	grapheme_twos: HASH_TABLE [TUPLE [grapheme: STRING; phonemes: ARRAY [STRING]], INTEGER]
			-- Graphemes with two letters.
		do
			create Result.make (81)
			Result.force (["ae", <<>>], 2)
			Result.force (["ai", <<>>], 4)
			Result.force (["al", <<>>], 6)
			Result.force (["ar", <<>>], 8)
			Result.force (["au", <<>>], 10)
			Result.force (["aw", <<>>], 12)
			Result.force (["ay", <<>>], 14)
			Result.force (["bb", <<"b">>], 16)
			Result.force (["bu", <<>>], 18)
			Result.force (["ce", <<>>], 20)
			Result.force (["ce", <<>>], 22)
			Result.force (["ch", <<>>], 24)
			Result.force (["ci", <<>>], 26)
			Result.force (["ck", <<"k">>], 28)
			Result.force (["cy", <<>>], 30)
			Result.force (["dd", <<"d">>], 32)
			Result.force (["ea", <<>>], 34)
			Result.force (["ed", <<"d">>], 36)
			Result.force (["ee", <<>>], 38)
			Result.force (["ei", <<>>], 40)
			Result.force (["el", <<>>], 42)
			Result.force (["eq", <<>>], 44)
			Result.force (["er", <<>>], 46)
			Result.force (["eu", <<>>], 48)
			Result.force (["ey", <<>>], 50)
			Result.force (["ff", <<"f">>], 52)
			Result.force (["ga", <<>>], 54)
			Result.force (["ge", <<>>], 56)
			Result.force (["gg", <<"g">>], 58)
			Result.force (["gh", <<>>], 60)
			Result.force (["gi", <<>>], 62)
			Result.force (["gn", <<>>], 64)
			Result.force (["gu", <<>>], 66)
			Result.force (["gy", <<>>], 68)
			Result.force (["ie", <<>>], 70)
			Result.force (["il", <<>>], 72)
			Result.force (["ir", <<>>], 74)
			Result.force (["kn", <<>>], 76)
			Result.force (["ks", <<>>], 78)
			Result.force (["le", <<>>], 80)
			Result.force (["ll", <<"l">>], 82)
			Result.force (["mb", <<>>], 84)
			Result.force (["me", <<>>], 86)
			Result.force (["mm", <<"m">>], 88)
			Result.force (["mn", <<>>], 90)
			Result.force (["ne", <<>>], 92)
			Result.force (["ng", <<>>], 94)
			Result.force (["nk", <<>>], 96)
			Result.force (["nn", <<"n">>], 98)
			Result.force (["oa", <<>>], 200)
			Result.force (["oe", <<>>], 202)
			Result.force (["oi", <<>>], 204)
			Result.force (["oo", <<>>], 206)
			Result.force (["or", <<>>], 208)
			Result.force (["ou", <<>>], 210)
			Result.force (["ow", <<>>], 212)
			Result.force (["oy", <<>>], 214)
			Result.force (["ph", <<"f">>], 216)
			Result.force (["pp", <<"p">>], 218)
			Result.force (["ps", <<>>], 220)
			Result.force (["qu", <<>>], 222)
			Result.force (["rh", <<>>], 224)
			Result.force (["rr", <<"r">>], 226)
			Result.force (["sc", <<>>], 228)
			Result.force (["se", <<"z">>], 230)
			Result.force (["sh", <<"s">>], 232)
			Result.force (["si", <<>>], 234)
			Result.force (["ss", <<"s">>], 236)
			Result.force (["st", <<>>], 238)
			Result.force (["th", <<>>], 240)
			Result.force (["ti", <<>>], 242)
			Result.force (["tt", <<"t">>], 244)
			Result.force (["ue", <<>>], 246)
			Result.force (["ui", <<>>], 248)
			Result.force (["ur", <<>>], 250)
			Result.force (["ve", <<>>], 252)
			Result.force (["wa", <<>>], 254)
			Result.force (["wh", <<>>], 256)
			Result.force (["wr", <<>>], 258)
			Result.force (["ze", <<"z">>], 260)
			Result.force (["zz", <<"z">>], 262)
		end

	grapheme_threes: HASH_TABLE [TUPLE [grapheme: STRING; phonemes: ARRAY [STRING]], INTEGER]
			-- Graphemes with three letters.
		do
			create Result.make (25)
			Result.force (["air", <<>>], 200)
			Result.force (["alt", <<>>], 202)
			Result.force (["are", <<>>], 204)
			Result.force (["chr", <<>>], 206)
			Result.force (["cks", <<>>], 208)
			Result.force (["dge", <<"j", "g">>], 110)
			Result.force (["ear", <<>>], 112)
			Result.force (["eau", <<>>], 114)
			Result.force (["eer", <<>>], 116)
			Result.force (["ere", <<>>], 118)
			Result.force (["gue", <<>>], 120)
			Result.force (["ier", <<>>], 122)
			Result.force (["igh", <<>>], 124)
			Result.force (["ine", <<>>], 126)
			Result.force (["kes", <<>>], 128)
			Result.force (["oar", <<>>], 130)
			Result.force (["oor", <<>>], 132)
			Result.force (["ore", <<>>], 134)
			Result.force (["oul", <<>>], 136)
			Result.force (["our", <<>>], 138)
			Result.force (["qua", <<>>], 140)
			Result.force (["que", <<>>], 142)
			Result.force (["ssi", <<>>], 144)
			Result.force (["tch", <<>>], 146)
			Result.force (["war", <<>>], 148)
			Result.force (["wor", <<>>], 150)
		end

	grapheme_fours: HASH_TABLE [TUPLE [grapheme: STRING; phonemes: ARRAY [STRING]], INTEGER]
			-- Graphemes with four letters.
		do
			create Result.make (5)
			Result.force (["augh", <<>>], 1_000)
			Result.force (["eigh", <<>>], 2_000)
			Result.force (["ough", <<>>], 3_000)
			Result.force (["quar", <<>>], 4_000)
			Result.force (["ture", <<>>], 5_000)

		end

	primes_generator: PRIMES
			-- `primes_generator'
		once
			create Result
		end

note
	design_intent: "[
		Graphemes are the spellings of phonemes. While there are 44 phonemes,
		there are more graphemes. However, in our need, we do not need to make
		a distinction between how something sounds vs. how it is written. All
		we care about is how the grapheme is written because we want to turn
		it into a hash code.
		
		The ultimate goal is to represent any reasonably long feature identifier
		as a hash code that is reasonably guaranteed to be unique in a system
		of EAV attributes.
		
		Furthermore, when parseing a word, we will do the following:
		
		(1) We may or may not care about the underscores that divide an identifier
			into "words" or "parts". We may be able to simply ignore them, which
			will allow identifiers to be run-ons.
		(2) We may or may not care about numbers in identifiers. We will attempt
			to ignore them to start with.
		(3) We will parse the identifier starting with the 4-letter graphemes first,
			then the 3-letter, and finally the 2-letter.
			
		NOTE: It is our present supposition that 1-letter remainders (e.g. after parsing)
				will not be found. If they are, we will set that up as a check
				assertion, which will alert us if the grapheme list is somehow incomplete
				or if the programmer has not used "proper english" in the construction
				of their identifiers. If that turns out to be the case, we have a choice:
				
				(a) We can force the programmer to choose another spelling, which is
					properly aligned with the rules -OR-
				(b) We can attempt to be accommodating to the nuance.
				
				We will prefer (a) over (b) as it is easier for the human mind to
				handle restructuing to meet the rules than it is to code for the
				nuance (at least that is our present belief).
		]"
	parsing: "[
		There are 111 total graphemes: 81 2-letter, 25 3-letter, and 5 4-letter = 111
		
		Noted:
		(1) Each grapheme may appear 0-1-more times in an identifier.
		(2) What is the average or max length we'd like to impose on identifiers?
			is_this_the_maximum_length_of_an_identifier? = 42? ... call it 50 characters?
		
		If we presume 50 character max, then the most of each grapheme count will be:
		
		(a) 2-letter = 25 graphemes
		(b) 3-letter = 16 graphemes
		(c) 4-letter = 12 graphemes
		
		The worse-case scenario is 25 2-letter graphemes of all the same grapheme
		For example: aeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeae <-- 25 "ae" graphemes
		
		The immediate question is: How does this hash out to {INTEGER_64}?
		
		The first thought we have is to take the 64-bits of the {INTEGER_64} and use bit-wise
		operations to represent "places" for the 2/3/4-letter graphemes, where there is a
		structure that accommodates x-grapheme X count (e.g. what grapheme do we have and
		how many did we find--no matter where they were and regardless of order or space in
		between them).
		
		The other PDF document has 93 total graphemes. What is needed and wanted is:
		
		[grapheme, count] --> each G has a count, where each G lives on the INTEGER_64 bit
		scale somewhere. 
		
		00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
		
		There are precisely 44 phonemes for 81-93 graphemes. Map graphemes to phonemes and
		store the phoneme representation.
		
		[phoneme, count] --> Each P has a count, where G lives on the INTEGER_64 bit scale
		somewhere.
		
		We can a 44-bit register where each phoneme gets a bit-position to mark as has/has-not.
		This will leave 20 bits for storing other information like counts.
		
		20 bits = 1,048,576 possible values


		]"
	testing: "[
		With the RANDOMIZER library, it ought to be possible to test a vast number of
		generated grapheme sets in order to prove that the system works reasonably well.
		]"

end
