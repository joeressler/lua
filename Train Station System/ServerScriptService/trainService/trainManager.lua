local stationTravel = game:GetService("ReplicatedStorage").trainEvents:WaitForChild("stationTravelEvent")
local guiOpenEvent = game:GetService("ReplicatedStorage").trainEvents:WaitForChild("guiOpenEvent")
local guiDismissEvent = game:GetService("ReplicatedStorage").trainEvents:WaitForChild("guiDismissEvent")
local Players = game:GetService("Players")
local stationTable = {
	
}


local Stations = workspace.Stations:GetChildren()
local button = script.TextButton
local stationGui = script.stationGui
for _, v in pairs(Stations) do
	table.insert(stationTable, v)
	local ScrollingFrame = stationGui.Frame.ScrollingFrame
	local clone = button:Clone()
	clone.Text = v.Name
	clone.Name = v.Name
	clone.Station.Value = v
	clone.Parent = ScrollingFrame
end



local function terminalConjure(player)
	local clone = stationGui:Clone()
	clone.Parent = player.PlayerGui
end

local function guiDismiss(player)
	player.PlayerGui:FindFirstChild("stationGui"):Destroy()
end

local function travel(player, station)
	local character = player.Character
	if character or character.Humanoid then
		for _, v in ipairs(stationTable) do
			if station == v then
				character:MoveTo(station.Position)
				guiDismiss(player)
			end
		end
	end
end




stationTravel.OnServerEvent:Connect(travel)

guiDismissEvent.OnServerEvent:Connect(guiDismiss)

guiOpenEvent.Event:Connect(terminalConjure)