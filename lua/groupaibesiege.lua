Hooks:Add("NetworkReceivedData", "NetworkAssaultStates_nepHUD", function(sender, id, data)
	if assaultstates and assaultstates.Options then
		local Net = _G.LuaNetworking
		local mod_key = "AssaultStates_Net"
	    if id == mod_key then

	    	local hac = managers.hud._hud_assault_corner

	        local function get_assault_state_options(option)
		 		if assaultstates and assaultstates.Options then
		 			return assaultstates.Options:GetValue(option)
		 		else
		 			log("[AssaultStates] Something went wrong.. Couldn't load data")
		 		end
		 	end

		 	if data == "control" then
		 		hac:_update_mod_spot(managers.localization:text("ControlTask_textlist_" .. get_assault_state_options("Textlist/textlist_control_task")))
		 		hac:_update_assault_hud_color(get_assault_state_options("Color/color_controltask"))
		 		hac:_update_state_spot(managers.localization:text("NepgearsyHUD_AssaultBar_Control_State"))
		 		hac:_toggle_state_spot(true)
		 	end

		 	if data == "anticipation" then
		 		hac:_update_mod_spot(managers.localization:text("AnticipationTask_textlist_" .. get_assault_state_options("Textlist/textlist_anticipation_task")))
		 		hac:_update_assault_hud_color(get_assault_state_options("Color/color_anticipationtask"))
		 		hac:_update_state_spot(managers.localization:text("NepgearsyHUD_AssaultBar_Anticipation_State"))
		 		hac:_toggle_state_spot(true)
		 	end

		 	if data == "build" then
		 		hac:_update_mod_spot(managers.localization:text("BuildTask_textlist_" .. get_assault_state_options("Textlist/textlist_build_task")))
		 		hac:_update_assault_hud_color(get_assault_state_options("Color/color_buildtask"))
		 		hac:_update_state_spot(managers.localization:text("NepgearsyHUD_AssaultBar_Build_State"))
		 		hac:_toggle_state_spot(true)
		 	end

		 	if data == "sustain" then
		 		hac:_update_mod_spot(managers.localization:text("SustainTask_textlist_" .. get_assault_state_options("Textlist/textlist_sustain_task")))
		 		hac:_update_assault_hud_color(get_assault_state_options("Color/color_sustaintask"))
		 		hac:_update_state_spot(managers.localization:text("NepgearsyHUD_AssaultBar_Sustain_State"))
		 		hac:_toggle_state_spot(true)
		 	end

		 	if data == "fade" then
		 		hac:_update_mod_spot(managers.localization:text("FadeTask_textlist_" .. get_assault_state_options("Textlist/textlist_fade_task")))
		 		hac:_update_assault_hud_color(get_assault_state_options("Color/color_fadetask"))
		 		hac:_update_state_spot(managers.localization:text("NepgearsyHUD_AssaultBar_Fade_State"))
		 		hac:_toggle_state_spot(true)
		 	end
		end
	end
end)

Hooks:PostHook( GroupAIStateBesiege, "init", "nephud_function_init_value", function(self, group_ai_state)
	self.total_phalanx_chance = 0
end)

if NepgearsyHUD and NepgearsyHUD.Data and NepgearsyHUD.Data["NepgearsyHUD_CompactAssaultStateMode_Value"] == 2 then
	Hooks:PostHook( GroupAIStateBesiege, "_upd_assault_task", "nephud_function", function(self)
	 	local task_data = self._task_data.assault
	    local current_wave = self:get_assault_number()
	    
	    if managers.groupai:state():get_hunt_mode() then
	        
	        if managers.hud._hud_assault_corner._assault_mode ~= "phalanx" then
	            managers.hud._hud_assault_corner.current_heist_state:set_text("ENDLESS ASSAULT")

	            if NepgearsyHUD and NepgearsyHUD.Data then
	                if NepgearsyHUD.Data["NepgearsyHUD_EnableChatMessages_Value"] and task_data.phase ~= last_displayed_phase then
	            		managers.chat:send_message(ChatManager.GAME, managers.network.account:username() or "Offline", "[WAVE " .. current_wave .. "] Now in ENDLESS ASSAULT !")
	        		end
	        	end
	        end
	        
	    else
	    
	        local displayed_text
			local time_left
	        local time_between_each_send
	        local mod
	        
	        if task_data.phase_end_t and self._t then
	            time_left = math.ceil(task_data.phase_end_t - self._t)
	            mod = time_left - math.floor(time_left/5)*5
	            if mod == 4 then
	                time_left = time_left + 1
	            end
	        end
	        
	        if task_data.phase == "anticipation" and not managers.groupai:state():get_hunt_mode() then
	            displayed_text = "[WAVE " .. current_wave .. "] Assault starting in " .. time_left .. " seconds."
	            time_between_each_send = 15
	        end

	        if task_data.phase == "build" and not managers.groupai:state():get_hunt_mode() then
	            displayed_text = "[WAVE " .. current_wave .. "] Assault building - " .. time_left .. " seconds left."
	            time_between_each_send = 15
	        end

	        if task_data.phase == "sustain" and not managers.groupai:state():get_hunt_mode() then
	            displayed_text = "[WAVE " .. current_wave .. "] Assault - " .. time_left .. " seconds left."
	            time_between_each_send = 30
	        end

	        if task_data.phase == "fade" and not managers.groupai:state():get_hunt_mode() then
	            if time_left > 0 then
	                displayed_text = "[WAVE " .. current_wave .. "] Assault over in " .. time_left .. " seconds."
	                time_between_each_send = 15
	            else
	                displayed_text = "[WAVE " .. current_wave .. "] Assault will be over when the remaining ennemies will be killed."
	                time_between_each_send = 60
	            end
	        end
	        
	        if time_left then
	            if time_left > 120 then
	                time_between_each_send = 60
	            elseif time_left > 30 then
	                time_between_each_send = 30
	            end
	        end
	        
	        if displayed_text then
	            managers.hud._hud_assault_corner.current_heist_state:set_text(displayed_text)
	            
	            if task_data.phase ~= last_displayed_phase then
	                managers.hud:show_hint( { text = displayed_text } )
	                
	                if NepgearsyHUD and NepgearsyHUD.Data then
	                    if NepgearsyHUD.Data["NepgearsyHUD_EnableChatMessages_Value"] then
	                        managers.chat:send_message(ChatManager.GAME, managers.network.account:username() or "Offline", displayed_text)
	                    end
	                end
	                
	                last_time_left = time_left
	            end
	            
	            if NepgearsyHUD and NepgearsyHUD.Data then
	                if NepgearsyHUD.Data["NepgearsyHUD_EnableChatMessages_Value"] then
	                    if time_left - math.floor(time_left / time_between_each_send) * time_between_each_send == 0 and time_left ~= last_time_left then
	                        managers.chat:send_message(ChatManager.GAME, managers.network.account:username() or "Offline", displayed_text)
	                    end
	                end
	            end
	        end
	        
	        last_time_left = time_left
	        
	    end
	    
	 	if managers.hud._hud_assault_corner._assault_mode == "phalanx" then
	 		managers.hud._hud_assault_corner.current_heist_state:set_text("[WAVE " .. current_wave .. "] CAPTAIN WINTERS LOCKED THE ASSAULT")
	 	end
	    
	    last_displayed_phase = task_data.phase
	    
	end )
else
	Hooks:PostHook( GroupAIStateBesiege, "_upd_assault_task", "nephud_function", function(self)
	 	local task_data = self._task_data.assault
	 	local assault_state_installed = false

	 	if assaultstates and assaultstates.Options then
	 		assault_state_installed = true
	 	end

	 	local function get_assault_state_options(option)
	 		if assaultstates and assaultstates.Options then
	 			return assaultstates.Options:GetValue(option)
	 		else
	 			log("[NepgearsyHUD @AssaultStates] Something went wrong.. Couldn't load data")
	 		end
	 	end

		if task_data.phase == "anticipation" and not managers.groupai:state():get_hunt_mode() then
	 		managers.hud._hud_assault_corner.current_heist_state:set_text(managers.localization:text("NepgearsyHUD_AssaultBar_Anticipation_State"))
	 		if assault_state_installed then
	 			managers.hud._hud_assault_corner:_update_assault_hud_color(get_assault_state_options("Color/color_anticipationtask"))
	 			managers.hud._hud_assault_corner:_update_mod_spot(managers.localization:text("AnticipationTask_textlist_" .. get_assault_state_options("Textlist/textlist_anticipation_task")))
	 		end
	 	end

		if task_data.phase == "build" and not managers.groupai:state():get_hunt_mode() then
	 		managers.hud._hud_assault_corner.current_heist_state:set_text(managers.localization:text("NepgearsyHUD_AssaultBar_Build_State"))
	 		if self:get_assault_number() ~= 0 then
	 			managers.hud._hud_assault_corner._bg_box_text:set_text(managers.localization:to_upper_text("hud_assault_assault"))
	 		end
	 		if assault_state_installed then
	 			managers.hud._hud_assault_corner:_update_assault_hud_color(get_assault_state_options("Color/color_buildtask"))
	 			managers.hud._hud_assault_corner:_update_mod_spot(managers.localization:text("BuildTask_textlist_" .. get_assault_state_options("Textlist/textlist_build_task")))
	 		end
	 	end

	 	if task_data.phase == "sustain" and not managers.groupai:state():get_hunt_mode() then
	 		managers.hud._hud_assault_corner.current_heist_state:set_text(managers.localization:text("NepgearsyHUD_AssaultBar_Sustain_State"))
	 		if assault_state_installed then
	 			managers.hud._hud_assault_corner:_update_assault_hud_color(get_assault_state_options("Color/color_sustaintask"))
	 			managers.hud._hud_assault_corner:_update_mod_spot(managers.localization:text("SustainTask_textlist_" .. get_assault_state_options("Textlist/textlist_sustain_task")))
	 		end
	 	end

	 	if task_data.phase == "fade" and not managers.groupai:state():get_hunt_mode() then
	 		managers.hud._hud_assault_corner.current_heist_state:set_text(managers.localization:text("NepgearsyHUD_AssaultBar_Fade_State"))
	 		if assault_state_installed then
	 			managers.hud._hud_assault_corner:_update_assault_hud_color(get_assault_state_options("Color/color_fadetask"))
	 			managers.hud._hud_assault_corner:_update_mod_spot(managers.localization:text("FadeTask_textlist_" .. get_assault_state_options("Textlist/textlist_fade_task")))
	 		end
	 	end

	 	if managers.groupai:state():get_hunt_mode() and managers.hud._hud_assault_corner._assault_mode ~= "phalanx" then
	 		managers.hud._hud_assault_corner.current_heist_state:set_text(managers.localization:text("NepgearsyHUD_AssaultBar_Endless_State"))
	 		managers.hud._hud_assault_corner._bg_box_text:set_text(managers.localization:text("NepgearsyHUD_AssaultBar_Endless"))
	 		managers.hud._hud_assault_corner:_update_mod_spot("")
	 	end

	 	if managers.hud._hud_assault_corner._assault_mode == "phalanx" then
	 		managers.hud._hud_assault_corner.current_heist_state:set_text(managers.localization:text("NepgearsyHUD_AssaultBar_WintersLocked_State"))
	 		managers.hud._hud_assault_corner._bg_box_text:set_text(managers.localization:text("NepgearsyHUD_AssaultBar_WintersLocked"))
	 		managers.hud._hud_assault_corner:_update_mod_spot("")
	 	end

	end )
end

Hooks:PostHook( GroupAIStateBesiege, "_upd_recon_tasks", "nephud_recon_function", function(self)
 	local assault_state_installed = false

 	if assaultstates and assaultstates.Options then
 		assault_state_installed = true
 	end

 	local function get_assault_state_options(option)
 		if assaultstates and assaultstates.Options then
 			return assaultstates.Options:GetValue(option)
 		else
 			log("[NepgearsyHUD @AssaultStates] Something went wrong.. Couldn't load data")
 		end
 	end

 	if Network:is_server() then
	 	if self:get_assault_number() == 0 then
	 		if not managers.hud._hud_assault_corner._assault and not managers.groupai:state():get_hunt_mode() and not managers.hud._hud_assault_corner._point_of_no_return then
		 		managers.hud._hud_assault_corner.current_heist_state:set_text(managers.localization:text("NepgearsyHUD_AssaultBar_FirstAssault_State"))
		 		managers.hud._hud_assault_corner._bg_box_text:set_text(managers.localization:text("NepgearsyHUD_AssaultBar_FirstAssault"))
		 
		 		if assault_state_installed then
		 			managers.hud._hud_assault_corner:_update_assault_hud_color(get_assault_state_options("Color/color_controltask"))
		 			managers.hud._hud_assault_corner:_update_mod_spot(managers.localization:text("ControlTask_textlist_" .. get_assault_state_options("Textlist/textlist_control_task")))
		 		end
	        end
		else
			if not managers.hud._hud_assault_corner._assault and not managers.hud._hud_assault_corner._point_of_no_return then
		 		managers.hud._hud_assault_corner.current_heist_state:set_text(managers.localization:text("NepgearsyHUD_AssaultBar_Survived"))
		 		managers.hud._hud_assault_corner._bg_box_text:set_text(managers.localization:text("NepgearsyHUD_AssaultBar_Survived"))
		 		
		 		if assault_state_installed then
		 			managers.hud._hud_assault_corner:_update_assault_hud_color(get_assault_state_options("Color/color_controltask"))
		 			managers.hud._hud_assault_corner:_update_mod_spot(managers.localization:text("ControlTask_textlist_" .. get_assault_state_options("Textlist/textlist_control_task")))
		 		end
			end
		end
	end
end)