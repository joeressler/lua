local aWPmodule = {}

aWPmodule.aWP = function()
	local workSpaceDescendants = game.Workspace:GetDescendants()
	for _, v in ipairs(workSpaceDescendants) do
		if v.ClassName == 'Script' then
			if v.Name == 'WelderPart' then
				v:Destroy()
			end
		end
	end
	local ServerStorage = game:GetService("ServerStorage")
	local serverStorageDescendants = ServerStorage:GetDescendants()
	for _, v in ipairs(serverStorageDescendants) do
		if v.ClassName == 'Script' then
			if v.Name == 'WelderPart' then
				v:Destroy()
			end
		end
	end
	print('cleaned WelderParts')
end


return aWPmodule
