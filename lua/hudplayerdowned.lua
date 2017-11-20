Hooks:PostHook( HUDPlayerDowned, "init", "nephud_function_hudpd", function(self, hud)
	local downed_panel = self._hud_panel:child("downed_panel")
	local timer_msg = downed_panel:child("timer_msg")

	timer_msg:set_y(58)

	local _, _, w, h = self._hud.timer:text_rect()
	self._hud.timer:set_h(h)
	self._hud.timer:set_y(math.round(timer_msg:bottom() - 6))
	self._hud.timer:set_center_x(self._hud_panel:center_x())
end)