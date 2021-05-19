-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- get project name list
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on getProjectNameList()
	
	tell application "Aperture"
		
		return name of projects
		
	end tell
	
	return projectNameList
	
end getProjectNameList

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- get project
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
-- process all image version metadata
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on processAllImageVersionMetadata()
	
	local versionDataList
	
	set nVersion to 0
	
	tell application "Aperture"
		
		set theVersionList to image versions
		
		repeat with theVersion in theVersionList
			
			processVersionMetadata(theVersion) of me
			
			set nVersion to nVersion + 1
			
		end repeat
		
	end tell
	
	notify(("Process " & nVersion as string) & " version", "")
	
end processAllImageVersionMetadata

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- process project metadata
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on processProjectMetadata(theProject)
	
	local versionDataList
	
	set versionDataList to {}
	
	tell application "Aperture"
		
		tell theProject
			
			set theVersionList to image versions
			
		end tell
		
		repeat with theVersion in theVersionList
			
			set versionData to processVersionMetadata(theVersion) of me
			
			set versionDataList's end to versionData
			
		end repeat
		
	end tell
	
	notify(("Process " & (count of versionDataList) as string) & " version", "Project " & name of theProject)
	
	return versionDataList
	
end processProjectMetadata

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- process project metadata
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on processVersionMetadata(theVersion)
	
	tell application "Aperture"
		
		tell theVersion
			
			set theName to name
			set theApertureId to id
			
			-- save 'version name' in IPTC core - Status Title
			if (exists the value of the IPTC tag named "ObjectName") then
				delete IPTC tag named "ObjectName"
			end if
			make new IPTC tag with properties {name:"ObjectName", value:theName}
			
		end tell
		
	end tell
	
	return {theApertureId, theName}
	
end processVersionMetadata

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- display dialog 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
on info(info)
	
	tell application "Aperture"
		
		display dialog info buttons {"OK"} with icon note giving up after 2
		
	end tell
	
end info

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--  notify method
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on notify(theMessage, theTitle)
	
	tell application "Aperture"
		
		return (display notification theMessage with title theTitle)
		
	end tell
	
end notify

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--  choose method
--
-- return array / missing value (when user cancel dialog box)
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on choose(theTitle, promptString, itemList)
	
	set chosen to choose from list itemList �
		with title theTitle �
		with prompt �
		promptString with multiple selections allowed
	
	if (chosen = false) then
		
		return missing value -- do nothing
		
	end if
	
	return chosen
	
end choose

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--  main
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- processAllImageVersionMetadata()

set apertureProjectNameList to getProjectNameList()

set chosenList to choose("Aperture tool", "Save version name into IPTC Tag", apertureProjectNameList)

repeat with projectName in chosenList
	
	set apertureProject to getProject(projectName)
	
	processProjectMetadata(apertureProject)
	
end repeat

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--  EOF
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 