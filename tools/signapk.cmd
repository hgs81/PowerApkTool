@echo off
call "%~dp0config.bat"

REM FIXME non-ascii named apk file not works properly
REM FIXME failure detection
SET APKPATH=%~1
SET APKNAME=%~nx1
SET APKOUT=%~dpn1-signed.apk
SET APKOUTNAME=%~n1-signed.apk
if %SIGNER%x EQU x set SIGNER=testkey
if %2x NEQ x SET SIGNER=%2
if %1x EQU x echo Usage: %~nx0 APK_FILE [SIGNER] &echo. &echo ApkTool version: %apktool_ver% &goto :eof

:start
SET SIGNED=%APKPATH:~0,-4%-temp.apk
SET ALIGNED=%SIGNED:~0,-4%-aligned.apk

call :clearall

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
%signapk% "%SIGNER_CERT%" "%SIGNER_KEY%" "%APKPATH%" "%SIGNED%"
if errorlevel 1 goto err

:: 	Zipalign APK
echo Zipaligning "%APKNAME%"
%zipalign% -f 4 "%SIGNED%" "%ALIGNED%"
if errorlevel 1 goto err

::  finalize
call :clearleft
ren "%ALIGNED%" "%APKOUTNAME%"
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
