@echo off
cls

rem [Copy Script Files]
echo [Copy script files to 3ds Max 2020]
echo.
set scriptDest=%localappdata%\Autodesk\3dsMax\2020 - 64bit\ENU\usermacros\
set iconDest=%localappdata%\Autodesk\3dsMax\2020 - 64bit\ENU\usericons\


copy Script\ "%scriptDest%"
echo.
pause