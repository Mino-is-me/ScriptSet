---------------------------------------------------------------------------------------
--
--	How to use the script: 
--	Enter the no. of LOD's to be generated.
--	Enter the vert % per LOD to be reduced.
--	Select mesh/es and hit 'Generate' button. 
--	Retains skin modifier on the LOD's
--
--	What does it do:
--	Generates LOD's for the selected geo. 
--
--	Created by Abhishek Subba.
--	Email:  born2animate@gmail.com
--
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

rollout LODRollout "LOD Creator"
(
	--GUI
	group "Description"
	(
		label lab1 "- Enter the no. of LOD's to be generated. " align:#left;
		label lab2 "- Enter the vert % per LOD to be reduced. " align:#left;
		label lab3 "- Select mesh/es and hit 'Generate' button. " align:#left;
		label	lab4 "- Generates LOD's for the selected geo. " align:#left;
	)
	group ""
	(
		spinner LOD_count "LOD Count:" range:[1,10,1] type:#integer;
		spinner vert_perc "Vert %:" range:[5,100,10] type:#integer;
		progressbar obj_prog color:blue; 
		progressbar LOD_prog color:green; 
	)
	group ""
	(
		button genLOD_btn "Generate" width:210 height:40;
	)
	
	-- generate LOD function
	fn genLOD origGeo vertPer LODCount = 
	(
		-- variable declaration 
		geo = "geo";
		
		select origGeo;
		-- check for the geo type
		if( (classOf origGeo) == Editable_Poly) then
		(
			geo = "poly";
		)
		else
		(
			geo = "mesh";
		)
		
		undo on
		(
			-- LOD creation
			try
			(
				select origGeo;
				if(IsValidNode (getNodeByName (origGeo.name + "_LOD" + ( LODCount as string)))) then
				(
					messageBox ("Object named " + (origGeo.name + "_LOD" + ( LODCount as string)) + " already exists.\nScript will skip this LOD.");
				)
				else
				(
					maxOps.cloneNodes origGeo cloneType:#copy newNodes:&nnl
					nnl.name =origGeo.name + "_LOD" + ( LODCount as string);
					objLOD2 = getNodeByName (origGeo.name + "_LOD" + ( LODCount as string));
					select objLOD2;
					modPanel.setCurrentObject $.baseObject
					modPanel.addModToSelection (MultiRes ()) ui:on	
					objLOD2.MultiRes.vertexPercent = vertPer;
					objLOD2.MultiRes.generate = true;
					max select none;
					select objLOD2; 
					objLOD2.MultiRes.generate = true;
					modPanel.setCurrentObject $.modifiers[#MultiRes]
					if (geo == "poly" ) then 
					(
						modPanel.addModToSelection (Edit_Poly ()) ui:on
						MIndex = modPanel.getModifierIndex $ $.modifiers[#Edit_Poly]; 
						maxOps.CollapseNodeTo $ MIndex off						
					)
					else
					(
						modPanel.addModToSelection (Edit_Mesh ()) ui:on
						MIndex = modPanel.getModifierIndex $ $.modifiers[#Edit_Mesh]; 
						maxOps.CollapseNodeTo $ MIndex off
					)
					select origGeo;
				)
			)
			catch
			(
				messagebox "Process failure!!";
			)
		)
		return true;
	)
	
	on genLOD_btn pressed do
	(
		selObj = getCurrentselection();
		if(selObj.count < 1 ) then
		(
			messagebox "Please select a mesh";
		)
		else
		(	
			try
			(
				lodCount = LOD_count.value;
				vPer = vert_perc.value;
				j = 0;			
				for obj in selObj do
				(
					j = j +1;
					obj_prog.value = 100.*j/selObj.count ; 
					
					-- checks if the selected object is a geo or not
					if( (classOf obj) != Editable_Poly and (classOf obj) != Editable_Mesh and (classOf obj) != PolyMeshObject) then 
					(
						messagebox (obj.name + " is not a geometry.\n Script will skip this object");
					)
					else
					(
						for i=1 to lodCount do
						(
							--LOD function call
							--genLOD origGeo vertPer LODCount
							genLOD obj vPer i;
							LOD_prog.value = 100.*i/lodCount 
						)
					)
					LOD_prog.value = 0;
				)
				obj_prog.value = 0;
				messagebox "LOD's created!! ";
			)
			catch
			(
				messagebox "Process failure";
			)
		)
	)
)

rollout aRoll "Author"
(
	label lab5 "Created by Abhishek Subba";
	label lab6 "Email: born2animate@gmail.com";
)

lodRollF = newRolloutFloater "LOD Creator" 250 330;
addRollout LODRollout lodRollF;
addRollout aRoll lodRollF;
