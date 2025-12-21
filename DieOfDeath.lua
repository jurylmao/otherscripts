--[[

hii dont skid my code please thank youuuu
hii dont skid my code please thank youuuu
hii dont skid my code please thank youuuu
hii dont skid my code please thank youuuu
hii dont skid my code please thank youuuu
hii dont skid my code please thank youuuu

]]

-- note for versionId:
-- .# - added feature
-- .## - bug fix OR minor change

local versionId = "v1.0"

local Players = game:GetService("Players")	
local Mouse = Players.LocalPlayer:GetMouse()
local UIElements = {}
local Buttons = {}
local TextList = {}
local TempObjects = {}
local Sections = {}
local lastupdate = 0
local stamina
local dragging
local updatesPaused = false
local eventObjects = true
local IsDrawing = false
local lastNotif = 0
local highestSectionZindex = 667
local guiVis = true


local Config = {
	staminaOnMouse = true,
	coloredStamina = true,
	antiZeroStamina = true,
}

print("DoD Script " .. versionId .. " loaded")

-- offset stuff?? idrk

local function get_offsets()
	local t = {}
	local ok, res = pcall(function()
		return game:HttpGet("https://offsets.ntgetwritewatch.workers.dev/offsets.json")
	end)
	if not ok or not res then return t end
	for k, v in res:gmatch('"([^"]-)"%s*:%s*"([^"]-)"') do
		t[k] = v
	end
	return t
end

local memoryOffsets = {
	Text = get_offsets()["TextLabelText"],
	Value = get_offsets()["Value"]
}


-- start of jurysNotify

local notify = {}
local activeNotifications = {}
local currID = 0

local function wrapText(text, limit)
	local result = ""
	local lineLength = 0
	local lastSpace = 0
	for i = 1, #text do
		local char = text:sub(i, i)
		result = result .. char
		lineLength = lineLength + 1
		if char == " " then
			lastSpace = #result
		end
		if lineLength >= limit then
			if lastSpace > 0 then
				result = result:sub(1, lastSpace - 1) .. "\n" .. result:sub(lastSpace + 1)
				lineLength = #result - lastSpace
				lastSpace = 0
			else
				result = result .. "\n"
				lineLength = 0
			end
		end
	end
	return result
end

local function addNotification(elements, id, duration, notificationType)
	local notifMain = elements[3]
	local offsets = {}

	for _, element in ipairs(elements) do
		offsets[element] = element.Position - notifMain.Position
	end

	local data = {
		ID = id,
		Elements = elements,
		Offsets = offsets,
		NotifMain = notifMain,
		Initialized = false,
		Duration = duration,
		Initializing = false,
		notificationType = notificationType
	}

	table.insert(activeNotifications, data)
end

local function updateRelativePosition(data, pos)
	for _, element in ipairs(data.Elements) do
		local offset = data.Offsets[element]
		element.Position = pos + offset
	end
end


function notify.CreateNotification(notificationType:string , titleContent:string, textContent:string, duration:number, zIndex:number ,titleColor:Color3, textContentColor:Color3, barColor:Color3, backgroundColor:Color3, lineColor:Color3, progressBarColor:Color3) 

	local processedText = wrapText(textContent, 35)
	if zIndex == nil then
		zIndex = 67
	end
	local xPos = -100
	local yPos = -100

	if notificationType == "default" then
		local ColorBar = Drawing.new("Square")
		ColorBar.ZIndex = zIndex
		ColorBar.Size = Vector2.new(5, 60)
		ColorBar.Position = Vector2.new(xPos - 5, yPos)
		ColorBar.Color = barColor or Color3.fromRGB(255, 255, 255)
		ColorBar.Filled = true

		local Title = Drawing.new("Text")
		Title.ZIndex = zIndex + 1
		Title.Position = Vector2.new(xPos + 5, yPos + 2)
		Title.Color = titleColor or Color3.fromRGB(255, 255, 255)
		Title.Text = titleContent or "Title"
		Title.Outline = false

		local NotifMain = Drawing.new("Square")
		NotifMain.ZIndex = zIndex
		NotifMain.Size = Vector2.new(200, 60)
		NotifMain.Position = Vector2.new(xPos, yPos)
		NotifMain.Color = backgroundColor or Color3.fromRGB(30, 30, 30)
		NotifMain.Filled = true

		local BorderLine1 = Drawing.new("Square")
		BorderLine1.ZIndex = zIndex + 1
		BorderLine1.Size = Vector2.new(190, 2)
		BorderLine1.Position = Vector2.new(xPos + 5, yPos + 20)
		BorderLine1.Color = barColor or Color3.fromRGB(255, 255, 255)
		BorderLine1.Filled = true

		local Text = Drawing.new("Text")
		Text.ZIndex = zIndex + 1
		Text.Position = Vector2.new(xPos + 5, yPos + 25)
		Text.Color = textContentColor or Color3.fromRGB(255, 255, 255)
		Text.Text = processedText or "hi"
		Text.Outline = false

		local ProgressBarTop = Drawing.new("Square")
		ProgressBarTop.ZIndex = zIndex + 2
		ProgressBarTop.Size = Vector2.new(190, 2)
		ProgressBarTop.Position = Vector2.new(xPos + 5, yPos + 55)
		ProgressBarTop.Color = progressBarColor or Color3.fromRGB(255, 255, 255)
		ProgressBarTop.Filled = true

		local ProgressBarBottom = Drawing.new("Square")
		ProgressBarBottom.ZIndex = zIndex + 1
		ProgressBarBottom.Size = Vector2.new(190, 2)
		ProgressBarBottom.Position = Vector2.new(xPos + 5, yPos + 55)
		ProgressBarBottom.Color = progressBarColor or Color3.fromRGB(255, 255, 255)
		ProgressBarBottom.Filled = true
		ProgressBarBottom.Transparency = 0.5

		addNotification({ColorBar, Title, NotifMain, BorderLine1, Text, ProgressBarTop, ProgressBarBottom}, currID, duration, notificationType)
	end

	if notificationType == "outline" then
		local ColorBar = Drawing.new("Square")
		ColorBar.Size = Vector2.new(204, 64)
		ColorBar.Position = Vector2.new(xPos - 2, yPos - 2)
		ColorBar.Color = barColor or Color3.fromRGB(255, 255, 255)
		ColorBar.Filled = true

		local Title = Drawing.new("Text")
		Title.ZIndex = zIndex + 1
		Title.Position = Vector2.new(xPos + 5, yPos + 2)
		Title.Color = titleColor or Color3.fromRGB(255, 255, 255)
		Title.Text = titleContent or "Title"
		Title.Outline = false

		local NotifMain = Drawing.new("Square")
		NotifMain.ZIndex = zIndex
		NotifMain.Size = Vector2.new(200, 60)
		NotifMain.Position = Vector2.new(xPos, yPos)
		NotifMain.Color = backgroundColor or Color3.fromRGB(30, 30, 30)
		NotifMain.Filled = true

		local BorderLine1 = Drawing.new("Square")
		BorderLine1.ZIndex = zIndex + 1
		BorderLine1.Size = Vector2.new(190, 2)
		BorderLine1.Position = Vector2.new(xPos + 5, yPos + 20)
		BorderLine1.Color = barColor or Color3.fromRGB(255, 255, 255)
		BorderLine1.Filled = true

		local Text = Drawing.new("Text")
		Text.ZIndex = zIndex + 1
		Text.Position = Vector2.new(xPos + 5, yPos + 25)
		Text.Color = textContentColor or Color3.fromRGB(255, 255, 255)
		Text.Text = processedText or "hi"
		Text.Outline = false

		local ProgressBarTop = Drawing.new("Square")
		ProgressBarTop.ZIndex = zIndex + 2
		ProgressBarTop.Size = Vector2.new(190, 2)
		ProgressBarTop.Position = Vector2.new(xPos + 5, yPos + 55)
		ProgressBarTop.Color = progressBarColor or Color3.fromRGB(255, 255, 255)
		ProgressBarTop.Filled = true

		local ProgressBarBottom = Drawing.new("Square")
		ProgressBarBottom.ZIndex = zIndex + 1
		ProgressBarBottom.Size = Vector2.new(190, 2)
		ProgressBarBottom.Position = Vector2.new(xPos + 5, yPos + 55)
		ProgressBarBottom.Color = progressBarColor or Color3.fromRGB(255, 255, 255)
		ProgressBarBottom.Filled = true
		ProgressBarBottom.Transparency = 0.5

		addNotification({ColorBar, Title, NotifMain, BorderLine1, Text, ProgressBarTop, ProgressBarBottom}, currID, duration, notificationType)
	end

	if notificationType == "roundedOutline" then

		local Outline = Drawing.new("Square")
		Outline.Size = Vector2.new(208, 64)
		Outline.Position = Vector2.new(xPos - 4, yPos - 2)
		Outline.Color = barColor or Color3.fromRGB(255, 255, 255)
		Outline.Filled = true
		Outline.ZIndex = zIndex

		local Title = Drawing.new("Text")
		Title.Position = Vector2.new(xPos + 5, yPos + 5)
		Title.Color = Color3.fromRGB(255, 255, 255)
		Title.Text = titleContent or "Title"
		Title.Outline = false
		Title.ZIndex = zIndex + 2

		local Background = Drawing.new("Square")
		Background.Size = Vector2.new(204, 60)
		Background.Position = Vector2.new(xPos - 2, yPos)
		Background.Color = backgroundColor or Color3.fromRGB(30, 30, 30)
		Background.Filled = true
		Background.ZIndex = zIndex + 1

		local BorderLine1 = Drawing.new("Square")
		BorderLine1.Size = Vector2.new(190, 2)
		BorderLine1.Position = Vector2.new(xPos + 5, yPos + 20)
		BorderLine1.Color = lineColor or Color3.fromRGB(255, 255, 255)
		BorderLine1.Filled = true
		BorderLine1.ZIndex = zIndex + 2

		local Text = Drawing.new("Text")
		Text.Position = Vector2.new(xPos + 5, yPos + 25)
		Text.Color = textContentColor or Color3.fromRGB(255, 255, 255)
		Text.Text = textContent or "Text"
		Text.Outline = false
		Text.ZIndex = zIndex + 2

		local ProgressBarTop = Drawing.new("Square")
		ProgressBarTop.Size = Vector2.new(95, 2)
		ProgressBarTop.Position = Vector2.new(xPos + 5, yPos + 55)
		ProgressBarTop.Color = progressBarColor or Color3.new(255, 255, 255)
		ProgressBarTop.Filled = true
		ProgressBarTop.ZIndex = zIndex + 3

		local ProgressBarBottom = Drawing.new("Square")
		ProgressBarBottom.Size = Vector2.new(190, 2)
		ProgressBarBottom.Transparency = 0.5
		ProgressBarBottom.Position = Vector2.new(xPos + 5, yPos + 55)
		ProgressBarBottom.Color = progressBarColor or Color3.new(255, 255, 255)
		ProgressBarBottom.Filled = true
		ProgressBarBottom.ZIndex = zIndex + 2

		local OutlineCircleTopLeft = Drawing.new("Circle")
		OutlineCircleTopLeft.Position = Vector2.new(xPos, yPos)
		OutlineCircleTopLeft.Color = barColor or Color3.fromRGB(255, 255, 255)
		OutlineCircleTopLeft.Radius = 4
		OutlineCircleTopLeft.NumSides = 24
		OutlineCircleTopLeft.Filled = true
		OutlineCircleTopLeft.ZIndex = zIndex

		local OutlineCircleTopRight = Drawing.new("Circle")
		OutlineCircleTopRight.Position = Vector2.new(xPos + 200, yPos)
		OutlineCircleTopRight.Color = barColor or Color3.fromRGB(255, 255, 255)
		OutlineCircleTopRight.Radius = 4
		OutlineCircleTopRight.NumSides = 24
		OutlineCircleTopRight.Filled = true
		OutlineCircleTopRight.ZIndex = zIndex

		local OutlineCircleBottomLeft = Drawing.new("Circle")
		OutlineCircleBottomLeft.Position = Vector2.new(xPos, yPos + 60)
		OutlineCircleBottomLeft.Color = barColor or Color3.fromRGB(255, 255, 255)
		OutlineCircleBottomLeft.Radius = 4
		OutlineCircleBottomLeft.NumSides = 24
		OutlineCircleBottomLeft.Filled = true
		OutlineCircleBottomLeft.ZIndex = zIndex

		local OutlineCircleBottomRight = Drawing.new("Circle")
		OutlineCircleBottomRight.Position = Vector2.new(xPos + 200, yPos + 60)
		OutlineCircleBottomRight.Color = barColor or Color3.fromRGB(255, 255, 255)
		OutlineCircleBottomRight.Radius = 4
		OutlineCircleBottomRight.NumSides = 24
		OutlineCircleBottomRight.Filled = true
		OutlineCircleBottomRight.ZIndex = zIndex

		local OutlineTop = Drawing.new("Square")
		OutlineTop.Size = Vector2.new(204, 68)
		OutlineTop.Position = Vector2.new(xPos - 2, yPos - 4)
		OutlineTop.Color = barColor or Color3.fromRGB(255, 255, 255)
		OutlineTop.Filled = true
		OutlineTop.ZIndex = zIndex

		local BackgroundCircleTopLeft = Drawing.new("Circle")
		BackgroundCircleTopLeft.Position = Vector2.new(xPos + 2, yPos + 2)
		BackgroundCircleTopLeft.Color = backgroundColor or Color3.fromRGB(0, 0, 0)
		BackgroundCircleTopLeft.Radius = 4
		BackgroundCircleTopLeft.NumSides = 24
		BackgroundCircleTopLeft.Filled = true
		BackgroundCircleTopLeft.ZIndex = zIndex + 1

		local BackgroundCircleTopRight = Drawing.new("Circle")
		BackgroundCircleTopRight.Position = Vector2.new(xPos + 198, yPos + 2)
		BackgroundCircleTopRight.Color = backgroundColor or Color3.fromRGB(0, 0, 0)
		BackgroundCircleTopRight.Radius = 4
		BackgroundCircleTopRight.NumSides = 24
		BackgroundCircleTopRight.Filled = true
		BackgroundCircleTopRight.ZIndex = zIndex + 1

		local BackgroundCircleBottomLeft = Drawing.new("Circle")
		BackgroundCircleBottomLeft.Position = Vector2.new(xPos + 2, yPos + 58)
		BackgroundCircleBottomLeft.Color = backgroundColor or Color3.fromRGB(0, 0, 0)
		BackgroundCircleBottomLeft.Radius = 4
		BackgroundCircleBottomLeft.NumSides = 24
		BackgroundCircleBottomLeft.Filled = true
		BackgroundCircleBottomLeft.ZIndex = zIndex + 1

		local BackgroundCircleBottomRight = Drawing.new("Circle")
		BackgroundCircleBottomRight.Position = Vector2.new(xPos + 198, yPos + 58)
		BackgroundCircleBottomRight.Color = backgroundColor or Color3.fromRGB(0, 0, 0)
		BackgroundCircleBottomRight.Radius = 4
		BackgroundCircleBottomRight.NumSides = 24
		BackgroundCircleBottomRight.Filled = true
		BackgroundCircleBottomRight.ZIndex = zIndex + 1

		local BackgroundTop = Drawing.new("Square")
		BackgroundTop.Size = Vector2.new(200, 64)
		BackgroundTop.Position = Vector2.new(xPos, yPos - 2)
		BackgroundTop.Color = backgroundColor or Color3.fromRGB(0, 0, 0)
		BackgroundTop.Filled = true
		BackgroundTop.ZIndex = zIndex + 1

		addNotification({Outline, Title, Background, BorderLine1, Text, ProgressBarTop, ProgressBarBottom, OutlineTop, OutlineCircleTopLeft, OutlineCircleTopRight, OutlineCircleBottomLeft, OutlineCircleBottomRight, BackgroundCircleTopLeft, BackgroundCircleTopRight, BackgroundCircleBottomLeft, BackgroundCircleBottomRight, BackgroundTop, OutlineTop}, currID, duration, notificationType)

	end

	currID = currID + 1

end

-- end of jurysNotify

-- ui shit
local function AddElement(element, section)
	local data = {
		Element = element,
		Section = section,
		ZIndex = element.ZIndex
	}

	data.Offset = element.Position - section.Position
	table.insert(section.Elements, data)

	table.insert(UIElements, data)
end

local function CreateSection(name, position, size, color)
	local section = {
		Name = name,
		Position = position,
		Size = size,
		Color = color or Color3.fromRGB(30, 30, 30),
		Elements = {},
		DragOffset = Vector2.new(0, 0),
		IsDragging = false,
		IsOnTop = false,
		sectionN = #Sections
	}

	section.DragArea = Drawing.new("Square")
	section.DragArea.ZIndex = 5
	section.DragArea.Size = size
	section.DragArea.Position = position
	section.DragArea.Color = section.Color
	section.DragArea.Filled = true

	section.Border = Drawing.new("Square")
	section.Border.ZIndex = 4
	section.Border.Size = size + Vector2.new(4, 4)
	section.Border.Position = position - Vector2.new(2, 2)
	section.Border.Color = Color3.fromRGB(255, 255, 255)
	section.Border.Filled = true

	section.Title = Drawing.new("Text")
	section.Title.ZIndex = 6
	section.Title.Position = position + Vector2.new(5, 4)
	section.Title.Color = Color3.fromRGB(255, 255, 255)
	section.Outline = false
	section.Title.Text = name

	section.BorderLine = Drawing.new("Square")
	section.BorderLine.ZIndex = 6
	section.BorderLine.Size = Vector2.new(size.X - 6, 2)
	section.BorderLine.Position = position + Vector2.new(3, 22)
	section.BorderLine.Color = Color3.fromRGB(255, 255, 255)
	section.BorderLine.Filled = true

	table.insert(Sections, section)

	AddElement(section.Border, section)
	AddElement(section.Title, section)
	AddElement(section.DragArea, section)
	AddElement(section.BorderLine, section)

	return section
end

local function CreateCheckbox(text:string, var:boolean, pos:Vector2, varname, section)

	local adjustedPos = section.Position + pos

	local CheckboxContainerBackground = Drawing.new("Square")
	CheckboxContainerBackground.ZIndex = 9
	CheckboxContainerBackground.Size = Vector2.new(190, 21)
	CheckboxContainerBackground.Position = adjustedPos
	CheckboxContainerBackground.Color = Color3.fromRGB(0, 0, 0)
	CheckboxContainerBackground.Filled = true

	local CheckboxContainerBackgroundOutline = Drawing.new("Square")
	CheckboxContainerBackgroundOutline.ZIndex = 8
	CheckboxContainerBackgroundOutline.Size = Vector2.new(192, 23)
	CheckboxContainerBackgroundOutline.Position = adjustedPos - Vector2.new(1, 1)
	CheckboxContainerBackgroundOutline.Color = Color3.fromRGB(255, 255, 255)
	CheckboxContainerBackgroundOutline.Filled = true

	local CheckboxBackground = Drawing.new("Square")
	CheckboxBackground.ZIndex = 10
	CheckboxBackground.Size = Vector2.new(15, 15)
	CheckboxBackground.Position = adjustedPos + Vector2.new(172, 3)
	CheckboxBackground.Color = Color3.fromRGB(255, 255, 255)
	CheckboxBackground.Filled = true

	local CheckboxVisible = Drawing.new("Square")
	CheckboxVisible.ZIndex = 11
	CheckboxVisible.Size = Vector2.new(13, 13)
	CheckboxVisible.Position = adjustedPos + Vector2.new(173, 4)
	if var == true then
		CheckboxVisible.Color = Color3.fromRGB(0, 255, 0)
	else
		CheckboxVisible.Color = Color3.fromRGB(255, 0, 0)
	end
	CheckboxVisible.Filled = true

	local CheckboxText = Drawing.new("Text")
	CheckboxText.ZIndex = 11
	CheckboxText.Position = adjustedPos + Vector2.new(5, 3)
	CheckboxText.Color = Color3.fromRGB(255, 255, 255)
	CheckboxText.Text = text
	CheckboxText.Outline = false

	AddElement(CheckboxContainerBackground, section)
	AddElement(CheckboxContainerBackgroundOutline, section)
	AddElement(CheckboxBackground, section)
	AddElement(CheckboxVisible, section)
	AddElement(CheckboxText, section)

	local Button = {}
	Button.Box = CheckboxContainerBackground
	Button.Checkbox = CheckboxVisible
	Button.Variable = var
	Button.Section = section
	Button.VarName = varname
	Button.Type = "Checkbox"

	table.insert(Buttons, Button)
end

local function CreateSlider(text:string, var:number, varname:string , steps:number, totalSteps:number, pos:Vector2, section)

	local adjustedPos = section.Position + pos -- 105, 147

	local SliderOutline = Drawing.new("Square")
	SliderOutline.ZIndex = 10
	SliderOutline.Size = Vector2.new(180,15)
	SliderOutline.Position = adjustedPos + Vector2.new(5,23)
	SliderOutline.Color = Color3.fromRGB(255,255,255)
	SliderOutline.Filled = true

	local SliderContainerBackground = Drawing.new("Square")
	SliderContainerBackground.ZIndex = 9
	SliderContainerBackground.Size = Vector2.new(190,44)
	SliderContainerBackground.Position = adjustedPos
	SliderContainerBackground.Color = Color3.fromRGB(0,0,0)
	SliderContainerBackground.Filled = true

	local SliderContainerBackgroundOutline = Drawing.new("Square")
	SliderContainerBackgroundOutline.ZIndex = 8
	SliderContainerBackgroundOutline.Size = Vector2.new(192,46)
	SliderContainerBackgroundOutline.Position = adjustedPos - Vector2.new(1,1)
	SliderContainerBackgroundOutline.Color = Color3.fromRGB(255,255,255)
	SliderContainerBackgroundOutline.Filled = true

	local SliderTitle = Drawing.new("Text")
	SliderTitle.ZIndex = 11
	SliderTitle.Size = Vector2.new(200,12)
	SliderTitle.Position = adjustedPos + Vector2.new(5,3)
	SliderTitle.Color = Color3.fromRGB(255,255,255)
	SliderTitle.Text = text
	SliderTitle.Outline = false

	local SliderBackground = Drawing.new("Square")
	SliderBackground.ZIndex = 11
	SliderBackground.Size = Vector2.new(178,13)
	SliderBackground.Position = adjustedPos + Vector2.new(6,24)
	SliderBackground.Color = Color3.fromRGB(0,0,0)
	SliderBackground.Filled = true

	local Slider = Drawing.new("Square")
	Slider.ZIndex = 12
	Slider.Size = Vector2.new(176,11)
	Slider.Position = adjustedPos + Vector2.new(7,25)
	Slider.Color = Color3.fromRGB(255,255,255)
	Slider.Filled = true

	local SliderValue = Drawing.new("Text")
	SliderValue.ZIndex = 11
	SliderValue.Center = true
	SliderValue.Size = Vector2.new(200,12)
	SliderValue.Position = adjustedPos + Vector2.new(165,11)
	SliderValue.Color = Color3.fromRGB(255,255,255)
	SliderValue.Text = var
	
	AddElement(SliderOutline, section)
	AddElement(SliderContainerBackground, section)
	AddElement(SliderContainerBackgroundOutline, section)
	AddElement(SliderTitle, section)
	AddElement(SliderBackground, section)
	AddElement(Slider, section)
	AddElement(SliderValue, section)
	
	local Button = {}
	Button.Box = SliderBackground
	Button.Slider = Slider
	Button.totalSteps = totalSteps
	Button.varname = varname
	Button.Section = section
	Button.varText = SliderValue
	Button.steps = steps or 0.05
	Button.Type = "Slider"

	table.insert(Buttons, Button)
	
	do -- make the slider match the current value
		local maxVal = tonumber(totalSteps) or 1
		if maxVal <= 0 then maxVal = 1 end
		local fraction = math.clamp((var or 0) / maxVal, 0, 1)
		local fullWidth = SliderBackground.Size.X - 2
		local initialWidth = math.max(1, math.floor(fullWidth * fraction + 0.5))
		Slider.Size = Vector2.new(initialWidth, Slider.Size.Y)
		Slider.Position = Vector2.new(SliderBackground.Position.X + 1, Slider.Position.Y)
		SliderValue.Text = tostring(var)
	end
end

local function CreateHeader(text:string, pos:Vector2, section)

	local adjustedPos = section.Position + pos

	local HeaderText = Drawing.new("Text")
	HeaderText.ZIndex = 11
	HeaderText.Position = adjustedPos
	HeaderText.Color = Color3.fromRGB(255, 255, 255)
	HeaderText.Text = text

	AddElement(HeaderText, section)
end

local function SetValue(name, value)
	if Config[name] ~= nil then
		Config[name] = value
	end
end

local function updateQuickUI()
	local StaminaText
	local color = Color3.fromRGB(255, 255, 255)
	local currentstam
	local success, result = pcall(function()
		return Players.LocalPlayer.PlayerGui.MainGui.RoundUI.PlayerUI.StaminaBar.Label
	end)
	local isReal = success and result or nil

	if isReal then
		local s, r = pcall(function()
			return tostring(memory_read("string", Players.LocalPlayer.PlayerGui:FindFirstChild("MainGui"):FindFirstChild("RoundUI"):FindFirstChild("PlayerUI"):FindFirstChild("StaminaBar"):FindFirstChild("Label").Address + memoryOffsets.Text))
		end)
		if s then
			currentstam = tonumber(string.match(r, "%d+"))
			if string.find(r, "/") and Config.coloredStamina then
				if string.find(r, "/") then -- for some reason this bullshit works so
					local totalstam = tonumber(string.match(r, "%d+", string.find(r, "/") + 1))
					color = Color3.fromRGB(255*( 1 - currentstam / totalstam),255*(currentstam / totalstam), 60)
					
				end
				
			end
			StaminaText = r
			
			if currentstam == 1 and Config.antiZeroStamina then
				keyrelease(0xA0)
			end
			
		else
			StaminaText = "Could not get stamina!"
			if Config.staminaOnMouse or Config.antiZeroStamina then
				if os.clock() >= lastNotif + 5 then
					notify.CreateNotification("roundedOutline" , "shitsaken", "An error occured while getting stamina.", 5, 10)
					lastNotif = os.clock()
				end
			end
		end
	end
	if StaminaText ~= nil then
		if Config.staminaOnMouse == true then
			if stamina ~= nil then
				stamina.Visible = true
				stamina.Text = StaminaText
				stamina.Position = Vector2.new(Mouse.X, Mouse.Y - 15)
				stamina.Color = color
			else
				stamina = Drawing.new("Text")
				stamina.Text = StaminaText
				stamina.Position = Vector2.new(Mouse.X, Mouse.Y - 15)
				stamina.Color = Color3.fromHex("FFFFFF")
				stamina.Outline = true
				stamina.Center = true
				stamina.ZIndex = 677
			end
		else
			if stamina ~= nil then
				stamina.Visible = false
			end
		end
	else
		if stamina ~= nil then
			stamina:Remove()
			stamina = nil
		end
	end
end
-- 😔😔😔
local function HandleSectionDrag() -- im gonna kill myself istg
	for _, section in ipairs(Sections) do
		if ismouse1pressed() and guiVis and isrbxactive() then
			local mousePos = Vector2.new(Mouse.X, Mouse.Y)

			if mousePos.X >= section.DragArea.Position.X and 
				mousePos.X <= section.DragArea.Position.X + section.DragArea.Size.X and
				mousePos.Y >= section.DragArea.Position.Y and 
				mousePos.Y <= section.DragArea.Position.Y + section.DragArea.Size.Y then

				if not section.IsDragging then
					section.IsDragging = true
					section.DragOffset = mousePos - section.Position
				end
			end
		else
			section.IsDragging = false
		end

		if section.IsDragging then
			local mousePos = Vector2.new(Mouse.X, Mouse.Y)
			local newPos = mousePos - section.DragOffset

			section.Position = newPos

			section.Border.Position = newPos - Vector2.new(2, 2)
			section.Title.Position = newPos + Vector2.new(5, 2)
			section.DragArea.Position = newPos
			section.BorderLine.Position = newPos + Vector2.new(3, 22)

			for _, elementData in ipairs(section.Elements) do
				elementData.Element.Position = section.Position + elementData.Offset
			end

			if section.DragArea.ZIndex ~= highestSectionZindex then -- this is the bugged thing

				for _, s2 in ipairs(Sections) do -- put non selected sections at default zindex
					if s2 ~= section then
						for _, element in ipairs(s2.Elements) do
							element.Element.ZIndex = element.ZIndex + s2.sectionN*10
						end
						s2.DragArea.ZIndex = 5 + s2.sectionN*10
						s2.BorderLine.ZIndex = 6 + s2.sectionN*10
						s2.Border.ZIndex = 4 + s2.sectionN*10
						s2.Title.ZIndex = 6 + s2.sectionN*10
					end
				end


				for _, element in ipairs(section.Elements) do
					element.Element.ZIndex = element.ZIndex + highestSectionZindex
				end
				section.DragArea.ZIndex = highestSectionZindex
				section.BorderLine.ZIndex = highestSectionZindex + 2
				section.Border.ZIndex = highestSectionZindex - 1
				section.Title.ZIndex = highestSectionZindex + 2
			end

		end

	end
end

local function HandleInteractables()
	if ismouse1pressed() and guiVis and isrbxactive() then
		for i, button in ipairs(Buttons) do
			local mousePos = Vector2.new(Mouse.X, Mouse.Y)
			
			if mousePos.X >= button.Box.Position.X and 
				mousePos.X <= button.Box.Position.X + button.Box.Size.X and
				mousePos.Y >= button.Box.Position.Y and 
				mousePos.Y <= button.Box.Position.Y + button.Box.Size.Y then
				if button.Type == "Checkbox" then
					button.Variable = not button.Variable

					if button.Variable == true then
						button.Checkbox.Color = Color3.fromRGB(0, 255, 0)
						SetValue(button.VarName, true)
					else
						button.Checkbox.Color = Color3.fromRGB(255, 0, 0)
						SetValue(button.VarName, false)
					end

					-- wait until not clicking anymore (this freezes some shit but wtv)
					while ismouse1pressed() do
						task.wait()
					end
				end
				
				if button.Type == "Slider" then
					-- slider shit
					while ismouse1pressed() do
						local sliderMin = button.Box.Position.X + 1
						local sliderMax = button.Box.Position.X + button.Box.Size.X - 1

						local x = math.clamp(Mouse.X, sliderMin, sliderMax)

						local fraction = 0
						if sliderMax > sliderMin then
							fraction = (x - sliderMin) / (sliderMax - sliderMin)
						end
						fraction = math.clamp(fraction, 0, 1)

						local fullWidth = button.Box.Size.X - 2
						local newWidth = math.max(1, math.floor(fullWidth * fraction + 0.5))
						button.Slider.Size = Vector2.new(newWidth, button.Slider.Size.Y)

						local maxVal = tonumber(button.totalSteps) or 1
						local step = tonumber(button.steps) or 0.05
						if maxVal <= 0 then maxVal = 1 end
						if step <= 0 then step = 0.05 end

						local rawVal = fraction * maxVal
						local stepsCount = math.floor(rawVal / step + 0.5)
						local value = math.clamp(stepsCount * step, 0, maxVal)

						SetValue(button.varname, value)

						if button.varText then
							button.varText.Text = tostring(string.format("%.2f", value))
						end
						
						task.wait()
					end
				end

				
			end
		end
	end
end



local utilitiesSection = CreateSection("Die of Death " .. versionId .. " // Utilities", Vector2.new(250, 100), Vector2.new(200, 125), Color3.fromRGB(35, 35, 35))

--[[
+17 (header -> checkbox)
+25 (checkbox -> header)
+28 (checkbox -> checkbox)
+50 (slider -> slider)
]]

-- visual section
CreateHeader("Stamina", Vector2.new(5, 25), utilitiesSection)
CreateCheckbox("Show Stamina on Mouse", Config.staminaOnMouse, Vector2.new(5, 42), "staminaOnMouse", utilitiesSection)
CreateCheckbox("Colored Stamina on Mouse", Config.coloredStamina, Vector2.new(5, 70), "coloredStamina", utilitiesSection)
CreateCheckbox("Anti Zero Stamina", Config.antiZeroStamina, Vector2.new(5, 98), "antiZeroStamina", utilitiesSection)
-- pointless but whatever
local function UIUpdate()	
	HandleSectionDrag()
	HandleInteractables()
end

-- ui shit
spawn(function()
	while true do
		UIUpdate()
		updateQuickUI()
		task.wait()
	end
end)

-- gui visuble
spawn(function()
	while true do
		if iskeypressed(0x70) then
			guiVis = not guiVis
			for _, v in ipairs(UIElements) do
				v.Element.Visible = guiVis
			end
			while iskeypressed(0x70) do
				task.wait(0.05)
			end
		end
		task.wait(0.05)
	end
end)

--notif initializer
spawn(function()
	while true do
		task.wait()
		if #activeNotifications > 0 then
			for _, v in ipairs(activeNotifications) do
				if v.Initialized == false and v.Initializing == false then
					v.Initializing = true
					local gameWindowSize = game.Workspace.Camera.ViewportSize
					updateRelativePosition(v, Vector2.new(gameWindowSize.X - 200, gameWindowSize.Y - 120))
					v.Initialized = true
					spawn(function()
						local startTime = os.clock()
						while os.clock() - startTime < v.Duration do
							task.wait()
							local elapsed = os.clock() - startTime
							local timeLeft = v.Duration - elapsed

							local percent = math.clamp(timeLeft / v.Duration, 0, 1)
							local progressBar = v.Elements[6]
							progressBar.Size = Vector2.new(190 * percent, progressBar.Size.Y)
						end

						for _, element in ipairs(v.Elements) do
							element:Remove()
						end
						table.remove(activeNotifications, table.find(activeNotifications, v))
					end)

				end
			end
		end
	end
end)

-- notif updates
spawn(function()
	while true do
		if #activeNotifications > 0 then
			for _, v in ipairs(activeNotifications) do
				if v.Initialized == true then		
					table.sort(activeNotifications, function(a, b)
						return a.ID > b.ID
					end)
					local baseY = game.Workspace.Camera.ViewportSize.Y - 70
					for index, notif in ipairs(activeNotifications) do
						local offsetY = (index - 1) * -70
						local gameWindowSize = game.Workspace.Camera.ViewportSize
						local pos = Vector2.new(gameWindowSize.X - 212, baseY + offsetY)
						updateRelativePosition(notif, pos)
					end

				end
			end
		end
		task.wait()
	end
end)

notify.CreateNotification("roundedOutline" , "shitsaken", "shitsaken " .. versionId .. " loaded successfully!", 5, 10)
