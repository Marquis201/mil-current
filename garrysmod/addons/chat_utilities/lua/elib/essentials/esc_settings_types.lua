

esclib.allowed_settings_types = esclib.allowed_settings_types or {}

function esclib:AddNewSettingsType(name, important_vars, secondary_vars, build_func)
	self.allowed_settings_types[name] = {}
	self.allowed_settings_types[name]["important_vars"] = important_vars or {}
	self.allowed_settings_types[name]["secondary_vars"] = secondary_vars or {}
	if (CLIENT) then self.allowed_settings_types[name]["draw_func"] = build_func end
end

------------
--# BOOL #--
------------
local name = "bool"
local required_params = {"value"}
local secondary_params = {}
local build_func = function( panel, addon, varid, varc, callback, other ) --not used on serverside

	--other: button_wide / button_tall / current_vars_copy
	local button_wide= other["button_wide"]
	local button_tall = other["button_tall"]
	local vars_copy = other["vars_copy"]
	local settab = other["bg"]

	local clr = esclib.addon:GetColors()

	local name_tr  = varc.name or addon:Translate(varc.name_tr)
	local desc = varc.desc or addon:Translate(varc.desc_tr)
	if (varc.change_type == "usergroup") or (varc.change_type == "steamid") then
		if varc.who_can_change and istable(varc.who_can_change) then
			if not desc then desc = "" end
			desc = desc.." "..esclib.addon:Translate("phrase_WhoCanChange")..": [ "
			for k,v in pairs(varc.who_can_change) do
				desc = desc..tostring(k).." "
			end
			desc = desc.." ]"
		end
	end

	if (varc.change_type == "boolean") then
		if not varc.who_can_change then
			if not desc then desc = "" end
			desc = desc.." "..esclib.addon:Translate("phrase_WhoCanChange")..": [ "..esclib.addon:Translate("phrase_NoOne").." ]"
		end
	end

	local name = esclib.util:TextCutAccurate(name_tr, esclib:AdaptiveFont("esclib", 24, 500), button_wide-15-90, "...")

	local button = panel:Add("DButton")
	button:SetSize(button_wide, button_tall)
	button:SetText("")
	if desc then
		button:eAddHint(desc,esclib:AdaptiveFont("esclib", 20, 500),TEXT_ALIGN_TOP,settab)
	end

	function button:DoClick()
		varc.value = not varc.value
		callback(varid,varc.value)
	end
	function button:Paint(w,h)
		local hovered = self:IsHovered()

		draw.RoundedBox(0,0,0,w,h,hovered and clr.button.hover or clr.button.main)

		draw.SimpleText(name,esclib:AdaptiveFont("esclib", 24, 500),15,h*0.5,clr.button.text,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

		local checkbox_size = h*0.25
		esclib.draw:MaterialCentered(w-checkbox_size-15, h*0.5, checkbox_size,  hovered and clr.button.main or clr.button.hover , esclib.Materials["box.png"])
		if varc.value then
			esclib.draw:MaterialCentered(w-checkbox_size-15, h*0.5, checkbox_size*0.6, clr.frame.text, esclib.Materials["true.png"])
		end

		--if changed
		if varc.value ~= vars_copy[varid] then
			draw.RoundedBox(0,0,h-3,w,3,clr.button.discard)
		end
	end
end

esclib:AddNewSettingsType(name, required_params, secondary_params, build_func)

-------------
--# FLOAT #--
-------------
local name = "float"
local required_params = {"value"}
local secondary_params = {"min", "max"}
local build_func = function( panel, addon, varid, varc, callback, other )

	local button_wide= other["button_wide"]
	local button_tall = other["button_tall"]
	local addon_vars_copy = other["vars_copy"]
	local settab = other["bg"]
	local clr = esclib.addon:GetColors()
	local name_tr  = varc.name or addon:Translate(varc.name_tr)
	local desc = varc.desc or addon:Translate(varc.desc_tr)

	local name = esclib.util:TextCutAccurate(name_tr, esclib:AdaptiveFont("esclib", 24, 500), button_wide-15-90, "...")

	local button = panel:Add("DButton")
	button:SetSize(button_wide, button_tall)
	button:SetText("")
	if desc then
		local added = ""
		if varc.max or varc.min then
			added = "("..(varc.min or "∞").." - "..(varc.max or "∞")..")\n"
		end
		button:eAddHint(added.." "..desc,esclib:AdaptiveFont("esclib", 20, 500),TEXT_ALIGN_CENTER,settab)
	end

	function button:DoClick()
		esclib:TextInputWindow(esclib.addon:Translate("window_ValueEdit"), (addon:Translate(varc.name_tr) or varc.name).." ("..varc.value..")",true,function(res)
			if not res then return end
			if res == 0 then return end
			if varc.max and varc.min then
				res = math.Clamp(res, varc.min, varc.max)
			elseif varc.max then
				res = math.Clamp(res, -math.huge, varc.max)
			elseif varc.min then
				res = math.Clamp(res, varc.min, math.huge)
			end
				
			varc.value = res
			callback(varid,varc.value)
		end)
	end
	function button:Paint(w,h)
		local hovered = self:IsHovered()
		draw.RoundedBox(0,0,0,w,h,hovered and clr.button.hover or clr.button.main)

		draw.SimpleText(name,esclib:AdaptiveFont("esclib", 24, 500),15,h*0.5,clr.button.text,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText(varc.value,esclib:AdaptiveFont("esclib", 24, 500),w-15,h*0.5,clr.button.apply,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1)

		--if changed
		if varc.value ~= addon_vars_copy[varid] then
			draw.RoundedBox(0,0,h-5,w,5,clr.button.discard)
		end
	end
end

esclib:AddNewSettingsType(name, required_params, secondary_params, build_func)


-----------------
--# NUMSLIDER #--
-----------------
local name = "numslider"
local required_params = { "value", "min", "max" }
local secondary_parameters = { "decimals", "step" }
local build_func = function( panel, addon, varid, varc, callback, other )

	local button_wide= other["button_wide"]
	local button_tall = other["button_tall"]
	local addon_vars_copy = other["vars_copy"]
	local settab = other["bg"]
	local clr = esclib.addon:GetColors()
	local name_tr  = varc.name or addon:Translate(varc.name_tr)
	local desc = varc.desc or addon:Translate(varc.desc_tr)

	local name = esclib.util:TextCutAccurate(name_tr, esclib:AdaptiveFont("esclib", 24, 500), button_wide-5, "...")

	local button = panel:Add("DPanel")
	button:SetSize(button_wide, button_tall)
	if desc then
		button:eAddHint(desc,esclib:AdaptiveFont("esclib", 20, 500),TEXT_ALIGN_TOP,settab)
	end

	local slider = button:Add("esclib.numslider")
	slider:SetSize(button:GetWide()-20,button:GetTall()*0.3 )
	slider:CenterHorizontal()
	slider:SetY(button:GetTall()-slider:GetTall()-6)
	slider:SetBG(settab)

	slider:SetMin(varc.min or 0)
	slider:SetMax(varc.max or 1)
	slider:SetValue(varc.value)
	slider:SetDecimals(varc.decimals or 0)
	slider:SetStep(varc.step or 1)

	function button:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,clr.button.main)

		draw.SimpleText(name,esclib:AdaptiveFont("esclib", 24, 500),10,(h-slider:GetY())*0.5+5,clr.button.text,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

		--if changed
		if varc.value ~= addon_vars_copy[varid] then
			draw.RoundedBox(0,0,h-2,w,2,clr.button.discard)
		end
	end


	slider.OnValueChanged = function(self,x)
		varc.value = x
		callback(varid,varc.value)
	end
end

esclib:AddNewSettingsType(name, required_params, secondary_parameters, build_func)



------------------
--# CHOICELIST #--
------------------
local name = "choicelist"
local required_params = { "values", "value", "SelectableCount" }
local secondary_parameters = { "TranslateValues", "SearchEnabled" }
local build_func = function( panel, addon, varid, varc, callback, other )

	local button_wide= other["button_wide"]
	local button_tall = other["button_tall"]
	local addon_vars_copy = other["vars_copy"] --repr old values
	local settab = other["bg"]

	local clr = esclib.addon:GetColors()
	local name_tr  = varc.name or addon:Translate(varc.name_tr)
	local desc = varc.desc or addon:Translate(varc.desc_tr)

	local name = esclib.util:TextCutAccurate(name_tr, esclib:AdaptiveFont("esclib", 24, 500), button_wide-5, "...")

	local selected = istable(varc.value) and varc.value or {varc.value}
	varc.value = selected --convert to table or do nothing

	local button = panel:Add("DButton")
	button:SetSize(button_wide, button_tall)
	button:SetText("")
	if desc then
		button:eAddHint(desc,esclib:AdaptiveFont("esclib", 20, 500),TEXT_ALIGN_TOP,settab)
	end
	

	function button:DoClick()

		local clr = esclib.addon:GetColors()

		local value_paint = function(self,w,h,val,active)
			local hovered = self:IsHovered()
			if varc.TranslateValues then
				val = addon:Translate(val)
			end
			
			draw.RoundedBox(0,0,0,w,h,hovered and clr.button.hover or clr.button.main)
			if active then
				draw.RoundedBox(0,0,0,5,h,clr.button.apply)
			end
			
			draw.SimpleText(val,esclib:AdaptiveFont("esclib", 24, 500),15,h*0.5,hovered and clr.button.text_hover or clr.button.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
		end

		local return_result = function(result)
			local val = result and (istable(result) and result or {result}) or {}
			if not table.IsEmpty(val) then
				varc.value = val
				callback(varid,varc.value)
			end
		end

		esclib:ChoiceMenu(name, varc.values, varc.SelectableCount, value_paint, return_result, nil, varc.SearchEnabled ~= false, varc.value[1])

	end

	function button:Paint(w,h)
		local hovered = self:IsHovered()
		draw.RoundedBox(0,0,0,w,h,hovered and clr.button.hover or clr.button.main)

		local value = ""
		if istable(varc.value) then
			for _, v in pairs(varc.value) do
				if varc.TranslateValues then v = addon:Translate(v) end
				value = value .. v .. " "
			end
		else
			if varc.TranslateValues then 
				value = addon:Translate(varc.value)
			else
				value = varc.value
			end
		end
		local copied_name = ""
		if istable(addon_vars_copy[varid]) then
			for _, v in pairs(addon_vars_copy[varid]) do
				if varc.TranslateValues then v = addon:Translate(v) end
				copied_name = copied_name .. v .. " "
			end
		else
			if varc.TranslateValues then 
				copied_name = addon:Translate(addon_vars_copy[varid])
			else
				copied_name = addon_vars_copy[varid]
			end
		end

		draw.SimpleText(name,esclib:AdaptiveFont("esclib", 24, 500),10,6,clr.button.text,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText("["..value:TrimRight().."]",esclib:AdaptiveFont("esclib", 16, 500),10,h-6,clr.button.apply,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
		draw.SimpleText("p","Marlett",w-2,h-2,clr.button.text,TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)

		--if changed
		if value ~= copied_name then
			draw.RoundedBox(0,0,h-2,w,2,clr.button.discard)
		end
	end
end

esclib:AddNewSettingsType(name, required_params, secondary_parameters, build_func)


-----------
--# STR #--
-----------
local name = "str"
local required_params = { "value" }
local secondary_parameters = { "MaximumCharCount", "MinimumCharCount", "HintTranslateKey" }
local build_func = function( panel, addon, varid, varc, callback, other )

	local button_wide= other["button_wide"]
	local button_tall = other["button_tall"]
	local addon_vars_copy = other["vars_copy"]
	local settab = other["bg"]
	local clr = esclib.addon:GetColors()
	local name_tr  = varc.name or addon:Translate(varc.name_tr)
	local desc = varc.desc or addon:Translate(varc.desc_tr)

	local name = esclib.util:TextCutAccurate(name_tr, esclib:AdaptiveFont("esclib", 24, 500), button_wide-25, "...")
	local value_text = esclib.util:TextCutAccurate(varc.value, esclib:AdaptiveFont("esclib", 20, 500), button_wide-25, "...")
	
	local button = panel:Add("DButton")
	button:SetSize(button_wide, button_tall)
	button:SetText("")
	if desc then
		button:eAddHint(desc,esclib:AdaptiveFont("esclib", 20, 500),TEXT_ALIGN_TOP,settab)
	end

	function button:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,self:IsHovered() and clr.button.hover or clr.button.main)

		draw.SimpleText(name,esclib:AdaptiveFont("esclib", 24, 500),10,5,clr.button.text,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText(value_text,esclib:AdaptiveFont("esclib", 20, 500),10,h-10,clr.button.apply,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)

		--if changed
		if varc.value ~= addon_vars_copy[varid] then
			draw.RoundedBox(0,0,h-2,w,2,clr.button.discard)
		end
	end

	function button:DoClick()
		local hint = varc.HintTranslateKey and addon:Translate(varc.HintTranslateKey) or esclib.addon:Translate("window_ValueEdit", addon.info.language)
		local text_input = esclib:TextInputWindow(name, hint, false, 
			function(result)
				varc.value = result
				callback(varid,varc.value)
			end,
			function(val)
				local slen = string.len(string.Trim(val) or "")
				local maxv = varc.MaximumCharCount or math.huge
				local minv = varc.MinimumCharCount or -math.huge

				if not ((slen >= minv) and (slen <= maxv)) then
					return string.format("%s <= #str <= %s", minv, maxv)
				end
				return not ((slen >= minv) and (slen <= maxv))
			end,
			addon.info.language
		)
		text_input:SetText(varc.value)
	end

end

esclib:AddNewSettingsType(name, required_params, secondary_parameters, build_func)


