fileIn ( "$userscripts/KenzorsScripts/Common/dnListViewWithDragDropStruct.ms")

KenzorsGroupObjectWrapperStruct = undefined
KenzorsGenericObjectWrapperStruct = undefined
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------- MaterialControlStruct
struct KenzorsMaterialControlStruct 
(
	filePath = ( GetDir #matlib) ,
	tmpMatLib = currentMaterialLibrary,
	fn fixPath txt =
	(
		txt = trimleft ( trimRight txt ) -- remove surrounding spaces
		for i = 1 to txt.count where txt[i] == "\\" do txt[i] = "/"
		txt
	),
	fn loadMatLibrary =
	(
		tmpMatLib = loadTempMaterialLibrary filePath
	),
	fn SetMaterialPath txt =
	(
		newpath = (if txt == undefined then "" else (FixPath txt) ) 
		if ( txt != undefined ) and ( doesFileExist newpath ) do
		(
			filePath = newPath
			loadMatLibrary()
		)
	),
	fn getRandomMaterialFromLibrary =
	(
		n = tmpMatLib.count 
		if n > 0 then 
		(
			i = random 1 n 
			tmpMatLib[i]
		) else undefined
	),
	fn setARandomMaterialFromLibraryToNodesInThisList theNodeList =
	(
		if tmpMatLib.count  > 0 then
		(
			for obj in theNodeList do obj.material = getRandomMaterialFromLibrary()
		)
	),
	fn BrowseAndLoadLibrary  =
	(
		fileType = "mat"
		txt = getOpenFileName fileName:filePath Caption:("Pick ."+fileType +" file" ) Types:("*." + fileType +"|*."+fileType +"|")
		if ( txt != undefined ) and ( doesFileExist txt ) do
		(
			SetMaterialPath txt 
		)
	),
	fn getMaterialLibraryPath = filePath,
	fn getMaterialCount =
	(
		tmpMatLib.count
	),
	
	-------------------------------------------------------------------------------------------
	fn setUniqueObjectIdToThisNodeList theNodeList =
	(
		allObjects = geometry as array
		-- remove theNodeList from allObjects
		tmpNodeList = copy theNodeList #noMap  --- #noMap stops objects being cloned in the scene
		for i = allObjects.count to 1 by -1 while ( tmpNodeList.count > 0 ) do
		(
			for j = tmpNodeList.count to 1 by -1 where allObjects[i] == tmpNodeList[j] do
			(
				deleteItem allObjects i
				deleteItem tmpNodeList j
			)
		)
		existingIdArray = #{}
		existingIdArray[65535] = false -- set the size of the array
		for obj in allObjects where ( obj.gbufferChannel > 0  ) do
		(
			existingIdArray[obj.gbufferChannel] = true
		)
		newIdArray = -existingIdArray 
		objectCount = theNodeList.count
		i = 1
		for id in newIdArray while i <= objectCount do 
		(
			theNodeList[i].gbufferChannel = id
			i += 1
		)
	)
)
-------------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: MaterialControlStruct
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------- KenzorsGenericObjectWrapperStruct
struct KenzorsGenericObjectWrapperStruct
(
	theNode = undefined,
	wt = 1.0,
	fn getWtAsString = wt as string,
	fn getName = theNode.name as string,
	fn CloneMeBy cloneType:#copy =
	(
		newList = #()
		maxOps.CloneNodes theNode cloneType:cloneType newNodes:&newList
		KenzorsGenericObjectWrapperStruct (newList[1]) 
	),
	fn selectMe = select theNode,
	fn SetTmTo theTM = ( theNode.transform = theTm )
)
--------------------------------------------------------------------------------------------------------------------------------------------- END OF: KenzorsGenericObjectWrapperStruct
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------- KenzorsGenericObjectWrapperStruct
struct KenzorsGroupObjectWrapperStruct
(
	theGroupHead = undefined,
	objectList = #(),
	wt = 1.0,
	fn getWtAsString = wt as string,
	fn getName = theGroupHead.name as string,
	fn getObjectListNames = for obj in objectList collect obj.name as string,
	fn CloneMeBy cloneType:#copy =
	(
		newList = #()
		maxOps.CloneNodes objectList cloneType:cloneType newNodes:&newList
		KenzorsGroupObjectWrapperStruct (newList[1]) newList
	),
	fn selectMe = select theGroupHead,
	fn SetTmTo theTM = 
	(
		theGroupHead.transform = theTm
	),
	fn FindGroupHead theObj = 
	(
		if ( ( isGroupHead theObj ) and ( not (isGroupMember theObj) ) ) then  --- isGroupMember returns false if isGroupHead true
		(
			return theObj
		)else 
		(
			if (isGroupMember theObj) then 
			(
				FindGroupHead ( theObj.parent )
			) else (return undefined)
		)
	),
	fn CollectMemberObjectsFromThisObj theObj=
	(
		childList = theObj.children
		childList = for obj in childList where ( ( isGroupMember obj ) and ( not isGroupHead obj ) ) collect obj
		if childList.count > 0 then 
		(
			join objectList childList
			for obj in childList do ( CollectMemberObjectsFromThisObj obj)
		)
	),
	fn CollectGroupFromThisObject theObj =
	(
		if ( theGroupHead = ( FindGroupHead theObj ) ) != undefined then
		(
			objectList = #(theGroupHead)
			CollectMemberObjectsFromThisObj theGroupHead
			true
		) else false
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------- END OF: KenzorsGenericObjectWrapperStruct
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- SourceObjectsToCopyStruct
struct SourceObjectsToCloneStruct
(
	SourceObjectsList = #(),
	cloneType = #instance,
	sourceObjIndex = 1,
	fn null = true,
	fn getRandomSourceObjectIndex = (sourceObjIndex = random 1 SourceObjectsList.count),
	fn getNextSourceObjectIndex = ( if ( sourceObjIndex += 1 )  > SourceObjectsList.count then sourceObjIndex = 1 ),
	IncrementSourceObjectIndexFn = getNextSourceObjectIndex,
	fn setIncrementSourceObjectIndexFnAs theFnID =
	(
		case theFnID of
		(
			1: ( IncrementSourceObjectIndexFn = null )
			2: ( IncrementSourceObjectIndexFn = getRandomSourceObjectIndex )
			3: ( IncrementSourceObjectIndexFn = getNextSourceObjectIndex )
		)
	),
	fn GetSourceListNames = 
	(
		namelist = for theObj in SourceObjectsList collect theObj.getName()
	),
	fn SetCloneTypeId newCloneTypeId =
	(
		cloneType = case newCloneTypeId of
		(
			1:#copy
			2:#instance
			3:#reference
		)
	),
	fn getNewObject = -- inThisLayer:(LayerManager.current)
	(
		IncrementSourceObjectIndexFn()
		( SourceObjectsList[sourceObjIndex]  ).CloneMeBy cloneType:cloneType
	),
	fn AddObjectToSourceList theObj =
	(
		testWrapper = KenzorsGroupObjectWrapperStruct()
		if not ( testWrapper.CollectGroupFromThisObject theObj ) then ( testWrapper = KenzorsGenericObjectWrapperStruct theObj )
		append SourceObjectsList testWrapper  --- ToDo: if unique ?
	),
	fn AddSelectionToSourceList objSet:selection =
	(
		 for theObj in objSet do ( AddObjectToSourceList theObj )
	),
	fn	RemoveSourceItemsByIndex indexBitArray =
	(
		n = SourceObjectsList.count
		for i = n to 1 by -1 where indexBitArray[i] do
		(
			deleteItem SourceObjectsList i
		)
	),
	fn SetSourceObjectsList newObjList =
	(
		newObjList = #()
		AddSelectionToSourceList objSet:newObjList
	),
	fn GetSourceObjectsList = SourceObjectsList,
	fn selectObjectWithIndex i = (SourceObjectsList[i]).selectMe()
)
-------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: SourceObjectsToCopyStruct
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ObjectListRoll
rollout ObjectListRoll "New Object List"
(
	-------------------------------------------------------------------- required for kenzorsRolloutManager
	Local isRolledOut = true
	local rolledUpEventFn = undefined
	on ObjectListRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) 
	-------------------------------------------------------------------------------------------------------------
	local sourceObjectsToClone = SourceObjectsToCloneStruct()  
		
	PickButton pckObjectAndAddToList "Pick Object " width:90 Align:#Left 
	Button BtnAddAllSelectedToList "Add selection" width:90 Align:#Left 
	Button BtnRemoveObjectsFromList "Remove" width:90 Align:#Left 
	
	radioButtons RBtnsCloneType "New objects is:" labels:#("copy","instance","referance") columns:1 Default:2 Align:#Left Offset:[0,5]
	radioButtons RBtnsNextType "Next object is:" labels:#("same","Random","Sequence") columns:1 Default:2 Align:#Left Offset:[0,5]
		
	fn myfillFn obj = 
	( 
		#( ( obj.getName() ) ,( obj.getWtAsString() ))
	)

	dotNetControl dnListObjects "System.Windows.Forms.ListView"  width:167 height:230 align:#right Offset:[5,-220]
	Local DnList = ( dnListViewWithDragDropStruct dnListObjects myfillFn &sourceObjectsToClone.sourceObjectsList )
	
	fn RefeshRollout =
	(
		DnList.fill()
	)
	on ObjectListRoll open do 
	(
		DnList.init  #(#("Name",160)  ) chkBx:false multi:false drop:True
		RefeshRollout()
	)
	------------------------------------------------------------------------------------------------------------------------
	on dnListObjects mousedown args do 
	(
		DnList.SelectAndHighLightMousePosition()
		--- DnList.setBtn args
		if DnList.selectedRow > 0 then
		(
			sourceObjectsToClone.selectObjectWithIndex ( DnList.selectedRow )

		)  else 
		(
			---
		)
	)
	------------------------------------------------------------------------------------------------------------------------ Drag and drop List View Item	
	on dnListObjects DragDrop arg do 
	(
		if ( dnList.lvDragDrop arg ) do
		(
			print arg
			--PrevisTransportRoll.SetCurrentClipIndex DnList.selectedRow 
			RefeshRollout() 
			--PrevisTransportRoll.writeClipListToPrevisNode()
		)
	)
	on dnListObjects DragOver Arg do dnList.lvDragOver arg
	on dnListObjects ItemDrag arg do dnList.lvItemDrag arg
	
	------------------------------------------------------------------------------------------------------------------------------
	
	on RBtnsCloneType changed val do sourceObjectsToClone.setCloneTypeId val 
	on RBtnsNextType changed val do sourceObjectsToClone.setIncrementSourceObjectIndexFnAs Val 
	On BtnAddAllSelectedToList pressed do 
	(
		sourceObjectsToClone.AddSelectionToSourceList()
		RefeshRollout()
	)
	On BtnRemoveObjectsFromList pressed do
	(
		sourceObjectsToClone.RemoveSourceItemsByIndex ( #{ DnList.selectedRow } )
		RefeshRollout()
	)
	on pckObjectAndAddToList picked obj do
	(
		sourceObjectsToClone.AddObjectToSourceList Obj
		RefeshRollout()
	)
	
)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------ END OF: ObjectListRoll
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


