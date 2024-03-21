; cmdlinedev_mainWindow.ahk
; part of cmdlinedev

;-------------------------------- mainWindow --------------------------------
mainWindow(hide := false) {
  global mainHWND, MainStatusBarHwnd, Text1, bit
  global windowPosX, windowPosY, clientWidth, clientHeight  
  global directoriesFile, toolsFile, shortcutsFile, fastSwitchHotkeysFile, configFile
  global app, appName, appVersion, appTitle
  global menuHotkey, exithotkey, runnerhotkey, runnerPath, Edit1
  global directoriesArr, paramMaxCount, LV1, Errormessage
  global font, fontsize, emptyFiledSubstituteChar
  global fastSwitchCycleHotkey, fastSwitchCycleGroupSelected, fastSwitchCycleGroupSelectedMax, fastSwitchAutoCycleHotkeyDefault, fastSwitchAutoCycleHotkey

  global fastSwitchCycleGroup2, fastSwitchCycleGroup3, fastSwitchCycleGroup4, fastSwitchCycleGroup5, fastSwitchCycleGroup6, fastSwitchCycleGroup7, fastSwitchCycleGroup8, fastSwitchCycleGroup9
    
  global Button_1, Button_2, Button_3, Button_4, Button_5, Button_6, Button_7
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
  
  gui,guiMain:New, +OwnDialogs +LastFound MaximizeBox HWNDmainHWND +Resize, %appTitle%`

  gui, Margin,6,4
  gui, guiMain:Font, s%fontsize%, %font%

  lv1Width := clientWidth - 10
  
  fastSwitchCycleHotkeyDisplay := "(" . hotkeyToText(fastSwitchCycleHotkey) . "):"
  gui, guiMain:Add, Text,x5 y5,FastSwitch-Cycle %fastSwitchCycleHotkeyDisplay%
     
  fastSwitchCycleGroup1 := "Off"
  gui, guiMain:Add, Radio, x+m section y5 gSaveSelectedFSGroup vfastSwitchCycleGroupSelected,%fastSwitchCycleGroup1%

  if (fastSwitchCycleGroup2 != "-"){
    gui, guiMain:Add, Radio, ys gSaveSelectedFSGroup,%fastSwitchCycleGroup2%
  }
  
  if (fastSwitchCycleGroup3 != "-"){
    Gui, guiMain:Add, Radio, ys gSaveSelectedFSGroup,%fastSwitchCycleGroup3%
  }
  
  if (fastSwitchCycleGroup4 != "-"){
    gui, guiMain:Add, Radio, ys gSaveSelectedFSGroup,%fastSwitchCycleGroup4%
  }
  
  if (fastSwitchCycleGroup5 != "-"){
    gui, guiMain:Add, Radio, ys gSaveSelectedFSGroup,%fastSwitchCycleGroup5%
  }
  
  if (fastSwitchCycleGroup6 != "-"){
    gui, guiMain:Add, Radio, ys gSaveSelectedFSGroup,%fastSwitchCycleGroup6%
  }
  
  if (fastSwitchCycleGroup7 != "-"){
    gui, guiMain:Add, Radio, ys gSaveSelectedFSGroup,%fastSwitchCycleGroup7%
  }
  
  if (fastSwitchCycleGroup8 != "-"){
    gui, guiMain:Add, Radio, ys gSaveSelectedFSGroup,%fastSwitchCycleGroup8%
  }
  
  if (fastSwitchCycleGroup9 != "-"){
    gui, guiMain:Add, Radio, ys gSaveSelectedFSGroup,%fastSwitchCycleGroup9%
  }
  
  gui, guiMain:Add, Button, x+m ys grunCurrent vButton_7, Open currently selected entry
  
  gui, guiMain:Add, Text, x+m , Run external app:
  gui, guiMain:Add, Edit, x+m ys r1 w300 GrundevSave vEdit_Run, %runnerPath%
  
  fastSwitchAutoCycleHotkeyDisplay := "(" . hotkeyToText(fastSwitchAutoCycleHotkey) . "):"
  gui, guiMain:Add, Text,x5 ,FS Auto Cycle %fastSwitchAutoCycleHotkeyDisplay%
  
  gui,guiMain:Add, Button, xs yp gfsLearn vButton_1, Learn
  gui,guiMain:Add, Button, x+m yp gfsEdit vButton_2, Edit

  gui,guiMain:Add, Button, x+m yp gfsSave1, Save 1
  gui,guiMain:Add, Button, x+m yp gfsRead1, Load 1
  gui,guiMain:Add, Button, x+m yp gfsSave2, Save 2
  gui,guiMain:Add, Button, x+m yp gfsRead2, Load 2
  gui,guiMain:Add, Button, x+m yp gfsSave3, Save 3
  gui,guiMain:Add, Button, x+m yp gfsRead3, Load 3
  
  gui,guiMain:Add, Button, x+m yp gfsClean vButton_4, Clean
  gui,guiMain:Add, Button, x+m yp gfsCleanAll vButton_5, CleanAll
  gui,guiMain:Add, Button, x+m yp gfsEditFile vButton_6, Edit-file
  gui,guiMain:Add, Button, x+m yp gfsArrangeManual vButton_3, Arrange
  
  gui,guiMain:Add, Text, x+m yp+3 gfsClean w300 vFSACText
  gui,guiMain:Add, Text, xp+0 yp+0 gfsClean w300 c00FF00 vFSACTextGreen
  gui,guiMain:Add, Text, xp+0 yp+0 gfsClean w300 cFF0000 vFSACTextRed
   
  gui, guiMain:Add, ListView, x5 w%lv1Width% GguiMainListViewEvent vLV1 hwndhLV1 Grid -Multi, |Name|Latest|Dir|Cmd1|Cmd2|Cmd3|Cmd4
  ; hidden global enter button 
  gui, guiMain:Add, Button, Default hidden gButtonOK, OK
  
  GuiControl, -Redraw, LV1
  for index, element in directoriesArr
  {
    elementArr := StrSplit(element,",")
    if (elementArr.Length() <= paramMaxCount){
      n := paramMaxCount - elementArr.Length()
      
      Loop, %n%
        elementArr.push(emptyFiledSubstituteChar) ; add missing fields with "_"-character
    }
    for k, v in elementArr
      if (k > 2 && v = "")
        elementArr[k] := emptyFiledSubstituteChar ; replace empty fields with "_"-character
    
    row := LV_Add("",Format("{:02}", index),elementArr[1],elementArr[2],elementArr[3],elementArr[4],elementArr[5],elementArr[6],elementArr[7])
  }
  GuiControl, +Redraw, LV1
  
  gui, guiMain:Menu, MainMenu
    
  if (!hide){
    showWindow()
  }

  fastSwitchCycleGroupSelected := Min(fastSwitchCycleGroupSelected, fastSwitchCycleGroupSelectedMax)
  GuiControl,, Button%fastSwitchCycleGroupSelected%,1
    
  gui, guiMain:Add, StatusBar, 0x800
  
  partSize := floor(clientWidth / 2) - 50
  SB_SetParts(partSize, partSize)
  showStatusBar()
  
  LV1Modify()
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
  exit()
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
;---------------------------- SaveSelectedFSGroup ----------------------------
SaveSelectedFSGroup(){
  global mainHWND, fastSwitchCycleGroupSelected, configFile, fastSwitchCycleHotkey, appName, bitName

  gui, guiMain:Submit, NoHide

  IniWrite, %fastSwitchCycleGroupSelected%, %configFile%, fastSwitchCycle, fastSwitchCycleGroupSelected
  
  if (fastSwitchCycleHotkey != "-" && fastSwitchCycleGroupSelected > 1){
    ;Hotkey, %fastSwitchCycleHotkey%, cycle
    tipTop("FastSwitchCycle activated, a reload is required!")
    showHintColored(mainHWND, appName . bitName . " reloads now!")
    exitAndReload()
  } else {
    Hotkey, %fastSwitchCycleHotkey%, cycle
    Hotkey, %fastSwitchCycleHotkey%, Off
    showHintColored(mainHWND, "FastSwitchCycle inactive!",3000)
  } 
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
  global directoriesArr, paramMaxCount, emptyFiledSubstituteChar

  LV_Delete()
  
  for index, element in directoriesArr
  {
    elementArr := StrSplit(element,",")
    if (elementArr.Length() < paramMaxCount){
      n := paramMaxCount - elementArr.Length()
      
      Loop, %n%
        elementArr.push(emptyFiledSubstituteChar)
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
























