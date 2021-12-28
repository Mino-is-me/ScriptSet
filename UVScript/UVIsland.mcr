------------------------------------- UV Islands To Smoothing Groups -------------------------------------
-- By Martin Palko 
-- www.martinpalko.com
--
--
-- Tested:	- Max 2014
-- 
-- Install:	- Drag script into max, then assign it to a hotkey or menu bar in "Customize -> User Interface"
--			- Can be found by setting the category to "MP_Tools" while in the "Main UI" group
--
-- Usage:	- Select any mesh object, and activate the script. Choose a UV channel and hit run.
--
-- Notes:	- This script will not affect your modifier stack, it will simply put an edit poly with the 
--				smoothing groups at the top.
--			- Undo is not currently supported, so save before, just in case. You can however, just delete 
--				the edit poly modifier to get your old smoothing groups back.
--			- Selecting any channel other than UV channel 1 will show a dialogue box asking if you want to 
--				reset UVs. You must hit yes for it to work based on the channel you've specified. This 
--				will NOT affect the model's existing UV set.

macroscript UVIslandsToSmoothing 
category:"EVE"
buttontext:"UVSmooth"
tooltip:"Convert UV islands to smoothing groups"
autoUndoEnabled:false
(	
	-- Helper function to get the index of the first true element in a bit array
	function getFirstActiveInBitarray aBitArray =
	(
		for i = 1 to aBitArray.count do
		(
			if aBitArray[i] == true do return i
		)
		-- return 0 if none are found active
		return 0
	)

	-- Actually performs the operation on the currently selected object
	function ConvertUVIslandsToSmoothingGroups aUVChannel =
	(
		if $ != undefined then
		(			
			modPanel.addModToSelection(Edit_Poly()) ui:on
			local editPoly = $.modifiers[#edit_poly]
			
			local facesDone = #{} -- empty bit array since no faces are done
			local allFaces = #{1.. polyop.getNumFaces $}
			local facesNotDone = allFaces
			
			-- Stick on a UVW modifier
			modPanel.addModToSelection (Unwrap_UVW ()) ui:on
			local uv_modifier = $.modifiers[#unwrap_uvw]				
			uv_modifier.unwrap2.setTVSubObjectMode 3 -- Use face selection
				
			if (aUVChannel != 1) then -- Only need to mess with this if it's not default
			(
				uv_modifier.unwrap.setMapChannel aUVChannel
				uv_modifier.unwrap.reset()
				forcecompleteredraw dodisabled:true -- Hacky fix for a bug, see http://www.polycount.com/forum/showthread.php?t=97059
			)
				
			local uv_islands = #() -- Empty array that will store bitarrays of all our UV islands
			local abort = false -- Abort boolean for breaking out of the loop and avoid the performance penalty of using break
			
			-- Build array of UV islands
			while (facesNotDone.isEmpty == false and abort == false) do
			(				
				nextFace = getFirstActiveInBitarray facesNotDone -- Get next face that hasn't been processed yet
				
				uv_modifier.unwrap2.selectFaces #{nextFace} -- Select that face
				uv_modifier.unwrap2.selectElement() -- Grow selection to element
				uv_island = uv_modifier.unwrap2.getSelectedFaces()	-- Get a bitaray of all those faces (representing a UV island)
				
				-- Update faces done/not done bit masks
				facesDone += uv_island
				facesNotDone -= uv_island
				
				insertItem uv_island uv_islands (uv_islands.count + 1) -- Add that bitarray to our array of UV islands
				
				if uv_islands.count > allFaces.count then -- this should never happen, if it does means we are in an infinite loop and will crash max, so bail
				(
					abort = true
					print ("Error, calculated too many islands, something went wrong")
				)
			)
			
			deletemodifier $ uv_modifier -- Don't need the UV modifier anymore
			
			editPoly.autoSmoothThreshold = 180.0 -- If we auto smooth, it should always be in the same smoothing group
			
			for island = 1 to uv_islands.count do -- Select and auto smooth each UV island
			(
				editPoly.SetSelection #Face uv_islands[island]
				editPoly.ButtonOp #Autosmooth
			)
		)
	)
	
	local isOpen = false -- Store if the rollout is open or closed
	
	rollout UV2SmoothRollout "UV_2_Smooth"
	(
		spinner UVChannelSpinner "UV Channel" range:[1,99,1] type:#integer
		button GoBtn "        Run        "
		
		on GoBtn pressed do
		(
			ConvertUVIslandsToSmoothingGroups (UVChannelSpinner.value)
			destroyDialog UV2SmoothRollout -- Close rollout after running
		)
		
		on UV2SmoothRollout close do
		(
			isOpen = false
			updateToolbarButtons() -- Update the toolbar icon when closing
		)
	)
	
	on execute do
	(
		if isOpen then --if open, close it
		(
			destroyDialog UV2SmoothRollout
		)
		
		else --if closed, open it
		(
			createDialog UV2SmoothRollout
			isOpen = true
		)
	)
  
	on isChecked return isOpen --return the flag
	
	on isEnabled do
	(
		-- Need an editable poly selected to work
		if $ == undefined then
		(
			-- Close the window if it's open and it shouldn't be
			if (isOpen) then
				destroyDialog UV2SmoothRollout
			
			return false
		)
		else
			return true
	)
)