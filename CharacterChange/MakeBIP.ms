Base = "C:\Users\Shiftup\Documents\Seq_Export\Game\Art\Character\PC\CH_P_EVE_01\Animation\BaseBIP.max"
Files = getFiles "C:\Users\Shiftup\Documents\Seq_Export\Game\Art\Character\PC\CH_P_EVE_01\Animation\Editied\*.fbx"



for i=1 to 2 do
(
    local file = Files[i]
    loadMaxFile Base quiet:true 

	FbxImporterSetParam "Mode" #exMerge 
    importfile file #noPrompt using:FBXIMP 
    
    fileNew = substituteString file ".fbx" ".bip"
    Biped.saveBipFile $Bip001.controller fileNew

    ResetMaxFile #noPrompt
)