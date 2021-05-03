@echo off
REM %1 command (d|b)
REM %2 src
REM %3 out
set PATH=%~dp0;%PATH%;
java -Xmx512m -jar "%~dp0apktool.jar" %1 -p "%~dp0framework" %4 %5 %6 %7 %8 %9 -o %3 %2
