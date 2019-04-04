(*
Save as Application / Script Bundle
Include payload.kmmacros and payload.zip in Resources
payload.zip contains
   -  Library/Scripts/Applications/Path Finder/Focus PF Search Field.scpt
   -  Library/Services/Focus PF Search Field.workflow/
*)

set kmMacros to alias ((path to me as text) & "Contents:Resources:payload.kmmacros")
set zipPath to POSIX path of alias ((path to me as text) & "Contents:Resources:payload.zip")
set postURL to "https://sptim.micro.blog/2019/04/05/replacement-for-path.html"

display dialog "Install the AppleScript and Automator Quick Action (Service) for focusing the search field in Path Finder" buttons {"Install", "Quit"} default button 1 cancel button 2 with title "Focus PF Search Field"
do shell script ("cd && unzip -o " & quoted form of zipPath)

try
	get alias ((get path to applications folder as text) & "Keyboard Maestro.app:")
	display dialog "Install Keyboard Maestro Macro to run the AppleScript" buttons {"Install", "Skip"} default button 1 cancel button 2 with title "Focus PF Search Field"
	tell application "Keyboard Maestro" to open kmMacros
end try

display dialog "Installation completed.
You should now configure the keyboard shortcut. See blog post (" & postURL & ") for further informations." buttons {"Open Blog Post", "Quit"} default button 1 cancel button 2 with title "Focus PF Search Field"
do shell script ("open " & quoted form of postURL)
