global desiredRotation = 0
global startFrame = 0
global endFrame = 100

try(destroyDialog makeDesiredRotation) Catch() 

Rollout makeDesiredRotation "Set Desired Rotation" 
(
	Spinner sp_AngleSelector "select Angle Here" align:#left range:[-360,360,0] type:#integer fieldWidth:50


    Spinner sp_startRotateFrame "Start Frame : " range:[0,1000,0] type:#integer fieldWidth:50 across:2
    Spinner sp_endRotateFrame "End Frame : " range:[1,1000,100] type:#integer fieldWidth:50


    on sp_AngleSelector changed val do 
    (
        desiredRotation = val 
    )

    on sp_startRotateFrame changed val do 
    (
        startFrame = val 
    )

    on sp_endRotateFrame changed val do 
    (
        endFrame = val
    )

)
createDialog makeDesiredRotation 300 100