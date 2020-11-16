fn makePastedBoneName strNodeName = 
(
    if ( findString strNodeName " R " != undefined ) do 
        local strOppositeNodeName = substituteString strNodeName " R " " L "

    if ( findString strNodeName " L " != undefined ) do 
        local strOppositeName = substituteString strNodeName " L " " R "
    
    return strOppositeNodeName 
)

for i in selection do 
(
    Expose = i.transform
    Expose.pos.x = Expose.Pos.x * -1

    if classof i == BoneGeometry then 
	(
        mirroredBone = Bone()
	)
    else if classof i == Point then
	(
        mirroredBone = Point()
	)
    else if classof i == ExposeTM then
	(
        mirroredBone = ExposeTM()
	)
    else if classof i == dummy then 
	(
        mirroredBone = Dummy()
	)
    
    mirroredBone.Transform = Expose
	mirroredBone.name = makePastedBoneName i.name
    arProperties = getPropNames i

    for j in arProperties do 
    (
        propertiesToLoop = execute ( "$" + "'" + i.name + "'" + "." + (j as string) )
		--execute ( "$" + "'" + mirroredBone
    )

)

fn makeExecuteName = 
(
	
)