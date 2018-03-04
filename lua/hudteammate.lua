Hooks:PostHook( HUDTeammate, "init", "nephud_function_tm", function(self, i, teammates_panel, is_player, width)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	local Net = _G.LuaNetworking

	local texture = {}
	texture.characters = {}
	
	texture.characters[1] = "neptune"
	texture.characters[2] = "neptune"
	texture.characters[3] = "neptune"
	texture.characters[4] = "nepgear"
	texture.characters[5] = "noire"
	texture.characters[6] = "uni"
	texture.characters[7] = "vert"
	texture.characters[8] = "blanc"
	texture.characters[9] = "rom"
	texture.characters[10] = "ram"
	texture.characters[11] = "histy"
	texture.characters[12] = "leon"

	local data_waifu_picked = NepgearsyHUD.Data["NepgearsyHUD_Waifu_Picker_Choice_Value"] or 1

	if data_waifu_picked and data_waifu_picked > 1  then

		local teammate_panel = self._panel:child("player")
		local radial_health_panel = teammate_panel:child("radial_health_panel")

		self.waifu_panel = hud.panel:panel({
			name = "waifu_panel",
			visible = false,
			w = 90,
			h = 90,
			x = 0,
			y = 0,
		})

		local waifu_texture = self.waifu_panel:bitmap({
			visible = true,
			name = "waifu_texture",
			layer = -1,
			texture = "assets/NepgearsyHUD/waifu_assets/" .. texture.characters[data_waifu_picked],
			blend_mode = "normal",
			x = 0,
			y = 0,
			w = 90,
			h = 90
		})

		self.waifu_texture = waifu_texture

		if self._main_player then
			self.waifu_panel:set_visible(true)
		end
		
		if data_waifu_picked > 2 then
			self.waifu_panel:set_w(102)
			self.waifu_panel:set_h(90)
			waifu_texture:set_w(102)
			waifu_texture:set_h(90)
		end

		self.waifu_panel:set_world_x(hud.panel:right() - self.waifu_texture:w() - teammate_panel:w())
		self.waifu_panel:set_world_y(hud.panel:bottom() - self.waifu_texture:h())

		if data_waifu_picked == 2 then
			Steam:friend_avatar(2, Steam:userid(), function (texture)
				local avatar = texture or "guis/textures/pd2/none_icon"
				self.waifu_texture:set_image(avatar)
			end)
			Steam:friend_avatar(2, Steam:userid(), function (texture)
				local avatar = texture or "guis/textures/pd2/none_icon"
				self.waifu_texture:set_image(avatar)
			end)

			-- 2 times to be sure it works.
		end
	end
end)

if NepgearsyHUD.Data and NepgearsyHUD.Data["NepgearsyHUD_EnableTeammatePanel_Value"] then
	Hooks:PostHook( HUDTeammate, "init", "nephud_function_hud_helf_sheeld", function(self, i, teammates_panel, is_player, width)
		
		local icon_atlas_texture_health = "guis/dlcs/chico/textures/pd2/specialization/icons_atlas"
		local icon_atlas_texture_armor = "guis/textures/pd2/specialization/icons_atlas"

		local shared_health_icon_pos = {1, 0}
		local shared_armor_icon_pos = {0, 5}

		local health_x = shared_health_icon_pos[1]
		local health_y = shared_health_icon_pos[2]
		local armor_x = shared_armor_icon_pos[1]
		local armor_y = shared_armor_icon_pos[2]

		local teammate_panel = teammates_panel:child("" .. i)
		local orig_health_circle = self._player_panel:child("radial_health_panel")

		orig_health_circle:set_visible(false)

		local bg_box_health = HUDBGBox_create(teammate_panel, {
			w = 40,
			h = 30,
			x = 0,
			y = 0
		})

		local bg_box_armor = HUDBGBox_create(teammate_panel, {
			w = 40,
			h = 30,
			x = 0,
			y = 0
		})

		local health_icon = teammate_panel:bitmap({
			name = "health_icon",
			texture = icon_atlas_texture_health,
			texture_rect = {
				health_x * 64,
				health_y * 64,
				64,
				64
			},
			w = 24,
			h = 24,
			color = Color(1, 1, 0, 0.5),
			layer = 1
		})

		local armor_icon = teammate_panel:bitmap({
			name = "armor_icon",
			texture = icon_atlas_texture_armor,
			texture_rect = {
				armor_x * 64,
				armor_y * 64,
				64,
				64
			},
			w = 24,
			h = 24,
			color = Color(1, 1, 1, 1),
			layer = 1
		})

		self.text_armor_amount = bg_box_armor:text({
			name = "text_armor_amount",
			text = "0",
			valign = "center",
			align = "center",
			vertical = "center",
			w = bg_box_armor:w(),
			h = bg_box_armor:h(),
			layer = 1,
			x = 0,
			y = 0,
			color = Color.white,
			font = tweak_data.hud_corner.assault_font,
			font_size = tweak_data.hud_corner.numhostages_size / 1.3
		})

		self.text_health_amount = bg_box_health:text({
			name = "text_health_amount",
			text = "0",
			valign = "center",
			align = "center",
			vertical = "center",
			w = bg_box_health:w(),
			h = bg_box_health:h(),
			layer = 1,
			x = 0,
			y = 0,
			color = Color.white,
			font = tweak_data.hud_corner.assault_font,
			font_size = tweak_data.hud_corner.numhostages_size / 1.3
		})

		if is_player then
			health_icon:set_x(orig_health_circle:w() - 65)
			health_icon:set_y(orig_health_circle:h() - 10)

			armor_icon:set_x(orig_health_circle:w() - 65)
			armor_icon:set_y(orig_health_circle:h() + 25)

			bg_box_health:set_x(health_icon:w() + 5)
			bg_box_health:set_y(health_icon:h() + 30)

			bg_box_armor:set_x(armor_icon:w() + 5)
			bg_box_armor:set_y(armor_icon:h() + 65)
		else
			health_icon:set_visible(false)
			armor_icon:set_visible(false)
			bg_box_health:set_visible(false)
			bg_box_armor:set_visible(false)
			orig_health_circle:set_visible(true)
		end


	end)

	Hooks:PostHook( HUDTeammate, "set_health", "nephud_function_hud_helf_upd", function(self, data)
		local health_percent = data.current * 100 / data.total
		local health_floor = math.floor(health_percent)
		self.text_health_amount:set_text(tostring(health_floor) .. "%")
	end)

	Hooks:PostHook( HUDTeammate, "set_armor", "nephud_function_hud_armor_upd", function(self, data)
		local armor_percent = data.current * 101 / data.total -- fix 99%
		local armor_floor = math.floor(armor_percent)
		self.text_armor_amount:set_text(tostring(armor_floor) .. "%")
	end)
end