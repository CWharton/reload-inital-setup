:: AUTOMAX - INTERNAL INITIAL COMPUTER SETUP
:: By: Chris Wharton
::
:: This is a set-up script to run on user computers. Run this after installing operating system.
::
::==================================================================================
@ECHO off

CALL NET USE X: \\10.18.210.10\wpkg user /user:user

SET AMAXDIR=%HOMEDRIVE%\automax
SET INSTALLDIR=%CD%\installdir
SET SCRIPTDIR=%AMAXDIR%\scripts
SET REMOTEDIR=X:\packages

CALL %~dp0\scripts\header.bat

CALL %REMOTEDIR%\init_programs\spiceworks_assistant.exe

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
CALL %REMOTEDIR%\scripts\scripts\configure_local_account.bat

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
IF EXIST "%AMAXDIR%\scripts\refresh_group_policy.bat" (
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

:: BGINFO
ECHO.
ECHO. -= Installing BGInfo for desktop
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v BGInfo /t REG_SZ /d "%AMAXDIR%\bginfo\bginfo.exe /accepteula /i%AMAXDIR%\bginfo\bginfo.bgi /timer:0" /f
%AMAXDIR%\bginfo\bginfo.exe /accepteula /i%AMAXDIR%\bginfo\bginfo.bgi /timer:0

:: Software Manager
CALL %AMAXDIR%\scripts\install_chocolatey.bat

ECHO. -= Installing additional software
CHOCO INSTALL -y --allow-empty-checksums 7zip notepadplusplus ultravnc adobereader firefox googlechrome thunderbird libreoffice

CALL %AMAXDIR%\scripts\refresh_vnc_config.bat

DEL "%HOMEPATH%\Desktop\UltraVNC Server.lnk"
DEL "%HOMEPATH%\Desktop\UltraVNC Settings.lnk"
DEL "%HOMEPATH%\Desktop\UltraVNC Viewer.lnk"
DEL "%HOMEPATH%\Desktop\uvnc_settings.lnk"
DEL "%HOMEPATH%\Desktop\vncviewer.exe.lnk"
DEL "C:\Users\Public\Desktop\CCleaner.lnk"
DEL "C:\Users\Public\Desktop\Acrobat Reader DC.lnk"

:: Setup VNC
"%ProgramFiles%\uvnc bvba\UltraVNC\winvnc.exe" -install
"%ProgramFiles%\uvnc bvba\UltraVNC\winvnc.exe" -startservice

:: Install bitdefender
CALL %REMOTEDIR%\init_programs\setupdownloader_[aHR0cHM6Ly9jbG91ZC1lY3MuZ3Jhdml0eXpvbmUuYml0ZGVmZW5kZXIuY29tOjQ0My9QYWNrYWdlcy9CU1RXSU4vMC9fVlVPWTAvaW5zdGFsbGVyLnhtbD9sYW5nPWVuLVVT].exe

CALL NET USE X: /delete

ECHO. -= Running windows update (This may take a while)
CALL "%AMAXDIR%\tools\WUInstall.exe" /install
