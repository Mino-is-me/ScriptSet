(
	local hForm = dotNetObject "MaxCustomControls.MaxForm"
	hForm.Size = dotNetObject "System.Drawing.Size" 640 480
	hForm.FormBorderStyle = (dotnetclass "System.Windows.Forms.FormBorderStyle").FixedToolWindow
	hForm.Text = ""
	hForm.ShowInTaskbar = False
	
	local txtbox = dotNetObject "System.Windows.Forms.TextBox"
	txtbox.location=dotNetObject "System.Drawing.Point" 10 10
	
	
	local txtbox2 = dotNetObject "System.Windows.Forms.TextBox"
	txtbox2.location=dotNetObject "System.Drawing.Point" 10 40
	
	local cmbbox = dotNetObject "System.Windows.Forms.ComboBox"
	cmbbox.location=dotNetObject "System.Drawing.Point" 10 80
	
	local dnKeys=dotnetclass "System.Windows.Forms.Keys"
	
	hform.controls.add(txtbox)
	hform.controls.add(txtbox2)
	hform.controls.add(cmbbox)
	
	local theKey=false
	
	fn txtbox_KeyDown sender eb =
	(	
			if (eb.Keycode==dnKeys.Tab) OR (eb.Keycode==dnKeys.Return)  then theKey=eb.KeyCode else theKey=false
	)
	fn txtbox_KeyPress sender eb =
	(
		if theKey!=false then 
		(
			case theKey of
			(
				(dnKeys.Tab): hform.selectnextcontrol hform.ActiveControl true true  false false
				(dnKeys.Return): print "Return"
			)			
		)
	)
	
	dotnet.addEventHandler txtbox "KeyDown" txtbox_KeyDown
	dotnet.addEventHandler txtbox "KeyPress" txtbox_KeyPress
	
	dotnet.addEventHandler txtbox2 "KeyDown" txtbox_KeyDown
	dotnet.addEventHandler txtbox2 "KeyPress" txtbox_KeyPress
	
	hForm.ShowModeless()
)