mode con:cols=50 lines=1
title Start work...

call :Clear>>Z:\Clear.log 2>&1
EXIT /b 0

:Clear
title Compress Boot
start /w Z:\WimOptimize.exe Z:\boot.wim
title Applying Clear.ps1
dism /get-imageinfo /imagefile:Z:\install.wim /index:10
if %ERRORLEVEL% EQU -1051328239 (
	del /f /q Z:\EN.txt
)
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -File Z:\Clear.ps1
title Load registry
reg load HKEY_LOCAL_MACHINE\WIM_SOFTWARE Z:\Install\Windows\System32\config\SOFTWARE
reg load HKEY_LOCAL_MACHINE\WIM_SYSTEM Z:\Install\Windows\System32\config\SYSTEM
reg load HKEY_LOCAL_MACHINE\WIM_CURRENT_USER Z:\Install\Users\Default\NTUSER.DAT
TIMEOUT /T 1 /NOBREAK >nul
title Applying Clear.reg
reg import Z:\Clear.reg
title Remove protect
set KEYSLIST=HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.AllAppsDesktopApplication HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.Computer HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.DesktopPackagedApplication HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.ImmersiveApplication HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.SystemSettings HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\IE.AssocFile.WEBSITE HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Microsoft.Website
for %%a in (%KEYSLIST%) do (
	reg export %%a\shellex\ContextMenuHandlers Z:\_temp.reg /y
	Z:\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\reg.exe /CommandLine "delete %%a\shellex\ContextMenuHandlers /f" /RunAs 8 /WaitProcess 1 /Run
	Z:\PostClear\AdvancedRun.exe /EXEFilename Z:\SubinAcl.exe  /CommandLine "/keyreg %%a\shellex /grant=S-1-5-18=F" /RunAs 8 /WaitProcess 1 /Run
	Z:\PostClear\AdvancedRun.exe /EXEFilename Z:\SubinAcl.exe  /CommandLine "/keyreg %%a\shellex /grant=S-1-5-32-544=F" /RunAs 8 /WaitProcess 1 /Run
	reg import Z:\_temp.reg
	del /f /q Z:\_temp.reg
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
ATTRIB Z:\Install\Users\Default\NTUSER.DAT +S +H
title Shortcuts
move "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools\Character Map.lnk" "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools"
set DEL="Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools\desktop.ini"
type %DEL%>>%DEL%.temp
del /f /q /a:sh %DEL%
move %DEL%.temp %DEL%
echo Character Map.lnk=@%SystemRoot%\system32\shell32.dll,-22021>>%DEL%
ATTRIB %DEL% +S +H
rd /s /q "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools"
move "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell ISE.lnk" "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools"
rd /s /q "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Windows PowerShell"
rd /s /q "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Maintenance"
move "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk" "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools"
rd /s /q "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell"
del /f /q "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\computer.lnk"
del /f /q "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"
rd /s /q "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Maintenance"
title EdgeUpdate
mkdir "Z:\Install\Program Files (x86)\Microsoft\EdgeCore"
mkdir "Z:\Install\Program Files (x86)\Microsoft\EdgeWebView\Application"
rd /s /q "Z:\Install\Program Files (x86)\Microsoft\EdgeUpdate"
rd /s /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\92.0.902.67\Installer"
del /f /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\92.0.902.67\elevation_service.exe"
del /f /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\92.0.902.67\notification_helper.exe"
del /f /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\92.0.902.67\notification_helper.exe.manifest"
title Disable Appx Protect
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path Z:\Install\Windows | Set-Acl -Path 'Z:\Install\Program Files\WindowsApps'"
title OneDrive
takeown /f Z:\Install\Windows\WinSxS\wow64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.19041.1_none_e585f901f9ce93e6
icacls Z:\Install\Windows\WinSxS\wow64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.19041.1_none_e585f901f9ce93e6 /grant "%username%":f /c /l /q
rd /s /q Z:\Install\Windows\WinSxS\wow64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.19041.1_none_e585f901f9ce93e6
set DELETELIST=Z:\Install\Windows\SysWOW64\OneDriveSetup.exe Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.19041.1_none_db314eafc56dd1eb.manifest Z:\Install\Windows\WinSxS\Manifests\wow64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.19041.1_none_e585f901f9ce93e6.manifest Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~~10.0.19041.1.cat Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~~10.0.19041.1.mum Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~ru-RU~10.0.19041.1.cat Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~ru-RU~10.0.19041.1.mum Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~~10.0.19041.1.cat Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~~10.0.19041.1.mum Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~ru-RU~10.0.19041.1.cat Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~ru-RU~10.0.19041.1.mum Z:\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~~10.0.19041.1.cat Z:\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~ru-RU~10.0.19041.1.cat Z:\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~~10.0.19041.1.cat Z:\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~ru-RU~10.0.19041.1.cat
for %%a in (%DELETELIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
	del /f /q %%a
)
title UPFC
set DEL=Z:\Install\Windows\System32\upfc.exe
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
move Z:\upfc.exe Z:\Install\Windows\System32
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path Z:\Install\Windows\System32\control.exe | Set-Acl -Path %DEL%"
set DEL=Z:\Install\Windows\WinSxS\amd64_microsoft-windows-upfc_31bf3856ad364e35_10.0.19041.1_none_5d169326bbc0abdb
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-upfc_31bf3856ad364e35_10.0.19041.1_none_5d169326bbc0abdb.manifest
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
title Calc
set DELETELIST=Z:\Install\Windows\WinSxS\amd64_microsoft-windows-calc_31bf3856ad364e35_10.0.19041.1_none_5faf0ebeba197e78 Z:\Install\Windows\WinSxS\wow64_microsoft-windows-calc_31bf3856ad364e35_10.0.19041.1_none_6a03b910ee7a4073
for %%a in (%DELETELIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
	rd /s /q %%a
)
set DELETELIST=Z:\Install\Windows\System32\calc.exe Z:\Install\Windows\SysWOW64\calc.exe Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-calc_31bf3856ad364e35_10.0.19041.1_none_5faf0ebeba197e78.manifest Z:\Install\Windows\WinSxS\Manifests\wow64_microsoft-windows-calc_31bf3856ad364e35_10.0.19041.1_none_6a03b910ee7a4073.manifest
for %%a in (%DELETELIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
	del /f /q %%a
)
move Z:\calc.exe Z:\Install\Windows\System32
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path Z:\Install\Windows\System32\control.exe | Set-Acl -Path Z:\Install\Windows\System32\calc.exe"
move Z:\calc_64.exe Z:\Install\Windows\SysWOW64\calc.exe
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path Z:\Install\Windows\System32\control.exe | Set-Acl -Path Z:\Install\Windows\SysWOW64\calc.exe"
if exist Z:\Install\Windows\en-US\explorer.exe.mui (
	del /f /q Z:\EN.txt
	del /f /q Z:\calc.exe.cn.mui
	del /f /q Z:\calc.exe.ru.mui
	copy Z:\calc.exe.en.mui Z:\Install\Windows\System32\en-US\calc.exe.mui
	move Z:\calc.exe.en.mui Z:\Install\Windows\SysWOW64\en-US
)
if exist Z:\Install\Windows\zh-CN\explorer.exe.mui (
	del /f /q Z:\calc.exe.en.mui
	del /f /q Z:\calc.exe.ru.mui
	copy Z:\calc.exe.cn.mui Z:\Install\Windows\System32\zh-CN\calc.exe.mui
	move Z:\calc.exe.cn.mui Z:\Install\Windows\SysWOW64\zh-CN
)
if exist Z:\Install\Windows\ru-RU\explorer.exe.mui (
	del /f /q Z:\calc.exe.en.mui
	del /f /q Z:\calc.exe.cn.mui
	copy Z:\calc.exe.ru.mui Z:\Install\Windows\System32\ru-RU\calc.exe.mui
	move Z:\calc.exe.ru.mui Z:\Install\Windows\SysWOW64\ru-RU
)
title Edge Chromium
set DEL=Z:\Install\Windows\WinSxS\amd64_microsoft-windows-edgechromium_31bf3856ad364e35_10.0.19041.1266_none_74657031110a9d30
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-edgechromium_31bf3856ad364e35_10.0.19041.1266_none_74657031110a9d30.manifest
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
title GameDVR
set DEL="Z:\Install\Windows\bcastdvr\KnownGameList.bin"
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
move Z:\KnownGameList.bin %DEL%
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path Z:\Install\Windows\System32\control.exe | Set-Acl -Path %DEL%"
title WaaS tasks
set DELETELIST=Z:\Install\Windows\WaaS\services Z:\Install\Windows\WaaS\tasks Z:\Install\Windows\WaaS
for %%a in (%DELETELIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
	rd /s /q %%a
)
set DELETELIST=Z:\Install\Windows\WinSxS\FileMaps\$$_waas_services_ddfc4ae175ff1678.cdf-ms Z:\Install\Windows\WinSxS\FileMaps\$$_waas_tasks_0504086c7768f632.cdf-ms
for %%a in (%DELETELIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
	del /f /q %%a
)
title Clear WinSxS
for /f "tokens=*" %%i in ('dir Z:\Install\Windows\WinSxS\Backup /b /a:-d') do (
	icacls "Z:\Install\Windows\WinSxS\Backup\%%~i" /grant "%username%":f /c /l /q
	del /f /q "Z:\Install\Windows\WinSxS\Backup\%%~i"
)
title Compress Winre
start /w Z:\WimOptimize.exe Z:\Install\Windows\System32\Recovery\Winre.wim
TIMEOUT /T 1 /NOBREAK >nul
title Copy PostClear
if not exist Z:\Install\Windows\ru-RU\explorer.exe.mui (
	del /f /q Z:\PostClear\SLMP-10.chm
)
move Z:\PostClear Z:\Install\ProgramData\PostClear
title Unmounting
dism /unmount-wim /mountdir:Z:\Install /commit
title Done...
del /f /q Z:\Clear.ps1
del /f /q Z:\Clear.reg
del /f /q Z:\SubinAcl.exe
del /f /q Z:\WimOptimize.exe
del /f /q Z:\Windows-10-DISM-Scripts.zip
del /f /q Z:\_Clear.bat
