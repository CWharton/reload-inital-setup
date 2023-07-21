:: ========================== SET NAME =============================================
setlocal
wmic bios get serialnumber | find /I /V "SerialNumber" > "%temp%\sn.txt"
set /p comp_name=<"%temp%\sn.txt"
wmic computersystem where name="%computername%" rename name=%comp_name%
del "%temp%\sn.txt"
endlocal

:: ========================== INSTALL SIEM AGENT =============================================
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri https://packages.wazuh.com/4.x/windows/wazuh-agent-4.4.5-1.msi -OutFile ${env:tmp}\wazuh-agent.msi; msiexec.exe /i ${env:tmp}\wazuh-agent.msi /q WAZUH_MANAGER='siem.killeenauto.local' WAZUH_REGISTRATION_SERVER='siem.killeenauto.local' WAZUH_AGENT_GROUP='default'"

:: ========================== START SIEM AGENT =============================================
NET START WazuhSvc