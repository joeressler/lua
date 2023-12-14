local holoModule = require(script.Parent.MainModule)

local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local holoEvents = ReplicatedStorage.holoEvents

local mapEvent = holoEvents:WaitForChild("mapEvent")

local teamEvent = holoEvents:WaitForChild("teamEvent")

local weaponEvent = holoEvents:WaitForChild("weaponEvent")

local function authorization(player)
	local authorized = false
	if player:GetRankInGroup(holoModule.groupID) >= holoModule.minRank then
		authorized = true
	end
	return authorized
end

local commands = {
	--[[command format
	
	COMMAND = function(...)
		local args = table.pack(...)
		local arg1 = args[2]
		local arg2 = args[3]
		Event:fire(arg1, arg2)
	end,
	
	]]
	authorize = function(player)
		local player = player
		holoModule.adminCheck(player)
	end,

	changemap = function(...)
		local args = table.pack(...)
		local map = args[2]
		mapEvent:fire(map)
	end,

	team = function(...)
		local args = table.pack(...)
		local arg1 = args[2]
		local arg2 = args[3]
		teamEvent:fire(arg1, arg2)
	end,

	sword = function(...)
		local args = table.pack(...)
		print(args) 
		if args[2] then
			local arg1 = args[1]
			local arg2 = args[2]
			print(arg1, arg2)
			weaponEvent:fire(arg1, arg2)
		end
	end,

	gun = function(...)
		local args = table.pack(...)
		local arg1 = args[1]
		local arg2 = args[2]
		weaponEvent:fire(arg1, arg2)
	end,
}



local function isCommand(str) --returns true if first character is prefix, false otherwise
	local prefix = holoModule.prefix
	if string.find(str, prefix, 1, 1) then
		return true
	end
	return false
end

local function findSpaceIdx(str) --returns a table where [1] is the first space's index and [2] is the second space's index and so on and so forth
	local target = string.byte(" ")
	local indices = {}
	for idx = 1, #str do
		if str:byte(idx) == target then
			indices[#indices+1] = idx
		end
	end
	return indices
end

local function isolateWord(str, startIdx, endIdx) --returns a substring of 'str'
	return string.sub(str, startIdx, endIdx)
end




local function msgFunction(player, message)
	message = string.lower(message)
	if isCommand(message) then
		if authorization(player) then
			local spaceIndices = findSpaceIdx(message)
			local arg1 --command
			local arg2
			local arg3
			if spaceIndices[1] == nil then
				warn('space 1 doesn\'t exist')
				arg1 = isolateWord(message, 2, #message)
			else
				arg1 = isolateWord(message, 2, spaceIndices[1]-1)
				
				if spaceIndices[2] then
					arg2 = isolateWord(message, spaceIndices[1]+1, spaceIndices[2]-1) --name or arg2	
					
					if spaceIndices[3] then
						arg3 = isolateWord(message, spaceIndices[2]+1, spaceIndices[3]-1)
						
					else
						warn('space 3 doesn\'t exist')
						arg3 = isolateWord(message, spaceIndices[2]+1, #message)
						
					end
					
				else
					warn('space 2 doesn\'t exist')
					arg2 = isolateWord(message, spaceIndices[1]+1, #message)
					
				end
			end
			
			if arg2 == 'me' then
				arg2 = player.Name
			end
			if commands[arg1] then
				if arg1 == 'authorize' then
					commands[arg1](player)
				else
					commands[arg1](arg1, arg2, arg3)
				end

			else
				warn('not a valid command')
			end
			
		end
	end
end






game.Players.PlayerAdded:Connect(function(player)
	holoModule.banCheck(player)
	player.Chatted:Connect(function(message)
		message = string.lower(message)
		msgFunction(player, message)
	end)
end)

