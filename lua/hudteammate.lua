if SystemFS:exists("assets/mod_overrides/NepgearsyHUD Waifu Assets/add.xml") then
function HUDTeammate:init(i, teammates_panel, is_player, width)
	self._id = i
	local small_gap = 8
	local gap = 0
	local pad = 4
	local main_player = i == HUDManager.PLAYER_PANEL
	self._main_player = main_player
	local names = {
		"WWWWWWWWWWWWQWWW",
		"AI Teammate",
		"FutureCatCar",
		"WWWWWWWWWWWWQWWW"
	}
	local teammate_panel = teammates_panel:panel({
		halign = "right",
		visible = false,
		x = 0,
		name = "" .. i,
		w = math.round(width)
	})

	if not main_player then
		--teammate_panel:set_h(84)
		teammate_panel:set_bottom(teammates_panel:h())
		teammate_panel:set_halign("left")
	end

	self._player_panel = teammate_panel:panel({name = "player"})
	self._health_data = {
		current = 0,
		total = 0
	}
	self._armor_data = {
		current = 0,
		total = 0
	}
	local name = teammate_panel:text({
		name = "name",
		vertical = "bottom",
		y = 0,
		layer = 1,
		text = " " .. names[i],
		color = Color.white,
		font_size = tweak_data.hud_players.name_size,
		font = tweak_data.hud_players.name_font
	})
	local _, _, name_w, _ = name:text_rect()

	managers.hud:make_fine_text(name)
	name:set_leftbottom(name:h(), teammate_panel:h() - 70)

	if not main_player then
		name:set_x(48 + name:h() + 4)
		name:set_bottom(teammate_panel:h() - 30)
	end

	local tabs_texture = "guis/textures/pd2/hud_tabs"
	local bg_rect = {
		84,
		0,
		44,
		32
	}
	local cs_rect = {
		84,
		34,
		19,
		19
	}
	local csbg_rect = {
		105,
		34,
		19,
		19
	}
	local bg_color = Color.white / 3

	teammate_panel:bitmap({
		name = "name_bg",
		visible = true,
		layer = 0,
		texture = tabs_texture,
		texture_rect = bg_rect,
		color = bg_color,
		x = name:x(),
		y = name:y() - 1,
		w = name_w + 4,
		h = name:h()
	})
	teammate_panel:bitmap({
		name = "callsign_bg",
		layer = 0,
		blend_mode = "normal",
		texture = tabs_texture,
		texture_rect = csbg_rect,
		color = bg_color,
		x = name:x() - name:h(),
		y = name:y() + 1,
		w = name:h() - 2,
		h = name:h() - 2
	})
	teammate_panel:bitmap({
		name = "callsign",
		layer = 1,
		blend_mode = "normal",
		texture = tabs_texture,
		texture_rect = cs_rect,
		color = (tweak_data.chat_colors[i] or tweak_data.chat_colors[#tweak_data.chat_colors]):with_alpha(1),
		x = name:x() - name:h(),
		y = name:y() + 1,
		w = name:h() - 2,
		h = name:h() - 2
	})

	local box_ai_bg = teammate_panel:bitmap({
		texture = "guis/textures/pd2/box_ai_bg",
		name = "box_ai_bg",
		alpha = 0,
		visible = false,
		y = 0,
		color = Color.white,
		w = teammate_panel:w()
	})

	box_ai_bg:set_bottom(name:top())

	local box_bg = teammate_panel:bitmap({
		texture = "guis/textures/pd2/box_bg",
		name = "box_bg",
		y = 0,
		visible = false,
		color = Color.white,
		w = teammate_panel:w()
	})

	box_bg:set_bottom(name:top())

	local texture, rect = tweak_data.hud_icons:get_icon_data("pd2_mask_" .. i)
	local size = 64
	local mask_pad = 2
	local mask_pad_x = 3
	local y = (teammate_panel:h() - name:h()) - size + mask_pad
	local mask = teammate_panel:bitmap({
		name = "mask",
		visible = false,
		layer = 1,
		color = Color.white,
		texture = texture,
		texture_rect = rect,
		x = -mask_pad_x,
		w = size,
		h = size,
		y = y
	})
	local radial_size = main_player and 64 or 48
	local radial_health_panel = self._player_panel:panel({
		name = "radial_health_panel",
		x = 0,
		layer = 1,
		w = radial_size + 4,
		h = radial_size + 4,
		y = mask:y()
	})

	radial_health_panel:set_bottom(self._player_panel:h())

	local radial_bg = radial_health_panel:bitmap({
		texture = "guis/textures/pd2/hud_radialbg",
		name = "radial_bg",
		alpha = 1,
		layer = 0,
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
	local radial_health = radial_health_panel:bitmap({
		texture = "guis/textures/pd2/hud_health",
		name = "radial_health",
		layer = 2,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		texture_rect = {
			128,
			0,
			-128,
			128
		},
		color = Color(1, 0, 1, 1),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
	local radial_shield = radial_health_panel:bitmap({
		texture = "guis/textures/pd2/hud_shield",
		name = "radial_shield",
		layer = 1,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		texture_rect = {
			128,
			0,
			-128,
			128
		},
		color = Color(1, 0, 1, 1),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
	local damage_indicator = radial_health_panel:bitmap({
		blend_mode = "add",
		name = "damage_indicator",
		alpha = 0,
		texture = "guis/textures/pd2/hud_radial_rim",
		layer = 1,
		color = Color(1, 1, 1, 1),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
	local radial_custom = radial_health_panel:bitmap({
		texture = "guis/textures/pd2/hud_swansong",
		name = "radial_custom",
		blend_mode = "add",
		visible = false,
		render_template = "VertexColorTexturedRadial",
		layer = 5,
		color = Color(1, 0, 0, 0),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
	local radial_ability_panel = radial_health_panel:panel({name = "radial_ability"})
	local radial_ability_meter = radial_ability_panel:bitmap({
		blend_mode = "add",
		name = "ability_meter",
		texture = "guis/dlcs/chico/textures/pd2/hud_fearless",
		render_template = "VertexColorTexturedRadial",
		layer = 5,
		color = Color(1, 0, 0, 0),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
	local radial_ability_icon = radial_ability_panel:bitmap({
		blend_mode = "add",
		name = "ability_icon",
		visible = false,
		alpha = 1,
		layer = 5,
		w = radial_size * 0.5,
		h = radial_size * 0.5
	})

	radial_ability_icon:set_center(radial_ability_panel:center())

	local radial_delayed_damage_panel = radial_health_panel:panel({name = "radial_delayed_damage"})
	local radial_delayed_damage_armor = radial_delayed_damage_panel:bitmap({
		texture = "guis/textures/pd2/hud_dot_shield",
		name = "radial_delayed_damage_armor",
		visible = false,
		render_template = "VertexColorTexturedRadialFlex",
		layer = 5,
		w = radial_delayed_damage_panel:w(),
		h = radial_delayed_damage_panel:h()
	})
	local radial_delayed_damage_health = radial_delayed_damage_panel:bitmap({
		texture = "guis/textures/pd2/hud_dot",
		name = "radial_delayed_damage_health",
		visible = false,
		render_template = "VertexColorTexturedRadialFlex",
		layer = 5,
		w = radial_delayed_damage_panel:w(),
		h = radial_delayed_damage_panel:h()
	})

	if main_player then
		local radial_rip = radial_health_panel:bitmap({
			texture = "guis/textures/pd2/hud_rip",
			name = "radial_rip",
			layer = 3,
			blend_mode = "add",
			visible = false,
			render_template = "VertexColorTexturedRadial",
			texture_rect = {
				128,
				0,
				-128,
				128
			},
			color = Color(1, 0, 0, 0),
			w = radial_health_panel:w(),
			h = radial_health_panel:h()
		})
		local radial_rip_bg = radial_health_panel:bitmap({
			texture = "guis/textures/pd2/hud_rip_bg",
			name = "radial_rip_bg",
			layer = 1,
			visible = false,
			render_template = "VertexColorTexturedRadial",
			texture_rect = {
				128,
				0,
				-128,
				128
			},
			color = Color(1, 0, 0, 0),
			w = radial_health_panel:w(),
			h = radial_health_panel:h()
		})
	end

	radial_health_panel:bitmap({
		texture = "guis/dlcs/coco/textures/pd2/hud_absorb_shield",
		name = "radial_absorb_shield_active",
		visible = false,
		render_template = "VertexColorTexturedRadial",
		layer = 5,
		color = Color(1, 0, 0, 0),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})

	local radial_absorb_health_active = radial_health_panel:bitmap({
		texture = "guis/dlcs/coco/textures/pd2/hud_absorb_health",
		name = "radial_absorb_health_active",
		visible = false,
		render_template = "VertexColorTexturedRadial",
		layer = 5,
		color = Color(1, 0, 0, 0),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})

	radial_absorb_health_active:animate(callback(self, self, "animate_update_absorb_active"))
	radial_health_panel:bitmap({
		texture = "guis/dlcs/coco/textures/pd2/hud_absorb_stack_fg",
		name = "radial_info_meter",
		blend_mode = "add",
		visible = false,
		render_template = "VertexColorTexturedRadial",
		layer = 3,
		color = Color(1, 0, 0, 0),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
	radial_health_panel:bitmap({
		texture = "guis/dlcs/coco/textures/pd2/hud_absorb_stack_bg",
		name = "radial_info_meter_bg",
		layer = 1,
		visible = false,
		render_template = "VertexColorTexturedRadial",
		texture_rect = {
			128,
			0,
			-128,
			128
		},
		color = Color(1, 0, 0, 0),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})

	local x, y, w, h = radial_health_panel:shape()

	teammate_panel:bitmap({
		name = "condition_icon",
		visible = false,
		layer = 4,
		color = Color.white,
		x = x,
		y = y,
		w = w,
		h = h
	})

	local condition_timer = teammate_panel:text({
		y = 0,
		vertical = "center",
		name = "condition_timer",
		align = "center",
		text = "000",
		visible = false,
		layer = 5,
		color = Color.white,
		font_size = tweak_data.hud_players.timer_size,
		font = tweak_data.hud_players.timer_font
	})

	condition_timer:set_shape(radial_health_panel:shape())

	local w_selection_w = 12
	local weapon_panel_w = 80
	local extra_clip_w = 4
	local ammo_text_w = (weapon_panel_w - w_selection_w) / 2
	local font_bottom_align_correction = 3
	local tabs_texture = "guis/textures/pd2/hud_tabs"
	local bg_rect = {
		0,
		0,
		67,
		32
	}
	local weapon_selection_rect1 = {
		68,
		0,
		12,
		32
	}
	local weapon_selection_rect2 = {
		68,
		32,
		12,
		32
	}
	local weapons_panel = self._player_panel:panel({
		name = "weapons_panel",
		visible = true,
		layer = 0,
		w = weapon_panel_w,
		h = radial_health_panel:h(),
		x = radial_health_panel:right() + 4,
		y = radial_health_panel:y()
	})
	local primary_weapon_panel = weapons_panel:panel({
		y = 0,
		name = "primary_weapon_panel",
		h = 32,
		visible = false,
		x = 0,
		layer = 1,
		w = weapon_panel_w
	})

	primary_weapon_panel:bitmap({
		name = "bg",
		layer = 0,
		visible = true,
		x = 0,
		texture = tabs_texture,
		texture_rect = bg_rect,
		color = bg_color,
		w = weapon_panel_w
	})
	primary_weapon_panel:text({
		name = "ammo_clip",
		align = "center",
		vertical = "bottom",
		font_size = 32,
		blend_mode = "normal",
		x = 0,
		layer = 1,
		visible = main_player and true,
		text = "0" .. math.random(40),
		color = Color.white,
		w = ammo_text_w + extra_clip_w,
		h = primary_weapon_panel:h(),
		y = 0 + font_bottom_align_correction,
		font = tweak_data.hud_players.ammo_font
	})
	primary_weapon_panel:text({
		text = "000",
		name = "ammo_total",
		align = "center",
		vertical = "bottom",
		font_size = 24,
		blend_mode = "normal",
		visible = true,
		layer = 1,
		color = Color.white,
		w = ammo_text_w - extra_clip_w,
		h = primary_weapon_panel:h(),
		x = ammo_text_w + extra_clip_w,
		y = 0 + font_bottom_align_correction,
		font = tweak_data.hud_players.ammo_font
	})

	local weapon_selection_panel = primary_weapon_panel:panel({
		name = "weapon_selection",
		layer = 1,
		visible = main_player and true,
		w = w_selection_w,
		x = weapon_panel_w - w_selection_w
	})

	weapon_selection_panel:bitmap({
		name = "weapon_selection",
		texture = tabs_texture,
		texture_rect = weapon_selection_rect1,
		color = Color.white,
		w = w_selection_w
	})
	self:_create_primary_weapon_firemode()

	if not main_player then
		local ammo_total = primary_weapon_panel:child("ammo_total")
		local _x, _y, _w, _h = ammo_total:text_rect()

		primary_weapon_panel:set_size(_w + 8, _h)
		ammo_total:set_shape(0, 0, primary_weapon_panel:size())
		ammo_total:move(0, font_bottom_align_correction)
		primary_weapon_panel:set_x(0)
		primary_weapon_panel:set_bottom(weapons_panel:h())

		local eq_rect = {
			84,
			0,
			44,
			32
		}

		primary_weapon_panel:child("bg"):set_image(tabs_texture, eq_rect[1], eq_rect[2], eq_rect[3], eq_rect[4])
		primary_weapon_panel:child("bg"):set_size(primary_weapon_panel:size())
	end

	local secondary_weapon_panel = weapons_panel:panel({
		name = "secondary_weapon_panel",
		h = 32,
		visible = false,
		x = 0,
		layer = 1,
		w = weapon_panel_w,
		y = primary_weapon_panel:bottom()
	})

	secondary_weapon_panel:bitmap({
		name = "bg",
		layer = 0,
		visible = true,
		x = 0,
		texture = tabs_texture,
		texture_rect = bg_rect,
		color = bg_color,
		w = weapon_panel_w
	})
	secondary_weapon_panel:text({
		name = "ammo_clip",
		align = "center",
		vertical = "bottom",
		font_size = 32,
		blend_mode = "normal",
		x = 0,
		layer = 1,
		visible = main_player and true,
		text = "" .. math.random(40),
		color = Color.white,
		w = ammo_text_w + extra_clip_w,
		h = secondary_weapon_panel:h(),
		y = 0 + font_bottom_align_correction,
		font = tweak_data.hud_players.ammo_font
	})
	secondary_weapon_panel:text({
		text = "000",
		name = "ammo_total",
		align = "center",
		vertical = "bottom",
		font_size = 24,
		blend_mode = "normal",
		visible = true,
		layer = 1,
		color = Color.white,
		w = ammo_text_w - extra_clip_w,
		h = secondary_weapon_panel:h(),
		x = ammo_text_w + extra_clip_w,
		y = 0 + font_bottom_align_correction,
		font = tweak_data.hud_players.ammo_font
	})

	local weapon_selection_panel = secondary_weapon_panel:panel({
		name = "weapon_selection",
		layer = 1,
		visible = main_player and true,
		w = w_selection_w,
		x = weapon_panel_w - w_selection_w
	})

	weapon_selection_panel:bitmap({
		name = "weapon_selection",
		texture = tabs_texture,
		texture_rect = weapon_selection_rect2,
		color = Color.white,
		w = w_selection_w
	})
	secondary_weapon_panel:set_bottom(weapons_panel:h())
	self:_create_secondary_weapon_firemode()

	if not main_player then
		local ammo_total = secondary_weapon_panel:child("ammo_total")
		local _x, _y, _w, _h = ammo_total:text_rect()

		secondary_weapon_panel:set_size(_w + 8, _h)
		ammo_total:set_shape(0, 0, secondary_weapon_panel:size())
		ammo_total:move(0, font_bottom_align_correction)
		secondary_weapon_panel:set_x(primary_weapon_panel:right())
		secondary_weapon_panel:set_bottom(weapons_panel:h())

		local eq_rect = {
			84,
			0,
			44,
			32
		}

		secondary_weapon_panel:child("bg"):set_image(tabs_texture, eq_rect[1], eq_rect[2], eq_rect[3], eq_rect[4])
		secondary_weapon_panel:child("bg"):set_size(secondary_weapon_panel:size())
	end

	local eq_rect = {
		84,
		0,
		44,
		32
	}
	local temp_scale = 1
	local eq_h = 64 / (PlayerBase.USE_GRENADES and 3 or 2)
	local eq_w = 48
	local eq_tm_scale = PlayerBase.USE_GRENADES and 1 or 0.75
	local deployable_equipment_panel = self._player_panel:panel({
		name = "deployable_equipment_panel",
		layer = 1,
		w = eq_w,
		h = eq_h,
		x = weapons_panel:right() + 4,
		y = weapons_panel:y()
	})

	deployable_equipment_panel:bitmap({
		name = "bg",
		layer = 0,
		x = 0,
		texture = tabs_texture,
		texture_rect = eq_rect,
		color = bg_color,
		w = deployable_equipment_panel:w()
	})

	local equipment = deployable_equipment_panel:bitmap({
		name = "equipment",
		visible = false,
		layer = 1,
		color = Color.white,
		w = deployable_equipment_panel:h() * temp_scale,
		h = deployable_equipment_panel:h() * temp_scale,
		x = -(deployable_equipment_panel:h() * temp_scale - deployable_equipment_panel:h()) / 2,
		y = -(deployable_equipment_panel:h() * temp_scale - deployable_equipment_panel:h()) / 2
	})
	local amount = deployable_equipment_panel:text({
		name = "amount",
		vertical = "center",
		font_size = 22,
		align = "right",
		y = 2,
		text = "",
		font = "fonts/font_medium_mf",
		visible = false,
		x = -2,
		layer = 2,
		color = Color.white,
		w = deployable_equipment_panel:w(),
		h = deployable_equipment_panel:h()
	})

	if not main_player then
		local scale = eq_tm_scale

		deployable_equipment_panel:set_size(deployable_equipment_panel:w() * 0.9, deployable_equipment_panel:h() * scale)
		equipment:set_size(equipment:w() * scale, equipment:h() * scale)
		equipment:set_center_y(deployable_equipment_panel:h() / 2)
		equipment:set_x(equipment:x() + 4)
		amount:set_center_y(deployable_equipment_panel:h() / 2)
		amount:set_right(deployable_equipment_panel:w() - 4)
		deployable_equipment_panel:set_x(weapons_panel:right() - 8)
		deployable_equipment_panel:set_bottom(weapons_panel:bottom())

		local bg = deployable_equipment_panel:child("bg")

		bg:set_size(deployable_equipment_panel:size())
	end

	local texture, rect = tweak_data.hud_icons:get_icon_data(tweak_data.equipments.specials.cable_tie.icon)
	local cable_ties_panel = self._player_panel:panel({
		name = "cable_ties_panel",
		layer = 1,
		w = eq_w,
		h = eq_h,
		x = weapons_panel:right() + 4,
		y = weapons_panel:y()
	})

	cable_ties_panel:bitmap({
		name = "bg",
		layer = 0,
		x = 0,
		texture = tabs_texture,
		texture_rect = eq_rect,
		color = bg_color,
		w = deployable_equipment_panel:w()
	})

	local cable_ties = cable_ties_panel:bitmap({
		name = "cable_ties",
		layer = 1,
		texture = texture,
		texture_rect = rect,
		color = Color.white,
		w = deployable_equipment_panel:h() * temp_scale,
		h = deployable_equipment_panel:h() * temp_scale,
		x = -(deployable_equipment_panel:h() * temp_scale - deployable_equipment_panel:h()) / 2,
		y = -(deployable_equipment_panel:h() * temp_scale - deployable_equipment_panel:h()) / 2
	})
	local amount = cable_ties_panel:text({
		name = "amount",
		vertical = "center",
		font_size = 22,
		align = "right",
		font = "fonts/font_medium_mf",
		y = 2,
		x = -2,
		layer = 2,
		text = tostring(12),
		color = Color.white,
		w = deployable_equipment_panel:w(),
		h = deployable_equipment_panel:h()
	})

	if PlayerBase.USE_GRENADES then
		cable_ties_panel:set_center_y(weapons_panel:center_y())
	else
		cable_ties_panel:set_bottom(weapons_panel:bottom())
	end

	if not main_player then
		local scale = eq_tm_scale

		cable_ties_panel:set_size(cable_ties_panel:w() * 0.9, cable_ties_panel:h() * scale)
		cable_ties:set_size(cable_ties:w() * scale, cable_ties:h() * scale)
		cable_ties:set_center_y(cable_ties_panel:h() / 2)
		cable_ties:set_x(cable_ties:x() + 4)
		amount:set_center_y(cable_ties_panel:h() / 2)
		amount:set_right(cable_ties_panel:w() - 4)
		cable_ties_panel:set_x(deployable_equipment_panel:right())
		cable_ties_panel:set_bottom(deployable_equipment_panel:bottom())

		local bg = cable_ties_panel:child("bg")

		bg:set_size(cable_ties_panel:size())
	end

	if PlayerBase.USE_GRENADES then
		local texture, rect = tweak_data.hud_icons:get_icon_data("frag_grenade")
		local grenades_panel = self._player_panel:panel({
			name = "grenades_panel",
			visible = true,
			layer = 1,
			w = eq_w,
			h = eq_h,
			x = weapons_panel:right() + 4,
			y = weapons_panel:y()
		})
		local grenades_bg = grenades_panel:bitmap({
			name = "bg",
			layer = 0,
			visible = true,
			x = 0,
			texture = tabs_texture,
			texture_rect = eq_rect,
			color = bg_color,
			w = cable_ties_panel:w()
		})
		local grenades_radial = grenades_panel:bitmap({
			texture = "guis/textures/pd2/hud_cooldown_timer",
			name = "grenades_radial",
			render_template = "VertexColorTexturedRadial",
			layer = 1,
			color = Color(0.5, 0, 1, 1),
			w = grenades_panel:h(),
			h = grenades_panel:h()
		})
		local grenades_radial_ghost = grenades_panel:bitmap({
			texture = "guis/textures/pd2/hud_cooldown_timer",
			name = "grenades_radial_ghost",
			visible = false,
			rotation = 360,
			layer = 1,
			w = grenades_panel:h(),
			h = grenades_panel:h()
		})
		local grenades_icon = grenades_panel:bitmap({
			name = "grenades_icon",
			layer = 2,
			texture = texture,
			texture_rect = rect,
			w = grenades_panel:h() * temp_scale,
			h = grenades_panel:h() * temp_scale,
			x = -(grenades_panel:h() * temp_scale - grenades_panel:h()) / 2,
			y = -(grenades_panel:h() * temp_scale - grenades_panel:h()) / 2
		})
		local grenades_icon_ghost = grenades_panel:bitmap({
			name = "grenades_icon_ghost",
			rotation = 360,
			visible = false,
			texture = texture,
			texture_rect = rect,
			layer = grenades_icon:layer(),
			color = grenades_icon:color(),
			w = grenades_icon:w(),
			h = grenades_icon:h(),
			x = grenades_icon:x(),
			y = grenades_icon:y()
		})
		local amount = grenades_panel:text({
			name = "amount",
			vertical = "center",
			font_size = 22,
			align = "right",
			font = "fonts/font_medium_mf",
			y = 2,
			x = -2,
			layer = 2,
			text = tostring("03"),
			color = Color.white,
			w = grenades_panel:w(),
			h = grenades_panel:h()
		})

		grenades_panel:set_bottom(weapons_panel:bottom())

		if not main_player then
			local scale = eq_tm_scale

			grenades_panel:set_size(grenades_panel:w() * 0.9, grenades_panel:h() * scale)
			grenades_icon:set_size(grenades_icon:w() * scale, grenades_icon:h() * scale)
			grenades_icon:set_center_y(grenades_panel:h() / 2)
			grenades_icon:set_x(grenades_icon:x() + 4)
			grenades_icon_ghost:set_position(grenades_icon:position())
			grenades_radial:set_center(grenades_icon:center())
			grenades_radial_ghost:set_position(grenades_radial:position())
			amount:set_center_y(grenades_panel:h() / 2)
			amount:set_right(grenades_panel:w() - 4)
			grenades_panel:set_x(cable_ties_panel:right())
			grenades_panel:set_bottom(cable_ties_panel:bottom())
			grenades_bg:set_size(grenades_panel:size())
		end
	end

	local bag_rect = {
		32,
		33,
		32,
		31
	}
	local bg_rect = {
		84,
		0,
		44,
		32
	}
	local bag_w = bag_rect[3]
	local bag_h = bag_rect[4]
	local carry_panel = self._player_panel:panel({
		name = "carry_panel",
		visible = false,
		x = 0,
		layer = 1,
		w = bag_w,
		h = bag_h + 2,
		y = radial_health_panel:top() - bag_h
	})

	carry_panel:set_x(24 - bag_w / 2)
	carry_panel:set_center_x(radial_health_panel:center_x())
	carry_panel:bitmap({
		name = "bg",
		visible = false,
		w = 100,
		layer = 0,
		y = 0,
		x = 0,
		texture = tabs_texture,
		texture_rect = bg_rect,
		color = bg_color,
		h = carry_panel:h()
	})
	carry_panel:bitmap({
		name = "bag",
		layer = 0,
		y = 1,
		visible = true,
		x = 1,
		texture = tabs_texture,
		w = bag_w,
		h = bag_h,
		texture_rect = bag_rect,
		color = Color.white
	})
	carry_panel:text({
		y = 0,
		vertical = "center",
		name = "value",
		text = "",
		font = "fonts/font_small_mf",
		visible = false,
		layer = 0,
		color = Color.white,
		x = bag_rect[3] + 4,
		font_size = tweak_data.hud.small_font_size
	})

	local interact_panel = self._player_panel:panel({
		layer = 3,
		name = "interact_panel",
		visible = false
	})

	interact_panel:set_shape(weapons_panel:shape())
	interact_panel:set_shape(radial_health_panel:shape())
	interact_panel:set_size(radial_size * 1.25, radial_size * 1.25)
	interact_panel:set_center(radial_health_panel:center())

	local radius = interact_panel:h() / 2 - 4
	self._interact = CircleBitmapGuiObject:new(interact_panel, {
		blend_mode = "add",
		use_bg = true,
		rotation = 360,
		layer = 0,
		radius = radius,
		color = Color.white
	})

	self._interact:set_position(4, 4)

	self._special_equipment = {}
	self._panel = teammate_panel

	self:create_waiting_panel(teammates_panel)
end

	Hooks:PostHook( HUDTeammate, "init", "nephud_function_tm", function(self, i, teammates_panel, is_player, width)
		hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
		local Net = _G.LuaNetworking

		local texture = {}
		texture.characters = {}
		
		texture.characters[1] = "neptune"
		texture.characters[2] = "nepgear"
		texture.characters[3] = "noire"
		texture.characters[4] = "uni"
		texture.characters[5] = "vert"
		texture.characters[6] = "blanc"
		texture.characters[7] = "rom"
		texture.characters[8] = "ram"
		texture.characters[9] = "histy"
		texture.characters[10] = "leon"

		local data_waifu_picked = NepgearsyHUD.Data["NepgearsyHUD_Waifu_Picker_Choice_Value"] or 1
		if data_waifu_picked then
			
			Net:SendToPeers( "NepHudWaifu", texture.characters[data_waifu_picked] )

			local teammate_panel = self._panel:child("player")
			local radial_health_panel = teammate_panel:child("radial_health_panel")

			self.waifu_panel = teammate_panel:panel({
				name = "waifu_panel",
				visible = false,
				w = 87,
				h = 74,
				x = 0,
				y = 0,
			})

			local waifu_texture = self.waifu_panel:bitmap({
				visible = true,
				name = "waifu_texture",
				layer = -1,
				texture = "guis/textures/nepgearsy_hud/" .. texture.characters[data_waifu_picked],
				blend_mode = "normal",
				x = 0,
				y = 0,
				w = 82,
				h = 70
			})

			if self._main_player then
				self.waifu_panel:set_visible(false)
			end
			

			self.waifu_panel:set_x(radial_health_panel:h() - 60)
			self.waifu_panel:set_bottom(teammate_panel:h() - 48)

			local nep_face_panel = hud.panel:panel({
				name = "nep_face_panel",
				visible = true,
				w = 107,
				h = 94,
				x = 900,
				y = 588,
			})

			local nep_face_texture = nep_face_panel:bitmap({
				visible = true,
				name = "nep_face_texture",
				layer = -1,
				texture = "guis/textures/nepgearsy_hud/" .. texture.characters[data_waifu_picked],
				blend_mode = "normal",
				x = 0,
				y = 0,
				w = 102,
				h = 90
			})
		end
	end)

	function HUDTeammate:set_waifu(waifu_name)
		local waifu_texture = self.waifu_panel:child("waifu_texture")
		waifu_texture:set_image("guis/textures/nepgearsy_hud/" .. waifu_name)
		self.waifu_panel:set_visible(true)
	end

	function HUDTeammate:remove_waifu()
		self.waifu_panel:set_visible(false)
	end
end
--[[
function HUDTeammate:set_state(state)
	local teammate_panel = self._panel
	local is_player = true
	teammate_panel:child("player"):set_alpha(is_player and 1 or 0)
	local name = teammate_panel:child("name")
	local name_bg = teammate_panel:child("name_bg")
	local callsign_bg = teammate_panel:child("callsign_bg")
	local callsign = teammate_panel:child("callsign")
	if not self._main_player then
		if is_player then
			name:set_x(48 + name:h() + 4)
			name:set_bottom(teammate_panel:h() - 30)
		else
			name:set_x(48 + name:h() + 4)
			name:set_bottom(teammate_panel:h())
		end
		name_bg:set_position(name:x(), name:y() - 1)
		callsign_bg:set_position(name:x() - name:h(), name:y() + 1)
		callsign:set_position(name:x() - name:h(), name:y() + 1)
	end
end]]

--[[
Hooks:PostHook( HUDTeammate, "init", "nephud_function_hud_ping", function(self, i, teammates_panel, is_player, width)
	if not is_player then
		local teammate_panel = teammates_panel:child("" .. i)
		local hud_ping_text = teammate_panel:text({
			name = "hud_ping_text",
			text = "1000 ms",
			layer = 1,
			color = Color(1, 0.5, 0.5, 0.5),
			y = 72,
			x = -10,
			align = "right",
			font_size = tweak_data.hud_players.name_size,
			font = tweak_data.hud_players.name_font
		})
	end
end)]]

--[[
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
		text = "999",
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
		text = "999",
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
end)]]