Hooks:PostHook(TweakData, "_init_pd2", "convert_all_clean_font_pd2", function(self)
	self.hud_players = {
		name_font = "fonts/font_large_mf",
		name_size = 19,
		ammo_font = "fonts/font_large_mf",
		ammo_size = 24,
		timer_font = "fonts/font_large_mf",
		timer_size = 30,
		timer_flash_size = 50
	}
	self.hud_present = {
		title_font = "fonts/font_large_mf",
		title_size = 28,
		text_font = "fonts/font_large_mf",
		text_size = 28
	}
	self.hud_mask_off = {
		text_size = 28,
		text_font = "fonts/font_large_mf"
	}
	self.hud_stats = {
		objectives_font = "fonts/font_large_mf",
		objective_desc_font = "fonts/font_large_mf",
		objectives_title_size = 28,
		objectives_size = 24,
		loot_size = 24,
		loot_title_size = 28,
		day_description_size = 22,
		potential_xp_color = Color(0, 0.6666666666666666, 1)
	}
	self.hud_corner = {
		assault_font = "fonts/font_large_mf",
		assault_size = 24,
		noreturn_size = 24,
		numhostages_size = 24
	}
	self.hud_downed = {timer_message_size = 24}
	self.hud_custody = {
		custody_font = "fonts/font_large_mf",
		custody_font_large = "fonts/font_large_mf",
		font_size = 28,
		small_font_size = 24
	}
end)