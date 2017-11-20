Hooks:PostHook( StatisticsManager, "init", "nephud_init_stats", function(self)
	self._kwp_points = 0
end)


Hooks:PostHook( StatisticsManager, "killed", "nephud_kill_panel", function(self, data)
	local HUDKWPTweakData = {}
	HUDKWPTweakData.difficulty_multipliers = {}
	HUDKWPTweakData.difficulty_multipliers["easy"] = 0
	HUDKWPTweakData.difficulty_multipliers["normal"] = 0.2
	HUDKWPTweakData.difficulty_multipliers["hard"] = 0.5
	HUDKWPTweakData.difficulty_multipliers["overkill"] = 0.75
	HUDKWPTweakData.difficulty_multipliers["overkill_145"] = 1
	HUDKWPTweakData.difficulty_multipliers["easy_wish"] = 1.4
	HUDKWPTweakData.difficulty_multipliers["overkill_290"] = 2.5
	HUDKWPTweakData.difficulty_multipliers["sm_wish"] = 4

	HUDKWPTweakData.points = {}
	HUDKWPTweakData.points.kill = {}
	HUDKWPTweakData.points.kill["default"] = 50
	HUDKWPTweakData.points.kill["shield"] = 150
	HUDKWPTweakData.points.kill["spooc"] = 200
	HUDKWPTweakData.points.kill["tank"] = 1000
	HUDKWPTweakData.points.kill["tank_hw"] = 3000
	HUDKWPTweakData.points.kill["tank_green"] = 1000
	HUDKWPTweakData.points.kill["tank_black"] = 1500
	HUDKWPTweakData.points.kill["tank_skull"] = 2500
	HUDKWPTweakData.points.kill["taser"] = 200
	HUDKWPTweakData.points.kill["medic"] = 200
	HUDKWPTweakData.points.kill["sniper"] = 200
	HUDKWPTweakData.points.kill["phalanx_minion"] = 1000
	HUDKWPTweakData.points.kill["biker_boss"] = 10000
	HUDKWPTweakData.points.kill["chavez_boss"] = 10000
	HUDKWPTweakData.points.kill["mobster_boss"] = 10000
	HUDKWPTweakData.points.kill["hector_boss"] = 10000
	HUDKWPTweakData.points.kill["hector_boss_no_armor"] = 10000
	HUDKWPTweakData.points.kill["drug_lord_boss"] = 10000
	HUDKWPTweakData.points.kill["drug_lord_boss_stealth"] = 10000

	HUDKWPTweakData.points.bonus = {}
	HUDKWPTweakData.points.bonus["head_multiplier"] = 1.15
	HUDKWPTweakData.points.bonus["melee_multiplier"] = 2

	local by_bullet = data.variant == "bullet"
	local by_melee = data.variant == "melee" or data.weapon_id and tweak_data.blackmarket.melee_weapons[data.weapon_id]
	local by_explosion = data.variant == "explosion"
	local by_other_variant = not by_bullet and not by_melee and not by_explosion
	local kwp_points_text = managers.hud._hud_kwp.kwp_bg_box:child("kwp_points_text")
	local text_box = managers.hud._hud_assault_corner._kills_bg_box:child("num_kills")

	if by_bullet then
		managers.hud._hud_assault_corner._total_killed_in_session = managers.hud._hud_assault_corner._total_killed_in_session + 1
		text_box:set_text(managers.hud._hud_assault_corner._total_killed_in_session)

		if HUDKWPTweakData.points.kill[data.name] then
			self._kwp_points = self._kwp_points + HUDKWPTweakData.points.kill[data.name] * HUDKWPTweakData.difficulty_multipliers[Global.game_settings.difficulty] + (data.head_shot and HUDKWPTweakData.points.bonus["head_multiplier"] or 0)
			kwp_floor = math.floor(self._kwp_points)
			kwp_points_text:set_text(tostring(kwp_floor))
		else
			self._kwp_points = self._kwp_points + HUDKWPTweakData.points.kill["default"] * HUDKWPTweakData.difficulty_multipliers[Global.game_settings.difficulty] + (data.head_shot and HUDKWPTweakData.points.bonus["head_multiplier"] or 0)
			kwp_floor = math.floor(self._kwp_points)
			kwp_points_text:set_text(tostring(kwp_floor))
		end

	elseif by_melee then
		managers.hud._hud_assault_corner._total_killed_in_session = managers.hud._hud_assault_corner._total_killed_in_session + 1
		text_box:set_text(managers.hud._hud_assault_corner._total_killed_in_session)

		if HUDKWPTweakData.points.kill[data.name] then
			self._kwp_points = self._kwp_points + HUDKWPTweakData.points.kill[data.name] * HUDKWPTweakData.difficulty_multipliers[Global.game_settings.difficulty] + HUDKWPTweakData.points.bonus["melee_multiplier"]
			kwp_floor = math.floor(self._kwp_points)
			kwp_points_text:set_text(tostring(kwp_floor))
		else
			self._kwp_points = self._kwp_points + HUDKWPTweakData.points.kill["default"] * HUDKWPTweakData.difficulty_multipliers[Global.game_settings.difficulty] + HUDKWPTweakData.points.bonus["melee_multiplier"]
			kwp_floor = math.floor(self._kwp_points)
			kwp_points_text:set_text(tostring(kwp_floor))
		end

	elseif by_explosion then
		managers.hud._hud_assault_corner._total_killed_in_session = managers.hud._hud_assault_corner._total_killed_in_session + 1
		text_box:set_text(managers.hud._hud_assault_corner._total_killed_in_session)

		if HUDKWPTweakData.points.kill[data.name] then
			self._kwp_points = self._kwp_points + HUDKWPTweakData.points.kill[data.name] * HUDKWPTweakData.difficulty_multipliers[Global.game_settings.difficulty]
			kwp_floor = math.floor(self._kwp_points)
			kwp_points_text:set_text(tostring(kwp_floor))
		else
			self._kwp_points = self._kwp_points + HUDKWPTweakData.points.kill["default"] * HUDKWPTweakData.difficulty_multipliers[Global.game_settings.difficulty]
			kwp_floor = math.floor(self._kwp_points)
			kwp_points_text:set_text(tostring(kwp_floor))
		end

	elseif by_other_variant then
		managers.hud._hud_assault_corner._total_killed_in_session = managers.hud._hud_assault_corner._total_killed_in_session + 1
		text_box:set_text(managers.hud._hud_assault_corner._total_killed_in_session)

		if HUDKWPTweakData.points.kill[data.name] then
			self._kwp_points = self._kwp_points + HUDKWPTweakData.points.kill[data.name] * HUDKWPTweakData.difficulty_multipliers[Global.game_settings.difficulty]
			kwp_floor = math.floor(self._kwp_points)
			kwp_points_text:set_text(tostring(kwp_floor))
		else
			self._kwp_points = self._kwp_points + HUDKWPTweakData.points.kill["default"] * HUDKWPTweakData.difficulty_multipliers[Global.game_settings.difficulty]
			kwp_floor = math.floor(self._kwp_points)
			kwp_points_text:set_text(tostring(kwp_floor))
		end

	end
end)