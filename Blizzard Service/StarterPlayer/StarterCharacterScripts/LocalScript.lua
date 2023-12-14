wait()
local Humanoid = script.Parent.Humanoid
local Player = game.Players:GetPlayerFromCharacter(script.Parent)
Humanoid.BreakJointsOnDeath = false
local DA = Instance.new("Animation")
DA.AnimationId = "rbxassetid://10432638525"
local DeathAnimation = Humanoid:LoadAnimation(DA)
local ReplicatedStorage =game:GetService("ReplicatedStorage")
local remoteEvent = ReplicatedStorage:WaitForChild("loadCharacter")
local remoteFunction = ReplicatedStorage:WaitForChild("FrostbittenDeath")
local frostbite_status = remoteFunction:InvokeServer(Player)

Humanoid.HealthChanged:Connect(function(Health)
	if Health <= 0 then
		print("died")
		print(frostbite_status)
		if frostbite_status == true then
			script.Parent.HumanoidRootPart.Anchored = true
			DeathAnimation:Play()
			wait(1)
			remoteEvent:FireServer(Player)
		else
			remoteEvent:FireServer(Player)
		end
	end
end)

while true do
	frostbite_status = remoteFunction:InvokeServer(Player)
	wait(1)
end