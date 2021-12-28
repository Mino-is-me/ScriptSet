툴을 실행하기 위해 아래와 같이 MaxScript 로 실행하시면 됩니다.

 
--IKFKTrader
python.ExecuteFile "Z:/ART_Backup/EVE_ANI/KCJ_Script/IKFKTrader_open.py"

--IKFKTrader for Macro
macroScript KCJ_IKFKTrader
    buttonText:"KCJ_IKFKTrader"
    category:"KCJ_AniToolLib"
    tooltip:"IKFKTrader"
    (
        python.ExecuteFile "Z:/ART_Backup/EVE_ANI/KCJ_Script/IKFKTrader_open.py"
    )