local CinematicTools = class('CinematicTools')


function CinematicTools:__init()
    print("Initializing Cinematic Tools")
    self:RegisterVars()
    self:RegisterEvents()
end


function CinematicTools:RegisterVars()
    self.m_CineState = nil
    self.m_PendingDirty = false
    self.m_CinePriority = 1
    self.m_PresetName = nil
    self.m_PresetPriority = nil
end


function CinematicTools:RegisterEvents()
    --self.m_VisualStateAddedEvent = Events:Subscribe('VE:StateAdded', self, self.OnVisualStateAdded)
    self.m_LevelLoadEvent = Events:Subscribe('Level:Loaded', self, self.OnLevelLoaded)
end


function CinematicTools:OnLevelLoaded()
    self:CreateGUI()
end


function CinematicTools:GenericSeperator(p_Str, p_Sep)
    if p_Sep == nil then
        p_Sep = "%s"
    end

    local s_Table = {}
    for l_Str in string.gmatch(p_Str, "([^" .. p_Sep .. "]+)") do
        table.insert(s_Table, l_Str)
    end

    return s_Table
end


function CinematicTools:GetVisualEnvironmentState(...)
	--Get all visual environment states
	local args = { ... }
	local states = VisualEnvironmentManager:GetStates()
	--Loop through all states
	for _, state in pairs(states) do
		--Tool:DebugPrint('Searching through states', 'VE')
        if state.entityName ~= "EffectEntity" then --todo REMOVE LATER
            state.priority = 1
        end

		for i,priority in pairs(args) do
			if state.priority == priority then
				return state
			end
		end
	end
	return nil
end


function CinematicTools:GenericCallback(p_Path, p_Value)
    if self.m_CineState == nil then
        self.m_CineState = self:GetVisualEnvironmentState(self.m_CinePriority)
    end

    local s_PathTable = self:GenericSeperator(p_Path, "\\.")
    print(s_PathTable)
    print(#s_PathTable)

    if self.m_CineState[p_Path] == p_Value then
        return
    end

    if #s_PathTable == 1 then
        self.m_CineState[s_PathTable[1]] = p_Value
    elseif #s_PathTable == 2 then
        self.m_CineState[s_PathTable[1]][s_PathTable[2]] = p_Value
    elseif #s_PathTable == 3 then
        self.m_CineState[s_PathTable[1]][s_PathTable[2]][s_PathTable[3]] = p_Value
    end

    VisualEnvironmentManager:SetDirty(true)

end

function CinematicTools:CreateGUI()
    print("*Creating GUI for Cinematic Tools")
    -- Sky
    DebugGUI:Folder("Sky", function ()

        DebugGUI:Range('Sky Brightness', {DefValue = 1, Min = 0, Max = 5, Step = 0.01}, function(p_Value)
            self:GenericCallback("sky.brightnessScale", p_Value)
        end)

        DebugGUI:Range('Sun Size', {DefValue = 0.01, Min = 0, Max = 1, Step = 0.01}, function(p_Value)
            self:GenericCallback("sky.sunSize", p_Value)
        end)

        DebugGUI:Range('Sun Scale', {DefValue = 5, Min = 0, Max = 100, Step = 0.1}, function(p_Value)
            self:GenericCallback("sky.sunScale", p_Value)
        end)

        DebugGUI:Range('Sun Rotation X', {DefValue = 90, Min = 0, Max = 359, Step = 1}, function(p_Value)
            self:GenericCallback("outdoorLight.sunRotationX", p_Value)
        end)

        DebugGUI:Range('Sun Rotation Y', {DefValue = 0, Min = 0, Max = 180, Step = 1}, function(p_Value)
            self:GenericCallback("outdoorLight.sunRotationY", p_Value)
        end)

        DebugGUI:Range('Sun Color Red', {DefValue = 1, Min = 0, Max = 1, Step = 0.01}, function(p_Value)
            self:GenericCallback("outdoorLight.sunColor.x", p_Value)
        end)

        DebugGUI:Range('Sun Color Green', {DefValue = 1, Min = 0, Max = 1, Step = 0.01}, function(p_Value)
            self:GenericCallback("outdoorLight.sunColor.y", p_Value)
        end)

        DebugGUI:Range('Sun Color Blue', {DefValue = 1, Min = 0, Max = 1, Step = 0.01}, function(p_Value)
            self:GenericCallback("outdoorLight.sunColor.z", p_Value)
        end)

    end)

    -- Environment
    DebugGUI:Folder("Environment", function ()

        DebugGUI:Range('Ground Color Red', {DefValue = 1, Min = 0, Max = 1, Step = 0.01}, function(p_Value)
            self:GenericCallback("outdoorLight.groundColor.x", p_Value)
        end)

        DebugGUI:Range('Ground Color Green', {DefValue = 1, Min = 0, Max = 1, Step = 0.01}, function(p_Value)
            self:GenericCallback("outdoorLight.groundColor.y", p_Value)
        end)

        DebugGUI:Range('Ground Color Blue', {DefValue = 1, Min = 0, Max = 1, Step = 0.01}, function(p_Value)
            self:GenericCallback("outdoorLight.groundColor.z", p_Value)
        end)

        DebugGUI:Range('Sky Color Red', {DefValue = 1, Min = 0, Max = 1, Step = 0.01}, function(p_Value)
            self:GenericCallback("outdoorLight.skyColor.x", p_Value)
        end)

        DebugGUI:Range('Sky Color Green', {DefValue = 1, Min = 0, Max = 1, Step = 0.01}, function(p_Value)
            self:GenericCallback("outdoorLight.skyColor.y", p_Value)
        end)

        DebugGUI:Range('Sky Color Blue', {DefValue = 1, Min = 0, Max = 1, Step = 0.01}, function(p_Value)
            self:GenericCallback("outdoorLight.skyColor.z", p_Value)
        end)

        DebugGUI:Range('Sky Light Angle', {DefValue = 0.85, Min = 0, Max = 1, Step = 0.001}, function(p_Value)
            self:GenericCallback("outdoorLight.skyLightAngleFactor", p_Value)
        end)

    end)

    -- Color Correction
    DebugGUI:Folder("Color Correction", function ()

        DebugGUI:Checkbox('Color Correction Enable', true, function(p_Value)
            self:GenericCallback("colorCorrection.enable", p_Value)
        end)

        DebugGUI:Range('Brightness Red', {DefValue = 1.0, Min = 0.0, Max = 1.5, Step = 0.01}, function(p_Value)
            self:GenericCallback("colorCorrection.brightness.x", p_Value)
        end)

        DebugGUI:Range('Brightness Green', {DefValue = 1.0, Min = 0.0, Max = 1.5, Step = 0.01}, function(p_Value)
            self:GenericCallback("colorCorrection.brightness.y", p_Value)
        end)

        DebugGUI:Range('Brightness Blue', {DefValue = 1, Min = 0.0, Max = 1.5, Step = 0.01}, function(p_Value)
            self:GenericCallback("colorCorrection.brightness.z", p_Value)
        end)

        DebugGUI:Range('Contrast Red', {DefValue = 1.0, Min = 0.0, Max = 1.5, Step = 0.01}, function(p_Value)
            self:GenericCallback("colorCorrection.contrast.x", p_Value)
        end)

        DebugGUI:Range('Contrast Green', {DefValue = 1.0, Min = 0.0, Max = 1.5, Step = 0.01}, function(p_Value)
            self:GenericCallback("colorCorrection.contrast.y", p_Value)
        end)

        DebugGUI:Range('Contrast Blue', {DefValue = 1.0, Min = 0.0, Max = 1.5, Step = 0.01}, function(p_Value)
            self:GenericCallback("colorCorrection.contrast.z", p_Value)
        end)

        DebugGUI:Range('Saturation Red', {DefValue = 1.0, Min = 0.0, Max = 1.5, Step = 0.01}, function(p_Value)
            self:GenericCallback("colorCorrection.saturation.x", p_Value)
        end)

        DebugGUI:Range('Saturation Green', {DefValue = 1.0, Min = 0.0, Max = 1.5, Step = 0.01}, function(p_Value)
            self:GenericCallback("colorCorrection.saturation.y", p_Value)
        end)

        DebugGUI:Range('Saturation Blue', {DefValue = 1.0, Min = 0.0, Max = 1.5, Step = 0.01}, function(p_Value)
            self:GenericCallback("colorCorrection.saturation.z", p_Value)
        end)

    end)

    -- Tonemap
    DebugGUI:Folder("Tonemap", function ()

        DebugGUI:Range('Method', {DefValue = 2.0, Min = 0.0, Max = 3.0, Step = 1.0}, function(p_Value)
            self:GenericCallback("tonemap.tonemapMethod", p_Value)
        end)

        DebugGUI:Range('Minimum Exposure', {DefValue = 0.0, Min = 0.0, Max = 10.0, Step = 0.1}, function(p_Value)
            self:GenericCallback("tonemap.minExposure", p_Value)
        end)

        DebugGUI:Range('Maximum Exposure', {DefValue = 1.0, Min = 0.0, Max = 10.0, Step = 0.1}, function(p_Value)
            self:GenericCallback("tonemap.maxExposure", p_Value)
        end)

        DebugGUI:Range('Middle Gray ', {DefValue = 1.0, Min = 0.0, Max = 1.0, Step = 0.01}, function(p_Value)
            self:GenericCallback("tonemap.middleGray", p_Value)
        end)

        DebugGUI:Range('Exposure Adjust Time', {DefValue = 1.0, Min = 0.0, Max = 50.0, Step = 0.1}, function(p_Value)
            self:GenericCallback("tonemap.exposureAdjustTime", p_Value)
        end)

        DebugGUI:Range('Bloom Scale Red', {DefValue = 0.2, Min = 0.0, Max = 5.0, Step = 0.05}, function(p_Value)
            self:GenericCallback("tonemap.bloomScale.x", p_Value)
        end)

        DebugGUI:Range('Bloom Scale Green', {DefValue = 0.2, Min = 0.0, Max = 5.0, Step = 0.05}, function(p_Value)
            self:GenericCallback("tonemap.bloomScale.y", p_Value)
        end)

        DebugGUI:Range('Bloom Scale Blue', {DefValue = 0.2, Min = 0.0, Max = 5, Step = 0.05}, function(p_Value)
            self:GenericCallback("tonemap.bloomScale.z", p_Value)
        end)

    end)

    -- Fog
    DebugGUI:Folder("Fog", function ()

        DebugGUI:Range('Fog Start', {DefValue = 0.0, Min = -100.0, Max = 10000.0, Step = 10.0}, function(p_Value)
            self:GenericCallback("fog.start", p_Value)
        end)

        DebugGUI:Range('Fog End', {DefValue = 5000.0, Min = 0.0, Max = 15000.0, Step = 10.0}, function(p_Value)
            self:GenericCallback("fog.endValue", p_Value)
        end)

        DebugGUI:Range('Fog Distance Multiplier [doesn´t work on all maps]', {DefValue = 1.0, Min = 0.0, Max = 5.0, Step = 0.2}, function(p_Value)
            self:GenericCallback("fog.fogDistanceMultiplier", p_Value)
        end)

        DebugGUI:Range('Fog Transparency Fade Start', {DefValue = 25.0, Min = 0.0, Max = 5000.0, Step = 1.0}, function(p_Value)
            self:GenericCallback("fog.transparencyFadeStart", p_Value)
        end)

        DebugGUI:Range('Transparency Fade Clamp', {DefValue = 1.0, Min = 0.0, Max = 1.0, Step = 0.1}, function(p_Value)
            self:GenericCallback("fog.transparencyFadeClamp", p_Value)
        end)

        DebugGUI:Range('Transparency Fade End', {DefValue = 100.0, Min = 0.0, Max = 5000.0, Step = 1.0}, function(p_Value)
            self:GenericCallback("fog.transparencyFadeEnd", p_Value)
        end)

        DebugGUI:Range('Fog Color Start', {DefValue = 0.0, Min = 0.0, Max = 5000.0, Step = 10.0}, function(p_Value)
            self:GenericCallback("fog.fogColorStart", p_Value)
        end)

        DebugGUI:Range('Fog Color End', {DefValue = 10000.0, Min = 0.0, Max = 20000.0, Step = 10.0}, function(p_Value)
            self:GenericCallback("fog.fogColorEnd", p_Value)
        end)

        DebugGUI:Range('Fog Color Red', {DefValue = 1.0, Min = 0.0, Max = 5.0, Step = 0.01}, function(p_Value)
            self:GenericCallback("fog.fogColor.x", p_Value)
        end)

        DebugGUI:Range('Fog Color Green', {DefValue = 1.0, Min = 0.0, Max = 5.0, Step = 0.01}, function(p_Value)
            self:GenericCallback("fog.fogColor.y", p_Value)
        end)

        DebugGUI:Range('Fog Color Blue', {DefValue = 1.0, Min = 0.0, Max = 5.0, Step = 0.01}, function(p_Value)
            self:GenericCallback("fog.fogColor.z", p_Value)
        end)

    end)

    -- Wind
    DebugGUI:Folder("Wind", function ()

        DebugGUI:Range('Wind Direction', {DefValue = 0.0, Min = 0.0, Max = 359, Step = 1.0}, function(p_Value)
            self:GenericCallback("wind.windDirection", p_Value)
        end)

        DebugGUI:Range('Wind Strength', {DefValue = 1.0, Min = 0.0, Max = 10.0, Step = 0.5}, function(p_Value)
            self:GenericCallback("wind.windStrength", p_Value)
        end)

    end)

    -- Depth of Field
    DebugGUI:Folder("Depth of Field", function ()

        DebugGUI:Checkbox('DoF Enable', false, function(p_Value)
            self:GenericCallback("dof.enable", p_Value)
            self:GenericCallback("dof.blurFilter", 6)
        end)

        DebugGUI:Range('Scale', {DefValue = 100.0, Min = 0.0, Max = 500.0, Step = 1.0}, function(p_Value)
            self:GenericCallback("dof.scale", p_Value)
        end)

        DebugGUI:Range('Near Distance Scale', {DefValue = 0.0, Min = 0.0, Max = 1.0, Step = 0.01}, function(p_Value)
            self:GenericCallback("dof.nearDistanceScale", p_Value)
        end)

        DebugGUI:Range('Far Distance Scale', {DefValue = 0.1, Min = 0.0, Max = 1.0, Step = 0.01}, function(p_Value)
            self:GenericCallback("dof.farDistanceScale", p_Value)
        end)

        DebugGUI:Range('Focus Distance', {DefValue = 50.0, Min = 0.0, Max = 1000.0, Step = 1}, function(p_Value)
            self:GenericCallback("dof.focusDistance", p_Value)
        end)

        DebugGUI:Range('Add Blur', {DefValue = 0.0, Min = 0.0, Max = 1.0, Step = 0.01}, function(p_Value)
            self:GenericCallback("dof.blurAdd", p_Value)
        end)

        DebugGUI:Checkbox('DoF Diffusion Enable', false, function(p_Value)
            self:GenericCallback("dof.diffusionDofEnable", p_Value)
        end)

        DebugGUI:Range('DoF Diffusion Aperture (broken)', {DefValue = 1.0, Min = 0.6, Max = 20.0, Step = 0.2}, function(p_Value)
            self:GenericCallback("dof.diffusionDofAperture", p_Value)
        end)

        DebugGUI:Range('DoF Diffusion Focal Length (broken)', {DefValue = 1.0, Min = 10.0, Max = 135.0, Step = 1.0}, function(p_Value)
            self:GenericCallback("dof.diffusionDofFocalLength", p_Value)
        end)

    end)

    -- Vignette
    DebugGUI:Folder("Vignette", function ()

        DebugGUI:Checkbox('Vignette Enable', false, function(p_Value)
            self:GenericCallback("vignette.enable", p_Value)
        end)

        DebugGUI:Range('Vignette Opacity', {DefValue = 1.0, Min = 0.0, Max = 1.0, Step = 0.1}, function(p_Value)
            self:GenericCallback("vignette.opacity", p_Value)
        end)

        DebugGUI:Range('Vignette Exponent', {DefValue = 1.0, Min = 0.0, Max = 1.0, Step = 0.1}, function(p_Value)
            self:GenericCallback("vignette.exponent", p_Value)
        end)

        DebugGUI:Range('Vignette Scale X', {DefValue = 1.0, Min = 0.0, Max = 5.0, Step = 0.1}, function(p_Value)
            self:GenericCallback("vignette.scale.x", p_Value)
        end)

        DebugGUI:Range('Vignette Scale Y', {DefValue = 0.75, Min = 0.0, Max = 5.0, Step = 0.1}, function(p_Value)
            self:GenericCallback("vignette.scale.y", p_Value)
        end)

    end)

    -- Character Lighting
    DebugGUI:Folder('Character Lighting (currently broken)', function ()

        DebugGUI:Checkbox('Character Lighting Enable', false, function(p_Value)
            self:GenericCallback("characterLighting.characterLightEnable", p_Value)
        end)

        DebugGUI:Checkbox('First Person Enable', true, function(p_Value)
            self:GenericCallback("characterLighting.firstPersonEnable", p_Value)
        end)

        DebugGUI:Range('Character Lighting Mode', {DefValue = 0.0, Min = 0.0, Max = 1.0, Step = 1.0}, function(p_Value)
            self:GenericCallback("characterLighting.characterLightingMode", p_Value)
        end)

        DebugGUI:Range('Blend Factor [In Mode 1]', {DefValue = 0.0, Min = 0.0, Max = 1.0, Step = 0.01}, function(p_Value)
            self:GenericCallback("characterLighting.blendFactor", p_Value)
        end)

        DebugGUI:Checkbox('Lock to Camera Direction', true, function(p_Value)
            self:GenericCallback("characterLighting.lockToCameraDirection", p_Value)
        end)

        DebugGUI:Range('Camera Up Rotation', {DefValue = 90.0, Min = 0.0, Max = 180.0, Step = 1.0}, function(p_Value)
            self:GenericCallback("characterLighting.cameraUpRotation", p_Value)
        end)

        DebugGUI:Range('Top Character Lighting Red', {DefValue = 1.0, Min = 0.0, Max = 5.0, Step = 0.1}, function(p_Value)
            self:GenericCallback("characterLighting.topLight.x", p_Value)
        end)

        DebugGUI:Range('Top Character Lighting Green', {DefValue = 1.0, Min = 0.0, Max = 5.0, Step = 0.1}, function(p_Value)
            self:GenericCallback("characterLighting.topLight.y", p_Value)
        end)

        DebugGUI:Range('Top Character Lighting Blue', {DefValue = 1.0, Min = 0.0, Max = 5.0, Step = 0.1}, function(p_Value)
            self:GenericCallback("characterLighting.topLight.z", p_Value)
        end)

        DebugGUI:Range('Top Light Direction X', {DefValue = 0.0, Min = 0.0, Max = 360.0, Step = 1}, function(p_Value)
            self:GenericCallback("characterLighting.topLightDirX", p_Value)
        end)

        DebugGUI:Range('Top Light Direction Y', {DefValue = 50.0, Min = 0.0, Max = 180.0, Step = 1}, function(p_Value)
            self:GenericCallback("characterLighting.topLightDirY", p_Value)
        end)

        DebugGUI:Range('Bottom Character Lighting Red', {DefValue = 1.0, Min = 0.0, Max = 5.0, Step = 0.1}, function(p_Value)
            self:GenericCallback("characterLighting.bottomLight.x", p_Value)
        end)

        DebugGUI:Range('Bottom Character Lighting Green', {DefValue = 1.0, Min = 0.0, Max = 5.0, Step = 0.1}, function(p_Value)
            self:GenericCallback("characterLighting.bottomLight.y", p_Value)
        end)

        DebugGUI:Range('Bottom Character Lighting Blue', {DefValue = 1.0, Min = 0.0, Max = 5.0, Step = 0.1}, function(p_Value)
            self:GenericCallback("characterLighting.bottomLight.z", p_Value)
        end)

    end)

    -- Ambient Occlusion
    DebugGUI:Folder('Ambient Occlusion', function ()

        DebugGUI:Range('HBAO Radius', {DefValue = 0, Min = 0.0, Max = 1.0, Step = 0.01}, function(p_Value)
            self:GenericCallback("dynamicAO.hbaoRadius", p_Value)
        end)

        DebugGUI:Range('HBAO Attentuation', {DefValue = 0, Min = 0.0, Max = 1.0, Step = 0.01}, function(p_Value)
            self:GenericCallback("dynamicAO.hbaoAttenuation", p_Value)
        end)

        DebugGUI:Range('HBAO Angle Bias', {DefValue = 0, Min = 0.0, Max = 1.0, Step = 0.01}, function(p_Value)
            self:GenericCallback("dynamicAO.hbaoAngleBias", p_Value)
        end)

        DebugGUI:Range('HBAO Power Exponent', {DefValue = 0, Min = 0.0, Max = 1.0, Step = 0.01}, function(p_Value)
            self:GenericCallback("dynamicAO.hbaoPowerExponent", p_Value)
        end)

        DebugGUI:Range('HBAO Contrast', {DefValue = 0, Min = 0.0, Max = 1.0, Step = 0.01}, function(p_Value)
            self:GenericCallback("dynamicAO.hbaoContrast", p_Value)
        end)

        DebugGUI:Range('HBAO Max Footprint Radius', {DefValue = 0, Min = 0.0, Max = 1.0, Step = 0.01}, function(p_Value)
            self:GenericCallback("dynamicAO.hbaoMaxFootprintRadius", p_Value)
        end)

    end)

    -- Utilities
    DebugGUI:Folder("Utilities", function ()

        DebugGUI:Text('(WIP) Presetname', 'New Preset', function(p_PresetName)
            self.m_PresetName = p_PresetName
        end)

        DebugGUI:Button('(WIP) Print Preset', function(value)
    		print(self:ParseJSON())
        end)

    end)

end

-- Print Preset as JSON
function CinematicTools:ParseJSON()

	if self.m_CineState == nil then
		return 'No changes'
	end
	
	local s_Result = {}

	--Foreach class
	local componentCount = 0
	for _, l_Class in pairs(g_VEManagerClient.m_SupportedClasses) do

		if(self.m_CineState[firstToLower(l_Class)] ~= nil) then
			-- Create class and add it to the VE entity.
			local s_Class =  _G[l_Class.."ComponentData"]()

			local s_Rows = {}

			-- Foreach field in class
			for _, l_Field in ipairs(s_Class.typeInfo.fields) do
				
				-- Fix lua types
				local s_FieldName = l_Field.name

				if(s_FieldName == "End") then
					s_FieldName = "EndValue"
				end

				-- Get type
				local s_Type = l_Field.typeInfo.name --Boolean, Int32, Vec3 etc.

				-- If the preset contains that field
				if self.m_CineState[firstToLower(l_Class)][firstToLower(s_FieldName)] ~= nil then
					local s_Value

					if IsBasicType(s_Type) then
						s_Value = self:ParseValue(s_Type, self.m_CineState[firstToLower(l_Class)][firstToLower(s_FieldName)])
					elseif l_Field.typeInfo.enum then
						s_Value = tonumber(self.m_CineState[firstToLower(l_Class)][firstToLower(s_FieldName)])
					elseif l_Field.typeInfo.array then
						s_Value = "\"Found unexpected array\""
						s_Value = nil
					else
						s_Value = "\"Found unexpected DataContainer\""
						s_Value = nil
					end

					if (s_Value ~= nil) then
						table.insert(s_Rows, string.format("\"%s\":%s", s_FieldName, s_Value))
					end

				end

			end
			
			if s_Rows ~= nil then
				table.insert(s_Result, "\"" .. l_Class .. "\" : {" .. table.concat(s_Rows, ",") .. "}")
			end
		end

	end

	-- Get simple json string
    if s_Result == nil then
        s_Result = 'Error while converting preset to JSON'
    else
		-- Add Preset Name
		if self.m_PresetName == nil then
			self.m_PresetName = "New preset"
		end
		local s_PresetNameInJSON = ", \"Name\":\"" .. self.m_PresetName .. "\""

		-- Final JSON convert
        s_Result = "{" .. table.concat(s_Result, ",") .. s_PresetNameInJSON .. "}"
    end

	return s_Result
end

function CinematicTools:ParseValue(p_Type, p_Value)
	-- This seperates Vectors. Let's just do it to everything, who cares?
	if (p_Type == "Boolean") then
		return p_Value
	elseif p_Type == "CString" then
		return tostring(p_Value)

	elseif  p_Type == "Float8" or
			p_Type == "Float16" or
			p_Type == "Float32" or
			p_Type == "Float64" or
			p_Type == "Int8" or
			p_Type == "Int16" or
			p_Type == "Int32" or
			p_Type == "Int64" or
			p_Type == "Uint8" or
			p_Type == "Uint16" or
			p_Type == "Uint32" or
			p_Type == "Uint64" then
		return p_Value

	elseif (p_Type == "Vec2") then -- Vec2
		return "\"(" .. p_Value.x .. "," .. p_Value.y .. ")\""

	elseif (p_Type == "Vec3") then -- Vec3
		return "\"(" .. p_Value.x .. "," .. p_Value.y .. "," .. p_Value.z .. ")\""

	elseif (p_Type == "Vec4") then -- Vec4
		return "\"(" .. p_Value.x .. "," .. p_Value.y .. "," .. p_Value.z .. "," .. p_Value.w .. ")\""
	else
		print("Unhandled type: " .. p_Type)
		return nil
	end
end

return CinematicTools