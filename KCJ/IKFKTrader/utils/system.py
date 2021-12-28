#-*-coding: utf-8-*-
import os
import json

def stringChange_Escape_BackSlash(string):
    partList = [part for part in repr(string).split("\\") if part]
    resultStr = eval( "/".join(partList) )
    return resultStr

def get_curDir() :
    # 이스케이프 문을 피하기 위해 raw문으로 변환합니다.
    path = os.path.dirname(__file__)
    path = stringChange_Escape_BackSlash(path)
    return path

def get_sourceDir() :
    return get_curDir().replace('utils', 'source')


def get_dataDir():
    return get_curDir().replace('utils', 'data')

def get_ui_main() :
    return get_sourceDir() + '/main.ui'

def save_dataJson( dataDict, filePath ):
    with open( filePath, 'w') as f:
        json.dump(dataDict, f, ensure_ascii=False)

def load_dataJson( filePath ):
    with open( filePath, 'r') as f:
        info = json.load(f)
    return info

def is_Exists_file(filePath):
    if os.path.exists(filePath) == False :
        return False
    if os.path.isfile(filePath) == False :
        return False

    return True

def get_cur_JsonDataList( fullPath = True ) :
    path = get_dataDir()
    file_list = os.listdir(path)
    file_list_json = [file for file in file_list if file.endswith(".json")]

    if fullPath == True :
        return [ path+'/'+fileName for fileName in file_list_json ]
    else :
        return file_list_json
