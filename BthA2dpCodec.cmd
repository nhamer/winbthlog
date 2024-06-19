@echo off
setlocal
rem Validate that we are running with an elevated token (admin)
fsutil dirty query %SYSTEMDRIVE% > NUL
if %ERRORLEVEL% EQU 0 goto elevated
echo %0 must be run at an elevated command prompt
goto :eof
:elevated

REM curl -o BluetoothStack.wprp https://raw.githubusercontent.com/microsoft/busiotools/master/bluetooth/tracing/BluetoothStack.wprp
REM Microsoft.Windows.Bluetooth.BthA2dp, 8776ad1e-5022-4451-a566-f47e708b9075

set TRACEPATH=%TEMP%
set TRACENAME=BthA2DPTrace
set TRACEETLNAME=%TRACEPATH%\%TRACENAME%.etl
set TRACETXTNAME=%TRACEPATH%\%TRACENAME%.txt
netsh trace start report=disabled provider={8776ad1e-5022-4451-a566-f47e708b9075} overwrite=yes traceFile="%TRACEETLNAME%" 
echo Start your audio stream
pause
netsh trace stop
netsh trace convert input="%TRACEETLNAME%" output="%TRACETXTNAME%" dump=TXT overwrite=yes
type %TRACETXTNAME% | findstr \"A2dpStreaming\"

del %TRACEETLNAME%
del %TRACETXTNAME%