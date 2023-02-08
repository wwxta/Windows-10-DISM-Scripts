mode con:cols=50 lines=1
title Start work...
call :PostClear>>%userprofile%\Desktop\PostClear.log 2>&1
EXIT /b 0
:PostClear
title Wait Explorer
taskkill /f /im explorer.exe
if exist %programdata%\PostClear\FirstLoad.reg (
	title Stopping DiagTrack
	net stop DiagTrack
	title Applying FirstLoad.reg
	%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\reg.exe /CommandLine "import %programdata%\PostClear\FirstLoad.reg" /RunAs 8 /WaitProcess 1 /Run
	title Deleting Defender tasks
	schtasks /delete /tn "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /f
	schtasks /delete /tn "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /f
	schtasks /delete /tn "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /f
	schtasks /delete /tn "Microsoft\Windows\Windows Defender\Windows Defender Verification" /f
	TIMEOUT /T 1 /NOBREAK >nul
	del /f /q %programdata%\PostClear\FirstLoad.reg
	goto Reboot
)
if exist %programdata%\PostClear\PostClearM.bat (
	call %programdata%\PostClear\PostClearM.bat
	del /f /q %programdata%\PostClear\PostClearM.bat
) else (
	for /F "skip=1 tokens=2*" %%A in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\InstallService" /V Start') do (if %%B equ 0x4 (title Press any key && start cmd /c "mode con:cols=60 lines=3 && title AppX Warning && echo off && echo "Microsoft Store Install Service" is Disabled! && echo Before create new account you must Enable AppX support. && pause" && pause))
	TIMEOUT /T 1 /NOBREAK >nul
)
title Applying PostClear.reg
reg import %programdata%\PostClear\PostClear.reg
TIMEOUT /T 1 /NOBREAK >nul
if exist %windir%\en-US\explorer.exe.mui (
	reg add "HKEY_CURRENT_USER\SOFTWARE\IvoSoft\ClassicShell\Settings" /v Language /t REG_SZ /d "en-US"
)
if exist %windir%\zh-CN\explorer.exe.mui (
	reg add "HKEY_CURRENT_USER\SOFTWARE\IvoSoft\ClassicShell\Settings" /v Language /t REG_SZ /d "zh-CN"
)
TIMEOUT /T 1 /NOBREAK >nul
:Reboot
title Start Explorer
start %windir%\explorer.exe
TIMEOUT /T 2 /NOBREAK >nul
title Rebooting...
SHUTDOWN -r -t 3
