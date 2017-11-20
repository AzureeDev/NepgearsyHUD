NepgearsyHUD = NepgearsyHUD or class()

NepgearsyHUD.SavePath = SavePath .. "NepgearsyHUD_Preferences.txt"
NepgearsyHUD.Data = {}

NepgearsyHUD.Localization = {}
NepgearsyHUD.Localization[1] = ModPath .. "loc/english.txt"
NepgearsyHUD.Localization[2] = ModPath .. "loc/spanish.txt"
NepgearsyHUD.Localization[3] = ModPath .. "loc/german.txt"

function NepgearsyHUD:Load()		
	local file = io.open( self.SavePath , "r")
	if file then
		for k, v in pairs(json.decode(file:read("*all")) or {}) do
			if k then
				NepgearsyHUD.Data[k] = v
			end
		end
		file:close()
	end
end

function NepgearsyHUD:Save()
	if file.DirectoryExists( SavePath ) then	
		local file = io.open( self.SavePath , "w+")
		if file then
			file:write(json.encode(NepgearsyHUD.Data))
			file:close()
		end
	end
end

function NepgearsyHUD:create_texture_entry(texture_path_ingame, texture_path_inmod)
	DB:create_entry(Idstring("texture"), Idstring(texture_path_ingame), texture_path_inmod)
	log("[NepgearsyHUD] Loaded custom asset: " .. tostring(texture_path_inmod))
end

function NepgearsyHUD:_setup_textures()
	self:create_texture_entry("guis/NepgearsyHUD/minimap/kenaz_loc_b_df", ModPath .. "assets/NepgearsyHUD/minimap_assets/kenaz_loc_b_df.texture")
	self:create_texture_entry("guis/NepgearsyHUD/minimap/mus_1", ModPath .. "assets/NepgearsyHUD/minimap_assets/mus_1.texture")
	self:create_texture_entry("guis/NepgearsyHUD/minimap/mus_2", ModPath .. "assets/NepgearsyHUD/minimap_assets/mus_2.texture")
	self:create_texture_entry("guis/NepgearsyHUD/minimap/mus_3", ModPath .. "assets/NepgearsyHUD/minimap_assets/mus_3.texture")
	self:create_texture_entry("guis/NepgearsyHUD/minimap/shadow_raid_5", ModPath .. "assets/NepgearsyHUD/minimap_assets/shadow_raid_5.texture")

	log("[NepgearsyHUD] Loaded all the custom assets.")
end

function NepgearsyHUD:_remove_useless_asset()
	if file.DirectoryExists("assets/mod_overrides/NepgearsyHUD Base Assets/") then
		os.execute('rd /s/q "'.. "assets/mod_overrides/NepgearsyHUD Base Assets/" ..'"')
		log("Useless folder removed successfully.")
	end
end

NepgearsyHUD:_setup_textures()
NepgearsyHUD:_remove_useless_asset()

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

NepgearsyHUD:Load()

Hooks:Add("LocalizationManagerPostInit", "NepHud_Localization", function(loc)
	local language_picked = NepgearsyHUD.Data["NepgearsyHUD_LanguageSelection_Value"] or 1
	loc:load_localization_file( NepgearsyHUD.Localization[language_picked] )
end)

MenuHelper:LoadFromJsonFile(ModPath .. "/menu/menu.json", NepgearsyHUD, NepgearsyHUD.Data)
MenuHelper:LoadFromJsonFile(ModPath .. "/menu/addons.json", NepgearsyHUD, NepgearsyHUD.Data)

if SystemFS:exists("assets/mod_overrides/NepgearsyHUD Waifu Assets/add.xml") then
	MenuHelper:LoadFromJsonFile(ModPath .. "/menu/waifu.json", NepgearsyHUD, NepgearsyHUD.Data)

	MenuCallbackHandler.NepgearsyHUD_Waifu_Picker_Choice_Callback = function(self, item)	
		NepgearsyHUD.Data.NepgearsyHUD_Waifu_Picker_Choice_Value = item:value()
		NepgearsyHUD:Save()
	end
end