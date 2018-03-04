function HUDHeistTimer:init(hud, tweak_hud)
	self._hud_panel = hud.panel
	if self._hud_panel:child("heist_timer_panel") then
		self._hud_panel:remove(self._hud_panel:child("heist_timer_panel"))
	end
	self._heist_timer_panel = self._hud_panel:panel({
		visible = true,
		name = "heist_timer_panel",
		h = 40,
		y = 22,
		valign = "center",
		layer = 0
	})

	self._timer_text = self._heist_timer_panel:text({
		name = "timer_text",
		text = "00:00",
		font_size = 24,
		font = "fonts/font_large_mf",
		color = Color.white,
		align = "center",
		vertical = "center",
		layer = 1,
		wrap = false,
		word_wrap = false
	})

	self._last_time = 0
	self._enabled = not tweak_hud.no_timer
	if not self._enabled then
		self._heist_timer_panel:hide()
	end
end