wget https://systeminformer.sourceforge.io/nightly.php
findstr /o  "zip" nightly.php > zip
setlocal enabledelayedexpansion
for /f "usebackq delims=" %%i in ("zip") do for %%a in (%%i) do (
    set "var=%%~a"
    set "var=!var:>=!"
    set "var=!var:"=!"
    if "!var:~0,4!" == "http" echo !var! > zip
)
wget https://github.com/massgravel/Microsoft-Activation-Scripts/blob/master/MAS/Separate-Files-Version/HWID-KMS38_Activation/KMS38_Activation.cmd -O 38.cmd
wget -i zip
wget -i wget
ren download 7z.exe
del /f /q nightly.php
del /f /q .wget-hsts
del /f /q zip

wget https://github.com/Orbmu2k/nvidiaProfileInspector/releases/latest
findstr /o  "expanded_assets" latest > pi
setlocal enabledelayedexpansion
for /f "usebackq delims=" %%i in ("pi") do for %%a in (%%i) do (
    set "var=%%~a"
    set "var=!var:>=!"
    set "var=!var:"=!"
    if "!var:~0,4!" == "http" echo !var:~75! > pi
)

setlocal enabledelayedexpansion
for /f "usebackq delims=" %%i in ("pi") do for %%a in (%%i) do (
    set "var=%%~a"
    set "var=!var:>=!"
    set "var=!var:"=!"
    if "!var:~0,1!" == "2" echo !var! && set vartmp=!var!
)
wget https://github.com/Orbmu2k/nvidiaProfileInspector/releases/download/%vartmp%/nvidiaProfileInspector.zip
del /f /q pi
del /f /q latest

