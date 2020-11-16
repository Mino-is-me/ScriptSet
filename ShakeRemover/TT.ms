files = getFiles "Z:\ART_Backup\SequenceExport"

for file in files do 
(
    loadMaxFile file quiet:true
    
    Set Animate On 

    $Root.rotation = quat 0 2.33173e-07 -0.707107 0.707107
    $Bip001.parent = undefiend

    $Root.rotation = quat -2.38419e-07 1.64878e-07 0 1
)
