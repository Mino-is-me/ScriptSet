fn GetAbsPosfromParent obj=
(
    absPos = obj.transform.pos * inverse obj.parent.transform
    
    return absPos
) -- Pos는 Rotation과 다르게 부모 TM의 행렬 전체를 따와야함





fn GetAbsRotfromParent obj=
(
    absRot = obj.transform.rotation * inverse obj.parent.transform.rotation

    return absRot 
) -- rotation은 부모 Rot Quaternion만 떼오면 됌.