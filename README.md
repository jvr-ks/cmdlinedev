# CmdLineDev  
  
Somewhat old AHK 1 code
  
#### Known issues / bugs  
  
Issue / Bug | Type | fixed in version  
------------ | ------------- | -------------  
~~"!externalApp!" command is not executed~~ | bug | 0.337
~~open the Document List sometimes fails~~ | issue | 0.334
  
#### Latest changes:  
  
Version (&gt;=)| Change  
------------ | -------------  
0.359 | Autostart the last used selection default hotkey changed to **\[WIN] + \[ALT] + \[c]**  
0.357 | Copy the file "________EMPTY.npp-session" to your session directory!
0.354 | "checkOperation" activation with CAPSLOCK removed, Bugfixes
0.353 | Default "run" hotkey changed to "*!r" (\[Alt] + r, any modifier i.e. \[Shift] is allowed, used to show debug info)
0.351 | FastSwitch windows file ("cldwindows.txt") is manually editable: Setup -> Edit FsWindowsFile-file
0.347 | Configuration file folder is app folder  
0.344 | Complete change of the way the entries are selected!  
0.342 | "Fastswitch-Cycle feature" removed!  
0.339 | "Run external app" execution path extracted from path of the external app.  
0.338 | "Run external app" input box is editable, EOL bug fixed.  
  
### Changes from version &gt;= 0.357 
Copy the file "________EMPTY.npp-session" to your session directory!  
  
### Changes from version &gt;= 0.344  
Single click: Run cmd 1 - 4 of the clicked row!  
Shift + Single click: Edit the row entries.  
\[Alt] + \[Ctrl] | move the line to a top position.  
The \[Alt] + \[Win]+ \[Ctrl] modifier is removed.  
  
### Changes from version &gt;= 0.342  
"Fastswitch-Cycle feature" removed!  
(But Fastswitch hotkeys are of course still usable, definition file is "cldfastswitchhotkeys.txt")
  
### Changes from version &gt;= 0.325  
It was not a good idea to use simple hotkeys to open rarely used apps.  
* Nearly all apps need a startparameter, for example a browser needs an URL, an editor needs a FILENAME etc.  
* The hotkeys are globally active and cannot be used by other apps thow.    
  
Use notepadd++, open "clddirectories.txt", press Ctrl+F, change "Search Mode" to Regex:  
Find: \n.*?,  
Replace: $0,  
Repeat until the end.  
  
The new column is called "Latest".  
"Latest" is the default sort column now (descending).  
The values are the seconds passed since 2024/02/01/16:54:00.  
A simple mechanism to move the entries of current interest to the top of the table!  
~~The value is set by a mouse-drag (up or down) onto a line entry in the table.~~  
Double click a row to move the selected entry to the top!  
(By setting the "Latest"-field).  
  
The "Latest"-field can be set manually also (Edit: SHIFT + Click).  
  
#### Download  
Via Updater is the preferred method!  
Portable, run from any directory, but running from a subdirectory of the windows programm-directories   
(C:\Program Files, C:\Program Files (x86) etc.)  
requires admin-rights and is not recommended!  
**Installation-directory (is created by the Updater) must be writable by the app!**  
  
To download **CmdLineDev** from Github please use:  
  
Windows, 64bit: [updater.exe](https://github.com/jvr-ks/cmdlinedev/raw/main/updater.exe)  
Windows, 32bit: [updater.exe](https://github.com/jvr-ks/cmdlinedev/raw/main/updater32.exe)  
  
**Be sure to use only one of the \*.exe at a time!**  
  
(Updater viruscheck please look at the [Updater repository](https://github.com/jvr-ks/updater)) 
  
* From time to time there are some false positiv virus detections  
[Virusscan](#virusscan) at Virustotal see below.  
  
### App-start  
  
**cmdlinedev.exe** 64 bit Windows  
**cmdlinedev32.exe** 32 bit Windows  
  
  
Alternatives to start CmdLineDev:  
* A doubleclick onto the file "cmdlinedev.exe" (or other version).    
* Drag the "cmdlinedev.exe" (or other version) to the taskbar.  
  
Start with Windows:  
* To create a shortcut of "cmdlinedev.exe" in the windows-autostart folder ("shell:startup"),  
run the simple Powershell script:  
"create_cmdlinedev_exe_link_with_in_autostartfolder.bat", or  
take a look at the project [startdelayed](https://github.com/jvr-ks/startdelayed).   
  
Self remove from memory: cmdlinedev.exe remove  
  
The app runs in the background after startup.  
(Can be disabled by a "showwindow" start-parameter).  
  
**Please press the hotkey (default is: \[Alt] + \[c]) to show the app-window!**  
   
### Description   
This app can be used to do multible operations by a single click *1) on an entry in the list.  
I use it to open a filemanager, an editor and other (up to 4) with a file-selection in a distinct directory.  
When the focus is lost, it is hidden and runs as a background process.  
It can be activated again via the menu-hotkey (\[ALT] + \[c] is default),  
but is NOT listed in the Windows tasklist, i.e. \[ALT + TAB] or \[WIN + TAB].  
  
Inspired by my own tool "sbt_console_select" I wrote this small tool, using Autohotkey.  
The advantages over other solutions (desktop icons, batch scripts, etc.) are:  
* easy maintainability,  
the entries are in a simple textfile (the ([Directories-file]) Menu -&gt; Edit,  
* fast access via hotkey,  
* can send additional parameters after an operation (an app / a program) is started.  
  
### Configuration file  
The Configuration file is: **cmdlinedev.ini**  
  
File encoding of **"\*.ini"** files is: **UTF-16 LE BOM**.   
  
Other data files used:  
Directories-file **"clddirectories.txt"**,  
Tools-file **"cldtools.txt"**,  
Shortcuts-file **"cldshortcuts.txt"**,  
  
File encoding of **"\*.txt"** files is: **UTF-8 (with BOM)**,  
  
  
#### Configuration file sections   
Configuration file-Section [hotkeys]:  
Hotkeys can be set to "off" by adding the word "off" to the definition.  
The two app-hotkeys defaults are:  
menuHotkey="!c", i.e. \[ALT] + \[c] to show the app-window  
menuOpenHotkey="^!c", i.e. \[CTRL] + \[ALT] + \[c] autostart the last used selection (like the "open button")
exitHotkey="+!c", i.e. \[SHIFT] + \[ALT] + \[c] to exit the app and remove it from memory  
(you may use the button "Kill the app" also)  
  
Primary hotkey modifiers:  
  
Hotkey prefix | Modifier Key  
------------ | -------------  
! | \[ALT]  
^ | \[CTRL]  
\# | \[WIN]  
\+ | \[SHIFT]  
    
Other [Autohotkey Hotkeys](https://www.autohotkey.com/docs/Hotkeys.htm) hotkeys-characters are usable,  
but are untested.  
Only simple hotkeys are good to remember and fast to access!  
If no Configuration file is found at all,  
a default one is always created!  

### Mouseclick operations in the app-window  
**Command modifier, holding down key while double-clicking:**  
  
Key | Action  
------------ | -------------  
\[Click] | Highlight the line entry
\[Ctrl] | Execute first command only  
\[Alt] | Execute second command only  
\[Ctrl] + \[Shift] | Execute third command only  
\[Alt] + \[Shift] | Execute fourth command only  
\[Shift] | Edit the entry  
\[Alt] + \[Ctrl] | move the line to a top position
  
Hint: Using the Shift + click edit operation the value of the "Latest" field can be changed, but not deleted!  
  
#### Hotkeys  
(fastswitch hotkeys see below)  
  
Hotkey | Action  
------------ | -------------  
**\[ALT] + \[c]** | open app-window  
**\[WIN] +\[ALT] + \[c]** | autostart the last used selection  
**\[SHIFT] + \[ALT] + \[c]** | remove app from memory  
**\[ALT] + \[r]** | Run any file defined in the field "Run external app" (used to run the "*.ahk"-file) \*1)  
  
\*1) The "Run external app"-field can be manually set or by the cmd: "!externalApp!#&gt;DIRECTORY&lt;\&gt;FILENAME&lt;"  
Example "clddirectories.txt"-entry, cmd4: "!externalApp!#\[ahk]\aottext\aottext.ahk"  
\[ahk] is a shortcut of a directory defined in the file "cldshortcuts.txt"   
  
**Hotkeys are configurable** -&gt; Configuration file.  
  
[Hotkey modifier symbols](https://www.autohotkey.com/docs/Hotkeys.htm) .  
[Convert pressed keys to Hotkey-code: hotkeyConverter2](https://github.com/jvr-ks/simpletools)
[Direct download hotkeyConverter2.exe](https://github.com/jvr-ks/simpletools/raw/main/hotkeyConverter2) .  
Only simple Hotkeys are shown in the app-window text (Cycle-entries).  
(Parsing is limited to \[CTRL], \[ALT], \[WIN], \[SHIFT]).  
  
#### Run external app  
(Default Hotkey: \[ALT] + \[r])  
Fast start of the "app under construction"!  
Saved to the Configuration file [external] -&gt; runnerPath=  
The Edit-Box must contain the full pathname,  
but can be set via the "!externalApp!" command using the defined cldshortcuts,  
cmd entry example: 
```
!externalApp!#[ahk]\lang2\_____test.ahk
```
which is expanded to the full path.  
  
#### Directories-file **"clddirectories.txt"**:  
contains on each line separated by a comma:  
  
Name | Dir | Cmd1 | Cmd2  ... Cmd5  
------------ | ------------- | ------------- | -------------  
**The name of the enty** | the working-directory *1) | 1st tool/command to open in that directory[#parameter1#parameter2 ... #parameter6] | 2nd tool *2) *3)  
 
\*1) optional, besides the command-line, nearly all apps/programs ignore this entry but take the 1st parameter as a dirctory.    
\*2) The number of tools/commands is not limited, but only 5 are displayed in the list.   
\*3) \[...] is an alias for the working directory.    
  
Tools are executed from left to right. 
Each tool/command can have up to 6 parameters, separated by a "#"-character.  
  
Hints: 

- ActualURL mechanism:  
  Use "firefox#§_____url.txt§" as an Directories-file entry.  
  Create a file "_____url.txt" containing the URL.  
  
- To open multiple urls with Firefox use: FireFox#url1 url2 url3 ...  
  
- Add FireFox, "C:\Program Files\Mozilla Firefox\firefox.exe"  
  to "cldtools.txt", if it is not already included.  
  
- Content may be read from a text-file located in the working-directory (or in the app-directory, if the "Dir" is empty).  
  Specify the filename as a parameter surrounded by "§"-characters, example: FireFox#§myhomepage.txt§.  
  
- Environment-variable are also usable, i.e. showmessage#%USERNAME%~5  
  Displays the username for about 5 seconds.  
  
URL-Restriction:  
If a parameter (namely URL) contains a "#"-character,  
replace it with a "°"-character!  
  
Special **SEND-parameter**:  
If the parameter is of the form "#value\~number",     
the **value** is sended to the running tool with a **number** delay (seconds) afterwards. 
There is an hard coded initial delay of 3 seconds after the tool is started.   
"#value\~0" waits for the user to press the **Alt-key** and the **Control-key**.  
("#value\~" is not allowed!) 
  
The characters "^,+,!,{,}" have a [special meaning](https://www.autohotkey.com/docs/commands/Send.htm),  
and must be escaped with {}.  
The characters:  
"," "#" "\~" 
cannot be used at all, because they are used by the app as delimiter-characters!   
  
Use the Paragraph-character as an alias for a comma!  
  
It is easier to use the **text-mode**, just prepend the send-value with **"{text}"**.  
You cannot send an \[ENTER]-key in text-mode,     
instead use an additional SEND-parameter to send an \[ENTER]-key,  
Examples:  
```
notepad#{text}Hello world!\~1#[E]\~1#by by{!}[E](Press Ctrl-key)\~0#!d\~2#b\~2#n\~1  
``` 
  
- Opens "Notepad" sends "Hello world!" in text-mode,  
- sends ENTER-Key,  
- sends "by by", ENTER-key and "(Press Ctrl-key)", 0 = waits for Ctrl-key (exclamation mark must be escaped if not in text-mode),  
- sends Alt + d, waits 2 sconds,  
- sends b, waits 2 seconds  
- sends n, waits 1 second  
  
#### Tools-file **"cldtools.txt"**:  
contains on each line separated by a comma: 

Entry1 | Entry2  
------------ | -------------  
name of the tool | path to open it  
  
Add an extra "%comspec% /k" to keep a shell window open.  
(like the VS19 entry) in the Tools-file.  
Use quotation marks arround an entry, if extra parameters are appended.  
  
Example:  
filemanager,%SystemRoot%\explorer.exe  
\[SystemRoot = windir]  
  
All commands with a paramter(s) may have a delay (seconds) added after execution,  
format is: commandname"+...+"delay,  
each "+" gives 2 seconds delay **before** running the command.  
Example:  
  
```
!opensession!+++++#akkatyped
```
  
Internal command "opensession", opening session "akkatyped" after 10 seconds delay.  
  
The Tools-file at github is populated with entries I use.  
My file-manager is [Directory Opus](https://www.gpsoft.com.au)  
  
Some tools (apps/programs) need special knowledge:  
Directory Opus:  
* Use "dopusrt.exe" to open more than one tab. Read the Directory Opus manual.  
Use shortcuts to shorten command-parameters, like "[dopus2_hidden]",  
\[...] is an alias of the working directory.  
   
#### Shortcuts-file **"cldshortcuts.txt"**:   
Besides environment-variable-expansion,  
the shortcut-mechanism allows to use shortcuts of the format \[shortcut-key] everywhere in the Directories-file!   
The Shortcuts-file can contain an unlimited number of \[shortcut-key], \[value] definition pairs.  
\[shortcut-key] must be alphanumeric (no symbols or special characters allowed) but  
**spaces in the value are retained!**  
Shortcuts without a trailing backslash are more universal usable, i. e. with a shortcut definition of  
[mydir],c:\mydir  
it an be used as [mydir]\subdir1 and [mydir]_newversion\subdir1  
  
Hint: Pay attention to Windows system folder having name aliases,  
the language name alias must be used as a shortcut, instead of the real folder names.  
Example:  
"C:\Users\USER\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"  
If the Windows language is set to "German" the folder alias is:  
"C:\Users\USER\AppData\Roaming\Microsoft\Windows\Startmenü\Programs\Startup"  
  
#### Builtin-functions:     
  
**!shell!**  
executes a command-shell with an \[ENTER] between each parameter and shows the result in a window.   
Uses normal parameters, not "send"-parametes, i.e. ... ,shellWR#cd \[tmp]#dir, ...  
  
**!showMessage!**  
Shows a messagebox. Removed after time t (seconds).  
Of form with delay (SEND-form), i.e. ... ,showMessage#themessage\~time, ...  
Time is in seonds, minimum is 1 second.         
      
**!Opensession!**  
see below  
  
**Examples:**  
```
TEST 1 explorer,,filemanager#c:\tmp  
```
Open explorer in the "c:\tmp" directory  
  
```
TEST 2 Show directory,,cmdline#cd \[tmp][E]\~#dir\[E]\~
```

Opens a command-shell, sends "cd C:\tmp" and "Enter" with no delay and then sends "dir".  
  
```
TEST 3,,notepad#test start^[E]\~3#test 2^[E]\~0#test end\[E]\~5#{Ctrl Down}w{Ctrl Up}\~1#n\~1,showMessage#Command finished!\~5
```
- Opens the windows-notepad editor,  
- enters "test start," ("^" is an alias for ",")  
- enters \[ENTER]-key and waits 3 seconds,  
- enters "test 2,", waits eternally (press Control-key to continue),  
- sends "test end" ad \[ENTER]-key , waits 5 seconds  
- sends notepad close commands with denying the save question,  
- shows "Command finished!" message, closes after 5 seconds.   
  
#### Log file  
The last command is allways written to the file "cldLog.bat".  
Execute this file and inspect possible error-messages.  
   
 
#### Two cycle thru the open app-windows mechanism  
Windows 10 has built-in cycle thru running-apps windows, accessible via Alt+ or Win+ or Ctrl+ Tab hotkey.  
Cmdlinedev adds 3 mechanism:  
  
#### 1) Fastswitch hotkeys  
The purpose of Fastswitch hotkeys is to fast switch between already open windows.  
They are defined in the **Hotkey-file: "cldfastswitchhotkeys.txt"**.  
  
Format is: hotkey, app-title  
  
hotkey is a hotkey-definition, see [Autohotkey Hotkeys](https://www.autohotkey.com/docs/Hotkeys.htm)   
app-title is any part of the window-title and/or any [other criteria](https://www.autohotkey.com/docs/misc/WinTitle.htm) of the Window Title.  
";" (line is commented out) and "," (is separator) are not allowed inside hotkey definitions.  
  
Already defined hotkeys: 
* !d,ahk_class dopus.lister  
* !n,ahk_class Notepad\+\+  
* !w,ahk_class Notepad\+\+ 
* !b,Mozilla Firefox  
* ;!b,Google Chrome (Use a semicolon to comment out)  
* !f,Foxit PDF Reader  
* !o,OpenOffice Writer  
* !k,ahk_group anyshell  
(anyshell is a hardcoded alias of: "ahk_class ConsoleWindowClass or ahk_class mintty")  
If any hotkey is already used by another app, it is redefined and not usable by the other app anymore.  
    
To make a hotkey usable by another app, redefine it with a "never used" (but still valid) hotkey-sequence,  
example: 
Edit the Hotkey-file and replace the line entry:
!b,Mozilla Firefox  
with:  
^+#!b,Mozilla Firefox  
Then edit the Configuration file (Setup -> Edit Fastswitch-file) and replace "!b" with "^+#!b"  
Looks ugly and if you want to use the hotkey directly, you have to press simultaneously:   
\[CTRL] + \[SHIFT] + \[WIN] + \[ALT],  
which is difficult to do, unless you are an alien who has a lot more fingers!   
  
Or use "Fastswitch Auto cycle" only, which is independent of any hotkey-definition.  
  
Hint: I use two hotkeys to select "notepad++",  
"ALT + n" is easy to remember and "ALT + w" is reachable with the left hand,  
while using FastSwitch cycles with "ALT + q" and sometimes switching to Notepad++ in between!  
  
#### 2) ~~Fastswitch hotkeys cycle thru the Cycle-Groups (2 - 9)~~  
Fastswitch hotkeys are ok, but cycle thru the Cycle-Groups is deactivated!  
  
Please use "Fastswitch Auto cycle" combined with "Fastswitch hotkeys" instead (below).  
  
#### 3) Fastswitch Auto cycle  
Another mechanism to cycle throw different windows.  
It is more flexible, but has only a single group!  
Uses only one hotkey (fastSwitchAutoCycleHotkey, default "Alt + q" = "!q") to cycle thru the running-apps-windows (99 maximal).   
Pressing the button FastSwitch: "Learn" adds running-apps-windows to the cycle-list.  
(Press "Clean" and then "Learn" to get a fresh list).  
The list of all running-apps-windows is kept in the file "cldwindows.txt" and can be manually edited: "Edit-file"-button.  
Use the "Edit" button to arrange the entries and to mark unwanted system windows as inactive (permanent)!  
  
Example:  
3|--|Scripts - Definition & Usage | AutoHotkey - Mozilla Firefox|\~\~|MozillaWindowClass  
  
Column 1: order-number or **0 if entry is inactive (permanently) / &gt; 99 if entry is inactive (temporary)**  
Separator: |--|  
Column 2: Title of the app-window \*1)  
Separator: |\~\~|  
Column 3: Class of the app-window  
  
\*1) The title (can be empty) is only used, if the Configuration file-entry-list "fastSwitchUseTitle" contains the corresponding class-name!  
The title can consist of only parts from the title, ignoring the absent specifications then,  
but a new "Auto Cycle Learn" will generate a new entry with the complete title then.  
  
There are some Windows internal system/hidden app-windows (language dependent), which must be manually inactivated once!  
  
"Learn" operates additive.  
To start fresh, press the button "Clean". It removes all active cycle-entries,  
but keeps the temporary deactivated entries ("100 and up").  
the button "Clean" removes all inclusiv the temporary deactivated entries ("100 and up")  
Inactive entries ("0 ...") are never removed! (use "Edit" to remove them).    
  
Press the button "Arrange" to manually arrange deactivated entries at the end of the list, with an empty line between.  
Mark temporary-inactive entries with key "&gt; 99"!  
Add spacer blank rows.  
All entries are re-indexed and sorted.  
  
Press a button "Save N" to save to file "_cldwindowsN.txt".   
Press a button "Read N" to read from file "_cldwindowsN.txt".  
  
Example after manually marking all system/hidden app-windows as inactive ("0"):  
``` 
1|--||~~|Notepad++
2|--||~~|classFoxitReader
3|--|Scala3_Learn - sbt  consoleQuick|~~|ConsoleWindowClass

100|--||~~|dopus.lister
101|--||~~|Chrome_WidgetWin_1
102|--||~~|MozillaWindowClass
103|--||~~|Notepad

0|--||~~|#32770
0|--||~~|CEF-OSC-WIDGET
0|--||~~|NarratorHelperWindow
0|--||~~|Shell_TrayWnd
0|--||~~|SynTrackCursorWindowClass
0|--||~~|SysShadow
0|--||~~|tooltips_class32
0|--||~~|USBDLM_UsrWndClass
0|--||~~|WindowsForms10.Window.8.app.0.ef02dc_r6_ad1
```
  
#### Sourcecode: [Autohotkey format](https://www.autohotkey.com)  
* "cmdlinedev.ahk"  
* "Lib\hkToDescription"  
* "Lib\hotkeyToText"  
  
#### Requirements  
* Windows 10 or later only.  
  
#### Sourcecode  
Github URL [github](https://github.com/jvr-ks/cmdlinedev).  
  
#### Hotkeys  
[Overview of all default Hotkeys used by my Autohotkey "tools"](https://github.com/jvr-ks/cmdlinedev/blob/main/hotkeys.md)  
  
#### Tips  
* Open Notepad\+\+ with cursor-position at the end of the file:  
If you use sessions / Session Manager plugin:  
Copy each "sessionName.npp-session" file to "sessionName.npp-session.xml" so you can edit it with Notepad\+\+ (would open the session otherwise!).  
(Or use any other plain text-editor to change the "sessionName.npp-session" file.)  
  
Each file which belongs to the session, has an entry of the form:  
&lt;File firstVisibleLine="99999" xOffset="0" ... filename= ... /&gt;  
(XML-format)  
Change firstVisibleLine="0" to firstVisibleLine="99999".  
  
Save and rename back to "sessionName.npp-session".  
  
* app#parameter1#parameter2 ... is different from app#paramter1\~number1#paramter2\~number2   
the first starts app with parameterN (commandline-parameter), the second starts app with no parameter but sends parameterN  
as if it where entered by the keyboard then, with delay numberN (seconds) between/afterwards.   
If a commandline-parameter contains blanks, it must be surrounded by quotationmarks!  
  
* After each command there is a default delay of 2 seconds.  
Add multible "+" to the next command name, to increase the delay before it is executed.  
Each "+" adds 2 seconds delay.     
Example: Chrome+++#url starts Chrome with 2 + (3 * 2) = 8 seconds after the previous command was started.  
(not after it was finished!)  
  
#### Opensession  
Open a Notepad\+\+ session.  
  
Format:  
!opensession!#sessionName 
or  
!opensession!&lt;\+ ...&gt;#sessionName  
Each "\+" adds a 2 seconds delay.  
  
"!opensession!" is the hardcoded command-name.  
Uses [nppsess] shortcut as the path to the "*.npp-session"-files  
and ".npp-session" filename-extension also (names are hardcoced, i.e. not changable).   
   
Open Session Manager session uses the "Alt+x"-hotkey!  
  
~~Session Manager contextmenu:  
Cmdlinedev sets the list to "sort by date"!~~  
  
Foxit PDF-Reader: [How to get rid of the security warning](https://kb.foxitsoftware.com/hc/en-us/articles/360040661431-How-to-get-rid-of-the-security-warning-Foxit-Reader-PhantomPDF-has-been-opened-by-the-following-app-without-an-valid-signature-This-may-indicate-a-security-issue-)
  
#### License: GNU GENERAL PUBLIC LICENSE  
  
Please take a look at [license.txt](https://github.com/jvr-ks/cmdlinedev/raw/main/license.txt)  
(Hold down the \[CTRL]-key to open the file in a new window/tab!)  
  
Copyright (c) 2020 J. v. Roos

<a name="virusscan"></a>
##### Virusscan at Virustotal 
[Virusscan at Virustotal, cmdlinedev.exe 64bit-exe, Check here](https://www.virustotal.com/gui/url/48d0cae565c0027012898f66ec70aaddba01bc94d9b91d68c82361bbfe4b5414/detection/u-48d0cae565c0027012898f66ec70aaddba01bc94d9b91d68c82361bbfe4b5414-1764321024
)  
[Virusscan at Virustotal, cmdlinedev32.exe 32bit-exe, Check here](https://www.virustotal.com/gui/url/86226d55d68d26a8dcaa92d608d573a232fc4cd2dabc3482da2ba937f07c930e/detection/u-86226d55d68d26a8dcaa92d608d573a232fc4cd2dabc3482da2ba937f07c930e-1764321025
)  
