@echo off
call "%~dp0config.bat"

SET APK=%~1
SET OUT=%~2
if %OUT%x EQU x set OUT=%TEMP%\%~n1-dex2jar.jar
SET PARAMS=%3 %4 %5 %6 %7 %8 %9
if %1x EQU x echo Usage: %~nx0 SRCAPK [OUTJAR [D2J_PARAMS]] &echo. &echo Dex2Jar version: %dexjar_ver% &echo JD-Gui version: %jdgui_ver% &goto :eof

:: 	Browse Java Code of APK (Decompile)
if exist "%OUT%" del /f "%OUT%"
%d2j% -f -e "%TEMP%\%~n1-error.zip" %PARAMS% -o "%OUT%" "%APK%"
if %errorlevel% NEQ 0 echo. &echo An error has occured. &echo. &echo Existing... &pause &goto :eof
set TMPAPK=%TEMP%\decomp_%random%.apk
set TMPOUT=%TMPAPK:~0,-4%.jar
if not exist "%OUT%" (
  REM maybe non-ascii file
  cls
  echo Copying original %~nx1 to %TMPAPK% ...
  copy /y "%APK%" "%TMPAPK%" >NUL
  echo.
  %d2j% -f -o %PARAMS% "%TMPOUT%" "%TMPAPK%"
  del /f /q "%TMPAPK%"
  %jdgui_wait% "%TMPOUT%"
  del /f /q "%TMPOUT%"
  goto :eof
)
%jdgui% "%OUT%"
