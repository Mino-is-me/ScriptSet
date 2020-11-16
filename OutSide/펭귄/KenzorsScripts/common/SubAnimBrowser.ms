-- subAnimbrowser

struct subAnimFinderStruct
(
	subAnimPath = #(),
	ctrl = undefined,
	validControllerList = #(bezier_float,Linear_Float,TCB_float,Expose_Float_Control,Float_Expression,Float_list,Float_motion_capture,Float_reactor,Float_script),
	
	fn TrimSpaces txt = trimleft ( trimRight txt ),
	fn mySubAnim = 
	(
		c = subAnimPath.Count 
		if c >0 then subAnimPath[c] else undefined
	),
	fn setValidControllerList type =
	(
		validControllerList = #(bezier_float,Linear_Float,TCB_float)
		if type = #input then validControllerList += #(Expose_Float_Control,Float_Expression,Float_list,Float_motion_capture,Float_reactor,Float_script)
	),
	fn setCtrl =
	(
		ctrlSubAnim = mySubAnim()
		isCtrlOk = ctrlSubAnim != undefined and isProperty ctrlSubAnim "controller"
		ctrl = if isCtrlOk then ctrlSubAnim.controller else Undefined
		isCtrlOk
	),
	fn setSubAnimPath newSubAnimPath =
	(
		subAnimPath = newSubAnimPath
		setCtrl()
	),
	fn findSubAnimOf theProperty byName: =
	(
		--format  "numsubs: % \n" (theProperty.numSubs)
			
		SubItemList = for i = 1 to theProperty.numSubs collect ( getSubAnim theProperty i)
		caList = for i = 1 to ( custAttributes.count theProperty ) collect ( custAttributes.get theProperty i )

		childPropertyList = SubItemList + caList
		childPropertyNamesList =  for n in childPropertyList collect (n.name as string)
		--print childPropertyNamesList
		i = findItem childPropertyNamesList byName
		if i > 0 then childPropertyList[i] else undefined
	),
	fn SetSubAnimFromCommaDelimitedString theString =
	(
		--print theString
		nameList = filterString theString ",\"#"
		trimName = ""
		setSubAnimPath #()
		nameList = for txt  in nameList where (( trimName = ( trimSpaces txt ) ) != "" ) collect trimName
		if nameList.count > 0 then
		(
			theNode = getNodeByName (nameList [1])
			
			if theNode != undefined then
			(
				theProperty = theNode
				deleteItem nameList 1
				
				newsubAnimPath = for n in nameList while theProperty != undefined collect
				(
					theProperty = findSubAnimOf theProperty byName:n
				)
				setSubAnimPath ( #(theNode) + newsubAnimPath )
				true
			)  else false
		) else false
	),
	fn getSubAnimPathAsString =
	(
		txt = ""
		for n in subAnimPath do
		(
			txt +=(  ( n.name as string ) + ",")
		)
		txt
	),
	fn mySubAnimNameAsString = 
	(
		theSubAnim = mySubAnim()
		if theSubAnim != undefined then ( theSubAnim.name as string ) else ""
	),
	fn writeMe f =
	(
		txt = getSubAnimPathAsString()
		format "%\n" txt to:f
	),
	fn readMe fStream =
	(
		SetSubAnimFromCommaDelimitedString ( fStream.ReadToDelimitChar "\n" )
	)
)
try ( destroyDialog subAnimRoll) catch ()

rollout KenzorsSubAnimRoll "subanim"
(
	----------------------------------------------------------------------------- required for kenzorsRolloutManager --------------------
	Local isRolledOut = true
	Local rolledUpEventFn = undefined
	on KenzorsSubAnimRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn())
		
	-----------------------------------------------------------------------------
	
	local subAnimPath = #()
	local currentProperty = undefined
	local childPropertyList = #()
	local validControllerList = #(bezier_float,Linear_Float,TCB_float,Expose_Float_Control,Float_Expression,Float_list,Float_motion_capture,Float_reactor,Float_script)
	
	-- Set these values in the calling function
	local returnIndex = 0
	local returnFnPtr = undefined
	
	Listbox LbxCurrentSubAnims "  "
	button btnUp "back" Across:3
	pickButton pbtnPickObject "pick object"
	
	button btnUse "use Contoller" enabled:false
	
	label lbl1 "Pick an object in the scene using the 'pick object' button." align:#center offset:[0,10]
	label lbl2 "Click an item in the list to browse it's properties." align:#center
	label lbl3 "Go back up the tree by pressing the 'back' button" align:#center
	
	fn setListCaption =
	(
		txt = ""
		for n in subAnimPath do
		(
			txt +=(  ( n.name as string ) + " > ")
		)
		LbxCurrentSubAnims.caption = txt
	)
	
	fn isValidController theSubAnim =
	(
		--validControllerList = #(bezier_float,Linear_Float,TCB_float,Expose_Float_Control,Float_Expression,Float_list,Float_motion_capture,Float_reactor,Float_script)
		( isProperty theSubAnim "controller" ) and ( ( findItem validControllerList (classof theSubAnim.controller) ) >0 )
	)
	
	fn FillSubAnimList =
	(
		if subAnimPath.Count  > 0 then 
		(
			currentProperty = subAnimPath[subAnimPath.Count ]
			--format  "numsubs: % \n" (currentProperty.numSubs)
			SubItemList = for i = 1 to currentProperty.numSubs collect ( getSubAnim currentProperty i)
			caList = for i = 1 to ( custAttributes.count currentProperty ) collect ( custAttributes.get currentProperty i )
			childPropertyList = SubItemList + caList

			LbxCurrentSubAnims.items =  for n in childPropertyList collect (n.name as string)
		) else LbxCurrentSubAnims.item = #()
		setListCaption()
		btnUse.enabled =  subAnimPath.count > 0 and ( isValidController subAnimPath[subAnimPath.count] )
	)
	
	fn  setChildPropertyIndex childPropertyIndex =
	(
		currentProperty = subAnimPath[subAnimPath.Count ]
		newProperty = childPropertyList[ childPropertyIndex ]
	--	format  "newProperty: % " newProperty
	--	format  "set current prop: % " childPropertyIndex
		if newProperty != undefined then
		(
			append subAnimPath newProperty
			FillSubAnimList()
		)
	)
	
	on pbtnPickObject picked obj do 
	(
		subAnimPath = if obj !=undefined then #(obj) else #()	
		FillSubAnimList()
	)
	
	on LbxCurrentSubAnims selected i do ( setChildPropertyIndex i )
	
	on btnUp Pressed do
	(
		if subAnimPath.count > 1 then deleteitem subAnimPath (subAnimPath.count)
		FillSubAnimList()
	)
	
	on btnUse pressed do
	(
		if returnFnPtr != undefined then   --- returnIndex > 0 and 
		(
			newSubAnim = subAnimFinderStruct()
			newSubAnim.setSubAnimPath subAnimPath
			returnFnPtr newSubAnim index: returnIndex         --- a pointer to a function
		) else
		(
			--these values should have been set by the calling function
			messagebox "oops returnIndex or returnFnPtr have not been defined "
		)
		
		destroyDialog subAnimRoll
	)
)

-- createDialog KenzorsSubAnimRoll 400 300