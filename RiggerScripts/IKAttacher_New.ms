/*
the_weaponData = attributes weaponData
(
    parameters main rollout:params
    (
        hitPoints type: #float ui:hits default:10
        cost type: #float ui:cost default:100
        sound type: #string
    )
    rollout params "Weapon Parameters"
    ( 
        spinner hits "Hit Points" type: #float
        spinner cost "Cost" type: #float
        dropdownlist sound_dd "Sound" items:# ("boom","sparkle","zap","fizzle")
    )
)
custAttributes.add $ the_weaponData

*/

the_IKAttachNew = attributes IKAttachNew
(
    parameters main rollout:params 
    (
        /*
        IKTarget1 type:#String ui:(edtIK1)
        IKTarget2 type:#String ui:(edtIK2)
        IKTarget3 type:#String ui:(edtIK3)

        FKTarget1 type:#String ui:(edtFK1)
        FKTarget2 type:#String ui:(edtFK2)
        FKTarget3 type:#String ui:(edtFK3)
        */
		IKNode type:#String UI:(btnAddIKs)
        IKTargets type:#StringTab tabSize:1 tabSizeVariable:true UI:(mlbIKTargetList)
		FKNode type:#String UI:(btnAddFKs) 
		FKTargets type:#StringTab tabSize:1 tabSizeVariable:true  UI: (mlbFKTargetList)
		
		IKBones type:#StringTab tabSize:1 tabSizeVariable:true UI: (mlbIKBones)
		FKBones type:#StringTab tabSize:1 tabSizeVariable:true  UI: (mlbFKBones)

    )
    rollout params "Attach IK Nodes"
    (
-- 	on params open do 
-- 	(
-- 		mlbIKTargetList.items = (IKTargets as array )
-- 		mlbFKTargetList.items = (FKTargets as array) 
-- 	)
		
        /*
        editText edtIK1 "IK Target1"
        editText edtIK2 "IK Target2"
        editText edtIK3 "IK Target3"
        BUtton btnAttach "↓"
        editText edtFK1 "FK Goal1"
        editText edtFK2 "FK Goal2"
        editText edtFK3 "FK Goal3"
        */
		Button Redraw "ReDraw UI" 
		Label lb1 "-------Select Target&Goals-------" 
		
        PickButton btnAddIKs "ADD IK Targets"  across:2
		PickButton btnAddFKs "ADD FK Goals" 
		--Button btnRemoveIKs "Remove IK Targets" 
        MultiListBox mlbIKTargetList "IK Targets" across:2
		MultiListBox mlbFKTargetList "FK Goals" 
		Button btnRemoveIKs "Remove IK Targets" across:2
		Button btnRemoveFKs "Remove FK Targets" 
		--MultiListBox mlbFKTargetList "FK Goals" 
		
		
		
		Label lb2 "-------Select Bones-------" 
		
		pickButton btnAddIKBones "ADD IK Bones" across:2
		pickButton btnAddFKBones "ADD FK Bones"
		
		MultiListBox mlbIKBones "IK Bones" across:2 
		MultiListBox mlbFKBones "FK Bones" 

		button btnRemoveIKBones "Remove IK Bones" across:2
		button btnRemoveFKBones "Remove FK Bones"
		--MultiListBox mlbFKBones "FK Bones" 
		
		label lb4 "--------Attach--------"
		Button IKtoFK "Attach to FK" across:3
		label lb3 "<-------->" 
		Button FKtoIK "Attach to IK"

		--editText edtIKTargets "IK Targets"
		
		on params open do 
		(
			if IKTargets[1] != undefined do 
			(
				mlbIKTargetList.items = (IKTargets as array )
			)
			if FKTargets[1] !=undefined do 
			(
				mlbFKTargetList.items = (FKTargets as array) 
			)
			if IKBones[1] != undefined do 
			(
				mlbIKBones.items = (IKBones as array) 
			)
			if FKBones[1] != undefined do 
			(
				mlbFKBones.items = (FKBones as array)
			) 
		)
		
		on btnRemoveIKs pressed do 
		(
			undo on 
			(
				Try 
				(
					deleteItem IKTargets (mlbIKTargetList.selection as array)[1]
				)
				Catch
				(
					deleteItem IKTargets mlbIKTargetList.items.count
				)
				mlbIKTargetList.items = (IKTargets as array) 
			)
		)
		
		on btnRemoveFKs pressed do 
		(
			undo on 
			(
				Try 
				(
					deleteItem FKTargets (mlbIKTargetList.selection as array)[1]
				)
				Catch
				(
					deleteItem FKTargets mlbIKTargetList.items.count
				)
				mlbFKTargetList.items = (FKTargets as array) 
			)
		)
		
		on btnRemoveIKBones pressed do 
		(
			undo on
			(
				Try 
				(
					deleteItem IKBones (mlbIKBones.selection as array)[1]
				)
				Catch
				(
					deleteItem IKBones mlbIKBones.items.count
				)
				mlbIKBones.items = (IKBones as array) 
			)
		)
		
		on btnRemoveFKBones pressed do 
		(
			undo on 
			(
				Try 
				(
					deleteItem FKBones (mlbFKBones.selection as array)[1]
				)
				Catch
				(
					deleteItem FKBones mlbFKBones.items.count
				)
				mlbFKBones.items = (FKBones as array) 
			)
		)
		
		on btnAddIKs picked obj do 
		(
			undo on 
			(
				IKNode = obj.name 
				append IKTargets IKNode
				
				local findUndefined = findItem IKTargets undefined
				
				if findUndefined == 1 then 
				(
					deleteItem IKTargets 1
				)
				mlbIKTargetList.items = (IKTargets as array)
			)
		)
		
		on btnAddFKs picked obj do 
		(
			undo on
			(
				FKNode = obj.name 
				append FKTargets FKNode 
				
				local findUndefined = findItem FKTargets undefined
				
				if findUndefined == 1 then 
				(
					deleteItem FKTargets 1
				)
				mlbFKTargetList.items = (FKTargets as array)
			)
		)
		
		on IKtoFK Pressed do 
		(
			undo on
			(
				with Animate On 
				(
					for i=1 to IKTargets.count do 
					(
						(getNodeByName IKTargets[i]).transform = (getNodeByName FKTargets[i]).transform
					)
				)
			)
		)
		
		on btnAddIKBones picked obj do 
		(
			undo on 
			(
				append IKBones (obj.name)
				local findUndefined = findItem IKBones undefined
				if findUndefined == 1 then 
				(
					deleteItem IKBones 1
				)
				mlbIKBones.items = (IKBones as array)
			)
		)
		on btnAddFKBones picked obj do 
		(
			undo on 
			(
				append FKBones obj.name 
				local findUndefined = findItem FKBones undefined
				if findUndefined == 1 then 
				(
					deleteItem FKBones 1
				)
				mlbFKBones.items = (FKBones as array) 
			)
		)
		
		on FKtoIK pressed do 
		(
			undo on
			(
				With Animate on
				(
					for i=1 to IKBones.count do 
					(
						(getNodeByName FKBones[i]).transform = (getNodeByName IKBones[i]).transform
					)
				)
			)
		)

		on FKtoIKAni pressed do
		(
			undo on 
			(
				with Animate on 
				( 
					for i=startFrame.value to endFrame.value do
					(
						sliderTime = i
						for i=1 to IKTargets.count do 
						(
							(getNodeByName IKTargets[i]).transform = (getNodeByName FKTargets[i]).transform
						)
					)
					set Animate off 
				)
			)
		)
		
		on IKtoFKAni pressed do 
		(
			undo on 
			(
				with Animate on 
				(
					for i=startFrame.value to endFrame.value do
					(
						sliderTime = i
						for i=1 to IKBones.count do 
						(
							(getNodeByName FKBones[i]).transform = (getNodeByName IKBones[i]).transform
						)
					)
				)	
			)
		)
	)
)
custAttributes.add $ the_IKAttachNew