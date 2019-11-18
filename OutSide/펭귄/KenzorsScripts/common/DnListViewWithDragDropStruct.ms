/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- dot Net List View With DragDrop functions
-- By ken turner
-- www.designimage.co.uk
*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
struct dnListViewWithDragDropStruct
(
	Lv,fillFn,
	ptrList,
	SelectedRow = 0,
	SelectedColumn = 0,
	DragFromRow = 0,
	DragFromColumn = 0,
	lastClick = undefined,
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
	fn ClearHighLight =
	(
		for i = 1 to lv.Items.count do lv.items.item[i-1].backcolor = BackCol
	),
	fn setHighLight i =
	(
		if i > 0 then lv.items.item[i-1].backcolor = HighCol
	),
	fn refeshCellText r c =
	(
		theObject = (*ptrList)[r]
		lv.items.item[r-1].subitems.item[c-1].text = (Fillfn theObject)[c] --- what if  c ==1
	),
	fn RefreshRowText r =
	(
		theObject = (*ptrList)[r]
		txtArray = (Fillfn theObject)
		for c = 1 to ( txtArray.count ) do
		(
			lv.items.item[r-1].subitems.item[c-1].text = txtArray[c]
		)
	),
	fn setSelection i column:0 =
	(
		ClearHighLight()
		SelectedRow = if i > lv.Items.count then lv.Items.count else i
		if SelectedRow > 0 then setHighLight SelectedRow
		SelectedColumn = column
	),
	fn SelectMousePos =
	(
		pos = lv.mousePosition
		pos = lv.PointToClient pos
		li = lv.getItemAt pos.x pos.y
		if li!= undefined then
		(
			si = li.getSubItemAt pos.x pos.y
			SelectedRow = li.index+1
			SelectedColumn = (li.subitems.indexof si) +1
			
		)else 
		(
			SelectedRow = 0
			SelectedColumn = 0
		)
	),
	fn SelectAndHighLightMousePosition =
	(
		SelectMousePos()
		ClearHighLight()
		if SelectedRow > 0 then setHighLight SelectedRow
	),
	fn init layout_def chkBx:false multi:false drop:false =
	(
		lv.allowdrop = drop
		lv.gridLines = true  
		lv.View = (dotNetClass "System.Windows.Forms.View").Details
		lv.LabelEdit = false
		lv.fullRowSelect = true 
		lv.multiselect = multi
		lv.ForeColor = ForeCol
		lv.backColor = BackCol
		lv.checkboxes = chkBx
		
		for i in layout_def do
		(
			lv.Columns.add i[1] i[2] --add column with name and optional width
		)
		--lv.refresh()
	),
	fn fill  =
	(
		
		topIndex = if lv.items.count >0 then lv.TopItem.index else undefined -- remember the position 
			
		lv.items.clear()
		theRange = #()
	
		for obj in *ptrList do
		(
			li = dotNetObject "System.Windows.Forms.ListViewItem" ""
			mysubItems = Fillfn obj
			li.text = mysubItems[1]
			for i = 2 to mysubItems.count do 
			(
				sub_li = li.SubItems.add mysubItems[i]
			)
			append theRange li --we add the list item to the array
		)
		lv.Items.AddRange theRange --when done, we populate the ListView
		lv.refresh()
		-- setSelection()
		
		if topIndex != undefined and ( lv.items.count > 0) then --- scroll the list view back to it orginal location
		(
			if topIndex > lv.items.count  then topIndex = lv.items.count - 1
			lv.TopItem = lv.items.item[ topIndex]
		)	
	),
	fn lvDragDrop arg =
	(
		theList = *ptrList
		SelectMousePos()
		if DragFromRow != SelectedRow then 
		(
			theObject = theList[DragFromRow]
			if SelectedRow == 0 then SelectedRow = theList.count
			if DragFromRow > SelectedRow then DragFromRow += 1
			InsertAtRow = if SelectedRow > DragFromRow then ( SelectedRow + 1 ) else SelectedRow
			insertItem theObject theList InsertAtRow
			deleteItem theList DragFromRow
			fill()
			setHighLight SelectedRow
			true
		) else false
	),
	fn lvDragOver arg =
	(
		if ( DragFromRow > 0)  do
		(
			local dragDropEffect = dotNetclass "System.Windows.Forms.DragDropEffects"
			arg.effect = dragDropEffect.move
		)
	),
	fn lvItemDrag arg =
	(
		DragFromRow = SelectedRow
		DragFromColumn = SelectedColumn
		if DragFromRow > 0 do 
		(
			local effect = dotNetclass "System.Windows.Forms.DragDropEffects"	
			lv.DoDragDrop arg.item effect.move
		)
	)
)