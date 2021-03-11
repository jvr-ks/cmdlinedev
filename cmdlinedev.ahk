/*
 *********************************************************************************
 * 
 * cmdlinedev.ahk
 * 
 * use UTF-8
 * 
 * Version -> appVersion
 * 
 * Copyright (c) 2020 jvr.de. All rights reserved.
 *
 *
 *********************************************************************************
*/

/*
 *********************************************************************************
 * 
 * MIT License
 * 
 * 
 * Copyright (c) 2020 jvr.de. All rights reserved.
 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sub-license, and/or sell copies 
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all 
 * copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANT-ABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE 
 * UTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
  *********************************************************************************
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force

#InstallKeybdHook
#InstallMouseHook
#UseHook On

#Include, Lib\ahk_common.ahk
#Include, Lib\WinGetPosEx.ahk

OwnPID := DllCall("GetCurrentProcessId")

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

FileEncoding, UTF-8-RAW
SetTitleMatchMode, 2

wrkDir := A_ScriptDir . "\"

appName := "CmdLineDev"
appVersion := "0.133"
app := appName . " " . appVersion

iniFile := wrkDir . "cmdlinedev.ini"
directoriesFile := wrkDir . "clddirectories.txt"
toolsFile := wrkDir . "cldtools.txt"

shortcutsArr := {}
shortcutsFile  := wrkDir . "cldshortcuts.txt"

fastSwitchArr := {}
fastSwitchFile  := wrkDir . "cldfastswitch.txt"

notepadPathDefault := "C:\Program Files\Notepad++\notepad++.exe"

; overwritten by ini-file
notepadpath := notepadPathDefault

menuhotkeyDefault := "!c"
exithotkeyDefault := "+!c"
menuHotkey := menuhotkeyDefault
exitHotkey := exithotkeyDefault

hintTimeShortDefault := 1500
hintTimeMediumDefault := 2000
hintTimeDefault := 3000
hintTimeLongDefault := 5000

hintTimeShort := hintTimeShortDefault
hintTimeMedium := hintTimeMediumDefault
hintTime := hintTimeDefault
hintTimeLong := hintTimeLongDefault

directoriesArr := []
toolsArr := {}
param := []

paramMaxCountDefault := 6
paramMaxCount := paramMaxCountDefault
	
msgDefault := ""

; *********** Gui parameter ***********
activeWin := 0

windowPosX := 0
windowPosY := 0
windowWidth := 0
windowHeight := 0
windowPosFixed := false

dpiScale := "on"

fontDefault := "Calibri"
font := fontDefault

fontsizeDefault := 10
fontsize := fontsizeDefault

borderX := 10
borderY := 55 ; reserve statusbar space
; *************************************


hasParams := A_Args.Length()

if (hasParams == 1){
	if(A_Args[1] = "remove")
		exit()
		
	if (A_Args[1] == "hidewindow"){
		hktest := hotkeyToText(menuHotkey)
		tipTopTime("Started " . app . ", Hotkey is: " . hktest, 4000)
		prepare()
		mainWindow(true)
	} else {
		showHint("Unknown ""parameter: " . A_Args[1] . """. Known parameter is: ""hidewindow""", hintTime)
		prepare()
		mainWindow()
	}
} else {
	prepare()
	mainWindow()
}

return
; *********************************** prepare ******************************
prepare() {
	readIni()
	readGuiParam()
	readDirectories()
	readTools()
	readShortcuts()
	readFastSwitch()
	initFastSwitch()
	
	return
}
; *********************************** readIni ******************************
readIni(){
	global iniFile
	global menuhotkeyDefault
	global menuHotkey
	
	global exithotkeyDefault
	global exithotkey

	global notepadpath
	global notepadPathDefault
	
	global hintTimeShort
	global hintTimeShortDefault
	global hintTimeMedium
	global hintTimeMediumDefault
	global hintTime
	global hintTimeDefault
	global hintTimeLong
	global hintTimeLongDefault

	global msgDefault
	global app
	global appName
	global OwnPID

; read Hotkey definition
	IniRead, menuHotkey, %iniFile%, hotkeys, menuhotkey , %menuhotkeyDefault%
	if (InStr(menuHotkey, "off") > 0){
		s := StrReplace(menuHotkey, "off" , "")
		Hotkey, %s%, showWindowRefreshed, off
	} else {
		Hotkey, %menuHotkey%, showWindowRefreshed
	}

	IniRead, exitHotkey, %iniFile%, hotkeys, exithotkey , %exithotkeyDefault%
	if (InStr(exitHotkey, "off") > 0){
		s := StrReplace(exitHotkey, "off" , "")
		Hotkey, %s%, exit, off
	} else {
		Hotkey, %exitHotkey%, exit
	}
	
	IniRead, hintTimeShort, %iniFile%, timing, hintTimeShort , %hintTimeShortDefault%
	IniRead, hintTimeMedium, %iniFile%, timing, hintTimeMedium , %hintTimeMediumDefault%
	IniRead, hintTime, %iniFile%, timing, hintTime , %hintTimeDefault%
	IniRead, hintTimeLong, %iniFile%, timing, hintTimeLong , %hintTimeLongDefault%
	
	IniRead, notepadpath, %iniFile%, external, notepadpath, %notepadPathDefault%
	
	return
}
; *********************************** readDirectories ******************************
readDirectories(){
	global directoriesFile
	global directoriesArr
	global param
	global paramMaxCount

	directoriesArr := []

	Loop, read, %directoriesFile%
	{
		if (A_LoopReadLine != "") {
			directoriesArr.Push(A_LoopReadLine)
		}
	}
	
	return
}
; *********************************** readTools ******************************
readTools(){
	global toolsArr
	global toolsFile
	
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

	return
}
; *********************************** readShortcuts ******************************
readShortcuts(){
	global shortcutsArr
	global shortcutsFile
	
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
	
	return
}
;------------------------------ readFastSwitch ------------------------------
readFastSwitch(){
	global fastSwitchArr
	global fastSwitchFile
	
	fastSwitchArr := {}

	Loop, read, %fastSwitchFile%
	{
		LineNumber := A_Index
		fastSwitchHotkey := ""
		fastSwitchTitle := ""

		if (A_LoopReadLine != "" && !InStr(A_LoopReadLine,";")) {
			Loop, parse, A_LoopReadLine, %A_Tab%`,
			{	
				if(A_Index == 1)
					fastSwitchHotkey := A_LoopField
					
				if(A_Index == 2)
					fastSwitchTitle := A_LoopField
			}
			
			fastSwitchArr[fastSwitchHotkey] := fastSwitchTitle
		}
	}
	
	return
}
;------------------------------ initFastSwitch ------------------------------
initFastSwitch(){
	global fastSwitchArr
	global fastSwitchFile
	
	for Key, Val in fastSwitchArr
		{
			if (InStr(Key, "off") > 0){
				s := StrReplace(Key, "off" , "")
				Hotkey, %s%, fastSwitchSelect, off
			} else {
				Hotkey, %Key%, fastSwitchSelect
			}
		}
	
	return
}
;----------------------------- fastSwitchSelect -----------------------------
fastSwitchSelect(){
	global fastSwitchArr
	global fastSwitchFile

			title := fastSwitchArr[A_ThisHotkey]
			if WinExist(title){
				winActivate,%title%
			}
			
	return
}
;***************************** insertFireFoxURL *****************************
insertFireFoxURL(){
	global directoriesFile
	
	cl := clipboard
	if (cl != ""){
		content := "FireFox (New!),,FireFox#" . cl
		FileAppend, `n%content%, %directoriesFile%, UTF-8-RAW
		prepare()
		LV_Modify(LV_GetCount(), "Select Focus Vis")
	}

	return
}
;***************************** insertChromeURL *****************************
insertChromeURL(){
	global directoriesFile
	
	cl := clipboard
	if (cl != ""){
		content := "Chrome (New!),,Chrome#" . cl
		FileAppend, `n%content%, %directoriesFile%, UTF-8-RAW
		prepare()
		LV_Modify(LV_GetCount(), "Select Focus Vis")
	}

	return
}
;****************************** registerWindow ******************************
registerWindow(){
	global activeWin
	
	activeWin := WinActive("A")
	
	return
}
; *********************************** showWindow ******************************
showWindow(){
	global windowPosX
	global windowPosY
	global windowWidth
	global windowHeight
	
	setTimer,registerWindow,-500
	setTimer,checkFocus,3000
	Gui, guiMain:Show, x%windowPosX% y%windowPosY% w%windowWidth% h%windowHeight%
	
	return
}
;********************************* hideWindow *********************************
hideWindow(){
	setTimer,checkFocus,delete
	Gui,guiMain:Hide

	return
}
;---------------------------- showWindowRefreshed ----------------------------
showWindowRefreshed(){
	global appName
	global menuHotkey
	global msgDefault
	global OwnPID

	prepare()
	showWindow()
	refreshGui()
	
	mem := GetProcessMemoryUsage(OwnPID) " MB"	
	msgDefault := "  " . appName . " hotkey: " . hotkeyToText(menuHotkey) . " [" . mem . "]"
	showMessage(msgDefault)
	
	return
}
; *********************************** mainWindow ******************************
mainWindow(hide := false) {
	global windowPosX
	global windowPosY
	global windowWidth
	global windowHeight	
	global directoriesFile
	global toolsFile
	global iniFile
	global fastSwitchFile
	global app
	global appName
	global appVersion	
	global msgDefault
	global menuHotkey
	global exithotkey
	global directoriesArr
	global paramMaxCount
	global LV1
	global Errormessage
	global font
	global fontsize
	global windowPosFixed
	global OwnPID
	global dpiScale

	global Text1
	
	Menu, Tray, UseErrorLevel   ; This affects all menus, not just the tray.

	Menu, MainMenu, DeleteAll
	Menu, MainMenuInsert, DeleteAll
	Menu, MainMenuEdit, DeleteAll
	Menu, MainMenuGithub, DeleteAll
	Menu, MainMenuSystem, DeleteAll
	Menu, MainMenuWindow, DeleteAll
	Menu, MainMenuClose, DeleteAll
	
	Menu, MainMenuEdit,Add,Edit Directories-file: "%directoriesFile%" with Notepad++,editDirectoriesFile
	Menu, MainMenuEdit,Add,Edit Tools-file: "%toolsFile%" with Notepad++,editToolsFile
	Menu, MainMenuEdit,Add,Edit Shortcuts-file: "%toolsFile%" with Notepad++,editShortcutsFile
	Menu, MainMenuEdit,Add,Edit Ini-file: "%iniFile%" with Notepad++,editIniFile
	Menu, MainMenuEdit,Add,Edit Fastswitch-file: "%fastSwitchFile%" with Notepad++,editFastSwitchFile
	
	Menu, MainMenuInsert,Add,Insert URL`/Firefox,insertFireFoxURL
	Menu, MainMenuInsert,Add,Insert URL`/Chrome,insertChromeURL
	
	Menu, MainMenuGithub,Add,Open %appName% Github webpage,openGithubPage
	Menu, MainMenuWindow,Add,Fix Pos/Size,fixWindowPos
	
	if (windowPosFixed)
		Menu, MainMenuWindow, Check, Fix Pos/Size
	
	Menu, MainMenuSystem,Add,ShowHistory,ShowHistory
	
	exitHotkeyText := "Close " . appName . " and remove from memory -> Hotkey: " . hotkeyToText(exitHotkey)
	Menu, MainMenuClose,Add,%exitHotkeyText%,exit
	
	Menu, MainMenu, Add,Edit,:MainMenuEdit
	Menu, MainMenu, Add,Insert,:MainMenuInsert
	Menu, MainMenu, Add,Github,:MainMenuGithub
	Menu, MainMenu, Add,System,:MainMenuSystem
	Menu, MainMenu, Add,Window,:MainMenuWindow
	Menu, MainMenu, Add,Close,:MainMenuClose
	
	Gui,guiMain:New,+E0x08000000 +OwnDialogs +LastFound MaximizeBox HwndhMain +Resize -DPIScale, %app%

	Gui, Margin,6,4
	Gui, guiMain:Font, s%fontsize%, %font%

	lv1Width := windowWidth - Round(windowWidth/10)
	;w%lv1Width%
	Gui, Add, ListView, x5 y5 w%lv1Width% gLVCommands vLV1 hwndhLV1 Grid AltSubmit -WantF2, |Name|Dir|Cmd1|Cmd2|Cmd3|Cmd4
		
	for index, element in directoriesArr
	{
		elementArr := StrSplit(element,",")
		if (elementArr.length() < 6){
			n := 6 - elementArr.length()
			
			Loop, %n%
				elementArr.push("_")
		}
			
		row := LV_Add("",index,elementArr[1],elementArr[2],elementArr[3],elementArr[4],elementArr[5],elementArr[6])
	}
	
	LV_ModifyCol(1,"AutoHdr Integer")
	LV_ModifyCol(2,"AutoHdr Text")
	LV_ModifyCol(3,"AutoHdr Text")
	LV_ModifyCol(4,"AutoHdr Text")
	LV_ModifyCol(5,"AutoHdr Text")
	LV_ModifyCol(6,"AutoHdr Text")
	LV_ModifyCol(7,"AutoHdr Text")

	Gui, guiMain:Menu, MainMenu
	
	Gui, guiMain:Add, StatusBar, 0x800 hWndhMySB
	
	mem := GetProcessMemoryUsage(OwnPID) " MB"	
	msgDefault := "  " . appName . " hotkey: " . hotkeyToText(menuHotkey) . " [" . mem . "]"
	showMessage(msgDefault)
	
	if (!hide){
		checkVersionFromGithub()
	
		setTimer,registerWindow,-500
		setTimer,checkFocus,3000
		Gui, guiMain:Show, x%windowPosX% y%windowPosY% w%windowWidth% h%windowHeight%
	}

	return
}
;******************************** refreshGui ********************************
refreshGui(){
	global directoriesArr

	prepare()

	LV_Delete()
	
	for index, element in directoriesArr
	{
		elementArr := StrSplit(element,",")
		if (elementArr.length() < 6){
			n := 6 - elementArr.length()
			
			Loop, %n%
				elementArr.push("_")
		}
			
		row := LV_Add("",index,elementArr[1],elementArr[2],elementArr[3],elementArr[4],elementArr[5],elementArr[6])
	}
	
	return
}
;****************************** guiMainGuiSize ******************************
guiMainGuiSize:
; Expand or shrink the ListView in response to the user's resizing of the window.


SetTimer %A_ThisLabel%,Off
	
if (A_EventInfo = 1)  ; The window has been minimized. No action needed.
	return

GuiControl, Move, LV1, % "W" . (A_GuiWidth - borderX) . " H" . (A_GuiHeight - borderY)

return
;******************************** checkFocus ********************************
checkFocus(){
	global activeWin
	global iniFile
	global windowPosFixed
	global windowPosX
	global windowPosY
	global windowWidth
	global windowHeight

	h := WinActive("A")
	if (activeWin != h){
		hideWindow()
	} else {
		if (!windowPosFixed){
			static xOld := 0
			static yOld := 0
			static wOld := 0
			static hOld := 0

			gui guiMain:+LastFound
			WinGet hwnd1,ID

			WinGetPosEx(hwnd1,xn1,yn1,wn1,hn1,Offset_X1,Offset_Y1)
			;WinGetPos,xn1,yn1,wn1,hn1,A
			hn1 := hn1 - 129
			xn1 := xn1 + Offset_X1


			n1 := xn1 + Offset_X1hn1 := Min(Round(A_ScreenHeight * 0.9),hn1)
			wn1 := Min(Round(A_ScreenWidth * 0.9),wn1)
			
			yn1 := Min(Round(A_ScreenHeight - hn1),yn1)
			xn1 := Min(Round(A_ScreenWidth - wn1),xn1)
		
			if (xOld != xn1 || yOld != yn1 || wOld != wn1 || hOld != hn1){
				;Tiptop(hn1 . "/" . hOld . "/" . Offset_X1)			
				xOld := xn1
				yOld := yn1
				wOld := wn1
				hOld := hn1
				
				IniWrite, %xn1% , %iniFile%, config, windowPosX
				IniWrite, %yn1%, %iniFile%, config, windowPosY
				
				IniWrite, %wn1% , %iniFile%, config, windowWidth
				IniWrite, %hn1%, %iniFile%, config, windowHeight
				;Tiptop("Coords saved!")
			}
		}
	}
		
	return
}	
;******************************** LVCommands ********************************
LVCommands(){
	if (A_GuiEvent = "Normal"){
		runInDir(A_EventInfo) 
	}

	return
}
; *********************************** runInDir ******************************
runInDir(lineNumber) {
	global directoriesFile
	global directoriesArr
	global toolsArr
	global hintTimeShort
	global hintTimeMedium
	global hintTime
	global hintTimeLong
	global paramMaxCountDefault
	global paramMaxCount

	directorieEntryArr := []

	if (lineNumber != 0){
		ks := getKeyboardState()
		switch ks
		{
		case 0:
			; no additional key pressed
			paramMaxCount := paramMaxCountDefault
			runInDirDefault(lineNumber,0)
			tipTopClose()
			
		case 1:
			;*** capslock ***
			keywait, Control
			
		case 2:
			;*** Alt ***
			showHint("Run entry 2 only!", hintTimeShort)
			runInDirDefault(lineNumber,2)
			tipTopClose()			
		case 4:
			;*** Ctrl ***
			showHint("Run entry 1 only!", hintTimeShort)
			runInDirDefault(lineNumber,1)
			tipTopClose()
		case 12:
			;*** Ctrl + shift***
			showHint("Run entry 3 only!", hintTimeShort)
			runInDirDefault(lineNumber,3)
			tipTopClose()
		case 10:
			;*** Alt + shift***
			showHint("Run entry 4 only!", hintTimeShort)
			runInDirDefault(lineNumber,4)
			tipTopClose()
		case 8:
			;*** Shift = edit ***
			s := directoriesArr[lineNumber]
			
			setTimer,unselect,-100
			InputBox,inp,Edit command,,,,100,,,,,%s%
			
			if (ErrorLevel){
				showHint("Canceled!",2000)
				prepare()
				return
			} else {
				;save new command
				directoriesArr[lineNumber] := inp
				
				content := ""
				
				l := directoriesArr.Length()
				
				Loop, % l
				{
					content := content . directoriesArr[A_Index] . "`n"
				}

				FileDelete, %directoriesFile%
				FileAppend, %content%, %directoriesFile%, UTF-8-RAW
			
				showWindow()
				refreshGui()
			}

		}
	}
	return
}
;********************************* unselect *********************************
unselect(){
	sendinput {left}
}
;****************************** runInDirDefault ******************************
runInDirDefault(i,useonly){
	global directoriesFile
	global directoriesArr
	global toolsArr
	global hintTimeShort
	global hintTimeMedium
	global hintTime
	global hintTimeLong

	directorieEntryArr := StrSplit(directoriesArr[i],",")
	
	;first is name now!
	path := cvtPath(directorieEntryArr[2],"")
		
	commandsMax := 0

	if (useonly == 0)
		commandsMax := directorieEntryArr.Length() - 2
	else
		commandsMax := 1

	Loop, %commandsMax%
	{
		index := A_Index
		
		if (useonly == 1)
			index := 1
			
		if (useonly == 2)
			index := 2
			
		if (useonly == 3)
			index := 3
			
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
		
		command := directorieEntryArr[index + 2]

		if (command != ""){
			if (InStr(command,"#")){
				nameArr := StrSplit(command,"#")
				command := nameArr[1]
				parameter1 := extractToSend(StrReplace(cvtPath(nameArr[2], path),"^",","),toSend1, delay1)
				parameter2 := extractToSend(StrReplace(cvtPath(nameArr[3], path),"^",","),toSend2, delay2)
				parameter3 := extractToSend(StrReplace(cvtPath(nameArr[4], path),"^",","),toSend3, delay3)
				parameter4 := extractToSend(StrReplace(cvtPath(nameArr[5], path),"^",","),toSend4, delay4)
				parameter5 := extractToSend(StrReplace(cvtPath(nameArr[6], path),"^",","),toSend5, delay5)
				parameter6 := extractToSend(StrReplace(cvtPath(nameArr[7], path),"^",","),toSend6, delay6)
			}
			tool := cvtPath(toolsArr[command],"")

			if (tool != ""){
				toRun := trim(tool . " " . parameter1 . parameter2 . parameter3 . parameter4 . parameter5 . parameter6)
			} else {
			
				c:= StrLower(command)
				switch c
				{
					case "shell":
						s := ""
						Loop, 6
						{
							i := parameter%index%
							if (i != ""){
								s := s . i . "`n"
							}
						}
						openShell(s)
						
					case "showmessage":
						t := Max(delay1,1000)
						showHint(toSend1, t)

					default:
						msgbox, ERROR tool not found and no internal command!
				}
			}
			
			if (toRun != ""){
				Run, %toRun%,%path%,max
				sleep, 3000
				
				if (checkOperation() == 999)
					return

				if (toSend1 != ""){
					SendInput %toSend1%
					if (delay1 == 0){
						sleepUntilCtrlPressed()
					} else {
						sleep, %delay1%
					}
				}
				if (checkOperation() == 999)
					return
				
				if (toSend2 != ""){
					SendInput %toSend2%
					if (delay2 == 0){
						sleepUntilCtrlPressed()
					} else {
						sleep, %delay2%
					}
				}
				if (checkOperation() == 999)
					return
				
				if (toSend3 != ""){
					SendInput %toSend3%
					if (delay3 == 0){
						sleepUntilCtrlPressed()
					} else {
						sleep, %delay3%
					}
				}
				if (checkOperation() == 999)
					return
				
				if (toSend4 != ""){
					SendInput %toSend4%
					if (delay4 == 0){
						sleepUntilCtrlPressed()
					} else {
						sleep, %delay4%
					}
				}
				if (checkOperation() == 999)
					return
				
				if (toSend5 != ""){
					SendInput %toSend5%
					if (delay5 == 0){
						sleepUntilCtrlPressed()
					} else {
						sleep, %delay5%
					}
				}
				if (checkOperation() == 999)
					return
				
				if (toSend6 != ""){
					SendInput %toSend6%
					if (delay6 == 0){
						sleepUntilCtrlPressed()
					} else {
						sleep, %delay6%
					}
				}
				
				if (checkOperation() == 999)
					return
			}
			
			;reload
		}
	}
	
	hideWindow()
	
	return
}
;****************************** checkOperation ******************************
checkOperation(){
	global hintTimeShort
	global hintTimeMedium
	global hintTime
	global hintTimeLong
	
	ret := 0
	
	if (getKeyboardState() == 1){
	
		checkOperationLoop:
		Loop
		{
			tipTop("CAPSLOCK active, holdon operation, release CAPSLOCK to continue or press [Ctrl]-key to abort operation!")
			
			if (getKeyboardState() == 5){
				tipTop("Operation aborted!")
				showHint("Operation aborted!", hintTime)
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
;******************************* extactToSend *******************************
extractToSend(sIn,ByRef sOut, ByRef delayOut){
	r := sIn
	d := 0
	if (InStr(sIn,"~")){
		sArr := StrSplit(sIn,"~")
		sOut := cvtPath(sArr[1], "")
		
		if (sArr[2] != ""){
			delayOut := (0 + sArr[2]) * 1000
			r := ""
		}
	}
		
	return r
}
;*************************** sleepUntilCtrlPressed ***************************
sleepUntilCtrlPressed(){
	global app

	tipTopEternal("[" . app . "] Waiting: If operation has finished, please press [Ctrl]-key to continue!")
	
	KeyWait, Control, D
	sleep,1000
	
	return
}
;******************************** ShowHistory ********************************
ShowHistory(){
	KeyHistory
	
	return
}
;****************************** openGithubPage ******************************
openGithubPage(){
	global appName
	
	StringLower, name, appName
	Run https://github.com/jvr-ks/%name%
	return
}

			
; *********************************** editDirectoriesFile ******************************
editDirectoriesFile() {
	global directoriesFile
	global notepadpath
	
	f := notepadpath . " " . directoriesFile
	showMessage("Please close the editor to refresh the menu!")
	runWait %f%,,max
	removeMessage()
	
	showWindow()
	refreshGui()

	return
}
; *********************************** editToolsFile ******************************
editToolsFile() {
	global toolsFile
	global notepadpath
	
	f := notepadpath . " " . toolsFile

	showMessage("Please close the editor to refresh the menu!")
	runWait %f%,,max
	removeMessage()
	
	showWindow()
	refreshGui()

	return
}
; *********************************** editIniFile ******************************
editIniFile() {
	global iniFile
	global notepadpath
	
	f := notepadpath . " " . iniFile
	showMessage("Please close the editor to refresh the menu!")
	runWait %f%,,max
	removeMessage()
	
	showWindow()
	refreshGui()

	return
}
; *********************************** editShortcutsFile ******************************
editShortcutsFile() {
	global shortcutsFile
	global notepadpath
	
	f := notepadpath . " " . shortcutsFile
	showMessage("Please close the editor to refresh the menu!")
	runWait %f%,,max
	removeMessage()
	
	showWindow()
	refreshGui()

	return
}
;---------------------------- editFastSwitchFile ----------------------------
editFastSwitchFile() {
	global fastSwitchFile
	global notepadpath
	
	f := notepadpath . " " . fastSwitchFile
	showMessage("Please close the editor to refresh the menu!")
	runWait %f%,,max
	removeMessage()
	
	showWindow()
	refreshGui()

	return
}
; *********************************** ret ******************************
ret() {
	return
}

; *********************************** hkToDescription ******************************
; in Lib
; *********************************** hotkeyToText ******************************
; in Lib

; *********************************** getKeyboardState ******************************
getKeyboardState(){
	r := 0
	if (getkeystate("Capslock","T")=1)
		r := 1
		
	if (getkeystate("Alt","P")=1)
		r := 2
		
	if (getkeystate("Ctrl","P")=1)
		r:= 4
		
	if (getkeystate("Shift","P")=1)
		r:= 8	

	return r
}
; *********************************** eq ******************************
eq(a, b) {
	if (InStr(a, b) && InStr(b, a))
		return 1

	return 0
}
; *********************************** cvtPath ******************************
cvtPath(s, path){
	; handles "\..." as path repetition also
	
	r := s
	pos := 0

	While pos := RegExMatch(r,"O)(\[\.\.\.\])", match, pos+1){
		r := RegExReplace(r, "\" . match.1, path, , 1, pos)
	}
	
	While pos := RegExMatch(r,"O)(\[.*?\])", match, pos+1){
		r := RegExReplace(r, "\" . match.1, shortcut(match.1, path), , 1, pos)
	}

	While pos := RegExMatch(r,"O)(%.+?%)", match, pos+1){
		r := RegExReplace(r, match.1, envVariConvert(match.1), , 1, pos)
	}
	return r
}
; *********************************** envVariConvert ******************************
envVariConvert(s){
	r := s
	if (InStr(s,"%")){
		s := StrReplace(s,"`%","")
		EnvGet, v, %s%
		Transform, r, Deref, %v%
	}

	return r
}
; *********************************** shortcut ******************************
shortcut(s, path){
	global shortcutsArr
	
	r := s

	sc := cvtPath(shortcutsArr[r], path)
	if (sc != "")
		r := sc

	return r
}
;******************************* readGuiParam *******************************
readGuiParam(){
	global iniFile
	global fontDefault
	global font
	global fontsizeDefault
	global fontsize
	global windowPosX
	global windowPosY
	global windowWidth
	global windowHeight
	global windowPosFixed
	
	IniRead, windowPosFixed, %iniFile%, config, windowPosFixed, 0
	
	IniRead, windowPosX, %iniFile%, config, windowPosX, 0

	windowWidthDefault := A_ScreenWidth - Round(A_ScreenWidth/8)
	IniRead, windowWidth, %iniFile%, config, windowWidth, %windowWidthDefault%
	if (windowWidth == 0)
		windowWidth := windowWidthDefault
		
	IniRead, windowPosY, %iniFile%, config, windowPosY, 0

	windowHeightDefault := A_ScreenHeight - Round(A_ScreenHeight/8)
	IniRead, windowHeight, %iniFile%, config, windowHeight, %windowHeightDefault%
	if (windowHeight < 0)
		windowHeight := windowHeightDefault
	
	IniRead, font, %iniFile%, config, font, %fontDefault%
	IniRead, fontsize, %iniFile%, config, fontsize, %fontsizeDefault%

	return
}
;******************************* fixWindowPos *******************************
fixWindowPos(){
	global windowPosFixed
	global iniFile
	
	if (!windowPosFixed){
		windowPosFixed := true
		IniWrite, %windowPosFixed% , %iniFile%, config, windowPosFixed
		Menu, MainMenuWindow, Check, Fix Pos/Size
	} else {
		windowPosFixed := false
		IniWrite, %windowPosFixed% , %iniFile%, config, windowPosFixed
		Menu, MainMenuWindow, Uncheck, Fix Pos/Size	
	}
}
;*************************** guiMainGuiContextMenu ***************************
guiMainGuiContextMenu(GuiHwnd, CtrlHwnd, EventInfo, IsRightClick, X, Y){
	isr := IsRightClick ? "yes" : "no"
	msgBox, 
	(
	A contextmenu is not defined at the moment!
	Parameters are
	GuiHwnd: %GuiHwnd%
	CtrlHwnd: %CtrlHwnd%
	EventInfo: %EventInfo%
	IsRightClick: %isr%
	X: %X%
	Y: %Y%
	)

	return
}
;-------------------------------- openNotepad --------------------------------
openNotepad(){
	title := "Notepad++"
	if WinExist(title){
	  winActivate,%title%
	}
	
	return
}
;--------------------------------- openDopus ---------------------------------
openDopus(){
	title := "ahk_exe dopus.exe"
	if WinExist(title){
	  winActivate,%title%
	}
	
	return
}	
; *********************************** exit ******************************
exit() {
	global app
	
	showHint("""" . app . """ removed from memory!", 1500)
	ExitApp
}
; ***********************************
