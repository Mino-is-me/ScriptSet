/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- read from text file structure
-- By ken turner
-- www.designimage.co.uk
*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- StringStreamStruct
struct StringStreamStruct
(
	f = undefined,
	headlinetxt = "",
	dataVersionNumber =  1.0, -- use this to set up read or write algorithms for different version of the data  ... because the 'chunks' my vary in size....
	fn trimSurroundingSpaces txt = ( trimleft ( trimRight txt ) ),
	fn ReadToDelimitChar DelimitChar =
	(
		txt = ( readDelimitedString f delimitChar ) 
		txt =  trimSurroundingSpaces txt 
	),
	fn ReadToDelimitCharAndTypeCast delimitChar asClass: =
	(
		txt = ( ReadToDelimitChar delimitChar ) 
		txt as asClass
	),
	fn ReadNameString withTheDelimitChar:"," = 
	( 
		txt = ReadToDelimitChar withTheDelimitChar
		txt = trimLeft	txt "#"	
		txt as name 
	),
	fn ReadBooleanString withTheDelimitChar:","= ( ReadToDelimitCharAndTypeCast withTheDelimitChar asClass:booleanClass ),
	fn ReadFloatString withTheDelimitChar:"," = ( ReadToDelimitCharAndTypeCast withTheDelimitChar asClass:float ),
	fn ReadPoint3String = 
	(
		ReadToDelimitChar "["
		a = ReadFloatString()
		b = ReadFloatString()
		c =  ( ReadToDelimitCharAndTypeCast "]" asClass:float )
		txt  = ReadToDelimitChar ","
		[ a , b , c ]
	),
	fn ReadIntString = ( ReadToDelimitCharAndTypeCast "," asClass:Integer ),
	fn ReadBitArrayString =
	(
		txt = ReadToDelimitChar "}"
		txtArray = filterString txt "#{,"
		newBitArray = #{}
		for txt in txtArray do
		(
			txt = ( filterString txt ".")
			numArray = for i in txt collect ( i as integer )
			if numArray.count == 1 then 
			(
				newBitArray[numArray[1]] = true
			)else
			(
				if numArray.count == 2 then 
				(
					for i = numArray[1] to numArray[2] do newBitArray[i] = true
				)
			)
		)
		newBitArray
	),
	fn ReadStringAndGetNode withTheDelimitChar:"," =
	(
		txt  = ReadToDelimitChar withTheDelimitChar
		getNodeByName txt --- toDo: validate this node
	),
	fn ReadHeadLineAndVersionNumber =
	(
		headlinetxt = ReadToDelimitChar ","
		dataVersionNumber = ReadToDelimitCharAndTypeCast "\n" asClass:float
	),
	fn checkHeadlineIs thisHeadlineText =
	(
		ReadHeadLineAndVersionNumber()
		thisHeadlineText == headlinetxt
	),
		
	fn collectStructArray structureDef =
	(
		ReadToDelimitChar ":"
		c = ReadToDelimitCharAndTypeCast "\n" asClass:Integer
		for i = 1 to C collect
		(
			structInstance = structureDef()
			structInstance.readMe this
			structInstance
		)
	),
	fn collectStructArrayToEOF structureDef =
	(
		newStructInstanceArray = #()
		while not (eof f) do
		(
			structInstance = structureDef()
			structInstance.readme this
			append newStructInstanceArray structInstance
		)
		newStructInstanceArray
	),
	fn ReadLineAsArray SplitUsingTheseCharacters:","  splitEmptyTokens:false =
	(
		txt = readLine f
		tokens = filterString txt SplitUsingTheseCharacters splitEmptyTokens:splitEmptyTokens
		for i = 1 to tokens.count do
		(
			tokens[i] = trimSurroundingSpaces tokens[i]
		)
		tokens
	)
)