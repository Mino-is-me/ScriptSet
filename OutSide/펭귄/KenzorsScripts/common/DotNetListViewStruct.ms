struct ListReportStruct
(
	rowTxt = #(),
	Tag = undefined
)
struct SelectedItemStruct
(
	Index =0,
	SubIndex =0,
	Tag =undefined
)
struct dotNetListViewStruct
(
	Lv,fillFn,
	ptrList,
	SelectedItems =#(),
	selectedIndices = #(),
	myChkBx = True,
	lastClick = 0,
	fn setBtn args =
	(
		lastClick = case ( args.button ) of
		(
			(Lv.MouseButtons.Left):#left
			(Lv.MouseButtons.Middle):#middle
			(Lv.MouseButtons.Right):#right
		)
	),
	fn DotNetColorFromMax col =
	(
		netColor = dotNetClass "System.Drawing.Color"
		netcolor.fromArgb col.r col.g col.b
	),
	ForeCol = DotNetColorFromMax ( color 225 215 210 ),
	BackCol = DotNetColorFromMax ( color 80 80 80 ),
	HighCol = DotNetColorFromMax (color 23 23 130),
	AltCol = DotNetColorFromMax ( red ),

	fn noSelection =
	(
		SelectedItems = #()
		selectedIndices = #()
		for i = 1 to lv.Items.count do lv.items.item[i - 1].backcolor = BackCol
	),
	fn subItemAtMousePos =
	(
		pos = lv.mousePosition
		pos = lv.PointToClient pos
		li = lv.getItemAt pos.x pos.y
		if li != undefined then
		(
			si = li.getSubItemAt pos.x pos.y
			i = li.index+1
			j = (li.subitems.indexof si) +1
			#(i,j) -- index + 1 because listview array starts at 0 whereas max array starts at 1
		)else false
	),
	fn GetSelection =
	(
		selectedIndices = for i = 0 to ( lv.selectedIndices.count - 1 )  collect lv.selectedIndices.item[i]+1
		setColour = #{1..(lv.Items.count)}
		SelectedItems = for i in selectedIndices collect 
		(
			setColour[i] = false -- bitarray index starts at 1
			lv.items.item[i-1].tag.value --listview item index starts at 0
		)
		for i = 1 to lv.Items.count do lv.items.item[i-1].backcolor = ( if setColour[i] then BackCol else  highCol )
	),
	fn setSelection =
	(
		for i in selectedIndices where ( i <= lv.Items.count ) do lv.selectedIndices.Add (i-1)
		getSelection()
	),
	fn setIndex indexlist = 
	(
		selectedIndices = indexlist
		setSelection()
	),
	fn addIndex indexList =
	(
		for i in indexList do appendIfUnique selectedIndices i
		setSelection()
	),
	fn AddItemAtMousePos =
	(
		theIndex = subItemAtMousePos()
		print theIndex
		if theIndex != false do addIndex #(theIndex[1])
	),
	fn selectIndexAtMouse =
	(
		n = subItemAtMousePos()
		if n == false then noSelection() else setIndex #(n[1])
	),
	fn init layout_def chkBx:True drop:false multi:false =
	(
		lv.allowdrop = drop
		lv.gridLines = true  
		lv.View = (dotNetClass "System.Windows.Forms.View").Details
		lv.LabelEdit = false
		lv.fullRowSelect = true 
		lv.multiselect = multi
		lv.ForeColor = ForeCol
		lv.backColor = BackCol
		lv.checkboxes = myChkBx = chkBx
		
		for i in layout_def do
		(
			lv.Columns.add i[1] i[2] --add column with name and optional width
		)
		--lv.refresh()
	),
	fn fill  =
	(
		lv.items.clear()
		theRange = #()
	
		for obj in *ptrList do
		(
			li = dotNetObject "System.Windows.Forms.ListViewItem" ""
			report = Fillfn obj
			mysubItems = report.rowtxt
			if report.tag != undefined do li.tag  = dotNetMXSValue report.tag 
			if myChkBx then li.checked = mysubItems[1] else li.text = mysubItems[1]
			for i = 2 to mysubItems.count do 
			(
				sub_li = li.SubItems.add mysubItems[i]
				--sub_li.tag = i
			)
			append theRange li --we add the list item to the array
		)
		lv.Items.AddRange theRange --when done, we populate the ListView
		lv.refresh()
		setSelection()
	)

)

