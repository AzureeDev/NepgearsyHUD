if RequiredScript == "lib/managers/hudmanagerpd2" then

	HUDKWP = HUDKWP or class()

	function HUDKWP:init(parent)
		self._parent = parent
		self._total_kwp_points = "0"
		self._is_enabled = NepgearsyHUD.Data["NepgearsyHUD_Enable_KWP_Value"] or false
		self._font_size = 16
		self._font = tweak_data.hud.medium_font_noshadow
		
		self.kwp_main_panel = self._parent:panel({
			visible = self._is_enabled,
			name = "kwp_main_panel",
			w = 250,
			h = 200,
			align = "left",
			y = 95,
			x = 26
		})

		self.kwp_bg_box = HUDBGBox_create(self.kwp_main_panel, {
			w = 250,
			h = 30,
			x = 0,
			y = 0
		}, {
			blend_mode = "add",
			visible = self._is_enabled
		})

		local kwp_name_text = self.kwp_bg_box:text({
			name = "kwp_name_text",
			visible = self._is_enabled,
			layer = 2,
			color = Color.white,
			text = managers.network.account:username_id(),
			font_size = self._font_size,
			font = self._font,
			x = 5,
			y = 0,
			w = self.kwp_bg_box:w(),
			h = self.kwp_bg_box:h(),
			align = "left",
			vertical = "center",
			valign = "center"
		})

		local kwp_points_text = self.kwp_bg_box:text({
			name = "kwp_points_text",
			visible = self._is_enabled,
			layer = 2,
			color = Color.white,
			text = self._total_kwp_points,
			font_size = self._font_size,
			font = self._font,
			x = -5,
			y = 0,
			w = self.kwp_bg_box:w(),
			h = self.kwp_bg_box:h(),
			align = "right",
			vertical = "center",
			valign = "center"
		})
	end

    local HUDManager_setup_player_info_hud_pd2_original = HUDManager._setup_player_info_hud_pd2

	function HUDManager:_setup_player_info_hud_pd2(...)
        HUDManager_setup_player_info_hud_pd2_original(self, ...)
        self:_setup_kwp_element()
    end

	function HUDManager:_setup_kwp_element()
		local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
		self._hud_kwp = HUDKWP:new(hud.panel)
	end
end