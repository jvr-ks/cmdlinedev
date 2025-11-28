/*
 *********************************************************************************
 * 
 * cmdlinedev.ahk
 * 
 * all files are UTF-8 no BOM encoded
 * 
 * Version -> appVersion
 * 
 * Copyright (c) 2021 jvr.de. All rights reserved.
 *
 * 
 *********************************************************************************
*/
/*
 *********************************************************************************
 * 
 * GNU GENERAL PUBLIC LICENSE
 * 
 * A copy is included in the file "license.txt"
 *
  *********************************************************************************
*/

/*
 *********************************************************************************
 * Main view element is the ListView LV1.
 * Upon a click guiMainListViewEvent() is called.
  *********************************************************************************
*/

#Requires AutoHotkey v1

#NoEnv
#Warn
#SingleInstance force
#Persistent

#InstallKeybdHook
#InstallMouseHook
#UseHook On

#Include %A_ScriptDir%

#Include Lib\table.ahk
#Include cmdlinedev_mainGui.ahk
#Include cmdlinedev_init.ahk
#Include cmdlinedev_helper.ahk
#Include cmdlinedev_hintColored.ahk
#Include cmdlinedev_htmlViewer.ahk
#Include cmdlinedev_fsEdit.ahk
#Include cmdlinedev_hotkeyfunc.ahk
#Include cmdlinedev_editGui.ahk


FileEncoding, UTF-8

clipboardSave := clipboardAll

CoordMode, ToolTip, Screen
CoordMode, Pixel, Client
CoordMode, Mouse, Screen
CoordMode, Caret, Client


SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetTitleMatchMode, 2
DetectHiddenWindows, ON
SetTitleMatchMode, slow

wrkDir := A_ScriptDir . "\"

appName := "CmdLineDev"
appnameLower := "cmdlinedev"
extension := ".exe"
appVersion := "0.359"

bit := (A_PtrSize=8 ? "64" : "32")

if (!A_IsUnicode)
  bit := "A" . bit

bitName := (bit=="64" ? "" : bit)

app := appName . " " . appVersion . " (" . bit . " bit)"
appTitle := appName . " " . appVersion

firstStart := true
sessionName := ""
currentNotepadId := ""
forcedCancel := 0
currentSelected := 0
pathSelected := ""

appDataDir := A_AppDataCommon . "\" . appnameLower . "\"

configFile := appnameLower . ".ini"

if (!FileExist(configFile)){
  createDefaultConfig(configFile)
}

directoriesFile := "clddirectories.txt"
toolsFile := "cldtools.txt"

dpiScaleDefault := 96
dpiCorrect := A_ScreenDPI / dpiScaleDefault

windowPosXDefault := 0
windowPosYDefault := 0
clientWidthDefault := 800
clientHeightDefault := 600

windowPosX := windowPosXDefault
windowPosY := windowPosYDefault
clientWidth := clientWidthDefault
clientHeight := clientHeightDefault

localVersionFileDefault := "version.txt"
serverURLDefault := "https://github.com/jvr-ks/"
serverURLExtensionDefault := "/raw/main/"

sessionfilesDefault := "C:\npp-sessions\"
sessionfiles := sessionfilesDefault

sessionfileExtensionDefault := ".npp-session"
sessionfileExtension := sessionfileExtensionDefault

localVersionFile := localVersionFileDefault
serverURL := serverURLDefault
serverURLExtension := serverURLExtensionDefault

updateServer := serverURL . appnameLower . serverURLExtension

GroupAdd,anyshell,ahk_class ConsoleWindowClass
GroupAdd,anyshell,ahk_class mintty

shortcutsArr := {}
shortcutsFile  := "cldshortcuts.txt"

fastSwitchHotkeysArr := {}
fastSwitchHotkeysFile := "cldfastswitchhotkeys.txt"
fastSwitchUseTitle := ""
fastSwitchUseTitleArr := {}

notepadppPathDefault := "C:\Program Files\Notepad++\notepad++.exe"

; overwritten by ini-file
showActiveTitle := true
notepadppPath := notepadppPathDefault

menuHotkeyDefault := "!c"
menuOpenHotkeyDefault := "#!c"
exitHotkeyDefault := "+!c"
menuHotkey := menuHotkeyDefault
menuOpenHotkey := menuOpenHotkeyDefault
exitHotkey := exitHotkeyDefault
runnerhotkeyDefault := "*!r"
runnerhotkey := runnerhotkeyDefault
runnerPath := ""

hintTimeShortDefault := 1500
hintTimeMediumDefault := 2000
hintTimeDefault := 3000
hintTimeLongDefault := 5000

hintTimeShort := hintTimeShortDefault
hintTimeMedium := hintTimeMediumDefault
hintTime := hintTimeDefault
hintTimeLong := hintTimeLongDefault

delayAfterCommandDefault := 2000
delayAfterCommand := delayAfterCommandDefault

directoriesArr := []
toolsArr := {}
param := []

paramMaxCountDefault := 7
paramMaxCount := paramMaxCountDefault

fsEditListSelected := 0
showPermanent := 0

;--- Gui parameter ---
activeWin1 := 0

borderLeft := 2
borderRight := 2
borderTop := 70 ; reserve statusbar space


fastSwitchCycleHotkeyDefault := "!t"
fastSwitchCycleHotkey := fastSwitchCycleHotkeyDefault

fastSwitchAutoCycleHotkeyDefault := "!q"
fastSwitchAutoCycleHotkey := fastSwitchAutoCycleHotkeyDefault
fastSwitchCycleArr := []
fastSwitchCyclePointer := 1
fastSwitchCycleGroup := "-"
fastSwitchCycleGroupSelected := 1
fastSwitchCycleGroupSelectedMax := 9

fsWindowsFile := "cldwindows.txt"
windowsTitleArr := {}
windowsOrderArr := {}
windowsMaxIndex := 1
; windowsCycleArr := {}
windowsCycleArrClass := {}
windowsCycleArrTitle := {}

fontDefault := "Calibri"
font := fontDefault
emptyFieldSubstituteChar := "_"

fontsizeDefault := 10
fontsize := fontsizeDefault

hideOnStartup := true
allArgs := ""

Loop % A_Args.Length()
{
  if(eq(A_Args[A_index],"remove"))
    exitApp
  
  if(eq(A_Args[A_index],"hidewindow")){
    ; is default
    hideOnStartup := true
  }
  
  if(eq(A_Args[A_index],"showwindow")){
    hideOnStartup := false
  }
  
  if(InStr(A_Args[A_index], ".txt")){
    directoriesFile := A_Args[A_index]
  }
  
  if(InStr(A_Args[A_index], ".ini")){
    configFile := A_Args[A_index]
  }
  
  allArgs .= A_Args[A_index] . " "
}

if (hideOnStartup){
  tipTop(app . "`n`nHotkey is: " . hotkeyToText(menuHotkey) . "`nConfiguration-file: " . configFile . "`nDirectories-file: " . directoriesFile, 1, 6000)
  prepare()
  readGuiParam()
  guiMainCreate(true)
} else {
  prepare()
  readGuiParam()
  guiMainCreate()
}

OnMessage(0x03,"WM_MOVE")

return


;-------------------------------- saveGuiData -------------------------------
saveGuiData(){
  global mainHWND, configFile, windowPosX, windowPosY, clientWidth, clientHeight, currentSelected
  
  IniWrite, %currentSelected%, %configFile%, gui, currentSelected
  
  WinGetPos, windowPosX, windowPosY,,, ahk_id %mainHWND%
  
  IniWrite, %windowPosX%, %configFile%, gui, windowPosX
  IniWrite, %windowPosY%, %configFile%, gui, windowPosY
  
  IniWrite, %clientWidth%, %configFile%, gui, clientWidth
  IniWrite, %clientHeight%, %configFile%, gui, clientHeight
  
}
;--------------------------- guiMainListViewEvent ---------------------------
guiMainListViewEvent(){
  global directoriesFile, directoriesArr, currentSelected, currentChecked, configFile
    
  ; LV_GetText(tmp, A_EventInfo)
  ; tooltip A_GuiEvent: %A_GuiEvent% A_EventInfo: %A_EventInfo% content %tmp%

  if (A_GuiEvent = "Normal"){
    LV_GetText(rowSelected, A_EventInfo)

    IniWrite, %rowSelected%, %configFile%, config, lastOpenedRow
    runInDir(rowSelected)
  }
}
;-------------------------------- runLastUsed --------------------------------
runLastUsed(){
  global currentSelected
  
  runInDir(currentSelected)
}
;------------------------------ runningMessage ------------------------------
runningMessage(directoryEntryArr, n){
  
  ret := ""
  ret := directoryEntryArr[1] . "`n`nRunning Cmd" . n . " only:`n`n" . directoryEntryArr[3 + n]

 return ret
}
;--------------------------------- runInDir ---------------------------------
runInDir(lineNumber) {
  global mainHWND, directoriesFile, directoriesArr, toolsArr, paramMaxCount
  global hintTimeShort, hintTimeMedium, hintTime, hintTimeLong
  global paramMaxCount, forcedCancel, emptyFieldSubstituteChar
  global lastUsedText, currentSelected, eventTriggered
  global pathSelected

  directoryEntryArr := []
  ; entries: 1 Name, 2 Current, 3 path, 4 - 7 commands
  directoryEntryArr := StrSplit(directoriesArr[lineNumber],",")
  
  a := directoryEntryArr[1]
  GuiControl,, lastUsedText, %a%
  
  SetCapsLockState, off

  if (lineNumber != 0){
    ks := getKeyboardState()
    
    pathSelected := ""
    pathSelected := cvtPath(directoryEntryArr[3])
    
    switch ks
    {
    case 0:
      ; no additional key pressed
      msg := directoryEntryArr[1]  . "`n`nRunning all Cmds:`n`n"
      entriesStart := 3
      loop 5
      {
        s := directoryEntryArr[A_Index + entriesStart] 
        if (s != emptyFieldSubstituteChar && s != "")
          msg .= directoryEntryArr[A_Index + entriesStart] . "`n"
      }
      showHintColored(mainHWND, msg, hintTime,,,,, "+0x80800000")
      runInDirDefault(lineNumber,0)
      tipTopCloseAll()
    case 2:
      ;*** Alt ***
      showHintColored(mainHWND, runningMessage(directoryEntryArr, 2), 0)
      runInDirDefault(lineNumber,2)
      tipTopCloseAll()  
      Gui, hintColored:Destroy      
    case 4:
      ;*** Ctrl ***
      showHintColored(mainHWND, runningMessage(directoryEntryArr, 1), 0)
      runInDirDefault(lineNumber,1)
      tipTopCloseAll()
      Gui, hintColored:Destroy
    case 6:
      ;*** Alt + Ctrl***
      ; set latest field
      
      LV_GetText(rowSelected, A_EventInfo)
      currentSelected := rowSelected
      
      s := directoriesArr[rowSelected]
      s := insertDateTime(s)

      ;save new command
      directoriesArr[rowSelected] := s
       
      content := ""
      Loop, % directoriesArr.Length() {
        content := content . directoriesArr[A_Index] . "`n"
      }

      FileDelete, %directoriesFile%
      FileAppend, %content%, %directoriesFile%, UTF-8
    
      showWindow()
      refreshGui()

    case 8:
      ;*** Shift = edit ***
      editGuiCreate()
      
    case 10:
      ;*** Alt + shift***
      showHintColored(mainHWND, runningMessage(directoryEntryArr, 4), 0)
      runInDirDefault(lineNumber,4)
      tipTopCloseAll()
      Gui, hintColored:Destroy
    case 12:
      ;*** Ctrl + shift***
      showHintColored(mainHWND, runningMessage(directoryEntryArr, 3), 0)
      runInDirDefault(lineNumber,3)
      tipTopCloseAll()
      Gui, hintColored:Destroy
    case 22:
      ;*** Win + Alt + Ctrl***
      ; moveRowToTop (only inside the file!)
      current := directoriesArr[lineNumber]
      
      directoriesArr.RemoveAt(lineNumber)
      directoriesArr.InsertAt(1,current)

      ; save
      content := ""
      
      Loop, % directoriesArr.Length()
      {
        content := content . directoriesArr[A_Index] . "`n"
      }

      FileDelete, %directoriesFile%
      FileAppend, %content%, %directoriesFile%, UTF-8

      showWindow()
      refreshGui()
      

/* 
    case XY:
      ; move one row down (only inside the file!) (not used)
      current := directoriesArr[lineNumber]
      
      directoriesArr.InsertAt(lineNumber + 2,current)
      directoriesArr.RemoveAt(lineNumber)
      
      ; save
      content := ""
      
      Loop, % directoriesArr.Length()
      {
        content := content . directoriesArr[A_Index] . "`n"
      }

      FileDelete, %directoriesFile%
      FileAppend, %content%, %directoriesFile%, UTF-8

      showWindow()
      refreshGui() 
*/

    }
  }
}
;------------------------------ runInDirDefault ------------------------------
runInDirDefault(i, useonly){
  global mainHWND, directoriesFile, directoriesArr, paramMaxCount, toolsArr
  global hintTimeShort, hintTimeMedium, hintTime, hintTimeLong
  global delayAfterCommand, delayAfterCommandDefault
  global sessionName, currentNotepadId
  global configFile, runnerPath, Edit_Run, emptyFieldSubstituteChar
  global pathSelected

  directoryEntryArr := StrSplit(directoriesArr[i],",")
  
  ; entries: 1 Name, 2 Current, 3 path, 4 - 7 commands
  ; useonly: 2,3,4,5 -> index + 2: 4,5,6,7

  pathRaw := directoryEntryArr[3]
  
  commandsMax := 0

  if (useonly == 0)
    commandsMax := paramMaxCount - 3
  else
    commandsMax := 1

  Loop, %commandsMax%
  {
    index := A_Index
    
    if (useonly > 0 &&  useonly < 5)
      index := useonly
      
    toRun := ""
    command := ""
    tool := ""

    parameter1 := ""
    parameter2 := ""
    parameter3 := ""
    parameter4 := ""
    parameter5 := ""
    parameter6 := ""
    
    toSend1 := ""
    toSend2 := ""
    toSend3 := ""
    toSend4 := ""
    toSend5 := ""
    toSend6 := ""
    
    delay1 := 1
    delay2 := 1
    delay3 := 1
    delay4 := 1
    delay5 := 1
    delay6 := 1
    
    delayAfterCommand := delayAfterCommandDefault
    delayBeforeCommand := 0
    
    command := directoryEntryArr[index + 3]
    nameArr := []

    if (command != ""){
      if (InStr(command,"#")){
        nameArr := StrSplit(command,"#")
        command := nameArr[1]
        command := StrReplace(command, "+", "", count)

        if (count > 0){
          delayBeforeCommand := delayBeforeCommand + count * 2000
        }
        parameter1 := extractToSend(nameArr[2], pathRaw, toSend1, delay1)
        parameter2 := extractToSend(nameArr[3], pathRaw, toSend2, delay2)
        parameter3 := extractToSend(nameArr[4], pathRaw, toSend3, delay3)
        parameter4 := extractToSend(nameArr[5], pathRaw, toSend4, delay4)
        parameter5 := extractToSend(nameArr[6], pathRaw, toSend5, delay5)
        parameter6 := extractToSend(nameArr[7], pathRaw, toSend6, delay6)
      }
      command := StrReplace(command, "+", "", count)
      tool := toolsArr[command]
      
      if (tool != ""){
        if (count > 0)
          MsgBox, Tool: %tool%, delay modifier (+) not allowed (useless!) using a tool!
      
        toRun := trim(tool . " " . parameter1 . " " . parameter2 . " " . parameter3 . " " . parameter4 . " " . parameter5 . " " . parameter6)
         ;msgbox, % toRun
      } else {
        ;internal commands:
        c := StrLower(command)
        switch c
        {
          case "!shell!":
            s := ""
            Loop, 6
            {
              i := parameter%A_index%
              if (i != ""){
                s := s . i . "`n"
              }
            }
            openShell(s)
            
          case "!showmessage!":
            t := Max(delay1,600)
            showHintColored(mainHWND, toSend1, t)
            sleep, t
            
          case "!showmessageBig!":
            t := Max(delay1,600)
            showHintColored(mainHWND, toSend1, t ,,,,12)
            sleep, t
              
          case "!opensession!":
            if (parameter1 == ""){
              msgbox, Sessionname missing!
            } else {
              sessionName := parameter1
              
            if (delayBeforeCommand > 0)
              sleep,%delayBeforeCommand%
              
            opensession()
              
            if (delayAfterCommand > 0)
              sleep, %delayAfterCommand%
            }
            
          case "!externalApp!":
            runnerPath := nameArr[2]
            if (runnerPath == ""){
              msgbox, ERROR !externalApp! command, a parameter is missing!
            } else {
              IniWrite, %runnerPath%, %configFile%, external, runnerPath
              GuiControl, guiMain:, Edit_Run, %runnerPath%
            }
            
          case emptyFieldSubstituteChar:
            ; empty-character, do nothing!

          default:
            msgbox, ERROR tool "%c%" not found and no internal command!
        }
      }
      
      if (toRun != ""){
        logfile :=  "cldLog.bat"
        if (FileExist(logfile))
          FileDelete, %logfile%    
          
        FileAppend, @rem %logfile% `n`n@rem toRun:`n%toRun%`n@rem path: %pathSelected%`n`n, %logfile%, UTF-8
        
        if (delayBeforeCommand > 0)
          sleep,%delayBeforeCommand%
          
        if(pathSelected != ""){
          toRun := StrReplace(toRun, "[...]", pathSelected)
          ; clipboard := toRun
          ; msgbox, %toRun%
        }

        Run, %toRun%, %pathSelected%, MAX
        
        if (delayAfterCommand > 0)
          sleep, %delayAfterCommand%
        
        if (toSend1 != ""){
          SendInput %toSend1%
          if (delay1 == 0){
            sleepUntilCtrlPressed()
          } else {
            sleep, %delay1%
          }
        }
        
        if (toSend2 != ""){
          SendInput %toSend2%
          if (delay2 == 0){
            sleepUntilCtrlPressed()
          } else {
            sleep, %delay2%
          }
        }
        
        if (toSend3 != ""){
          SendInput %toSend3%
          if (delay3 == 0){
            sleepUntilCtrlPressed()
          } else {
            sleep, %delay3%
          }
        }
        
        if (toSend4 != ""){
          SendInput %toSend4%
          if (delay4 == 0){
            sleepUntilCtrlPressed()
          } else {
            sleep, %delay4%
          }
        }
        
        if (toSend5 != ""){
          SendInput %toSend5%
          if (delay5 == 0){
            sleepUntilCtrlPressed()
          } else {
            sleep, %delay5%
          }
        }
        
        if (toSend6 != ""){
          SendInput %toSend6%
          if (delay6 == 0){
            sleepUntilCtrlPressed()
          } else {
            sleep, %delay6%
          }
        }
    }
  }
  
  hideWindow()
 }
}
/* 
;------------------------------ checkOperation ------------------------------
checkOperation(){
  global mainHWND, hintTimeShort, hintTimeMedium, hintTime, hintTimeLong
  
  ret := 0
  
  if (getKeyboardState()){
  
    checkOperationLoop:
    Loop
    {
      tipTop("CAPSLOCK active, holdon operation, release CAPSLOCK to continue or press [Ctrl]-key to abort operation!")
      
      if (getKeyboardState() == 5){
        tipTop("Operation aborted!")
        showHintColored(mainHWND, "Operation aborted!", hintTime)
        ret := 999
        Break checkOperationLoop
      }
      sleep, 1000
      
      if (getKeyboardState() == 0){
        ret := 0
        Break checkOperationLoop
      }
    }
  }
  
  return ret
}

*/
;------------------------------- extractToSend -------------------------------
extractToSend(sIn, path, ByRef sOut, ByRef delayOut){
  ; handles path etc., extracts delayN
  ; extracts filename (containing url) from §filename§
  
  r := StrReplace(cvtPath(sIn),"^",",")
  p := cvtPath(path)
  
  pos := RegExMatch(sIn, "O)(.*)~(\d+)", match) 
  if (pos){
    sOut := cvtPath(match.1)
    delayOut := (0 + match.2) * 1000
    r := ""
  }
  
  pos := RegExMatch(sIn,"O)§(.+?)§", match)
  if (pos > 0){
    filename := p . "\" . match.1
    
    if (FileExist(filename)) {
      FileReadLine, firstline, %filename%, 1
        if (eq(firstline,"")){
          msgbox, File is empty: "filename"
          r := ""
        } else {
          r := firstline
        }
    } else {
      msgbox, File not found: %filename%
      r := ""
    }
  }
  
  return r
}
;--------------------------- sleepUntilCtrlPressed ---------------------------
sleepUntilCtrlPressed(){
  global mainHWND, app

  showHintColored(mainHWND, "[" . app . "] Waiting: If operation has finished, please press [Alt] + [Ctrl]-key to continue!")
  
  KeyWait,Alt,D
  KeyWait,Control,D
  sleep,100
  Gui, hintColored:Destroy
 }
;-------------------------------- ShowHistory --------------------------------
ShowHistory(){
  KeyHistory
 }
;------------------------------ openGithubPage ------------------------------
openGithubPage(){
  global appName
  
  StringLower, name, appName
  Run https://github.com/jvr-ks/%name%
}
;------------------------------------ ret ------------------------------------
ret() {
}
;---------------------------------- in Lib ----------------------------------
; hkToDescription
; hotkeyToText
; getKeyboardState
;-------------------------------- openSession --------------------------------
openSession(){
  global sessionName, notepadppPath, currentNotepadId
  global waitForNotepadReady, waitForSessionManagerLoop, waitForEditReady, waitDokListOpenLoop
  global sessionfiles, sessionfileExtension
  
  sessionId := "[" . sessionName . "] ahk_class Notepad++"
  
  FormatTime, notepadId, %A_Now% T8, 'id'yyyyMMddhhmmss
  
  if (WinExist(sessionId)){
    WinActivate, %sessionId%
    WinMaximize, %sessionId%
    t := -1 * waitDokListOpenLoop
    settimer, openDocumentList, %t%
  } else {
    runparam := """" . notepadppPath . """ " 
    runparam .= "-titleAdd=" . notepadId . " " 
    runparam .= -multiInst . " "
    ; "use -openSession" to open an empty session fist!
    runparam .= "-openSession ________EMPTY.npp-session"
    run, %runparam%
    WinWait, %notepadId%,,15
    if (ErrorLevel){
      run, %runparam% ; 2nd trial
    }
    
    WinWaitActive, %notepadId%,, 10
    if (!ErrorLevel){
      sleep, %waitForNotepadReady%
      controlsend,,{ALT down}{x}{ALT up}, %notepadId%
      
      found := 0
      loop 10 {
        if (WinExist("ahk_class #32770 ahk_exe notepad++.exe")){
          found := 1
          break
        } else {
        sleep, %waitForSessionManagerLoop%
        controlsend,,{ALT down}{x}{ALT up}, %notepadId%
        }
      }
      if (!found){
        msgbox, Could not start Session Manager Plugin!
        return
      }
      
      ; delete previous text
      sleep, %waitForEditReady%
      controlsend, Edit1, {Ctrl Down}{a}{Ctrl Up}, ahk_class #32770 ahk_exe notepad++.exe
      controlsend, Edit1, {Del}, ahk_class #32770 ahk_exe notepad++.exe
      
      controlsend, Edit1, %sessionName%, ahk_class #32770 ahk_exe notepad++.exe
      
      number := 0
      DetectHiddenWindows, ON
      ControlGet, Items, List,, Listbox1, ahk_class #32770 ahk_exe notepad++.exe

      Loop, Parse, Items, `n
      {
        if (InStr(A_LoopField, sessionName))
          number := A_Index
      }
      
      if (number > 0){
        Control, Choose, %number%, Listbox1, ahk_class #32770 ahk_exe notepad++.exe
      }
      openDocumentList()
    } else {
        msgbox, Could not create a new notepad++ instance !
    }
  }
}
;----------------------------- openDocumentList -----------------------------
openDocumentList(){
  global sessionName, waitDokListOpenLoop
  
  sessionId := "[" . sessionName . "] ahk_exe notepad++.exe"

  Loop, 10 {
    ControlGet, sysListView321IsVisible, Visible,,SysListView321, %sessionId%
    if (!sysListView321IsVisible){
      controlsend,SysListView321,{Ctrl down}{Tab}{Ctrl up}, %sessionId%
    } else {
      Break
    }
    sleep, %waitDokListOpenLoop%
  }
}
;---------------------------- editDirectoriesFile ----------------------------
editDirectoriesFile(){
  global editTextFileFilename, directoriesFile
  
  editTextFileFilename:= directoriesFile
  editTextFile()
 }
;------------------------ editDirectoriesFileExternal ------------------------
editDirectoriesFileExternal(){
  global directoriesFile
  
  RunWait, %directoriesFile%
  msgbox, 36, External edit operation finished!, If content was changed via an external editor`,`nplease press the "OK"-button to reload!
    IfMsgBox Yes
      restart(1)
    else
      gui, guiMain:Show
}
;------------------------------- editToolsFile -------------------------------
editToolsFile(){
  global editTextFileFilename, toolsFile
  
  editTextFileFilename:= toolsFile
  editTextFile()
}
;--------------------------- editToolsFileExternal ---------------------------
editToolsFileExternal(){
  global toolsFile
  
  run, %toolsFile%
  msgbox, If content was changed via an external editor`,`nplease press the "OK"-button to reload!
  restart(1)
}

;----------------------------- editShortcutsFile -----------------------------
editShortcutsFile(){
  global editTextFileFilename, shortcutsFile
  
  editTextFileFilename:= shortcutsFile
  editTextFile()
}
;------------------------- editShortcutsFileExternal -------------------------
editShortcutsFileExternal(){
  global shortcutsFile
  
  run, %shortcutsFile%
  msgbox, If content was changed via an external editor`,`nplease press the "OK"-button to reload!
  restart(1)
}
;---------------------------- editFastSwitchFile ----------------------------
editFastSwitchFile(){
  global editTextFileFilename, fastSwitchHotkeysFile
  
  editTextFileFilename:= fastSwitchHotkeysFile
  editTextFile()
}
;------------------------ editFastSwitchFileExternal ------------------------
editFastSwitchFileExternal(){
  global fastSwitchHotkeysFile
  
  run, %fastSwitchHotkeysFile%
  msgbox, If content was changed via an external editor`,`nplease press the "OK"-button to reload!
  restart(1)
}
;------------------------------ editConfigFile ------------------------------
editConfigFile(){
  global editTextFileFilename, configFile
  
  editTextFileFilename:= configFile
  editTextFile()
}
;-------------------------- editConfigFileExternal --------------------------
editConfigFileExternal(){
  global configFile
  
  run, %configFile%
  msgbox, If content was changed via an external editor`,`nplease press the "OK"-button to reload!
  restart(1)
}
;----------------------------- editFsWindowsFile -----------------------------
editFsWindowsFile(){
  global editTextFileFilename, fsWindowsFile
  
  editTextFileFilename:= fsWindowsFile
  editTextFile()
}
;------------------------- editFsWindowsFileExternal -------------------------
editFsWindowsFileExternal(){
  global fsWindowsFile
  
  RunWait, %fsWindowsFile%
  msgbox, 36, External edit operation finished!, If content was changed via an external editor`,`nplease press the "OK"-button to reload!
    IfMsgBox Yes
      restart(1)
    else
      gui, guiMain:Show
}
;------------------------------- editTextFile -------------------------------
; non SCI version
editTextFile(){
  global editTextFileFilename, editTextFileContent, clientWidth, clientHeight
  
  hideWindow()

  if (FileExist(editTextFileFilename)){
    theFile := FileOpen(editTextFileFilename, "r `n")
    
    if !IsObject(theFile) {
        msgbox, Error, can't open "%editTextFileFilename%" for reading, exiting to prevent a data loss!
        exitApp
    } else {
      data := theFile.Read()
      theFile.Close()
      
      editTextFileContent := data
      
      borderX := 10
      borderY := 50
      
      h := clientHeight - borderY
      w := clientWidth - borderX
      
      gui, editTextFile:new, +resize +AlwaysOnTop,Edit (autosave on close): %theFile%
      gui, editTextFile:Font, s9,Segoe UI
      gui, editTextFile:Add, edit, x0 y0 w0 h0
      gui, editTextFile:add,edit, h%h% w%w% VeditTextFileContent,%data%
      
      gui, editTextFile:show,center autosize
    } 
  } else {
    msgbox, Error, file not found: %theFile% !
  }
}
;--------------------------- editTextFileGuiClose ---------------------------
editTextFileGuiClose(){
  global appname, editTextFileFilename, editTextFileContent
  
  gui,editTextFile:submit,nohide
  
  theFile := FileOpen(editTextFileFilename, "w `n")
  
  if !IsObject(theFile) {
      msgbox, Error, can't open "%editTextFileFilename%" for writing!
  } else {
    theFile.Write(editTextFileContent)
    theFile.Close()

    gui,editTextFile:destroy

    restart(1)
  }
 }
;---------------------------- editTextFileGuiSize ----------------------------
editTextFileGuiSize(){

   if (A_EventInfo != 1) {
    editTextFileWidth := A_GuiWidth
    editTextFileHeight := A_GuiHeight

    borderX := 10
    borderY := 50
    
    w := editTextFileWidth - borderX
    h := editTextFileHeight - borderY

    GuiControl, Move, editTextFileContent, h%h% w%w%
  }
}

;---------------------------------- restart ----------------------------------
restart(forceShow := 0){
  global mainHWND, clipboardSave
  global app
  global allArgs

  saveGuiData()
  showHintColored(mainHWND, """" . app . """ restart!",3000,"cFF0000","c00FF00")
  clipboard := clipboardSave
  
  if (forceShow){
    allArgs := StrReplace(allArgs,"showwindow","")
    allArgs := StrReplace(allArgs,"hidewindow","")
    allArgs .= " " . "showwindow"
  }
  
  if A_IsCompiled
      Run "%A_ScriptFullPath%" /force /restart %allArgs%
  else
      Run "%A_AhkPath%" /force /restart "%A_ScriptFullPath%" %allArgs%


  ExitApp
}
;--------------------------------- errorExit ---------------------------------
errorExit(theMsgArr, clp := "") {

  msgComplete := ""
  for index, element in theMsgArr
  {
    msgComplete .= element . "`n"
  }
  msgbox,48,ERROR,%msgComplete%

  exit()
}
;------------------------------- exitAndReload -------------------------------
exitAndReload(){
  global appname
  
  saveGuiData()
  
  restart(1)
}
;----------------------------------- exit -----------------------------------
exit() {
  global mainHWND, app, clipboardSave
  
  saveGuiData()
  showHintColored(mainHWND, app . " removed from memory!", 1500)
  
  sleep, 1500
  clipboard := clipboardSave
       
  ExitApp
}
;----------------------------------------------------------------------------
  
