@echo off
call "%~dp0config.bat"

REM FIXME non-ascii named apk file not works properly
SET APK=%~1
SET ODEX=%~dpn1.odex
SET OUT=%~2
if %OUT%x EQU x set OUT=%~dpn1-disasm
SET PARAMS=%3 %4 %5 %6 %7 %8 %9
if %1x EQU x echo Usage: %~nx0 SRCAPK [OUTDIR [APKTOOL_PARAMS]] &echo. &echo ApkTool version: %apktool_ver% &goto :eof

:: 	Disassemble APK and Decode Resources
if exist "%OUT%\." rd /s /q "%OUT%"
REM if exist "%USERPROFILE%\apktool\framework\1.apk" del /f "%USERPROFILE%\apktool\framework\1.apk"
%apktool% d "%APK%" "%OUT%" %PARAMS%
if %errorlevel% NEQ 0 echo. &echo An error has occured. &echo. &echo Existing... &pause &goto :eof
if exist "%ODEX%" (
 echo.
 echo Baksmaling external odex file...
 %baksmali% -a 14 -x "%ODEX%" -d framework -o "%OUT%\smali"
 echo.
 echo Warning: This apk file has odex file and may not be baksmalied properly.
 echo.
 pause
)
