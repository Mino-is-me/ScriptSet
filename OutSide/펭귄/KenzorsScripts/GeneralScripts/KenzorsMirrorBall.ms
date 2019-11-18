/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- version 1.0
-- Kenzors Mirror Ball
-- By ken turner
-- www.designimage.co.uk
-- last changed 14th sept 2012
-- dot net reference http://www.scriptspot.com/bobo/mxs9/dotNet/dotNetObject_System.Windows.Forms.TabControl.html

14/09/2012	v1.0	First release.
*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if KenzorsMirrorBall != undefined then KenzorsMirrorBall.closeup()
KenzorsMirrorBall = undefined

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fileIn ( "$userscripts/KenzorsScripts/Common/kenzorsRolloutManager.ms" )

kenzorsMirrorBallParameters =  undefined

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

struct kenzorsMirrorBallMirrorStruct
(
	theNode = undefined,
	jitterValue = Random [-90,-90, -90] [90, 90, 90],
	baseTm = Undefined,
	fn deleteMe =
	(
		delete theNode
	),
	fn createMirrorFromBox mirrorSize mirrorWireColor =
	(
		theNode = box length:mirrorSize.x width:mirrorSize.y height:mirrorSize.z wirecolor:mirrorWireColor
	),
	fn createMe mirrorSize mirrorWireColor =
	(
		theNode  = box length:mirrorSize.x width:mirrorSize.y height:mirrorSize.z wirecolor:mirrorWireColor
	),
	fn refreshMirrorWireColor =
	(
		theNode.wirecolor = kenzorsMirrorBallParameters.mirrorWireColor	
	),
	fn setMirrorSize =
	(
		theNode.length = kenzorsMirrorBallParameters.mirrorSize.x 
		theNode.width = kenzorsMirrorBallParameters.mirrorSize.y 
		theNode.height = kenzorsMirrorBallParameters.mirrorSize.z 
	),
	fn setBaseTmWithJitter =
	(
		jVal = kenzorsMirrorBallParameters.jitterWeight /100.0
		jRotation = (eulerAngles (jVal.x * jitterValue.y)  (jVal.y * jitterValue.y) (jVal.z * jitterValue.z) ) as quat
		--jRotation = (eulerAngles 0 0 0 ) as quat
		newtm = copy baseTm
		--in coordsys baseTm about baseTm rotate newtm jRotation --- ffs this rotation context really should work
		newtm = preRotate newTm jRotation
		theNode.transform = matrix3 newtm[1] newtm[2]  newtm[3] baseTm.pos
	),
	fn setTmto theTm withYaw:0 =
	(
		baseTm  = copy theTm
		in coordsys world ( about [0,0,0] rotateZ baseTm withYaw)
		setBaseTmWithJitter()
	),
	fn setNewJitterValue =
	(
		jitterValue = Random [-90,-90, -90] [90, 90, 90]
		setBaseTmWithJitter()
	)
)

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

struct kenzorsMirrorBallParametersStruct
(
	ballRadius = 10,

	mirrorSize = [1.5,1.5,.15],
	hGapSize = .001,
	vGapSize = .001,
	verticalArc = 1,
	useSphere = true,
	addBottom = true,
	mirrorWireColor = yellow,
	theSphere = undefined,
	jitterWeight = [0.1,0.1,0.1],
	randomSeedValue = 1,
	
	fn setRandomSeedValueTo val =
	(
		seed val
		randomSeedValue = val
	),
	fn createTheSphere =
	(
		theSphere = Sphere radius:ballRadius segs:64
	),
	initaliseThisStructWithAFunctionCall = createTheSphere(),
	
	fn setAddBottom addBottomState =
	(
		addBottom = addBottomState
	),
	fn setMirrorWireColorTo newColor = ( mirrorWireColor = newColor ),
	fn getTmAtVerticalArcAngle v =
	(
		p = [0,(cos v),(sin v)]
		matrix3 x_axis  [0,-p.z,p.y] -p ( p * ballRadius )
	),
	fn getMirrorObject =
	(
		theNewMirrorObject  = kenzorsMirrorBallMirrorStruct()
		theNewMirrorObject.createMe mirrorSize mirrorWireColor
		theNewMirrorObject
	),
	fn getArc lineLength gapLength theRadius =
	(
		a = ( lineLength + gapLength )/( 2.0 * theRadius ) 
		theAngle = if a <= 1.0 then (2 * asin a) else 180
		if theAngle < 0.1 then 0.1 else theAngle
	),
	fn getHorizontalArcAtVerticalArcAngle v =
	(
		topOfMirrorsAngle = v + ( verticalArc / 2.0)
		topOfMirrorsRadius = ballRadius * cos ( topOfMirrorsAngle )
		getArc mirrorSize.y hGapSize topOfMirrorsRadius 
	),	
	fn setVerticalArc =
	(
		verticalArc = getArc mirrorSize.x vGapSize ballRadius 
	),
	fn setMirrorSize v =
	(
		mirrorSize = [v,v,(v/10)]
		setVerticalArc()
	),
	fn setVGapSize v =
	(
		vGapSize = v
		setVerticalArc()
	),
	fn setHGapSize v =
	(
		hGapSize = v
	),
	fn setBallRadius v =
	(
		ballRadius = v
		setVerticalArc()
		if useSphere then  theSphere.radius = v
	),
	fn setUseSphere UseSphereState =
	(
		sphereExists = ( theSphere != undefined ) and ( not isdeleted theSphere )
		if UseSphereState and ( Not sphereExists ) then createTheSphere()
		if not UseSphereState and sphereExists then ( delete theSphere ; theSphere = undefined )
		useSphere = UseSphereState
	)
)

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

kenzorsMirrorBallParameters = kenzorsMirrorBallParametersStruct()
kenzorsMirrorBallParameters.setVerticalArc()

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

struct kenzorsMirrorRingStruct
(
	arrayOfMirrors =#(),
	verticalAngle = 0,
	horizontalArc = 0,
	numberInRing = 1,
	intialTm = matrix3 1,
	randomShiftWieght = random 0.0 1.0,
	randomHorizontalShift = 0,
	fn deleteMe =
	(
		for obj in arrayOfMirrors do obj.deleteMe()
		arrayOfMirrors =#()
	),
	fn setNumberInRing n =
	(
		numberInRing = n
		theDifference = arrayOfMirrors.count - numberInRing
		if theDifference > 0 then
		(
			for i = 1 to theDifference do
			(
				arrayOfMirrors[1].deleteMe()
				deleteItem arrayOfMirrors 1
			)
		) else
		(
			if theDifference < 0 do
			(
				for i = 1 to -theDifference do
				(
					append arrayOfMirrors (kenzorsMirrorBallParameters.getMirrorObject())
				)	
			)
		)
	),
	fn updateTm =
	(
		randomHorizontalShift = randomShiftWieght * horizontalArc
		--format " verticalAngle % NumberInRing % randomHorizontalShift % \n" verticalAngle NumberInRing randomHorizontalShift
		theYaw = randomHorizontalShift
		for obj in arrayOfMirrors do
		(
			obj.setTmto intialTm withYaw:theYaw 
			theYaw =  theYaw + horizontalArc
		)
	),
	fn setHorizontalArc =
	(
		minimumHorizontalArc = kenzorsMirrorBallParameters.getHorizontalArcAtVerticalArcAngle verticalAngle
		SetNumberInRing (( floor ( 360.0 / minimumHorizontalArc )) as integer )		
		horizontalArc = ( 360.0 / 	NumberInRing ) as float
		updateTm()
	),
	fn setVerticalAngle a =
	(
		verticalAngle = a
		intialTm = kenzorsMirrorBallParameters.getTmAtVerticalArcAngle verticalAngle
		setHorizontalArc()
	),
	fn setAsMirrorToThisRing theOppositeRing =
	(
		verticalAngle = theOppositeRing.verticalAngle
		horizontalArc = theOppositeRing.horizontalArc
		setNumberInRing theOppositeRing.numberInRing
		Tm = theOppositeRing.intialTm
		intialTm = matrix3 Tm[1] ( Tm[2] * [1,1,-1] ) (Tm[3] * [1,1,-1] ) (Tm[4] * [1,1,-1] )
		updateTm()
	),
	fn setMirrorSize =
	(
		for theMirror in arrayOfMirrors do theMirror.setMirrorSize()
	),
	fn refreshMirrorWireColor =
	(
		for theMirror in arrayOfMirrors do 
		(
			theMirror.refreshMirrorWireColor()
		)
	),
	fn setBaseTmWithJitter =
	(
		for theMirror in arrayOfMirrors do 
		(
			theMirror.setBaseTmWithJitter()
		)
	),
	fn setNewJitterValue =
	(
		for theMirror in arrayOfMirrors do theMirror.setNewJitterValue()
	)
)

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

struct kenzorsMirrorBallStruct
(
	arrayOfRings = #(),

	fn deleteAll =
	(
		for theRing in arrayOfRings do
		(
			theRing.deleteMe()
		)
		arrayOfRings = #()
	),
	fn setNumberOfRingsTo n =
	(
		theDifference = arrayOfRings.count - n
		if theDifference > 0 then
		(
			for i = 1 to theDifference do
			(
				c = arrayOfRings.count 
				arrayOfRings[c].deleteMe()
				deleteItem arrayOfRings c
			)
		) else
		(
			if theDifference < 0 do
			(
				for i = 1 to -theDifference do
				(
					append arrayOfRings (kenzorsMirrorRingStruct())
				)	
			)
		)
	),
	fn updateHorizontalRotations =
	(
		for theRing in arrayOfRings do theRing.setHorizontalArc()
	),
	fn setVerticalArc =
	(
		a = kenzorsMirrorBallParameters.verticalArc
		numberOfRings = ( floor ( 90 / a )) as integer
		finalNumberOfRings = if kenzorsMirrorBallParameters.addBottom then numberOfRings * 2 else numberOfRings
		setNumberOfRingsTo finalNumberOfRings	
		theVerticalAngle = a / 2.0
		for i = 1 to numberOfRings do
		(
			arrayOfRings[i].setVerticalAngle theVerticalAngle
			theVerticalAngle += a
		)
		if kenzorsMirrorBallParameters.addBottom then 
		(
			for i = 1 to numberOfRings do
			(
				arrayOfRings[i + numberOfRings].setAsMirrorToThisRing ( arrayOfRings[i] )
			)
		)
		
	),
	fn setMirrorSize val =
	(
		kenzorsMirrorBallParameters.setMirrorSize val
		for theRing in arrayOfRings do theRing.setMirrorSize()
		setVerticalArc()
	),
	fn updateMesh =
	(
		setVerticalArc()
	),
	fn setMirrorWireColorTo newColor =
	(
		kenzorsMirrorBallParameters.setMirrorWireColorTo newColor
		for theRing in arrayOfRings do
		(
			theRing.refreshMirrorWireColor()
		)
	),
	fn setBaseTmWithJitter val =
	(
		kenzorsMirrorBallParameters.jitterWeight = val
		for theRing in arrayOfRings do 
		(
			theRing.setBaseTmWithJitter()
		)
	),
	fn setRandomSeedValueTo val =
	(
		kenzorsMirrorBallParameters.setRandomSeedValueTo val
		for theRing in arrayOfRings do 
		(
			theRing.setNewJitterValue()
		)
	)
	
)

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

rollout kenzorsMirrorBallRoll "Kenzors Mirror Ball"
(
	Local isRolledOut = true --- required varible for kenzorsRolloutManager
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on kenzorsMirrorBallRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) --- required function for kenzorsRolloutManager
	---------------------------------------------------------------------------------------------
	
	-- local KenzorsLogoBmp = openBitmap "$userscripts/KenzorsScripts/Common/Images/Logo_32.bmp"
	local kenzorsMirrorBall = kenzorsMirrorBallStruct()
	-- button btnWebLink "" images:#(KenzorsLogoBmp, undefined, 1,1,1,1,1 ) align:#center-- -- System.Diagnostics.Process.Start(target)
	--hyperlink wwwDesignimage "www.designimage.co.uk" color:blue address:"www.designimage.co.uk" align:#center
	spinner spnMirrorSize  "Mirror size" FieldWidth:50 range:[0.001,1000,kenzorsMirrorBallParameters.mirrorSize.x]
	spinner spnVGap "vertical gap" FieldWidth:50   range:[0.0,1000,kenzorsMirrorBallParameters.vGapSize]
	spinner spnHGap "Horizontal gap" FieldWidth:50   range:[0.0,1000,kenzorsMirrorBallParameters.hGapSize]
	spinner spnBallRadius "Radius" FieldWidth:50   range:[0.001,1000,kenzorsMirrorBallParameters.ballRadius]
	group "jitter Rotation"
	(
	spinner spnRandomSeed "Random Seed" FieldWidth:40 type:#Integer  range:[0,10000000,kenzorsMirrorBallParameters.RandomSeedValue] 	
	spinner spnJitterX "X" FieldWidth:30   range:[0.0,100,kenzorsMirrorBallParameters.jitterWeight.x] across:3
	spinner spnJitterY "Y" FieldWidth:30   range:[0.0,100,kenzorsMirrorBallParameters.jitterWeight.y]
	spinner spnJitterZ "Z" FieldWidth:30   range:[0.0,100,kenzorsMirrorBallParameters.jitterWeight.z]
	)
	checkbox chkAddSphere "Add Sphere" checked:kenzorsMirrorBallParameters.useSphere 
	checkbox chkAddBottom "Add Bottom" checked:kenzorsMirrorBallParameters.addBottom
	
	ColorPicker cPckMirrorColor "mirror wire color"  color:kenzorsMirrorBallParameters.mirrorWireColor
	
	on kenzorsMirrorBallRoll open do kenzorsMirrorBall.updateMesh()
	on spnMirrorSize changed val do
	(
		kenzorsMirrorBall.setMirrorSize val
	)	
	on spnHGap changed val do
	(
		kenzorsMirrorBallParameters.setHGapSize val
		kenzorsMirrorBall.updateHorizontalRotations()
	)
	on spnVGap changed val do
	(
		kenzorsMirrorBallParameters.setVGapSize val
		kenzorsMirrorBall.setVerticalArc()
	)	
	on spnBallRadius changed val do
	(
		kenzorsMirrorBallParameters.setBallRadius val
		kenzorsMirrorBall.setVerticalArc()
	)
	on chkAddSphere changed arg do
	(
		kenzorsMirrorBallParameters.setUseSphere arg
	)
	on chkAddBottom changed arg do
	(
		kenzorsMirrorBallParameters.setAddBottom arg
		kenzorsMirrorBall.updateMesh()
	)
	on cPckMirrorColor changed arg do
	(
		kenzorsMirrorBall.setMirrorWireColorTo arg
	)
	fn setBaseTmWithJitter =
	(
		val = [spnJitterX.value,spnJitterY.value,spnJitterZ.value]
		kenzorsMirrorBall.setBaseTmWithJitter val
	)
	on spnJitterX changed val do
	(
		setBaseTmWithJitter()
	)
	on spnJitterY changed val do
	(
		setBaseTmWithJitter()
	)
	on spnJitterZ changed val do
	(
		setBaseTmWithJitter()
	)
	on spnRandomSeed changed val do
	(
		kenzorsMirrorBall.setRandomSeedValueTo val
		--kenzorsMirrorBall.updateHorizontalRotations()
	)

)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: kenzorsMirrorBallRoll

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

KenzorsMirrorBall= KenzorsRolloutManagerStruct  "Mirror Ball" 200 #( KenzorsAboutMeRoll, kenzorsMirrorBallRoll )
KenzorsMirrorBall.Initalize()
KenzorsAboutMeRoll.wwwHelp = "http://www.designimage.co.uk/3dsmax-maxscript-mirror-ball/"
