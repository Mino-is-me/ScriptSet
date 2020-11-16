MacroScript MorphTargetBuilder
            category:"Griffs Game Dev" 
            Tooltip:"Morph Target Builder" 
            Buttontext:"MTB"
(	-- Morph Target Builder v1.1 by Griffs Game Dev 6/29/2017
	-- This utility assists in building morph targets to match skin morphed topologies.
	-- Update v1.1:  Changed logic to use the biggest weight of each vertex rather than an average.
	
	try destroyDialog MorphTargetBuilder catch()
	
	-- Variables
	local MorphTargetBuilder
	local sPoly
	local gPoly
	local cPoly
-- 	local vSkinTransformP1 = #(matrix3 [0,0,0] [0,0,0] [0,0,0] [0,0,0])
-- 	local vSkinTransformP2 = #(matrix3 [0,0,0] [0,0,0] [0,0,0] [0,0,0])
	local vSkinTransformP1 = #()
	local vSkinTransformP2 = #()
	
	-- Structures
	struct SkinInfo_struct (boneTf, boneWeight)
	
	-- Functions
	function validate_sPoly tpoly = 
	( -- validate the picked Skinned poly
		vStatus = 0
		bStatus = 0
		mStatus = 0
		sStatus = 0
		vcStatus = 0
		if classof tpoly.baseobject  == Editable_Poly then bStatus = 1
		for i in tpoly.modifiers do
		(
			if classof i == Skin then sStatus = 1
			if classof i == Morpher then mStatus = 1
		)
		if gPoly == undefined then vcStatus = 1
			else if polyOp.GetNumVerts tpoly == polyOp.GetNumVerts gPoly then vcStatus = 1
		if bStatus + mStatus + sStatus + vcStatus == 4 then vStatus = 1
			else messagebox "Not a valid Skinned Poly.  The base object must be an editable poly, with a morpher modifier then a skin modifier.  The vertex count must also match the Goal Poly's."
		vStatus
	)
	
	function validate_gPoly tpoly = 
	( -- validate the picked Goal poly
		vStatus = 0
		bStatus = 0
		mStatus = 0
		vcStatus = 0
		
		if classof tpoly.baseobject  == Editable_Poly then bStatus = 1
		if tpoly.modifiers.count == 0 then mStatus = 1
		if gPoly == undefined then vcStatus = 1
			else if polyOp.GetNumVerts tpoly == polyOp.GetNumVerts sPoly then vcStatus = 1
		if bStatus + mStatus + vcStatus == 3 then vStatus = 1
			else messagebox "Not a valid Goal Poly.  The base object must be an editable poly with no modifiers.  The vertex count must also match the Skinned Poly's."
		vStatus
	)
	
	function validate_cPoly tpoly = 
	( -- validate the current poly
		1
	)
	
-- 	function getSkinMatrix skinInfo = 
--	(	
-- 		totalTF = (matrix3 [0,0,0] [0,0,0] [0,0,0] [0,0,0])
-- 		biggestWeight = 0
-- 		for i = 1 to skinInfo.count do 
-- 		(
-- 			totalTf[1] = totalTf[1] + skinInfo[i].boneTf[1] * skinInfo[i].boneWeight
-- 			totalTf[2] = totalTf[2] + skinInfo[i].boneTf[2] * skinInfo[i].boneWeight
-- 			totalTf[3] = totalTf[3] + skinInfo[i].boneTf[3] * skinInfo[i].boneWeight
-- 			totalTf[4] = totalTf[4] + skinInfo[i].boneTf[4]
-- 		)
-- 		totalTf[1] =  (totalTF[1] / skinInfo.count)
-- 		totalTf[2] =  (totalTF[2] / skinInfo.count)
-- 		totalTf[3] =  (totalTF[3] / skinInfo.count)
-- 		totalTf[4] = totalTF[4] / skinInfo.count
-- 		for i = 1 to skinInfo.count do
-- 		(
-- 			if skinInfo[i].boneWeight > biggestWeight then 
-- 			(
-- 				biggestWeight = skinInfo[i].boneWeight
-- 				totalTF[1] = skinInfo[i].boneTF[1] * skinInfo[i].boneWeight
-- 				totalTF[2] = skinInfo[i].boneTF[2] * skinInfo[i].boneWeight
-- 				totalTF[3] = skinInfo[i].boneTF[3] * skinInfo[i].boneWeight
-- 				totalTF[4] = skinInfo[i].boneTF[4]
-- 			)
-- 		)
-- 		matrix3 totalTf[1] totalTf[2] totalTf[3] totalTf[4]
-- 	)
	
	function getSkinData = 
	( -- Build an array of transforms matched to vertex id using skin weighting info
		vSkinTransform_tmp = #(SkinInfo_struct)
		
		for i = 1 to polyOp.GetNumVerts $ do
		(
			vBones = skinOps.GetVertexWeightCount $.modifiers[#Skin] i
			biggestBoneWeight = 0
			biggestBoneTf = (matrix3 [0,0,0] [0,0,0] [0,0,0] [0,0,0])
			boneWeight = 0
			boneName = ""
			boneTf = (matrix3 [0,0,0] [0,0,0] [0,0,0] [0,0,0])
			objs = objects as array
			
			if vBones > 0 then
			(
				for j = 1 to vBones do
				(
					boneWeight = skinOps.GetVertexWeight $.modifiers[#Skin] i j
					boneName =  skinOps.GetBoneName $.modifiers[#Skin] (skinOps.GetVertexWeightBoneID $.modifiers[#Skin] i j) 0
					for k = 1 to objs.count do -- find skin bone (or whatever) in scene to get transform
					(
						if objs[k].name == boneName then
						(
							boneTf = objs[k].transform
							exit
						)
					)
					if boneWeight > biggestBoneWeight then
					(
						biggestBoneWeight = boneWeight
						biggestBoneTf = boneTf
					)
				)
				vSkinTransform_tmp[i] = SkinInfo_struct boneTf:biggestBoneTf boneWeight:biggestBoneWeight
			)
			else
			(
				vSkinTransform_tmp[i] = SkinInfo_struct boneTf:$.transform boneWeight:1
			)
		)
 		vSkinTransform_tmp
	)
	
	-- Rollouts
	rollout MorphTargetBuilder "Morph Target Builder"
	(
		label sPoly_lbl "Skinned Poly:" across:2 align:#left 
		pickbutton sPoly_pbtn	">>Pick Skinned Poly<<" width:160 align:#right autoDisplay:true tooltip:"The Editable Poly object with the morpher and skin modifiers."
		label gPoly_lbl "Goal Poly:" across:2 align:#left
		pickbutton gPoly_pbtn ">>Pick Goal Poly<<" width:160 align:#right autoDisplay:true tooltip:"The Editable Poly object with the correct shape."
		label dLine1 "------------------------------------------------------------"
		button setSkinPose_btn "Get Skin Pose Data" across:2 align:#left enabled:false
		button setDesiredPose_btn "Get Desired Pose Data" align:#right enabled:false
		label dLine2 "------------------------------------------------------------"
		slider pLevel_sdr "Precision Level" range:[1,0.0001,0.5] type:#float orient:#horizontal
		label pLevel_lbl "0.5" across:2 align:#left
		button moveVerts_btn "Move Selected Vertices" align:#right
		
		on sPoly_pbtn picked tpoly do 
		(
			if validate_sPoly tpoly == 1
				then 
				(
					sPoly = tpoly
					setSkinPose_btn.enabled = true
					setDesiredPose_btn.enabled = true
				)
				else 
				(
					sPoly = ()
					sPoly_pbtn.object = ()
					setSkinPose_btn.enabled = false
					setSkinPose_btn.text = "Get Skin Pose Data"
					setDesiredPose_btn.enabled = false
					setDesiredPose_btn.text = "Get Desired Pose Data"
				)
		)
		
		on gPoly_pbtn picked tpoly do 
		(
			if validate_gPoly tpoly == 1
				then gPoly = tpoly
				else 
				(
					gPoly = ()
					gPoly_pbtn.object = ()
				)
		)
		
		on setSkinPose_btn pressed do
		(
			cSel = $
			select sPoly
			max modify mode
			modPanel.setCurrentObject $.modifiers[#Skin]
			vSkinTransformP1 = getSkinData()
			if cSel != undefined then select cSel
			setSkinPose_btn.text = "Skin Pose Loaded"
		)
		
		on setDesiredPose_btn pressed do
		(
			cSel = $
			select sPoly
			max modify mode
			modPanel.setCurrentObject $.modifiers[#Skin]
			vSkinTransformP2 = getSkinData()
			if cSel != undefined then select cSel
			setDesiredPose_btn.text = "Desired Pose Loaded"
		)
		
		on pLevel_sdr changed sVal do (pLevel_lbl.text = sVal as string)
		
		on moveVerts_btn pressed do
		(
			if ($ != undefined) and (sPoly != undefined) and (gPoly != undefined) then
			(
				cPoly = selection[1]
				cSelection = polyOp.getVertSelection cPoly
				pLevel = [1,1,1] * pLevel_sdr.value
				
				for i in cSelection do
				(
					if cSelection[i] == true then
					(
						loopSafety = 1
						do 
						(
							in coordsys vSkinTransformP2[i].boneTf sVPos = polyOp.getVert sPoly i 
							in coordsys vSkinTransformP2[i].boneTf gVPos = polyOp.getVert gPoly i 
							goalDistance = gVPos - sVPos
							goalDistance = goalDistance * vSkinTransformP1[i].boneWeight
							
							in coordsys vSkinTransformP1[i].boneTf polyOp.moveVert cPoly i goalDistance
							
							loopSafety = loopSafety + 1
						)
						while length goalDistance >= length pLevel and loopSafety <= 50
					)
				)
			)
			
		)
	)
	createDialog MorphTargetBuilder 265 205
)