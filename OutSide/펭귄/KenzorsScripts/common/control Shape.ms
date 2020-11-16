/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Animation Control Shape
-- By ken turner
-- www.designimage.co.uk


SVG Paths
Simple or compound shape outlines are drawn with curved or straight lines that can be filled in, outlined, or used as a clipping path. 
Paths have a compact coding. For example 
M (for 'move to') precedes initial numeric x and y coordinates
L (line to) precedes a point to which a line should be drawn. 
Further command letters (C, S, Q, T and A) precede data that is used to draw various Bézier and elliptical curves. 
C 
Z is used to close a path.

In all cases, absolute coordinates follow capital letter commands and relative coordinates are used after the equivalent lower-case letters

*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fileIn ( "$userscripts/KenzorsScripts/Common/stringStreamStruct.ms" )
struct ShapePointStruct
(
/*
getKnotType <shape> <spline_index_integer> <knot_index_integer>
setKnotType <shape> <spline_index_integer> <knot_index_integer> \  (#smooth | #corner | #bezier | #bezierCorner )
getKnotPoint <shape> <spline_index_integer> <knot_index_integer>
setKnotPoint <shape> <spline_index_integer> <knot_index_integer> <point3>
getInVec <shape> <spline_index_integer> <knot_index_integer>
setInVec <shape> <spline_index_integer> <knot_index_integer> <point3>
getOutVec <shape> <spline_index_integer> <knot_index_integer>
setOutVec <shape> <spline_index_integer> <knot_index_integer> <point3>
	
getSegmentType <shape> <spline_index_integer> <seg_index_integer>
setSegmentType <shape> <spline_index_integer> \ <seg_index_integer> \ ( #curve | #line )

*/
	pos =  [1.0,1.0,1.0] ,
	knotType = #corner,
	inVector = [1.0,1.0,1.0] ,
	outVector = [1.0,1.0,1.0],
	segmentType = #line, -- could add #end to mean there is no out going segment... it's the end of the spline.
	
	fn copyKnotFrom obj splineIndex knotIndex =
	(
		pos = getKnotPoint obj splineIndex knotIndex
		knotType = getKnotType obj splineIndex knotIndex 
		inVector = getInVec obj splineIndex knotIndex 
		outVector = getOutVec obj splineIndex knotIndex 
	),
	fn copySegmentTypeFrom obj splineIndex segmentIndex  =
	(
		-- of course the number of segments is one less than the number of knots
		segmentType = getSegmentType obj splineIndex segmentIndex 
	),
	fn setInOutVector obj splineIndex knotIndex size:1.0 =
	(
		setInVec obj splineIndex knotIndex ( size * inVector )
		setOutVec obj splineIndex knotIndex ( size * outVector )
	),
	fn addKnotTo obj splineIndex knotIndex size:1.0 =
	(
		  --- segmentType is the type of spline segment leaving the knot  ( #curve | #line ) or 
		-- setInOutVector obj splineIndex knotIndex size:1.0
		if knotType == #smooth or knotType == #corner then 
		(
			addKnot obj splineIndex knotType segmentType ( size * pos )
		)else
		(
			addKnot obj splineIndex knotType segmentType ( size * pos ) ( size * inVector ) ( size * outVector )
		)
	),
	fn setKnotSizeTo obj splineIndex knotIndex size =
	(
		in coordsys obj
		(
			setKnotPoint  obj splineIndex knotIndex  ( size * pos ) 
			setInOutVector obj splineIndex knotIndex size:size
		)
	),
	fn writeSVG f =
	(
		format "   %,%,%,%,%,\n" pos.x pos.y inVector outVector segmentType to:f
	),
	fn writeMe f =
	(
		format "   %,%,%,%,%,\n" pos knotType inVector outVector segmentType to:f
	),
	fn readMe sStream =
	(
		pos = sStream.ReadPoint3String()
		knotType = sStream.ReadNameString()
		inVector = sStream.ReadPoint3String()
		outVector = sStream.ReadPoint3String()
		segmentType = sStream.ReadNameString()
	)
)

struct ShapeCurveStruct
(
	pointArray = #( ShapePointStruct [0,-5.12,0], ShapePointStruct [-1.72,-2.6,0], ShapePointStruct [-0.93,-2.6,0], ShapePointStruct [-0.93,2.6,0], ShapePointStruct [-1.72,2.6,0], ShapePointStruct [0,5.12,0], ShapePointStruct [1.72,2.6,0], ShapePointStruct [0.93,2.6,0], ShapePointStruct [0.93,-2.6,0], ShapePointStruct [1.72,-2.6,0]),
	isClosedShape = true,
	splineIndex = 1,
	fn setObjectSize obj size =
	(
		for knotIndex = 1 to pointArray.count do
		(
			pointArray[knotIndex].setKnotSizeTo obj splineIndex knotIndex size
		)
	),
	fn createCurveInShape obj size:1.0 =
	(
		addNewSpline obj
		knotIndex = 0 
		for p in pointArray do
		(
			knotIndex +=1
			p.addKnotTo obj splineIndex knotIndex size:1.0 
			-- addKnot obj curveNumber #corner #line ( size * p )
		)
		if isClosedShape do close obj splineIndex
	),
	fn copyCurveData testObj cNum =
	(
		splineIndex = cNum
		isClosedShape = isClosed testObj cNum
		in coordsys testObj
		(
			knotCount = ( numKnots testObj splineIndex ) 
			pointArray = for knotIndex = 1 to knotCount collect	
			(
				p = ShapePointStruct()
				-- getKnotPoint testObj curveNumber i
				p. copyKnotFrom testObj splineIndex knotIndex 
				p
			)
			segmentCount = if isClosedShape then knotCount else ( knotCount - 1 )
			for segmentIndex = 1 to segmentCount do pointArray[segmentIndex].copySegmentTypeFrom testObj splineIndex segmentIndex  
		)
	),
	fn worldToSVGPage pos withScale: FrameSize: =
	(
		px = pos.x
		py = pos.y 

		x = (px * withScale) + ( FrameSize.x / 2 )
		y = (py * withScale) + ( FrameSize.y / 2 )
		[x,y]
	),
	fn writeSVGCurveTo f pFrom: pTo: withScale:10 FrameSize:[1920,1080]  =
	(
		svgPos = worldToSVGPage pTo.pos withScale:withScale FrameSize:FrameSize	
		svgVectFrom = worldToSVGPage pFrom.outVector withScale:withScale FrameSize:FrameSize
		svgVectTo = worldToSVGPage pTo.InVector withScale:withScale FrameSize:FrameSize
		format "C%,% %,% %,% " svgVectFrom.x svgVectFrom.y svgVectTo.x svgVectTo.y svgPos.x svgPos.y to:f
	),
	fn writeSVG f withScale:10 FrameSize:[1920,1080] strokeWidth:1 fill:true =
	(
		fillcolour = if fill then 
		(
			"fill=\"#FFFFFF\""
		)else 
		(
			"fill=\"none\" stroke=\"#FFFFFF\" stroke-width=\"%\"" 
		)
		
		format "<path % stroke-miterlimit=\"10\" d=\"" fillcolour strokeWidth to:f

		svgPos = worldToSVGPage pointArray[1].pos withScale:withScale FrameSize:FrameSize
		format "M%,% " svgPos.x svgPos.y to:f  --- M means move to
		
		for i = 2 to pointArray.count do
		(
			pFrom = pointArray[ ( i - 1) ]
			pTo = pointArray[i]
			writeSVGCurveTo f pFrom:pFrom pTo:pTo withScale:withScale FrameSize:FrameSize
		)
		if isClosedShape then 
		(
			pFrom = pointArray[(pointArray.count)]
			pTo = pointArray[1]
			writeSVGCurveTo f pFrom:pFrom pTo:pTo  withScale:withScale FrameSize:FrameSize
			format "z" to:f
		)

		format "\"/>\n" to:f
		
	),
	fn writeMe f =
	(
		format " %,%,\n" splineIndex isClosedShape to:f
		c = pointArray.count
		format " point Count:% \n" c to:f
		for p in pointArray do p.writeMe f 
	),
	fn readMe sStream =
	(
		splineIndex = sStream.ReadIntString()
		isClosedShape = sStream.ReadBooleanString()
		pointArray = sStream.collectStructArray ShapePointStruct
	)
)

struct ShapeStruct
(
	shapeFilePath = "",
	shapeName = "",
	CurveList = #(ShapeCurveStruct()), --- an array of ShapeCurveStructs
	obj = undefined,
	TransformLockBitArray = #{}, --- this is setup in local space.... but transformed into parent space when you link to an object.
	thickness = .5,
	displayInView = true,
	hasLockedTransformBool = false,
	AxisOrder = #(1,2,3),
	fn exists = 
	(
		Not ( obj == undefined or isDeleted Obj )
	),
	-------------------------------------------------------------------------- unlock or lock transform
	fn LockTransformWith ba =
	(
		setTransformLockFlags obj ba
		updateShape obj
		nodeInvalRect obj
	),
	/*
	fn LockTransform =
	(
		hasLockedTransformBool = true
		if exists() do 
		(
			newBa = #{}
			--- reorder the bit array to get the axis locks pointing in the right direction
			for i = 1 to 3 do
			(
				theIndex = abs AxisOrder[i]
				newBa[theIndex] = TransformLockBitArray[i]
				newBa[theIndex + 3] = TransformLockBitArray[i + 3]
				newBa[theIndex + 6] = TransformLockBitArray[i + 6]
			)

			print newBa
			LockTransformWith newBa
		)
	),
	*/
	fn getInParentSpaceTheRotationControllerForAxisIndex i =
	(
		theIndex = abs AxisOrder[i]
		case theIndex of 
		(
			1:(obj.Rotation.x_rotation.controller)
			2:(obj.Rotation.y_rotation.controller)
			3:(obj.Rotation.z_rotation.controller)
		)
	),
	fn getInParentSpaceThePositionControllerForAxisIndex i =
	(
		theIndex = abs AxisOrder[i]
		case theIndex of 
		(
			1:(obj.Position.x_position.controller)
			2:(obj.Position.y_position.controller)
			3:(obj.Position.z_position.controller)
		)
	),
	fn getInParentSpaceTheScaleControllerForAxisIndex i =
	(
		theIndex = abs AxisOrder[i]
		case theIndex of 
		(
			1:(obj.Scale.x_scale.controller)
			2:(obj.Scale.y_scale.controller)
			3:(obj.Scale.z_scale.controller)
		)
	),
	fn LockTransform =
	(
		hasLockedTransformBool = True
		if exists() do 
		(
			LockTransformWith TransformLockBitArray
		)
	),
	fn setTransformLockBitArrayTo ba =
	(
		TransformLockBitArray = ba 
		if exists() and hasLockedTransformBool do LockTransform()
	),
	fn UnLockTransform =
	(
		hasLockedTransformBool = false
		if exists() do LockTransformWith #{}
	),
	fn setHasLockedTransformBoolTo state =
	(
		if state then LockTransform() else UnLockTransform()
	),
	--------------------------------------------------------------------------
	fn SetDisplayInViewBoolTo state =
	(
		displayInView = state
		if exists() do obj.render_displayRenderMesh = displayInView
	),
	fn deleteObject =
	(
		delete obj
	),
	fn setObjectSize size =
	(
		if exists() do 
		(
			obj.render_thickness = thickness * size
			for crv in CurveList do crv.setObjectSize obj size
			updateShape obj
			nodeInvalRect obj
		)
	),
	fn addEmptyModNamed theName withCustomAttribute:undefined =
	(
		if Not (IsProperty obj  theName ) do Addmodifier obj (EmptyModifier name:theName)
		if withCustomAttribute != Undefined then
		(
			custAttributes.add obj.modifiers[theName] withCustomAttribute
		)
	),
	fn createShape size:1 tm:(matrix3 1) namePrefix:"" nameSuffix:"" colour:(random black white) =
	(
		print shapeFilePath 
		
		if CurveList.count > 0 then 
		(
			obj = SplineShape prefix:(namePrefix + shapeName + nameSuffix) pos:[0,0,0] -- The prefix keyword can be used in place of the name keyword argument to specify the start of the node name from which 3ds Max will generate a unique name by adding a series of digits, as it does when creating objects interactively.
			obj.wireColor = colour
			for crv in CurveList do crv.createCurveInShape obj size:1
			obj.render_thickness = thickness * size
			obj.render_displayRenderMesh = displayInView
			obj.render_sides = 4
			
			obj.transform = tm
			updateShape obj
			nodeInvalRect obj
			obj
		) else undefined
	),
	fn copyShapeDataFrom sampleObject =
	(
		if sampleObject != undefined and ( isKindOf sampleObject Shape ) then
		(
			ShapeName = sampleObject.name as string
			thickness = sampleObject.render_thickness
			displayInView = sampleObject.render_displayRenderMesh
			TransformLockBitArray = getTransformLockFlags sampleObject 
			CurveList = for curveIndex = 1 to numSplines sampleObject collect
			(
				newCurve = ShapeCurveStruct()
				newCurve.copyCurveData sampleObject curveIndex
				newCurve
			)
		)
	),
---------------------------------------------------------------------------------------------------------------
	fn writeSVG f withScale:10 FrameSize:[1920,1080] strokeWidth:1 fill:true =
	(
		for crv in CurveList do crv.writeSVG f withScale:withScale FrameSize:FrameSize strokeWidth:strokeWidth fill:fill 
	),
	fn writeSvgToFilePath fPath withScale:10 FrameSize:[1920,1080] strokeWidth:1 fill:true =
	(
		if (fPath != undefined) then 
		( 
			f = createFile fPath
			writeSVG f withScale:withScale FrameSize:FrameSize strokeWidth:strokeWidth fill:fill 
			close f
			true -- todo: return false if it breaks
		)else false
	),
---------------------------------------------------------------------------------------------------------------
	fn writeMe f =
	(
		format "Kenzors Control Shape version, 1 \n" to:f
		format "%\n" ShapeName to:f
		format "%\n" TransformLockBitArray to:f
		format "%,%,\n" displayInView thickness to:f
		format "Curve Count:% \n" CurveList.count to:f
		for crv in CurveList do crv.writeMe f
	),
	fn writeMeToFilePath fPath =
	(
		if (fPath != undefined) then 
		( 
			f = createFile fPath
			writeMe f
			close f
			true -- todo: return false if it breaks
		)else false
	),
---------------------------------------------------------------------------------------------------------------
	fn readMe sStream =
	(
		obj = undefined
		
		sStream.ReadHeadLineAndVersionNumber()
		ShapeName = sStream.ReadToDelimitChar "\n"
		TransformLockBitArray = sStream.ReadBitArrayString()
		displayInView = sStream.ReadBooleanString()
		thickness = sStream.ReadFloatString()
		CurveList = sStream.collectStructArray ShapeCurveStruct
	),
	fn readMeFromFilePath fPath =
	(
		if (fPath != undefined) then 
		( 
			if (doesFileExist fPath ) then
			(
				CurveDataPath = fPath
				f = openfile fPath
				readMe ( StringStreamStruct f )
				close f
				true
			)else false
		)else false
	),
	fn setTransformTo theTm withAxisOrder:#(1,2,3) flipAxis:3  =
	(
		newTm = matrix3 0
		AxisOrder = deepcopy withAxisOrder
		for i = 1 to 3 do
		(
			theAxis = abs ( AxisOrder[i] )
			theSign = if ( AxisOrder[i] ) > 0 then 1 else -1 
			newTm[i] = theSign * theTm[theAxis]
		)
		if (  newTm.determinantsign == -1 ) do
		(
			newTm[flipAxis] = -1 * newTm[flipAxis] 
			AxisOrder[flipAxis] = -1 * AxisOrder[flipAxis] 
		)
		newTm.pos =  theTm.pos
		obj.Transform = newTm
		nodeInvalRect obj
	),
	fn setOrientationTo theTm withAxisOrder:#(1,2,3) flipAxis:3  =
	(
		newTm = theTm
		newTm.pos =  obj.pos
		 setTransformTo newTm withAxisOrder:withAxisOrder flipAxis:flipAxis
	),
	fn createShapeAndLinkTo objParent withAxisOrder:#(1,2,3) flipAxis:3 size:1 namePrefix:"" nameSuffix:"" colour:(random black white) =
	(
		theTm = objParent.transform
		createShape size:1 tm:theTm namePrefix:namePrefix nameSuffix:nameSuffix colour:colour
		setTransformTo theTm withAxisOrder:withAxisOrder flipAxis:flipAxis
		obj.parent = objParent
		LockTransform()
	),
	loadOk = ( readMeFromFilePath shapeFilePath ) 
)