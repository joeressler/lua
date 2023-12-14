local timeModule = {}
timeModule.state_to_times = {}

timeModule.state_to_times['blizzard'] =
	function()
		return 180 +math.random(0, 18) * 10 --3 to 6 mins
	end

timeModule.state_to_times['clear'] =
	function()
		return 300 + math.random(0, 30) * 10 --5 to 10 mins
	end


timeModule.rollRandomDuration = 
	function(wstate)
		timeModule.randomWaitTime = timeModule.state_to_times[wstate]()
	end


return timeModule
