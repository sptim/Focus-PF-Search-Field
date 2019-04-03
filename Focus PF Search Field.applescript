property focusedUIElement : missing value
tell application "System Events"
	if UI elements enabled then
		tell application process "Path Finder"
			set searchField to my findSearchField()
			if searchField is not missing value then
				if focused of searchField is true then
					if focusedUIElement is not missing value then
						try
							set focused of focusedUIElement to true
							return
						end try
					end if
					set theBrowser to my findBrowser(false)
					if theBrowser is not missing value then set focused of theBrowser to true
				else
					set focusedUIElement to my findBrowser(true)
					if focusedUIElement is not missing value then
						set focused of searchField to true
					end if
				end if
			end if
		end tell
	else
		try
			display alert "UI Scripting not allowed" message "Depending on how you invoke this script you have to allow 'Keyboard Maestro Engine', 'FastScripts', or 'Path Finder' to control your computer in the 'Accessibility' section of the 'Privacy' tab in 'Security & Privacy' system preferences pane." as critical buttons {"Open System Preferences", "Cancel"} default button 1 cancel button 2
			tell application "System Preferences"
				activate
				tell pane id "com.apple.preference.security"
					reveal anchor "Privacy_Accessibility"
					delay 1
					authorize
				end tell
			end tell
		end try
	end if
end tell

on findSearchField()
	tell application "System Events"
		set theWindow to window 1 of application process "Path Finder"
		if toolbars of theWindow is not {} then
			repeat with theGroup in groups of toolbar 1 of theWindow
				if text fields of theGroup is not {} then
					set searchFields to (text fields of theGroup whose subrole is "AXSearchField")
					if searchFields is not {} then return first item of searchFields
				end if
			end repeat
		end if
	end tell
	return missing value
end findSearchField

on findBrowser(isFocused)
	tell application "Path Finder"
		set currentView to current view of finder window 1
	end tell
	tell application "System Events"
		return my findBrowser_recurseSplitterGroups(window 1 of application process "Path Finder", currentView, isFocused)
	end tell
end findBrowser

on findBrowser_recurseSplitterGroups(theElement, currentView, isFocused)
	tell application "System Events"
		repeat with splitterGroup in splitter groups of theElement
			set theBrowser to my findBrowser_recurseGroups(splitterGroup, currentView, isFocused)
			if theBrowser is not missing value then return theBrowser
			set theBrowser to my findBrowser_recurseSplitterGroups(splitterGroup, currentView, isFocused)
			if theBrowser is not missing value then return theBrowser
		end repeat
	end tell
	return missing value
end findBrowser_recurseSplitterGroups

on findBrowser_recurseGroups(theElement, currentView, isFocused)
	tell application "System Events"
		repeat with theGroup in groups of theElement
			if currentView is "column view" then
				try
					if isFocused then
						repeat with scrollArea in (get scroll areas of scroll area 1 of browser 1 of theGroup)
							if focused of list 1 of scrollArea is true then return scrollArea
						end repeat
					else
						return last scroll area of scroll area 1 of browser 1 of theGroup
					end if
				end try
			else if currentView is "list view" then
				try
					if isFocused then
						if (get outlines of scroll area 1 of theGroup whose focused is true) is not {} then
							return scroll area 1 of theGroup
						end if
					else
						get outline 1 of scroll area 1 of theGroup
						return scroll area 1 of theGroup
					end if
				end try
			else if currentView is "icon view" then
				try
					if (get accessibility description of UI element 1 of scroll area 1 of theGroup) is "Image browser" then
						if not isFocused or focused of UI element 1 of scroll area 1 of theGroup is true then return scroll area 1 of theGroup
					end if
				end try
			end if
			set theBrowser to my findBrowser_recurseGroups(theGroup, currentView, isFocused)
			if theBrowser is not missing value then return theBrowser
		end repeat
	end tell
	return missing value
end findBrowser_recurseGroups