@echo off
call "%~dp0config.bat"

REM FIXME non-ascii named apk file not works properly
REM FIXME failure detection
SET APK=%~1

:: 	Install APK to Phone
echo Starting to install "%~nx1" to phone
echo Waiting for device
%adb% wait-for-device

set TMPAPK=%TEMP%\decomp_%random%.apk
copy /y "%APK%" "%TMPAPK%" >NUL

%adb% install -r "%TMPAPK%"
if %errorlevel% NEQ 0 echo. &echo An error has occured. &echo. &echo Existing... &goto clean

:clean
del /f /q "%TMPAPK%"
pause
