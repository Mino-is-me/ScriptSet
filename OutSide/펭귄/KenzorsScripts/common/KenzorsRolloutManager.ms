/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- version 1.1
-- KenzorsRolloutManagerStruct
-- By ken turner
-- www.designimage.co.uk

09/12/2017 -- 3dsmax 2017 rollout bug fix

-- dot net reference http://www.scriptspot.com/bobo/mxs9/dotNet/dotNetObject_System.Windows.Forms.TabControl.html

-- generic rollout tools and about me info

*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Struct KenzorsRolloutManagerStruct
(

	floaterName = "",
	floaterWidth = 200,
	RolloutArray = #(),
	myFloater = undefined,
	wwwMyHelp = "http://www.designimage.co.uk/category/3dsmax/maxscripts/" ,
	fn GetHelp =
	(
		process=dotnetclass "System.Diagnostics.Process"
		process.start wwwMyHelp
	),
	fn setFloaterSize =
	(
		myFloater.size.y = 
		(
			h = 3
			for r in RolloutArray do ( h = h + (if r.IsRolledOut then r.height + 25 else 21) )
			h
		)
	),
	fn closeUp =
	(
		if myFloater != undefined do closerolloutfloater myFloater 
	),
	fn Initalize =
	(
		myFloater = NewRolloutFloater floaterName floaterWidth 100
		for roll in RolloutArray do
		(
			AddRollout roll myFloater rolledup:(not roll.isRolledOut) 
			roll.rolledUpEventFn = this.setFloaterSize
		)
		setFloaterSize()
	)
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rollout KenzorsAboutMeRoll "About"
(
	-------------------------------------------------------------------- required for kenzorsRolloutManager
	Local isRolledOut = false
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on KenzorsAboutMeRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn())
	-------------------------------------------------------------------------------------------------------------
	local KenzorsLogoBmp = openBitmap "$userscripts/KenzorsScripts/Common/Images/Logo_32.bmp"
	button btnWebLink "" images:#(KenzorsLogoBmp, undefined, 1,1,1,1,1 ) across:2
	button btnGetHelp "View Help"
	local wwwHelp = "http://www.designimage.co.uk/category/3dsmax/maxscripts/"
	on btnWebLink pressed do 
	(
		process=dotnetclass "System.Diagnostics.Process"
		process.start "http://www.designimage.co.uk"
	)
	on btnGetHelp pressed do 
	(
		process=dotnetclass "System.Diagnostics.Process"
		process.start wwwHelp
	)

)