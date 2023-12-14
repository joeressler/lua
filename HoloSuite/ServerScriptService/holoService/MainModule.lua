local holoModule = {}
local Teams = game:GetService("Teams")
local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")
holoModule.groupID = 0 --change to your groupid
holoModule.prefix = '!' --change to your prefix of choice
holoModule.minRank = 1 --change to the minimum rank you want your members to be in order to use the commands
holoModule.Admins = { --this table is for who is allowed to be teamed to 'Trainers' via the authorize command, I wrote it in such a way that you could add playernames, but I forgot how it worked when I came back the next day
	[1] = {groupID = holoModule.groupID, Rank = holoModule.minRank}
}
holoModule.bans = { --change these to whatever you want following this format
	'playername', --change to a playername you want banned
	0, --change to a groupID you want banned
}
local mapStorage = game.ServerStorage:WaitForChild("mapStorage")
holoModule.maplist = {'gun_1s', 'sword_1s'} --add your map folders names in here

function holoModule.adminCheck(player)
	for _,v in pairs(holoModule.Admins) do
		if type(v) == 'string' then
			if v == player.Name then
				player.Team = Teams.Trainers
			end
		else
			if player:IsInGroup(v.groupID) then
				if player:GetRankInGroup(v.groupID) >= v.Rank then
					player.Team = Teams.Trainers
				end
			end
		end
	end
end

function holoModule.banCheck(player)
	for _,v in pairs(holoModule.bans) do
		if type(v) == 'string' then
			if v == player.Name then
				player:kick("You are banned.")
			end
		elseif type(v) == 'number' then
			if player:IsInGroup(v) then
				local vInfo = GroupService:GetGroupInfoAsync(v)
				local rankInt = player:GetRankInGroup(v)
				local vRole = vInfo.Roles
				local rankName
				for i,role in ipairs(vRole) do
					if role.Rank == rankInt then
						rankName = role.Name
					end
				end
				player:kick("You are a "..rankName.." in the banned group "..vInfo.Name)
			end
		end
	end
end

function holoModule.findPlayer(str) --str being the name or part of name we are looking for
	local players = Players:GetPlayers()
	local name = str
	local namelen = string.len(name)
	for _, player in pairs(players) do
		local nameshort = string.sub(player.Name, 1, namelen)
		if nameshort:lower() == name:lower() then
			print('correcting '..nameshort..' to '..player.Name)
			return player
		end
	end
	warn('no player was found')
	return nil
end

function holoModule.findTeam(str) --str being the name or part of the name we are looking for
	print(str)
	print(type(str))
	local teamList = Teams:GetTeams()
	local name = str
	local namelen = string.len(name)
	for _, team in pairs(teamList) do
		local nameshort = string.sub(team.Name, 1, namelen)
		if nameshort:lower() == name:lower() then
			print('correcting '..nameshort..' to '..team.Name)
			return team
		end
	end
	warn('no team was found')
	return nil
end

function holoModule.populateSwords()
	local swordList = {}
	for i, child in ipairs(game:GetService("ServerStorage").toolStorage.swordStorage:GetChildren()) do
		print(child)
		table.insert(swordList, child)
	end
	return swordList
end

function holoModule.populateGuns()
	local gunList = {}
	for i, child in ipairs(game:GetService("ServerStorage").toolStorage.gunStorage:GetChildren()) do
		print(child)
		table.insert(gunList, child)
	end
	return gunList
end

return holoModule
