### Default hotkeys  
  
#### Hint: Hotkeys are bound to the german keyboard layout!  
  
App | Open Hotkey | Kill Hotkey \*1) | other  
------------ | ------------- | ------------- | -------------  
**aottext** | !a | - | hide / show  
**cmdlinedev** | !c  | +!c | !q, Alt & Tab,!n, !f, !d, !k, !b, !o  possible more FastSwitch hotkeys  
**clickandsleep** | !m | +!m | ^!m: Record mouse-click-position on/off  
**sbt_console_select** | !t | +!t | !e: Run commands, \^e:Run all, ^e:Run selected, +\^e:store selected to execution part, ^r:Reset SBT-Console-Repl, ^!t: (running sbtConsole scala>) copy "replcommands.txt" ...  
**chunkCopy** (simpletools) |  | \[ESCAPE] | 
**clipboardresize** \*2)| +#z | +!#z | !z: Capture-area+Resize, #z: Capture+Resize, ^#z: C+R+Save, !#z: Set size | !y: OCR  
[**codetester**](https://github.com/jvr-ks/codetester) |  |  | ESC ^u F7 F8 F1 F2 F3  
**selja** | !j |  |  
**selsca** | !p |  |  
**skatstube** | - | ESCAPE \*3) | CTRL/Space + RButton or RButton if active only to toggle Activation button   
**SuperClicker** |  | F12 | F1 F2 F10 F11 F12  
**fastswitch** (deprecated) |  |  | Fastswitch is part of cmdlinedev now!  
  
Hotkey prefix | Modifier Key |  Remark  
------------ | ------------- | -------------  
! | \[ALT] |  
\^ | \[CTRL] |  
\# | \[WIN] |  
\+ | \[SHIFT] |  
  
[Complete List of Keys](https://www.autohotkey.com/docs/KeyList.htm)  
  
\*1) Kill: Stop app and remove it from memory!  
  
\*2) Uses hotkeyname to virtual-keycode conversion,  
so it is independent of the keyboard layout, but only "simple" hotkeys are converted, i.e. a word character like "a", "b", "c" and preceding modifiers "#!^+~".  
Hotkeys with more than one character (like "Alt & Tab") are not converted, but may still be usable!  
  
\*3) Resets thescreen-position to top-left  

[back ...](https://github.com/jvr-ks/cmdlinedev/blob/main/hotkeys.md)
