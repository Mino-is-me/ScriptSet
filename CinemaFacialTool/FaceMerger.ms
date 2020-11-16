global fbxes = #()
global dir = ""
global OriginSceneOld = getThisScriptFilename() 
OriginScene = "Z:\\ART_Backup\\ScriptData\\CinemaFacialTool\\Origin_eve.max"
OriginScene1 = "Z:\\ART_Backup\\ScriptData\\CinemaFacialTool\\Origin_lilly.max"
Try(destroyDialog FaceMerger) Catch()

rollout FaceMerger "Face Merger"
(
	editText 'edt_Folder' "Directories : " 
	dropDownList 'ddl_faceOwner' "Who?" items:#("EVE","Lilly") 
	button 'btn_press' "←"
	--dropDownList 'ddl_faceOwner' "Who?" items:#("EVE","Lilly") 
	on btn_press pressed do 
	(
		dir = FaceMerger.edt_Folder.text 
		fbxes = getDirectories ((FaceMerger.edt_Folder.text ) + "\\*")
		for i in fbxes do 
		(
			AniFolder = i + "Animation\\"
			FBXFile = getFiles (AniFolder + "*.fbx")
			case FaceMerger.ddl_faceOwner.selection of 
			(
				1 : loadMaxFile OriginScene quiet:true 
				2 : loadMaxFile OriginScene1 quiet:true
			)
			importfile FBXFile[1] #noPrompt using:FBXIMP
			
			frameRate = 30 
			
			case FaceMerger.ddl_faceOwner.selection of 
			(
				1 : faceMesh = $EVE_Face_E
				2 : faceMesh = $Lilly_Head
			)
			
			local faceNameEVE = findString faceMesh.name "EVE" 
			local faceNameLilly = findString faceMesh.name "Lilly"
			if faceNameEVE != undefined then 
			(
				faceMesh.material[1].diffuseMap = BitmapTexture fileName:"Z:\ART_Backup\ScriptData\CinemaFacialTool\TextureSet\EVE\diffuse_face.tga"
				faceMesh.material[5].Opacity = 0.0
				faceMesh.material[6].diffuseMap = BitmapTexture fileName:"Z:\ART_Backup\ScriptData\CinemaFacialTool\TextureSet\Lilly\diffuse_Eye.tga"
				faceMesh.material[6].diffuseMap.coords.U_Tiling = 3.0
				faceMesh.material[6].diffuseMap.coords.V_Tiling = 3.0
			)
		
			else if faceNameLilly != undefined then 
			(
				faceMesh.material[8].diffuseMap = BitmapTexture fileName:"Z:\ART_Backup\ScriptData\CinemaFacialTool\TextureSet\Lilly\diffuse_face.tga"
				faceMesh.material[5].Opacity = 0.0
				faceMesh.material[3].diffuseMap = BitmapTexture fileName:"Z:\ART_Backup\ScriptData\CinemaFacialTool\TextureSet\Lilly\diffuse_Eye.tga"
				faceMesh.material[3].diffuseMap.coords.U_Tiling = 1.5
				faceMesh.material[3].diffuseMap.coords.V_Tiling = 1.5

				setCVertMode faceMesh false
			)


			delete $Dummy001
			skinOps.addbone faceMesh.skin $Bip001_Head 1
			select faceMesh
			macros.run "Modifier Stack" "SubObject_1"
			Max Select All 
			skinOps.setWeight faceMesh.modifiers[#Skin] 1
			SceneName = substituteString FBXFile[1] ".FBX" ".MAX"
			saveMaxFile SceneName quiet:true 
			resetMaxFile #noPrompt

		)

	)
)

createDialog FaceMerger