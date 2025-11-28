; cmdlinedev_init.ahk
; part of cmdlinedev

;---------------------------------- prepare ----------------------------------
prepare() {
  readConfig()
  readDirectories()
  readTools()
  readShortcuts()
  readFastSwitchHotkeysHotkeys()
  initFastSwitch()
  fsRead()
 }
;------------------------------- readGuiParam -------------------------------
readGuiParam(){
  global configFile, windowPosX, windowPosY, clientWidth, clientHeight
  global windowPosXDefault, windowPosYDefault, clientWidthDefault, clientHeightDefault
  global dpiCorrect, dpiScale, currentSelected
  
  currentSelected := iniReadSave("currentSelected", "gui", 0)
    
  windowPosX := iniReadSave("windowPosX", "gui", 0)
  windowPosY := iniReadSave("windowPosY", "gui", 0)
  clientWidth := iniReadSave("clientWidth", "gui", clientWidthDefault)
  clientHeight := iniReadSave("clientHeight", "gui", clientHeightDefault)
    
  windowPosX := max(windowPosX,-5)
  windowPosY := max(windowPosY,-5)
 }
;------------------------------ readDirectories ------------------------------
readDirectories(){
  global directoriesFile, directoriesArr, param, paramMaxCount

  directoriesArr := []

  Loop, read, %directoriesFile%
  {
    if (A_LoopReadLine != "") {
      directoriesArr.Push(A_LoopReadLine)
    }
  }
 }
;--------------------------------- readTools ---------------------------------
readTools(){
  global toolsArr, toolsFile
  
  toolsArr := {}

  Loop, read, %toolsFile%
  {
    LineNumber := A_Index
    toolName := ""
    toolTarget := ""
    
    if (A_LoopReadLine != "") {
      Loop, parse, A_LoopReadLine, %A_Tab%`,
      {  
        if(A_Index == 1)
          toolName := A_LoopField
          
        if(A_Index == 2)
          toolTarget := A_LoopField
      }
      toolsArr[toolName] := toolTarget
    }
  }
}
;------------------------------- readShortcuts -------------------------------
readShortcuts(){
  global shortcutsArr, shortcutsFile
  
  shortcutsArr := {}

  Loop, read, %shortcutsFile%
  {
    LineNumber := A_Index
    shortcutName := ""
    shortcutReplace := ""
    
    if (A_LoopReadLine != "") {
      Loop, parse, A_LoopReadLine, %A_Tab%`,
      {  
        if(A_Index == 1)
          shortcutName := A_LoopField
          
        if(A_Index == 2)
          shortcutReplace := A_LoopField
      }
      shortcutsArr[shortcutName] := shortcutReplace
    }
  }
 }
;------------------------------ readFastSwitchHotkeys ------------------------------
readFastSwitchHotkeysHotkeys(){
  global fastSwitchHotkeysArr, fastSwitchHotkeysFile
  
  fastSwitchHotkeysArr := {}

  Loop, read, %fastSwitchHotkeysFile%
  {
    LineNumber := A_Index
    fastSwitchHotkey := ""
    fastSwitchTitle := ""

    if (A_LoopReadLine != "" && !InStr(A_LoopReadLine,";")) {
      Loop, parse, A_LoopReadLine, %A_Tab%`,
      {  
        if(A_Index == 1)
          fastSwitchHotkey := A_LoopField
          ; fastSwitchHotkey := keyToVk(A_LoopField)
          
        if(A_Index == 2)
          fastSwitchTitle := A_LoopField
      }
      
      fastSwitchHotkeysArr[fastSwitchHotkey] := fastSwitchTitle
    }
  }
 }
;------------------------------ initFastSwitch ------------------------------
initFastSwitch(){
  global fastSwitchHotkeysArr, fastSwitchHotkeysFile
  
  for Key, Val in fastSwitchHotkeysArr
    {
      if (InStr(Key, "off") > 0){
        s := StrReplace(Key, "off", "")
        Hotkey, %s%, fastSwitchSelect, off
      } else {
        Hotkey, %Key%, fastSwitchSelect
      }
    }
}
;-------------------------------- readConfig --------------------------------
readConfig(){
  global configFile, menuHotkeyDefault, menuHotkey, menuOpenHotkeyDefault, menuOpenHotkey
  global exitHotkeyDefault, exitHotkey, runnerhotkeyDefault, runnerhotkey
  global fontDefault, font, fontsizeDefault, fontsize, emptyFieldSubstituteChar
  global notepadppPath, notepadppPathDefault, runnerPath
  global hintTimeShort, hintTimeShortDefault, hintTimeMedium, hintTimeMediumDefault, hintTime, hintTimeDefault, hintTimeLong, hintTimeLongDefault
  global showActiveTitle, sessionfilesDefault, sessionfiles, sessionfileExtensionDefault, sessionfileExtension
  global fastSwitchCycleArr, fastSwitchCyclePointer, fastSwitchCycleHotkeyDefault, fastSwitchCycleHotkey
  global fastSwitchCycleGroup2, fastSwitchCycleGroup3, fastSwitchCycleGroup4, fastSwitchCycleGroup5, fastSwitchCycleGroup6, fastSwitchCycleGroup7, fastSwitchCycleGroup8, fastSwitchCycleGroup9
  global fastSwitchCycleGroupSelected, fastSwitchCycleGroupSelectedMax, fastSwitchAutoCycleHotkeyDefault, fastSwitchAutoCycleHotkey
  global fastSwitchUseTitle, fastSwitchUseTitleArr
  global waitForNotepadReady, waitForSessionManagerLoop, waitForEditReady, waitDokListOpenLoop

  font := iniReadSave("font", "config", fontDefault)
  fontsize := iniReadSave("fontsize", "config", fontsizeDefault)
  sessionfiles := iniReadSave("sessionfiles", "config", sessionfilesDefault)
  sessionfileExtension := iniReadSave("sessionfileExtension", "config", sessionfileExtensionDefault)
  waitForNotepadReady := iniReadSave("waitForNotepadReady", "config", 3000)
  waitForSessionManagerLoop := iniReadSave("waitForSessionManagerLoop", "config", 1000)
  waitForEditReady := iniReadSave("waitForEditReady", "config", 1000)
  waitDokListOpenLoop := iniReadSave("waitDokListOpenLoop", "config", 1000)

  menuhotkey := iniReadSave("menuHotkey", "config", menuHotkeyDefault)
  if (InStr(menuhotkey, "off") > 0){
    s := StrReplace(menuhotkey, "off", "")
    Hotkey, %s%, showWindowRefreshed, off
  } else {
    Hotkey, %menuhotkey%, showWindowRefreshed, "ON T1"
  }

  menuopenhotkey := iniReadSave("menuOpenHotkey", "config", menuOpenHotkeyDefault)
  if (InStr(menuopenhotkey, "off") > 0){
    s := StrReplace(menuopenhotkey, "off", "")
    Hotkey, %s%, autoOpen, off
  } else {
    Hotkey, %menuopenhotkey%, autoOpen, "ON T1"
  }
  
  exithotkey := iniReadSave("exitHotkey", "config", exitHotkeyDefault)
  if (InStr(exithotkey, "off") > 0){
    s := StrReplace(exithotkey, "off", "")
    Hotkey, %s%, exit, off
  } else {
    Hotkey, %exithotkey%, exit
  }
  
  runnerhotkey := iniReadSave("runnerhotkey", "config", runnerhotkeyDefault)
  if (InStr(runnerhotkey, "off") > 0){
    s := StrReplace(runnerhotkey, "off", "")
    Hotkey, %s%, rundev, off
  } else {
    Hotkey, %runnerhotkey%, rundev, "ON T1"
  }
  runnerPath := iniReadSave("runnerPath", "external", "")
  guicontrol, guiMain:, Edit_Run, %runnerPath%
  
  hintTimeShort := iniReadSave("hintTimeShort", "timing", hintTimeShortDefault)
  hintTimeMedium := iniReadSave("hintTimeMedium", "timing", hintTimeMediumDefault)
  hintTime := iniReadSave("hintTime", "timing", hintTimeDefault)
  hintTimeLong := iniReadSave("hintTimeLong", "timing", hintTimeLongDefault)
  notepadppPath := iniReadSave("notepadppPath", "external", notepadppPathDefault)

  fastSwitchCycleHotkey := iniReadSave("fastSwitchCycleHotkey", "fastSwitchCycle", fastSwitchCycleHotkeyDefault)
  
  loop, 8
  {
    i := A_Index + 1
    fastSwitchCycleGroup%i% := iniReadSave("fastSwitchCycleGroup" . i, "fastSwitchCycle", "-")
    s := fastSwitchCycleGroup%i%
  }
  
  fastSwitchCycleGroupSelected := iniReadSave("fastSwitchCycleGroupSelected", "fastSwitchCycle", 1)
  
  if (fastSwitchCycleHotkey != "-" && fastSwitchCycleGroupSelected > 1){
    Hotkey, %fastSwitchCycleHotkey%, cycle
  } else {
    Hotkey, %fastSwitchCycleHotkey%, cycle
    Hotkey, %fastSwitchCycleHotkey%, Off
  }
    
  fastSwitchAutoCycleHotkey := iniReadSave("fastSwitchAutoCycleHotkey", "fastSwitchCycle", fastSwitchAutoCycleHotkeyDefault)
  
  if (fastSwitchAutoCycleHotkey != "-"){
    Hotkey, %fastSwitchAutoCycleHotkey%, fsCycle
  } else {
    Hotkey, %fastSwitchAutoCycleHotkey%, fsCycle
    Hotkey, %fastSwitchAutoCycleHotkey%, Off
  }
  
  showActiveTitleRead := iniReadSave("showActiveTitleRead", "config", "yes")
  satr := StrLower(showActiveTitleRead)
  if (InStr(satr,"n") > 0 || InStr(satr,"f") > 0  || satr == "0"){
    showActiveTitle := false
  }
  
  fastSwitchUseTitle := iniReadSave("fastSwitchUseTitle", "fastSwitchCycle", fastSwitchUseTitle)
  if (fastSwitchUseTitle != ""){
      Loop, parse, fastSwitchUseTitle, `,
      { 
        fastSwitchUseTitleArr[A_LoopField] := true
      }
  }
}
;------------------------------- createDefaultConfig -------------------------------
createDefaultConfig(fn){
  
  content := "
(
[hotkeys]
menuHotkey=""!c""
menuOpenHotkey=""!p""
exitHotkey=""+!c""
runnerhotkey=""*!r""

[timing]
hintTimeShort=1500
hintTimeMedium=2000
hintTime=3000
hintTimeLong=20000

[config]
font=""Segoe UI""
fontsize=9
sessionfiles=""C:\npp-sessions\""
sessionfileExtension="".npp-session""

[external]
notepadppPath=""C:\Program Files\Notepad++\notepad++.exe""

[fastSwitchCycle]
fastSwitchCycleGroupSelected=1
fastSwitchCycleHotkey=""

;fastSwitchCycleGroup1 is fixed to Off
fastSwitchCycleGroup2_Off=!d,!n
fastSwitchCycleGroup3_Off=!d,!n,!b
fastSwitchCycleGroup4_Off=!b,!k
fastSwitchCycleGroup5_Off=!n,!b
fastSwitchCycleGroup6_Off=!n,!f
fastSwitchCycleGroup7_Off=!n,!k
fastSwitchCycleGroup8_Off=!n,!k,!d
fastSwitchCycleGroup9_Off=!d,!o

fastSwitchAutoCycleHotkey=!q

fastSwitchUseTitle=ConsoleWindowClass

[openSessionTiming]
waitForNotepadReady=1000
waitForSessionManagerLoop=500
waitForEditReady=500
waitDokListOpenLoop=1000
)"

  FileAppend, %content%, %fn%, UTF-16
}

;----------------------------------------------------------------------------


































































