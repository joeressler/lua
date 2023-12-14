local PlayerManager = {}
--services
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local moduleScripts = ServerStorage:WaitForChild("ModuleScripts")
local gS = require(moduleScripts:WaitForChild("GameSettings"))

-- events? (according to education?)
local events = ServerStorage:WaitForChild("Events")
local matchEnd = events:WaitForChild("MatchEnd")


--map vars
local lobbySpawn = workspace.Lobby.StartSpawn
local arenaMap = workspace.Arena
local spawnLocations = arenaMap.SpawnLocations

-- values
local displayValues = ReplicatedStorage:WaitForChild("DisplayValues")
local playersLeft = displayValues:WaitForChild("PlayersLeft")

-- player vars
local activePlayers = {}
--local playerWeapons = ServerStorage.StarterTools


--local functions
local function onPlayerJoin(player)
	player.RespawnLocation = lobbySpawn
end

local function checkPlayerCount()
	if #activePlayers == 1 then
		matchEnd:Fire(gS.endStates.FoundWinner)
	end
end

local function removeActivePlayer(player)
	for playerKey, whichPlayer in pairs(activePlayers) do
		if whichPlayer == player then
			table.remove(activePlayers, playerKey)
			playersLeft.Value = #activePlayers
			checkPlayerCount()
		end
	end
end

local function respawnPlayerInLobby(player)
	player.TeamColor = BrickColor.new("Medium stone grey")
	player.RespawnLocation = lobbySpawn
	player:LoadCharacter()
end

local function preparePlayer(player, whichSpawn)
	player.RespawnLocation = whichSpawn
	player:LoadCharacter()
	-- extraneous code below
	local char = player.Character or player.CharacterAdded:Wait() 
	--for wkey, wep in ipairs(playerWeapons:GetChildren()) do
	--	local weapon = wep:Clone()
	--	weapon.Parent = char
	--end
	
	
	-- ### IMPORTANT### ### IMPORTANT### ### IMPORTANT### ### IMPORTANT### ### IMPORTANT### ### IMPORTANT###
	
	-- In the event of wanting an attrition battle (i.e.  not respawn in lobby) comment the humanoid code here (lines 75-79) and 
	-- uncomment the commented event (line 107) at the bottom
	
	-- ### IMPORTANT### ### IMPORTANT### ### IMPORTANT### ### IMPORTANT### ### IMPORTANT### ### IMPORTANT###
	local humanoid = char:WaitForChild("Humanoid")
	humanoid.Died:Connect(function()
		respawnPlayerInLobby(player)
		removeActivePlayer(player)
	end)
end

local function removePlayerWeapon(whichPlayer)
	if whichPlayer then
		local character = whichPlayer.Character
		
		if character:FindFirstChild("Tool") then
			character.Tool:Destroy()	
		end
		if whichPlayer.Backpack:FindFirstChild("Tool") then
			character.Tool:Destroy()
		end
	else
		print("No player to remove weapon")
	end
end



--module functions
function PlayerManager.sendPlayersToMatch()
	print("Sending players to match")
	local arenaSpawns = spawnLocations:GetChildren()
	local spawnLocation
	
	for playerKey, whichPlayer in pairs(Players:GetPlayers()) do
		table.insert(activePlayers, whichPlayer)
		local playerteam = whichPlayer.Team
		for spawnKey, spawn in ipairs(arenaSpawns) do
			local spawnColor = spawn.TeamColor
			if playerteam.TeamColor == spawnColor then
				 spawnLocation = spawn
			end
		end
		preparePlayer(whichPlayer, spawnLocation)

	end
	playersLeft.Value = #activePlayers
end


function PlayerManager.getWinnerName()
	if activePlayers[1] then
		local winningPlayer = activePlayers[1]
		return winningPlayer.Name
	else
		return "Error: No winning player found"
	end
end

function PlayerManager.getWinnerTeamColor()
	if activePlayers[1] then
		local winningPlayer = activePlayers[1]
		return winningPlayer.TeamColor
	end
end

function PlayerManager.removeAllWeapons()
	for playerKey, whichPlayer in pairs(activePlayers) do
		removePlayerWeapon(whichPlayer)
	end
end

function PlayerManager.resetPlayers()
	for playerKey, whichPlayer in pairs(activePlayers) do
		respawnPlayerInLobby(whichPlayer)
	end
	
	activePlayers = {}
end

--events
Players.PlayerAdded:Connect(onPlayerJoin)
--matchEnd.Event:Connect(gameEnder.onEnd)



return PlayerManager
