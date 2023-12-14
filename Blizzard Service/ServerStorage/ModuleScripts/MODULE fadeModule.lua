local fadeModule = {}

local TweenService = game:GetService("TweenService")

fadeModule.TweeningIn =
	function(gui)
		local guiChildren = gui:GetDescendants()
		for i,imageLabel in pairs(guiChildren) do
			if imageLabel.ClassName == 'ImageLabel' then
				local TweenIn = TweenService:Create(imageLabel, TweenInfo.new(1), {ImageTransparency=0})
				TweenIn:Play()
			end
		end
	end

fadeModule.TweeningOut =
	function(gui)
		local guiChildren = gui:GetDescendants()
		for i,imageLabel in pairs(guiChildren) do
			if imageLabel.ClassName == 'ImageLabel' then
				local TweenOut = TweenService:Create(imageLabel, TweenInfo.new(1), {ImageTransparency=1})
				TweenOut:Play()
			end
		end
	end


return fadeModule
