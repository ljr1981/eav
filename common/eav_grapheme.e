note
	description: "[
		Representation of an effected {EAV_GRAPHEME}.
]"

class
	EAV_GRAPHEME

feature -- Basic Operations

	convert_to_hash (a_identifier: STRING): ARRAYED_LIST [INTEGER_32]
			-- `convert_to_hash' `a_identifier' to hash-code as {INTEGER_32}.
		local
			i,j: INTEGER
			l_found: BOOLEAN
		do
			create Result.make (5)
			inspect
				a_identifier.count
			when 1 then
				Result.force (a_identifier.hash_code)
			when 2 then
				Result.force (grapheme_twos_hash_codes.at (a_identifier))
			else
				from
					i := 1
				until
					(i > a_identifier.count)
				loop
					from
						if (a_identifier.count - i) >= 4  then
							j := 4
						else
							j := a_identifier.count - i + 1
						end
						l_found := False
					until
						(j < 0) or l_found
					loop
						inspect
							j
						when 4 then
							if attached grapheme_fours_hash_codes.at (a_identifier.substring (i, i + j - 1)) as al_code and then al_code > 0 then
								Result.force (al_code)
								l_found := True
							end
						when 3 then
							if attached grapheme_threes_hash_codes.at (a_identifier.substring (i, i + j - 1)) as al_code and then al_code > 0 then
								Result.force (al_code)
								l_found := True
							end
						when 2 then
							if attached grapheme_twos_hash_codes.at (a_identifier.substring (i, i + j - 1)) as al_code and then al_code > 0 then
								Result.force (al_code)
								l_found := True
							end
						when 1 then
							Result.force (a_identifier.substring (i, i).hash_code)
							l_found := True
						else
							check too_small: False end
						end
						j := j - 1
					end
					i := i + j + 1
				end
			end
		end

feature -- Constants

	phoneme_list: HASH_TABLE [STRING, INTEGER_32]
			-- Phonemes of various forms.
		note
			EIS: "src=file:$(USERPROFILE)\Documents\GitHub\eav\docs\table_of_phonemes.pdf", "protocol=PDF"
		do
			create Result.make (44)
		end

	graphemes: HASH_TABLE [INTEGER_32, STRING]
		once
			create Result.make (111)
			across grapheme_fours as ic loop Result.force (ic.key, ic.item) end
			across grapheme_threes as ic loop Result.force (ic.key, ic.item) end
			across grapheme_twos as ic loop Result.force (ic.key, ic.item) end
		end

	grapheme_twos_hash_codes: HASH_TABLE [INTEGER_32, STRING]
			-- `grapheme_twos_hash_codes' lookup hash-code by grapheme text.
		once
			create Result.make (80)
			Result.force (("ae").hash_code, "ae")
			Result.force (("ai").hash_code, "ai")
			Result.force (("al").hash_code, "al")
			Result.force (("ar").hash_code, "ar")
			Result.force (("au").hash_code, "au")
			Result.force (("aw").hash_code, "aw")
			Result.force (("ay").hash_code, "ay")
			Result.force (("bb").hash_code, "bb")
			Result.force (("bu").hash_code, "bu")
			Result.force (("ce").hash_code, "ce")
			Result.force (("ce").hash_code, "ce")
			Result.force (("ch").hash_code, "ch")
			Result.force (("ci").hash_code, "ci")
			Result.force (("ck").hash_code, "ck")
			Result.force (("cy").hash_code, "cy")
			Result.force (("dd").hash_code, "dd")
			Result.force (("ea").hash_code, "ea")
			Result.force (("ed").hash_code, "ed")
			Result.force (("ee").hash_code, "ee")
			Result.force (("ei").hash_code, "ei")
			Result.force (("el").hash_code, "el")
			Result.force (("eq").hash_code, "eq")
			Result.force (("er").hash_code, "er")
			Result.force (("eu").hash_code, "eu")
			Result.force (("ey").hash_code, "ey")
			Result.force (("ff").hash_code, "ff")
			Result.force (("ga").hash_code, "ga")
			Result.force (("ge").hash_code, "ge")
			Result.force (("gg").hash_code, "gg")
			Result.force (("gh").hash_code, "gh")
			Result.force (("gi").hash_code, "gi")
			Result.force (("gn").hash_code, "gn")
			Result.force (("gu").hash_code, "gu")
			Result.force (("gy").hash_code, "gy")
			Result.force (("ie").hash_code, "ie")
			Result.force (("il").hash_code, "il")
			Result.force (("ir").hash_code, "ir")
			Result.force (("kn").hash_code, "kn")
			Result.force (("ks").hash_code, "ks")
			Result.force (("le").hash_code, "le")
			Result.force (("ll").hash_code, "ll")
			Result.force (("mb").hash_code, "mb")
			Result.force (("me").hash_code, "me")
			Result.force (("mm").hash_code, "mm")
			Result.force (("mn").hash_code, "mn")
			Result.force (("ne").hash_code, "ne")
			Result.force (("ng").hash_code, "ng")
			Result.force (("nk").hash_code, "nk")
			Result.force (("nn").hash_code, "nn")
			Result.force (("oa").hash_code, "oa")
			Result.force (("oe").hash_code, "oe")
			Result.force (("oi").hash_code, "oi")
			Result.force (("oo").hash_code, "oo")
			Result.force (("or").hash_code, "or")
			Result.force (("ou").hash_code, "ou")
			Result.force (("ow").hash_code, "ow")
			Result.force (("oy").hash_code, "oy")
			Result.force (("ph").hash_code, "ph")
			Result.force (("pp").hash_code, "pp")
			Result.force (("ps").hash_code, "ps")
			Result.force (("qu").hash_code, "qu")
			Result.force (("rh").hash_code, "rh")
			Result.force (("rr").hash_code, "rr")
			Result.force (("sc").hash_code, "sc")
			Result.force (("se").hash_code, "se")
			Result.force (("sh").hash_code, "sh")
			Result.force (("si").hash_code, "si")
			Result.force (("ss").hash_code, "ss")
			Result.force (("st").hash_code, "st")
			Result.force (("th").hash_code, "th")
			Result.force (("ti").hash_code, "ti")
			Result.force (("tt").hash_code, "tt")
			Result.force (("ue").hash_code, "ue")
			Result.force (("ui").hash_code, "ui")
			Result.force (("ur").hash_code, "ur")
			Result.force (("ve").hash_code, "ve")
			Result.force (("wa").hash_code, "wa")
			Result.force (("wh").hash_code, "wh")
			Result.force (("wr").hash_code, "wr")
			Result.force (("ze").hash_code, "ze")
			Result.force (("zz").hash_code, "zz")
		end

	grapheme_twos: HASH_TABLE [STRING, INTEGER_32]
			-- Graphemes with two letters.
		once
			create Result.make (80)
			Result.force ("ae", ("ae").hash_code)
			Result.force ("ai", ("ai").hash_code)
			Result.force ("al", ("al").hash_code)
			Result.force ("ar", ("ar").hash_code)
			Result.force ("au", ("au").hash_code)
			Result.force ("aw", ("aw").hash_code)
			Result.force ("ay", ("ay").hash_code)
			Result.force ("bb", ("bb").hash_code)
			Result.force ("bu", ("bu").hash_code)
			Result.force ("ce", ("ce").hash_code)
			Result.force ("ch", ("ch").hash_code)
			Result.force ("ci", ("ci").hash_code)
			Result.force ("ck", ("ck").hash_code)
			Result.force ("cy", ("cy").hash_code)
			Result.force ("dd", ("dd").hash_code)
			Result.force ("ea", ("ea").hash_code)
			Result.force ("ed", ("ed").hash_code)
			Result.force ("ee", ("ee").hash_code)
			Result.force ("ei", ("ei").hash_code)
			Result.force ("el", ("el").hash_code)
			Result.force ("eq", ("eq").hash_code)
			Result.force ("er", ("er").hash_code)
			Result.force ("eu", ("eu").hash_code)
			Result.force ("ey", ("ey").hash_code)
			Result.force ("ff", ("ff").hash_code)
			Result.force ("ga", ("ga").hash_code)
			Result.force ("ge", ("ge").hash_code)
			Result.force ("gg", ("gg").hash_code)
			Result.force ("gh", ("gh").hash_code)
			Result.force ("gi", ("gi").hash_code)
			Result.force ("gn", ("gn").hash_code)
			Result.force ("gu", ("gu").hash_code)
			Result.force ("gy", ("gy").hash_code)
			Result.force ("ie", ("ie").hash_code)
			Result.force ("il", ("il").hash_code)
			Result.force ("ir", ("ir").hash_code)
			Result.force ("kn", ("kn").hash_code)
			Result.force ("ks", ("ks").hash_code)
			Result.force ("le", ("le").hash_code)
			Result.force ("ll", ("ll").hash_code)
			Result.force ("mb", ("mb").hash_code)
			Result.force ("me", ("me").hash_code)
			Result.force ("mm", ("mm").hash_code)
			Result.force ("mn", ("mn").hash_code)
			Result.force ("ne", ("ne").hash_code)
			Result.force ("ng", ("ng").hash_code)
			Result.force ("nk", ("nk").hash_code)
			Result.force ("nn", ("nn").hash_code)
			Result.force ("oa", ("oa").hash_code)
			Result.force ("oe", ("oe").hash_code)
			Result.force ("oi", ("oi").hash_code)
			Result.force ("oo", ("oo").hash_code)
			Result.force ("or", ("or").hash_code)
			Result.force ("ou", ("ou").hash_code)
			Result.force ("ow", ("ow").hash_code)
			Result.force ("oy", ("oy").hash_code)
			Result.force ("ph", ("ph").hash_code)
			Result.force ("pp", ("pp").hash_code)
			Result.force ("ps", ("ps").hash_code)
			Result.force ("qu", ("qu").hash_code)
			Result.force ("rh", ("rh").hash_code)
			Result.force ("rr", ("rr").hash_code)
			Result.force ("sc", ("sc").hash_code)
			Result.force ("se", ("se").hash_code)
			Result.force ("sh", ("sh").hash_code)
			Result.force ("si", ("si").hash_code)
			Result.force ("ss", ("ss").hash_code)
			Result.force ("st", ("st").hash_code)
			Result.force ("th", ("th").hash_code)
			Result.force ("ti", ("ti").hash_code)
			Result.force ("tt", ("tt").hash_code)
			Result.force ("ue", ("ue").hash_code)
			Result.force ("ui", ("ui").hash_code)
			Result.force ("ur", ("ur").hash_code)
			Result.force ("ve", ("ve").hash_code)
			Result.force ("wa", ("wa").hash_code)
			Result.force ("wh", ("wh").hash_code)
			Result.force ("wr", ("wr").hash_code)
			Result.force ("ze", ("ze").hash_code)
			Result.force ("zz", ("zz").hash_code)
		end

	grapheme_threes_hash_codes: HASH_TABLE [INTEGER_32, STRING]
			-- `grapheme_threes_hash_codes' for looking up hash-codes by grapheme.
		once
			create Result.make (26)
			Result.force (("air").hash_code, "air")
			Result.force (("alt").hash_code, "alt")
			Result.force (("are").hash_code, "are")
			Result.force (("chr").hash_code, "chr")
			Result.force (("cks").hash_code, "cks")
			Result.force (("dge").hash_code, "dge")
			Result.force (("ear").hash_code, "ear")
			Result.force (("eau").hash_code, "eau")
			Result.force (("eer").hash_code, "eer")
			Result.force (("ere").hash_code, "ere")
			Result.force (("gue").hash_code, "gue")
			Result.force (("ier").hash_code, "ier")
			Result.force (("igh").hash_code, "igh")
			Result.force (("ine").hash_code, "ine")
			Result.force (("kes").hash_code, "kes")
			Result.force (("oar").hash_code, "oar")
			Result.force (("oor").hash_code, "oor")
			Result.force (("ore").hash_code, "ore")
			Result.force (("oul").hash_code, "oul")
			Result.force (("our").hash_code, "our")
			Result.force (("qua").hash_code, "qua")
			Result.force (("que").hash_code, "que")
			Result.force (("ssi").hash_code, "ssi")
			Result.force (("tch").hash_code, "tch")
			Result.force (("war").hash_code, "war")
			Result.force (("wor").hash_code, "wor")
		end

	grapheme_threes: HASH_TABLE [STRING, INTEGER_32]
			-- Graphemes with three letters.
		once
			create Result.make (26)
			Result.force ("air", ("air").hash_code)
			Result.force ("alt", ("alt").hash_code)
			Result.force ("are", ("are").hash_code)
			Result.force ("chr", ("chr").hash_code)
			Result.force ("cks", ("cks").hash_code)
			Result.force ("dge", ("dge").hash_code)
			Result.force ("ear", ("ear").hash_code)
			Result.force ("eau", ("eau").hash_code)
			Result.force ("eer", ("eer").hash_code)
			Result.force ("ere", ("ere").hash_code)
			Result.force ("gue", ("gue").hash_code)
			Result.force ("ier", ("ier").hash_code)
			Result.force ("igh", ("igh").hash_code)
			Result.force ("ine", ("ine").hash_code)
			Result.force ("kes", ("kes").hash_code)
			Result.force ("oar", ("oar").hash_code)
			Result.force ("oor", ("oor").hash_code)
			Result.force ("ore", ("ore").hash_code)
			Result.force ("oul", ("oul").hash_code)
			Result.force ("our", ("our").hash_code)
			Result.force ("qua", ("qua").hash_code)
			Result.force ("que", ("que").hash_code)
			Result.force ("ssi", ("ssi").hash_code)
			Result.force ("tch", ("tch").hash_code)
			Result.force ("war", ("war").hash_code)
			Result.force ("wor", ("wor").hash_code)
		end

	grapheme_fours_hash_codes: HASH_TABLE [INTEGER_32, STRING]
			-- `grapheme_fours_hash_codes' for looking up hash-codes by grapheme.
		once
			create Result.make (5)
			Result.force (("augh").hash_code, "augh")
			Result.force (("eigh").hash_code, "eigh")
			Result.force (("ough").hash_code, "ough")
			Result.force (("quar").hash_code, "quar")
			Result.force (("ture").hash_code, "ture")
		end

	grapheme_fours: HASH_TABLE [STRING, INTEGER_32]
			-- Graphemes with four letters.
		once
			create Result.make (5)
			Result.force ("augh", ("augh").hash_code)
			Result.force ("eigh", ("eigh").hash_code)
			Result.force ("ough", ("ough").hash_code)
			Result.force ("quar", ("quar").hash_code)
			Result.force ("ture", ("ture").hash_code)

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
