/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- read from text file ignoreing comments
-- By ken turner
-- www.designimage.co.uk
*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------------------------------- CommentedStringStreamStruct
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
struct CommentedStringStreamStruct
(
	f = undefined,
	headlinetxt = "",
	dataVersionNumber =  1.0, -- use this to set up read or write algorithms for different version of the data  ... because the 'chunks' my vary in size....
	fn trimSurroundingSpaces txt = ( trimleft ( trimRight txt ) ),
	fn NextLineAsString =
	(
		txt = readLine f
		i = findstring txt "--"
		if i != undefined then 
		(
			txt = substring txt 1 (i - 1)
		)
		txt = trimSurroundingSpaces txt
	),
	fn ReadNextLine =
	(
		txt = undefined
		do ( txt = NextLineAsString() ) while ( Not ( eof f )and ( txt.count < 1 ) )
		if ( txt.count < 1 ) then txt = undefined
		txt
	),
	fn IsHeadLineEqualTo theHeadline =
	(
		headlinetxt = ReadNextLine()
		if headlinetxt != undefined then ( headlinetxt == theHeadline ) else false
	),
	fn ReadNextLineAndTypeCastAs theClass =
	(
		txt = ReadNextLine()
		if txt != undefined then ( txt as theClass ) else undefined
	),
	fn ReadListAsArray =
	(
		theLine = ""
		theArray = #()
		while ( ( theLine = ReadNextLine() ) != undefined and (theLine != "EndOfList" )) do
		(
			append theArray theLine
		)
		theArray
	),
	fn ReadListAsArrayOfArrays =
	(
		theLine = ""
		theArray = #()
		while ( ( theLine = ReadNextLine() ) != undefined and (theLine != "EndOfList" )) do
		(
			newArray = filterString theLine ","
			for i = 1 to  newArray.count do newArray[i] = trimSurroundingSpaces newArray[i] 
			append theArray newArray
		)
		theArray
	)
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------- END OF: CommentedStringStreamStruct

