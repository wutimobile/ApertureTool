-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--	get project flatten list
--
--	Capture One Import
--		Aperture Projects which directly contain images
--	to
--		Group / Project / Album  contain the images
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on getCaptureOneProjects()
	
	tell application "Capture One 21"
		
		set projectList to {}
		
		tell current document
			
			--
			-- group first
			--
			set theGroupList to collections whose user is true and kind is group
			
			if (count of theGroupList) = 0 then
				
				return missing value
				
			end if
			
			repeat with theGroup in theGroupList
				
				tell theGroup
					
					--
					--
					--
					set projectList to projectList & (collections whose kind is project)
					
				end tell
				
			end repeat
			
		end tell
		
		return projectList
		
	end tell
	
end getCaptureOneProjects

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--	get variants list
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on getCaptureOneVariants(theProject)
	
	tell application "Capture One 21"
		
		return variants of theProject
		
	end tell
	
end getCaptureOneVariants

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--	purify variants IPTC tag
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on purifyVariant(theVariant)
	
	tell application "Capture One 21"
		
		tell theVariant
			
			--
			--	status title is set when we prepare Apple Aperture Library import
			--	if name is equal to status title, we do not need preserve it
			--
			if name is equal to status title then
				
				set status title to ""
				
				return true
				
			else
				
				return false
				
			end if
			
		end tell
		
	end tell
	
end purifyVariant

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--  notify method
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on notify(theMessage, theTitle)
	
	tell application "Capture One 21"
		
		return (display notification theMessage with title theTitle)
		
	end tell
	
end notify

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--	main
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
on main()
	
	set projectList to getCaptureOneProjects()
	
	set nPurified to 0
	set nVariant to 0
	
	repeat with project in projectList
		
		log "process project " & name of project
		
		set variantList to getCaptureOneVariants(project)
		
		repeat with theVariant in variantList
			
			set nVariant to nVariant + 1
			
			if purifyVariant(theVariant) is true then
				
				set nPurified to nPurified + 1
				
			end if
			
		end repeat
		
	end repeat
	
	notify(("Purified " & nPurified as string) & " variant(s)", ("#" & nVariant as string) & " variants") of me
	
end main

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--	run it
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
main()