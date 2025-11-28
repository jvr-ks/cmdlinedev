@rem compile.bat

@echo off

call cmdlinedev.exe remove
call cmdlinedev32.exe remove


call "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in cmdlinedev.ahk /out cmdlinedev.exe /icon cmdlinedev.ico /bin "C:\Program Files\AutoHotkey\Compiler\Unicode 64-bit.bin"

call "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in cmdlinedev.ahk /out cmdlinedev32.exe /icon cmdlinedev.ico /bin "C:\Program Files\AutoHotkey\Compiler\Unicode 32-bit.bin"



