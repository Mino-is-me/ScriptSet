function fn_make_tuple_list = (
	temp  = #()
    for i in selection do (
		append temp #(i.name, i.transform) 
    )
    return temp
)

function fn_return_transforms_by_name __nameList = (
    ar_need_to_return = #() 
    for each in __nameList do (
        local _node = getNodeByName each
        append ar_need_to_return #(_node.name, _node.transform)
    ) 
    return ar_need_to_return
)

function fn_set_bones_by_tuple_list __tuplelist = (
    for each in __tuplelist do (
        local _node = getNodeByName each[1] --name 
        _node.transform = each[2] --transform 
    ) 
    return 0
)


ar_hairBones = #(
    "Ab TL HairB01",
    "Ab TL HairB02",
    "Ab TL HairB03",
    "Ab TL HairB04",
    "Ab TL HairB05",
    "Ab TL HairB06",
    "Ab TL HairB07",
    "Ab TL HairB08",
    "Ab TL HairB09"
)

--tuple_hairBones = fn_return_transforms_by_name ar_hairBones