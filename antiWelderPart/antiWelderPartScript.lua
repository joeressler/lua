local RunService = game:GetService("RunService")
local module = require(game:GetService("ServerScriptService").antiWelderPart:WaitForChild("antiWelderPartModule"))
local counter = 0
RunService.Heartbeat:Connect(function()
	if counter == 900 then
		module.aWP()
		counter = 0
	else
		counter = counter + 1
	end
end)