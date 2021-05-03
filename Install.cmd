@echo off
color 0a

:: relaunch self elevated
ver|find /i "XP">nul||whoami /all|find "S-1-16-12288">nul
IF %ERRORLEVEL% NEQ 0 (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
)

java -version >nul 2>&1 || (
  echo Error: Java not found.
  echo Please install Java first.
  echo.
  echo Existing..
  pause
  goto :eof
)


set HANDLER=.apk

REM porting in BlueStack env
assoc .apk 2>nul | findstr /i "BlueStacks.Apk" >nul && (
  set HANDLER=BlueStacks.Apk
  goto :install
)

:: remove menu handlers installed by other apps
reg add "HKCR\.apk" /f /ve /t REG_SZ /d ""
reg delete "HKCU\Software\Classes\.apk" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.apk" /f >nul 2>&1

reg add "HKCR\%HANDLER%\DefaultIcon" /f /ve /t REG_SZ /d "%~dp0tools\apk.ico"

:install
reg add "HKCR\%HANDLER%\shell\decompile" /f /ve /t REG_SZ /d "Browse Java Code of APK"
reg add "HKCR\%HANDLER%\shell\decompile\command" /f /ve /t REG_SZ /d "\"%~dp0tools\decompile.cmd\" \"%%1\""
reg add "HKCR\%HANDLER%\shell\disassemble" /f /ve /t REG_SZ /d "Disassemble APK and Decode Resources"
reg add "HKCR\%HANDLER%\shell\disassemble\command" /f /ve /t REG_SZ /d "\"%~dp0tools\disassemble.cmd\" \"%%1\""
reg add "HKCR\%HANDLER%\shell\gensrc" /f /ve /t REG_SZ /d "Generate Java Sources"
reg add "HKCR\%HANDLER%\shell\gensrc\command" /f /ve /t REG_SZ /d "\"%~dp0tools\gensrc.cmd\" \"%%1\""
reg add "HKCR\%HANDLER%\shell\install" /f /ve /t REG_SZ /d "Install APK to &Phone"
reg add "HKCR\%HANDLER%\shell\install\command" /f /ve /t REG_SZ /d "\"%~dp0tools\install.cmd\" \"%%1\""
reg add "HKCR\folder\shell\recompile" /f /ve /t REG_SZ /d "Recompile APK from Disassembly"
reg add "HKCR\folder\shell\recompile\command" /f /ve /t REG_SZ /d "\"%~dp0tools\buildapk.cmd\" \"%%1\""

:: remove entries left from old versions
reg delete "HKCR\jarfile\shell\decompile" /f >nul 2>&1

pause
