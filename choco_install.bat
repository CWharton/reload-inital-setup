CHOCO INSTALL -y 7zip notepadplusplus ultravnc adobereader firefox googlechrome thunderbird libreoffice

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