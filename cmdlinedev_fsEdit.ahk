; cmdlinedev_fsEdit.ahk
; part of cmdlinedev

;---------------------------------- fsEdit ----------------------------------
fsEdit(){
  global mainHWND, fsWindowsFile, windowsTitleArr, LV2
  global windowsEditKeyArr, windowsEditValueArr, fsEditErrorText, hFsEdit, showPermanent

  windowsTitleArr := {}

  windowsEditKeyArr := []
  windowsEditValueArr := [] 
  
  ; keep guimain open!
  setTimer, checkFocus, delete
  
  Gui, fsEdit:Destroy
  Gui, fsEdit:New, hwndhFsEdit +LastFound +OwnDialogs +parentGuiMain +ownerGuiMain,Edit
  Gui, fsEdit:Default
  
  Gui, Margin, 20, 20
  Gui, +MinSize200x200 +Resize
  
  Menu, fsEditMenu, DeleteAll
  
  up := A_IsUnicode ? Chr(08593) : "+"
  down := A_IsUnicode ? Chr(08595) : "-"
  Menu, fsEditMenu,Add,%up% up,fsEditListDec
  Menu, fsEditMenu,Add,%down% down,fsEditListInc
    
  Menu, fsEditMenu,Add,DeActivate,fsEditListTmpDeActivate
  Menu, fsEditMenu,Add,Activate,fsEditListTmpActivate
  Menu, fsEditMenu,Add,DeActivate (permanent),fsEditListPermaDeActivate
  Menu, fsEditMenu,Add,Show/hide perm. deActivated,showPermanentToggle
  Menu, fsEditMenu,Add,Close,fsEditListClose

  Gui, fsEdit:Menu, fsEditMenu
  
  Gui, fsEdit:Add, ListView,x5 r20 w600 gfsEditListViewClick vLV2 hwndhLV2 NoSortHdr Grid AltSubmit, Order|Class|Title
  
  Gui, fsEdit:Add, Text, x5 w580 cFF0000 vfsEditErrorText

  index := 1
  Loop, read, %fsWindowsFile%
  {
    rl := trim(A_LoopReadLine)
    if (rl != "") {
      data := Strsplit(rl,"|--|") ; separator is: "|--|"
      if (data.Length() > 0){
        key := data[2] ; title + class
        kv := StrSplit(key,"|~~|")
        theTitle := kv[1]
        theClass := kv[2]
        order := RegExReplace(data[1],"(\d+)","$1")
        windowsTitleArr[key] := 0 + order ; "0" or "1,2 ..., n"
        windowsEditKeyArr[index] := order
        windowsEditValueArr[index] := key

        ; first show all to get column size
        LV_Add("", Format("{:02}", order), theClass, theTitle)
        index += 1
      }
    }
  }
  
  setTimer,checkFocus1,3000
  
  Gui, fsEdit:show, Autosize
  
  LV_ModifyCol()
  LV_ModifyCol(1,"AutoHdr Integer")
  LV_ModifyCol(2,"AutoHdr Text")
  LV_ModifyCol(3,"AutoHdr Text")
  
  WinCenter(mainHWND, hFsEdit, Visible := 1)
 }
;----------------------------- fsEditListRefresh -----------------------------
fsEditListRefresh(){
  global fsWindowsFile, windowsTitleArr, windowsEditKeyArr, windowsEditValueArr, showPermanent
  
  index := 1
  Loop, read, %fsWindowsFile%
  {
    rl := trim(A_LoopReadLine)
    if (rl != "") {
      data := Strsplit(rl,"|--|") ; separator is: "|--|"
      if (data.Length() > 0){
        key := data[2] ; title + class
        kv := StrSplit(key,"|~~|")
        theTitle := kv[1]
        theClass := kv[2]
        order := RegExReplace(data[1],"(\d+)","$1")
        windowsTitleArr[key] := 0 + order ; "0" or "1,2 ..., n"
        windowsEditKeyArr[index] := order
        windowsEditValueArr[index] := key

        if(showPermanent){
          LV_Modify(index,Format("{:02}", index), order,theClass, theTitle)
          ;LV_Add("", order, theClass, theTitle)
        } else {
          if((0 + order) != 0){
            ;LV_Add("", order, theClass, theTitle)
            LV_Modify(index,Format("{:02}", index), order,theClass, theTitle)
          } else {
            LV_Modify(index,"", "", "", "")
          }
        }
        index += 1
      }
    }
  }
}
;-------------------------------- fsEditFile --------------------------------
fsEditFile() {
  global fsWindowsFile, notepadppPath, appName, bitName
  
  f := notepadppPath . " " . fsWindowsFile
  closeMessage()
  setTimer, checkFocus, Delete
  runWait %f%,,max
  msgbox, If content was changed via an external editor`,`nplease press the "OK"-button to reload!
  closeMessageRemove()
  showWindow()

  fsRead()
  
  FSACTextRemove()
 }
;------------------------------ FSACTextRemove ------------------------------
FSACTextRemove(){
  global FSACText
  
  GuiControl,guiMain:, FSACText
}
;------------------------------- fsArrangeManual -------------------------------
fsArrangeManual(){
  global FSACText
  
  fsRead()
  fsArrange()
  fsCycle(true) ; reset
  GuiControl,guiMain:, FSACText, All entries arranged!
  setTimer,FSACTextRemove,-3000
 }
;---------------------------------- fsArrange ----------------------------------
fsArrange(){
  global fsWindowsFile, windowsTitleArr

  tmp := []
  sortArr := []
  
  ; sort
  for key, value in windowsTitleArr
  {
    order := 0 + value

    if (value != "" && key != "" && order != 0){
    
      findNewKeyLoop:
      Loop
      {
        if (!tmp.HasKey(order)){
          sortArr[order] := key
          break findNewKeyLoop
        } else {
          order += 1
        }
      }
    }
  }
  
  ; generate output part 1, re-index, < 100
  index := 1
  for key, value in sortArr
  {
    order := 0 + key
    ;tmp[index] := key . "|--|" .  value
    if(order < 100){
      tmp[index] := index . "|--|" .  value
      index += 1
    }
  }

  index += 1 ; add a blank line
  
  ; generate output part 2, re-index, >= 100
  index100 := 100
  for key, value in sortArr
  {
    order := 0 + key
    ;tmp[index] := key . "|--|" .  value
    if(order >= 100){
      tmp[index] := index100 . "|--|" .  value
      index += 1
      index100 += 1
    }
  }

  index += 1 ; add a blank line
  
  ; generate output part 3
  ; put "zero" entries at the end
  for key, value in windowsTitleArr
  {
    order := 0 + value

    if (key != "|~~|" && order == 0){
      tmp[index] := value . "|--|" . key 
      index += 1
    }   
  }

  FileDelete, %fsWindowsFile%
  sleep,1000
  
  Loop % tmp.Length()
  {
    s := tmp[A_index]
    FileAppend, %s%`n, %fsWindowsFile%, UTF-8
  }
  
  fsCycle(true) ; reset
}
;---------------------------------- fsSave1 ----------------------------------
fsSave1(){
  
  index := 1
  FileCopy, cldwindows.txt, _cldwindows%index%.txt,1
  fsSaveOk(index)
 }
;---------------------------------- fsSave2 ----------------------------------
fsSave2(){
  
  index := 2
  FileCopy, cldwindows.txt, _cldwindows%index%.txt,1
  fsSaveOk(index)
}
;---------------------------------- fsSave3 ----------------------------------
fsSave3(){
  
  index := 3
  FileCopy, cldwindows.txt, _cldwindows%index%.txt,1
  fsSaveOk(index)
}
;---------------------------------- fsRead1 ----------------------------------
fsRead1(){
  
  index := 1
  FileCopy, _cldwindows%index%.txt, cldwindows.txt,1
  fsReadOk(index)
}
;---------------------------------- fsRead2 ----------------------------------
fsRead2(){
  
  index := 2
  FileCopy, _cldwindows%index%.txt, cldwindows.txt,1
  fsReadOk(index)
}
;---------------------------------- fsRead3 ----------------------------------
fsRead3(){
  
  index := 3
  FileCopy, _cldwindows%index%.txt, cldwindows.txt,1
  fsReadOk(index)
}
;--------------------------------- fsSaveOk ---------------------------------
fsSaveOk(index){

  GuiControl,guiMain:, FSACTextGreen, Saved set %index%!
  setTimer,FSACTextRemove,-3000
 }
;--------------------------------- fsReadOk ---------------------------------
fsReadOk(index){

  GuiControl,guiMain:, FSACTextGreen, Loaded set %index%!
  setTimer,FSACTextRemove,-3000
 }
;---------------------------- showPermanentToggle ----------------------------
showPermanentToggle(){
  global showPermanent
  
  showPermanent := !showPermanent
  fsEditListRefresh()
}
;-------------------------------- checkFocus1 --------------------------------
checkFocus1(){
  global hFsEdit

  if (hFsEdit != WinActive("A")){
    fsEditGuiClose()
  }
}
;------------------------------ fsEditListClose ------------------------------
fsEditListClose(){

  Gui, fsEdit:Destroy
  
  ; hide perm. desel.
  fsEditListRefresh()
  
  fsArrange()
  fsRead() ; reread!
  fsCycle(true) ; reset
  
  setTimer,checkFocus,3000
}
;------------------------------ fsEditGuiClose ------------------------------
fsEditGuiClose(){

  setTimer,checkFocus1,delete

  Gui, fsEdit:Destroy
  setTimer,checkFocus,3000
}
;------------------------------ fsEditListViewClick ------------------------------
fsEditListViewClick(){
  global fsEditListSelected, windowsEditKeyArr, windowsEditValueArr

  if (A_GuiEvent = "normal"){
    LV_GetText(order, A_EventInfo)
    
    fsEditListSelected := A_EventInfo

    entryType := ""
    
    data := 0 + windowsEditKeyArr[fsEditListSelected]
    if (data == 0)
      entryType := "perm. deActivated"
    if (data > 99)
      entryType := "deActivated"
      
    key := windowsEditValueArr[fsEditListSelected]
    kv := StrSplit(key,"|~~|")
    theTitle := kv[1]
    theClass := kv[2]
    
    GuiControl,fsEdit:, fsEditErrorText, Selected entry: %order% %theClass% %theTitle% %entryType%
  }
  }
;---------------------------- fsEditListTmpDeActivate ----------------------------
fsEditListTmpDeActivate(){
  global windowsTitleArr, fsEditListSelected, windowsEditKeyArr, windowsEditValueArr, fsEditErrorText
  
  if(fsEditListSelected > 0){
    GuiControl,fsEdit:, fsEditErrorText
  
    order := 0 + windowsEditKeyArr[fsEditListSelected]
    key := windowsEditValueArr[fsEditListSelected]

    if(order > 0){
      windowsTitleArr[key] := order + 999
      fsArrange() ; also saves to file!
      
      LV_Modify(fsEditListSelected, "-Select")
      fsEditListSelected := 0
      
      fsEditListRefresh()
      
    } else {
      GuiControl,fsEdit:, fsEditErrorText, Please use Edit-file button to edit this entry!
    }
  } else {
    GuiControl,fsEdit:, fsEditErrorText, Please selected an entry first!
  }
}
;----------------------------- fsEditListTmpActivate -----------------------------
fsEditListTmpActivate(){
  global windowsTitleArr, fsEditListSelected, windowsEditKeyArr, windowsEditValueArr, fsEditErrorText

  if(fsEditListSelected > 0){
    GuiControl,fsEdit:, fsEditErrorText

    order := 0 + windowsEditKeyArr[fsEditListSelected]
    key := windowsEditValueArr[fsEditListSelected]
    
    a := order - 10

    if(a > 0){
      windowsTitleArr[key] := a
      fsArrange() ; also saves to file!
      
      LV_Modify(fsEditListSelected, "-Select")
      fsEditListSelected := 0
      
      fsEditListRefresh()
    } else {
      GuiControl,fsEdit:, fsEditErrorText, Please use Edit-file button to edit this entry!
    }
  } else {
    GuiControl,fsEdit:, fsEditErrorText, Please selected an entry first!
  }
}
;---------------------------------- fsClean ----------------------------------
fsClean(){
  global fsWindowsFile, windowsTitleArr

  fsRead()
  
  FileDelete, %fsWindowsFile%
  sleep,1000
  
  for key, value in windowsTitleArr
  {
    order := 0 + value

    if (order == 0 || order > 99){
      FileAppend, %value%|--|%key%`n, %fsWindowsFile%, UTF-8
    }
  }
  
  fsCycle(true) ; reset
  
  GuiControl,guiMain:, FSACTextGreen, Cleaned!
  setTimer,FSACTextRemove,-3000
 }
;-------------------------------- fsCleanAll --------------------------------
fsCleanAll(){
  global fsWindowsFile, windowsTitleArr

  FileDelete, %fsWindowsFile%
  sleep,1000
  
  for key, value in windowsTitleArr
  {
    order := 0 + value
    if (order == 0){
      FileAppend, %value%|--|%key%`n, %fsWindowsFile%, UTF-8
    }
  }
  
  fsCycle(true) ; reset
  fsRead()
  
  GuiControl,guiMain:, FSACTextGreen, All cleaned!
  setTimer,FSACTextRemove,-3000
 }
;--------------------------- fsEditListPermaDeActivate ---------------------------
fsEditListPermaDeActivate(){
  global windowsTitleArr, fsEditListSelected, windowsEditKeyArr, windowsEditValueArr, fsEditErrorText
  
  if(fsEditListSelected > 0){
    order := 0 + windowsEditKeyArr[fsEditListSelected]
    key := windowsEditValueArr[fsEditListSelected]

    windowsTitleArr[key] := 0
    fsEditListSelected := 0
    fsArrange() ; also saves to file!
    
    
    fsEditListRefresh()
  } else {
    GuiControl,fsEdit:, fsEditErrorText, Please selected an entry first!
  }
 }
;------------------------------- fsEditListInc -------------------------------
fsEditListInc(){
  global windowsTitleArr, windowsOrderArr, fsEditListSelected, windowsEditKeyArr, windowsEditValueArr, fsEditErrorText
  
  if(fsEditListSelected > 0){
    order := 0 + windowsEditKeyArr[fsEditListSelected]
    key := windowsEditValueArr[fsEditListSelected]
    
    order1 := 0 + windowsEditKeyArr[fsEditListSelected + 1]
    key1 := windowsEditValueArr[fsEditListSelected + 1]
    
    if(key1 != "" && order1 < 100){
      windowsTitleArr[key] := order1
      windowsTitleArr[key1] := order
      
      fsArrange() ; also saves to file!
      fsEditListSelected += 1
      if(fsEditListSelected > 99)
        fsEditListSelected := 99
      
      fsEditListRefresh()
      GuiControl,fsEdit:, fsEditErrorText, Selected: %fsEditListSelected%
      LV_Modify(0, "-Select")
      LV_Modify(fsEditListSelected, "Focus Select")
      GuiControl, Focus, LV2
      send {right}
      
    }
  } else {
    GuiControl,fsEdit:, fsEditErrorText, Please selected an entry first!
  }
}
;------------------------------- fsEditListDec -------------------------------
fsEditListDec(){
  global windowsTitleArr, windowsOrderArr, fsEditListSelected, windowsEditKeyArr, windowsEditValueArr, fsEditErrorText
  
  if(fsEditListSelected > 1){
    order := 0 + windowsEditKeyArr[fsEditListSelected]
    key := windowsEditValueArr[fsEditListSelected]
    
    order1 := 0 + windowsEditKeyArr[fsEditListSelected - 1]
    key1 := windowsEditValueArr[fsEditListSelected - 1]
    
    if(key1 != "" && order1 < 100){
      windowsTitleArr[key] := order1
      windowsTitleArr[key1] := order
      
      fsArrange() ; also saves to file!
      fsEditListSelected -= 1
      if(fsEditListSelected < 1)
        fsEditListSelected := 1
      
      fsEditListRefresh()
      GuiControl,fsEdit:, fsEditErrorText, Selected: %fsEditListSelected%
      LV_Modify(0, "-Select")
      LV_Modify(fsEditListSelected, "Focus Select")
      GuiControl, Focus, LV2
      send {right}
    }
  } else {
    GuiControl,fsEdit:, fsEditErrorText, Please selected an entry first!
  }
}
;-------------------------------- fsRead --------------------------------
fsRead(){
  ; not using a class was not a good idea ...
  ; using value as key in windowsOrderArr
  global fsWindowsFile, windowsTitleArr, windowsOrderArr, windowsCycleArrClass, windowsCycleArrTitle

  windowsTitleArr := {}
  windowsOrderArr := {}
  windowsCycleArrClass := {}
  windowsCycleArrTitle := {}

  Loop, read, %fsWindowsFile%
  {
    rl := trim(A_LoopReadLine)
    if (rl != "") {
      data := Strsplit(rl,"|--|") ; separator is: "|--|"
      if (data.Length() > 0){
        key := data[2] ; title + class
        order := 0 + RegExReplace(data[1],"(\d+)","$1")
        
        if(order != 0){
          if(windowsOrderArr.HasKey(order) && order < 100){
            index := 1
            
            findNewOrder:
            Loop, 100
            {
              if(windowsOrderArr.HasKey(index)){
                index += 1
                if(index > 99) {
                  msgbox, Error, more than 99 windows, exiting app!
                  exit()
                }
              } else {
                windowsOrderArr[index] := key
                windowsTitleArr[key] := index ; "0" or "1,2 ..., n"
                break findNewOrder
              }
            }
          } else {
            windowsOrderArr[order] := key
            windowsTitleArr[key] := order ; "0" or "1,2 ..., n"
          }
        } else {
          windowsTitleArr[key] := 0
        }
      }
    }
  }
  
  ; does not sort:
  for key, value in windowsTitleArr
  {
    kv := StrSplit(key,"|~~|")
    theTitle := kv[1]
    theClass := kv[2]
    order := 0 + value
    if (order > 0 && order < 100){
      ; windowsCycleArr[order] := key
      windowsCycleArrClass[order] := theClass
      windowsCycleArrTitle[order] := theTitle
    }
  }
   }
;---------------------------------- fsLearn ----------------------------------
fsLearn(){
  global fsWindowsFile
  global windowsTitleArr
  global windowsMaxIndex
  global fastSwitchUseTitleArr
  global windowsCycleArrClass
  global windowsCycleArrTitle

  fsRead()
  
  ; get the max index of active (below 100) entries
  n := 1
  windowsIndex := 1
  windowsMaxIndex := 1

  for key, value in windowsTitleArr
  {
    data := Strsplit(value,"|--|") ; separator is: "|--|"
    if (data.Length() > 0){
      n := 0 + data[1] ; "0 .. N"
    }

    if n between 0 and 99
    {
      if (n > windowsMaxIndex)
        windowsMaxIndex := n
    }
  }
  
  if (windowsMaxIndex < 99){
    windowsIndex := windowsMaxIndex + 1 
  } else {
    msgbox, Error, to much entries: %n%!  
    return
  }
      
  hideWindow()

  
  WinGet,actu,ID,A

  DetectHiddenWindows, Off
  WinGet, id, List,,, Program Manager
  DetectHiddenWindows, ON
  
  newKey := ""
  
  Loop, %id%
  {
    this_id := id%A_Index%
    WinActivate, ahk_id %this_id%
    WinGetClass,this_class,ahk_id %this_id%
    WinGetTitle,this_title,ahk_id %this_id%
    
    if(fastSwitchUseTitleArr.HasKey(this_class)){
      newKey := this_title . "|~~|" . this_class
    } else {
      newKey := "|~~|" . this_class ; ignore title (default)
    }
    
    if (newKey != "|~~|"){
      if (!windowsTitleArr.HasKey(newKey)){
        sepaOn := windowsIndex . "|--|"
        windowsTitleArr[newKey] := sepaOn ; only new
        windowsIndex += 1
        FileAppend,%sepaOn%%newKey%`n, %fsWindowsFile%, UTF-8
      }
    }
  }
  
  windowsCycleArrClass := {}
  windowsCycleArrTitle := {}
  index := 1
  for key, value in windowsTitleArr
  {
    kv := StrSplit(key,"|~~|")
    theTitle := kv[1]
    theClass := kv[2]
      
    order := 0 + value
    if (order > 0 && order < 100){
      windowsCycleArrClass.push(theClass)
      windowsCycleArrTitle.push(theTitle)
    }
    index += 1
  }
  
  fsRead() ; reread!
  fsArrange()
  fsCycle(true) ; reset
  
  WinActivate,ahk_id %actu%
  
  showWindow()
 }
;------------------------------- fsCycle -------------------------------
fsCycle(fsSelectedReset := false){
  global windowsTitleArr, windowsCycleArrClass, windowsCycleArrTitle, showActiveTitle
  
  static fsSelected := 1
  
  if (fsSelectedReset){
    fsSelected := 1
  } else {
    windowsCycleArrLen := windowsCycleArrClass.Length()
    
    if (windowsCycleArrLen < 2){
      msgbox, Problem detected: windowsCycleArrLen is %windowsCycleArrLen%
    }

    windowsCycleLoop:
    Loop, %windowsCycleArrLen%
    {
      ; kv := StrSplit(s,"|~~|")
      
      theTitle := windowsCycleArrTitle[fsSelected]
      theClass := windowsCycleArrClass[fsSelected]
      
      actuTitle := ""
      actuClass := ""
        
      if(theTitle != "")
        WinGetTitle, actuTitle, A
      
      if(theClass != "")
        WinGetClass, actuClass, A
      
      ;Next window already in front?
      a := actuTitle . " ahk_class " . actuClass
      b := theTitle . " ahk_class " . theClass

      if(eq(a, b)){
        fsSelected += 1
        if (fsSelected > windowsCycleArrLen)
          fsSelected := 1
          
        ; s := windowsCycleArr[fsSelected]
        ; kv := StrSplit(s,"|~~|")
        
        ; theTitle := kv[1]
        ; theClass := kv[2]
        
        theTitle := windowsCycleArrTitle[fsSelected]
        theClass := windowsCycleArrClass[fsSelected]
      }
      
      if(WinExist(theTitle . " ahk_class " . theClass)){
        if (showActiveTitle)
          showHintAdd("Activate entry: " . fsSelected . " (" . Trim(theTitle . " " . theClass) . ")",4000)
          
        WinActivate,%theTitle% ahk_class %theClass%
        setTimer,showHintAddReset, -3000
        break windowsCycleLoop
      } else {
        if(theTitle != "" || theClass != "")
          showHintAdd("Entry: " . fsSelected . ", window not found: " . " (" . theTitle . " / " . theClass . ")",3000)
      }
      fsSelected += 1
      if (fsSelected > windowsCycleArrLen)
        fsSelected := 1 
    }
  }
}
;------------------------------- closeMessage -------------------------------
closeMessage(){
  global FSACTextRed

  if (WinExist("ahk_exe notepad++.exe")){
    msgbox, Notepad++ is already running, please close it first (all instances)!
    return
  }
  GuiControl,guiMain:, FSACTextRed, Please close the editor before proceeding!  !
}
;---------------------------- closeMessageRemove ----------------------------
closeMessageRemove(){
  global FSACTextRed

  GuiControl,guiMain:, FSACTextRed
}





















































 



















