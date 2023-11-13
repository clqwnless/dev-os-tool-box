@echo off

title DEV OS TOOLBOX

mode con cols=125 lines=50

chcp 65001 > nul

color 4

goto main


:find_root_folder

set root_folder=%~dp0

set root_folder="%root_folder:~0,-1%"


:ran_as_admin_check

fltmc > nul 2>&1

if %errorlevel% neq 0 (
    echo.
    echo [*ERROR] The Script requires admin rights
    echo.
    pause
    exit 1
)

exit /b 0


:find_build

set unknown_build=false

reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild" > %root_folder%\temp.txt 2>&1

if %errorlevel% neq 0 (
    set build=unknown
    
    del /q temp.txt > nul 2>&1
    
    exit /b 1
)

for /f "tokens=3" %%i in (temp.txt) do (
    set build=%%i
)

exit /b 0


:find_product_name

set next_word_is_value=false

set product_name=

reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName" > %root_folder%\temp.txt 2>&1

if %errorlevel% neq 0 (
    set product_name=unknown
    
    del /q temp.txt > nul 2>&1
    
    exit /b 1
)

for /f "delims=" %%i in (temp.txt) do (
    set result=%%i
)

for %%i in (%result%) do (
    if !next_word_is_value! equ true (
        set product_name=!product_name! %%i
    )

    if "%%i" equ "REG_SZ" (
        set next_word_is_value=true
    )
)

set product_name=!product_name:~1!

del /q temp.txt > nul 2>&1

exit /b 0


:find_version 


set result=

set next_word_is_value=false

reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "DisplayVersion" > %root_folder%\temp.txt 2>&1

if %errorlevel% neq 0 (
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ReleaseId" > %root_folder%\temp.txt 2>&1
)

if %errorlevel% neq 0 (
    set version=unknown
    
    del /q temp.txt > nul 2>&1
    
    exit /b 1
)

for /f "delims=" %%i in (temp.txt) do (
    set result=%%i
)

set flag=false

set version=

for %%i in (%result%) do (
    if !next_word_is_value! equ true (
        set version=!version! %%i
    )

    if "%%i" equ "REG_SZ" (
        set next_word_is_value=true
    )
)

set version=!version:~1!

del /q temp.txt > nul 2>&1

exit /b 0


:clear_all_event_viewer_logs

for /F "tokens=*" %%G in ('wevtutil.exe el') do (
    wevtutil.exe cl "%%G" > nul 2>&1
)

echo  [*INFO] Cleared all event viewer logs

echo.

pause

exit /b 0


:theme_configuration

cls

echo.

echo  ===========================
echo    [*THEME CONFIGURATION*]
echo  ===========================

echo.

echo  =========================
echo    [1] ^| Set Light Theme
echo    [2] ^| Set Dark Theme
echo    [3] ^| Back
echo  =========================

echo.

set choice=

set /p choice=">>> "

if not defined choice (
    goto theme_configuration
)

echo.

if %choice% equ 1 (
    reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 1 /f > nul 2>&1

    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 1 /f > nul 2>&1

    echo  [*INFO] Set Light Theme
    
    echo.
    
    pause
) else if %choice% equ 2 (
    reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 0 /f > nul 2>&1

    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 0 /f > nul 2>&1

    echo  [*INFO] Set Dark Theme
    
    echo.
    
    pause
) else if %choice% equ 3 (
    exit /b 0
) else (
    goto theme_configuration
)

exit /b 0


:windows_activation

slmgr /upk

slmgr /cpky

slmgr /ipk M7XTQ-FN8P6-TTKYV-9D4CC-J462D

slmgr /skms kms.digiboy.ir

slmgr /ato

pause

exit /b 0


:ultimate_power_addition

chcp 437 > nul

powershell -NoLogo -Command "powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61

chcp 65001 > nul

echo.
echo.

pause

exit /b 0


:firewall_configuration

cls

echo.

echo  ==============================
echo    [*FIREWALL CONFIGURATION*]
echo  ==============================

echo.

echo  ==========================
echo    [1] ^| Enable Firewall
echo    [2] ^| Disable Firewall
echo    [3] ^| Back
echo  ==========================

echo.

set choice=

set /p choice=">>> "

if not defined choice (
    goto firewall_configuration
)

echo.

if %choice% equ 1 (
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile" /v "EnableFirewall" /t REG_DWORD /d 1 /f > nul 2>&1
    
    echo  [*INFO] Enabled Firewall
    
    echo.
    
    pause
) else if %choice% equ 2 (
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile" /v "EnableFirewall" /t REG_DWORD /d 0 /f > nul 2>&1
    
    echo  [*INFO] Disabled Firewall
    
    echo.
    
    pause
) else if %choice% equ 3 (
    exit /b 0
) else (
    goto firewall_configuration
)

exit /b 0


:event_viewer_configuration

cls

echo.

echo  ==================================
echo    [*EVENT VIEWER CONFIGURATION*]
echo  ==================================

echo.

echo  ==============================
echo    [1] ^| Enable Event Viewer
echo    [2] ^| Disable Event Viewer
echo    [3] ^| Back
echo  ==============================

echo.

set choice=

set /p choice=">>> "

if not defined choice (
    goto event_viewer_configuration
)

echo.

if %choice% equ 1 (
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\EventLog" /v "Start" /t REG_DWORD /d 2 /f > nul 2>&1
    
    echo  [*INFO] Enabled Event Viewer
    
    echo.
    
    pause
) else if %choice% equ 2 (
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\EventLog" /v "Start" /t REG_DWORD /d 4 /f > nul 2>&1
    
    echo  [*INFO] Disabled Event Viewer
    
    echo.
    
    pause
) else if %choice% equ 3 (
    exit /b 0
) else (
    goto event_viewer_configuration
)

exit /b 0


:cpp_redistributable_installation 

cls

echo.

echo  [*INFO] Installing 2005 package [x64 and x86]

curl --location "http://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x64.exe" --output %root_folder%\package.exe > nul 2>&1

start /wait package.exe /q

del /q package.exe > nul 2>&1

curl --location "http://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x86.exe" --output %root_folder%\package.exe > nul 2>&1

start /wait package.exe /q

del /q package.exe > nul 2>&1

echo  [*INFO] Installing 2008 package [x64 and x86]

curl --location "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe" --output %root_folder%\package.exe > nul 2>&1

start /wait package.exe /qb

del /q package.exe > nul 2>&1

curl --location "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe" --output %root_folder%\package.exe > nul 2>&1

start /wait package.exe /qb

del /q package.exe > nul 2>&1

echo  [*INFO] Installing 2010 package [x64 and x86]

curl --location "https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe" --output %root_folder%\package.exe > nul 2>&1

start /wait package.exe /passive /norestart

del /q package.exe > nul 2>&1

curl --location "https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe" --output %root_folder%\package.exe > nul 2>&1

start /wait package.exe /passive /norestart

del /q package.exe > nul 2>&1

echo  [*INFO] Installing 2012 package [x64 and x86]

curl --location "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe" --output %root_folder%\package.exe > nul 2>&1

start /wait package.exe /passive /norestart

del /q package.exe > nul 2>&1

curl --location "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" --output %root_folder%\package.exe > nul 2>&1

start /wait package.exe /passive /norestart

del /q package.exe > nul 2>&1

echo  [*INFO] Installing 2013 package [x64 and x86]

curl --location "https://aka.ms/highdpimfc2013x64enu" --output %root_folder%\package.exe > nul 2>&1

start /wait package.exe /passive /norestart

del /q package.exe > nul 2>&1

curl --location "https://aka.ms/highdpimfc2013x86enu" --output %root_folder%\package.exe > nul 2>&1

start /wait package.exe /passive /norestart

del /q package.exe > nul 2>&1

echo  [*INFO] Installing 2015, 2017 ^& 2019 ^& 2022 package [x64 and x86]

curl --location "https://aka.ms/vs/17/release/vc_redist.x64.exe" --output %root_folder%\package.exe > nul 2>&1

start /wait package.exe /passive /norestart

del /q package.exe > nul 2>&1

curl --location "https://aka.ms/vs/17/release/vc_redist.x86.exe" --output %root_folder%\package.exe > nul 2>&1

start /wait package.exe /passive /norestart

del /q package.exe > nul 2>&1

echo.

pause

exit /b 0


:brave_browser_installation

cls

echo.

echo  [*INFO] Installing Brave Browser

curl --location "https://github.com/brave/brave-browser/releases/download/v1.57.62/BraveBrowserSetup.exe" --output %root_folder%\brave_installer.exe > nul 2>&1

start /wait brave_installer.exe

del /q brave_installer.exe

echo.

pause

exit /b 0


:firefox_installation

cls

echo.

echo  [*INFO] Installing FireFox

curl --location "https://ftp.mozilla.org/pub/firefox/releases/99.0b8/win64/en-US/Firefox%%20Setup%%2099.0b8.exe" --output %root_folder%\firefox_installer.exe > nul 2>&1

start /wait firefox_installer.exe

del /q firefox_installer.exe

echo.

pause

exit /b 0


:7_zip_installation

cls

echo.

echo  [*INFO] Installing 7-Zip

curl --location "https://www.7-zip.org/a/7z2301-x64.exe" --output %root_folder%\7_zip_installer.exe > nul 2>&1

start /wait 7_zip_installer.exe

del /q 7_zip_installer.exe

echo.

pause

exit /b 0

:notepad_pp_installation

cls

echo.

echo  [*INFO] Installing Notepad ++

curl --location "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5.8/npp.8.5.8.Installer.x64.exe" --output %root_folder%\notepad_pp_installer.exe > nul 2>&1

start /wait notepad_pp_installer.exe

del /q notepad_pp_installer.exe

echo.

pause

exit /b 0


:main

cls

call :find_root_folder

cd %root_folder%

call :ran_as_admin_check

call :find_build

setlocal enabledelayedexpansion

call :find_product_name
call :find_version


echo.
echo  ==========================================================================
echo    [*COMPUTER NAME: %ComputerName% ^| CURRENT USER: %username%*]
echo    [*CURRENT OS: !product_name! ^| Build: %build% ^| Version: !version!*]
echo  ==========================================================================

endlocal

echo.

echo  ▄▄▄█████▓▒█████  ▒█████  ██▓    ▄▄▄▄   ▒█████ ▒██   ██▒
echo  ▓  ██▒ ▓▒██▒  ██▒██▒  ██▓██▒   ▓█████▄▒██▒  ██▒▒ █ █ ▒░
echo  ▒ ▓██░ ▒▒██░  ██▒██░  ██▒██░   ▒██▒ ▄█▒██░  ██░░  █   ░
echo  ░ ▓██▓ ░▒██   ██▒██   ██▒██░   ▒██░█▀ ▒██   ██░░ █ █ ▒ 
echo    ▒██▒ ░░ ████▓▒░ ████▓▒░██████░▓█  ▀█░ ████▓▒▒██▒ ▒██▒
echo    ▒ ░░  ░ ▒░▒░▒░░ ▒░▒░▒░░ ▒░▓  ░▒▓███▀░ ▒░▒░▒░▒▒ ░ ░▓ ░
echo      ░     ░ ▒ ▒░  ░ ▒ ▒░░ ░ ▒  ▒░▒   ░  ░ ▒ ▒░░░   ░▒ ░
echo    ░     ░ ░ ░ ▒ ░ ░ ░ ▒   ░ ░   ░    ░░ ░ ░ ▒  ░    ░  
echo              ░ ░     ░ ░     ░  ░░         ░ ░  ░    ░  
echo                                       ░                 

echo.


echo  TWEAKS                                      APPS INSTALLATION
echo  ======================================      ==============================================
echo    [1] ^| Clear all event viewer logs          [8]  ^| Brave Browser
echo    [2] ^| Theme configuration                  [9]  ^| FireFox
echo  ======================================       [10] ^| 7-Zip
echo                                               [11] ^| Notepad++
echo  OTHER ^| ETC                                  [12] ^| Exit
echo  ==========================================
echo    [3] ^| Windows Activation (6-8 months)
echo    [4] ^| Add ultimate power
echo    [5] ^| Firewall configuration
echo    [6] ^| Event Viewer configuration
echo    [7] ^| Install C++ redistributable
echo  ========================================== 


echo.

set choice=

set /p choice=">>> "

if not defined choice (
    goto main
)

echo.

if %choice% equ 1 (
    call :clear_all_event_viewer_logs
    goto main
) else if %choice% equ 2 (
    call :theme_configuration
    goto main
) else if %choice% equ 3 (
    call :windows_activation
    goto main
) else if %choice% equ 4 (
    call :ultimate_power_addition
    goto main
) else if %choice% equ 5 (
    call :firewall_configuration
    goto main
) else if %choice% equ 6 (
    call :event_viewer_configuration
    goto main
) else if %choice% equ 7 (
    call :cpp_redistributable_installation
    goto main
) else if %choice% equ 8 (
    call :brave_browser_installation
    goto main
) else if %choice% equ 9 (
    call :firefox_installation
    goto main
) else if %choice% equ 10 (
    call :7_zip_installation
    goto main
) else if %choice% equ 11 (
    call :notepad_pp_installation
    goto main
) else if %choice% equ 12 (
    pause

    exit /b 0
) else (
    goto main
)
