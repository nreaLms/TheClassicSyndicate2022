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
-- Missions Indexes ---------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

local MIAMI_MissionsIndex = -1

-----------------------------------------------------------------------------------------------
-- Missions Lists -----------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

local MIAMI_MissionsList = {

	-----------------------------------------------------------------------------------------------
	-- DRIVER: Miami Missions

	"MIAMI_00",					-- Interview									O		Playable, Complete
--	"MIAMI_NextMessage",		-- The Bank Job (Message)						O		------------------
--	"MIAMI_01",					-- The Bank Job									O		Playable, Complete
--	"MIAMI_NextMessage",		-- Hide The Evidence (Message)					O		------------------
--	"MIAMI_02",					-- Hide The Evidence							O		Playable, Complete
--	"MIAMI_NextMessage",		-- Ticco's Ride (Message)						O		------------------
--	"MIAMI_03",					-- Ticco's Ride									O		Playable, Complete
--	"MIAMI_NextMessage",		-- The Clean Up (Message)						O		------------------
--	"MIAMI_04a",				-- The Clean Up (Part 1)						O		Playable, Complete
--	"MIAMI_04b",				-- The Clean Up (Part 2)						O		Playable, Complete
--	"MIAMI_NextMessage",		-- Case For A Key (Message)						O		------------------
--	"MIAMI_05a",				-- Case For A Key								O		Playable, Complete
--	"MIAMI_05b",				-- Case For A Key (Part 2)						O		Playable, Complete
--	"MIAMI_05c",				-- Case For A Key (Part 3)						O		Playable, Complete
--	"MIAMI_NextMessage",		-- Tanner Meets Rufus (Message)					O		------------------
--	"MIAMI_06", 				-- Tanner Meets Rufus							O		Playable, Complete
--	"MIAMI_07a",				-- Bust Out Jean Paul							O		Playable, Complete
--	"MIAMI_07b",				-- Bust Out Jean Paul (Part 2)					O		Playable, Complete
--	"MIAMI_NextMessage",		-- Payback (Message)							O		------------------
--	"MIAMI_08", 				-- Payback										O		Playable, Complete	
--	"MIAMI_NextMessage",		-- A Shipment's Coming In (Message)				O		------------------
--	"MIAMI_09", 				-- A Shipment's Coming In						O		Playable, Complete	
--	"MIAMI_NextMessage",		-- Superfly Drive (Message)						O		------------------
--	"MIAMI_10",					-- Superfly Drive								O		Playable, Complete	
--	"MIAMI_NextMessage",		-- Take Out Di Angio's Car (Message)			O		------------------
--	"MIAMI_11", 				-- Take Out Di Angio's Car						O		Playable, Complete	
--	"MIAMI_NextMessage",		-- Bait for a Trap (Message)					O		------------------
--	"MIAMI_12",					-- Bait for a Trap								O		Playable, Complete
--	"MIAMI_13", 				-- The Informant								O		Playable, Complete

--	{screen = "MIAMI_StoryEndScreen"}
}

-----------------------------------------------------------------------------------------------
-- Levels Aliases -----------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

local MIAMI_LevelName 		= 	"MiamiClassic"

-----------------------------------------------------------------------------------------------
-- Levels Grouping ----------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

local TCS_Levels = {

	MIAMI_LevelName,
	
}

-----------------------------------------------------------------------------------------------
-- Vehicles Listing ---------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

local TCS_Vehicles = {

}

-----------------------------------------------------------------------------------------------
-- Police Audio Scripts -----------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

local DRIVER_PoliceAudio_PSX = "scripts/sounds/DRIVER_PoliceAudio_PSX.txt"

-----------------------------------------------------------------------------------------------
-- Levels Using Keep Pursuit Option -----------------------------------------------------------
-----------------------------------------------------------------------------------------------

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
-- Specify CVAR Alias -------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

local r_pp_bloom = console.FindCvar("r_pp_bloom")

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Initialization function -- Initialization function -- Initialization function -- Initialization function -- Initialization function -- Initialization function -- Initialization function --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function ModInit:Init()
	
	-----------------------------------------------------------------------------------------------
	-- Load Packages ------------------------------------------------------------------------------
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
	-- Load Other Stuff ---------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	include("scripts/lua/MIAMI_CinematicCamera.lua")
	include("scripts/lua/MIAMI_StoryEndScreen.lua")

	storySelectionItems = include("scripts/lua/MIAMI_PrefferedStoryCar_Script.lua")

	-----------------------------------------------------------------------------------------------
	-- Load Audio Scripts -------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	EmitterSoundRegistry.DRIVER_Engines 	= 		"scripts/sounds/DRIVER_Engines.txt"
	EmitterSoundRegistry.DRIVER_Interview 	= 		"scripts/sounds/DRIVER_Interview.txt"
--	EmitterSoundRegistry.DRIVER_Voices 		= 		"scripts/sounds/DRIVER_Voices.txt"
--	EmitterSoundRegistry.DRIVER_SFX 		= 		"scripts/sounds/DRIVER_SFX.txt"
--	EmitterSoundRegistry.DRIVER_Messages 	= 		"scripts/sounds/DRIVER_Messages.txt"
--	EmitterSoundRegistry.DRIVER_World 		= 		"scripts/sounds/DRIVER_World.txt"

	SetLevelLoadCallbacks("DRIVER_Music", function() 
			sounds:LoadScript("scripts/sounds/DRIVER_Music.txt")
	end, nil)
	
	-----------------------------------------------------------------------------------------------
	-- Set Custom Police Script for Levels --------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	CopVoiceOver[MIAMI_LevelName] 					= DRIVER_PoliceAudio_PSX;	
	CopVoiceOver[string.lower(MIAMI_LevelName)] 	= DRIVER_PoliceAudio_PSX;
	
	-----------------------------------------------------------------------------------------------
	-- Music State Logic --------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

    OldMakeDefaultMissionSettings = MakeDefaultMissionSettings
    MakeDefaultMissionSettings = function()
    
		local settings = OldMakeDefaultMissionSettings()
		
		settings.KeepPursuitMusic = IsMyLevel()
		
		return settings
	end

	-----------------------------------------------------------------------------------------------
	-- Store Old CVAR Value & Apply New One -------------------------------------------------------
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
	-- Music Selection For Each Level -------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	CityTimeOfDayMusic[MIAMI_LevelName] = {
		day_clear 			= 		"miami_day",
		day_stormy 			= 		"la_day",
		dawn_clear 			= 		"frisco_night",
		night_clear 		= 		"miami_night",
		night_stormy 		= 		"nyc_night"
	}

	-----------------------------------------------------------------------------------------------
	-- Add Levels To Selection List ---------------------------------------------------------------
	-----------------------------------------------------------------------------------------------
	
	table.insert(MenuCityList, {MIAMI_LevelName, "Miami (Classic)"})

	-----------------------------------------------------------------------------------------------
	-- Add Vehicles To Selection List -------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	for i,v in ipairs(TCS_Vehicles) do
		table.insert(MenuCarsList, v)
	end

	-----------------------------------------------------------------------------------------------
	-- Load Minigames -----------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	table.insert(missions["minigame/survival"], {"MIAMI_Survival01", "Miami Classic (Miami Beach)"})

	table.insert(missions["minigame/getaway"], {"MIAMI_EuroDemo43", "Miami Classic (Euro Demo 43)"})

	-----------------------------------------------------------------------------------------------
	-- Load Missions ------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	missions["TCS_STORY"] = MIAMI_MissionsList

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
	
	MIAMI_MissionsIndex = table.insert(StoryGameExtraElems, 
		MenuStack.MakeSubMenu("The Classic Story", storySelectionItems, nil, EQUI_CARSSELECTION_SCHEME_NAME))
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Deinitialization function -- Deinitialization function -- Deinitialization function -- Deinitialization function -- Deinitialization function -- Deinitialization function -- Deinitialization function --
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function ModInit:DeInit()

	-----------------------------------------------------------------------------------------------
	-- Unload Mission Table -----------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	ResetMissionTable = OldResetMissionTable
	SetupInitialSettings = OldSetupInitialSettings

	-----------------------------------------------------------------------------------------------
	-- Unload Audio Scripts -----------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	EmitterSoundRegistry.DRIVER_Engines 		= 		nil
	EmitterSoundRegistry.DRIVER_Interview 		= 		nil
--	EmitterSoundRegistry.DRIVER_Voices 			= 		nil
--	EmitterSoundRegistry.DRIVER_SFX 			= 		nil	
--	EmitterSoundRegistry.DRIVER_Messages 		= 		nil
--	EmitterSoundRegistry.DRIVER_World 			= 		nil

	SetLevelLoadCallbacks("DRIVER_Music", nil, nil)


	-----------------------------------------------------------------------------------------------
	-- Unload Camera ------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	MIAMI_CinematicCamera = nil

	-----------------------------------------------------------------------------------------------
	-- Unload Missions ----------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	table.remove(StoryGameExtraElems, MIAMI_MissionsIndex)
	missions["TCS_STORY"] = nil

	-----------------------------------------------------------------------------------------------
	-- Unload Minigames ---------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------

	table.remove(missions["minigame/survival"], MIAMI_Survival01)

	table.remove(missions["minigame/getaway"], MIAMI_EuroDemo43)

	-----------------------------------------------------------------------------------------------
	-- Unload Levels ------------------------------------------------------------------------------
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
	-- Unload Vehicles ----------------------------------------------------------------------------
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