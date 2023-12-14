local event = game:GetService("ReplicatedStorage").trafficEvents:WaitForChild("trafficChange")

for _,v in pairs(workspace:GetDescendants()) do
	if v.Name == 'StopLight' then
		local clone = script.stopLightScript:Clone()
		clone.Disabled = false
		clone.Parent = v
	end
end


local cycle = 5

while true do
	wait(cycle)
	event:Fire()
end