Hooks:PostHook(HUDHint, "init", "postinit_hint", function(self, hud)
	local panel = self._hint_panel:child("clip_panel")
	local text = panel:child("hint_text")

	text:set_font(Idstring("fonts/font_large_mf"))
	text:set_font_size(28)
end)