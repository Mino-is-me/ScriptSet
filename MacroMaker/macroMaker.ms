--MacroMaker Script by Minomi 

dir = "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\MacroMaker\\CreatedMacro\\"
macroName = ""

bodyText = "macroScript BodyFormat
category:\"EVE_Created\"
ButtonText:
toolTip:
"

Try(DestroyDialog getMacroName) catch()
rollout 'getMacroName' "Macro Name"
(
    editText 'edt_getMacroName' "Macro Name : "

    on edt_getMacroName entered val do 
    (
        macroName = val
        strMacro = getclipboardText()


        BodyArray = filterString bodyText "\n"

        BodyArray[1] =  substituteString BodyArray[1] "BodyFormat" ""
        BodyArray[1] = BodyArray[1] + macroName
        BodyArray[3] = BodyArray[3] + "\"" + macroName + "\""
        BodyArray[4] = BodyArray[4] + "\"" + macroName + "\""
        BodyArray[5] ="(" + getclipboardText() + ")"

        BodyString = ""
        for i=1 to 5 do 
        (
            BodyString = BodyString + "\n" + BodyArray[i] 
        )

        print BodyString 
        newMacro = createFile (dir + macroName + ".mcr" )
        --newMacroStream = openFile newMacro
        format BodyString to:newMacro

        sleep 0.1
        close newMacro

        ShellLaunch "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\MacroMaker\\openFolder.bat" ""
    )
)
CreateDialog getMacroName


/*
strMacro = getclipboardText()


BodyArray = filterString bodyText

BodyArray[1] =  substituteString BodyArray[1] "BodyFormat" ""
BodyArray[1] = BodyArray[1] + macroName 
*/