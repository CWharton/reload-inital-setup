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

CALL %REMOTEDIR%\init_programs\spiceworks_assistant.exe

:bitdefloop
ECHO.
ECHO Install BitDefender? (Anti-Virus Software) & ECHO. 1) Yes & ECHO. 2) No & SET /p _bitdef=
If not "%_bitdef%"=="1" If not "%_bitdef%"=="2" goto bitdefloop

:merakiloop
ECHO.
ECHO Install Meraki Agent? (ONLY MOBILE DEVICES) & ECHO. 1) Yes & ECHO. 2) No & SET /p _meraki=
If not "%_meraki%"=="1" If not "%_meraki%"=="2" goto merakiloop
If "%_meraki%"=="1" msiexec /i %REMOTEDIR%\init_programs\MerakiSM-Agent-automax.msi /quiet /qn /norestart

:weblinkloop
ECHO.
ECHO Add default Desktop links? & ECHO. 1) Yes & ECHO. 2) No & SET /p _weblink=
If not "%_weblink%"=="1" If not "%_weblink%"=="2" goto weblinkloop

:updatemgr
ECHO.
ECHO Install software manager (chocolatey) and other software? & ECHO. 1) Yes & ECHO. 2) No & SET /p _updatemgr=
If not "%_updatemgr%"=="1" If not "%_updatemgr%"=="2" goto updatemgr

IF "%_updatemgr%"=="1" (

	:javaseloop
	ECHO.
	ECHO Install Java? & ECHO. 1. Yes & ECHO. 2. No & SET /p _java=
	If not "%_java%"=="1" If not "%_java%"=="2" goto javaseloop
	
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
:: CALL %REMOTEDIR%\scripts\scripts\configure_local_account.bat

ECHO.
ECHO. -= Setting up system accounts
NET USER administrator /active:yes
regedit.exe /s "%REMOTEDIR%\win_registry\hide_admin.reg"
SET ADMINUSER = AutomaxAdmin

:: THIS WILL SET-UP ADMINISTRATOR PASSWORD SO ALL COMPUTERS ARE THE SAME
:: (Active Directory is mainly used so never give out this password unless they are IT Admins)
ECHO.
ECHO. -= Setting up Administrator account
NET USER administrator L0n9Horns!

:: Move over scripts directory
ECHO.
ECHO. -= Creating automax directory
XCOPY /Y /R /S /H /Q "%REMOTEDIR%\scripts" "%AMAXDIR%\"

:: Set time server
ECHO.
ECHO. -= Set time server
IF EXIST "%AMAXDIR%\scripts\refresh_time_server.bat" (
	CALL %AMAXDIR%\scripts\refresh_time_server.bat
)

:: Update latest Desktop Icons
IF EXIST "%AMAXDIR%\scripts\refresh_desktop_icons.bat" (
	CALL %AMAXDIR%\scripts\refresh_desktop_icons.bat
)

:: Move over group policy
ECHO.
ECHO. -= Creating group policy
IF EXIST "%AMAXDIR%\scripts\refresh_time_server.bat" (
	CALL %AMAXDIR%\scripts\refresh_group_policy.bat
)

:: System I.T. Info
ECHO.
ECHO. -= Initilizing system settings
regedit.exe /S %REMOTEDIR%\win_registry\OEMInfo.reg

ECHO.
ECHO. -= Creating routine system tasks
SCHTASKS /CREATE /TN "maintenance_daily" /XML "%REMOTEDIR%\schedules_win7\maintenance_daily.xml"
SCHTASKS /CREATE /TN "maintenance_weekly" /XML "%REMOTEDIR%\schedules_win7\maintenance_weekly.xml"

:: Setup desktop web links
IF "%_osupgrade%"=="1" (
   ECHO.
   ECHO. -= Turning off OS Upgrade.
   regedit.exe /S %REMOTEDIR%\win_registry\DisableGWX.reg
   regedit.exe /S %REMOTEDIR%\win_registry\DisableOSUpgrade.reg
)

:: Setup desktop web links
IF "%_weblink%"=="1" (
   ECHO.
   ECHO. -= Added links to desktop.
   CSCRIPT "%~dp0\scripts\weblink.vbs"
)

:: BGINFO
ECHO.
ECHO. -= Installing BGInfo for desktop
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v BGInfo /t REG_SZ /d "%AMAXDIR%\bginfo\bginfo.exe /accepteula /i%AMAXDIR%\bginfo\bginfo.bgi /timer:0" /f
%AMAXDIR%\bginfo\bginfo.exe /accepteula /i%AMAXDIR%\bginfo\bginfo.bgi /timer:0

:: Software Manager
IF "%_updatemgr%"=="1" (
   CALL %AMAXDIR%\scripts\install_chocolatey.bat
   
   ECHO. -= Installing additional software
   IF "%_java%"=="1" choco install -y --allow-empty-checksums jre8
   CHOCO INSTALL -y --allow-empty-checksums flashplayerplugin flashplayeractivex 7zip notepadplusplus ultravnc adobereader firefox thunderbird libreoffice
   
   CALL %AMAXDIR%\scripts\refresh_vnc_config.bat

   DEL "%HOMEPATH%\Desktop\UltraVNC Server.lnk"
   DEL "%HOMEPATH%\Desktop\UltraVNC Settings.lnk"
   DEL "%HOMEPATH%\Desktop\UltraVNC Viewer.lnk"
   DEL "%HOMEPATH%\Desktop\uvnc_settings.lnk"
   DEL "%HOMEPATH%\Desktop\vncviewer.exe.lnk"
   DEL "C:\Users\Public\Desktop\CCleaner.lnk"
   DEL "C:\Users\Public\Desktop\Acrobat Reader DC.lnk"
)

If "%_bitdef%"=="1" CALL %REMOTEDIR%\init_programs\setupdownloader_[aHR0cHM6Ly9jbG91ZC1lY3MuZ3Jhdml0eXpvbmUuYml0ZGVmZW5kZXIuY29tOjQ0My9QYWNrYWdlcy9CU1RXSU4vMC9fVlVPWTAvaW5zdGFsbGVyLnhtbD9sYW5nPWVuLVVT].exe

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
