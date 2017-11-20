function HUDBGBox_create(panel, params, config)
	local box_panel = panel:panel(params)
	local color = config and config.color
	local bg_color = config and config.bg_color or Color(1, 0, 0, 0)
	local blend_mode = config and config.blend_mode
	box_panel:rect({
		name = "bg",
		halign = "grow",
		valign = "grow",
		blend_mode = "normal",
		alpha = 0.35,
		color = bg_color,
		layer = -1
	})
	local left_top = box_panel:bitmap({
		name = "left_top",
		halign = "left",
		valign = "top",
		name = "left_top",
		color = color,
		blend_mode = blend_mode,
		visible = false,
		layer = 0,
		texture = "guis/textures/pd2/hud_corner",
		x = 0,
		y = 0
	})
	local left_bottom = box_panel:bitmap({
		name = "left_bottom",
		halign = "left",
		valign = "bottom",
		color = color,
		rotation = -90,
		name = "left_bottom",
		blend_mode = blend_mode,
		visible = false,
		layer = 0,
		texture = "guis/textures/pd2/hud_corner",
		x = 0,
		y = 0
	})
	left_bottom:set_bottom(box_panel:h())
	local right_top = box_panel:bitmap({
		name = "right_top",
		halign = "right",
		valign = "top",
		color = color,
		rotation = 90,
		name = "right_top",
		blend_mode = blend_mode,
		visible = false,
		layer = 0,
		texture = "guis/textures/pd2/hud_corner",
		x = 0,
		y = 0
	})
	right_top:set_right(box_panel:w())
	local right_bottom = box_panel:bitmap({
		name = "right_bottom",
		halign = "right",
		valign = "bottom",
		color = color,
		rotation = 180,
		name = "right_bottom",
		blend_mode = blend_mode,
		visible = false,
		layer = 0,
		texture = "guis/textures/pd2/hud_corner",
		x = 0,
		y = 0
	})
	right_bottom:set_right(box_panel:w())
	right_bottom:set_bottom(box_panel:h())
	return box_panel
end
function HUDBGBox_create_assault(panel, params, config)
	local box_panel = panel:panel(params)
	local color = config and config.color
	local bg_color = config and config.bg_color or Color(1, 0, 0, 0)
	local blend_mode = config and config.blend_mode
	box_panel:rect({
		name = "bg",
		halign = "grow",
		valign = "grow",
		blend_mode = "normal",
		alpha = 0.35,
		color = bg_color,
		layer = -1
	})
	local left_top = box_panel:bitmap({
		name = "left_top",
		halign = "left",
		valign = "top",
		name = "left_top",
		color = color,
		blend_mode = blend_mode,
		visible = true,
		layer = 0,
		texture = "guis/textures/pd2/hud_corner",
		x = 0,
		y = 0
	})
	local left_bottom = box_panel:bitmap({
		name = "left_bottom",
		halign = "left",
		valign = "bottom",
		color = color,
		rotation = -90,
		name = "left_bottom",
		blend_mode = blend_mode,
		visible = true,
		layer = 0,
		texture = "guis/textures/pd2/hud_corner",
		x = 0,
		y = 0
	})
	left_bottom:set_bottom(box_panel:h())
	local right_top = box_panel:bitmap({
		name = "right_top",
		halign = "right",
		valign = "top",
		color = color,
		rotation = 90,
		name = "right_top",
		blend_mode = blend_mode,
		visible = true,
		layer = 0,
		texture = "guis/textures/pd2/hud_corner",
		x = 0,
		y = 0
	})
	right_top:set_right(box_panel:w())
	local right_bottom = box_panel:bitmap({
		name = "right_bottom",
		halign = "right",
		valign = "bottom",
		color = color,
		rotation = 180,
		name = "right_bottom",
		blend_mode = blend_mode,
		visible = true,
		layer = 0,
		texture = "guis/textures/pd2/hud_corner",
		x = 0,
		y = 0
	})
	right_bottom:set_right(box_panel:w())
	right_bottom:set_bottom(box_panel:h())
	return box_panel
end
local box_speed = 100
function HUDBGBox_animate_open_down(panel, wait_t, target_h, done_cb, config)
	config = config or {}
	panel:set_visible(false)
	local top = panel:top()
	panel:set_h(0)
	panel:set_top(top)
	if wait_t then
		wait(wait_t)
	end
	panel:set_visible(true)
	local speed = box_speed
	local bg = panel:child("bg")
	bg:stop()
	bg:animate(callback(nil, _G, "HUDBGBox_animate_bg_attention"), {
		color = config.attention_color,
		attention_color_function = config.attention_color_function,
		forever = config.attention_forever
	})
	local TOTAL_T = target_h / speed
	local t = TOTAL_T
	while t > 0 do
		local dt = coroutine.yield()
		t = t - dt
		panel:set_h((1 - t / TOTAL_T) * target_h)
		panel:set_top(top)
	end
	panel:set_h(target_h)
	panel:set_top(top)
	done_cb()
end
function HUDBGBox_animate_close_down(panel, done_cb)
	local speed = box_speed
	local cw = panel:h()
	local TOTAL_T = cw / speed
	local t = TOTAL_T
	while t > 0 do
		local dt = coroutine.yield()
		t = t - dt
		panel:set_h(t / TOTAL_T * cw)
	end
	panel:set_h(0)
	done_cb()
end

function HUDObjectives:init(hud)
	self._hud_panel = hud.panel
	if self._hud_panel:child("objectives_panel") then
		self._hud_panel:remove(self._hud_panel:child("objectives_panel"))
	end
	local objectives_panel = self._hud_panel:panel({
		visible = false,
		name = "objectives_panel",
		x = 0,
		y = 30,
		h = 100,
		w = 500,
		valign = "top"
	})
	self.level_panel = self._hud_panel:panel({
		visible = false,
		name = "level_panel",
		x = 0,
		y = 0,
		h = 200,
		w = 700,
		valign = "top"
	})
	self._bg_box_level = HUDBGBox_create(self.level_panel, {
		w = 250,
		h = 90,
		x = 0,
		y = 140
	})
	local icon_objectivebox = objectives_panel:bitmap({
		halign = "left",
		valign = "top",
		name = "icon_objectivebox",
		blend_mode = "normal",
		visible = true,
		layer = 0,
		texture = "guis/textures/pd2/hud_icon_objectivebox",
		x = 0,
		y = 34,
		w = 24,
		h = 24
	})
	self._bg_box = HUDBGBox_create(objectives_panel, {
		w = 200,
		h = 38,
		x = 26,
		y = 0
	})
	local objective_text = objectives_panel:text({
		name = "objective_text",
		visible = false,
		layer = 2,
		color = Color.white,
		text = "",
		font_size = tweak_data.hud.active_objective_title_font_size,
		font = tweak_data.hud.medium_font_noshadow,
		x = 0,
		y = 34 + 8,
		align = "left",
		vertical = "top"
	})
	objective_text:set_x(self._bg_box:x() + 8)
	objective_text:set_y(6)
	local amount_text = objectives_panel:text({
		name = "amount_text",
		visible = true,
		layer = 2,
		color = Color.white,
		text = "1/4",
		font_size = tweak_data.hud.active_objective_title_font_size,
		font = tweak_data.hud.medium_font_noshadow,
		x = 6,
		y = 0,
		align = "left",
		vertical = "top"
	})
	amount_text:set_x(objective_text:x())
	amount_text:set_y(objective_text:y() + objective_text:font_size() - 2)

	self:recreate_ring_level()

	self.level_panel:set_top(objectives_panel:bottom() - 100)
	self.level_panel:set_left(objectives_panel:left() + 26)
end

function HUDObjectives:recreate_ring_level()
	local next_level_data = managers.experience:next_level_data() or {}
	local bg_ring = self.level_panel:bitmap({
		texture = "guis/textures/pd2/level_ring_small",
		w = 61,
		h = 61,
		color = Color.black,
		alpha = 0.4
	})
	self.exp_ring = self.level_panel:bitmap({
		texture = "guis/textures/pd2/level_ring_small",
		rotation = 360,
		w = 61,
		h = 61,
		color = Color((next_level_data.current_points or 1) / (next_level_data.points or 1), 1, 1),
		render_template = "VertexColorTexturedRadial",
		blend_mode = "add",
		layer = 1
	})
	bg_ring:set_bottom(self.level_panel:h())
	self.exp_ring:set_bottom(self.level_panel:h())
	self.gain_xp = 0
	local at_max_level = managers.experience:current_level() == managers.experience:level_cap()
	local can_lvl_up = not at_max_level and self.gain_xp >= next_level_data.points - next_level_data.current_points
	local progress = (next_level_data.current_points or 1) / (next_level_data.points or 1)
	local gain_progress = (self.gain_xp or 1) / (next_level_data.points or 1)
	self.exp_gain_ring = self.level_panel:bitmap({
		texture = "guis/textures/pd2/level_ring_potential_small",
		rotation = 360,
		w = 61,
		h = 61,
		color = Color(gain_progress, 1, 0),
		render_template = "VertexColorTexturedRadial",
		blend_mode = "normal",
		layer = 2
	})
	self.exp_gain_ring:rotate(360 * progress)
	self.exp_gain_ring:set_center(self.exp_ring:center())
	local level_text = self.level_panel:text({
		name = "level_text",
		font = tweak_data.menu.pd2_medium_font,
		font_size = tweak_data.hud_stats.day_description_size,
		text = tostring(managers.experience:current_level()),
		color = tweak_data.screen_colors.text
	})
	managers.hud:make_fine_text(level_text)
	level_text:set_center(self.exp_ring:center())
	self.gain_xp_text = self.level_panel:text({
		name = "gain_xp_text",
		text = text,
		font_size = tweak_data.menu.pd2_small_font_size,
		font = tweak_data.menu.pd2_small_font,
		color = tweak_data.hud_stats.potential_xp_color
	})
	if at_max_level then
		local text = managers.localization:to_upper_text("hud_at_max_level")
		local at_max_level_text = self.level_panel:text({
			name = "at_max_level_text",
			text = text,
			font_size = tweak_data.menu.pd2_small_font_size,
			font = tweak_data.menu.pd2_small_font,
			color = tweak_data.hud_stats.potential_xp_color
		})
		managers.hud:make_fine_text(at_max_level_text)
		self.gain_xp_text:set_visible(false)
		at_max_level_text:set_left(math.round(self.exp_ring:right() + 4))
		at_max_level_text:set_center_y(math.round(self.exp_ring:center_y()) + 0)
	else
		local next_level_in = self.level_panel:text({
			name = "next_level_in",
			text = "",
			font_size = tweak_data.menu.pd2_small_font_size,
			font = tweak_data.menu.pd2_small_font,
			color = tweak_data.screen_colors.text
		})
		local points = next_level_data.points - next_level_data.current_points
		next_level_in:set_text(utf8.to_upper(managers.localization:text("menu_es_next_level") .. " " .. managers.money:add_decimal_marks_to_string(tostring(points))))
		managers.hud:make_fine_text(next_level_in)
		next_level_in:set_left(math.round(self.exp_ring:right() + 4))
		next_level_in:set_center_y(math.round(self.exp_ring:center_y()) - 20)
		local text = managers.localization:to_upper_text("hud_potential_xp", {
			XP = managers.money:add_decimal_marks_to_string(tostring(self.gain_xp))
		})
		managers.hud:make_fine_text(self.gain_xp_text)
		self.gain_xp_text:set_left(math.round(self.exp_ring:right() + 4))
		self.gain_xp_text:set_center_y(math.round(self.exp_ring:center_y()) + 0)
		local text = managers.localization:to_upper_text("hud_potential_level_up")
		self.potential_level_up_text = self.level_panel:text({
			layer = 3,
			name = "potential_level_up_text",
			align = "left",
			vertical = "center",
			blend_mode = "normal",
			visible = false,
			text = text,
			font_size = tweak_data.menu.pd2_small_font_size,
			font = tweak_data.menu.pd2_small_font,
			color = tweak_data.hud_stats.potential_xp_color
		})
		managers.hud:make_fine_text(self.potential_level_up_text)
	end
end

function HUDObjectives:activate_objective(data)
	print("[HUDObjectives] activate_objective", data.id, data.amount)
	self._active_objective_id = data.id
	local objectives_panel = self._hud_panel:child("objectives_panel")
	local objective_text = objectives_panel:child("objective_text")
	objective_text:set_text("- " .. utf8.to_upper(data.text))
	local _, _, w, _ = objective_text:text_rect()
	objectives_panel:set_visible(true)
	self._bg_box:set_h(data.amount and 60 or 38)
	objective_text:set_visible(false)
	self._bg_box:stop()
	self._bg_box:animate(callback(nil, _G, "HUDBGBox_animate_open_right"), 0.66, w + 16, callback(self, self, "open_right_done", data.amount and true or false))
	objectives_panel:stop()
	objectives_panel:animate(callback(self, self, "_animate_activate_objective"))
	objectives_panel:child("amount_text"):set_visible(false)
	if data.amount then
		self:update_amount_objective(data)
	end
end

function HUDObjectives:update_amount_objective(data)
	print("[HUDObjectives] update_amount_objective", data.id, data.current_amount, data.amount)
	if data.id == self._active_objective_id then
		local current = data.current_amount or 0
		local amount = data.amount
		local calc_remaining = amount - current
		local objectives_panel = self._hud_panel:child("objectives_panel")
		local amount_text = objectives_panel:child("amount_text")
		
		if managers.job:current_job_id() ~= "chill_combat" then
			if alive(amount_text) then
				amount_text:set_text(calc_remaining .. " required")
			end
		else
			if alive(amount_text) then
				amount_text:set_text(current .. " bags remaining")
			end
		end
	end
end