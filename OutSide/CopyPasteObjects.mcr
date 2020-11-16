--Copy and Paste Obects
-- version 0.21
--Christopher Grant, www.christophergrant.com | www.scriptspot.com
--
--DESCRIPTION: 
--	It's always annoyed me that I couldn't copy objects from one instance of max and paste them
--  into another, as I work with 2 or 3 instances of max up at a time. It's tedious to do a save 
--  selected / merge objects so this script does it for you. It's not a TRUE copy/paste via the 
--  windows clipboard, but it will let you very quickly copy objects from one file to another.
--
--USAGE:
--  Select the objects you want to copy. Run 'copy script' (I assign mine to Ctrl+Shift+C). Now run the 'paste script' 
--  (I assign mine to Ctrl+Shift+V) into either the same file or you can load another instance of max and 'paste' the objects into it.
--
--INSTALLATION:
-- 1. Click Maxscript / Run Script and choose wherever you downloaded this file to
-- 	1a. It will seem like nothing happened but that's exactly what it should do, you now need to assign a shortcut to it
-- 2. Click Customize / Customize User Interface / Keyboard (tab)
-- 3. Change the Category to "CG_Tools"
-- 4. Click "Copy Objects to File" and change its Hotkey to something, maybe Ctrl+Alt+C .Click Assign
-- 5. Click "Paste Objects from File" and change its Hotkey to something, maybe Ctrl+Alt+V. Click Assign
-- 6. Click Save and save your custom UI settings to a file, do yourself a favor and don't use the default.
-- 7. That's it.
--
--HISTORY:
-- 
-- 05-02-28: first rev...
-- 05-03-11: fixed a problem that kept the script from working... I can't believe I didn't catch this before first release, 
--   		   as it was erroring out and not working because my variables were out of scope...
-- 09-02-03: changed credit in header
--------------------------------
macroScript Copy_Objects_To_File Category:"CG_Tools" toolTip:"Copy"
(
	thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
	thecopypastefile = "\pastefile.max" --this is the filename to save as...
	thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string
	
	if $ != undefined do 
		saveNodes $ thecopypastestring --this saves ("copies") the objects as a file
)

macroScript Paste_Objects_From_File Category:"CG_Tools" toolTip:"Paste"
(
	thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
	thecopypastefile = "\pastefile.max" --this is the filename to save as...
	thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string

	mergemaxfile (thecopypastedir + thecopypastefile) #select --this merges ("pastes") and selects objects from file
)