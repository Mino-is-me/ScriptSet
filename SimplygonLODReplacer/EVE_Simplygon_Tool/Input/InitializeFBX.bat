@echo off
for %%f in (*.fbx) do for /F "tokens=1 delims=." %%p in ("%%f") do (md "%cd%\temp\%%p\LOD0")
for %%f in (*.fbx) do for /F "tokens=1 delims=." %%p in ("%%f") do (xcopy "%cd%\%%p.fbx" "%cd%\temp\%%p\LOD0\" /y)