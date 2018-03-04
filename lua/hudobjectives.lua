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

function HUDBGBox_animate_bg_attention(bg, config)
	local color = config and config.color or Color.black
	local attention_color_function = config and config.attention_color_function
	local forever = config and config.forever or false
	local TOTAL_T = 3
	local t = TOTAL_T

	while t > 0 or forever do
		local dt = coroutine.yield()
		t = t - dt
		local cv = math.abs(math.sin(t * 90 * 1))
		local mod_color = attention_color_function and attention_color_function() or color

		bg:set_color(Color(1, mod_color.red * cv, mod_color.green * cv, mod_color.blue * cv))
	end

	bg:set_color(Color(1, 0, 0, 0))
end

Hooks:PostHook(HUDObjectives, "init", "obj_posthook_init", function(self, hud)
	local objectives_panel = self._hud_panel:child("objectives_panel")
	local amount_text = objectives_panel:child("amount_text")
	local obj_text = objectives_panel:child("objective_text")
	objectives_panel:set_y(30)
	amount_text:set_font(Idstring("fonts/font_large_mf"))
	amount_text:set_font_size(tweak_data.hud.active_objective_title_font_size)
	obj_text:set_font(Idstring("fonts/font_large_mf"))
	obj_text:set_font_size(tweak_data.hud.active_objective_title_font_size)
end)

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