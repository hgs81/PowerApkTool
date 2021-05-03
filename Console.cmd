@echo off
call "%~dp0tools\config.bat"

SET PATH=%PP%;%PP%\ADB\%ADB_VER%;%PATH%


TITLE "ApkTool Console"

PROMPT $G$S
CLS

ECHO.
ECHO Current directory is: "%CD%"
ECHO.

echo Command list:
dir /b "%PP%\*.cmd"
echo.

adb version
ECHO.

CMD /Q /K
GOTO:EOF

:error
  ECHO.
  ECHO Press any key to exit.
  PAUSE >nul
  GOTO:EOF
