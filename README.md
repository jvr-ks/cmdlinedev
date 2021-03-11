# CmdLineDev 
  
#### [-> Latest changes/ bug fixes](latest_changes.md)
   
#### App-start  
  
**cmdlinedev.exe** 64 bit Windows  
**cmdlinedev32.exe** 32 bit Windows  
  
Alternatives to start CmdLineDev:  
* A doubleclick onto the file "cmdlinedev.exe".    
* Drag the "cmdlinedev.exe" to the taskbar.  
  
Start with Windows:  
* To create a shortcut of "cmdlinedev.exe" in the windows-autostart folder ("shell:startup"),  
run the simple Powershell script:  
start hidden: "create_cmdlinedev_exe_link_with_hidewindow_in_autostartfolder.bat"  
    
#### Description   
  
This tool can be used to do multible operations by a single click *1) on an entry in the list.  
I use it to open a filemanager and an editor with a file-selection in a distinct directoy.  
  
Inspired by my own tool "sbt_console_select" I wrote this small tool, using Autohotkey.  
The advantages over other solutions (desktop icons, batch scripts, etc.) are:  
* easy maintainability,  
the entries in the control file ([Directories-file]) can be edited quickly and easily with a text editor  
* fast access via hotkey  

Configuration is done by a few files,
standard file encoding is: **UTF-8 (no BOM).**  
Use [Notepad++](https://notepad-plus-plus.org/) to edit the files:   
  
\[Directories-file] **"clddirectories.txt"**,  
\[Tools/commands-file] **"cldtools.txt"**,  
\[Shortcuts-file] **"cldshortcuts.txt"**,      
\[Configuration-file] **"cmdlinedev.ini"**
    
\*1) Holding down while clicking:  
  
Key | Action  
------------ | -------------  
\[Shift]-key | Edit the entry  
\[Ctrl]-key | Execute first command only  
\[Alt]-key | Execute second command only  
\[Ctrl] + \[Shift]-key | Execute third command only  
\[Alt] + \[Shift]-key | Execute forth command only  
  
\[Directories-file] **"clddirectories.txt"**:  
contains on each line separated by a comma:  

Name | Dir | Cmd1 | Cmd2  ... Cmd5
------------ | ------------- | ------------- | -------------
**The name of the enty** | the working directory *1) | 1st tool/command to open in that directory[#parameter1#parameter2 ... #parameter6] | 2nd tool *2) *3)
 
\*1) optional, besides the command-line, nearly all apps/programs ignore this entry but take the 1st parameter as a dirctory.    
\*2) The number of tools/commands is not limited, but only 5 are displayed in the list.   
\*3) \[...] is an alias for the working directory.    

  
Tools are executed from left to right. 
Each tool/command can have up to 6 parameters, separated by a "#"-character.  
     
Special **SEND-parameter**:  
If the parameter is of the form "#value\~number",     
the **value** is sended to the running tool with a **number** delay (seconds) afterwards. 
There is an hard coded initial delay of 3 seconds after the tool is started.   
"#value\~" does not wait at all,  
"#value\~0" waits for the user to press the **Control-key**.  
  
The characters "^,+,!,#,{,}" have a [special meaning](https://www.autohotkey.com/docs/commands/Send.htm),  
and must be escaped with {}.  
","   
"#"   
"\~"  
cannot be used at all, because they are used by the app as delimiter-characters!  
Often it is easier to use the **text-mode**, just prepend the send-value with **"{text}"**.  
You cannot send an \[ENTER]-key in text-mode, so   
use an additional SEND-parameter to send an \[ENTER]-key,  
Example:  
notepad#{text}Hello world!~1#[E]~1#by by{!}[E](Press Ctrl-key)~0#!d~2#b~2#n~1  
Opens "Notepad" sends "Hello world!" in text-mode,  
sends ENTER-Key,  
sends "by by", ENTER-key and "(Press Ctrl-key)", 0 = waits for Ctrl-key (exclamation mark must be escaped if not in text-mode),  
sends Alt + d, waits 2 sconds,  
sends b, waits 2 sconds
sends n, waits 1 scond

"^" can be used as an alias for a comma!     
  
\[Tools/commands-file] **"cldtools.txt"**:  
contains on each line separated by a comma: 
Entry1 | Entry2
------------ | -------------
name of the tool | path to open it  
  
In the app-window the comma between the entries is substituted with a ">>>" for better readability!  
([Configuration-file]: -> \[config] -> menuDelimCharacter)  
  
Add an extra "%comspec% /k" to keep a shell window open.  
(like the VS19 entry) in the \[Tools/commands-file].  
Use quotation marks arround an entry, if extra paramters are appended.  
  
Example:  
filemanager,%SystemRoot%\explorer.exe  
\[SystemRoot = windir]  
  
The \[Tools/commands-file] at github is populated with entries I use.  
My file-manager is [Directory Opus](https://www.gpsoft.com.au)  
Directory Opus opens each directory in a new tab, not a new instance. 
It has a speciall runtime "dopusrt", which allows multible configuration parameters.   
  
\[Shortcuts-file] **"cldshortcuts.txt"**:   
Besides environment-variable-expansion,  
the shortcut-mechanism allows to use shortcuts of the format \[shortcut-key] everywhere in the \[Directories-file]!   
The \[Shortcuts-file] can contain an unlimited number of \[shortcut-key], \[value] definition pairs.  
\[shortcut-key] must be alphanumeric (no symbols or special characters allowed) but  
**spaces in the value are retained!**  
Shortcuts without a trailing backslash are more universal usable, i. e. with a shortcut definition of  
[mydir],c:\mydir  
it an be used as [mydir]\subdir1 and [mydir]_newversion\subdir1  
    
\[Configuration-file] **"cmdlinedev.ini"**:
If parameter listWidth=0 the width of the window is sized to the screen-width (default).  
    
Section [hotkeys]:
Hotkeys can be set to "off" by adding the word "off" to the definition.  
The two app-hotkeys defaults are:  
menuhotkey="!c", i.e. \[ALT] + \[c] to show the app-window
exithotkey="+!c", i.e. \[SHIFT] + \[ALT] + \[c] to exit the app and remove it from memory  
  
Primary hotkey modifiers:  
Hotkey prefix | Modifier Key |  Remark
------------ | ------------- | ------------- 
! | \[ALT] |
^ | \[CTRL] |
\# | \[WIN] |
\+ | \[SHIFT] |  
    
Other [Autohotkey Hotkeys](https://www.autohotkey.com/docs/Hotkeys.htm) hotkeys-characters are usable,  
but are untested.  
Only simple hotkeys are good to remember and fast to access!  

	
#### Buildin-functions:     
  
**shell**  
executes a command-shell with an \[ENTER] between each parameter and shows the result in a window.   
Uses normal parameters, not "send"-parametes, i.e. ... ,shellWR#cd \[tmp]#dir, ...
Exits the command-shell afterward.  
  
**showMessage**  
Shows a messagebox. Removed after time t (seconds).
Of form with delay (SEND-form), i.e. ... ,showMessage#themessage\~time, ...  
Time is in seonds, minimum is 1 second.         
      
**Examples:** 
TEST 1 explorer,,filemanager#c:\tmp  
Open explorer in the "c:\tmp" directory  
  
TEST 2 Show directory,,cmdline#cd \[tmp][E]\~#dir\[E]\~
Opens a command-shell, sends "cd C:\tmp" and "Enter" with no delay and then sends "dir".  
  
TEST 3,,notepad#test start^[E]\~3#test 2^[E]\~0#test end\[E]\~5#{Ctrl Down}w{Ctrl Up}\~1#n\~1,showMessage#Command finished!\~5
Opens the windows-notepad editor,  
enters "test start," ("^" is an alias for ",")
enters \[ENTER]-key and waits 3 seconds,
enters "test 2,", waits eternally (press Control-key to continue),
sends "test end" ad \[ENTER]-key , waits 5 seconds
sends notepad close commands with denying the save question,
shows "Command finished!" message, closes after 5 seconds.   
 
#### Hotkeys  
(fastswitch hotkeys see below)
  
Hotkey | Action
------------ | -------------
**\[ALT] + \[c]** | open app-window
**\[SHIFT] + \[ALT] + \[c]** | remove app from memory

**Hotkeys are configurable** -> \[Configuration-file].  
    
\[Hotkey modifier symbols](https://www.autohotkey.com/docs/Hotkeys.htm).  
Only simple Hotkey modifications are reflected in the app-window.  
(Parsing is limited to \[CTRL], \[ALT], \[WIN], \[SHIFT]).  
  
#### Fastswitch hotkeys
The purpose of Fastswitch hotkeys is to fast switch between already open windows.  
They are defined in the Hotkey-file: "cldfastswitch.txt".  
  
Format is: hotkey, app-title  
  
hotkey is a hotkey-definition, see [Autohotkey Hotkeys](https://www.autohotkey.com/docs/Hotkeys.htm)   
app-title is any part of the window-title and/or any [other criteria.](https://www.autohotkey.com/docs/misc/WinTitle.htm) of the Window Title.  
";" (is Comment) and "," (is separator) are not allowed inside hotkey definitions.  

Already defined in the included Hotkey-file:  
* Notepad++ with \[ALT] + \[n], i.e. "!n"
* Dopus with \[ALT] + \[d], i.e. "!d"

Primary hotkey modifiers:  
Hotkey prefix | Modifier Key |  Remark
------------ | ------------- | ------------- 
! | \[ALT] |
^ | \[CTRL] |
\# | \[WIN] |
\+ | \[SHIFT] |


#### Download  
[Download from github](https://github.com/jvr-ks/cmdlinedev/raw/master/cmdlinedev.exe)  
Virus check see below.  
  
#### Sourcecode: [Autohotkey format](https://www.autohotkey.com)  
* "cmdlinedev.ahk".  
  
#### Requirements  
* Windows 10 or later only.  
  
#### Sourcecode  
Github URL [github](https://github.com/jvr-ks/cmdlinedev).

#### Hotkeys
[Overview of all default Hotkeys used by my Autohotkey "tools"](https://github.com/jvr-ks/cmdlinedev/blob/master/hotkeys.md)
  
#### License: MIT  
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sub-license, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANT-ABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Copyright (c) 2020 J. v. Roos


##### Virus check at Virustotal 
[Check here](https://www.virustotal.com/gui/url/d31f7aa4dba0bc551702ea98e7c7398acea0625c363ef34497bb7733a9454be0/detection/u-d31f7aa4dba0bc551702ea98e7c7398acea0625c363ef34497bb7733a9454be0-1615483739
)  
Use [CTRL] + Click to open in a new window! 
