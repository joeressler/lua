local GameSettings = {}

--Match variables
GameSettings.intermissionDuration = 60 -- duration before match starts in seconds (1min by default)
GameSettings.matchDuration = 600 -- duration of match in seconds (10mins by default)
GameSettings.minimumPlayers = 3 -- minimum players, may change this later to accomodate for teams since I'm basing this code off of roblox's battle royale gamesystem
GameSettings.transitionTime = 5 -- time in settings for loading

-- Possible ways the game can end
GameSettings.endStates ={
	TimerUp = "TimerUp",
	FoundWinner = "FoundWinner",
	CapturedFlags = "CapturedFlags"
}

return GameSettings
