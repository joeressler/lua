local timeModule = require(game.ServerStorage.ModuleScripts.timeModule)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local weather_state = ReplicatedStorage.weather_state
local weatherChangeEvent = ReplicatedStorage.weatherChangeEvent


weather_states = {'clear', 'blizzard'}
weather_state_index = 1

function change_weather()
	timeModule.rollRandomDuration(weather_states[weather_state_index])
	local randWait = timeModule.randomWaitTime
	weather_state.Value = weather_states[weather_state_index]
	weatherChangeEvent:Fire()
	print('changing weather to ', weather_state.Value)
	
	weather_state_index += 1
	if weather_state_index > #weather_states then
		weather_state_index = 1
	end
	delay(randWait, change_weather)
end

change_weather()
