local teamFromColor = {}

function teamFromColor.foo(color)
	for _, t in pairs(game:GetService("Teams"):GetChildren()) do
		if t.TeamColor == color then return t end
	end
	return nil
end

return teamFromColor
