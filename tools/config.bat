@echo off
REM APK decompiler config file

color 0a
set PP=%~dp0
set PP=%PP:~0,-1%
cd /d "%PP%"
java -version >nul 2>&1||echo Error: Java is not found&&echo Please install JRE first &&echo.&&echo Existing..&&pause&&exit
set PATH=%PP%;%PATH%

if %ADB_VER%x     EQU x set ADB_VER=1.0.41
if %APKTOOL_VER%x EQU x set APKTOOL_VER=2.5.0
if %DEXJAR_VER%x  EQU x set DEXJAR_VER=2.1.28
if %JDGUI_VER%x   EQU x set JDGUI_VER=1.6.6
if %BAKSMALI_VER%x EQU x set BAKSMALI_VER=2.5.2
if %SMALI_VER%x   EQU x set SMALI_VER=2.5.2
if %SIGNER%x      EQU x set SIGNER=testkey

set ADB="%PP%\ADB\%ADB_VER%\adb.exe"
REM set APKTOOL=java -Xmx512m -jar "%PP%\ApkTool\apktool_%APKTOOL_VER%.jar"
set APKTOOL=call "%PP%\ApkTool\%APKTOOL_VER%\apktool.bat"
set D2J=call "%PP%\Dex2Jar\%DEXJAR_VER%\d2j-dex2jar.bat"
set JDGUI=start /max /d "%PP%\JavaDecompiler" jd-gui-%JDGUI_VER%.exe
set JDGUI_WAIT=start /wait /max /d "%PP%\JavaDecompiler" jd-gui-%JDGUI_VER%.exe
set BAKSMALI=java -Xmx512m -jar "%PP%\Smali\baksmali-%BAKSMALI_VER%.jar"
set SMALI=java -Xmx512m -jar "%PP%\Smali\smali-%SMALI_VER%.jar"
set OPTIPNG="%PP%\Misc\optipng.exe"
set ZIPALIGN="%PP%\Misc\zipalign.exe"
set SIGNAPK=java -jar "%PP%\Sign\signapk.jar"
