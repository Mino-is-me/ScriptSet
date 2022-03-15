import unreal as ue
# BP 컴포넌트 접근 순서
## 블루프린트 클래스 로드
### 디폴트 오브젝트 로드
#### 컴포넌트 로드 (get_editor_property)

def get_bp_c_by_name(__bp_dir:str):
    __bp_c = __bp_dir + '_c' 
    return __bp_c 

def get_bp_mesh_comp_by_name (__bp_c:str, __seek_comp_name:str) :
    #source_mesh = ue.load_asset(__mesh_dir)
    loaded_bp_c = ue.EditorAssetLibrary.load_blueprint_class(__bp_c)
    bp_c_obj = ue.get_default_object(loaded_bp_c)
    loaded_comp = bp_c_obj.get_editor_property(__seek_comp_name)
    return loaded_comp



