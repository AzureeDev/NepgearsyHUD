if SystemFS:exists("assets/mod_overrides/NepgearsyHUD Waifu Assets/add.xml") then
	local NepHudWaifu = "NepHudWaifu"
	Hooks:Add("NetworkReceivedData", "NetworkReceivedData_NepHudWaifu", function(sender, id, data)

	    if id == NepHudWaifu then
	    	local Net = _G.LuaNetworking
	    	local waifu_name = data
	    	
	    	if Net:IsHost() then
	    		local sender_correction = sender - 1
	    		managers.hud._teammate_panels[sender_correction]:set_waifu(waifu_name)
	    	else
	    		managers.hud._teammate_panels[sender]:set_waifu(waifu_name)
	    	end
	    end

	end)
end
