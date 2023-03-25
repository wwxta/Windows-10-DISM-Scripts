mode con:cols=50 lines=1
title Start work...

call :Clear>>C:\10\Clear.log 2>&1
EXIT /b 0

:Clear
title Compress boot.wim
start /w C:\10\WimOptimize.exe C:\10\boot.wim
title Applying Clear.ps1

%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -File C:\10\Clear.ps1
title Load registry
reg load HKEY_LOCAL_MACHINE\WIM_SOFTWARE C:\10\Install\Windows\System32\config\SOFTWARE
reg load HKEY_LOCAL_MACHINE\WIM_SYSTEM C:\10\Install\Windows\System32\config\SYSTEM
reg load HKEY_LOCAL_MACHINE\WIM_CURRENT_USER C:\10\Install\Users\Default\NTUSER.DAT
TIMEOUT /T 1 /NOBREAK >nul
title Applying Clear.reg
reg import C:\10\Clear.reg
title Remove protect
set KEYSLIST=HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.AllAppsDesktopApplication HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.Computer HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.DesktopPackagedApplication HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.ImmersiveApplication HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.SystemSettings HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\IE.AssocFile.WEBSITE HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Microsoft.Website
for %%a in (%KEYSLIST%) do (
	reg export %%a\shellex\ContextMenuHandlers C:\10\_temp.reg /y
	C:\10\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\reg.exe /CommandLine "delete %%a\shellex\ContextMenuHandlers /f" /RunAs 8 /WaitProcess 1 /Run
	C:\10\PostClear\AdvancedRun.exe /EXEFilename C:\10\SubinAcl.exe  /CommandLine "/keyreg %%a\shellex /grant=S-1-5-18=F" /RunAs 8 /WaitProcess 1 /Run
	C:\10\PostClear\AdvancedRun.exe /EXEFilename C:\10\SubinAcl.exe  /CommandLine "/keyreg %%a\shellex /grant=S-1-5-32-544=F" /RunAs 8 /WaitProcess 1 /Run
	reg import C:\10\_temp.reg
	del /f /q C:\10\_temp.reg
)
title Disable Secondary Logs
for /f "tokens=*" %%a in ('reg QUERY "HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels"') do (
	reg add "%%a" /v Enabled /t REG_DWORD /d 0 /f
)
TIMEOUT /T 1 /NOBREAK >nul
title Unload registry
reg unload HKEY_LOCAL_MACHINE\WIM_CURRENT_USER
reg unload HKEY_LOCAL_MACHINE\WIM_SYSTEM
reg unload HKEY_LOCAL_MACHINE\WIM_SOFTWARE
title Hide NTUSER.DAT
ATTRIB C:\10\Install\Users\Default\NTUSER.DAT +S +H
title EdgeUpdate
mkdir "C:\10\Install\Program Files (x86)\Microsoft\EdgeCore"
mkdir "C:\10\Install\Program Files (x86)\Microsoft\EdgeWebView\Application"
rd /s /q "C:\10\Install\Program Files (x86)\Microsoft\EdgeUpdate"
ren "C:\10\Install\Program Files (x86)\Microsoft\Edge\Application\86.0.622.38\Installer" "InstallerR"
del /f /q "C:\10\Install\Program Files (x86)\Microsoft\Edge\Application\86.0.622.38\elevation_service.exe"
del /f /q "C:\10\Install\Program Files (x86)\Microsoft\Edge\Application\86.0.622.38\notification_helper.exe"
del /f /q "C:\10\Install\Program Files (x86)\Microsoft\Edge\Application\86.0.622.38\notification_helper.exe.manifest"
title Disable Appx Protect
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path C:\10\Install\Windows | Set-Acl -Path 'C:\10\Install\Program Files\WindowsApps'"
title UPFC
set DEL=C:\10\Install\Windows\System32\upfc.exe
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
move C:\10\upfc.exe C:\10\Install\Windows\System32
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path C:\10\Install\Windows\System32\control.exe | Set-Acl -Path %DEL%"
set DEL=C:\10\Install\Windows\WinSxS\amd64_microsoft-windows-upfc_31bf3856ad364e35_10.0.20348.1_none_30948326e569bbd9
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=C:\10\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-upfc_31bf3856ad364e35_10.0.20348.1_none_30948326e569bbd9.manifest
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
title GameDVR
set DEL="C:\10\Install\Windows\bcastdvr\KnownGameList.bin"
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
move C:\10\KnownGameList.bin %DEL%
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path C:\10\Install\Windows\System32\control.exe | Set-Acl -Path %DEL%"
title WaaS tasks
set DELETELIST=C:\10\Install\Windows\WaaS\services C:\10\Install\Windows\WaaS\tasks C:\10\Install\Windows\WaaS
for %%a in (%DELETELIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
	rd /s /q %%a
)
set DELETELIST=C:\10\Install\Windows\WinSxS\FileMaps\$$_waas_services_ddfc4ae175ff1678.cdf-ms C:\10\Install\Windows\WinSxS\FileMaps\$$_waas_tasks_0504086c7768f632.cdf-ms
for %%a in (%DELETELIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
	del /f /q %%a
)
title Clear WinSxS
for /f "tokens=*" %%i in ('dir C:\10\Install\Windows\WinSxS\Backup /b /a:-d') do (
	icacls "C:\10\Install\Windows\WinSxS\Backup\%%~i" /grant "%username%":f /c /l /q
	del /f /q "C:\10\Install\Windows\WinSxS\Backup\%%~i"
)
title Compress Winre
start /w C:\10\WimOptimize.exe C:\10\Install\Windows\System32\Recovery\Winre.wim
TIMEOUT /T 1 /NOBREAK >nul
title Copy PostClear
move C:\10\PostClear C:\10\Install\ProgramData\PostClear
title Unmounting
dism /unmount-wim /mountdir:C:\10\Install /commit
title Done...

