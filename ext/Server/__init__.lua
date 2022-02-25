---@class VEManagerServer
VEManagerServer = class 'VEManagerServer'

---@type Logger
local m_Logger = Logger("Server", false)

---@type TimeServer
local m_TimeServer = require 'TimeServer'

function VEManagerServer:__init()
	m_Logger:Write('Initializing VEManagerServer')
	self:RegisterEvents()
	self:RegisterRCON()
end

function VEManagerServer:RegisterEvents()
	if VEM_CONFIG.DEV_ENABLE_CHAT_COMMANDS then
		Events:Subscribe('Player:Chat', self, self.ChatCommands)
	end
end

function VEManagerServer:RegisterRCON()
	RCON:RegisterCommand('VEM:RegisterViaRCON', RemoteCommandFlag.RequiresLogin, self, self.OnRCONRegister)
end

---@param p_Command string
---@param p_Args string[]
---@param p_IsLoggedIn boolean
---@return string[]
function VEManagerServer:OnRCONRegister(p_Command, p_Args, p_IsLoggedIn)
	local s_RawPreset = p_Args[1]

	if s_RawPreset == nil then
		return { "Invalid argument" }
	end

	print(s_RawPreset)
	local s_Preset = json.decode(s_RawPreset)

	if not s_Preset then
		return { "Invalid preset" }
	end

	if s_Preset.name == nil then
		return { "Preset has no name" }
	end

	m_Logger:Write('RCON Preset Call: ' .. s_Preset.name)
	NetEvents:Broadcast('VEManager:RCONRegister', s_Preset.name, s_RawPreset)

	s_Preset = nil
	return { "OK" }
end

---@param p_Player Player|nil
---@param p_RecipientMask integer
---@param p_Message string
function VEManagerServer:ChatCommands(p_Player, p_RecipientMask, p_Message)

	-- Check if admin
	local s_IsAdmin = false
	local s_PlayerName = p_Player and p_Player.name or "An RCON Admin"

	-- if Player is nil then it has to be an admin message
	if p_Player == nil then
		s_IsAdmin = true
	else
		for _, l_Admin in pairs(VEM_CONFIG.ADMINS) do
			if l_Admin == p_Player.name then
				s_IsAdmin = true
				break
			end
		end
	end

	if not s_IsAdmin then
		m_Logger:Write(s_PlayerName .. ' wants to apply a preset but he is not an Admin')
		return
	end

	-- Check for commands
	if p_Message == '!vanillapreset' then
		-- TODO: enable original preset or disable all custom presets
		m_Logger:Write(s_PlayerName .. ' wants to apply the vanilla preset')
		return
	elseif p_Message == '!custompreset' then
		m_Logger:Write(s_PlayerName .. ' wants to apply the cinematic tools preset')
		NetEvents:Broadcast('VEManager:EnablePreset', 'CinematicTools')
		return
	elseif p_Message:match('^!preset') then
		--local presetID = p_Message:match('^!preset (%d+)')
		local presetID = p_Message:gsub("!preset ", ""):gsub("^%s*(.-)%s*$", "%1") -- The last gsub is trim
		m_Logger:Write(s_PlayerName .. ' wants to apply the preset with ID: ' .. tostring(presetID))

		if presetID ~= nil then
			NetEvents:Broadcast('VEManager:EnablePreset', presetID)
		end

		return
	end

	-- Check if time server commands
	m_TimeServer:ChatCommands(s_PlayerName, p_RecipientMask, p_Message)
end

return VEManagerServer()
