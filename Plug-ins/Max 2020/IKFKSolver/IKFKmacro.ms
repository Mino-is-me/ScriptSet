--This script goes in the plugin directory of 3ds max
MacroScript IKFK
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"IKFK Solver"
	Category:"Inverse Kinematics" 
	internalCategory:"Inverse Kinematics" 
	Tooltip:"IKFK Solver" 
	Icon:#("MainToolbar",49)
	SilentErrors:(Debug == undefined or Debug != True)
(
	fn IKFKFilter theNode=
	(
		local notfound=true
		local aux=theNode
		while notfound and aux!=undefined do
		(
			if aux.parent==$ then notFound=false
			aux=aux.parent
		)
		if notFound then
		(
			local aux=$
			while notfound and aux!=undefined do
			(
				if aux.parent==theNode then notFound=false
				aux=aux.parent
			)
		)
		not notFound
	)
	on isEnabled return selection.count == 1
	on execute do 
	(
		local secNode=pickObject message:"Pick node" pront:"Pick node" filter:IKFKFilter rubberBand:$.transform.position forceListenerFocus:false
		createikfk $ secNode
	)
)

animMenu=menuMan.findMenu "&Animation"
if (animMenu!=null) then
(
	subMenuIndex=1
	prevBatch=0
	theSubMenu=undefined
	for i=1 to animMenu.numItems() do
	(
		if (animMenu.getItem i).getTitle()=="&IK Solvers" then theSubMenu=(animMenu.getItem i).getSubMenu()
	)
	for i=theSubMenu.numItems() to 1 by -1 do
	(
		local actionTitle=((theSubMenu.getItem i).getTitle())
		if actionTitle=="IKFK Solver" then 
			theSubMenu.removeItemByPosition i
	)
	theSubMenu.addItem (menuMan.createActionItem "IKFK" "Inverse Kinematics") 4 --add the ActionItem to the menu
	menuMan.updateMenuBar() --update the menu bar
)

callbacks.addScript #preSystemShutdown "deletefile ((getdir #maxroot)+\"plugins\IKFKmacro.ms\")"