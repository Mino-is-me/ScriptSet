for i in selection do 
(
    select i 


    local meshName = $.name + "_eyeBrow"
    local appendNode = getNodeByName meshName 
    
    actionMan.executeAction 369982487 "40007"
    subobjectLevel = 5
    $.EditablePoly.attach appendNode $


    actionMan.executeAction 369982487 "40007"
    subobjectLevel = 0

)