#### Hint: Hotkeys are bound to the german keyboard layout!  
(Position of the "z" key and the "y" key are exchanged!)  
  
App | Open Hotkey | Kill Hotkey \*1) | other  
------------ | ------------- | ------------- | -------------  
[**aottext**](https://github.com/jvr-ks/aottext) | \[ALT] + \[a] | - | hide / show  
**cmdlinedev** | \[ALT] + \[c]  | \[SHIFT] + \[ALT] + \[c] | \[ALT] + \[q], , \[ALT] + \[n], \[ALT] + \[f], \[ALT] + \[d], \[ALT] + \[k], \[ALT] + \[b], \[ALT] + \[o], \[ALT] + \[r] and possible more FastSwitch hotkeys (fastSwitchCycleGroups) file "cldfastswitchhotkeys.txt"
**clickandsleep** | \[ALT] + \[m] | \[SHIFT] + \[ALT] + \[m] | \[CTRL] + \[ALT] + \[m]: Record mouse-click-position on/off  
**sbt_console_select** | \[ALT] + \[t] | \[SHIFT] + \[ALT] + \[t] | \[ALT] + \[e]: Run commands, \[CTRL] + \[e]:Run all, ^e:Run selected, \[SHIFT] + \[CTRL] + \[e]:store selected to execution part, \[CTRL] + \[r]:Reset SBT-Console-Repl, \[CTRL] + \[ALT] + \[t]: (running sbtConsole scala>) copy "replcommands.txt" ...  
**[chunkCopy](https://github.com/jvr-ks/simpletools?tab=readme-ov-file#ChunkCopy)** (simpletools) |  | \[ESCAPE] | 
**clipboardresize** \*2)| \[SHIFT] + \[WIN] + \[z] | \[SHIFT] + \[ALT] + \[WIN] + \[z] | \[ALT] + \[z]: Capture-area+Resize, \[WIN] + \[z]: Capture+Resize, \[CTRL] + \[WIN] + \[z]: C+R+Save, \[ALT] + \[WIN] + \[z]: Set size, \[ALT] + \[y]: OCR  
[**codetester**](https://github.com/jvr-ks/codetester) |  |  | \[ESC], \[CTRL] + \[u], \[F7], \[F8], \[F1], \[F2], \[F3],  
**selja** | \[ALT] + \[j] |  |  
**selsca** | \[ALT] + \[p] |  |  
**skatstube** | - | \[ESCAPE] \*3) | CTRL/Space + RButton or RButton if active only to toggle Activation button   
**SuperClicker** |  | \[F12] | \[F1], \[F2], \[F10], \[F11], \[F12]  
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
  
\*3) Resets the screen-position to top-left  

[This table, but with modifier-codes](https://github.com/jvr-ks/cmdlinedev/blob/main/hotkeys_short.md)




