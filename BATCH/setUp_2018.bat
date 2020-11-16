@echo off
cls

rem [Copy Script Files]
echo [Copy script files to 3ds Max 2018]
echo.
set scriptDest=%localappdata%\Autodesk\3dsMax\2018 - 64bit\ENU\usermacros\
set iconDest=%localappdata%\Autodesk\3dsMax\2018 - 64bit\ENU\usericons\


copy *.mcr "%scriptDest%"
copy .\icons\*.bmp "%iconDest%"


echo.
pause