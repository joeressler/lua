--services
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")

--module scripts
local moduleScripts = ServerStorage.ModuleScripts
local matchManager = require(moduleScripts.MatchManager)
local gS = require(moduleScripts.GameSettings)
local displayManager = require(moduleScripts.DisplayManager)

--event variables
local events = ServerStorage:WaitForChild("Events")
local matchEnd = events:WaitForChild("MatchEnd")

--variables
local team1 = Teams["DEF"]
local team2 = Teams["ATK"]
team1Players = nil -- making table
team2Players = nil
size1 = 0
size2 = 0

RunService.Heartbeat:Connect(function(step) -- this is never updating?
	team1Players = team1:GetPlayers()
	team2Players = team2:GetPlayers()
	size1 = #team1Players
	size2 = #team2Players
end)


local intermission = gS.intermissionDuration
print('Intermission length is: ', intermission)



--main game loop
while true do
	displayManager.updateStatus("Waiting for Players")
	repeat
		print("Starting intermission. . .")
		wait(intermission)
	until size1 >= gS.minimumPlayers and size2 >= gS.minimumPlayers
	
	--play game here
	print("Intermission over")
	displayManager.updateStatus("Get ready!")
	wait(gS.transitionTime)
	
	matchManager.prepareGame()
	
	
	local endState = matchEnd.event:Wait()
	local endStatus = matchManager.getEndStatus(endState)
	displayManager.updateStatus(endStatus)
	
	matchManager.cleanupMatch()
	wait(gS.transitionTime)
	
	matchManager.resetMatch()
end

--events

