@rem compile.bat

@echo off

@call cmdlinedev.exe remove

@"C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in cmdlinedev.ahk /out cmdlinedev.exe /icon cmdlinedev.ico /bin "C:\Program Files\AutoHotkey\Compiler\Unicode 64-bit.bin"


