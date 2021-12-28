Try(destroyDialog 'GettingInform')
Catch()
rollout 'GettingInform' "get informaiton" 
(
    --editText 'edt_name :' "your Name : "
    checkBox 'chk_agree' "I AGREE WITH SHARING THE INFROMATION OF PC"
    button 'btn_send' "Send your Information" enabled:false 

    on 'chk_agree' changed val do 
    (
        if val then
        (
            GettingInform.btn_send.enabled = true
        )

        else 
        (
            GettingInform.btn_send.enabled = false 
        )
    )

    on 'btn_send' pressed do 
    (
        NWIF = dotnetClass "System.Net.NetworkInformation.NetworkInterface"
        the_Mac_array = NWIF.GetAllNetworkInterfaces() -- this is an array of all the Networks
        --the_PhysicalAddress_Array = #()
        for i in the_Mac_array do
        (
            local iProperties = i.GetIPProperties()
            local DnsSuffix = iProperties.DnsSuffix

            if DnsSuffix == "SHIFTUP" do 
            (
                local macAddress = i.getPhysicalAddress()
                print (macAddress.toString())

                local returnVal = (macAddress.toString())
                setClipBoardText returnVal
            )
        )
    )
)
CreateDialog 'GettingInform' 400 80