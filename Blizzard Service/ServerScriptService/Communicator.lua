--system vars


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local StarterPlayer = game:GetService("StarterPlayer")

--modules
local fadeModule = require(ServerStorage.ModuleScripts.fadeModule)

--local vars
local happened = false
local weatherChangeEvent = game.ReplicatedStorage.weatherChangeEvent
local weather_state = ReplicatedStorage.weather_state.Value
local Frostbitten_Death = ReplicatedStorage:WaitForChild("FrostbittenDeath")
local blizzSlowFactor = 2
local defaultWalkSpeed = 16
local is_outside = {}
local last_outside = {}
local frostbite = {}
StarterPlayer.CameraMaxZoomDistance = 10


Players.PlayerAdded:Connect(function(player)
	is_outside[player.UserId] = true
	last_outside[player.UserId] = true
	frostbite[player.UserId] = 0
	update_state(player)
end)
Players.PlayerRemoving:Connect(function(player)
	is_outside[player.UserId] = nil
	last_outside[player.UserId] = nil
	frostbite[player.UserId] = nil
end)



--functions

local function checkFrostbite(player)
	local player = player
	local frostbite_num = frostbite[player.UserId]
	local frostbite_status = false
	if frostbite_num > 0 then
		frostbite_status = true
	end
	return frostbite_status
end

local function changeLighting(weather)
	local weatherFolder = ServerStorage.LightingGroups[weather]
	if game.Lighting:GetChildren() ~= weatherFolder:GetChildren() then
		game.Lighting:ClearAllChildren()
		for i, instance in pairs(weatherFolder:GetChildren()) do
			local copyInstance = instance:Clone()
			copyInstance.Parent = game.Lighting
		end
	end
end

function enableBlizz(player, character)
	
	--initializing character
	local char = character
	local hum = char.Humanoid
	
	--setting guis
	player.PlayerGui:WaitForChild("BlizzardGui") --this is here because it will throw errors if it's not
	fadeModule.TweeningIn(player.PlayerGui.BlizzardGui) --makes the gui fade in
	player.PlayerGui:WaitForChild("FrostVignette")--this is here because it will throw errors if it's not
	fadeModule.TweeningIn(player.PlayerGui.FrostVignette) --makes the gui fade in
	
	--affecting the player
	hum.WalkSpeed = defaultWalkSpeed / blizzSlowFactor --halving the walk speed because snowfall makes you slow
	if happened == false then
		for count = 10, 5, -0.5 do
			player.CameraMaxZoomDistance = count
			wait()
		end
	end
	
	player.CameraMaxZoomDistance = 5
	
	
	--affecting the Lighting
	changeLighting('blizzard')
	game.Lighting.Skybox.CelestialBodiesShown = false --hiding the moon/sun because clouds will cover them
	game.Lighting.FogEnd = 100
	game.Lighting.FogStart = 0
	game.Lighting.ExposureCompensation = -0.5
	
	--creating frostbite
	
	
	happened = true
end

function disableBlizz(player, character)

	--initializing character
	local char = character
	local hum = char.Humanoid
	
	--setting guis
	player.PlayerGui:WaitForChild("BlizzardGui") --this is here because it will throw errors if it's not
	fadeModule.TweeningOut(player.PlayerGui.BlizzardGui)  --makes the gui fade out
	player.PlayerGui:WaitForChild("FrostVignette") --this is here because it will throw errors if it's not
	fadeModule.TweeningOut(player.PlayerGui.FrostVignette)  --makes the gui fade out
	
	--affecting the player
	hum.WalkSpeed = defaultWalkSpeed --resetting the walkspeed
	player.CameraMaxZoomDistance = 10
	for count = 0.5, 10, 0.5 do
		player.CameraMinZoomDistance = count
		wait()
	end
	player.CameraMinZoomDistance = 0.5
	
	--affecting the Lighting
	changeLighting('clear')
	game.Lighting.Skybox.CelestialBodiesShown = true --showing the moon/sun because clouds will not longer be as thick
	game.Lighting.FogEnd = 500
	game.Lighting.FogStart = 5
	game.Lighting.ExposureCompensation = 0
	
	happened = true
end


function fireRay(caster) --fires ray above humanoid root part
	local rayOrigin = caster.Position
	local rayDirection = Vector3.new(0,1000,0)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {caster.Parent}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.IgnoreWater = false
	local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	return result
	
end

function update_state() --updates gui
	local weather_state = ReplicatedStorage.weather_state.Value	
	for _, player in pairs(Players:GetPlayers()) do
		local char = player.Character
		if not char or not char.Parent then
			char = player.CharacterAdded:wait()
		end
		local hRP = char.HumanoidRootPart
		local result = fireRay(hRP)
		is_outside[player.UserId] =  (result == nil) or (result.Instance.Transparency == 1) or (result.Instance.Locked and not result.Instance.ClassName == 'Terrain')  --if something opaque is ABOVE something transparent, this will read it as outside
	
		local hum = char.Humanoid
		
		if (weather_state == 'blizzard' and is_outside[player.UserId]) then
			enableBlizz(player, char)
			local frostbiteStacks = 15 --this is the amount of seconds that go by before frostbite starts stacking
			if frostbite[player.UserId] < frostbiteStacks then
				frostbite[player.UserId] = frostbite[player.UserId] + 1
			else
				local killTime = math.random(120, 300) --amount of time to kill in seconds, first variable is lower bound, second is upper
				local damageAmount = (100/killTime)+1
				hum:TakeDamage(damageAmount)
				game.Lighting.blizzBlur.Size = game.Lighting.blizzBlur.Size + 0.09333333333
				if game.Lighting.ExposureCompensation > -3 then
					game.Lighting.ExposureCompensation = game.Lighting.ExposureCompensation - 0.05
				end
			end

		else
			disableBlizz(player, char)
			frostbite[player.UserId] = 0
			game.Lighting.ExposureCompensation = 0		
		end
	end
end

--event calls
local accumulator = 0
local accumMAX = 1
RunService.Heartbeat:Connect(function(step)
	accumulator += step
	if accumulator > accumMAX then
		accumulator = 0
		update_state()
	end
end)

weatherChangeEvent.Event:Connect(function()
	update_state()
	happened = false
end)

Frostbitten_Death.OnServerInvoke = checkFrostbite




