:CheckOS
IF EXIST "%PROGRAMFILES(X86)%" (GOTO 64BIT) ELSE (GOTO 32BIT)

:64BIT
"%ProgramFiles(x86)%\McAfee\Common Framework\FrmInst.exe" /FORCEUNINSTALL
GOTO END

:32BIT
"%ProgramFiles%\McAfee\Common Framework\FrmInst.exe" /FORCEUNINSTALL
GOTO END

:END
