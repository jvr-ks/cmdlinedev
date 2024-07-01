; cmdlinedev_helper.ahk
; part of cmdlinedev


;---------------------------------- cvtPath ----------------------------------
cvtPath(s){
  global pathSelected
  
  ; handles "[...]" as path repetition
  ; handles [shortcut] ...
  ; handles %enviroment variable%
  ; replaces "°" with "#" (URL relativ address)
  
  r := s
  
  pos := 0

  if(pathSelected != "")
    r := StrReplace(r, "[...]", pathSelected)
  
  While pos := RegExMatch(r,"O)(\[.*?\])", match, pos+1){
    r := RegExReplace(r, "\" . match.1, shortcut(match.1), , 1, pos)
  }

  While pos := RegExMatch(r,"O)(%.+?%)", match, pos+1){
    r := RegExReplace(r, match.1, envVariConvert(match.1), , 1, pos)
  }

  r := StrReplace(r, "°", "#")
  
  return r
}
;--------------------------------- shortcut ---------------------------------
shortcut(s){
  global shortcutsArr
  
  r := s
  
  if (shortcutsArr.haskey(s)){
    r := shortcutsArr[s]
  }

  return r
}
;------------------------------ envVariConvert ------------------------------
envVariConvert(s){
  r := s
  if (InStr(s,"%")){
    s := StrReplace(s,"`%","")
    EnvGet, v, %s%
    Transform, r, Deref, %v%
  }

  return r
}
;-------------------------------- resolvePath --------------------------------
resolvePath(p){
  global wrkdir

  r := p
  if (!InStr(p, ":"))
    r := wrkdir . p

  return r
}
;------------------------------ insertDateTime ------------------------------
insertDateTime(s){
  entriesArray := StrSplit(s,",")
  
  FormatTime, start , 20240201165400,yyyyMMddHHmmss
  FormatTime, now ,,yyyyMMddHHmmss
  t := now - start
  
  entriesArray[2] := round(t / 10) ; 10 seconds resolution
  
  s := ""
  for k, v in entriesArray {
    s .= v . ","
  }
  s := SubStr(s, 1, -1) ; remove colon
  
  return s
}
;------------------------------------ eq ------------------------------------
eq(a, b) {
  if (InStr(a, b) && InStr(b, a))
    return 1
  return 0
}
;--------------------------------- StrLower ---------------------------------
StrLower(s){
  r := ""
  StringLower, r, s
  
  return r
}
;---------------------------------- tipTop ----------------------------------
tipTop(msg, n := 1, t := 4000){

  s := StrReplace(msg,"^",",")
  
  toolX := Floor(A_ScreenWidth / 2)
  toolY := 2

  CoordMode,ToolTip,Screen
  
  toolTip,%s%, toolX, toolY, n
  
  WinGetPos, X,Y,W,H, ahk_class tooltips_class32

  toolX := (A_ScreenWidth / 2) - W / 2
  
  toolTip,%s%, toolX, toolY, n
  
  SetTimer, tipTopCloseAll, delete
  if (t > 0){
    SetTimer, tipTopCloseAll, -%t%
  }
 }
;-------------------------------- tipTopCloseAll --------------------------------
tipTopCloseAll(){
  
  Loop, 20
  {
    ToolTip,,,,%A_Index%
  }
}
;----------------------------- checkUpdate -----------------------------
checkUpdate(){
  global mainHWND, appname, appnameLower, localVersionFile, updateServer

  localVersion := getLocalVersion(localVersionFile)

  remoteVersion := getVersionFromGithubServer(updateServer . localVersionFile)

  if (remoteVersion != "unknown!" && remoteVersion != "error!"){
    if (remoteVersion > localVersion){
      msg1 := "New version available: (" . localVersion . " -> " . remoteVersion . ")`, please use the Updater (updater.exe) to update " . appname . "!"
      showHintColored(mainHWND, msg1)
      
    } else {
      msg2 := "No new version is available!"
      showHintColored(mainHWND, msg2)
    }
  } else {
    msg := "Update-check failed: (" . localVersion . " -> " . remoteVersion . ")"
    showHintColored(mainHWND, msg)
  }
}
;------------------------------ getLocalVersion ------------------------------
getLocalVersion(file){
  
  versionLocal := 0.000
  if (FileExist(file) != ""){
    file := FileOpen(file, "r `n")
    versionLocal := file.Read()
    file.Close()
  }

  return versionLocal
}
;------------------------ getVersionFromGithubServer ------------------------
getVersionFromGithubServer(url){

  ret := "unknown!"

  whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
  Try
  { 
    whr.Open("GET", url)
    whr.Send()
    status := whr.Status
    if (status == 200){
     ret := whr.ResponseText
    } else {
      msgArr := {}
      msgArr.push("Error while reading actual app version!")
      msgArr.push("Connection to:")
      msgArr.push(url)
      msgArr.push("failed!")
      msgArr.push(" URL -> clipboard")
      msgArr.push("Closing Updater due to an error!")
    
      errorExit(msgArr, url)
    }
  }
  catch e
  {
    ret := "error!"
  }

  return ret
}
;----------------------------- getKeyboardState -----------------------------
getKeyboardState(){
  r := 0
  if (getkeystate("Capslock","T"))
    r := r + 1
    
  if (getkeystate("Alt","P"))
    r := r + 2
    
  if (getkeystate("Ctrl","P"))
    r:= r + 4
    
  if (getkeystate("Shift","P"))
    r:= r + 8
    
  if (getkeystate("LWin","P"))
    r:= r + 16
    
  if (getkeystate("RWin","P"))
    r:= r + 16

  return r
}
;--------------------------------- openShell ---------------------------------
openShell(commands) {
  shell := ComObjCreate("WScript.Shell")
  exec := shell.Exec(ComSpec " /Q /K echo off")
  exec.StdIn.WriteLine(commands "`nexit") 
  r := exec.StdOut.ReadAll()
  msgbox, %r%
 }
;--------------------------- GetProcessMemoryUsage ---------------------------
GetProcessMemoryUsage() {
    PID := DllCall("GetCurrentProcessId")
    size := 440
    VarSetCapacity(pmcex,size,0)
    ret := ""
    
    hProcess := DllCall( "OpenProcess", UInt,0x400|0x0010,Int,0,Ptr,PID, Ptr )
    if (hProcess)
    {
        if (DllCall("psapi.dll\GetProcessMemoryInfo", Ptr, hProcess, Ptr, &pmcex, UInt,size))
            ret := Round(NumGet(pmcex, (A_PtrSize=8 ? "16" : "12"), "UInt") / 1024**2, 2)
        DllCall("CloseHandle", Ptr, hProcess)
    }
    return % ret
}
;-------------------------------- wrkPath --------------------------------
wrkPath(p){
  global wrkdir
  
  r := wrkdir . p
    
  return r
}
;------------------------------- pathToAbsolut -------------------------------
pathToAbsolut(p){
  
  r := p
  if (!InStr(p, ":"))
    r := wrkPath(p)
    
  if (SubStr(r,0,1) != "\")
    r .= "\"
    
  return r
}
;--------------------------------- WinCenter ---------------------------------
; from: https://www.autohotkey.com/board/topic/92757-win-center/
WinCenter(mainHWND, hChild, Visible := 1) {
  WinGetPos, X, Y, W, H, ahk_ID %mainHWND%
  WinGetPos, _X, _Y, _W, _H, ahk_ID %hChild%
  If Visible {
      SysGet, MWA, MonitorWorkArea, % WinMonitor(mainHWND)
      X := X+(W-_W)//2, X := X < MWALeft ? MWALeft+5 : X, X := (X + _W) > MWARight ? MWARight-_W-5 : X
      Y := Y+(H-_H)//2, Y := Y < MWATop ? MWATop+5 : Y, Y := (Y + _H) > MWABottom ? MWABottom-_H-5 : Y
  } Else X := X+(W-_W)//2, Y := Y+(H-_H)//2
  WinMove, ahk_ID %hChild%,, %X%, %Y%
  WinShow, ahk_ID %hChild%
}
;-------------------------------- WinMonitor --------------------------------
WinMonitor(hwnd, Center := 1) {
    SysGet, MonitorCount, 80
    WinGetPos, X, Y, W, H, ahk_ID %hwnd%
    Center ? (X := X+(W//2), Y := Y+(H//2))
    loop %MonitorCount% {
      SysGet, Mon, Monitor, %A_Index%
      if (X >= MonLeft && X <= MonRight && Y >= MonTop && Y <= MonBottom)
          Return A_Index
    }
}
;-------------------------- openAutostartFolderUser --------------------------
openAutostartFolderUser(){
  run, shell:startup
}
;------------------------- openAutostartFolderAdmin -------------------------
openAutostartFolderAdmin(){
  run, explore C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
}
;-------------------------------- openGodMode --------------------------------
openGodMode(){
  run,shell:::{ED7BA470-8E54-465E-825C-99712043E01C}
 }
;----------------------------- sortShortcutsFile -----------------------------
sortShortcutsFile(){
  global shortcutsFile
  
  a := ReadTable(shortcutsFile)
  b := SortTable(a, "1")
  e := WriteTable(b, shortcutsFile)
  
  if (e)
    msgbox, Error (sorting) occured!
  else
    msgbox, Ok!
 }
;------------------------------- debugShowAll -------------------------------
debugShowAll(theObject1, theObject2){

  s := ""
  l := theObject1.Count()

  loop, %l%
  {
    s .= A_Index . " ::: " . theObject1[A_Index] . " ::: " . theObject2[A_Index] . "`n"
  }

  msgbox, %s%
}
;-------------------------------- iniReadSave --------------------------------
iniReadSave(name, section, defaultValue){
  global configFile
  
  r := ""
  IniRead, r, %configFile%, %section%, %name%, %defaultValue%
  if (r == "" || r == "ERROR")
    r := defaultValue
    
  return r
}
;----------------------------- coordsScreenToApp -----------------------------
coordsScreenToApp(n){
  global dpiCorrect
  
  r := 0
  if (dpiCorrect > 0)
    r := round(n / dpiCorrect)

  return r
}
;----------------------------- coordsAppToScreen -----------------------------
coordsAppToScreen(n){
  global dpiCorrect

  r := round(n * dpiCorrect)

  return r
}
;--------------------------------- unselect ---------------------------------
unselect(){
  sendinput {left}
}




;----------------------------------------------------------------------------































































































