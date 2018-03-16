NepgearsyHUD = NepgearsyHUD or class()

NepgearsyHUD.SavePath = SavePath .. "NepgearsyHUD_Preferences.txt"
NepgearsyHUD.MinimapDirectory = ModPath .. "assets/NepgearsyHUD/minimap_assets/"
NepgearsyHUD.RealMinimapDirectory = "assets/NepgearsyHUD/minimap_assets/"
NepgearsyHUD.WaifuDirectory = ModPath .. "assets/NepgearsyHUD/waifu_assets/"
NepgearsyHUD.RealWaifuDirectory = "assets/NepgearsyHUD/waifu_assets/"
NepgearsyHUD.Data = {}

NepgearsyHUD.Localization = {}
NepgearsyHUD.Localization[1] = ModPath .. "loc/english.txt"
NepgearsyHUD.Localization[2] = ModPath .. "loc/spanish.txt"
NepgearsyHUD.Localization[3] = ModPath .. "loc/german.txt"
NepgearsyHUD.Localization[4] = ModPath .. "loc/chinese.txt"
NepgearsyHUD.Localization[5] = ModPath .. "loc/portuguese.txt"

function NepgearsyHUD:init()
	self:_setup_minimap_textures()
	self:_setup_waifu_textures()
	self:log("Init() completed!")
	self._initialized = true
end

function NepgearsyHUD:log(t)
	local tostring_log = tostring(t)
	log("[NepgearsyHUD] - " .. tostring_log)
end

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
	self:log("Loaded custom asset: " .. tostring(texture_path_inmod))
end

function NepgearsyHUD:_setup_minimap_textures()
	for i, v in ipairs(SystemFS:list(NepgearsyHUD.MinimapDirectory)) do
		local wo_extension = string.gsub(v, ".texture", "")
		self:create_texture_entry(NepgearsyHUD.RealMinimapDirectory .. wo_extension, NepgearsyHUD.MinimapDirectory .. v)
	end
	self:log("Loaded minimap assets.")
end

function NepgearsyHUD:_setup_waifu_textures()
	for i, v in ipairs(SystemFS:list(NepgearsyHUD.WaifuDirectory)) do
		local wo_extension = string.gsub(v, ".texture", "")
		self:create_texture_entry(NepgearsyHUD.RealWaifuDirectory .. wo_extension, NepgearsyHUD.WaifuDirectory .. v)
	end
	self:log("Loaded waifu assets.")
end

if not NepgearsyHUD._initialized then
	NepgearsyHUD:init()
end
