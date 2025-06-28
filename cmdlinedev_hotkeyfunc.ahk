; cmdlinedev_hotkeyfunc.ahk
; part of cmdlinedev

;----------------------------- fastSwitchSelect -----------------------------
fastSwitchSelect(){
  global fastSwitchHotkeysArr

  title := fastSwitchHotkeysArr[A_ThisHotkey]
  if WinExist(title){
    winActivate,%title%
  }
}
;----------------------------------- cycle -----------------------------------
;deprecated!
cycle(){
  global mainHWND, fastSwitchCycleArr, fastSwitchCyclePointer, fastSwitchHotkeysArr

  global fastSwitchCycleGroup2, fastSwitchCycleGroup3, fastSwitchCycleGroup4, fastSwitchCycleGroup5, fastSwitchCycleGroup6, fastSwitchCycleGroup7, fastSwitchCycleGroup8, fastSwitchCycleGroup9
  global fastSwitchCycleGroupSelected, fastSwitchCycleGroupSelectedMax

  gui, guiMain:Submit, NoHide

  if (!getkeystate("Capslock","T")){
  
    if (fastSwitchCycleGroupSelected > 1){
        selectedGroup := fastSwitchCycleGroup%fastSwitchCycleGroupSelected%
        if (selectedGroup != "-"){
          fastSwitchCycleArr := StrSplit(selectedGroup,",")
          
          s := fastSwitchCycleArr[fastSwitchCyclePointer]

          title := fastSwitchHotkeysArr[s]
          if WinActive(title){ ; already open? -> select next
            fastSwitchCyclePointer := fastSwitchCyclePointer + 1
            if (fastSwitchCyclePointer > fastSwitchCycleArr.Length())
              fastSwitchCyclePointer := 1
              
            s := fastSwitchCycleArr[fastSwitchCyclePointer]
            title := fastSwitchHotkeysArr[s]
          }
         
          if WinExist(title){
            winActivate,%title%
            winWait,%title%,,10
          } else {
            showHintColored(mainHWND, "Window " . title . " not found!",3000,"cFF0000","c00FF00")
          }
        
          fastSwitchCyclePointer := fastSwitchCyclePointer + 1
          if (fastSwitchCyclePointer > fastSwitchCycleArr.Length())
            fastSwitchCyclePointer := 1

        }
     } 
   } else {
       send {Control down}{Alt down}{Tab}{Alt up}{Control up}
   }
}

























