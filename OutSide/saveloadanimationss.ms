--function definitions:
fn getPosActiveCnt pc = --what is the active position controller?  function
(
	if (classof pc == position_list or classof pc == position_layer) then ppc = pc[pc.active] else ppc = pc
	if classof ppc == springPositionController then ppcc=ppc.position.controller else ppcc=ppc
	if ppcc.controller != undefined and (classof ppcc.controller == position_list or classof ppcc.controller == position_layer) then ppccc= getPosActiveCnt ppcc.controller else ppccc=ppcc
	if ppccc.controller!= undefined then (return ppccc.controller) else (return ppccc)
	)

fn getRotActiveCnt rc=  --what is the active rotation controller?  function
(
	if (classof rc == rotation_list or classof rc == rotation_layer) then rrc = rc[rc.active] else rrc = rc
	if rrc.controller != undefined and (classof rrc.controller == rotation_list or classof rrc.controller == rotation_layer) then rrcc= getRotActiveCnt rrc.controller else rrcc=rrc
	if rrcc.controller != undefined then (return rrcc.controller) else (return rrcc)
	)

fn getScaleActiveCnt sc=  --what is the active scale controller?  function
(
	if (classof sc == scale_list or classof sc == scale_layer) then ssc = sc[sc.active] else ssc = sc
	if ssc.controller != undefined and (classof ssc.controller == scale_list or classof ssc.controller == scale_layer) then sscc= getScaleActiveCnt ssc.controller else sscc=ssc
	if sscc.controller != undefined then (return sscc.controller) else (return sscc)
	)	

fn writeBezierKeys cnt ff st en = --write bezier keys function
(
	cntk=#()
	for kk in cnt.keys do 
	(
		if kk.time >=st and kk.time<=en then append cntk kk else()
		)
	format "\t\t%\n" cntk.count to:ff
	for i=1 to cntk.count do
	(
		format "\t\t% % % % % % % % % % % % %\n" (cntk[i].time-st) cntk[i].value cntk[i].inTangentType cntk[i].inTangent cntk[i].inTangentLength cntk[i].outTangentType cntk[i].outTangent cntk[i].outTangentLength cntk[i].freeHandle cntk[i].x_locked cntk[i].y_locked cntk[i].z_locked cntk[i].constantVelocity to:ff
		)
	)

fn writeTCBKeys cnt ff st en = --write tcb keys function
(
	cntk=#()
	for kk in cnt.keys do 
	(
		if kk.time >=st and kk.time<=en then append cntk kk else()
		)
	format "\t\t%\n" cntk.count to:ff
	for i=1 to cntk.count do
	(
		format "\t\t% % % % % % %\n" (cntk[i].time-st) (at time cntk[i].time cnt.value) cntk[i].tension cntk[i].continuity cntk[i].bias cntk[i].easeto cntk[i].easefrom to:ff
		)
	)

fn pcase cnt =  --what kind of controller is the active position controller? 
(
	case (classof cnt) of 
	(
		position_xyz:a=1
		tcb_position:a=2
		bezier_position:a=3
		default:a=4
		)
	)

fn rcase cnt =  --what kind of controller is the active rotation controller? 
(
	case (classof cnt) of 
	(
		euler_xyz:a=1
		tcb_rotation:a=2
		default:a=4
		)
	)

fn scase cnt =  --what kind of controller is the active position controller? 
(
	case (classof cnt) of 
	(
		scalexyz:a=1
		tcb_scale:a=2
		bezier_scale:a=3
		default:a=4
		)
	)
	
fn loadBezierKeys cnt ffl kn pffset= --load bezier keys functions
(
	for i=1 to kn do
	(
		t=readvalue ffl
		val=readvalue ffl
		intgt=readvalue ffl
		intg=readvalue ffl
		intgl=readvalue ffl
		outtgt=readvalue ffl
		outtg=readvalue ffl
		outtgl=readvalue ffl
		frh=readvalue ffl
		xlk=readvalue ffl
		ylk=readvalue ffl
		zlk=readvalue ffl
		constvel=readvalue ffl
		kk=addNewKey cnt (t+pffset)
		kk.value=val
		kk.inTangent=intg
		kk.inTangentLength=intgl
		kk.outTangent=outtg
		kk.outTangentLength=outtgl
		kk.freeHandle=frh
		kk.x_locked=xlk
		kk.y_locked=ylk
		kk.z_locked=zlk
		kk.constantVelocity=constvel
		kk.inTangentType=intgt
		kk.outTangentType=outtgt
		)
	)

fn loadTCBkeys cnt ffl kn pffset=
(
	for i=1 to kn do
	(
		t=readvalue ffl
		val=readvalue ffl
		tns=readvalue ffl
		cont=readvalue ffl
		bbias=readvalue ffl
		eto=readvalue ffl
		efrom=readvalue ffl
		kk=addNewKey cnt (t+pffset)
		with animate on at time (t+pffset) cnt.value=val
		kk.tension=tns
		kk.continuity=cont
		kk.bias=bbias
		kk.easeto=eto
		kkeasefrom=efrom
		)
	)

rollout sL "Save/Load Animation" width:223 height:329
(
	
	button svb "Save Animation" pos:[66,71] width:90 height:30
	button ldb "Load Animation" pos:[66,227] width:90 height:30
	spinner spn2 "At Frame" pos:[71,200] width:80 height:16 range:[-1e+007,1e+007,0] type:#integer scale:0.1
	GroupBox grp1 "Save" pos:[16,2] width:191 height:167
	GroupBox grp2 "Load" pos:[14,183] width:195 height:135
	
	spinner spn5 "From" pos:[41,20] width:64 height:16 enabled:false range:[-1e+007,1e+007,(animationRange.start as integer)/TicksPerFrame] type:#integer 
	spinner spn6 "To" pos:[118,20] width:64 height:16 enabled:false range:[-1e+007,1e+007,(animationRange.end as integer)/TicksPerFrame] type:#integer 
	checkbox chk8 "Time Range" pos:[70,47] width:103 height:16 checked:true
	progressBar pbrr "" pos:[27,288] width:168 height:16 value:0 color:(color 192 20 20)
	progressBar pbrr2 "" pos:[27,141] width:168 height:16 value:0 color:(color 20 192 20)
	label lbl3 "" pos:[26,111] width:170 height:19
	label lbl4 "" pos:[26,261] width:170 height:19
	
	on svb pressed do  -- the save animation button
	(
		if selection.count == 0 then (messagebox "No Object Selected")
		else
		(
			ss = getSaveFileName types:"Animation files (*.acts)|*.acts" --asks for the save path and file
			if ss != undefined then
			(
				ff = createfile ss --creates the save file
				
				if chk8.checked == true then
				(
					stt=animationRange.start --start time
					ent=animationRange.end -- end time
					)
				else
				(
					stt=spn5.value as time --start time
					ent=spn6.value as time -- end time
					)
				format "%\n" (((ent-stt) as integer)/ticksperframe) to:ff
					
				for i = 1 to selection.count do  -- takes every object and.....
				(
					pbrr2.value = 100.*i/selection.count --the progress bar 
					o=selection[i]
					lbl3.text=o.name
					format "% \n" o.name to:ff -- write the object name
					pcnt=getPosActiveCnt o.position.controller
					rcnt =getRotActiveCnt o.rotation.controller
					scnt=getScaleActiveCnt o.scale.controller
					format "\tposition_controller_type %\n" (pcase pcnt) to:ff --writes the position controller type
					case pcase pcnt of --write position keys
					(
						1:(
							writeBezierKeys pcnt.x_position.controller ff stt ent
							writeBezierKeys pcnt.y_position.controller ff stt ent
							writeBezierKeys pcnt.z_position.controller ff stt ent
								)
						2:(
							writeTCBKeys pcnt ff stt ent
								)
						3:(
							writeBezierKeys pcnt ff stt ent
								)
						default:(print "muie")
						)   --end write position keys
					
					format "\trotation_controller_type %\n" (rcase rcnt) to:ff -- writes the rotation controller type
					case rcase rcnt of  --write rotation keys
					(
						1:(
							writeBezierKeys rcnt.x_rotation.controller ff stt ent
							writeBezierKeys rcnt.y_rotation.controller ff stt ent
							writeBezierKeys rcnt.z_rotation.controller ff stt ent
								)
						2:(
							writeTCBKeys rcnt ff stt ent
								)
						default:(print "muie")
					
						)  --end write rotation keys
						
					format "\tscale_controller_type %\n" (scase scnt) to:ff -- writes the scale controller type
					case scase scnt of  --write scale keys
					(
						1:(
							writeBezierKeys scnt.x_scale.controller ff stt ent
							writeBezierKeys scnt.y_scale.controller ff stt ent
							writeBezierKeys scnt.z_scale.controller ff stt ent
								)
						2:(
							writeTCBKeys scnt ff stt ent
								)
						3:(
							writeBezierKeys scnt ff stt ent
								)
						default:(print "muie")
						)  --end write scale keys
					pbrr2.value=0
					lbl3.text="Completed"
					)
				)
			else()
			)
		)
	on ldb pressed do -- the load animation button
	(
		if selection.count == 0 then (messagebox "No Object Selected")
		else
		(
			fload= getOpenFileName types:"Animation files (*.acts)|*.acts" -- asks for the saved file
			if fload !=undefined then
			(
				pffset = spn2.value as time  --the time offset
				ff=openfile fload --opens the saved file
				rng=readvalue ff
				for i=1 to selection.count do --takes every selected object and...
				(
					o=selection[i]
					lbl4.text=o.name
					pbrr.value = 100.*i/selection.count --the progress bar 
					
					pcnt=getPosActiveCnt o.position.controller -- what is the active position controller?
					rcnt=getRotActiveCnt o.rotation.controller -- what is the active rotation controller?
					scnt=getScaleActiveCnt o.scale.controller -- what is the active scale controller?
					
					--deleting the existing active controllers keys in range:
					selectKeys pcnt pffset (pffset + rng)
					deletekeys pcnt #selection
					selectKeys rcnt pffset (pffset + rng)
					deletekeys rcnt #selection
					selectKeys scnt pffset (pffset + rng)
					deletekeys scnt #selection
					
					seek ff 0 --goes to begining of the saved file
					skiptostring ff (o.name + " ") --goes to object line
					
					if (eof ff) == false then  -- tests if the object exists in the saved file
					(
						skiptostring ff "position_controller_type" --goes to saved position controller line --begining of reading position controller
						pct=readvalue ff --gets the saved position controller type
						if pct == pcase pcnt then --tests if the saved position controller type is the same as actual position controller type
						(
							case pct of --loads the position controller keys
							(
								1:( --position_xyz
										knx=readvalue ff
										ffx=""
										for i=1 to knx do ffx=ffx+readline ff
										fflx=ffx as stringstream
										loadBezierKeys pcnt.x_position.controller fflx knx pffset
										
										kny=readvalue ff
										ffy=""
										for i=1 to kny do ffy=ffy+readline ff
										ffly=ffy as stringstream
										loadBezierKeys pcnt.y_position.controller ffly kny pffset
										
										knz=readvalue ff
										ffz=""
										for i=1 to knz do ffz=ffz+readline ff
										fflz=ffz as stringstream
										loadBezierKeys pcnt.z_position.controller fflz knz pffset
										)
								2:( --tcb
										knw=readvalue ff
										ffw=""
										for i=1 to knw do ffw=ffw+readline ff
										fflw=ffw as stringstream
										loadTCBKeys pcnt fflw knw pffset
										)
								3:( --bezier_position
										knw=readvalue ff
										ffw=""
										for i=1 to knw do ffw=ffw+readline ff
										fflw=ffw as stringstream
										loadBezierKeys pcnt fflw knw pffset
										)
								default:(print "muie")
								)
							)
						else(print ("--some controllers are of a different type than the saved controllers - "+o.name +": " + (pcnt as string)))
						-- end of reading position controller
						
						skiptostring ff "rotation_controller_type" --goes to saved position controller line --begining of reading position controller
						rct=readvalue ff --reads the saved rotation controller type
						if rct == rcase rcnt then --tests if the saved rotation controller type is the same as actual rotation controller type
						(
							case rct of --loads the rotation controller keys
							(
								1:( --euler_xyz
										knx=readvalue ff
										ffx=""
										for i=1 to knx do ffx=ffx+readline ff
										fflx=ffx as stringstream
										loadBezierKeys rcnt.x_rotation.controller fflx knx pffset
										
										kny=readvalue ff
										ffy=""
										for i=1 to kny do ffy=ffy+readline ff
										ffly=ffy as stringstream
										loadBezierKeys rcnt.y_rotation.controller ffly kny pffset
										
										knz=readvalue ff
										ffz=""
										for i=1 to knz do ffz=ffz+readline ff
										fflz=ffz as stringstream
										loadBezierKeys rcnt.z_rotation.controller fflz knz pffset
										)
								2:( --tcb
										knw=readvalue ff
										ffw=""
										for i=1 to knw do ffw=ffw+readline ff
										fflw=ffw as stringstream
										loadTCBKeys rcnt fflw knw pffset
										)
								default:(print "muie")
								)
							)
						else(print ("--some controllers are of a different type than the saved controllers - "+o.name+": " + (rcnt as string)))
						-- end of reading position controller
							
						skiptostring ff "scale_controller_type" --goes to saved scale controller line --begining of reading scale controller
						sct=readvalue ff --gets the saved scale controller type
						if sct == scase scnt then --tests if the saved scale controller type is the same as actual scale controller type
						(
							case sct of --loads the scale controller keys
							(
								1:( --scale_xyz
										knx=readvalue ff
										ffx=""
										for i=1 to knx do ffx=ffx+readline ff
										fflx=ffx as stringstream
										loadBezierKeys scnt.x_scale.controller fflx knx pffset
										
										kny=readvalue ff
										ffy=""
										for i=1 to kny do ffy=ffy+readline ff
										ffly=ffy as stringstream
										loadBezierKeys scnt.y_scale.controller ffly kny pffset
										
										knz=readvalue ff
										ffz=""
										for i=1 to knz do ffz=ffz+readline ff
										fflz=ffz as stringstream
										loadBezierKeys scnt.z_scale.controller fflz knz pffset
										)
								2:( --tcb
										knw=readvalue ff
										ffw=""
										for i=1 to knw do ffw=ffw+readline ff
										fflw=ffw as stringstream
										loadTCBKeys scnt fflw knw pffset
										)
								3:( --bezier_scale
										knw=readvalue ff
										ffw=""
										for i=1 to knw do ffw=ffw+readline ff
										fflw=ffw as stringstream
										loadBezierKeys scnt fflw knw pffset
										)
								default:(print "muie")
								)
							)
						else(print ("--some controllers are of a different type than the saved controllers - "+o.name+": " + (pcnt as string)))
						-- end of reading scale controller
						)
					else() -- if the object does not exist in the saved file nothing happens
					)
					
				pbrr.value = 0 --the progress barr resets
				lbl4.text="Completed"
				close ff -- close file (i don't know if that's necessary :D)
				)
			else()
			)
		)
	on spn5 changed val do
		(if spn5.value>spn6.value then spn6.value = spn5.value+1 else())
	on spn6 changed val do
		(if spn6.value<spn5.value then spn5.value = spn6.value-1 else())
	on chk8 changed state do
	(
		spn5.enabled = not spn5.enabled
		spn6.enabled = not spn6.enabled
		)
)
createdialog sl