--//////////////////////////////////////////////////////////////////////////////////
--// Copyright © Inspiration Byte
--// 2009-2021
--//////////////////////////////////////////////////////////////////////////////////

local MIAMI_StoryEndScreen = class()

	SequenceScreens.Register("MIAMI_StoryEndScreen", MIAMI_StoryEndScreen)

	MIAMI_StoryEndScreen.schemeName = "resources/UI/MIAMI_StoryEndScreen_UI.res"

	function MIAMI_StoryEndScreen:__init() 
		self.control = nil
		self.done = false
		self.fade = 0
	end

	function MIAMI_StoryEndScreen:InitUIScheme( equiControl )
		self.control = equiControl
		self.bgChild = equi:Cast(self.control:FindChild("fade"), "panel")
		self.bgChild:SetColor(vec4(0, 0, 0, 1))
	end
	
	function MIAMI_StoryEndScreen:Update(delta)
	
		local color = 1.0 - self.fade
	
		self.bgChild:SetColor(vec4(0, 0, 0, color))
		
		if self.done then
			self.fade = self.fade - delta
		else
			self.fade = self.fade + delta
		end

		if self.fade > 1 then
			self.fade = 1
		end
	
		return self.fade > 0
	end
	
	function MIAMI_StoryEndScreen:Close()
		self.done = true
		SequenceScreens.current = nil
		EqStateMgr.ScheduleNextStateType( GAME_STATE_MAINMENU )
		
		missionladder:DeleteProgress("TCS_Story")
	end
	
	function MIAMI_StoryEndScreen:KeyPress(key, down)
		if (key == inputMap["ENTER"] or key == inputMap["JOY_A"]) and down == false then
			self:Close()
		end
	end
	
	function MIAMI_StoryEndScreen:MouseClick(x, y, buttons, down)
		if buttons == inputMap["MOUSE1"] then
			self:Close()
		end
	end
	