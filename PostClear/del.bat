rd /s /q "c:\System Volume Information"
rd /s /q "C:\PerfLogs"
del /f /q "C:\Windows\System32\ctfmon.exe"
del /f /q "C:\Windows\System32\mobsyns.exe"
del /f /q "C:\Windows\System32\SppExtComObj.exe"

del /s /f /q C:\windows\temp\*.* 
rd /s /q C:\windows\temp 
del /s /f /q %temp%\*.* 
rd /s /q %temp% 

rd /s /q "C:\Program Files\7-Zip\Lang"
