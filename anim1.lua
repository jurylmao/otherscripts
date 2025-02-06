-- original script made by some roblox dev, turned into funny by @jurytunic47825

local Heil = Instance.new("Tool")
Heil.Name = "Heil"
Heil.WorldPivot = CFrame.new(0, 7, 0, 0.9999998807907104, 0, 0, 0, 0.9999998807907104, 0, 0, 0, 1)
Heil.GripPos = Vector3.new(0.09999991953372955, -0.5, 0.1999998390674591)
Heil.Grip = CFrame.new(0.09999991953372955, -0.5, 0.1999998390674591, 0.9999998807907104, -8.881784197001252e-16, 0, 0, 1, 4.371138828673793e-08, 0, -4.371138473402425e-08, 0.9999998807907104)
Heil.GripForward = Vector3.new(-0, -4.371138828673793e-08, -0.9999998807907104)
Heil.ToolTip = "nazi salute thing"
Heil.GripUp = Vector3.new(-8.881784197001252e-16, 1, -4.371138473402425e-08)
Heil.GripRight = Vector3.new(0.9999998807907104, 0, 0)

local Animations = Instance.new("Folder")
Animations.Name = "Animations"
Animations.Parent = Heil

local R6 = Instance.new("Folder")
R6.Name = "R6"
R6.Parent = Animations

local Slam = Instance.new("Animation")
Slam.Name = "Slam"
Slam.AnimationId = "http://www.roblox.com/Asset?ID=65067813"
Slam.Parent = R6

local R15 = Instance.new("Folder")
R15.Name = "R15"
R15.Parent = Animations

local Slam1 = Instance.new("Animation")
Slam1.Name = "Slam"
Slam1.AnimationId = "rbxassetid://2695892384"
Slam1.Parent = R15

local Drink = Instance.new("Animation")
Drink.Name = "Drink"
Drink.AnimationId = "http://www.roblox.com/Asset?ID=94700140"
Drink.Parent = Heil

local Handle = Instance.new("Part")
Handle.Name = "Handle"
Handle.CFrame = CFrame.new(0, 6, 0, 0.9999998807907104, 0, 0, 0, 0.9999998807907104, 0, 0, 0, 1)
Handle.Transparency = 1
Handle.Locked = true
Handle.Size = Vector3.new(0.6000000238418579, 1.2599999904632568, 0.6000000238418579)
Handle.formFactor = Enum.FormFactor.Custom
Handle.Parent = Heil

Heil.Parent = game:GetService("Players").LocalPlayer.Backpack

function Create(ty)
	return function(data)
		local obj = Instance.new(ty)
		for k, v in pairs(data) do
			if type(k) == 'number' then
				v.Parent = obj
			else
				obj[k] = v
			end
		end
		return obj
	end
end

local Tool = game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Heil")
Tool.Enabled = true


local Animations = {}

local Character,Humanoid,Torso,BodyColors

local RunService = (game:FindService("RunService") or game:GetService("RunService"))

function Equipped()
	Character = Tool.Parent
	Humanoid = Character:FindFirstChildOfClass("Humanoid")
	BodyColors = Character:FindFirstChildOfClass("BodyColors")
	Torso = (Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso"))
	Animations = Tool:WaitForChild("Animations")
	Animations = {
		Slam = Humanoid:LoadAnimation(Animations:WaitForChild(Humanoid.RigType.Name):WaitForChild("Slam"))
	}
end

local Sequenced = false
function Activated()
	if not Tool.Enabled or not Humanoid or Humanoid.Health <= 0 or not Torso or Sequenced or not Character then return end
	Tool.Enabled = false
	Sequenced = true
	local start = tick()
	
	Animations.Slam:Play()
	task.wait(0.2)
	Animations.Slam:AdjustSpeed(0)
	start = tick()
	repeat
		local current = tick()
		RunService.Heartbeat:Wait()
	until (current - start) >= .5 or not Sequenced
end

function Unequipped()
	if Sequenced then 
		Sequenced = false
		delay(1,function()
			Tool.Enabled = true
		end)
	end
	for _,anim in pairs(Animations) do
		if anim then anim:Stop() end
	end
end

Tool.Equipped:Connect(Equipped)
Tool.Activated:Connect(Activated)
Tool.Unequipped:Connect(Unequipped)
