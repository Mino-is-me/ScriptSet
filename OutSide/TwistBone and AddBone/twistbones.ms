
/*
macroScript chainTools
	category:"Custom tools"
	icon:#("Radiosity", 3)
	
	setTransformLockFlags selObj #{1..9} --오브젝트 락
	
	offsetTm = ((transMatrix ((inverse $'Bip01 Pelvis'.transform) *  (rotateXMatrix 180 * rotateYMatrix -90) ).row4) * (rotateXMatrix 180 * rotateYMatrix -90))
	--피겨상태에서 구해야함 애니메이션된 Bip Pelvis에서 Bip Thigh의 값을 구하기 위한 기준이되는 matrix3 구하기
	펠비스b * inverse 펠비스a 로 펠비스 변화값을구한후 위에 적용?
	ZeroLTm = $'Bip01 L Thigh'.transform
	-- 피겨상태의 Bip01 L Thigh의 matrix3
	$'Bip01 Pelvis'.transform * offsetTm * ZeroLTm
	
	*/
	
(
	rollout TBPersiana "Add Bones Setup"
	(


	 function TBSetFunction n	buttonState	=
	 (

	 
	  bipRoots=#() --여러개의 bip를 선택 하였을 경우 com을 어레이로 저장한다.
	  bipLimbs=#() --롤아웃 패널에서 입력한 트위스트본 갯수와 지정할 이름이 저장될 어레이

	  
	  
	  bipLimbs[1]=#(#larm,2,n[1],1," L UpperArm")
	  bipLimbs[2]=#(#rarm,2,n[1],1," R UpperArm")
	  bipLimbs[3]=#(#larm,3,n[2],2," L ForeArm")
	  bipLimbs[4]=#(#rarm,3,n[2],2," R ForeArm")
	  bipLimbs[5]=#(#lleg,1,n[3],3," L Thigh")
	  bipLimbs[6]=#(#rleg,1,n[3],3," R Thigh")
	  bipLimbs[7]=#(#lleg,2,n[4],4," L Calf")
	  bipLimbs[8]=#(#rleg,2,n[4],4," R Calf")
	  

	  
	  
	  
	  TBExpressionA="try(
	TM=Limb.transform*inverse Limb.parent.transform
	vector=normalize (cross TM.row1 [1,0,0])
	angle=acos (normalize TM.row1).x
	(quat angle vector)*inverse TM.rotation)
catch((quat 0 0 0 1))"
	 --UpperArm Twist 의 스크립트구문

	  
	  
	  TBExpressionBa="try(
	TM=(matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0])*Limb.transform*inverse Limb.parent.transform
	vector=normalize (cross TM.row1 [1,0,0])
	angle=acos (normalize TM.row1).x
	TM.rotation*(quat -angle vector))
catch((quat 0 0 0 1))"
	 --R ForeArm Twist 의 스크립트구문
	  TBExpressionBb="try(
	TM=(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0])*Limb.transform*inverse Limb.parent.transform
	vector=normalize (cross TM.row1 [1,0,0])
	angle=acos (normalize TM.row1).x
	TM.rotation*(quat -angle vector))
catch((quat 0 0 0 1))"
	 --L ForeArm Twist 의 스크립트구문
	  


	  TBExpressionC="try(
	TM=Limb.transform*inverse Limb.parent.transform
	vector=normalize (cross -TM.row1 [1,0,0])
	angle=acos -(normalize TM.row1).x
	(quat 0 1 0 0)*(quat angle vector)*inverse TM.rotation)
catch((quat 0 0 0 1))"
	  --Thigh Twist 의 스크립트구문
	  TBExpressionD="try(
	TM=Limb.transform*inverse Limb.parent.transform
	vector=normalize (cross TM.row1 [1,0,0])
	angle=acos (normalize TM.row1).x
	TM.rotation*(quat -angle vector))
catch((quat 0 0 0 1))"
	 --Calf Twist 의 스크립트구문
	  

	  
	  
	  
	  TBExtraExpressionA="try(
	(Limb.transform*inverse LimbParent.transform).rotation
	)
catch((quat 0 0 0 1))"
	  --UpperArm, Thigh 의 하위 트위스트본의 구문

	  
	  
	  TBExtraExpressionB="try(dependson TB
	TB.rotation.controller[1].value
	)
catch((quat 0 0 0 1))"
	 -- ForeArm, Calf 의 하위 트위스트본의 구문
	
	  LimbJointExpression = "try(
	Tm = (limb.transform* inverse limb.parent.transform)
	vector=normalize (cross TM.row2 [0,1,0])
	angle=(acos (normalize TM.row2).y)/2
	(quat angle vector))*inverse TM.rotation
catch((quat 0 0 0 1))"
	-- Elbow, Knee 보정 더미의 구문 (스크립트 컨트롤러 대신 컨스트레인을 사용해도됨)
	
	  LimbShoulderExpression ="try(
	Tm = (limb.transform* inverse limb.parent.transform)
	vector = normalize (cross TM.row1 [1,0,0])
	angle = (acos (normalize TM.row1).X)
	local quat1= (quat angle vector) , quat2=(TM.rotationpart)
	local dot = quat1.x*quat2.x + quat1.y*quat2.y + quat1.z*quat2.z+quat1.w*quat2.w
	if (dot < 0.0) do (quat2.x = -quat2.x; quat2.y = -quat2.y;quat2.z = -quat2.z; quat2.w = -quat2.w)
	slerp quat1 quat2  0.2)
catch((quat 0 0 0 1))"
	-- Shoulder 보정 더미의 구문 스크립트 컨트롤러의 weight를 50으로 낮춘다 .(스크립트대신 컨스트레인을 이용하여 셋팅해도됨)
	
	
	  for i in selection do
	  (
		   if (classof i.controller==BipSlave_Control) then  
		   (
				if (finditem bipRoots i.controller.rootnode)==0 then
					append bipRoots i.controller.rootnode
		   )
		   else if (classof i.controller==Vertical_Horizontal_Turn) then
		   (
			   if (finditem bipRoots i)==0 then
					append bipRoots i
		   )

	  ) --bip 의 com을 찾아 bipRoots 어레이에 저장한다.
	  
	--for 문을 수정한다면
	 /*
	  for i in selection do
	  (
			if classof i == Biped_Object do
			(
			
				if (finditem bipRoots i.controller.rootnode)== 0 do 
				(
					append bipRoots i.controller.rootnode
				)
			)
	  )
	*/
	--for 문을 수정 -end- 	  

	  
	  
	  for i in bipRoots do
	  (
	   i.controller.figureMode = True 
	   --바이패드 피겨 모드 on
	   redrawViews() 
	   -- 뷰포트 갱신
	   
	   RLegAux=biped.getNode i #Rleg link:1
	   LLegAux=biped.getNode i #Lleg link:1
	   PelvisAux=biped.getNode i #pelvis
	   
	   /*
	   RLegAux.parent=LLegAux.parent=PelvisAux
	--다리 bip의 부모를 Bip Spine 에서 Bip Pelvis로 변경
		*/
	
		if buttonState[3] do 
		(
			for k in bipLimbs do
		   (
				if k[4] == 2 or  k[4] == 4 do 
				(
					local Limb = biped.getNode i k[1] link:k[2] 
					local boxsize = ceil(distance limb.parent limb /4 )  --floor   ceil
					local creatDummy = Dummy transform:(limb.transform)  isSelected:off
					creatDummy.boxsize = [boxsize,boxsize,boxsize]
					creatDummy.name = "Joint" + k[5] 
					creatDummy.parent = limb
					
					creatDummy.rotation.controller=Rotation_List()
					creatDummy.rotation.controller[1].controller=rotation_script()
					creatDummy.rotation.controller[1].AddNode "Limb" Limb
					creatDummy.rotation.controller[1].SetExpression LimbJointExpression 
					creatDummy.rotation.controller.weight[1] = 100
					
					if buttonState[2] do setTransformLockFlags creatDummy #{1..9} --오브젝트 락
				)
				-- Elbow, Knee 보정 더미
				if k[4] == 1 do 
				(
					local Limb = biped.getNode i k[1] link:k[2] 
					local boxsize = ceil(distance limb limb.Children[1] /4 )  --floor   ceil
					local creatDummy = Dummy transform:(limb.transform)  isSelected:off
					creatDummy.boxsize = [boxsize,boxsize,boxsize]
					creatDummy.name = "Joint" + k[5] 
					creatDummy.parent = limb.parent
					
					creatDummy.rotation.controller=Rotation_List()
					creatDummy.rotation.controller[1].controller=rotation_script()
					creatDummy.rotation.controller[1].AddNode "Limb" Limb
					creatDummy.rotation.controller[1].SetExpression LimbShoulderExpression
					creatDummy.rotation.controller.weight[1] = 50
					
					if buttonState[2] do setTransformLockFlags creatDummy #{1..9} --오브젝트 락
				) -- Shoulder 보정 더미
				
		   ) 

		)
	-- 관절 보조더미 추가(이 부분에 추가해야 여러개의 바이패드가잇을경우 각각에 추가하게됨 )
	
		
	   for k in bipLimbs do
	   (
		if (k[3]>0) then
		(
		Limb=biped.getNode i k[1] link:k[2] 
		distanceVar=(distance limb limb.Children[1]) 
		
		
		TBExpression=""
		ControllerLimb=Limb
		weightVar=100

		
		
		case k[4] of
		(
		 1:(TBExpression=TBExpressionA)
		 2:(
			if k[1]==#larm then TBExpression=TBExpressionBb else TBExpression=TBExpressionBa
			ControllerLimb=Limb.children[1]
			weightVar=100/k[3]
		   )
		 3:(TBExpression=TBExpressionC)
		 4:(
			TBExpression=TBExpressionD
			ControllerLimb=Limb.children[1]
			weightVar=100/k[3]
		   )
		)
		

		
		
		TwistBone=BoneSys.createBone Limb.transform.position Limb.transform.position [0,0,1] 
		TwistBone.name="Bone"+k[5]+" Twist"
		TwistBone.parent=Limb
		TwistBone.Length=distanceVar/k[3]
		TwistBone.Width=distanceVar/8
		TwistBone.Height=TwistBone.Width
		TwistBone.taper=0
		TwistBone.rotation.controller=Rotation_List()
		TwistBone.rotation.controller[1].controller=rotation_script()
		TwistBone.rotation.controller[1].AddNode "Limb" ControllerLimb
		TwistBone.rotation.controller[1].SetExpression TBExpression
		TwistBone.rotation.controller.weight[1]=weightVar
		
		if buttonState[2] do setTransformLockFlags TwistBone #{1..9} --오브젝트 락
		--기본 트위스트본을 만든 다음 rotation_script컨트롤러를 추가하고 노드 스크립트 구문 추가

		
		--여기서부터 하위 트위스트본 만들기 
		TBExtraController=rotation_script()
		if buttonState[1] then 
		(
			case of
			(
			 (k[4]==1 or k[4]==3):(
								   TBExtraController.AddNode "Limb" Limb 
								   TBExtraController.AddNode "LimbParent" TwistBone 
								   TBExtraController.setExpression TBExtraExpressionA
								  )
			 (k[4]==2 or k[4]==4):(
								   TBExtraController.AddNode "TB" TwistBone
								   TBExtraController.setExpression TBExtraExpressionB
								  )
			)
			PrevTBE=TwistBone

			
			
			for j=2 to k[3] do
			(
			 TwistBoneExtra=BoneSys.createBone [0,0,0] [1,0,0] [0,0,1] 
			 matAux=matrix3 1
			 matAux.position=[(distanceVar/k[3]),0,0]
			 TwistBoneExtra.transform=matAux*PrevTBE.transform
			 TwistBoneExtra.name=TwistBone.name+((j-1) as string)
			 TwistBoneExtra.parent=PrevTBE
			 TwistBoneExtra.Length=distanceVar/k[3]
			 TwistBoneExtra.Width=PrevTBE.Width
			 TwistBoneExtra.Height=PrevTBE.Height
			 TwistBoneExtra.taper=0
			 TwistBoneExtra.rotation.controller=Rotation_List()
			 TwistBoneExtra.rotation.controller[1].controller=TBExtraController
			 TwistBoneExtra.rotation.controller.weight[1]=100/k[3]
			 PrevTBE=TwistBoneExtra
			 
			 if buttonState[2] do setTransformLockFlags TwistBoneExtra #{1..9} --오브젝트 락
			)
		) else
		(
			case of
			(
				(k[4]==1 or k[4]==3):
				(
					TBExtraController.AddNode "Limb" TwistBone  
					TBExtraController.AddNode "LimbParent" Limb 
					TBExtraController.setExpression TBExtraExpressionA
			 	)
				(k[4]==2 or k[4]==4):
				(
					TBExtraController.AddNode "TB" TwistBone
					TBExtraController.setExpression TBExtraExpressionB
				)
			)
			PrevTBE=TwistBone

			
			
			for j=2 to k[3] do
			(
			 TwistBoneExtra=BoneSys.createBone [0,0,0] [1,0,0] [0,0,1] 
			 matAux=matrix3 1
			 matAux.position=[(distanceVar/k[3]),0,0]
			 TwistBoneExtra.transform=matAux*PrevTBE.transform
			 TwistBoneExtra.name=TwistBone.name+((j-1) as string)
			 TwistBoneExtra.parent=Limb
			 TwistBoneExtra.Length=distanceVar/k[3]
			 TwistBoneExtra.Width=PrevTBE.Width
			 TwistBoneExtra.Height=PrevTBE.Height
			 TwistBoneExtra.taper=0
			 TwistBoneExtra.rotation.controller=Rotation_List()
			 TwistBoneExtra.rotation.controller[1].controller=TBExtraController
			 if (k[4]==1 or k[4]==3) then
			 (
				TwistBoneExtra.rotation.controller.weight[1]= (100/k[3] * ((k[3]+1)-j))
			 ) else 
			 (
				TwistBoneExtra.rotation.controller.weight[1]= (100/k[3] * j)
			 )
			 PrevTBE=TwistBoneExtra
			 
			 if buttonState[2] do setTransformLockFlags TwistBoneExtra #{1..9} --오브젝트 락
			)
		)
		--여기까지 하위 트위스트본 만들기 -end-
		
		)
	   )
	   i.controller.figureMode = false 
	   --바이패드 피겨 모드 off
	   
	  )
	  redrawViews()
	 ) --TBSetFunction

	 
	 
	 group "Add Bones"
	 (
	  checkbutton HierarchyMode "HierarchyMode" checked:true
	  label LocksLabel "Locks: " offset:[33,0] across:2
	  checkbox checkLocks checked:true  offset:[10,0] align:#right
	  label AddJointLabel "Add Joint: " offset:[26,0] across:2
	  checkbox AddJoint checked:true  offset:[10,0] align:#right
	  spinner TBUpperArms "UpperArms: " type:#integer range:[0,999999999,2] fieldwidth:40
	  spinner TBForeArms "ForeArms: " type:#integer range:[0,999999999,1] fieldwidth:40
	  spinner TBThighs "Thighs: " type:#integer range:[0,999999999,1] fieldwidth:40
	  spinner TBCalves "Calves: " type:#integer range:[0,999999999,1] fieldwidth:40
	  
	  button TBSet "실행" width:80	 )

	 
	
	 on TBSet pressed do 
	 (
	  local n = #(TBUpperArms.value,TBForeArms.value,TBThighs.value,TBCalves.value) 
	  local buttonState = #(HierarchyMode.state,  checkLocks.state, AddJoint.state)
	  undo on TBSetFunction n buttonState
	 )
	)

	createDialog TBPersiana
)