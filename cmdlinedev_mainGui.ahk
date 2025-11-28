; cmdlinedev_mainGui.ahk
; part of cmdlinedev

;------------------------------- guiMainCreate -------------------------------
guiMainCreate(hide := false) {
  global mainHWND, MainStatusBarHwnd, Text1, bit
  global windowPosX, windowPosY, clientWidth, clientHeight  
  global directoriesFile, toolsFile, shortcutsFile, fastSwitchHotkeysFile, configFile
  global app, appName, appVersion, appTitle
  global menuHotkey, exitHotkey, runnerhotkey, runnerPath, Edit1
  global directoriesArr, paramMaxCount, LV1, Errormessage
  global font, fontsize, emptyFieldSubstituteChar
  global fastSwitchCycleHotkey, fastSwitchCycleGroupSelected, fastSwitchCycleGroupSelectedMax, fastSwitchAutoCycleHotkeyDefault, fastSwitchAutoCycleHotkey

  global fastSwitchCycleGroup2, fastSwitchCycleGroup3, fastSwitchCycleGroup4, fastSwitchCycleGroup5, fastSwitchCycleGroup6, fastSwitchCycleGroup7, fastSwitchCycleGroup8, fastSwitchCycleGroup9
    
  global Button_1, Button_2, Button_3, Button_4, Button_5, Button_6, Button_7, Button_8
  global Edit_Run
  
  global FSACText, FSACTextGreen, FSACTextRed, fsWindowsFile
  
  Menu, Tray, UseErrorLevel

  Menu, MainMenuEdit,Add,Edit Directories-file: "%directoriesFile%",editDirectoriesFile
  Menu, MainMenuEdit,Add,Edit Directories-file: "%directoriesFile%" with system default editor,editDirectoriesFileExternal
  Menu, MainMenuEdit,Add,
  Menu, MainMenuEdit,Add,Edit Tools-file: "%toolsFile%",editToolsFile
  Menu, MainMenuEdit,Add,Edit Tools-file: "%toolsFile%" with system default editor,editToolsFileExternal
  Menu, MainMenuEdit,Add,
  Menu, MainMenuEdit,Add,Edit Shortcuts-file: "%shortcutsFile%",editShortcutsFile
  Menu, MainMenuEdit,Add,Edit Shortcuts-file: "%shortcutsFile%" with system default editor,editShortcutsFileExternal
  Menu, MainMenuEdit,Add,Sort Shortcuts-file: "%shortcutsFile%",sortShortcutsFile
  Menu, MainMenuEdit,Add,
  Menu, MainMenuEdit,Add,Edit Fastswitch-file: "%fastSwitchHotkeysFile%",editFastSwitchFile
  Menu, MainMenuEdit,Add,Edit Fastswitch-file: "%fastSwitchHotkeysFile%" with system default editor,editFastSwitchFileExternal
  Menu, MainMenuEdit,Add,
  Menu, MainMenuEdit,Add,Edit Configuration-file: "%configFile%",editConfigFile
  Menu, MainMenuEdit,Add,Edit Configuration-file: "%configFile%" with system default editor,editConfigFileExternal
  Menu, MainMenuEdit,Add,
  Menu, MainMenuEdit,Add,Edit FsWindows-file: "%fsWindowsFile%",editFsWindowsFile
  Menu, MainMenuEdit,Add,Edit FsWindows-file: "%fsWindowsFile%" with system default editor,editFsWindowsFileExternal

  Menu, MainMenuTools, Add, Open Autostartfolder %A_UserName%, openAutostartFolderUser
  Menu, MainMenuTools, Add, Open Autostartfolder admin, openAutostartFolderAdmin
  Menu, MainMenuTools, Add, Open God mode, openGodMode


  Menu, MainMenuInsert,Add,Insert URL`/Firefox,insertFireFoxURL
  Menu, MainMenuInsert,Add,Insert URL`/Chrome,insertChromeURL


  Menu, MainMenuUpdate,Add,Check if new version is available, startCheckUpdate
  Menu, MainMenuUpdate,Add, Start updater, startUpdate
  
  Menu, MainMenuHelp, Add,Quick-help offline,htmlViewerOffline
  Menu, MainMenuHelp, Add,Quick-help online,htmlViewerOnline
  Menu, MainMenuHelp, Add,README online, htmlViewerOnlineReadme
  Menu, MainMenuHelp, Add,Open Github,openGithubPage
  
  
  Menu, MainMenuSystem,Add,ShowHistory,ShowHistory
  
  Menu, MainMenu, Add,Setup,:MainMenuEdit
  Menu, MainMenu, Add,Tools,:MainMenuTools
  Menu, MainMenu, Add,Insert,:MainMenuInsert
  Menu, MainMenu, Add,Update,:MainMenuUpdate
  Menu, MainMenu, Add,Help,:MainMenuHelp

  ex := chr(0x2715)
  Menu, MainMenu,Add,%ex% Kill the app %ex% ,exit
  
  gui, guiMain:New, +OwnDialogs +LastFound MaximizeBox HWNDmainHWND +Resize, %appTitle%`

  gui, Margin,6,4
  gui, guiMain:Font, s%fontsize%, %font%

  editheight := 2 * fontsize + 2
  gui, guiMain:Add, Button, x5 y5 h%editheight% GrunLastUsed vButton_7, Open:
  gui, guiMain:Add, Edit, x+m yp+0 vlastUsedText readonly w150 h%editheight%, % getNameOfCurrentSelected()
  
  gui, guiMain:Add, Text, x+m yp+2, Run:
  ;gui, guiMain:Add, Edit, x+m yp-2 w200 h%editheight% vEdit_Run, % RegExReplace(runnerPath, ".*\\(.*)$", "$1")
  gui, guiMain:Add, Edit, x+m yp-2 w200 h%editheight% vEdit_Run, %runnerPath%
  gui, guiMain:Add, Button, x+m yp+0 h%editheight% grundevSave vButton_8, Save
  
  gui, guiMain:Add, Text, x+m yp+2, FastSwitch:
  gui, guiMain:Add, Button, x+m yp-2 h%editheight% gfsLearn vButton_1, Learn
  gui, guiMain:Add, Button, x+m yp+0 h%editheight% gfsEdit vButton_2, Edit

  gui, guiMain:Add, Button, x+m yp+0 h%editheight% gfsSave1, Save 1
  gui, guiMain:Add, Button, x+m yp+0 h%editheight% gfsRead1, Load 1
  gui, guiMain:Add, Button, x+m yp+0 h%editheight% gfsSave2, Save 2
  gui, guiMain:Add, Button, x+m yp+0 h%editheight% gfsRead2, Load 2
  gui, guiMain:Add, Button, x+m yp+0 h%editheight% gfsSave3, Save 3
  gui, guiMain:Add, Button, x+m yp+0 h%editheight% gfsRead3, Load 3
  
  gui, guiMain:Add, Button, x+m yp+0 h%editheight% gfsClean vButton_4, Clean
  gui, guiMain:Add, Button, x+m yp+0 h%editheight% gfsCleanAll vButton_5, CleanAll
  gui, guiMain:Add, Button, x+m yp+0 h%editheight% gfsEditFile vButton_6, Edit-file
  gui, guiMain:Add, Button, x+m yp+0 h%editheight% gfsArrangeManual vButton_3, Arrange
  
  gui, guiMain:Add, Text, x+m yp+0 gfsClean w300 vFSACText
  gui, guiMain:Add, Text, xp+0 yp+0 h%editheight% gfsClean w300 c00FF00 vFSACTextGreen
  gui, guiMain:Add, Text, xp+0 yp+0 h%editheight% gfsClean w300 cFF0000 vFSACTextRed
   
  lv1Width := clientWidth - 10
  gui, guiMain:Add, ListView, x5 w%lv1Width% h%editheight%  GguiMainListViewEvent AltSubmit vLV1 hwndhLV1 Grid -Multi, |Name|Latest|Dir|Cmd1|Cmd2|Cmd3|Cmd4
  ; hidden global enter button 
  gui, guiMain:Add, Button, Default hidden gButtonOK, OK
  
  GuiControl, -Redraw, LV1
  for index, element in directoriesArr
  {
    elementArr := StrSplit(element,",")
    if (elementArr.Length() <= paramMaxCount){
      n := paramMaxCount - elementArr.Length()
      
      Loop, %n%
        elementArr.push(emptyFieldSubstituteChar) ; add missing fields with "_"-character
    }
    for k, v in elementArr
      if (k > 2 && v = "")
        elementArr[k] := emptyFieldSubstituteChar ; replace empty fields with "_"-character
    
    row := LV_Add("",Format("{:02}", index),elementArr[1],elementArr[2],elementArr[3],elementArr[4],elementArr[5],elementArr[6],elementArr[7])
  }
  GuiControl, +Redraw, LV1
  
  gui, guiMain:Menu, MainMenu
    
  if (!hide){
    showWindow()
  }

  gui, guiMain:Add, StatusBar, 0x800
  
  partSize := floor(clientWidth / 2) - 50
  SB_SetParts(partSize, partSize)
  showStatusBar()
  
  LV1Modify()
}
;------------------------------ setLastUsedName ------------------------------
setLastUsedName(){
; not used
  global lastUsedText
  
  GuiControl,, lastUsedText, getNameOfCurrentSelected()

}
;------------------------- getNameOfCurrentSelected -------------------------
getNameOfCurrentSelected() {
  global directoriesArr, currentSelected
  
  directoryEntryArr := StrSplit(directoriesArr[currentSelected],",")
  
  return directoryEntryArr[1]
}
;--------------------------------- autoOpen ---------------------------------
autoOpen() {
  
  lastOpenedRow := iniReadSave("lastOpenedRow", "config", 1)
  msgbox,lastOpenedRow %lastOpenedRow%
  runInDir(lastOpenedRow)
}
;--------------------------------- LV1Modify ---------------------------------
LV1Modify(){
  global LV1, currentSelected
 
  GuiControl, -Redraw, LV1
  if (currentSelected > 0){
    LV_Modify(currentSelected, "+Select")
  }
  
  LV_ModifyCol()
  LV_ModifyCol(1,"AutoHdr Integer")
  LV_ModifyCol(2,"AutoHdr Text")
  LV_ModifyCol(3,"AutoHdr Integer Sort SortDesc")
  LV_ModifyCol(4,"AutoHdr Text")
  LV_ModifyCol(5,"250 Text")
  LV_ModifyCol(6,"250 Text")
  LV_ModifyCol(7,"250 Text")
  LV_ModifyCol(8,"AutoHdr Text")
  GuiControl, +Redraw, LV1
}
;---------------------------------- WM_MOVE ----------------------------------
WM_MOVE(wParam, lParam){
  global mainHWND, windowPosX, windowPosY
  
    WinGetPos, newWwindowPosX, newWindowPosY,,, ahk_id %mainHWND%
    
    if (newWwindowPosX > -200)
      windowPosX := newWwindowPosX
      
    if (newWindowPosY > -200)
      windowPosY := newWindowPosY
}
;------------------------------ guiMainGuiSize ------------------------------
guiMainGuiSize(){
  global mainHWND, clientWidth, clientHeight
  global windowPosXDefault, windowPosYDefault, clientWidthDefault, clientHeightDefault
  global borderLeft, borderRight, borderTop, LV1, appIsMinimized

  if (A_EventInfo != 1) {
    ; not minimized
    
    clientWidth := A_GuiWidth
    clientHeight := A_GuiHeight

    width := clientWidth - borderLeft - borderRight
    height := clientHeight - borderTop
    guicontrol, guiMain:move, LV1, x%borderLeft% w%width% h%height%
    
    partSize := floor(clientWidth / 2) - 50
    SB_SetParts(partSize, partSize)
    
  } else {
    setTimer, checkFocus, delete
    gui,guiMain:Hide
    
    appIsMinimized := 1
  }
}
;------------------------------ guiMainGuiClose ------------------------------
guiMainGuiClose(){
  global mainHWND
  
  showHintColored(mainHWND, "Hiding window... ", 1000)
  hideWindow()
}
;------------------------------- showStatusBar -------------------------------
showStatusBar(hk1 := "", hk2 := ""){
  global configFile, directoriesFile, menuHotkey, exitHotkey

  if (hk1 != ""){
    SB_SetText(" " . hk1 , 1, 1)
  } else {
    SB_SetText(" " . "Configuration-file: " . configFile , 1, 1)
  }
    
  if (hk2 != ""){
    SB_SetText(" " . hk2 , 2, 1)
  } else {
    SB_SetText(" " . "Directories-file: " . directoriesFile , 2, 1)
  }
  
  memory := "[" . GetProcessMemoryUsage() . " MB]      "
  SB_SetText("`t`t" . memory , 3, 2)
}
;----------------------------- startCheckUpdate -----------------------------
startCheckUpdate(){

  setTimer, checkFocus, delete
  checkUpdate()
  showWindow()
}
;-------------------------------- startUpdate --------------------------------
startUpdate(){
  global wrkdir, appname, bitName, extension

  updaterExeVersion := "updater" . bitName . extension
  
  if(FileExist(updaterExeVersion)){
    msgbox, Closing %appname% and starting "%updaterExeVersion%" now!
    run, %updaterExeVersion% runMode
    exit()
  } else {
    msgbox, Updater not found!
  }
  
  showWindow()
}
;----------------------------- insertFireFoxURL -----------------------------
insertFireFoxURL(){
  global directoriesFile
  
  cl := clipBoard
  if (cl != ""){
    content := "FireFox (New!),,FireFox#" . cl

    FileAppend, `n%content%, %directoriesFile%, UTF-8
    LV_Modify(LV_GetCount(), "Select Focus Vis")
  }

  exitAndReload()
 }
;------------------------------ insertChromeURL ------------------------------
insertChromeURL(){
  global directoriesFile
  
  cl := clipBoard
  if (cl != ""){
    content := "Chrome (New!),,Chrome#" . cl
     
    FileAppend, `n%content%, %directoriesFile%, UTF-8
    LV_Modify(LV_GetCount(), "Select Focus Vis")
  }
  
  exitAndReload()
 }
;-------------------------------- showWindow --------------------------------
showWindow(){
  global guiMain, windowPosX, windowPosY, clientWidth, clientHeight
  
  windowPosX := max(windowPosX,-5)
  windowPosY := max(windowPosY,-5)

  setTimer, checkFocus, Delete
  gui, guiMain:Hide
  gui, guiMain:Show, x%windowPosX% y%windowPosY% w%clientWidth% h%clientHeight%
  setTimer, checkFocus, 3000
 }
;-------------------------------- hideWindow --------------------------------
hideWindow(){
  setTimer, checkFocus, delete
  gui,guiMain:Hide
}
;---------------------------- showWindowRefreshed ----------------------------
showWindowRefreshed(){

  Gui, guiMain:default
  showWindow()
  refreshGui()
}
;-------------------------------- refreshGui --------------------------------
refreshGui(){
  global directoriesArr, paramMaxCount, emptyFieldSubstituteChar

  LV_Delete()
  
  for index, element in directoriesArr
  {
    elementArr := StrSplit(element,",")
    if (elementArr.Length() < paramMaxCount){
      n := paramMaxCount - elementArr.Length()
      
      Loop, %n%
        elementArr.push(emptyFieldSubstituteChar)
    }
      
    row := LV_Add("",Format("{:02}", index), elementArr[1], elementArr[2], elementArr[3], elementArr[4], elementArr[5], elementArr[6], elementArr[7])
  }
  
  LV1Modify()
}
;-------------------------------- checkFocus --------------------------------
checkFocus(){
  global mainHWND


  if (mainHWND != WinActive("A")){
    hideWindow()
  }
}
;--------------------------------- ButtonOK ---------------------------------
ButtonOK(){
  ; hidden button to handle LV1 press ENTER
  GuiControlGet, FocusedControl, FocusV
  if (FocusedControl == "LV1"){
    rowSelected := LV_GetNext(0, "Focused")
    runInDir(rowSelected)
  }
}
;---------------------------------- rundev ----------------------------------
rundev(){
  global runnerPath, pathSelected

  if(pathSelected != ""){
    p := cvtPath(runnerPath)
    
    run, %p%, %pathSelected%, MAX
  } else {
    if (InStr(runnerPath, ":")){ ; absolut path?
      run, %p%,, MAX
    } else {
      msgbox, Please run a command first (to set the path)!
    }
  }
}
;-------------------------------- rundevSave --------------------------------
rundevSave(){
  global mainHWND, configFile, runnerPath, Edit_Run
  
  gui, guiMain:Submit, NoHide
  runnerPath := Edit_Run
  IniWrite, %runnerPath%, %configFile%, external, runnerPath
  showHintColored(mainHWND, "Saved: " . runnerPath, 2000)
}
;----------------------------------------------------------------------------

