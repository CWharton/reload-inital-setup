CALL NET USE X: \\10.18.210.9\wpkg user /user:user

SET AMAXDIR=%HOMEDRIVE%\automax
SET REMOTEDIR=X:\packages

CHOCO INSTALL -y ultravnc adobereader firefox googlechrome libreoffice

CALL %AMAXDIR%\scripts\refresh_vnc_config.bat

DEL "%HOMEPATH%\Desktop\UltraVNC Server.lnk"
DEL "%HOMEPATH%\Desktop\UltraVNC Settings.lnk"
DEL "%HOMEPATH%\Desktop\UltraVNC Viewer.lnk"
DEL "%HOMEPATH%\Desktop\uvnc_settings.lnk"
DEL "%HOMEPATH%\Desktop\vncviewer.exe.lnk"
DEL "C:\Users\Public\Desktop\CCleaner.lnk"
DEL "C:\Users\Public\Desktop\Acrobat Reader DC.lnk"

:: Setup VNC
IF EXIST "%PROGRAMFILES%\uvnc bvba\UltraVnc\" (
	copy /y "%REMOTEDIR%\uvnc\ultravnc.ini" "%PROGRAMFILES%\uvnc bvba\UltraVnc\UltraVNC.ini"
)

"%ProgramFiles%\uvnc bvba\UltraVNC\winvnc.exe" -install
"%ProgramFiles%\uvnc bvba\UltraVNC\winvnc.exe" -startservice

CALL NET USE X: /delete