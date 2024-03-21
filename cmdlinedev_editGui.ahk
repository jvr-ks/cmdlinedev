; cmdlinedev_editGui.ahk
; part of cmdlinedev


;-------------------------------- editGuiShow --------------------------------
editGuiShow(directoryEntryArr, linenumber){
  global hwndheditGui, directoriesFile, directoriesArr, forcedCancel, fontsize, emptyFiledSubstituteChar
  global paramMaxCount
  
  ; s := directoriesArr[lineNumber]
  ; msgbox, %s%
  
  ; directoryEntryArr := StrSplit(directoriesArr[lineNumber],",")
  ; entries: 1 Name, 2 Current, 3 path, 4 - 7 commands
  
  Gui, editGui:new, hwndheditGui +parentGuiMain +ownerGuiMain +0x80000000, Edit entry
  Gui, editGui:Font, s%fontsize%
  Gui, editGui:Add, Text, x2 y2 w100, Name
  Gui, editGui:Add, Edit, x+m section yp+0 w400 Vt1, % directoryEntryArr[1]
  Gui, editGui:Add, Text, x2, Current
  Gui, editGui:Add, Edit, xs yp+0 w400 Vt2, % directoryEntryArr[2]
  Gui, editGui:Add, Text, x2, Path
  Gui, editGui:Add, Edit, xs yp+0 w400 Vt3, % (directoryEntryArr[3] = emptyFiledSubstituteChar) ? "" : directoryEntryArr[3]
  Gui, editGui:Add, Text, x2, Cmd1
  Gui, editGui:Add, Edit, xs yp+0 w400 Vt4, % (directoryEntryArr[4] = emptyFiledSubstituteChar) ? "" : directoryEntryArr[4]
  Gui, editGui:Add, Text, x2, Cmd2
  Gui, editGui:Add, Edit, xs yp+0 w400 Vt5, % (directoryEntryArr[5] = emptyFiledSubstituteChar) ? "" : directoryEntryArr[5]
  Gui, editGui:Add, Text, x2, Cmd3
  Gui, editGui:Add, Edit, xs yp+0 w400 Vt6, % (directoryEntryArr[6] = emptyFiledSubstituteChar) ? "" : directoryEntryArr[6]
  Gui, editGui:Add, Text, x2, Cmd4
  Gui, editGui:Add, Edit, xs yp+0 w400 Vt7, % (directoryEntryArr[7] = emptyFiledSubstituteChar) ? "" : directoryEntryArr[7]
  Gui, editGui:Add, Button, GeditGuiButtonSave Default w80, Save
  Gui, editGui:Add, Button, GeditGuiButtonCancel w80 x+m yp+0, Cancel
  Gui, editGui:Show, center
  pause, On, 0
  
  if (!forcedCancel){
    gui, editGui:submit, nohide
    
    loop, %paramMaxCount% {
      if (t%A_Index% = ""){
        if (A_Index > 2){
          directoryEntryArr[A_Index] := emptyFiledSubstituteChar
        }
      } else {
        directoryEntryArr[A_Index] := t%A_Index%
      }
    }
    inp := ""
    for k,v in directoryEntryArr
      inp .= v . ","
    
    inp := SubStr(inp, 1, -1)  ; remove last colon
    ;save new command
    directoriesArr[lineNumber] := inp
    
    content := ""
    
    Loop, % directoriesArr.length() {
      content := content . directoriesArr[A_Index] . "`n"
    }
    
    FileDelete, %directoriesFile%
    FileAppend, %content%, %directoriesFile%, UTF-8
    
    Gui, editGui:Destroy
    
    Gui, guiMain:default

    showWindowRefreshed()
  } else {
    Gui, editGui:Destroy
    Gui, guiMain:default
    showWindow()
  }
}
;------------------------------ editGuiGuiClose ------------------------------
editGuiGuiClose(){
  global mainHWND, forcedCancel
  
  Gui, guiMain:default
  showHintColored(mainHWND, "Canceled!")
  forcedCancel := 1
  pause, Off, 0
}
;------------------------------ editGuiButtonSave ------------------------------
editGuiButtonSave(){
  global forcedCancel
  
  forcedCancel := 0
  pause, Off, 0
}
;---------------------------- editGuiButtonCancel ----------------------------
editGuiButtonCancel(){
  global forcedCancel
  
  forcedCancel := 1
  pause, Off, 0
}






















