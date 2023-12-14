local MatchManager = {}

--services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--module scripts
local moduleScripts = ServerStorage:WaitForChild("ModuleScripts")
local playerManager = require(moduleScripts:WaitForChild("PlayerManager"))
local gS = require(moduleScripts:WaitForChild("GameSettings"))
local timer = require(moduleScripts:WaitForChild("Timer"))
local teamFromColor = require(ServerScriptService["Misc Scripts"]:WaitForChild("teamFromColor"))

-- events
local events = ServerStorage:WaitForChild("Events")
local matchStart = events:WaitForChild("MatchStart")
local matchEnd = events:WaitForChild("MatchEnd")

-- variables
local displayValues = ReplicatedStorage:WaitForChild("DisplayValues")
local timeLeft = displayValues:WaitForChild("TimeLeft")

-- timers
local myTimer = timer.new()

--local funtions
local function stopTimer()
	myTimer:stop()
end

local function timeUp()
	matchEnd:Fire(gS.endStates.TimerUp)
end

local function startTimer()
	print("Timer started")
	myTimer:start(gS.matchDuration)
	myTimer.finished:Connect(timeUp)
	
	while myTimer:isRunning() do
		timeLeft.Value = (math.floor(myTimer:getTimeLeft() + 1))
		wait()
	end
end




--module functions

function MatchManager.prepareGame()
	print("Game starting!")
	playerManager.sendPlayersToMatch()
	matchStart:Fire()
end

function MatchManager.getEndStatus(endState)
	local statusToReturn
	
	if endState == gS.endStates.FoundWinner then
		local winnerName = playerManager:getWinnerName()
		local winnerTeamColor = playerManager:getWinnerTeamColor()
		local winnerTeam = teamFromColor.foo(winnerTeamColor)
		statusToReturn = winnerTeam.Name .. " win! Lone winner is: " .. winnerName
	elseif endState == gS.endStates.TimerUp then
		statusToReturn = "DEF win! Time ran out!"
	elseif endState == gS.endStates.CapturedFlags then
		statusToReturn = "ATK win! ATK captured all flags!"
	else
		statusToReturn = "Error found"
	end
	
	return statusToReturn
end

function MatchManager.cleanupMatch()
	playerManager.removeAllWeapons()
end

function MatchManager.resetMatch()
	playerManager.resetPlayers()
end

-- Events
matchStart.Event:Connect(startTimer)
matchEnd.Event:Connect(stopTimer)


return MatchManager
