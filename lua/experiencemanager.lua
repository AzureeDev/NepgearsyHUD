if NepgearsyHUD and NepgearsyHUD.Data then
	if not NepgearsyHUD.Data["NepgearsyHUD_EnableXPInHud_Value"] or NepgearsyHUD.Data["NepgearsyHUD_EnableXPInHud_Value"] == false then
		AGlobalValueToStopTheMess = true
	end
end

if Utils:IsInHeist() and managers.experience then
	managers.hud._hud_objectives.level_panel:set_visible(true)
	
	local at_max_level = managers.experience:current_level() == managers.experience:level_cap()
	local next_level_data = managers.experience:next_level_data() or {}
	local progress = (next_level_data.current_points or 1) / (next_level_data.points or 1)
	local gained_xp = managers.experience:get_xp_dissected(true, 0, true)
	local can_lvl_up = not at_max_level and gained_xp >= next_level_data.points - next_level_data.current_points
	local text = "+ " .. managers.money:add_decimal_marks_to_string(tostring(gained_xp))

	managers.hud._hud_objectives.exp_gain_ring:rotate(360 * progress)
	managers.hud._hud_objectives.exp_gain_ring:set_center(managers.hud._hud_objectives.exp_ring:center())
	managers.hud._hud_objectives.gain_xp_text:set_text(text)
	
	if not at_max_level and can_lvl_up then
		--mss = HUDStatsScreen
		managers.hud._hud_objectives.potential_level_up_text:set_visible(true)
		managers.hud._hud_objectives.potential_level_up_text:set_left(math.round(managers.hud._hud_objectives.exp_ring:right() + 4))
		managers.hud._hud_objectives.potential_level_up_text:set_center_y(math.round(managers.hud._hud_objectives.exp_ring:center_y()) + 20)
		--managers.hud._hud_objectives.potential_level_up_text:animate(callback(mss, mss, "_animate_text_pulse"), managers.hud._hud_objectives.exp_gain_ring, managers.hud._hud_objectives.exp_ring)
	end
end