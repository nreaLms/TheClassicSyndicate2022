-----------------------------------------------------------------------------------------------
-- ModInit for The Classic Syndicate (TCS) ----------------------------------------------------
-----------------------------------------------------------------------------------------------

local ModInit = {
	Title = "The Classic Syndicate (2022)",

	CreatedBy = "_matti, Soapy, Nik",
	Version = "0.43a",
	
	PreBoot = false,

	Conflicts = {}
}

MIAMI_PrefferedStoryCar = "MIAMI_Default_PSX"
local EQUI_CARSSELECTION_SCHEME_NAME = "UI_MIAMI_PrefferedStoryCar"

-----------------------------------------------------------------------------------------------
-- Packages -----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

local TCS_LevelsPackage 		= ""
local TCS_MaterialsPackage 		= ""
local TCS_ModelsPackage 		= ""
local TCS_ResourcesPackage 		= ""
local TCS_ScriptsPackage 		= ""
local TCS_SoundsPackage 		= ""

-----------------------------------------------------------------------------------------------
-- Missions -----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

local TCS_MissionsIndex = -1

local TCS_MissionsList = {

	-----------------------------------------------------------------------------------------------
	-- DRIVER: Miami Missions

	"MIAMI_00",					-- Interview, Playable (HUD is placeholder)

}

-----------------------------------------------------------------------------------------------
-- Levels -------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

local PARKING_LevelName		=	"ParkingClassic"
local MIAMI_LevelName 		= 	"MiamiClassic"

local TCS_Levels = {

	PARKING_LevelName,
	MIAMI_LevelName,
	
}

-----------------------------------------------------------------------------------------------
-- Vehicles -----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

local TCS_Vehicles = {

	{"MIAMI_Default_PSX", 							"Miami - Default (PSX)"},
	{"MIAMI_Default_iOS",			 				"Miami - Default (iOS)"},

}

-----------------------------------------------------------------------------------------------
-- Audio --------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

local DRIVER_PoliceAudio_PSX = "scripts/sounds/DRIVER_PoliceAudio_PSX.txt"

function IsMyLevel()
	local levName = string.lower(world:GetLevelName())

	for i,n in ipairs(TCS_Levels) do
		if string.lower(n) == levName then
			return true
		end
	end
	
	return false
end

-----------------------------------------------------------------------------------------------
-- CVAR ---------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

local r_pp_bloom = console.FindCvar("r_pp_bloom")

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Initialization function -- Initialization function -- Initialization function -- Initialization function -- Initialization function -- Initialization function -- Initialization function --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function ModInit:Init()
	
	-----------------------------------------------------------------------------------------------
	-- Packages -----------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	TCS_LevelsPackage 		= self.Path .. "/TCS_Levels.epk"
	TCS_MaterialsPackage 	= self.Path .. "/TCS_Materials.epk"
	TCS_ModelsPackage 		= self.Path .. "/TCS_Models.epk"
	TCS_ResourcesPackage 	= self.Path .. "/TCS_Resources.epk"
	TCS_ScriptsPackage 		= self.Path .. "/TCS_Scripts.epk"
	TCS_SoundsPackage 		= self.Path .. "/TCS_Sounds.epk"


	fileSystem:AddPackage(TCS_LevelsPackage, SP_MOD)
	fileSystem:AddPackage(TCS_MaterialsPackage, SP_MOD)
	fileSystem:AddPackage(TCS_ModelsPackage, SP_MOD)
	fileSystem:AddPackage(TCS_ResourcesPackage, SP_MOD)
	fileSystem:AddPackage(TCS_ScriptsPackage, SP_MOD)
	fileSystem:AddPackage(TCS_SoundsPackage, SP_MOD)

	-----------------------------------------------------------------------------------------------
	-- Extra Stuff --------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	include("scripts/lua/TCS_CutsceneCamera.lua")
	include("scripts/lua/MIAMI_StoryEndScreen.lua")

	storySelectionItems = include("scripts/lua/MIAMI_PrefferedStoryCar.lua")

	-----------------------------------------------------------------------------------------------
	-- Audio --------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	EmitterSoundRegistry.DRIVER_Engines 	= 		"scripts/sounds/DRIVER_Engines.txt"
	EmitterSoundRegistry.DRIVER_Interview 	= 		"scripts/sounds/DRIVER_Interview.txt"
--	EmitterSoundRegistry.DRIVER_Voices 		= 		"scripts/sounds/DRIVER_Voices.txt"
--	EmitterSoundRegistry.DRIVER_SFX 		= 		"scripts/sounds/DRIVER_SFX.txt"
--	EmitterSoundRegistry.DRIVER_Messages 	= 		"scripts/sounds/DRIVER_Messages.txt"
--	EmitterSoundRegistry.DRIVER_World 		= 		"scripts/sounds/DRIVER_World.txt"

	CityTimeOfDayMusic[MIAMI_LevelName] = {
		day_clear 			= 		"miami_day",
		day_stormy 			= 		"la_day",
		dawn_clear 			= 		"frisco_night",
		night_clear 		= 		"miami_night",
		night_stormy 		= 		"nyc_night"
	}

	CopVoiceOver[MIAMI_LevelName] 					= DRIVER_PoliceAudio_PSX;	
	CopVoiceOver[string.lower(MIAMI_LevelName)] 	= DRIVER_PoliceAudio_PSX;

    OldMakeDefaultMissionSettings = MakeDefaultMissionSettings
    MakeDefaultMissionSettings = function()
    
		local settings = OldMakeDefaultMissionSettings()
		
		settings.KeepPursuitMusic = IsMyLevel()
		
		return settings
	end

	-----------------------------------------------------------------------------------------------
	-- CVAR ---------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	local saveBloom = r_pp_bloom:GetInt()

	OldSetupInitialSettings = SetupInitialSettings
	SetupInitialSettings = function()

		saveBloom = r_pp_bloom:GetInt()

		if IsMyLevel() then

			r_pp_bloom:SetInt(0)	-- Comment this line to enable bloom on Classic levels (not recommended)

		end
		
		OldSetupInitialSettings()
	end

	OldResetMissionTable = ResetMissionTable
	ResetMissionTable = function( shouldKeepData )

		r_pp_bloom:SetInt(saveBloom)

		OldResetMissionTable(shouldKeepData)
	end

	-----------------------------------------------------------------------------------------------
	-- Levels -------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------
	
	table.insert(MenuCityList, {MIAMI_LevelName, "Miami (Classic)"})

	-----------------------------------------------------------------------------------------------
	-- Vehicles -----------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	for i,v in ipairs(TCS_Vehicles) do
		table.insert(MenuCarsList, v)
	end

	-----------------------------------------------------------------------------------------------
	-- Minigames ----------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	table.insert(missions["minigame/survival"], {"MIAMI_Survival01", "Miami Classic (Miami Beach)"})

	table.insert(missions["minigame/getaway"], {"MIAMI_EuroDemo43", "Miami Classic (Euro Demo 43)"})

	-----------------------------------------------------------------------------------------------
	-- Missions -----------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	missions["TCS_STORY"] = TCS_MissionsList

	local MIAMI_MissionsElems = 
	{
		{
			label = "#MENU_SYNDICATE_NEWGAME",
			isFinal = true,
			onEnter = function(self, stack)
			
				-- Reset and Run Ladder
				missionladder:Run( "TCS_STORY", missions["TCS_STORY"] )

				return {}
			end,
		},
	}
	
	TCS_MissionsIndex = table.insert(StoryGameExtraElems, 
		MenuStack.MakeSubMenu("The Classic Story", storySelectionItems, nil, EQUI_CARSSELECTION_SCHEME_NAME))
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Deinitialization function -- Deinitialization function -- Deinitialization function -- Deinitialization function -- Deinitialization function -- Deinitialization function -- Deinitialization function --
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function ModInit:DeInit()

	-----------------------------------------------------------------------------------------------
	-- Audio --------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	ResetMissionTable = OldResetMissionTable
	SetupInitialSettings = OldSetupInitialSettings

	EmitterSoundRegistry.DRIVER_Engines 		= 		nil
	EmitterSoundRegistry.DRIVER_Interview 		= 		nil
--	EmitterSoundRegistry.DRIVER_Voices 			= 		nil
--	EmitterSoundRegistry.DRIVER_SFX 			= 		nil	
--	EmitterSoundRegistry.DRIVER_Messages 		= 		nil
--	EmitterSoundRegistry.DRIVER_World 			= 		nil

	-----------------------------------------------------------------------------------------------
	-- Camera -------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	TCS_CutsceneCamera = nil

	-----------------------------------------------------------------------------------------------
	-- Missions -----------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	table.remove(StoryGameExtraElems, TCS_MissionsIndex)
	missions["TCS_STORY"] = nil

	-----------------------------------------------------------------------------------------------
	-- Minigames ----------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	table.remove(missions["minigame/survival"], MIAMI_Survival01)

	table.remove(missions["minigame/getaway"], MIAMI_EuroDemo43)

	-----------------------------------------------------------------------------------------------
	-- Levels -------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	for i,v in ipairs(MenuCityList) do
	
		for ii,vv in ipairs(TCS_Levels) do
			if v[1] == vv then
				--table.remove( MenuCityList, i)
				MenuCityList[i] = nil
			end
		end
	end

	-----------------------------------------------------------------------------------------------
	-- Vehicles -----------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	for i,v in ipairs(MenuCarsList) do
	
		for ii,vv in ipairs(TCS_Vehicles) do
			if vv[1] == v[1] then
				--table.remove( MenuCarsList, i)
				MenuCarsList[i] = nil
			end
		end
	end
end

return ModInit