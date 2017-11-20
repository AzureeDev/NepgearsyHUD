MenuCallbackHandler.NepgearsyHUD_LanguageSelection_Callback = function(self, item)
	NepgearsyHUD.Data.NepgearsyHUD_LanguageSelection_Value = item:value()
	NepgearsyHUD:Save()
end

MenuCallbackHandler.NepgearsyHUD_DisableMinimap_Callback = function(self, item)
	NepgearsyHUD.Data.NepgearsyHUD_DisableMinimap_Value = (item:value() == "on" and true or false)
	NepgearsyHUD:Save()
end

MenuCallbackHandler.NepgearsyHUD_ForceMinimap_Callback = function(self, item)
	NepgearsyHUD.Data.NepgearsyHUD_ForceMinimap_Value = (item:value() == "on" and true or false)
	NepgearsyHUD:Save()
end

MenuCallbackHandler.NepgearsyHUD_EnableXPInHud_Callback = function(self, item)
	NepgearsyHUD.Data.NepgearsyHUD_EnableXPInHud_Value = (item:value() == "on" and true or false)
	NepgearsyHUD:Save()
end

MenuCallbackHandler.NepgearsyHUD_ZoomMinimap_Callback = function(self, item)	
	NepgearsyHUD.Data.NepgearsyHUD_ZoomMinimap_Value = item:value()
	NepgearsyHUD:Save()
end

MenuCallbackHandler.NepgearsyHUD_SizeMinimap_Callback = function(self, item)
	NepgearsyHUD.Data.NepgearsyHUD_SizeMinimap_Value = item:value()
	NepgearsyHUD:Save()
end

MenuCallbackHandler.NepgearsyHUD_EnableHorizontalCrewSetup_Callback = function(self, item)
	NepgearsyHUD.Data.NepgearsyHUD_EnableHorizontalCrewSetup_Value = (item:value() == "on" and true or false)
	NepgearsyHUD:Save()
end

MenuCallbackHandler.NepgearsyHUD_Starring_Text_Callback = function(self, item)
	NepgearsyHUD.Data.NepgearsyHUD_Starring_Text_Value = item:value()
	NepgearsyHUD:Save()
end

MenuCallbackHandler.NepgearsyHUD_Starring_Color_Callback = function(self, item)
	NepgearsyHUD.Data.NepgearsyHUD_Starring_Color_Value = item:value()
	NepgearsyHUD:Save()
end

MenuCallbackHandler.NepgearsyHUD_CompactAssaultStateMode_Callback = function(self, item)	
	NepgearsyHUD.Data.NepgearsyHUD_CompactAssaultStateMode_Value = item:value()
	NepgearsyHUD:Save()
end

MenuCallbackHandler.NepgearsyHUD_EnableChatMessages_Callback = function(self, item)
	NepgearsyHUD.Data.NepgearsyHUD_EnableChatMessages_Value = (item:value() == "on" and true or false)
	NepgearsyHUD:Save()
end

MenuCallbackHandler.NepgearsyHUD_AssaultBarThickness_Callback = function(self, item)	
	NepgearsyHUD.Data.NepgearsyHUD_AssaultBarThickness_Value = item:value()
	NepgearsyHUD:Save()
end

MenuCallbackHandler.NepgearsyHUD_Enable_KWP_Callback = function(self, item)	
	NepgearsyHUD.Data.NepgearsyHUD_Enable_KWP_Value = (item:value() == "on" and true or false)
	NepgearsyHUD:Save()
end

MenuCallbackHandler.NepgearsyHUD_EnableTeammatePanel_Callback = function(self, item)	
	NepgearsyHUD.Data.NepgearsyHUD_EnableTeammatePanel_Value = (item:value() == "on" and true or false)
	NepgearsyHUD:Save()
end

NepgearsyHUD:Load()

Hooks:Add("LocalizationManagerPostInit", "NepHud_Localization", function(loc)
	local language_picked = NepgearsyHUD.Data["NepgearsyHUD_LanguageSelection_Value"] or 1
	loc:load_localization_file( NepgearsyHUD.Localization[language_picked] )
end)

MenuHelper:LoadFromJsonFile(ModPath .. "/menu/main.json", NepgearsyHUD, NepgearsyHUD.Data)
MenuHelper:LoadFromJsonFile(ModPath .. "/menu/hud.json", NepgearsyHUD, NepgearsyHUD.Data)
MenuHelper:LoadFromJsonFile(ModPath .. "/menu/menu.json", NepgearsyHUD, NepgearsyHUD.Data)
MenuHelper:LoadFromJsonFile(ModPath .. "/menu/addons.json", NepgearsyHUD, NepgearsyHUD.Data)
MenuHelper:LoadFromJsonFile(ModPath .. "/menu/waifu.json", NepgearsyHUD, NepgearsyHUD.Data)

MenuCallbackHandler.NepgearsyHUD_Waifu_Picker_Choice_Callback = function(self, item)	
	NepgearsyHUD.Data.NepgearsyHUD_Waifu_Picker_Choice_Value = item:value()
	NepgearsyHUD:Save()
end