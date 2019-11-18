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

the_IKAttach = attributes IKAttach 
(
    parameters main rollout:params 
    (
       -- ScriptLine type:#String UI:(edtNode) 
        refNode type:#Node UI:(pckNode)
    )
    rollout params "Picking Reference"
    (
        --editText edtNode "Script Here" 
        pickButton pckNode "Pick Ref Node Here"

        on pckNode picked obj do 
        (
            refNode = obj 
            $.text = obj.transform.pos as string 
        )
    )
)
custAttributes.add $ the_IKAttach #unique 


