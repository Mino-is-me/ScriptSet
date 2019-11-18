import maya.cmds as mel
import inspect 
'''
def sherlock(__function_name__, __watch_value__):
    __title_string__ = '#function name = ' + __function_name__ 
    print(__title_string__) 
    __main_string__ = '#value = ' + __watch_value__
    print(__watch_value__)
'''
def get_lastest_added_customAttr():
    __attr_lists__ = mel.listAttr()
    __list_count__ = len(__attr_lists__) - 1
    __latest_attr__ = __attr_lists__[__list_count__]
    return __latest_attr__

def is_lastest_attr_is_customAlpha:
    __attr__ = get_lastest_added_customAttr()
    __is_custom_alpha__ = __attr__ == 'CustomAlpha'
    
    if __is_custom_alpha__:
        return True
    else:
        return False


def set_custom_alpha_attributes():
    __driver__ = mel.ls(selection=True)
    print(__driver__)
    
    mel.select(__driver__)
    mel.addAttr( longName='CustomAlpha',defaultValue=0.0, minValue=0.0, maxValue=1.0)
    
    #sherlock(set_custom_alpha_attributes.__name__,__driver__.__name__)

#def set_drivenkey() 

__this_has_attr__ = is_lastest_attr_is_customAlpha()

if __this_has_attr__:
    set_custom_alpha_attributes()
