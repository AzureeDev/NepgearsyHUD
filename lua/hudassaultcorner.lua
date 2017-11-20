function HUDAssaultCorner:_retrieve_thickness_assault_bar()
	if NepgearsyHUD.Data and NepgearsyHUD.Data["NepgearsyHUD_AssaultBarThickness_Value"] then
		self._assault_bar_thickness = tonumber(NepgearsyHUD.Data["NepgearsyHUD_AssaultBarThickness_Value"])
	end
end

function HUDAssaultCorner:init(hud, full_hud, tweak_hud)
	self._assault_bar_thickness = 45
	self:_retrieve_thickness_assault_bar()
	self._hud_panel = full_hud.panel
	self._prev_hud = hud.panel
	self._total_killed_in_session = 0
	self._assault_count = 0
	self._full_hud_panel = full_hud.panel
	if self._hud_panel:child("assault_panel") then
		self._hud_panel:remove(self._hud_panel:child("assault_panel"))
	end
	local size = 1280
	local assault_panel = self._hud_panel:panel({
		visible = true,
		name = "assault_panel",
		w = 1280,
		h = self._assault_bar_thickness,
		align = "left"
	})
	self._assault_color = Color(1, 1, 1, 1)
	self._bg_box = HUDBGBox_create(assault_panel, {
		w = 1280,
		h = self._assault_bar_thickness,
		x = 0,
		y = 0
	}, {
		color = self._assault_color,
		blend_mode = "add",
		visible = true
	})
	self._bg_box_text = self._bg_box:text({
		name = "_bg_box_text",
		text = "CASING MODE",
		valign = "center",
		align = "center",
		vertical = "center",
		w = self._bg_box:w(),
		h = self._bg_box:h(),
		layer = 1,
		x = 0,
		y = 0,
		color = self._assault_color,
		font = tweak_data.hud_corner.assault_font,
		font_size = 24
	})

	local text_string = ""
	local use_stars = true
	if managers.crime_spree:is_active() then
		text_string = text_string .. managers.localization:to_upper_text("menu_cs_level", {
			level = managers.experience:cash_string(managers.crime_spree:server_spree_level(), "")
		})
		use_stars = false
	end
	if use_stars then
		for i = 1, managers.job:current_difficulty_stars() do
			text_string = text_string .. managers.localization:get_default_macro("BTN_SKULL")
		end
	end

	self._bg_box_difficulty_marker = self._bg_box:text({
		name = "_bg_box_difficulty_marker",
		text = text_string,
		valign = "center",
		align = "left",
		vertical = "center",
		w = self._bg_box:w(),
		h = self._bg_box:h(),
		layer = 1,
		x = 10,
		y = 0,
		color = self._assault_color,
		font = tweak_data.hud_corner.assault_font,
		font_size = 24
	})

	self._bg_box_mod_space = self._bg_box:text({
		name = "_bg_box_difficulty_marker",
		text = "",
		valign = "center",
		align = "right",
		vertical = "center",
		w = self._bg_box:w(),
		h = self._bg_box:h(),
		layer = 1,
		x = -10,
		y = 0,
		color = self._assault_color,
		font = tweak_data.hud_corner.assault_font,
		font_size = 24
	})
	
	assault_panel:set_top(0)
	assault_panel:set_right(self._hud_panel:w())
	self._assault_mode = "normal"
	
	self._vip_assault_color = Color(1, 1, 0.5019608, 0)
	if managers.mutators:are_mutators_active() then
		self._assault_color = Color(255, 211, 133, 255) / 255
		self._vip_assault_color = Color(255, 255, 133, 225) / 255
	end
	self._assault_survived_color = Color(1, 0.1254902, 0.9019608, 0.1254902)
	self._current_assault_color = self._assault_color
	local icon_assaultbox = assault_panel:bitmap({
		halign = "center",
		valign = "center",
		color = self._assault_color,
		name = "icon_assaultbox",
		blend_mode = "add",
		rotation = -90,
		visible = false,
		layer = 0,
		texture = "guis/textures/pd2/hud_icon_assaultbox",
		x = 0,
		y = 6,
		w = 24,
		h = 24
	})
	icon_assaultbox:set_right(icon_assaultbox:parent():w())
	--[[self._bg_box = HUDBGBox_create(assault_panel, {
		w = 0,
		h = 0,
		x = 0,
		y = 0
	}, {
		color = self._assault_color,
		blend_mode = "add",
		visible = false
	})
	self._bg_box:set_right(icon_assaultbox:left() - 3)--]]
	local yellow_tape = assault_panel:rect({
		visible = false,
		name = "yellow_tape",
		h = tweak_data.hud.location_font_size * 1.5,
		w = size * 3,
		color = Color(1, 0.8, 0),
		layer = 1
	})
	yellow_tape:set_center(10, 10)
	yellow_tape:set_rotation(30)
	yellow_tape:set_blend_mode("add")
	assault_panel:panel({
		name = "text_panel",
		layer = 1,
		w = yellow_tape:w()
	}):set_center(yellow_tape:center())
	if self._prev_hud:child("hostages_panel") then
		self._prev_hud:remove(self._prev_hud:child("hostages_panel"))
	end

	local hostage_w, hostage_h, hostage_box = 90, 58, 38
	local hostages_panel = self._prev_hud:panel({
		name = "hostages_panel",
		w = hostage_w,
		h = hostage_h,
		x = 0,
		y = 40
	})

	local kills_panel = self._prev_hud:panel({
		name = "kills_panel",
		w = hostage_w,
		h = hostage_h,
		x = self._hud_panel:w() - 275,
		y = 80
	})
	self.hostages_icon = hostages_panel:bitmap({
		name = "hostages_icon",
		texture = "guis/textures/pd2/hud_icon_hostage",
		valign = "top",
		layer = 1,
		x = 0,
		y = 0
	})
	local kills_icon = kills_panel:bitmap({
		name = "kills_icon",
		texture = "guis/textures/pd2/crimenet_skull",
		valign = "top",
		layer = 1,
		x = 0,
		y = 0,
		w = 24,
		h = 24
	})
	self._hostages_bg_box = HUDBGBox_create(hostages_panel, {
		w = 60,
		h = 38,
		x = 0,
		y = 0
	}, {})
	self._kills_bg_box = HUDBGBox_create(kills_panel, {
		w = 60,
		h = 38,
		x = 0,
		y = 0
	}, {})
	self.hostages_icon:set_right(hostages_panel:w() + 5)
	kills_icon:set_right(kills_panel:w() + 5)
	self.hostages_icon:set_center_y(self._hostages_bg_box:h() / 2)
	kills_icon:set_center_y(self._kills_bg_box:h() / 2)
	self._hostages_bg_box:set_right(self.hostages_icon:left())
	self._kills_bg_box:set_right(kills_icon:left())
	local num_hostages = self._hostages_bg_box:text({
		name = "num_hostages",
		text = "0",
		valign = "center",
		align = "center",
		vertical = "center",
		w = self._hostages_bg_box:w(),
		h = self._hostages_bg_box:h(),
		layer = 1,
		x = 0,
		y = 0,
		color = Color.white,
		font = tweak_data.hud_corner.assault_font,
		font_size = tweak_data.hud_corner.numhostages_size
	})
	local num_kills = self._kills_bg_box:text({
		name = "num_kills",
		text = "0",
		valign = "center",
		align = "center",
		vertical = "center",
		w = self._kills_bg_box:w(),
		h = self._kills_bg_box:h(),
		layer = 1,
		x = 0,
		y = 0,
		color = Color.white,
		font = tweak_data.hud_corner.assault_font,
		font_size = tweak_data.hud_corner.numhostages_size
	})

	if not self:is_safehouse_raid() then
		local phalanx_chance_panel = self._hud_panel:panel({
			visible = false,
			name = "phalanx_chance_panel",
			w = hostage_w,
			h = hostage_h,
			x = self._hud_panel:w() - 275,
			y = 134
		})
		local phalanx_chance_icon = phalanx_chance_panel:bitmap({
			name = "phalanx_chance_icon",
			texture = "guis/textures/pd2/hud_buff_shield",
			valign = "top",
			layer = 1,
			x = 0,
			y = 0,
			w = 24,
			h = 24
		})
		self._phalanx_chance_bg_box = HUDBGBox_create(phalanx_chance_panel, {
			w = 60,
			h = 38,
			x = 0,
			y = 0
		}, {})

		phalanx_chance_icon:set_right(phalanx_chance_panel:w() + 5)
		phalanx_chance_icon:set_center_y(self._phalanx_chance_bg_box:h() / 2)
		self._phalanx_chance_bg_box:set_right(phalanx_chance_icon:left())

		local percent_phalanx = self._phalanx_chance_bg_box:text({
			name = "percent_phalanx",
			text = "0%",
			valign = "center",
			align = "center",
			vertical = "center",
			w = self._phalanx_chance_bg_box:w(),
			h = self._phalanx_chance_bg_box:h(),
			layer = 1,
			x = 0,
			y = 0,
			color = Color.white,
			font = tweak_data.hud_corner.assault_font,
			font_size = tweak_data.hud_corner.numhostages_size
		})
	end

	if tweak_hud.no_hostages then
		hostages_panel:hide()
	end
	if self._prev_hud:child("wave_panel") then
		self._prev_hud:remove(self._prev_hud:child("wave_panel"))
	end
	self._max_waves = tweak_data.safehouse.combat.waves[Global.game_settings.difficulty or "normal"]
	self._wave_number = 1
	if self:is_safehouse_raid() then
		self._wave_panel_size = {250, 70}
		local wave_w, wave_h = 38, 38
		local wave_panel = self._prev_hud:panel({
			name = "wave_panel",
			w = self._wave_panel_size[1],
			h = self._wave_panel_size[2],
			x = self._prev_hud:w() - 416,
			y = 120
		})
		local waves_icon = wave_panel:bitmap({
			name = "hostages_icon",
			texture = "guis/textures/pd2/specialization/icons_atlas",
			texture_rect = {
				192,
				64,
				64,
				64
			},
			valign = "top",
			layer = 1,
			x = 0,
			y = 0,
			w = wave_w,
			h = wave_h
		})
		self._wave_bg_box = HUDBGBox_create(wave_panel, {
			w = 60,
			h = 38,
			x = 0,
			y = 0
		}, {blend_mode = "add"})
		waves_icon:set_right(wave_panel:w() - 5)
		waves_icon:set_center_y(self._wave_bg_box:h() * 0.5)
		self._wave_bg_box:set_right(waves_icon:left() + 5)
		local num_waves = self._wave_bg_box:text({
			name = "num_waves",
			text = self:get_completed_waves_string(),
			valign = "center",
			vertical = "center",
			align = "center",
			halign = "right",
			w = self._wave_bg_box:w(),
			h = self._wave_bg_box:h(),
			layer = 1,
			x = 0,
			y = 0,
			color = Color.white,
			font = tweak_data.hud_corner.assault_font,
			font_size = tweak_data.hud_corner.numhostages_size
		})

	end
	if self._hud_panel:child("point_of_no_return_panel") then
		self._hud_panel:remove(self._hud_panel:child("point_of_no_return_panel"))
	end
	local size = 1310
	local point_of_no_return_panel = self._hud_panel:panel({
		visible = false,
		name = "point_of_no_return_panel",
		w = size,
		h = self._assault_bar_thickness
	})
	self._noreturn_color = Color(1, 1, 0, 0)
	local icon_noreturnbox = point_of_no_return_panel:bitmap({
		halign = "center",
		valign = "center",
		color = self._noreturn_color,
		name = "icon_noreturnbox",
		blend_mode = "add",
		visible = false,
		layer = 0,
		texture = "guis/textures/pd2/hud_icon_noreturnbox",
		x = 0,
		y = 6,
		w = 24,
		h = 24
	})
	icon_noreturnbox:set_right(icon_noreturnbox:parent():w())
	self._noreturn_bg_box = HUDBGBox_create(point_of_no_return_panel, {
		w = 1310,
		h = self._assault_bar_thickness,
		x = 0,
		y = 0
	}, {
		color = self._noreturn_color,
		blend_mode = "add"
	})
	self._noreturn_bg_box:set_right(icon_noreturnbox:left() - 3)
	local w = point_of_no_return_panel:w()
	local size = 200 - tweak_data.hud.location_font_size
	local point_of_no_return_text = self._noreturn_bg_box:text({
		name = "point_of_no_return_text",
		text = "",
		blend_mode = "add",
		layer = 1,
		valign = "center",
		align = "center",
		vertical = "center",
		x = 0,
		y = 0,
		w = self._noreturn_bg_box:w(),
		h = self._noreturn_bg_box:h(),
		color = self._noreturn_color,
		font_size = 24,
		font = tweak_data.hud_corner.assault_font
	})
	point_of_no_return_text:set_text(utf8.to_upper(managers.localization:text("hud_assault_point_no_return_in", {time = ""})))
	point_of_no_return_text:set_size(self._noreturn_bg_box:w(), self._noreturn_bg_box:h())
	local point_of_no_return_timer = self._noreturn_bg_box:text({
		name = "point_of_no_return_timer",
		text = "",
		blend_mode = "add",
		layer = 1,
		valign = "center",
		align = "center",
		vertical = "center",
		x = 745,
		y = 0,
		color = self._noreturn_color,
		font_size = 24,
		font = tweak_data.hud_corner.assault_font
	})
	local _, _, w, h = point_of_no_return_timer:text_rect()
	point_of_no_return_timer:set_size(46, self._noreturn_bg_box:h())
	--point_of_no_return_text:set_right(math.round(point_of_no_return_timer:left()))
	if self._hud_panel:child("casing_panel") then
		self._hud_panel:remove(self._hud_panel:child("casing_panel"))
	end
	local size = 300
	local casing_panel = self._prev_hud:panel({
		visible = false,
		name = "casing_panel",
		w = size,
		h = 40,
		x = self._hud_panel:w() - size
	})
	self._casing_color = Color.white
	local icon_casingbox = casing_panel:bitmap({
		halign = "right",
		valign = "top",
		color = self._casing_color,
		name = "icon_casingbox",
		blend_mode = "add",
		visible = true,
		layer = 0,
		texture = "guis/textures/pd2/hud_icon_stealthbox",
		x = 0,
		y = 4,
		w = 38,
		h = 38
	})
	icon_casingbox:set_right(icon_casingbox:parent():w())
	local w = casing_panel:w()
	local size = 200 - tweak_data.hud.location_font_size
	casing_panel:panel({
		name = "text_panel",
		layer = 1,
		w = yellow_tape:w()
	}):set_center(yellow_tape:center())
	if self._hud_panel:child("buffs_panel") then
		self._hud_panel:remove(self._hud_panel:child("buffs_panel"))
	end
	local width = 200
	local x = assault_panel:left() + self._bg_box:left() - 3 - width
	local buffs_panel = self._hud_panel:panel({
		visible = false,
		name = "buffs_panel",
		w = width,
		h = 38,
		x = x
	})
	self._vip_bg_box_bg_color = Color(1, 0, 0.6666667, 1)
	self._vip_bg_box = HUDBGBox_create(buffs_panel, {
		w = 38,
		h = 38,
		x = width - 38,
		y = 0
	}, {
		color = Color.white,
		bg_color = self._vip_bg_box_bg_color
	})
	local vip_icon = self._vip_bg_box:bitmap({
		halign = "center",
		valign = "center",
		color = Color.white,
		name = "vip_icon",
		blend_mode = "add",
		visible = true,
		layer = 0,
		texture = "guis/textures/pd2/hud_buff_shield",
		x = 0,
		y = 0,
		w = 38,
		h = 38
	})
	vip_icon:set_center(self._vip_bg_box:w() / 2, self._vip_bg_box:h() / 2)

	if SystemFS:exists("mods/Money In Hud/mod.txt") then
		self._money_panel_color = Color(255, 5, 165, 0) / 255
	    self.money_panel = self._prev_hud:panel({
			visible = false,
			name = "money_panel",
			w = 400,
			h = 100,
			color = self._money_panel_color
		})
		self.total_money_panel = self._prev_hud:panel({
			visible = true,
			name = "total_money_panel",
			w = 400,
			h = 100,
			color = self._money_panel_color
		})
	    self._money_panel_box = HUDBGBox_create(self.money_panel, {
			w = 242,
			h = 38,
			x = 0,
			y = 0
		}, {
			visible = true,
			blend_mode = "add"
		})
		self.money_count = self._money_panel_box:text({
			name = "money_count",
			text = "",
			valign = "center",
			align = "left",
			vertical = "center",
			w = self._money_panel_box:w(),
			h = self._money_panel_box:h(),
			layer = 1,
			x = 10,
			y = 0,
			color = Color.white,
			font = tweak_data.hud_corner.assault_font,
			font_size = tweak_data.hud_corner.numhostages_size
		})
		self.total_money_count = self.total_money_panel:text({
			name = "total_money_count",
			text = "",
			valign = "center",
			align = "left",
			vertical = "center",
			w = self._money_panel_box:w(),
			h = self._money_panel_box:h(),
			layer = 1,
			x = 10,
			y = 0,
			color = Color.white,
			font = tweak_data.hud_corner.assault_font,
			font_size = 12
		})
	    self.money_panel:set_top(self._hostages_bg_box:bottom() + 60)
	    self.money_panel:set_left(self._hostages_bg_box:left() + 21)
	    self.total_money_panel:set_top(self.money_panel:bottom() - 64)
	    self.total_money_panel:set_left(self.money_panel:left() - 8)

	    if CustomAchievementAPI then
	    	self.achievement_unlocked_panel = self._prev_hud:panel({
				visible = false,
				name = "achievement_unlocked_panel",
				w = 350,
				h = 95,
				color = Color(0,1,1,1)
			})

			self.achievement_unlocked_box = HUDBGBox_create(self.achievement_unlocked_panel, {
				w = 350,
				h = 95,
				x = 0,
				y = 0
			}, {
				blend_mode = "add"
			})

			self.achievement_unlocked_image = self.achievement_unlocked_panel:bitmap({
				name = "achievement_unlocked_image",
				texture = "guis/textures/mods/CustomAchievement/default",
				texture_rect = {
					0,
					0,
					512,
					256
				},
				layer = 40,
				w = 128,
				h = 64,
				x = 5,
				y = 5
			})

			self.trophy_rank_image = self.achievement_unlocked_panel:bitmap({
				name = "trophy_rank_image",
				texture = "guis/textures/mods/CustomAchievement/trophy_icon_bronze",
				texture_rect = {
					0,
					0,
					256,
					256
				},
				
				layer = 40,
				w = 24,
				h = 24,
				x = 5,
				y = 8
			})

			self.achievement_unlocked_text = self.achievement_unlocked_box:text({
				name = "achievement_unlocked_text",
				text = "Achievement Unlocked!",
				align = "left",
				w = self.achievement_unlocked_box:w(),
				h = self.achievement_unlocked_box:h(),
				layer = 1,
				x = 5,
				y = 8,
				color = Color.white,
				font = tweak_data.hud_corner.assault_font,
				font_size = 18
			})

			self.achievement_unlocked_desc = self.achievement_unlocked_box:text({
				name = "achievement_unlocked_desc",
				text = "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW",
				align = "left",
				w = self.achievement_unlocked_box:w(),
				h = self.achievement_unlocked_box:h(),
				layer = 1,
				x = 5,
				y = 8,
				color = Color.white,
				font = tweak_data.hud_corner.assault_font,
				font_size = 14
			})

			self.achievement_unlocked_text:set_left(self.achievement_unlocked_image:right() + 5)
			self.achievement_unlocked_panel:set_top(self._hostages_bg_box:bottom() + 200)
		    self.achievement_unlocked_panel:set_left(self._hostages_bg_box:left())
	    end
    end

    local is_host = Network:is_server()

    self.current_heist_state = self._prev_hud:text({
		name = "current_heist_state",
		text = "GO LOUD TO DISPLAY THE ASSAULT STATE",
		valign = "center",
		align = "right",
		vertical = "top",
		layer = 1,
		x = 0,
		y = 0,
		color = Color.white,
		font = tweak_data.hud_corner.assault_font,
		font_size = 12,
		visible = is_host
	})

	self.current_heist_state:set_top(26)
	self.current_heist_state:set_right(self.hostages_icon:right())
	self.current_heist_state:set_align("right")
	self.current_heist_state:set_x(0)
end

function HUDAssaultCorner:_update_mod_spot(text)
	self._bg_box_mod_space:set_text(text)
end

function HUDAssaultCorner:_update_text_spot(text)
	self._bg_box_text:set_text(text)
end

function HUDAssaultCorner:_update_state_spot(text)
	self.current_heist_state:set_text(text)
end

function HUDAssaultCorner:_toggle_state_spot(bool)
	self.current_heist_state:set_visible(bool)
end

function HUDAssaultCorner:_update_assault_hud_color(color)
	local assault_panel = self._hud_panel:child("assault_panel")
	local icon_assaultbox = assault_panel:child("icon_assaultbox")
	icon_assaultbox:set_color(color)
	self._assault_color = color
	self._current_assault_color = color
	self._bg_box_text:set_color(color)
	self._bg_box_difficulty_marker:set_color(color)
	self._bg_box_mod_space:set_color(color)
end

function HUDAssaultCorner:_animate_text(text_panel, bg_box, color, color_function)
	local text_list = bg_box or self._bg_box:script().text_list
	local text_index = 0
	local texts = {}
	local padding = 10
	local function create_new_text(text_panel, text_list, text_index, texts)
		if texts[text_index] and texts[text_index].text then
			text_panel:remove(texts[text_index].text)
			texts[text_index] = nil
		end
		local text_id = text_list[text_index]
		local text_string = ""
		if type(text_id) == "string" then
			text_string = managers.localization:to_upper_text(text_id)
		elseif text_id == Idstring("risk") then
			local use_stars = true
			if managers.crime_spree:is_active() then
				text_string = text_string .. managers.localization:to_upper_text("menu_cs_level", {
					level = managers.experience:cash_string(managers.crime_spree:server_spree_level(), "")
				})
				use_stars = false
			end
			if use_stars then
				for i = 1, managers.job:current_difficulty_stars() do
					text_string = text_string .. managers.localization:get_default_macro("BTN_SKULL")
				end
			end
		end
		local mod_color = color_function and color_function() or color or self._assault_color
		local text = text_panel:text({
			text = text_string,
			layer = 1,
			align = "center",
			vertical = "center",
			blend_mode = "add",
			color = mod_color,
			font_size = tweak_data.hud_corner.assault_size,
			font = tweak_data.hud_corner.assault_font,
			w = 10,
			h = 10
		})
		local _, _, w, h = text:text_rect()
		text:set_size(w, h)
		texts[text_index] = {
			x = text_panel:w() + w * 0.5 + padding * 2,
			text = text
		}
	end
	while true do
		local dt = coroutine.yield()
		local last_text = texts[text_index]
		if last_text and last_text.text then
			if last_text.x + last_text.text:w() * 0.5 + padding < text_panel:w() then
				text_index = text_index % #text_list + 1
				create_new_text(text_panel, text_list, text_index, texts)
			end
		else
			text_index = text_index % #text_list + 1
			create_new_text(text_panel, text_list, text_index, texts)
		end
		local speed = 55
		for i, data in pairs(texts) do
			if data.text then
				data.x = data.x - dt * speed
				data.text:set_center_x(data.x)
				data.text:set_center_y(text_panel:h() * 0.5)
				if 0 > data.x + data.text:w() * 0.5 then
					text_panel:remove(data.text)
					data.text = nil
				elseif color_function then
					data.text:set_color(color_function())
				end
			end
		end
	end
end

function HUDAssaultCorner:_start_assault(text_list)
	self._assault_count = self._assault_count + 1
	text_list = text_list or {""}
	local assault_panel = self._hud_panel:child("assault_panel")
	local text_panel = assault_panel:child("text_panel")
	self:_set_text_list(text_list)
	self._assault = true
	if self._bg_box:child("text_panel") then
		self._bg_box:child("text_panel"):stop()
		self._bg_box:child("text_panel"):clear()
	else
		self._bg_box:panel({name = "text_panel"})
	end
	self._bg_box:child("bg"):stop()
	assault_panel:set_visible(true)
	local icon_assaultbox = assault_panel:child("icon_assaultbox")
	icon_assaultbox:stop()
	icon_assaultbox:animate(callback(self, self, "_show_icon_assaultbox"))
	local config = {
		attention_color = self._assault_color,
		attention_forever = true,
		attention_color_function = callback(self, self, "assault_attention_color_function")
	}
	self._bg_box:stop()
	self._bg_box:animate(callback(nil, _G, "HUDBGBox_animate_open_down"), 0.75, self._assault_bar_thickness, function() end, config)
	local box_text_panel = self._bg_box:child("text_panel")
	box_text_panel:stop()
	--box_text_panel:animate(callback(self, self, "_animate_text"), nil, nil, callback(self, self, "assault_attention_color_function"))
	self:_update_assault_hud_color(Color(1, 1, 1, 0))

	if self._assault_count == 1 then
		self:_update_text_spot(managers.localization:to_upper_text("NepgearsyHUD_AssaultBar_FirstAssault"))
	else
		self:_update_text_spot(managers.localization:to_upper_text("hud_assault_assault"))
	end
	
	self:_set_feedback_color(self._assault_color)
	if alive(self._wave_bg_box) then
		self._wave_bg_box:stop()
		self._wave_bg_box:animate(callback(self, self, "_animate_wave_started"), self)
	end
end

function HUDAssaultCorner:_end_assault()
	if not self._assault then
		self._start_assault_after_hostage_offset = nil
		return
	end
	self:_set_feedback_color(nil)
	self._assault = false
	local box_text_panel = self._bg_box:child("text_panel")
	box_text_panel:stop()
	box_text_panel:clear()
	self._remove_hostage_offset = true
	self._start_assault_after_hostage_offset = nil
	local icon_assaultbox = self._hud_panel:child("assault_panel"):child("icon_assaultbox")
	icon_assaultbox:stop()
	self:_update_text_spot(managers.localization:to_upper_text("hud_assault_survived"))
	if self:is_safehouse_raid() then
		self:_update_assault_hud_color(self._assault_survived_color)
		self:_set_text_list(self:_get_survived_assault_strings())
		self:_update_text_spot(managers.localization:to_upper_text("hud_assault_survived"))	
		box_text_panel:animate(callback(self, self, "_animate_text"), nil, nil, callback(self, self, "assault_attention_color_function"))
		icon_assaultbox:stop()
		icon_assaultbox:animate(callback(self, self, "_show_icon_assaultbox"))
		self._wave_bg_box:stop()
		self._wave_bg_box:animate(callback(self, self, "_animate_wave_completed"), self)
	else
		self:_close_assault_box()
	end
end

function HUDAssaultCorner:sync_set_assault_mode(mode)
	if self._assault_mode == mode then
		return
	end
	self._assault_mode = mode
	local color = self._assault_color
	if mode == "phalanx" then
		color = self._vip_assault_color
		self:_update_text_spot(managers.localization:text("NepgearsyHUD_AssaultBar_WintersLocked"))
		self:_update_state_spot(managers.localization:text("NepgearsyHUD_AssaultBar_WintersLocked_State"))
		self:_update_mod_spot("")
	else
		color = self._assault_color
		self:_update_text_spot(managers.localization:to_upper_text("hud_assault_assault"))
		self:_update_state_spot(managers.localization:text("NepgearsyHUD_AssaultBar_WintersDefeated_State"))
	end
	self:_update_assault_hud_color(color)
	self:_set_text_list(self:_get_assault_strings())
	local assault_panel = self._hud_panel:child("assault_panel")
	local icon_assaultbox = assault_panel:child("icon_assaultbox")
	local image = mode == "phalanx" and "guis/textures/pd2/hud_icon_padlockbox" or "guis/textures/pd2/hud_icon_assaultbox"
	icon_assaultbox:set_image(image)
end

function HUDAssaultCorner:_close_assault_box()
	local icon_assaultbox = self._hud_panel:child("assault_panel"):child("icon_assaultbox")
	icon_assaultbox:stop()
	local function close_done()
		self._bg_box:set_visible(false)
		icon_assaultbox:stop()
		icon_assaultbox:animate(callback(self, self, "_hide_icon_assaultbox"))
		self:sync_set_assault_mode("normal")
	end
	self._bg_box:stop()
	self._bg_box:animate(callback(nil, _G, "HUDBGBox_animate_close_down"), close_done)
end

function HUDAssaultCorner:show_casing(mode)
	local delay_time = 1
	self:_end_assault()
	
	if mode == "civilian" then
		self:_update_mod_spot(managers.localization:text("NepgearsyHUD_AssaultBar_CivilianMode_Mod"))
		self:_update_text_spot(managers.localization:text("NepgearsyHUD_AssaultBar_CivilianMode"))
	else
		self:_update_mod_spot(managers.localization:text("NepgearsyHUD_AssaultBar_CasingMode_Mod"))
		self:_update_text_spot(managers.localization:text("NepgearsyHUD_AssaultBar_CasingMode"))
	end

	self._bg_box:stop()
	self._bg_box:animate(callback(self, self, "_animate_show_casing"), delay_time)
	self._casing = true
end

function HUDAssaultCorner:_animate_show_casing(casing_panel, delay_time)
	local icon_casingbox = casing_panel:child("icon_casingbox")
	wait(delay_time)
	self._bg_box:set_visible(true)
	icon_casingbox:stop()
	icon_casingbox:animate(callback(self, self, "_show_icon_assaultbox"))
	local open_done = function()
	end
	self._bg_box:stop()
	self._bg_box:animate(callback(nil, _G, "HUDBGBox_animate_open_down"), 0.75, self._assault_bar_thickness, open_done, {
		attention_color = self._casing_color,
		attention_forever = true
	})
	casing_panel:set_visible(true)
	--self:_set_hostage_offseted(true)
end

function HUDAssaultCorner:hide_casing()
	local function close_done()
	end
	self:_update_text_spot("STEALTH STATE")
	self._bg_box:animate(callback(nil, _G, "HUDBGBox_animate_close_down"), close_done)
	self:_set_hostage_offseted(false)
	self._casing = false
end

function HUDAssaultCorner:_offset_hostage(is_offseted, hostage_panel)
	local TOTAL_T = 0.18
	local OFFSET = self._bg_box:h() + 16
	local from_y = is_offseted and 0 or OFFSET
	local target_y = is_offseted and OFFSET or 12
	local t = (1 - math.abs(hostage_panel:y() - target_y) / OFFSET) * TOTAL_T

	while TOTAL_T > t do
		local dt = coroutine.yield()
		t = math.min(t + dt, TOTAL_T)
		local lerp = t / TOTAL_T

		if self._start_assault_after_hostage_offset and lerp > 0.4 then
			self._start_assault_after_hostage_offset = nil
			self:start_assault_callback()
		end
	end
	if self._start_assault_after_hostage_offset then
		self._start_assault_after_hostage_offset = nil
		self:start_assault_callback()
	end
end

function HUDAssaultCorner:show_point_of_no_return_timer()
	local delay_time = self._assault and 1.2 or 0
	self:_close_assault_box()
	local point_of_no_return_panel = self._hud_panel:child("point_of_no_return_panel")
	--self:_hide_hostages()
	point_of_no_return_panel:stop()
	point_of_no_return_panel:animate(callback(self, self, "_animate_show_noreturn"), delay_time)
	self:_set_feedback_color(self._noreturn_color)
	self._point_of_no_return = true
end

function HUDAssaultCorner:get_completed_waves_string()
	local macro = {
		current = managers.network:session():is_host() and managers.groupai:state():get_assault_number() or self._wave_number,
		max = self._max_waves or 0
	}
	return macro.current .. " / " .. macro.max
end

function HUDAssaultCorner:_show_hostages()
	if not self._point_of_no_return then
		self._prev_hud:child("hostages_panel"):show()
	end
end

function HUDAssaultCorner:_hide_hostages()
	self._prev_hud:child("hostages_panel"):hide()
end

function HUDAssaultCorner:_set_hostage_offseted(is_offseted)
	local hostage_panel = self._prev_hud:child("hostages_panel")
	self._remove_hostage_offset = nil
	hostage_panel:stop()
	hostage_panel:animate(callback(self, self, "_offset_hostage", is_offseted))
	local wave_panel = self._prev_hud:child("wave_panel")
	if wave_panel then
		wave_panel:stop()
		wave_panel:animate(callback(self, self, "_offset_hostage", is_offseted))
	end
end

function HUDAssaultCorner:set_assault_wave_number(assault_number)
	self._wave_number = assault_number
	local panel = self._prev_hud:child("wave_panel")
	print("found panel")
	if alive(self._wave_bg_box) and panel then
		local wave_text = panel:child("num_waves")
		if wave_text then
			wave_text:set_text(self:get_completed_waves_string())
		end
	end
end

function HUDAssaultCorner:_animate_show_noreturn(point_of_no_return_panel, delay_time)
	local icon_noreturnbox = point_of_no_return_panel:child("icon_noreturnbox")
	local point_of_no_return_text = self._noreturn_bg_box:child("point_of_no_return_text")
	point_of_no_return_text:set_visible(false)
	local point_of_no_return_timer = self._noreturn_bg_box:child("point_of_no_return_timer")
	point_of_no_return_timer:set_visible(false)
	wait(delay_time)
	point_of_no_return_panel:set_visible(true)
	icon_noreturnbox:stop()
	icon_noreturnbox:animate(callback(self, self, "_show_icon_assaultbox"))
	local function open_done()
		point_of_no_return_text:animate(callback(self, self, "_animate_show_texts"), {point_of_no_return_text, point_of_no_return_timer})
	end
	self._noreturn_bg_box:stop()
	self._noreturn_bg_box:animate(callback(nil, _G, "HUDBGBox_animate_open_down"), 0.75, self._assault_bar_thickness, open_done, {
		attention_color = self._casing_color,
		attention_forever = true
	})
end