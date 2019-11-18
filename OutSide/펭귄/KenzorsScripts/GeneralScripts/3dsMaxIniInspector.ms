/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- version 1.0
-- 3dsmax.ini Browser
-- By ken turner
-- www.designimage.co.uk

----- version history -------

------ Notes -------
http://paulneale.com/tutorials/dotNet/treeView/dotNetTreeView.htm
http://www.scriptspot.com/bobo/mxs9/dotNet/DotNetControls.html
shellLaunch  (GetDir  #maxData ) ""  --- opens a bowser window with the 3dsmax.ini file

------- toDo -------
*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if KenzorsIniBrowserManager != undefined then KenzorsIniBrowserManager.closeup()
KenzorsIniBrowserManager = undefined
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ File In ----------------------

fileIn ( "$userscripts/KenzorsScripts/Common/kenzorsRolloutManager.ms" )

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

rollout KenzorsIniBrowserRoll "3dsmax.ini Browser"
(
	----------------------------------------------------------------------------- required for kenzorsRolloutManager --------------------
	Local isRolledOut = true --- required varible for kenzorsRolloutManager
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on KenzorsIniBrowserRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) --- required function for kenzorsRolloutManager
	------------------------------------------------------------------------------------------------------------------------------------------
	local theIniFile = getMAXIniFile() 
	local currentSection = undefined
	------------------------------------------------------------------------------------------------------------------------------------------	
	dotNetControl tv "TreeView" width: 390 height:400 align:#center	
	button btnSave "Save settings" enabled:false
	button btnLoad "Load settings"
	button btnShowFolder "explore 3dsMax.ini location"

	------------------------------------------------------------------------------------------------------------------------------------------
	fn fillInTreeView tv =
	(
		sectionList = getINISetting theIniFile
		sort sectionList

		for theSection in sectionList do
		(
			theNode = tv.Nodes.add theSection
			theNode.tag = dotNetMXSValue theSection
			stringList = getINISetting theIniFile theSection
			for theString in stringList do
			(
				stringNode = theNode.Nodes.add (theString + " " + ( getINISetting theIniFile theSection theString ) )
				stringNode.tag = dotNetMXSValue theSection
			)
		)
	)	
	------------------------------------------------------------------------------------------------------------------------------------------
	fn WriteAllParametersIn sectionName: fromIniFile: toIniFile: =
	(
		stringList = getINISetting fromIniFile sectionName
		for theString in stringList do
		(
			setINISetting toIniFile sectionName theString ( getINISetting fromIniFile sectionName theString ) 
		)	
	)
	
	fn BrowseAndSaveThe sectionName  =
	(
		fPath = getSaveFileName  Caption:("Save "+ sectionName + "to .ini file" ) Types:("*.ini|*.ini|")  -- fileName:filePath
		if fPath != undefined do
		(
			if not (doesFileExist fPath) then
			(
				fStream = createFile fPath
				close fStream
			)
			WriteAllParametersIn sectionName:sectionName fromIniFile:theIniFile toIniFile:fPath
		)
	)
	
	fn BrowseAndLoadAllSections =
	(
		fPath = getOpenFileName Caption:("Pick .ini file" ) Types:("*.ini|*.ini|")  -- fileName:filePath
		if fPath != undefined do
		(
			theFileName = getFilenameFile fpath
			
			if (queryBox ( theFileName + " settings will replace existing 3dsMax.ini settings. Are you sure?" ) ) do
			(
				sectionList = getINISetting theIniFile
				for theSection in sectionList do
				(
					WriteAllParametersIn sectionName:theSection fromIniFile:fPath toIniFile:theIniFile
				)
			)
		)
	)
	------------------------------------------------------------------------------------------------------------------------------------------
	
	-------------------------------------------------------------------------------------------------------------------------- UI Events ---
	on tv mouseDown arg do
	(
		-- showProperties arg	--Show the properties for the argument
		-- print arg.location	--Instead of using the X and Y value to create a point the location returns on. 
		-- print (tv.GetNodeAt arg.location) --Get the node under the mouse
		-- showProperties (tv.GetNodeAt arg.location)
		-- print (tv.GetNodeAt arg.location).text	--Get the text
		-- print (tv.GetNodeAt arg.location).Index	--The index of the node.	
		currentSection = (tv.GetNodeAt arg.location).tag.value
		tv.SelectedNode  = tv.GetNodeAt arg.location
		if currentSection != undefined then 
		(
			btnSave.text = "Save " + currentSection + " Settings"
			btnSave.enabled = true
		)else btnSave.enabled = false		
	)

	on KenzorsIniBrowserRoll open do
	(
		tv.Indent= 28 
		fillInTreeView tv
	)
	on btnSave pressed do BrowseAndSaveThe currentSection
	on btnLoad pressed do BrowseAndLoadAllSections()
	on btnShowFolder pressed do ( shellLaunch  (GetDir  #maxData ) ""  )
)
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

KenzorsIniBrowserManager = KenzorsRolloutManagerStruct  "3dsMax ini file browser" 400 #( KenzorsAboutMeRoll,  KenzorsIniBrowserRoll )
KenzorsIniBrowserManager.Initalize()
KenzorsAboutMeRoll.wwwHelp = "http://www.designimage.co.uk/backup-and-restore-3dsmax-settings/"

