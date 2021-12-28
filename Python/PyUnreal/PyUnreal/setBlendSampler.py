import unreal 



'''NA Number'''
num = 39
'''NA Number'''


'''Default Directories'''
Basepath = '/Game/Art/Character/Monster/CH_M_NA_' + str(num) + '/'
BSAssetPath = Basepath + '/Animation/BlendSpace/' 
AnimAssetPath = Basepath + '/Animation/'
'''Default Directories'''

bsNames = ["IdleRun_BS_Peaceful", "IdleRun_BS_Battle", "Down_BS", "Groggy_BS", "LockOn_BS", "Airborne_BS"]

'''Value Set'''
runSpeed = 400 
walkSpeed = 150 
defaultSamplingVector = unreal.Vector(0.0, 0.0, 0.0)
defaultSampler = unreal.BlendSample()
defaultSampler.set_editor_property("sample_value",defaultSamplingVector)

Anims = unreal.EditorAssetLibrary.list_assets(AnimAssetPath)
'''Value Set end'''

'''BS Samplers Setting START '''

BS_idle_peace_path = BSAssetPath + bsNames[1]
BS_idle_peace = unreal.EditorAssetLibrary.load_asset(BS_idle_peace_path)
defaultSampler.set_editor_property("animation",


'''BS Samplers Setting END '''
i=0

while i < len(Anims):
    found_word = Anims[i].find('idle')
    if found_word != -1:
        print('yes')

