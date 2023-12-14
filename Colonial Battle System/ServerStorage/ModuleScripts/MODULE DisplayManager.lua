local DisplayManager = {}

DisplayManager.__index = DisplayManager

-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- display values
local displayValues = ReplicatedStorage:WaitForChild("DisplayValues")
local status = displayValues:WaitForChild("Status")
local timeLeft = displayValues:WaitForChild("TimeLeft")
local playersLeft = displayValues:WaitForChild("PlayersLeft")

-- local functions
local function updateRoundStatus()
	status.Value = "Players left: " .. playersLeft.Value .. " / Time Left: " .. timeLeft.Value
end

-- module functions

function DisplayManager.updateStatus(newStatus)
	status.Value = newStatus
end

--events
playersLeft.Changed:Connect(updateRoundStatus)
timeLeft.Changed:Connect(updateRoundStatus)


return DisplayManager
