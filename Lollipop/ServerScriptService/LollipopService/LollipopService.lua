local modifier = game:GetService("ReplicatedStorage").LollipopEvents:WaitForChild("HealthModifier")
local check = game:GetService("ReplicatedStorage").LollipopEvents:WaitForChild("LolliCheck")
local addtPct = 0.50
local function findPct(health)
	return (health + (health * addtPct))
end
check.OnInvoke = function(player)
	if player.PlayerGui.Lollipop.Value > 0 then
		return true
	end
	return false
end
local function healthModify(character, modType)
	local player = game.Players:GetPlayerFromCharacter(character)
	local newHealth = findPct(character:FindFirstChild('Humanoid').Health)
	if modType == 'LolliUp' then
		character:FindFirstChild('Humanoid').MaxHealth = newHealth
		character:FindFirstChild('Humanoid').Health = newHealth
		player.PlayerGui.Lollipop.Value = player.PlayerGui.Lollipop.Value + 1
		task.delay(60, function()
			if character:FindFirstChild('Humanoid').Health > 100 then
				character:FindFirstChild('Humanoid').MaxHealth = 100
				character:FindFirstChild('Humanoid').Health = 100
				player.PlayerGui.Lollipop.Value = 0
			end
		end)
	elseif modType == 'LolliDown' then
		character:FindFirstChild('Humanoid').Health = 0
		player.PlayerGui.Lollipop.Value = 0
	end
end
modifier.Event:Connect(healthModify)