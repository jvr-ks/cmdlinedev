@rem compileRun.bat

@echo off

cd %~dp0

@set appname=cmdlinedev

call %appname%.exe remove
call %appname%32.exe remove

set autohotkeyExe=C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe
set autohotkeyCompilerPath=C:\Program Files\AutoHotkey\Compiler\

call "%autohotkeyExe%" /in %appname%.ahk /out %appname%.exe /icon %appname%.ico /bin "%autohotkeyCompilerPath%Unicode 64-bit.bin"
call "%autohotkeyExe%" /in %appname%.ahk /out %appname%32.exe /icon %appname%.ico /bin "%autohotkeyCompilerPath%Unicode 32-bit.bin"

call upx --best %appname%.exe
call upx --best %appname32%.exe

start %appname%.exe showwindow

exit
