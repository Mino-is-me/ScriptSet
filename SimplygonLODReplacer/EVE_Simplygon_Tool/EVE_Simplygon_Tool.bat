title EVE Simplygon Batch Tool
@echo off
:menu
cls
echo EVE Simplygon Batch Tool
echo.
echo 0. Install (if resources and output directory not exist)
echo 1. Level Architecture
echo 2. Rock
echo 3. High Detail
echo 4. Deco
echo 5. Folaige
echo 6. Large Prop
echo 7. Middle Prop
echo 8. Small Prop
echo 9. Merged Prop
echo.
set /p menu= 
if "%menu%"=="0" goto Install
if "%menu%"=="1" goto LevelArchitecture
if "%menu%"=="2" goto Rock
if "%menu%"=="3" goto HighDetail
if "%menu%"=="4" goto Deco
if "%menu%"=="5" goto Folaige
if "%menu%"=="6" goto LargeProp
if "%menu%"=="7" goto MiddleProp
if "%menu%"=="8" goto SmallProp
if "%menu%"=="9" goto MergedProp
goto menu

Preset = "Empty"

:Install
cls
md "C:\Users\%username%\Documents\Simplygon\8\UI\Presets\EVE Presets"
md "%cd%\Output\Level Architecture"
md "%cd%\Output\Rock"
md "%cd%\Output\High Detail"
md "%cd%\Output\Deco"
md "%cd%\Output\Folaige"
md "%cd%\Output\Large Prop"
md "%cd%\Output\Middle Prop"
md "%cd%\Output\Small Prop"
xcopy "%cd%\Presets\EVE Presets" "C:\Users\%username%\Documents\Simplygon\8\UI\Presets\EVE Presets" /s /h /e /y
md Output
md Input
goto menu

:LevelArchitecture
cls
for /D %%f in (%cd%\Input\temp\*) do (
    move /y "%%f" "%cd%\Output\Level Architecture"
)
rd "%cd%\Input\temp\" /s /q
SimplygonBatch.exe --Input "%cd%\Input" --Spl "%cd%\Presets\Level Architecture.spl" --Output "%cd%\Output" --Verbose --OutputFileFormat "fbx"
goto done

:Rock
cls
for /D %%f in (%cd%\Input\temp\*) do (
    move /y "%%f" "%cd%\Output\Rock"
)
rd "%cd%\Input\temp\" /s /q
SimplygonBatch.exe --Input "%cd%\Input" --Spl "%cd%\Presets\Rock.spl" --Output "%cd%\Output" --Verbose --OutputFileFormat "fbx"
goto done

:HighDetail
cls
for /D %%f in (%cd%\Input\temp\*) do (
    move /y "%%f" "%cd%\Output\High Detail"
)
rd "%cd%\Input\temp\" /s /q
SimplygonBatch.exe --Input "%cd%\Input" --Spl "%cd%\Presets\High Detail.spl" --Output "%cd%\Output" --Verbose --OutputFileFormat "fbx"
goto done

:Deco
cls
for /D %%f in (%cd%\Input\temp\*) do (
    move /y "%%f" "%cd%\Output\Deco"
)
rd "%cd%\Input\temp\" /s /q
SimplygonBatch.exe --Input "%cd%\Input" --Spl "%cd%\Presets\Deco.spl" --Output "%cd%\Output" --Verbose --OutputFileFormat "fbx"
goto done

:Folaige
cls
for /D %%f in (%cd%\Input\temp\*) do (
    move /y "%%f" "%cd%\Output\Folaige"
)
rd "%cd%\Input\temp\" /s /q
SimplygonBatch.exe --Input "%cd%\Input" --Spl "%cd%\Presets\Folaige.spl" --Output "%cd%\Output" --Verbose --OutputFileFormat "fbx"
goto done

:LargeProp
cls
for /D %%f in (%cd%\Input\temp\*) do (
    move /y "%%f" "%cd%\Output\Large Prop"
)
rd "%cd%\Input\temp\" /s /q
SimplygonBatch.exe --Input "%cd%\Input" --Spl "%cd%\Presets\Large Prop.spl" --Output "%cd%\Output" --Verbose --OutputFileFormat "fbx"
goto done

:MiddleProp
cls
for /D %%f in (%cd%\Input\temp\*) do (
    move /y "%%f" "%cd%\Output\Middle Prop"
)
rd "%cd%\Input\temp\" /s /q
SimplygonBatch.exe --Input "%cd%\Input" --Spl "%cd%\Presets\Middle Prop.spl" --Output "%cd%\Output" --Verbose --OutputFileFormat "fbx"
goto done

:SmallProp
cls
for /D %%f in (%cd%\Input\temp\*) do (
    move /y "%%f" "%cd%\Output\Small Prop"
)
rd "%cd%\Input\temp\" /s /q
SimplygonBatch.exe --Input "%cd%\Input" --Spl "%cd%\Presets\Small Prop.spl" --Output "%cd%\Output" --Verbose --OutputFileFormat "fbx"
goto done

:MergedProp
cls
goto menu

:done
echo.
echo Finished to excute.
timeout 3 /nobreak>nul
exit