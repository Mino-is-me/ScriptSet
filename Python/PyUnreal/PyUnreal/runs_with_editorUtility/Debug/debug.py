import unreal as ue 
import re 
from typing import List

import_task: object  = ue.AssetImportTask()
fac: object          = ue.BlendSpaceFactoryNew()
can_create_new: bool = fac.get_editor_property('create_new')



import_task.automated = True
import_task.factory = fac


fac.set_editor_property('asset_import_task',import_task)


ue.AssetTools.create_asset('bb', '/Game/Art', ue.BlendSpace, fac)