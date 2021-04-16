import unreal 
import os

RootPath = "/Game/Art/Character/Monster/CH_M_NA_"  #몬스터 폴더에 넘버링 전까지 고정 
LastPath = "/Animation/BlendSpace/" #BS 폴더 고정 

BsName_make = 'Airborne_BS'
BsName_origin = 'IdleRun_BS_Peaceful'
AnimName = '/Animation/Result_State_Airborne_L'

#공용 BlendSample 제작 
defaultSamplingVector = unreal.Vector(0.0, 0.0, 0.0)
defaultSampler = unreal.BlendSample()
defaultSampler.set_editor_property("sample_value",defaultSamplingVector)


#폴더 루프 돌면서 BS 생성 -> 애니메이션 할당 작업 
for i in range(26):
    if i > 0:
        if i < 10:
            FullPath = RootPath + '0' + str(i) + LastPath
            AnimPath = RootPath + '0' + str(i) + AnimName

        else:
            FullPath = RootPath + str(i) + LastPath 
            AnimPath = RootPath + str(i) + AnimName

        originBS = FullPath + BsName_origin
        makeBS = FullPath + BsName_make

        if unreal.EditorAssetLibrary.does_asset_exist(originBS) and not unreal.EditorAssetLibrary.does_asset_exist(makeBS):
            madenBS = unreal.EditorAssetLibrary.duplicate_asset(originBS,makeBS)
            
            if unreal.EditorAssetLibrary.does_asset_exist(AnimPath):
                AnimAsset = unreal.EditorAssetLibrary.load_asset(AnimPath)
                defaultSampler.set_editor_property("animation",AnimAsset)
                madenBS.set_editor_property("sample_data",[defaultSampler])


#BlendSample이 Vector값은 가지고 있지만 Reference Animation을 가지고 있지 않으면 nullptr 띄움.
#Editor에서 노출 안됩니다 ^_^
            









