import unreal 
import re 


re.search(seek, anim_list)


for each in anim_list :
    result = re.search(seek, each)
    if result != None :
        print(result)
        print(each)