-- by Nathan Grigg


on main()
	set typeset_lib_file to path_to_contents() & "Resources/typeset-lib.scpt"
	set typeset_lib to load script POSIX file typeset_lib_file
	tell typeset_lib
		set doc to get_front_BBEdit_doc()
		set filename to get_filename for doc
		set err_list to parse_errors from filename with warnings
	end tell

	if length of err_list is 0 then
		display dialog "There are no errors or warnings"
	else
		tell application "BBEdit" to make new results browser with data err_list with properties {name:"Log Warnings and Errors"}
	end if
end main

-- Catch and display custom errors; exit silently on cancelled dialogs
try
	main()
on error eStr number eNum partial result rList from badObj to exptectedType
	if eNum = 5033 then
		display dialog eStr buttons {"OK"} with title "Error" default button 1
	else if eNum = 5088 then
		beep
	else if eNum is not -128 then
		error eStr number eNum partial result rList from badObj to exptectedType
	end if
end try

on path_to_contents()
	--- Returns path to "Contents" folder containing the current script
	local delims, split_string
	set delims to AppleScript's text item delimiters
	set AppleScript's text item delimiters to "/Contents/"
	set split_string to text items of POSIX path of (path to me)
	set AppleScript's text item delimiters to delims
	if length of split_string = 1 then error "This script must remain inside the Latex BBEdit package because it depends on other scripts in that package." number 5033
	return (item 1 of split_string) & "/Contents/"
end path_to_contents

