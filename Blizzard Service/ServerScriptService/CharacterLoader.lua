local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage:WaitForChild("loadCharacter")

local function loadCharacter(player)
	player:LoadCharacter()
end

RemoteEvent.OnServerEvent:Connect(loadCharacter)
