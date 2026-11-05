; cmdlinedev_hintColored.ahk
; part of cmdlinedev

;------------------------------ showHintColored ------------------------------
showHintColored(handle, s := "", n := 3000, fg := "cFFFFFF", bg := "a900ff", newfont := "", newfontsize := "", style := "+0x80000000"){
  global mainHWND
  global font, fontsize
  
  if (newfont == "")
    newfont := font
    
  if (newfontsize == "")
    newfontsize := fontsize
  
  Gui, hintColored:new, hwndhHintColored -Caption +ToolWindow +AlwaysOnTop +parentGuiMain +ownerGuiMain %style%
  Gui, hintColored:Font, s%newfontsize%, %newfont%
  Gui, hintColored:Font, c%fg%
  Gui, hintColored:Color, %bg%
  Gui, hintColored:Add, Text,, %s%
  Gui, hintColored:Show, autosize
  WinCenter(mainHWND, hHintColored, 1)
  if (n > 0){
    ; delay the subsequent operations
    settimer, destroyHintColored, -%n%
    sleep, %n%
  } else {
    if (n != 0) ; don't destroy if n = 0
      ; don't delay the subsequent operations
      settimer, destroyHintColored, %n%
  }
}
;---------------------------- destroyHintColored ----------------------------
destroyHintColored(){
  Gui, hintColored:Destroy
}
;-------------------------------- showHintAdd --------------------------------
showHintAdd(s, n := 2000){
  global font
  global fontsize
  
  static sIs := ""
  
  setTimer, showHintAddDestroy, delete
  if (s == ""){
    sIs := ""
    rows := 1
    Gui, hintAdd:Destroy
  } else {
    sIs .= s

    Gui, hintAdd:Destroy
    Gui, hintAdd:Font, %fontsize%, %font%
    Gui, hintAdd:Add, Text,, %sIs%
    Gui, hintAdd:-Caption
    Gui, hintAdd:+ToolWindow
    Gui, hintAdd:+AlwaysOnTop
    Gui, hintAdd:Show, autosize
    
    sIs .= "`n"
    t := -1 * n
    setTimer, showHintAddDestroy, %t%
  }
 }
;----------------------------- showHintAddReset -----------------------------
showHintAddReset(){

  showHintAdd("",0)
}
;---------------------------- showHintAddDestroy ----------------------------
showHintAddDestroy(){

  setTimer, showHintAddDestroy, delete
  Gui, hintAdd:Destroy
}
;----------------------------------------------------------------------------






















