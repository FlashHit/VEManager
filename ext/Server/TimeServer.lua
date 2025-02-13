---@class TimeServer
TimeServer = class "TimeServer"

---@type Logger
local m_Logger = Logger("TimeServer", false)

function TimeServer:__init()
	m_Logger:Write('Initializing Time-Server')
	self:RegisterVars()
	self:RegisterEvents()
end

function TimeServer:RegisterVars()
	-- Initialise variables
	m_Logger:Write('Registered Vars')
	self.m_ServerDayTime = 0.0
	self.m_TotalServerTime = 0.0
	self.m_EngineUpdateTimer = 0.0
	self.m_TotalDayLength = 0.0
	self.m_IsStatic = nil
	self.m_ServerTickrate = SharedUtils:GetTickrate()
	self.m_SyncTickrate = VEM_CONFIG.SERVER_SYNC_CLIENT_EVERY_TICKS / self.m_ServerTickrate --[Hz]
	self.m_SystemRunning = false
end

function TimeServer:RegisterEvents()
	m_Logger:Write('Registered Events')

	Events:Subscribe('TimeServer:AddTime', self, self.AddTime)
	NetEvents:Subscribe('TimeServer:AddTimeNet', self, self.AddTimeViaNet)

	Events:Subscribe('TimeServer:Pause', self, self.PauseContinue)

	Events:Subscribe('TimeServer:Disable', self, self.DisableDynamicCycle)
	NetEvents:Subscribe('TimeServer:DisableNet', self, self.DisableDynamicCycleViaNet)

	self.m_EngineUpdateEvent = Events:Subscribe('Engine:Update', self, self.Run)
	--self.m_LevelLoadedEvent = Events:Subscribe('Level:Loaded', self, self.OnLevelLoaded)
	self.m_LevelDestroyEvent = Events:Subscribe('Level:Destroy', self, self.OnLevelDestroy)
	self.m_PlayerRequestEvent = NetEvents:Subscribe('TimeServer:PlayerRequest', self, self.OnPlayerRequest)
end

function TimeServer:OnLevelDestroy()
	self.m_SystemRunning = false
end

function TimeServer:AddTimeViaNet(player, p_StartingTime, p_LengthOfDayInMinutes)
	self:AddTime(p_StartingTime, p_LengthOfDayInMinutes)
end

function TimeServer:AddTime(p_StartingTime, p_LengthOfDayInMinutes)
	if self.m_SystemRunning == true then
		self:RegisterVars()
	end

	if p_LengthOfDayInMinutes ~= nil then
		self.m_TotalDayLength = p_LengthOfDayInMinutes * 60
		self.m_ServerDayTime = p_StartingTime * 3600 * (self.m_TotalDayLength / 86000)
		self.m_IsStatic = false
	else
		self.m_TotalDayLength = 86000
		self.m_ServerDayTime = p_StartingTime * 3600
		self.m_IsStatic = true
	end

	m_Logger:Write('Received new time (Starting Time, Length of Day): ' .. p_StartingTime .. 'h, '.. self.m_TotalDayLength .. 'sec')

	NetEvents:Broadcast('VEManager:AddTimeToClient', self.m_ServerDayTime, self.m_IsStatic, self.m_TotalDayLength)
	self.m_SystemRunning = true
end

function TimeServer:Run(p_DeltaTime, p_SimulationDeltaTime)
	if self.m_SystemRunning == true and self.m_IsStatic == false then
		self.m_ServerDayTime = self.m_ServerDayTime + p_DeltaTime
		self.m_EngineUpdateTimer = self.m_EngineUpdateTimer + p_DeltaTime

		if self.m_TotalServerTime == 0.0 then
			self.m_TotalServerTime = self.m_TotalServerTime + self.m_ServerDayTime
		end
		self.m_TotalServerTime = self.m_TotalServerTime + p_DeltaTime

		if self.m_EngineUpdateTimer <= self.m_SyncTickrate then
			return
		end

		self.m_EngineUpdateTimer = 0
		self:Broadcast(self.m_ServerDayTime, self.m_TotalServerTime)

		if self.m_ServerDayTime >= self.m_TotalDayLength then
			m_Logger:Write('New day cycle')
			self.m_ServerDayTime = 0
		end
	end
end

function TimeServer:OnPlayerRequest(player)
	if self.m_SystemRunning == true or self.m_IsStatic == true then
		m_Logger:Write('Received Request by Player')
		m_Logger:Write('Calling Sync Broadcast')
		NetEvents:SendTo('VEManager:AddTimeToClient', player, self.m_ServerDayTime, self.m_IsStatic, self.m_TotalDayLength)
	end
end

function TimeServer:Broadcast(p_ServerDayTime, p_TotalServerTime)
	--m_Logger:Write('Syncing Players')
	NetEvents:BroadcastUnreliableOrdered('TimeServer:Sync', p_ServerDayTime, p_TotalServerTime)
end

function TimeServer:PauseContinue()
	-- Pause or Continue time
	self.m_SystemRunning = not self.m_SystemRunning
	m_Logger:Write('Time system running: ' .. tostring(self.m_SystemRunning))
	NetEvents:Broadcast('ClientTime:Pause', self.m_SystemRunning)
end

function TimeServer:DisableDynamicCycle()
	self.m_SystemRunning = false
	NetEvents:Broadcast('ClientTime:Disable')
end

function TimeServer:DisableDynamicCycleViaNet()
	self.m_Systemrunning = false
	NetEvents:Broadcast('ClientTime:Disable')
end

-- Chat Commands
---@param p_PlayerName string
---@param p_RecipientMask integer
---@param p_Message string
function TimeServer:ChatCommands(p_PlayerName, p_RecipientMask, p_Message)
	if p_Message:match('^!settime') then
		local hour, duration = p_Message:match('^!settime (%d+%.*%d*) (%d+%.*%d*)')

		if hour == nil then
			hour = 9
		end

		if duration == nil then
			duration = 0.5
		end

		m_Logger:Write('Time Event called by ' .. p_PlayerName)
		self:AddTime(hour, duration)

	elseif p_Message == '!setnight' then
		m_Logger:Write('Time Event called by ' .. p_PlayerName)
		self:AddTime(0, nil)

	elseif p_Message == '!setmorning' then
		m_Logger:Write('Time Event called by ' .. p_PlayerName)
		self:AddTime(9, nil)

	elseif p_Message == '!setnoon' then
		m_Logger:Write('Time Event called by ' .. p_PlayerName)
		self:AddTime(12, nil)

	elseif p_Message == '!setafternoon' then
		m_Logger:Write('Time Event called by ' .. p_PlayerName)
		self:AddTime(15, nil)

	elseif p_Message == '!pausetime' then
		m_Logger:Write('Time Pause called by ' .. p_PlayerName)
		self:PauseContinue()

	elseif p_Message == '!disabletime' then
		m_Logger:Write('Time Disable called by ' .. p_PlayerName)
		self:DisableDynamicCycle()
	end
end

return TimeServer()
