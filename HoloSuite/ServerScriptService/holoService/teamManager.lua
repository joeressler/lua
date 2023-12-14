local holoModule = require(script.Parent.MainModule)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerStorage = game:GetService("ServerStorage")

local Players = game:GetService("Players")

local Teams = game:GetService("Teams")

local holoEvents = ReplicatedStorage.holoEvents

local teamEvent = holoEvents:WaitForChild("teamEvent")



local teamList = Teams:GetTeams()
local gameplayTeams = {
	'Team_1',
	'Team_2'
}

local function teamChange(playername, teamname)
	local playerList = Players:GetPlayers()
	
	
	--randomizes teams
	if playername == 'random' then
		for _, player in pairs(playerList) do
			if player.Team == Teams.Trainees or player.Team == Teams.Team_1 or player.Team == Teams.Team_2 then
				local randomTeam = Teams[gameplayTeams[math.random(1, #gameplayTeams)]]
				player.Team = randomTeam
			end
		end
		
		
	--swaps active teams
	elseif playername == 'swap' then
		for _, player in pairs(playerList) do
			if player.Team == Teams.Team_1 then
				player.Team = Teams.Team_2
			elseif player.Team == Teams.Team_2 then
				player.Team = Teams.Team_1
			end
		end
		
		
	--makes all active team members Trainees
	elseif playername == 'end' then
		for _, player in pairs(playerList) do
			if player.Team ==Teams.Team_1 or player.Team == Teams.Team_2 then
				player.Team = Teams.Trainees
			end
			holoModule.adminCheck(player)
		end
		
		
	--team change command
	else
		local player = holoModule.findPlayer(playername)
		local team = holoModule.findTeam(teamname)
		player.Team = Teams[team.Name]
	end
end

teamEvent.Event:Connect(teamChange)