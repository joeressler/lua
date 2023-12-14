local model = script.Parent
local tS = game:GetService("TweenService")

local tweenInfo = TweenInfo.new(
	1.25, --Time it takes to move from point A to point B	
	Enum.EasingStyle.Linear, --movement style
	Enum.EasingDirection.Out, --movement direction
	-1, --repeat count, -1 for infinite
	true, --reversing, do you want it to turn around or not
	0.0 --delay time once it finishes a tween
)

local newVector = Vector3.new(0, 0, 35) --edit this vector to determine where it goes, X is back and forth, Y is up and down, Z is side to side


for i, child in ipairs(model:GetDescendants()) do
	if child.ClassName =="Part" or child.ClassName == "UnionOperation" then
		local tween = tS:Create(child, tweenInfo, {Position = child.Position + newVector})

		tween:Play()
	end
end
