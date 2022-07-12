-- Config

local config = {
	-- Bird Values
	spiribird_Health = 15,
	spiribird_Stamina = 15,
	spiribird_Attack = 5,
	spiribird_Defense = 5,
	-- Enable Birds
	enable_Health = false,
	enable_Stamina = false,
	enable_Attack = false,
	enable_Defense = false
}

-- Config path
local config_path = "CustomSpiribirds/config.json"

-- Initialize config
local config_file = json.load_file(config_path)

if config_file ~= nil then
	config = config_file
else
	json.dump_file(config_path, config)
end

-- Mod
local reapplyValues = false
local modded_ids = {}
local original_Values = {}
local original_ids = {}
sdk.hook(sdk.find_type_definition("snow.data.EquipmentInventoryData"):get_method("getLvBuffCageData"),
    function(args) end,
    function(retval)
        local params = sdk.to_managed_object(retval):get_field("_Param")
        local id = params:get_field("_Id")
		
		if reapplyValues ~= true then 
			if modded_ids[id] then
				return retval
			end
		end 
		
		if reapplyValues then
			modded_ids = {}
		end
		

        local arr = params:get_field("_StatusBuffAddValue")

		if original_ids[id] ~= true then
			original_ids[id] = true
			
			local origArray = {}
			
			for i, obj in ipairs(arr:get_elements()) do
				local origValue = obj:get_field("mValue")
				
				origArray[i] = origValue
			end
			
			original_Values[id] = origArray
		end
		
		local origArr = original_Values[id]
		
        for i, obj in ipairs(arr:get_elements()) do
			local value = obj:get_field("mValue")
			
			-- Set original values
			local origHealth = 0
			local origStamina = 0
			local origAttack = 0
			local origDefense = 0
			
			-- Get original values
			for i, obj in ipairs(origArr) do
				if i == 1 then
					origHealth = origArr[i]
				end
				if i == 2 then
					origStamina = origArr[i]
				end
				if i == 3 then
					origAttack = origArr[i]
				end
				if i == 4 then
					origDefense = origArr[i]
				end
			end

			if i == 1 then
				if config.enable_Health then
					--Set custom health
					arr[i - 1] = sdk.create_uint32(config.spiribird_Health)
				else
					--Set original health
					arr[i - 1] = sdk.create_uint32(origHealth)
				end
			end
			if i == 2 then
				if config.enable_Stamina then
					--Set custom health
					arr[i - 1] = sdk.create_uint32(config.spiribird_Stamina)
				else
					--Set original health
					arr[i - 1] = sdk.create_uint32(origStamina)
				end
			end
			if i == 3 then 
				if config.enable_Attack then
					--Set custom health
					arr[i - 1] = sdk.create_uint32(config.spiribird_Attack)
				else
					--Set original health
					arr[i - 1] = sdk.create_uint32(origAttack)
				end
			end
			if i == 4 then
				if config.enable_Defense then
					--Set custom health
					arr[i - 1] = sdk.create_uint32(config.spiribird_Defense)
				else
					--Set original health
					arr[i - 1] = sdk.create_uint32(origDefense)
				end
			end
        end
        
        modded_ids[id] = true
		reapplyValues = false
        return retval
    end
)



-- Menu

re.on_draw_ui(function()
	local changed = false
	local saveSettings = false
	
	if imgui.tree_node("CustomSpiribirds") then
		-- Enable health checkbox
		local preEnable = config.enable_Health
		changed, config.enable_Health = imgui.checkbox("Enable Spiribird - Health", config.enable_Health)
		
		-- Need each of these, as it will change on the next section
		if config.enable_Health ~= preEnable then 
			saveSettings = true
		end
		
		-- Health value setting
		if config.enable_Health then
			changed, config.spiribird_Health = imgui.slider_int("Spiribird - Health Gain (Per a single green spiribird)", config.spiribird_Health, 1, 50)	
		end
		
		-- Need each of these, as it will change on the next section
		if changed then 
			saveSettings = true
		end
		
		-- Enable stamina checkbox
		preEnable = config.enable_Stamina
		changed, config.enable_Stamina = imgui.checkbox("Enable Spiribird - Stamina", config.enable_Stamina)
		
		-- Need each of these, as it will change on the next section
		if config.enable_Stamina ~= preEnable then 
			saveSettings = true
		end
		
		-- Stamina value setting
		if config.enable_Stamina then
			changed, config.spiribird_Stamina = imgui.slider_int("Spiribird - Stamina Gain (Per a single yellow spiribird)", config.spiribird_Stamina, 1, 50)	
		end
		
		-- Need each of these, as it will change on the next section
		if changed then 
			saveSettings = true
		end
		
		-- Enable attack checkbox
		preEnable = config.enable_Attack
		changed, config.enable_Attack = imgui.checkbox("Enable Spiribird - Attack", config.enable_Attack)
		
		-- Need each of these, as it will change on the next section
		if config.enable_Attack ~= preEnable then 
			saveSettings = true
		end
		
		-- Attack value setting
		if config.enable_Attack then
			changed, config.spiribird_Attack = imgui.slider_int("Spiribird - Attack Gain (Per a single red spiribird)", config.spiribird_Attack, 1, 15)	
		end
		
		-- Need each of these, as it will change on the next section
		if changed then 
			saveSettings = true
		end
		
		-- Enable defense checkbox
		preEnable = config.enable_Defense
		changed, config.enable_Defense = imgui.checkbox("Enable Spiribird - Defense", config.enable_Defense)
		
		-- Need each of these, as it will change on the next section
		if config.enable_Defense ~= preEnable then 
			saveSettings = true
		end
		
		-- Defense value setting
		if config.enable_Defense then
			changed, config.spiribird_Defense = imgui.slider_int("Spiribird - Defense Gain (Per a single orange spiribird)", config.spiribird_Defense, 1, 25)	
		end
		
		-- Need each of these, as it will change on the next section
		if changed then 
			saveSettings = true
		end
		
		-- Save settings 
		if saveSettings then
			if json.load_file(config_path) ~= config then
				json.dump_file(config_path, config)
				reapplyValues = true
			end
		end
		
		imgui.tree_pop()
	end
end)







