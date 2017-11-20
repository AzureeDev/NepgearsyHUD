Hooks:PostHook( HUDMissionBriefing, "init", "nephud_function_init_hmb", function(self, hud, workspace)
	self._player = {}
	self._player[1] = "0"
	self._player[2] = "0"
	self._player[3] = "0"
	self._player[4] = "0"
end)

Hooks:PostHook( HUDMissionBriefing, "set_player_slot", "nephud_function_post_bs", function(self, nr, params)
	local Net = _G.LuaNetworking
	local table_color = {}
	table_color[1] = Color(1, 1, 1, 1)
	table_color[2] = Color(1, 1, 0, 0)
	table_color[3] = Color(1, 0, 0, 1)
	table_color[4] = Color(1, 0, 1, 0)
	table_color[5] = Color(1, 1, 1, 0)
	table_color[6] = Color(1, 1, 0.73, 0)
	table_color[7] = Color(1, 0, 1, 1)
	table_color[8] = Color(1, 1, 0, 1)
	table_color[9] = Color(1, 1, 0.75, 1)
	table_color[10] = Color(1, 0, 0.61, 1)
	table_color[11] = Color(1, 0.53, 0.31, 0.67)
	table_color[12] = Color(1, 1, 0, 0.55)
	table_color[13] = Color(1, 0.63, 0.58, 0.95)

	local current_name = params.name
	local peer_id = params.peer_id

	if NepgearsyHUD and NepgearsyHUD.Data then
		if NepgearsyHUD.Data["NepgearsyHUD_Starring_Color_Value"] then
			local data_to_number = tostring(NepgearsyHUD.Data["NepgearsyHUD_Starring_Color_Value"])
			Net:SendToPeers( "NepHud_Color_Starring", data_to_number )
		end

		if NepgearsyHUD.Data["NepgearsyHUD_Starring_Text_Value"] and NepgearsyHUD.Data["NepgearsyHUD_Starring_Text_Value"] ~= "" then
			local stringify_data = tostring(NepgearsyHUD.Data["NepgearsyHUD_Starring_Text_Value"])
			Net:SendToPeers( "NepHud_Text_Starring", stringify_data )
		end
	end

	self:_update_avatar_slot(peer_id)
	self:_update_name(current_name, peer_id)

	if NepgearsyHUD and NepgearsyHUD.Data then

		local blackscreen = managers.hud._hud_blackscreen
		local blackscreen_panel = blackscreen._blackscreen_panel
		local starring_panel = blackscreen_panel:child("starring_panel")
		local player_slot = starring_panel:child("player_" .. nr)

		if NepgearsyHUD.Data["NepgearsyHUD_Starring_Color_Value"] then
			local data_to_number = tonumber(NepgearsyHUD.Data["NepgearsyHUD_Starring_Color_Value"])
			local local_peer_color = table_color[data_to_number]
			if current_name == managers.network.account:username_id() then
				player_slot:set_color(local_peer_color)
			end
		end

		if NepgearsyHUD.Data["NepgearsyHUD_Starring_Text_Value"] and NepgearsyHUD.Data["NepgearsyHUD_Starring_Text_Value"] ~= "" then
			local stringify_data = tostring(NepgearsyHUD.Data["NepgearsyHUD_Starring_Text_Value"])
			if current_name == managers.network.account:username_id() then
				player_slot:set_text(player_slot:text() .. ", " .. stringify_data)
			end
		end
	end
end)

function HUDMissionBriefing:_update_avatar_slot(peer_id)
	local peer_data = managers.network and managers.network:session() and managers.network:session():peer(peer_id)
	local steam_id = peer_data:user_id()

	self._player[peer_id] = tostring(steam_id)

	Steam:friend_avatar(2, self._player[peer_id], function (texture)
		local avatar = texture or "guis/textures/pd2/none_icon"
		local blackscreen = managers.hud._hud_blackscreen
		local blackscreen_panel = blackscreen._blackscreen_panel
		local starring_panel = blackscreen_panel:child("starring_panel")
		local player_slot = starring_panel:child("avatar_player_" .. peer_id)

		player_slot:set_image(avatar)
		player_slot:set_visible(true)
	end)
end

function HUDMissionBriefing:_update_name(name, peer_id)
	local blackscreen = managers.hud._hud_blackscreen
	local blackscreen_panel = blackscreen._blackscreen_panel
	local starring_panel = blackscreen_panel:child("starring_panel")
	local player_slot = starring_panel:child("player_" .. peer_id)

	player_slot:set_text(name)
	player_slot:set_visible(true)
end

function HUDMissionBriefing:_update_custom_starring_text(text, peer_id)
	local blackscreen = managers.hud._hud_blackscreen
	local blackscreen_panel = blackscreen._blackscreen_panel
	local starring_panel = blackscreen_panel:child("starring_panel")
	local player_slot = starring_panel:child("player_" .. peer_id)

	local previous_text = player_slot:text()
	player_slot:set_text(previous_text .. ", " .. text)
end

Hooks:Add("NetworkReceivedData", "NepHud_Color_Starring_Func", function(sender, id, data)
	local nephud_starring_id = "NepHud_Color_Starring"
    if id == nephud_starring_id then
		local table_color = {}
		table_color[1] = Color(1, 1, 1, 1)
		table_color[2] = Color(1, 1, 0, 0)
		table_color[3] = Color(1, 0, 0, 1)
		table_color[4] = Color(1, 0, 1, 0)
		table_color[5] = Color(1, 1, 1, 0)
		table_color[6] = Color(1, 1, 0.73, 0)
		table_color[7] = Color(1, 0, 1, 1)
		table_color[8] = Color(1, 1, 0, 1)
		table_color[9] = Color(1, 1, 0.75, 1)
		table_color[10] = Color(1, 0, 0.61, 1)
		table_color[11] = Color(1, 0.53, 0.31, 0.67)
		table_color[12] = Color(1, 1, 0, 0.55) 
		table_color[13] = Color(1, 0.63, 0.58, 0.95)

		local blackscreen = managers.hud._hud_blackscreen
		local blackscreen_panel = blackscreen._blackscreen_panel
		local starring_panel = blackscreen_panel:child("starring_panel")
		local player_slot = starring_panel:child("player_" .. sender)
		local data_to_number = tonumber(data)

		player_slot:set_color(table_color[data_to_number])
    end
end)

Hooks:Add("NetworkReceivedData", "NepHud_Text_Starring_Func", function(sender, id, data)

	local nephud_text_starring_id = "NepHud_Text_Starring"
	if id == nephud_text_starring_id then
    	local blackscreen = managers.hud._hud_blackscreen
		local blackscreen_panel = blackscreen._blackscreen_panel
		local starring_panel = blackscreen_panel:child("starring_panel")
		local player_slot = starring_panel:child("player_" .. sender)
		local data_to_string = tostring(data)

		managers.hud._hud_mission_briefing:_update_custom_starring_text(data_to_string, sender)
    end
end)