macroScript exporter_Opener
    category:"EVE"
    ButtonText:"Exporter"
    toolTip:"Exporter for Project EVE"
   -- icon: #("\\\\10.220.70.12\\eve\\ART_Backup\\Script\\Logo\\eveLogo.bmp")
    --iconName:"bmp_index"
    --silentErrors:true
    --autoUndoEnabled:true
(
    on execute do (fileIn "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\Exporter\\TheExporter.ms" )
)

