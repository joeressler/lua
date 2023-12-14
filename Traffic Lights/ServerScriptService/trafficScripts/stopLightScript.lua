local isGreen = script.Parent.isGreen
local GreenLight = script.Parent.GreenLight
local YellowLight = script.Parent.YellowLight
local RedLight = script.Parent.RedLight
local event = game:GetService("ReplicatedStorage").trafficEvents:WaitForChild("trafficChange")


local delayTime = 0.1
local yellowTime = 2 + delayTime


local function lightOff(light)
	light.Transparency = light.Off.Transparency.Value
	light.Material = Enum.Material.DiamondPlate
	light.TrafficLIGHT.Enabled = false
end

local function lightOn(light)
	light.Transparency = light.On.Transparency.Value
	light.Material = Enum.Material.Neon
	light.TrafficLIGHT.Enabled = true
end

local function toRed()
	lightOff(GreenLight)
	
	wait(delayTime)
	lightOn(YellowLight)
	
	wait(yellowTime)
	lightOff(YellowLight)
	lightOn(RedLight)
	isGreen.Value = false
end

local function toGreen()
	wait(yellowTime)
	lightOff(RedLight)
	
	wait(delayTime)
	lightOn(GreenLight)
	isGreen.Value = true
end

local function lightChange()
	if isGreen.Value == true then
		toRed()
	else
		toGreen()
	end
end

event.Event:Connect(lightChange)