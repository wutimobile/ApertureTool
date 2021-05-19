-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--	get project name list
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on getProjectNameList()
	
	tell application "Aperture"
		
		return name of projects
		
	end tell
	
	return projectNameList
	
end getProjectNameList

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--	get project
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on getProject(projectName)
	
	tell application "Aperture"
		
		if (exists project projectName) is false then
			
			return missing value
			
		end if
		
		return project projectName
		
	end tell
	
end getProject

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--	process all image version metadata
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on processAllImageVersionMetadata()
	
	local versionDataList
	
	set nSkip to 0
	set nSaved to 0
	set nFail to 0
	
	tell application "Aperture"
		
		set theVersionList to image versions
		
		repeat with theVersion in theVersionList
			
			set flag to processVersionMetadata(theVersion) of me
			
			if flag is missing value then
				
				set nSkip to nSkip + 1
				
			else if flag is true then
				
				set nSaved to nSaved + 1
				
			else
				
				set nFail to nFail + 1
				
			end if
			
		end repeat
		
	end tell
	
	set theMessage to "versions "
	
	if nSaved > 0 then
		set theMessage to (theMessage & "saved #" & nSaved as string) & " "
	end if
	
	if nSkip > 0 then
		set theMessage to (theMessage & "skip #" & nSkip as string) & " "
	end if
	
	if nFail > 0 then
		set theMessage to (theMessage & "fail #" & nFail as string) & " "
	end if
	
	notify(theMessage, "Process #" & (nSkip + nSaved + nFail) as string)
	
end processAllImageVersionMetadata

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--	process project metadata
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on processProjectMetadata(theProject)
	
	local versionDataList
	
	set nSkip to 0
	set nSaved to 0
	set nFail to 0
	
	tell application "Aperture"
		
		tell theProject
			
			set theVersionList to image versions
			
		end tell
		
		repeat with theVersion in theVersionList
			
			set flag to processVersionMetadata(theVersion) of me
			
			if flag is missing value then
				
				set nSkip to nSkip + 1
				
			else if flag is true then
				
				set nSaved to nSaved + 1
				
			else
				
				set nFail to nFail + 1
				
			end if
			
		end repeat
		
	end tell
	
	set theMessage to "versions "
	
	if nSaved > 0 then
		set theMessage to (theMessage & "saved #" & nSaved as string) & " "
	end if
	
	if nSkip > 0 then
		set theMessage to (theMessage & "skip #" & nSkip as string) & " "
	end if
	
	if nFail > 0 then
		set theMessage to (theMessage & "fail #" & nFail as string) & " "
	end if
	
	notify(theMessage, ("Process #" & (nSkip + nSaved + nFail) as string) & " in project " & name of theProject)
	
end processProjectMetadata

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--	process project metadata
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on processVersionMetadata(theVersion)
	
	tell application "Aperture"
		
		tell theVersion
			
			set theName to name
			set theApertureId to id
			
			-- save 'version name' in IPTC core - Status Title
			if (exists the value of the IPTC tag named "ObjectName") then
				
				if the value of the IPTC tag named "ObjectName" is equal to theName then
					
					--	already saved, skip
					return missing value
					
				else
					
					--	this IPTC tag is used for other information
					return false
					
				end if
				
			else
				
				--	save
				make new IPTC tag with properties {name:"ObjectName", value:theName}
				return true
				
			end if
			
		end tell
		
	end tell
	
end processVersionMetadata

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--	display dialog 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
on info(info)
	
	tell application "Finder"
		
		set theResult to display dialog info buttons {"OK", "Cancel"} with icon note giving up after 5
		
		set button to button returned of theResult
		
		return (button is "OK")
		
	end tell
	
end info

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--	notify method
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on notify(theMessage, theTitle)
	
	tell application "Aperture"
		
		return (display notification theMessage with title theTitle)
		
	end tell
	
end notify

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--	choose method
--
--	return array / missing value (when user cancel dialog box)
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on choose(theTitle, promptString, itemList)
	
	set chosen to choose from list itemList Â
		with title theTitle Â
		with prompt Â
		promptString with multiple selections allowed
	
	if (chosen = false) then
		
		return missing value -- do nothing
		
	end if
	
	return chosen
	
end choose

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--	main
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on main()
	
	set apertureProjectNameList to getProjectNameList()
	
	set chosenList to choose("Preserve version name into IPTC Tag", "Choose Aperture Project to process", apertureProjectNameList)
	
	repeat with projectName in chosenList
		
		set apertureProject to getProject(projectName)
		
		processProjectMetadata(apertureProject)
		
	end repeat
	
end main

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--	run it
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
if info("Please open Aperture Library before run this script") then
	
	main()
	
end if

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--  EOF
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 