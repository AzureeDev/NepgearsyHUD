Hooks:PostHook(Setup, "init_managers", "nephud_presenter_clean_font", function(self, managers)
	managers.subtitle:set_presenter(CoreSubtitlePresenter.OverlayPresenter:new("fonts/font_large_mf", tweak_data.menu.pd2_medium_font_size))
end)