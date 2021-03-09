#### Latest changes: 
[-> README](README.md)
 
* Build in fastswitch functionality:  
* * notepad Hotkey = \[Alt] + \[n]-key default
* * dopus Hotkey= \[Alt] + \[d]-key default  
* \[Ctrl] + \[Shift]-key | Execute third command only  
* \[Alt] + \[Shift]-key | Execute forth command only  
* "hidewindow" parameter failure removed  
* Memory-leak removed  
* Working directory alias "\[...]" can be used inside shortcut definitions.  
* Saving window size and position  (still under construction!)  
* List of dir/commands changed to multi columns  
Configuration-file: -> [config] -> menuDelimCharacter removed  
* Autohide on minimize window and focus lost!  
* Start app running in background with start-parameter "hidegui" changed to **"hidewindow"**  
* App window is automatically hidden (moved to background) after selecting a command  
* **Switched to 64bit exe, i.e. now runs on 64bit Windows only.**  
* Instead [Ctrl]-v there is a new button: "Insert URL/Firefox"  
Generates a new entry with name "New" and contents from clipboard as a parameter to command "FireFox".    
(if clipboard is not emtpy)    
Path defaults to empty working-directory.  
* New Gui  
* Additional column (1st!) with the name of the entry  
* **File encoding of all files: UTF-8 (no BOM).**  
To use special characters as a delimiter in the menu,    
the Configuration-file must be ANSI encoded,  
because Windows cannot display UTF-8 characters in the menu.  
* New (Configuration-file: -> [config] -> menuDelimCharacter)  
* **"!" send-delay separator character changed to "\~"**  
* New SEND mechanism   
After starting a program it is possible to send up to 6 SEND-arguments, 
each with configurable delay between.   
The parameter must contain a "\~" character.   
Characters before the "\~" are the SEND-argument, after it is the delay after the send (seconds).  
  
Example (a demonstration only, "ClickandSleep" is more adequate for such a task!):  
**[_wksp][scL]\__testarea,wsl#sudo su{ENTER}\~12#whoami[E]\~3#apt-get update[E]\~15#apt-get dist-upgrade[E]\~60#apt autoremove[E]\~20,#exit[E]exit[E]exit[E]\~2**  
  
Line by line description:  
("#" is the parameter delimiter)  
  
**[_wksp][scL]\__testarea**    
Select the working directory.  
[_wksp] and [scL] are shortcuts lookedup in the Shortcuts-file.  
     
~~Tip: You can mark the first entry as a comment by including a "!" character anywere inside,  
if the path is not used.~~     
Changed: First entry is the name! 
    
**wsl**  
Lookup "wsl" in the Tools-file (default is: "cldtools.txt"), found:  
%windir%\System32\WindowsPowerShell\v1.0\powershell.exe "%windir%\sysnative\wsl.exe"  
starting a 64-bit powershell (in my directory [_wksp][scL]\__testarea) with wsl (Windows-Subsystem for Linux) inside.   
  
  
**\#sudo su{ENTER}\~10**    
Sending "sudo su" + Enter-key to wsl (changing to user "root"), waiting 12 seconds delay, 
time enought to enter password manually.   
(I don't want to delete mmy password every time I upload to github ... :-) ). 
  
**\#whoami[E]\~2**  
Sending "whoami", looking upd the "[E]" shortcut in the Shortcuts-file, found {ENTER} which is the Enter-key, sending it.    
  
**\#apt-get update[E]\~15**    
Sending "apt-get update" + Enter-key, waiting 15 seconds delay afterwards.  
  
**\#apt-get dist-upgrade[E]\~60**    
Sending "apt-get dist-upgrade", waiting 60 seconds delay.  
  
**\#apt autoremove[E]\~20**  
Sending "apt autoremove", waiting 20 seconds delay. 
  
**#exit[E]exit[E]#exit[E]\~2**  
send 3 times exit + {ENTER], each with a 2 seconds delay.  
(Maximum of 6 parameters already reached!) 

I have an extra **#exit[E]\~2#exit[E]\~2#exit[E]\~2** command, to close the wsl-shell in case of an command-abort.   
  
**To hold on the running operation press the [CAPSLOCK]-key! **  
Then you can:  
1. Do things manually
2. Press [CTRL] to abort operation

Releasing the [CAPSLOCK]-key continues operation.  

  
* Bug regarding %...% corrected  
* Default start behavior has been changed: Menu always showing after start!  
To hide menu use "hidemenu" parameter!  
(Batchfile: "create_cmdlinedev_exe_link_with_hidemenu_in_autostartfolder.bat" is included)  
* New powershell batch: "create_cmdlinedev_exe_link_in_autostartfolder.bat"  
* Default-hotkey changed to **[ALT + c]**  
* New: Because the working-path (first line-entry in the directories-file) is often repeated multible times in the line,  
the builtin shortcut "[...]" can now be used as an alias of the working directory.   
* New menu entry: Edit Shortcuts-file  
* Closing notepad++ after editing Directories-file, Tools-file, Shortcuts-file or Ini-file autorefreshs the menu.  
* ~~Directories-file first entry (the path) can be used as a comment, if no path is required, or the paths is set by an argumnt.  
 Enclose the comment in square brackets exclamation marks: [comment] changed to: **!comment!**~~  
* New shortcut-mechanism   
* New menu entry: Edit Ini-file  
The Ini-file contains the hotkey-definitions and the path to notepad++, used in the menu Edit XXX commands.  
* Additional key-functions in the menu:  
[Ctrl] + click on a command-entry: edit this command.  
* Now up to 6 parameters are usable   
To use the Directory Opus filemanager with split screen additional parameters are needed.  
  
An Example (using "dopusrt.exe", not "dopus.exe"!):  
To open two directories the command structure to use is:    
"C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe" /acmd Go "C:\directory1" NEWTAB OPENINLEFT DUALPATH "C:\directory2"  
  
This translates to the Directories-file "clddirectories.txt" entry:  
C:\directory1,dopusrt# /acmd Go # C:\directory1 # NEWTAB OPENINLEFT DUALPATH # C:\directory2, ...  

"C:\directory1" is ignored in this case, but is usefull for identification of the entry.  
  
There are no blanks between parameters by default, so you have to add them.  

I use this entry to open cmdlinedev development environment :-)
%_ahk%cmdlinedev,dopusrt# /acmd Go # %_ahk%cmdlinedev # NEWTAB OPENINLEFT DUALPATH # %_ahk%cmdlinedev\hidden,notepad#%_nppsess%cmdlinedev.npp-session  

%_ahk% is an evironment-variable which is expanded to my Autohotkey working directory,
as is %_nppsess%, which is expanded to the directory holding the np++ Session-manager pluging definition files.  
  
A little drawback: np++ opens all files of the session, but in an anonymous session called [None]
  
   
* Enviroment variables are not expanded in the menu, so it is more readable  
* Often used paths can be defined as your own environment-variables (via Windows)   
* Environment-variable expansion for arguments  
* Environment-variable expansion  
* Arguments: Add "#" followed by the argument.  
Commas inside arguments must be replaced by a "^".  
   
Example (a line in the Directories-file):  
some directory,notepad#cmdlinedev.ahk  
opens "cmdlinedev.ahk" with notepad++ if notepad++ is defined as the tool "notepad" in the Tools-file.  
    
If no tool is specified or found, the entris are treated as files and the Windows file-extension mechanism is used to open the file,  
i.e. some directory,cmdlinedev.ahk would start Autohotkey.exe (if it is installed) and start interpreting the file "cmdlinedev.ahk",  
i.e. this tool ... 
   
- If you have thunderbird, you can send me an email if you like. Press [ALT + t] and select the line ",email ...".   
(Using the supplied Directories-file and Tools-file.)  

##### TODO:  


[-> README](README.md)


