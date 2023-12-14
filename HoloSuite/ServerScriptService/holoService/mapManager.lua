local holoModule = require(script.Parent.MainModule)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerStorage = game:GetService("ServerStorage")

local holoEvents = ReplicatedStorage.holoEvents

local mapEvent = holoEvents:WaitForChild("mapEvent")



local map_active = script.map_active


local function isMap(name)
	for i,v in pairs(holoModule.maplist) do
		if v == name then 
			return true
		end
	end
	return false
end


local function mapChange(map)
	print('event received for map change')
	local workspaceChildren = workspace:GetChildren()
	local mapStorage = ServerStorage:FindFirstChild("mapStorage")
	
	if map == 'clear' then
		for _,v in ipairs(workspaceChildren) do
			if isMap(v.Name) then
				print('found map')
				v.Parent = mapStorage
			end
		end
		map_active.Value = false
		
	else
		if ServerStorage.mapStorage[map] then
			if map_active.Value == true then
				print('clearing map before load')
				mapChange('clear')
			end
			local newMap = mapStorage[map]
			newMap.Parent = workspace
			map_active.Value = true
		end
	end
	
end

mapEvent.Event:Connect(mapChange)