--Head exporter present to suhyun - park 
--script by Minomi 
fn HeadExportSetUp =
(
	FbxExporterSetParam "Animation" true
	
	FbxExporterSetParam "UseSceneName" true
	
	FbxExporterSetParam "BakeAnimation" true
	FbxExporterSetParam "BakeFrameStart" animationRange.start
	FbxExporterSetParam "BakeFrameEnd" animationRange.end
	FbxExporterSetParam "BakeFrameStep" 1
	FbxExporterSetParam "BakeResampleAnimation" true
	--FbxExporterSetParam "Resampling" frameVal
	FbxExporterSetParam "FilterKeyReducer" false
	FbxExporterSetParam "Skin" true	
	FbxExporterSetParam "Shape" true
	
	FbxExporterSetParam "SmoothingGroups" true	 	--Export With Smoothing Group
	
	FbxExporterSetParam "UpAxis" #z						 	--Up Axis -> +Z
	FbxExporterSetParam "Lights" false					 	--Export WithOut Light
	FbxExporterSetParam "ASCII" true						 	--FBX Format -> ASCII
	FbxExporterSetParam "ConvertUnit" #custom unit	--unit Size -> Custom
	
	
	
) -- from FBX Export Parameter Selection

fn getSkinObjs =
(
	local objs = $*
	local skinObjs = #()
	for obj in objs do
	(
		for i=1 to obj.modifiers.count do if classof obj.modifiers[i] == Skin do append skinObjs obj
	)
	return skinObjs
)


BaseMesh = $ 

RootTrees = #("Root","Bip001","Bip001 Pelvis","Bip001 Spine","Bip001 Spine1","Bip001 Spine2","Bip001 Neck","Bip001 Head")

skinObjs = getSkinObjs()
selectMore skinObjs
for i in RootTrees do 
(
    local NOD = getNodeByName i 
    selectMore NOD
   
)

HeadExportSetUp() 
