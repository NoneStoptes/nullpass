@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1
title NullPass Installer

echo NullPass installer
echo ------------------

where python >nul 2>&1
if %errorlevel% neq 0 (
    echo Python not found. Get it from https://www.python.org/downloads/
    echo Check "Add Python to PATH" during install.
    pause
    start https://www.python.org/downloads/
    exit /b 1
)
set PYTHON=python

for /f "tokens=*" %%i in ('!PYTHON! --version 2^>^&1') do echo [ok] %%i

echo Installing packages...
!PYTHON! -m pip install --quiet --upgrade pip
!PYTHON! -m pip install --quiet cryptography argon2-cffi Pillow
if %errorlevel% neq 0 (
    echo Failed. Try running as Administrator.
    pause
    exit /b 1
)
echo [ok] packages

set INSTALL=%LOCALAPPDATA%\NullPass
if not exist "%INSTALL%" mkdir "%INSTALL%"
copy /Y "%~dp0nullpass.py" "%INSTALL%\nullpass.py" >nul
if exist "%~dp0icon.png" copy /Y "%~dp0icon.png" "%INSTALL%\icon.png" >nul
if exist "%~dp0icon.ico" copy /Y "%~dp0icon.ico" "%INSTALL%\icon.ico" >nul
echo [ok] installed to %INSTALL%

set VBS=%TEMP%\np_shortcut.vbs
(
echo Set oWS = WScript.CreateObject("WScript.Shell")
echo Set lnk = oWS.CreateShortcut("%USERPROFILE%\Desktop\NullPass.lnk"^)
echo lnk.TargetPath = "!PYTHON!"
echo lnk.Arguments = """%INSTALL%\nullpass.py"""
echo lnk.WorkingDirectory = "%INSTALL%"
echo lnk.Description = "NullPass"
if exist "%INSTALL%\icon.ico" echo lnk.IconLocation = "%INSTALL%\icon.ico"
echo lnk.Save
) > "%VBS%"
cscript //nologo "%VBS%"
del "%VBS%" >nul 2>&1
echo [ok] desktop shortcut

echo.
echo Done. Launch NullPass from your desktop.
echo.
pause
