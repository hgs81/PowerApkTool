@echo off
call "%~dp0config.bat"

REM FIXME non-ascii named apk file not works properly
REM FIXME failure detection
SET FOLDER=%~1
SET APKNAME=%~nx1.apk
SET APKOUT=%~dpnx1.apk
if %SIGNER%x EQU x set SIGNER=testkey
if %2x NEQ x SET SIGNER=%2
if %1x EQU x echo Usage: %~nx0 DISASM_FOLDER [SIGNER] &echo. &echo ApkTool version: %apktool_ver% &goto :eof
REM SET APKOUT=%~2
REM if %APKOUT%x EQU x SET APKOUT=%FOLDER:~1,-1%.apk
REM if %3x NEQ x SET SIGNER=%3
REM SET PNG_OPTIMIZE=%4
REM if %1x EQU x echo Usage: %~nx0 DISASM_FOLDER [APKOUT [SIGNER [ENABLE_PNG_OPTIMIZE]]] &echo. &echo ApkTool version: %apktool_ver% &echo Signer: %signer% &goto :eof

if exist "%FOLDER%\Data\apktool.yml" if exist "%FOLDER%\Binary" (
 echo Detected VTS project tree.
 REM SET APKNAME=%~nx1.apk
 REM SET APKOUT=%FOLDER%\Binary\%APKNAME%
 SET APKOUT=%FOLDER%\Binary\%~nx1.apk
 SET FOLDER=%FOLDER%\Data
 SET SIGNER=vtskey
 goto start
)
if not exist "%FOLDER%\apktool.yml" echo. &echo Input folder is not disassembled folder. &echo. &echo Existing... &pause &goto :eof

:start
SET SIGNED=%APKOUT:~0,-4%-signed.apk
SET ALIGNED=%SIGNED:~0,-4%-aligned.apk

call :clearall

:: 	Build APK from Disassembly
%apktool% b "%FOLDER%" "%APKOUT%"
if errorlevel 1 goto err

:: 	Optimize png images
REM TODO
REM cd /d "%~dp0others"
REM SET EXTR=%~dp1$extracted_%~nx1
REM SET TEMP=%~dp1$res_%~nx1
REM md "%EXTR%"
REM md "%TEMP%"
REM 7za x -o"%EXTR%" "%APKOUT%" -y
REM xcopy /sy "%EXTR%\res\*.9.png" "%TEMP%"
REM roptipng "%EXTR%\**\*.png"
REM xcopy /sy "%TEMP%" "%EXTR%\res"
REM del /f "%APKOUT%"
REM 7za a -tzip "%APKOUT%" "%EXTR%\*" -mx9
REM rd /s /q "%EXTR%"
REM rd /s /q "%TEMP%"

:: 	Sign APK
set SIGNER_CERT=%PP%\Sign\%SIGNER%\%SIGNER%.x509.pem
set SIGNER_KEY=%PP%\Sign\%SIGNER%\%SIGNER%.pk8
set SIGNER_PARAM_FILE=%PP%\Sign\%SIGNER%\signer.bat
if not exist "%SIGNER_CERT%" if exist "%SIGNER_PARAM_FILE%" call "%SIGNER_PARAM_FILE%" &goto sign
if not exist "%SIGNER_KEY%" if exist "%SIGNER_PARAM_FILE%" call "%SIGNER_PARAM_FILE%" &goto sign
if %SIGNER%x EQU x set SIGNER=testkey
set SIGNER_CERT=%PP%\Sign\%SIGNER%\%SIGNER%.x509.pem
set SIGNER_KEY=%PP%\Sign\%SIGNER%\%SIGNER%.pk8
:sign
echo Signing "%APKNAME%" with key "%signer%"
%signapk% "%SIGNER_CERT%" "%SIGNER_KEY%" "%APKOUT%" "%SIGNED%"
if errorlevel 1 goto err

:: 	Zipalign APK
echo Zipaligning "%APKNAME%"
%zipalign% -f 4 "%SIGNED%" "%ALIGNED%"
if errorlevel 1 goto err

::  finalize
call :clearleft
ren "%ALIGNED%" "%APKNAME%"
if %errorlevel% NEQ 0 goto err
goto :EOF

:err
call :clearall
echo. &echo An error has occured. &echo. &echo Existing... &pause &goto :eof

:clearall
if exist "%ALIGNED%" del /f "%ALIGNED%"

:clearleft
if exist "%APKOUT%" del /f "%APKOUT%"
if exist "%SIGNED%" del /f "%SIGNED%"
del /f /q "%TEMP%\APKTOOL*.tmp" >NUL 2>NUL
REM if exist "%USERPROFILE%\apktool\framework\1.apk" del /f "%USERPROFILE%\apktool\framework\1.apk"
