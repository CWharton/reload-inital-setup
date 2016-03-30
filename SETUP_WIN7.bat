:: AUTOMAX - INTERNAL INITIAL COMPUTER SETUP
:: By: Chris Wharton
::
:: This is a set-up script to run on user computers. Run this after installing operating system.
::
::==================================================================================
@ECHO off

SET AMAXDIR=%HOMEDRIVE%\automax
SET INSTALLDIR=%CD%\installdir
SET SCRIPTDIR=%AMAXDIR%\scripts
SET REMOTEDIR=\\10.18.210.10\wpkg\packages

CALL %~dp0\scripts\header.bat

CALL %~dp0\init\spiceworks_assistant.exe

:bitdefloop
ECHO.
ECHO Install BitDefender? (Anti-Virus Software) & ECHO. 1) Yes & ECHO. 2) No & SET /p _bitdef=
If not "%_bitdef%"=="1" If not "%_bitdef%"=="2" goto bitdefloop
If "%_bitdef%"=="1" CALL %~dp0\init\setupdownloader_[aHR0cHM6Ly9jbG91ZC1lY3MuZ3Jhdml0eXpvbmUuYml0ZGVmZW5kZXIuY29tOjQ0My9QYWNrYWdlcy9CU1RXSU4vMC9fVlVPWTAvaW5zdGFsbGVyLnhtbD9sYW5nPWVuLVVT].exe

:merakiloop
ECHO.
ECHO Install Meraki Agent? (ONLY MOBILE DEVICES) & ECHO. 1) Yes & ECHO. 2) No & SET /p _meraki=
If not "%_meraki%"=="1" If not "%_meraki%"=="2" goto merakiloop
If "%_meraki%"=="1" msiexec /i %~dp0\init\MerakiSM-Agent-automax.msi /quiet /qn /norestart

:osupgradeloop
ECHO.
ECHO Stop upgrade to Windows 10? & ECHO. 1) Yes & ECHO. 2) No & SET /p _osupgrade=
If not "%_osupgrade%"=="1" If not "%_osupgrade%"=="2" goto osupgradeloop

:weblinkloop
ECHO.
ECHO Add default Desktop links? & ECHO. 1) Yes & ECHO. 2) No & SET /p _weblink=
If not "%_weblink%"=="1" If not "%_weblink%"=="2" goto weblinkloop

:bginfoloop
ECHO.
ECHO Place BGInfo on the desktop? & ECHO. 1) Yes & ECHO. 2) No & SET /p _bginfo=
If not "%_bginfo%"=="1" If not "%_bginfo%"=="2" goto bginfoloop

:updatemgr
ECHO.
ECHO Install software manager (chocolatey) and other software? & ECHO. 1) Yes & ECHO. 2) No & SET /p _updatemgr=
If not "%_updatemgr%"=="1" If not "%_updatemgr%"=="2" goto updatemgr
IF "%_updatemgr%"=="1" (

:javaloop
   ECHO.
   ECHO Install Java? & ECHO. 1. Yes & ECHO. 2. No & SET /p _java=
   If not "%_java%"=="1" If not "%_java%"=="2" goto javaloop

:thunderbirdloop
   ECHO.
   ECHO Install Thunderbird? & ECHO. 1. Yes & ECHO. 2. No & SET /p _thunderbird=
   If not "%_thunderbird%"=="1" If not "%_thunderbird%"=="2" goto thunderbirdloop

:firefoxloop
   ECHO.
   ECHO Install FireFox? & ECHO. 1. Yes & ECHO. 2. No & SET /p _firefox=
   If not "%_firefox%"=="1" If not "%_firefox%"=="2" goto firefoxloop
)


:updateloop
ECHO.
ECHO Run Windows Update? & ECHO. 1) Yes & ECHO. 2) No & SET /p _aupdate=
If not "%_aupdate%"=="1" If not "%_aupdate%"=="2" goto updateloop

:loop
ECHO.
ECHO The installation process is about to start?
ECHO Would You like to restart computer when completed? & ECHO. 1) Yes & ECHO. 2) No & SET /p _restart=
If not "%_restart%"=="1" If not "%_restart%"=="2" goto loop

CALL %~dp0\scripts\header.bat
ECHO.
ECHO.
ECHO.
ECHO. Automax initial setup finished.
ECHO.
ECHO. Now we have to complete the task you want.
ECHO. This can take a while so grab yourself a cold beer and watch me work :)
ECHO. OR get back to work on something else.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO. Copyright C 2009-2016 Automax All rights reserved
ECHO.
ECHO.
pause

:: ========================== RUN =============================================
ECHO.
ECHO. -= Setting up system accounts
NET USER administrator /active:yes
regedit.exe /s "%~dp0\scripts\hide_admin.reg"
SET ADMINUSER = AutomaxAdmin

:: THIS WILL SET-UP ADMINISTRATOR PASSWORD SO ALL COMPUTERS ARE THE SAME
:: (Active Directory is mainly used so never give out this password unless they are IT Admins)
ECHO.
ECHO. -= Setting up Administrator account
NET USER administrator L0n9Horns!

:: Set time server
ECHO.
ECHO. -= Set time server
sc start w32time
w32tm /config /update /manualpeerlist:10.18.210.5
w32tm /resync

:: Move over scripts directory
ECHO.
ECHO. -= Creating automax directory
XCOPY /Y /R /S /H /Q "%REMOTEDIR%\scripts\*" "%SYSTEMDRIVE%\automax\"

:: Move over group policy
ECHO.
ECHO. -= Creating group policy
XCOPY /Y /R /S /H /Q "%REMOTEDIR%\GroupPolicy\*" "%WINDIR%\System32\GroupPolicy\"
GPUPDATE /FORCE
:: System I.T. Info
ECHO.
ECHO. -= Initilizing system settings
regedit.exe /S %~dp0\scripts\OEMInfo.reg

ECHO.
ECHO. -= Creating routine system tasks
SCHTASKS /CREATE /TN "maintenance_daily" /XML "%REMOTEDIR%\schedules_win7\maintenance_daily.xml"
SCHTASKS /CREATE /TN "maintenance_weekly" /XML "%REMOTEDIR%\schedules_win7\maintenance_weekly.xml"

:: Setup desktop web links
IF "%_osupgrade%"=="1" (
   ECHO.
   ECHO. -= Turning off OS Upgrade.
   regedit.exe /S %~dp0\scripts\DisableGWX.reg
   regedit.exe /S %~dp0\scripts\DisableOSUpgrade.reg
)

:: Setup desktop web links
IF "%_weblink%"=="1" (
   ECHO.
   ECHO. -= Added links to desktop.
   CSCRIPT "%~dp0\scripts\weblink.vbs"
)

:: BGINFO
IF "%_bginfo%"=="1" (
   ECHO.
   ECHO. -= Installing BGInfo for desktop
   reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v BGInfo /t REG_SZ /d "%AMAXDIR%\bginfo\bginfo.exe /accepteula /i%AMAXDIR%\bginfo\bginfo.bgi /timer:0" /f
   %AMAXDIR%\bginfo\bginfo.exe /accepteula /i%AMAXDIR%\bginfo\bginfo.bgi /timer:0
)

:: Software Manager
IF "%_updatemgr%"=="1" (
   CALL scripts\install_chocolatey.bat
   ECHO. -= Installing additional software
   IF "%_java%"=="1" choco install jre8
   IF "%_thunderbird%"=="1" choco install thunderbird
   IF "%_firefox%"=="1" choco install firefox
   CHOCO INSTALL -y flashplayerplugin 7zip adobereader notepadplusplus ccleaner libreoffice ultravnc
   COPY /y "%REMOTEDIR%\uvnc\ultravnc.ini" "%PROGRAMFILES%\uvnc bvba\UltraVNC\UltraVNC.ini
)

:: Windows Update
IF "%_aupdate%"=="1" (
   ECHO. -= Running windows update (This may take a while)
   CALL "%AMAXDIR%\tools\WUInstall.exe" /install
)

:: Restart Computer
IF "%_restart%"=="1" (
   ECHO. -= Finally it is time to reboot the system.
   ECHO. -= HAVE A GREAT DAY !!!
   CALL "%AMAXDIR%\tools\psshutdown" -r -f -c -m "Rebooting for latest updates. If canceled please manually reboot." -accepteula
)
