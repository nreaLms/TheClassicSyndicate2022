--//////////////////////////////////////////////////////////////////////////////////
--// Copyright � Inspiration Byte
--// 2009-2020
--//////////////////////////////////////////////////////////////////////////////////

local StoryCarsList = {
	{"MIAMI_Default_PSX", 	"Miami - Default (PSX)"},
	{"MIAMI_Default_iOS", 	"Miami - Default (iOS)"},
}

function MIAMI_GetPlayerCarName()
	local storyPreferences = RestoreMissionCompletionData("MIAMI_StoryPreferences")
	if storyPreferences ~= nil then
		MIAMI_PrefferedStoryCar = storyPreferences.PrefferedStoryCar
	end
	
	-- reset in some paranoid cases
	if MIAMI_PrefferedStoryCar == nil then
		MIAMI_PrefferedStoryCar = "MIAMI_Default_PSX"
	end
	
	return MIAMI_PrefferedStoryCar
end

local function MIAMI_CarSelectionElementsFunc(equiScheme, stack)

	-- reset car type if mods were disabled
	if MenuStack.FindChoiceIndex(StoryCarsList, MIAMI_PrefferedStoryCar) == -1 then
		MIAMI_PrefferedStoryCar = StoryCarsList[1][1]
	end
	
	-- init elements
	local selElem = {}
	local prevElem = {}
	local nextElem = {}

	selElem.ui = equi:Cast(equiScheme:FindChild("carselection_img"), "image")
	selElem.ui:SetMaterial("UI/Vehicles/"..MIAMI_PrefferedStoryCar)

	prevElem.ui = equi:Cast(equiScheme:FindChild("carselection_prev"), "image")
	prevElem.ui:SetMaterial("UI/Vehicles/"..MIAMI_PrefferedStoryCar)

	nextElem.ui = equi:Cast(equiScheme:FindChild("carselection_next"), "image")
	nextElem.ui:SetMaterial("UI/Vehicles/"..MIAMI_PrefferedStoryCar)

	-- make update function to show and hide prev/next items
	local updateItems = function()
		local value = MIAMI_PrefferedStoryCar
		local choiceIdx = MenuStack.FindChoiceIndex(StoryCarsList, value)
		
		local imageName = "UI/Vehicles/"..value
		
		-- check for image existence
		if not fileSystem:FileExist("materials/"..imageName..".mat", SP_MOD) then
			imageName = "UI/Vehicles/unknown_vehicle"
		end
		
		selElem.ui:SetMaterial(imageName)
		
		if choiceIdx-1 > 0 then
			value = StoryCarsList[choiceIdx-1][1]
			imageName = "UI/Vehicles/"..value
		
			-- check for image existence
			if not fileSystem:FileExist("materials/"..imageName..".mat", SP_MOD) then
				imageName = "UI/Vehicles/unknown_vehicle"
			end
		
			prevElem.ui:SetMaterial(imageName)
			prevElem.ui:Show()
		else
			prevElem.ui:Hide()
		end
		
		if choiceIdx+1 <= #StoryCarsList then
			value = StoryCarsList[choiceIdx+1][1]
			
			imageName = "UI/Vehicles/"..value
		
			-- check for image existence
			if not fileSystem:FileExist("materials/"..imageName..".mat", SP_MOD) then
				imageName = "UI/Vehicles/unknown_vehicle"
			end
			
			nextElem.ui:SetMaterial(imageName)
			nextElem.ui:Show()
		else
			nextElem.ui:Hide()
		end		
	end
	
	updateItems() -- first time update
	
	local movetime = 0
	local movedir = 1

	-- make get/set for both CVar and element
	local currentCarNameGetSet = { 
		get = function()
			return MIAMI_PrefferedStoryCar
		end,
		set = function(value, dir)
			movetime = 0.25
			movedir = dir
			
			MIAMI_PrefferedStoryCar = value
			
			updateItems()
		end
	}
	
	-- this updates UI every frame
	stack.updateFunc = function(delta)

		local moveVal = movetime*movetime * 1.0
		local scale = 1.0 - moveVal*4
		selElem.ui:SetTransform(vec2(movetime * movedir * 500, 0), vec2(scale,scale), movedir * movetime * 25.0)
		
		local unselScale = 0.75+movetime
	
		if movedir < 0 then
			nextElem.ui:SetTransform(vec2(movetime * -80, movetime * 80), vec2(unselScale,unselScale), 0)
			prevElem.ui:SetTransform(vec2(0, 0), vec2(0.75,0.75), 0)
		else
			prevElem.ui:SetTransform(vec2(movetime * 80, movetime * 80), vec2(unselScale,unselScale), 0)
			nextElem.ui:SetTransform(vec2(0, 0), vec2(0.75,0.75), 0)
		end
		
		if movetime > 0 then
			movetime = movetime-delta
		end
	end

	-- make menu elements
	-- car selection, city selection and time of day
	local elems = {
		MenuStack.MakeChoiceParam("< %s >", currentCarNameGetSet, StoryCarsList),
		{
			label = "#MENU_SYNDICATE_NEWGAME",
			isFinal = true,
			onEnter = function(self, stack)
			
				-- first store for MIAMI
				StoreMissionCompletionData("MIAMI_StoryPreferences", {
					PrefferedStoryCar = MIAMI_PrefferedStoryCar
				})
							
				-- Reset and run ladder
				missionladder:Run( "TCS_STORY", missions["TCS_STORY"] )

				return {}
			end,
		},
	}
	
	return elems
end

-- return entire menu item function
return MIAMI_CarSelectionElementsFunc