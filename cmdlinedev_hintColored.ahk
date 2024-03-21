; cmdlinedev_hintColored.ahk
; part of cmdlinedev

;------------------------------ showHintColored ------------------------------
showHintColored(handle, s := "", n := 3000, fg := "cFFFFFF", bg := "a900ff", newfont := "", newfontsize := ""){
  global mainHWND
  global font, fontsize
  
  if (newfont == "")
    newfont := font
    
  if (newfontsize == "")
    newfontsize := fontsize
  
  Gui, hintColored:new, hwndhHintColored +parentGuiMain +ownerGuiMain +0x80000000
  Gui, hintColored:Font, s%newfontsize%, %newfont%
  Gui, hintColored:Font, c%fg%
  Gui, hintColored:Color, %bg%
  Gui, hintColored:Add, Text,, %s%
  Gui, hintColored:-Caption
  Gui, hintColored:+ToolWindow
  Gui, hintColored:+AlwaysOnTop
  Gui, hintColored:Show
  WinCenter(mainHWND, hHintColored, 1)
  if (n > 0){
    Sleep, n
    Gui, hintColored:Destroy
  }
}
;-------------------------------- showHintAdd --------------------------------
showHintAdd(s,n := 2000){
  global font
  global fontsize
  
  static sIs := ""
  
  if (s == ""){
    sIs := ""
    rows := 1
    setTimer,showHintAddDestroy, delete
    Gui, hintAdd:Destroy
  } else {
    setTimer,showHintAddDestroy, delete
    sIs .= s

    Gui, hintAdd:Destroy
    Gui, hintAdd:Font, %fontsize%, %font%
    Gui, hintAdd:Add, Text,, %sIs%
    Gui, hintAdd:-Caption
    Gui, hintAdd:+ToolWindow
    Gui, hintAdd:+AlwaysOnTop
    Gui, hintAdd:Show,autosize
    
    sIs .= "`n"
    t := -1 * n
    setTimer,showHintAddDestroy, %t%
  }
 }
;----------------------------- showHintAddReset -----------------------------
showHintAddReset(){

  showHintAdd("",0)
}
;---------------------------- showHintAddDestroy ----------------------------
showHintAddDestroy(){

  setTimer,showHintAddDestroy, delete
  Gui, hintAdd:Destroy
}



















