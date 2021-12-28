ar_morphNames = #()

BaseObj = $'EyeAOcover'
tomodify = $'EyeAOcover'



morphStack = BaseObj.morpher
Origin = tomodify
for i=1 to 16 do 
(
	WM3_MC_SetValue morphStack i 100.0 
	local morphName = WM3_MC_GetName BaseObj.Morpher i
	append ar_morphNames morphName
	Copied = Copy Origin
	select Copied 

	sleep 0.1

	macros.run "Modifier Stack" "Convert_to_Poly"
	Copied.pos = [20 * i, 0, 0]
	Copied.name = morphName
	select Origin
	WM3_MC_SetValue morphStack i 0.0 
	sleep 0.1
)

