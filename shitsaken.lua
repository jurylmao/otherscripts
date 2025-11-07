local versionId = "v1.12"

local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()
local UIElements = {}
local Buttons = {}
local TextList = {}
local TempObjects = {}
local lastupdate = 0
local stamina
local dragging
local updatesPaused = false
local eventObjects = true

local Toggles = {
	taphTripmine = true,
	taphTripwire = true,
	gameGenerator = true,
	noliGenerator = true,
	gameMedkit = true,
	gameCola = true,
	johndoeDigitalFootprint = true,
	twoTimeRespawn = true,
	buildermanSentry = true,
	buildermanDispenser = true,
	espEnabled = true,
	eventItem = true,
	staminaOnMouse = false,
	veeronicaSpray = true
}

local textLookup = {
	Tripmine = "taphTripmine",
	Tripwire = "taphTripwire",
	Generator = "gameGenerator",
	Fake = "noliGenerator",
	Med = "gameMedkit",
	Bloxy = "gameCola",
	Digital = "johndoeDigitalFootprint",
	Ritual = "twoTimeRespawn",
	Sentry = "buildermanSentry",
	Dispenser = "buildermanDispenser",
	Shadow = "johndoeDigitalFootprint",
	Candy = "eventItem",
	Graffiti = "veeronicaSpray"
}

local ESPObjects = {

	["Fake"] = { -- putting ts at top so it gets selected first
		Type = "Model",
		Root = "Main",
		Text = "Fake Generator",
		Color = Color3.fromHex("9800ff")
	},

	["SubspaceTripmine"] = {
		Type = "Model",
		Root = "SubspaceBox",
		Text = "Tripmine",
		Color = Color3.fromHex("f904f9")
	},

	["Tripwire"] = {
		Type = "Model",
		Root = "Wire",
		Text = "Tripwire",
		Color = Color3.fromHex("f97f04")
	},

	["BloxyCola"] = {
		Type = "Tool",
		Root = "ItemRoot",
		Text = "Bloxy Cola",
		Color = Color3.fromHex("aa5500")
	},

	["Medkit"] = {
		Type = "Tool",
		Root = "ItemRoot",
		Text = "Medkit",
		Color = Color3.fromHex("afafaf")
	},

	["Generator"] = {
		Type = "Model",
		Root = "Main",
		Text = "Generator",
		Color = Color3.fromHex("ff0000")
	},

	["BuildermanDispenser"] = {
		Type = "Model",
		Root = "Root",
		Text = "Dispenser",
		Color = Color3.fromHex("ff6666")
	},

	["BuildermanSentry"] = {
		Type = "Model",
		Root = "Root",
		Text = "Sentry",
		Color = Color3.fromHex("66fffc")
	},
	
	["doothsek"] = {
		Type = "Model",
		Root = "Part",
		Text = "Event Candy",
		Color = Color3.fromHex("45d16f"),
	},
	["dumsek"] = {
		Type = "Model",
		Root = "Part",
		Text = "Event Candy",
		Color = Color3.fromHex("45d16f"),
	},
	["dusek"] = {
		Type = "Model",
		Root = "Part",
		Text = "Event Candy",
		Color = Color3.fromHex("45d16f"),
	},
	["umdum"] = {
		Type = "Model",
		Root = "Part",
		Text = "Event Candy",
		Color = Color3.fromHex("45d16f"),
	},
	["toon dusek"] = {
		Type = "Model",
		Root = "Part",
		Text = "Event Candy",
		Color = Color3.fromHex("45d16f"),
	},
	["RespawnLocation"] = {
		Type = "Part",
		Root = "None",
		Text = "Ritual",
		Color = Color3.fromHex("ffffff"),
		Special = "TwoTime"
	},
	
	["Shadow"] = {
		Type = "Part",
		Root = "None",
		Text = "Digital Footprint",
		Color = Color3.fromHex("fcf805"),
		Special = "JohnDoeTrap"
	},
	
	["Spray"] = {
		Type = "Model",
		Root = "Hitbox",
		Text = "Graffiti",
		Color = Color3.fromHex("ecc3dc"),
		Special = "Veeronica"
	},
}



print("hello lace")

local function AddElement(element)
	local data = {}
	data.Element = element
	table.insert(UIElements, data)
end

local function CreateCheckbox(text:string, var:boolean, pos:Vector2, varname:string)
	local CheckboxContainerBackground = Drawing.new("Square")
	CheckboxContainerBackground.ZIndex = 4
	CheckboxContainerBackground.Size = Vector2.new(190, 21)
	CheckboxContainerBackground.Position = pos
	CheckboxContainerBackground.Color = Color3.fromRGB(0, 0, 0)
	CheckboxContainerBackground.Filled = true

	local CheckboxContainerBackgroundOutline = Drawing.new("Square")
	CheckboxContainerBackgroundOutline.ZIndex = 3
	CheckboxContainerBackgroundOutline.Size = Vector2.new(192, 23)
	CheckboxContainerBackgroundOutline.Position = pos - Vector2.new(1, 1)
	CheckboxContainerBackgroundOutline.Color = Color3.fromRGB(255, 255, 255)
	CheckboxContainerBackgroundOutline.Filled = true

	local CheckboxBackground = Drawing.new("Square")
	CheckboxBackground.ZIndex = 5
	CheckboxBackground.Size = Vector2.new(15, 15)
	CheckboxBackground.Position = pos + Vector2.new(172, 3)
	CheckboxBackground.Color = Color3.fromRGB(255, 255, 255)
	CheckboxBackground.Filled = true

	local CheckboxVisible = Drawing.new("Square")
	CheckboxVisible.ZIndex = 6
	CheckboxVisible.Size = Vector2.new(13, 13)
	CheckboxVisible.Position = pos + Vector2.new(173, 4)
	if var == true then
		CheckboxVisible.Color = Color3.fromRGB(0, 255, 0)
	else
		CheckboxVisible.Color = Color3.fromRGB(255, 0, 0)
	end
	CheckboxVisible.Filled = true

	local CheckboxText = Drawing.new("Text")
	CheckboxText.ZIndex = 6
	CheckboxText.Position = pos + Vector2.new(5, 3)
	CheckboxText.Color = Color3.fromRGB(255, 255, 255)
	CheckboxText.Text = text

	AddElement(CheckboxContainerBackground)
	AddElement(CheckboxContainerBackgroundOutline)
	AddElement(CheckboxBackground)
	AddElement(CheckboxVisible)
	AddElement(CheckboxText)

	local Button = {}
	Button.Box = CheckboxContainerBackground
	Button.Checkbox = CheckboxVisible
	Button.Variable = var
	Button.VarName = varname

	table.insert(Buttons, Button)
end

local function CreateHeader(text:string, pos:Vector2)
	local HeaderText = Drawing.new("Text")
	HeaderText.ZIndex = 6
	HeaderText.Position = pos
	HeaderText.Color = Color3.fromRGB(255, 255, 255)
	HeaderText.Text = text

	AddElement(HeaderText)
end

local function CheckEnabled(text)
	for keyword, varname in pairs(textLookup) do
		if string.find(text, keyword) and Toggles[varname] then
			return true
		end
	end
	return false
end

local function SetEnabled(name)
	if Toggles[name] ~= nil then
		Toggles[name] = true
	end
end

local function SetDisabled(name)
	if Toggles[name] ~= nil then
		Toggles[name] = false
	end
end


-- special stuff
local function twoTimeSpecial(object:Part)
	local start = object.Name:find("RespawnLocation")
	local prefix = object.Name:sub(1, start - 1)
	return prefix .. "'s Ritual" 
end

local function veeronicaSpecial(object:Model)
	local start = object.Name:find("Spray")
	local prefix = object.Name:sub(1, start - 1)
	return prefix .. "'s Graffiti" 
end

-- remake of this function
local function RemoveObject(v)
	pcall(function()
		if v and v.text then
			v.text:Remove()
		end
	end)

	local idx = table.find(TextList, v)
	if idx then
		table.remove(TextList, idx)
	end

	if v and v.Address then
		local tidx = table.find(TempObjects, v.Address)
		if tidx then
			table.remove(TempObjects, tidx)
		end
	end
end

local function updatePositions()
	for i = #TextList, 1, -1 do
		local v = TextList[i]
		if not v then
			table.remove(TextList, i)
			continue
		end

		if not v.text then
			table.remove(TextList, i)
			continue
		end

		local ok, result = pcall(function()
			if not v.object or not v.object.Parent then
				return nil, "remove"
			end

			-- SAFELY get position
			local objPos
			local gotPos, posOrErr = pcall(function()
				return v.object.Position
			end)

			if not gotPos or not posOrErr then
				return nil, "no_pos"
			end

			objPos = posOrErr

			local screenPos
			local gotScreen, screenOrErr = pcall(function()
				return WorldToScreen(objPos)
			end)

			if not gotScreen then
				return nil, "screen_fail"
			end

			screenPos = screenOrErr

			-- getfullname is a bitch and is gonna make me kill myself
			local isVisible

			local okName, fullname = pcall(function()
				return v.object:GetFullName()
			end)
			if okName and string.find(fullname, "Workspace") and not (screenPos.X == 0 and screenPos.Y == 0) and CheckEnabled(v.text.Text) then
				isVisible = true
			else
				isVisible = false
			end

			if isVisible and Toggles.espEnabled then
				-- this was fine probably but im still gonna do this
				pcall(function()
					v.text.Visible = true
					v.text.Position = screenPos
				end)
			else
				pcall(function()
					v.text.Visible = false
				end)
			end
			
			if v.model and v.object and v.object.Name == "Main" and game.Workspace.Map and game.Workspace.Map:FindFirstChild("Ingame") and game.Workspace.Map.Ingame:FindFirstChild("Map") then
				local value = 0
				local okProg, progVal = pcall(function()
					local prog = v.model:FindFirstChild("Progress")
					return prog and prog.Value or 0
				end)
				if okProg then value = progVal end

				local Progress = 0
				if value == 26 then
					Progress = 1
				elseif value == 52 then
					Progress = 2
				elseif value == 78 then
					Progress = 3
				elseif value == 100 then
					Progress = 4
					pcall(function() v.text.Color = Color3.fromHex("764a4a") end)
				end
				pcall(function()
					v.text.Text = "Generator (" .. tostring(Progress) .. "/4)"
				end)
			end

			return true, "ok"
		end)

		if not ok or result == "remove" or result == nil then
			-- cleanup and remove entry
			pcall(function()
				if v and v.text then
					v.text:Remove()
				end
			end)
			table.remove(TextList, i)
			if v and v.Address then
				for j = #TempObjects, 1, -1 do
					if TempObjects[j] == v.Address then
						table.remove(TempObjects, j)
					end
				end
			end
		end

		continue
	end
end


local function addObjects(v)
	for objName, objData in pairs(ESPObjects) do
		if string.find(v.Name, objName) and v:IsA(objData.Type) and not table.find(TempObjects, v.Address) and game.Workspace.Map.Ingame:FindFirstChild("Map") then
			local rootPart = v:FindFirstChild(objData.Root) or nil
			if objData.Root == "None" or rootPart then
				if objData.Special == "TwoTime" then
					objData.Text = twoTimeSpecial(v)
					rootPart = v
				end
				
				if objData.Special == "Veeronica" then
					objData.Text = veeronicaSpecial(v)
				end
				
				if objData.Special == "JohnDoeTrap" then
					rootPart = v
				end
				if rootPart ~= nil then
					local espText = Drawing.new("Text")
					espText.Text = objData.Text
					if rootPart ~= nil then
						espText.Position = WorldToScreen(rootPart.Position)
					else
						espText:Remove()
						return
					end
					espText.Color = objData.Color
					espText.Outline = true
					espText.Center = true
				if rootPart ~= nil then
						table.insert(TempObjects, v.Address)
						local entry = {}
						entry.object = rootPart
						entry.text = espText
						entry.model = v
						entry.temporary = true
						table.insert(TextList, entry)
				else
					espText:Remove()
				end
				else
					return
				end
			end
		end
	end
end

local function updateObjects()
	-- jd traps
	for _, obj in ipairs(game.Workspace.Map.Ingame:GetChildren()) do
		if string.find(obj.Name, "Shadows") then
			for _, v in ipairs(obj:GetChildren()) do
				addObjects(v)
			end
		end
	end

	-- everything else
	if workspace:FindFirstChild('Map') then
		if workspace.Map:FindFirstChild('Ingame') then
			for _, v in game.Workspace.Map.Ingame.Map:GetChildren() do
				addObjects(v)
			end
			for _, v in game.Workspace.Map.Ingame:GetChildren() do
				addObjects(v)
			end
			for _, v in game.Workspace:GetChildren() do
				addObjects(v)
			end
		end
	end
	-- event candy
	if game.Workspace.Map.Ingame:FindFirstChild("CurrencyLocations") then
		for _, v in game.Workspace.Map.Ingame:FindFirstChild("CurrencyLocations"):GetChildren() do
			addObjects(v)
		end
	end
	
end

local function updateQuickUI()
	local StaminaText
	local stamCap
	local success, result = pcall(function()
		return Players.LocalPlayer.PlayerGui.TemporaryUI.PlayerInfo.Bars.Stamina
	end)
	local isReal = success and result or nil

	if isReal then
		StaminaText = tostring(memory_read("string", Players.LocalPlayer.PlayerGui:FindFirstChild("TemporaryUI"):FindFirstChild("PlayerInfo"):FindFirstChild("Bars"):FindFirstChild("Stamina"):FindFirstChild("Amount").Address + 0xAE0))
	end
	if StaminaText ~= nil then
		if Toggles.staminaOnMouse == true then
			if stamina ~= nil then
				stamina.Visible = true
				stamina.Text = StaminaText
				stamina.Position = Vector2.new(Mouse.X, Mouse.Y - 15)
			else
				stamina = Drawing.new("Text")
				stamina.Text = StaminaText
				stamina.Position = Vector2.new(Mouse.X, Mouse.Y - 15)
				stamina.Color = Color3.fromHex("FFFFFF")
				stamina.Outline = true
				stamina.Center = true
				stamina.ZIndex = 7
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

local Drag = Drawing.new("Square")
Drag.Size = Vector2.new(200, 442)
Drag.Position = Vector2.new(100, 100)
Drag.Color = Color3.fromRGB(30, 30, 30)
Drag.Filled = true
Drag.ZIndex = 2

local Title = Drawing.new("Text")
Title.ZIndex = 3
Title.Position = Vector2.new(105, 102)
Title.Color = Color3.fromRGB(255, 255, 255)
Title.Text = "shitsaken // " .. versionId .. " // Ping: 67"

local Background = Drawing.new("Square")
Background.ZIndex = 1
Background.Size = Vector2.new(Drag.Size.X + 4, Drag.Size.Y + 4)
Background.Position = Vector2.new(98, 98)
Background.Color = Color3.fromRGB(255, 255, 255)
Background.Filled = true

local BorderLine1 = Drawing.new("Square")
BorderLine1.ZIndex = 3
BorderLine1.Size = Vector2.new(190, 2)
BorderLine1.Position = Vector2.new(105, 120)
BorderLine1.Color = Color3.fromRGB(255, 255, 255)
BorderLine1.Filled = true

AddElement(Title)
AddElement(Background)
AddElement(BorderLine1)
CreateHeader("ESP", Vector2.new(105, 123))
CreateCheckbox("ESP Enabled", Toggles.espEnabled, Vector2.new(105, 140), "espEnabled")
CreateCheckbox("Taph Tripmine ESP", Toggles.taphTripmine, Vector2.new(105, 168), "taphTripmine")
CreateCheckbox("Taph Tripwire ESP", Toggles.taphTripwire, Vector2.new(105, 196), "taphTripwire")
CreateCheckbox("Two Time Respawn ESP", Toggles.twoTimeRespawn, Vector2.new(105, 224), "twoTimeRespawn")
CreateCheckbox("Veeronica Graffiti ESP", Toggles.veeronicaSpray, Vector2.new(105, 252), "veeronicaSpray")
CreateCheckbox("Bloxy Cola ESP", Toggles.gameCola, Vector2.new(105, 280), "gameCola")
CreateCheckbox("Medkit ESP", Toggles.gameMedkit, Vector2.new(105, 308), "gameMedkit")
CreateCheckbox("Builderman Sentry ESP", Toggles.buildermanSentry, Vector2.new(105, 336), "buildermanSentry")
CreateCheckbox("Builderman Dispenser ESP", Toggles.buildermanDispenser, Vector2.new(105, 364), "buildermanDispenser")
CreateCheckbox("Generator ESP", Toggles.gameGenerator, Vector2.new(105, 392), "gameGenerator")
CreateCheckbox("Fake Generator ESP", Toggles.noliGenerator, Vector2.new(105, 420), "noliGenerator")
CreateCheckbox("Digital Footprint ESP", Toggles.johndoeDigitalFootprint, Vector2.new(105, 448), "johndoeDigitalFootprint")
CreateCheckbox("Event Candy ESP", Toggles.eventItem, Vector2.new(105, 476), "eventPickups")
CreateHeader("UI Stuff", Vector2.new(105, 501))
CreateCheckbox("Stamina on Mouse", Toggles.staminaOnMouse, Vector2.new(105, 518), "staminaOnMouse")
local function UIUpdate()

	-- button presses

	if iskeypressed(0x01) and Drag.Position.X < Mouse.X and Mouse.X < Drag.Position.X + Drag.Size.X and Drag.Position.Y < Mouse.Y and Mouse.Y < Drag.Position.Y + Drag.Size.Y then
		for i, v in ipairs(Buttons) do
			if v.Box.Position.X < Mouse.X and Mouse.X < v.Box.Size.X + v.Box.Position.X and v.Box.Position.Y < Mouse.Y and Mouse.Y < v.Box.Position.Y + v.Box.Size.Y then
				v.Variable = not v.Variable

				if v.Variable == true then
					v.Checkbox.Color = Color3.fromRGB(0, 255, 0)
					SetEnabled(v.VarName)
				else
					v.Checkbox.Color = Color3.fromRGB(255, 0, 0)
					SetDisabled(v.VarName)
				end
			end
		end
	end

	Title.Text = "shitsaken // " .. versionId .. " // Ping: " .. tostring(math.floor(memory_read("double", game:FindFirstChild("Stats"):FindFirstChild("PerformanceStats"):FindFirstChild("Ping").Address + 0xC8)))

	local offsets = {}
	if iskeypressed(0x01) and Drag.Position.X < Mouse.X and Mouse.X < Drag.Position.X + Drag.Size.X and Drag.Position.Y < Mouse.Y and Mouse.Y < Drag.Position.Y + Drag.Size.Y  then
		dragging = true

		for _, v in ipairs(UIElements) do
			offsets[v] = v.Element.Position - Drag.Position
		end

		local distanceX = Mouse.X - Drag.Position.X
		local distanceY = Mouse.Y - Drag.Position.Y
		while dragging == true do
			Drag.Position = Vector2.new(Mouse.X - distanceX, Mouse.Y - distanceY)
			for _, v in ipairs(UIElements) do
				v.Element.Position = Drag.Position + offsets[v]
			end
			dragging = iskeypressed(0x01)
		end
	end

end

-- ui shit
spawn(function()
	while true do
		UIUpdate()
		updateQuickUI()
		task.wait()
	end
end)

spawn(function()
	while true do
		task.wait(0.5)
		if updatesPaused == false then
			updateObjects()
		end
	end
end)

spawn(function()
	while true do
		
		
		if game.Workspace.Map.Ingame:FindFirstChild("Map") then
			updatePositions()
		else
			for _, v in TextList do
				v.text:Remove()
			end
			table.clear(TextList)
			table.clear(TempObjects)
			if stamina ~= nil then
				stamina:Remove()
				stamina = nil
			end
			updatesPaused = true
			repeat 
				task.wait()	
			until game.Workspace.Map.Ingame:FindFirstChild("Map")
			task.wait(1)
			updatesPaused = false
		end
		task.wait()
		end
end)
