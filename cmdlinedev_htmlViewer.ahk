; cmdlinedev_htmlViewer.ahk
; part of cmdlinedev

;------------------------------- htmlViewer -------------------------------
htmlViewer(forceOnline := 0, url := ""){
  global mainHWND,hHtmlViewer, clientWidthHtmlViewer, clientHeightHtmlViewer
  global WB, appnameLower
  
  clientWidthHtmlViewer := coordsScreenToApp(A_ScreenWidth * 0.6)
  clientHeightHtmlViewer := coordsScreenToApp(A_ScreenHeight * 0.6)

  WinSet, Style, -alwaysOnTop, ahk_id %mainHWND% 
  gui, guiMain:hide

  gui, htmlViewer:destroy
  gui, htmlViewer:New,-0x100000 -0x200000 +alwaysOnTop +resize +E0x08000000 hwndhHtmlViewer, Html-viewer
  gui, htmlViewer:Add, ActiveX, x0 y0 w%clientWidthHtmlViewer% h%clientHeightHtmlViewer% +VSCROLL +HSCROLL vWB, about:<!DOCTYPE html><meta http-equiv="X-UA-Compatible" content="IE=edge">
  
  gui, htmlViewer:Add, StatusBar
  SB_SetParts(400,300)
  SB_SetText("Use CTRL + mousewheel to zoom in/out!", 1, 1)

  htmlFile := "quickhelp.html"
  
  if(url == "")
    url := "https://xit.jvr.de/" . appnameLower . "_quickhelp.html"

  failed := 0
  if (!forceOnline){
    if (FileExist(htmlFile)){
      FileEncoding, UTF-8
      FileRead, data, %htmlFile%
      if (!ErrorLevel){
        doc := wb.document
        doc.write(data)
      } else {
        failed := 1
      }
    } else {
      failed := 1
    }
    if (failed){
      WB.Navigate(url)
      SB_SetText("(Local help-file not found, using online version) Use CTRL + mousewheel to zoom in/out!", 1, 1)
    }
  } else {
    WB.Navigate(url)
  }

  gui, htmlViewer:Show, center
  
  GuiControl, -HScroll -VScroll, ahk_id %hHtmlViewer%
}
;----------------------------- htmlViewerGuiSize -----------------------------
htmlViewerGuiSize(){
  global hHtmlViewer, clientWidthHtmlViewer, clientHeightHtmlViewer
  global WB

  if (A_EventInfo != 1) {
    statusBarSize := 20
    clientWidthHtmlViewer := A_GuiWidth
    clientHeightHtmlViewer := A_GuiHeight - statusBarSize

    GuiControl, Move, WB, % "w" clientWidthHtmlViewer "h" clientHeightHtmlViewer
  }
}
;---------------------------- htmlViewerGuiClose ----------------------------
htmlViewerGuiClose(){
  global mainHWND, ishidden

  WinSet, Style, +alwaysOnTop, ahk_id %mainHWND% 
  ishidden := 0
  gui,guiMain:show
}
;----------------------------- htmlViewerOffline -----------------------------
htmlViewerOffline(){
  htmlViewer(0)
}
;----------------------------- htmlViewerOnline -----------------------------
htmlViewerOnline(){
  htmlViewer(1)
}
;-------------------------- htmlViewerOnlineReadme --------------------------
htmlViewerOnlineReadme(){
  global appnameLower
  
  htmlViewer(1, "https://xit.jvr.de/" . appnameLower . "_readme.html")
}






















