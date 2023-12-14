local holoModule = require(script.Parent.MainModule)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerStorage = game:GetService("ServerStorage")

local Players = game:GetService("Players")

local Teams = game:GetService("Teams")

local toolStorage = ServerStorage.toolStorage
local swordStorage = toolStorage.swordStorage
local gunStorage = toolStorage.gunStorage

local holoEvents = ReplicatedStorage.holoEvents

local weaponEvent = holoEvents:WaitForChild("weaponEvent")


local weaponList = toolStorage:GetChildren()
local players = Players:GetPlayers()
local gunList = holoModule.populateGuns()
local swordList = holoModule.populateSwords()




local function giveGun(player)
	for i, gun in pairs(gunList) do
		gun:Clone().Parent = player.Backpack
	end
end

local function giveSword(player)
	local player = player
	for i, sword in pairs(swordList) do
		sword:Clone().Parent = player.Backpack
	end
end

local function assignWeapon(arg1, arg2)
	if arg1 == 'sword' then
		
		--gives sword to all
		if arg2 == 'all' then
			for i, player in pairs(players) do
				giveSword(player)
			end
		--sword giving command
		else
			local isTeam = holoModule.findTeam(arg2)
			if isTeam ~= nil then
				local team =Teams[isTeam.Name]
				local teamplayers =team:GetPlayers()
				for i, player in pairs(teamplayers) do
					giveSword(player)
				end
			else
				local player = holoModule.findPlayer(arg2)
				giveSword(player)
			end
		end
			
		
		
		
	
	elseif arg1 == 'gun' then
		
		--gives gun to all
		if arg2 == 'all' then
			for i, player in pairs(players) do
				giveGun(player)
			end
			--sword giving command
		else
			local isTeam = holoModule.findTeam(arg2)
			if isTeam ~= nil then
				local team =Teams[isTeam.Name]
				local teamplayers =team:GetPlayers()
				for i, player in pairs(teamplayers) do
					giveGun(player)
				end
			else
				local player = holoModule.findPlayer(arg2)
				giveGun(player)
			end
		end
	end
end

weaponEvent.Event:Connect(assignWeapon)