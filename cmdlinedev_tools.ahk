; cmdlinedev_tools.ahk
; part of cmdlinedev

;---------------------------- clddirectoriesSort ----------------------------
clddirectoriesSort() {
  ; Name, alphabetically
  
  file := "clddirectories.txt"

  ; Datei einlesen
  FileRead, content, %file%
  if (ErrorLevel){
    msgbox, File not found: %file%
    restart(1)
  }

  rows := ""
  Loop, Parse, content, `n, `r
  {
    line := A_LoopField
    if (line = "")
      continue

    ; Erste CSV-Spalte extrahieren
    firstCol := StrSplit(line, ",")[1]

    ; Sortierschlüssel + Originalzeile
    rows .= firstCol "|" line "`n"
  }

  ; Sortieren nach Schlüssel
  Sort, rows, D`n

  ; Schlüssel wieder entfernen
  sorted := ""
  Loop, Parse, rows, `n, `r
  {
    if (A_LoopField = "")
      continue
    parts := StrSplit(A_LoopField, "|")
    sorted .= parts[2] "`n"
  }

  ; Datei überschreiben
  FileDelete, %file%
  FileAppend, %sorted%, %file%

  restart(1)
}

;--------------------------- clddirectoriesSort2() ---------------------------
clddirectoriesSort2() {
  ; Latest, sort numerically
  
  file := "clddirectories.txt"

  FileRead, content, %file%
  if (ErrorLevel){
    msgbox, File not found: %file%
    restart(1)
  }

  rows := ""

  Loop, Parse, content, `n, `r
  {
    line := A_LoopField
    if (line = "")
      continue

    cols := StrSplit(line, ",")

    ; Spalte 2 prüfen
    num := cols[2]
    if (num = "") {
      num := 1
      cols[2] := 1
      ; Zeile aktualisieren
      line := cols[1]
      Loop % cols.MaxIndex()-1
        line .= "," cols[A_Index+1]
    }

    ; numerischen Sortierschlüssel erzeugen (Zero-Padding)
    key := Format("{:010}", num)

    rows .= key "|" line "`n"
  }

  ; numerisch absteigend sortieren
  Sort, rows, D`n R

  ; Schlüssel entfernen
  sorted := ""
  Loop, Parse, rows, `n, `r
  {
    if (A_LoopField = "")
      continue
    parts := StrSplit(A_LoopField, "|")
    sorted .= parts[2] "`n"
  }

  FileDelete, %file%
  FileAppend, %sorted%, %file%

  restart(1)
}

;----------------------------------------------------------------------------







