local tool = script.Parent
local modifier = game:GetService("ReplicatedStorage").LollipopEvents:WaitForChild("HealthModifier")
local check = game:GetService("ReplicatedStorage").LollipopEvents:WaitForChild("LolliCheck")

local function onActivate()
	local character = tool.Parent
	local player = game.Players:GetPlayerFromCharacter(character)
	local humanoid = character:FindFirstChild("Humanoid")
	if check:Invoke(player) then
		modifier:Fire(character, 'LolliDown')
	else
		modifier:Fire(character, 'LolliUp')
	end
end

tool.Activated:Connect(onActivate)
