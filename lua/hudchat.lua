Hooks:PostHook(HUDChat, "_create_input_panel", "nephud_clean_font_chat1", function(self)
	local say = self._input_panel:child("say")
	local input_text = self._input_panel:child("input_text")
	say:set_font(Idstring("fonts/font_large_mf"))
	say:set_font_size(tweak_data.menu.pd2_small_font_size)
	input_text:set_font(Idstring("fonts/font_large_mf"))
	input_text:set_font_size(tweak_data.menu.pd2_small_font_size)
end)

-- If only fucking ovk gave a name to 'line', i wouldnt need to change this function. Fuck off
function HUDChat:receive_message(name, message, color, icon)
	local output_panel = self._panel:child("output_panel")
	local len = utf8.len(name) + 1
	local x = 0
	local icon_bitmap = nil

	if icon then
		local icon_texture, icon_texture_rect = tweak_data.hud_icons:get_icon_data(icon)
		icon_bitmap = output_panel:bitmap({
			y = 1,
			texture = icon_texture,
			texture_rect = icon_texture_rect,
			color = color
		})
		x = icon_bitmap:right()
	end

	local line = output_panel:text({
		halign = "left",
		vertical = "top",
		hvertical = "top",
		wrap = true,
		align = "left",
		blend_mode = "normal",
		word_wrap = true,
		y = 0,
		layer = 0,
		text = name .. ": " .. message,
		font = "fonts/font_large_mf",
		font_size = tweak_data.menu.pd2_small_font_size,
		x = x,
		color = color
	})
	local total_len = utf8.len(line:text())

	line:set_range_color(0, len, color)
	line:set_range_color(len, total_len, Color.white)

	local _, _, w, h = line:text_rect()

	line:set_h(h)
	table.insert(self._lines, {
		line,
		icon_bitmap
	})
	line:set_kern(line:kern())
	self:_layout_output_panel()

	if not self._focus then
		local output_panel = self._panel:child("output_panel")

		output_panel:stop()
		output_panel:animate(callback(self, self, "_animate_show_component"), output_panel:alpha())
		output_panel:animate(callback(self, self, "_animate_fade_output"))
	end
end