-- note for versionId:
-- .# - added feature
-- .## - bug fix

local versionId = "v1.2"

-- acidzs stuff
_G.IsDrawing = false
local Grid

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
local IsDrawing = false

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
	veeronicaSpray = true,
	autoGen = false
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

print("shitsaken " .. versionId .. " loaded")

-- acidzs autogen

local function parse_grid()
	local cells = {}
	local circles = {}
	local gridSize = 6

	for row = 1, gridSize do
		cells[row] = {}
		for col = 1, gridSize do
			local cellName = row .. "-" .. col
			local cell = Grid:FindFirstChild(cellName)
			if cell then
				cells[row][col] = {
					frame = cell,
					position = cell.AbsolutePosition,
					value = 0
				}

				local circle = cell:FindFirstChild("Circle")
				if circle then
					local numberLabel = circle:FindFirstChild("Number")
					if numberLabel then
						local pairNum = tonumber(numberLabel.Text)
						cells[row][col].value = pairNum

						if not circles[pairNum] then
							circles[pairNum] = {}
						end
						table.insert(circles[pairNum], {row = row, col = col})
					end
				end
			end
		end
	end

	return cells, circles, gridSize
end


local function get_neighbors(r, c, rows, cols)
	local neighbors = {}
	local dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
	for _, dir in ipairs(dirs) do
		local nr, nc = r + dir[1], c + dir[2]
		if nr >= 1 and nr <= rows and nc >= 1 and nc <= cols then
			table.insert(neighbors, {nr, nc})
		end
	end
	return neighbors
end


local function is_walkable(r, c, targetColor, grid, rows, cols)
	if r < 1 or r > rows or c < 1 or c > cols then
		return false
	end
	local cellValue = grid[r][c].value
	return cellValue == 0 or cellValue == targetColor
end


local function manhattan_distance(a, b)

	local ar, ac, br, bc
	if type(a) == "table" then
		ar = a.row or a[1]
		ac = a.col or a[2]
	end
	if type(b) == "table" then
		br = b.row or b[1]
		bc = b.col or b[2]
	end
	return math.abs(ar - br) + math.abs(ac - bc)
end


local function pqs(path, startPos, goalPos)
	if #path == 0 then
		return math.huge
	end

	local sr = startPos.row or startPos[1]
	local sc = startPos.col or startPos[2]

	if path[1][1] ~= sr or path[1][2] ~= sc then
		return math.huge
	end

	local score = #path
	local straightDist = manhattan_distance(startPos, goalPos)
	local deviationPenalty = math.max(0, #path - straightDist - 1) * 2
	score = score + deviationPenalty

	local directionChanges = 0
	for i = 3, #path do
		local prevDir = {path[i-1][1] - path[i-2][1], path[i-1][2] - path[i-2][2]}
		local currDir = {path[i][1] - path[i-1][1], path[i][2] - path[i-1][2]}
		if prevDir[1] ~= currDir[1] or prevDir[2] ~= currDir[2] then
			directionChanges = directionChanges + 1
		end
	end
	score = score + directionChanges * 0.5

	return score
end


local function fbp(startPos, goalPos, color, grid, rows, cols, maxPaths)
	maxPaths = maxPaths or 20

	local function heuristic(pos)
		return manhattan_distance(pos, goalPos)
	end

	local paths = {}
	local frontier = {}
	local visitedCosts = {}

	local startKey = startPos.row .. "," .. startPos.col
	table.insert(frontier, {
		priority = heuristic({startPos.row, startPos.col}),
		cost = 0,
		path = {{startPos.row, startPos.col}},
		visited = {[startKey] = true}
	})

	while #frontier > 0 and #paths < maxPaths do
		table.sort(frontier, function(a, b) return a.priority < b.priority end)
		local current = table.remove(frontier, 1)

		local currentPos = current.path[#current.path]
		local posKey = currentPos[1] .. "," .. currentPos[2]

		if visitedCosts[posKey] and visitedCosts[posKey] < current.cost then
			continue
		end
		visitedCosts[posKey] = current.cost

		if currentPos[1] == goalPos.row and currentPos[2] == goalPos.col then
			table.insert(paths, current.path)
			continue
		end

		if current.cost > manhattan_distance({startPos.row, startPos.col}, {goalPos.row, goalPos.col}) + 15 then
			continue
		end

		for _, neighbor in ipairs(get_neighbors(currentPos[1], currentPos[2], rows, cols)) do
			local nr, nc = neighbor[1], neighbor[2]
			local nKey = nr .. "," .. nc

			if not current.visited[nKey] and is_walkable(nr, nc, color, grid, rows, cols) then
				local newVisited = {}
				for k, v in pairs(current.visited) do
					newVisited[k] = v
				end
				newVisited[nKey] = true

				local newPath = {}
				for _, p in ipairs(current.path) do
					table.insert(newPath, p)
				end
				table.insert(newPath, {nr, nc})

				local newCost = current.cost + 1
				local priority = newCost + heuristic({nr, nc})

				table.insert(frontier, {
					priority = priority,
					cost = newCost,
					path = newPath,
					visited = newVisited
				})
			end
		end
	end

	table.sort(paths, function(a, b)
		return pqs(a, {startPos.row, startPos.col}, {goalPos.row, goalPos.col}) < pqs(b, {startPos.row, startPos.col}, {goalPos.row, goalPos.col})
	end)

	return paths
end


local function qcc(grid, remainingPairs, rows, cols)
	for color, endpoints in pairs(remainingPairs) do
		local startPos, goalPos = endpoints[1], endpoints[2]
		local queue = {{startPos.row, startPos.col}}
		local visited = {[startPos.row .. "," .. startPos.col] = true}
		local found = false

		while #queue > 0 and not found do
			local pos = table.remove(queue, 1)
			local r, c = pos[1], pos[2]

			if r == goalPos.row and c == goalPos.col then
				found = true
				break
			end

			for _, neighbor in ipairs(get_neighbors(r, c, rows, cols)) do
				local nr, nc = neighbor[1], neighbor[2]
				local nKey = nr .. "," .. nc

				if not visited[nKey] then
					local cell = grid[nr][nc].value
					if cell == 0 or cell == color or (nr == goalPos.row and nc == goalPos.col) then
						visited[nKey] = true
						table.insert(queue, {nr, nc})
					end
				end
			end
		end

		if not found then
			return false
		end
	end
	return true
end


local function cfc(pos, grid, rows, cols)
	local count = 0
	local r = pos.row or pos[1]
	local c = pos.col or pos[2]
	for _, neighbor in ipairs(get_neighbors(r, c, rows, cols)) do
		if grid[neighbor[1]][neighbor[2]].value == 0 then
			count = count + 1
		end
	end
	return count
end


local function e_mrv_hr(remainingPairs, grid, rows, cols)
	local colorScores = {}

	for color, endpoints in pairs(remainingPairs) do
		local startPos, goalPos = endpoints[1], endpoints[2]
		local paths = fbp(startPos, goalPos, color, grid, rows, cols, 5)

		if #paths == 0 then
			return {color}
		end

		local pathScore = 10.0 / #paths
		local startFree = cfc(startPos, grid, rows, cols)
		local goalFree = cfc(goalPos, grid, rows, cols)
		local bottleneckScore = 5.0 / (startFree + goalFree + 1)
		local distanceScore = manhattan_distance(startPos, goalPos) * 0.1

		colorScores[color] = pathScore + bottleneckScore + distanceScore
	end

	local sortedColors = {}
	for color, _ in pairs(remainingPairs) do
		table.insert(sortedColors, color)
	end
	table.sort(sortedColors, function(a, b)
		return colorScores[a] > colorScores[b]
	end)

	return sortedColors
end


local function backtrack_solve(colorsToSolve, endpointsMap, grid, solution, rows, cols, depth, maxDepth)
	if #colorsToSolve == 0 then
		return solution
	end

	if depth > maxDepth then
		return nil
	end

	local remainingPairs = {}
	for _, color in ipairs(colorsToSolve) do
		remainingPairs[color] = endpointsMap[color]
	end

	local colorsSorted = e_mrv_hr(remainingPairs, grid, rows, cols)

	for _, color in ipairs(colorsSorted) do
		local endpoints = endpointsMap[color]
		local startPos, goalPos = endpoints[1], endpoints[2]

		local remaining = {}
		for _, c in ipairs(colorsToSolve) do
			if c ~= color then
				table.insert(remaining, c)
			end
		end



		local paths = fbp(startPos, goalPos, color, grid, rows, cols, 15)

		if #paths == 0 then
			continue
		end

		for i, path in ipairs(paths) do
			local originalStates = {}
			for _, pos in ipairs(path) do
				local r, c = pos[1], pos[2]
				originalStates[r .. "," .. c] = grid[r][c].value
				grid[r][c].value = color
			end

			solution[color] = path

			local remainingMap = {}
			for _, col in ipairs(remaining) do
				remainingMap[col] = endpointsMap[col]
			end

			if qcc(grid, remainingMap, rows, cols) then
				local result = backtrack_solve(remaining, endpointsMap, grid, solution, rows, cols, depth + 1, maxDepth)
				if result then
					return result
				end
			end

			solution[color] = nil
			for key, val in pairs(originalStates) do
				local r, c = key:match("(%d+),(%d+)")
				grid[tonumber(r)][tonumber(c)].value = val
			end
		end
	end

	return nil
end


local function solve(endpointsMap, rows, cols)
	local grid = {}
	for r = 1, rows do
		grid[r] = {}
		for c = 1, cols do
			grid[r][c] = {value = 0}
		end
	end

	for color, endpoints in pairs(endpointsMap) do
		local r1, c1 = endpoints[1].row, endpoints[1].col
		local r2, c2 = endpoints[2].row, endpoints[2].col
		grid[r1][c1].value = color
		grid[r2][c2].value = color
	end

	local colorsToSolve = {}
	for color, _ in pairs(endpointsMap) do
		table.insert(colorsToSolve, color)
	end

	local maxDepths = {15, 20, 25}
	for _, maxDepth in ipairs(maxDepths) do

		for r = 1, rows do
			for c = 1, cols do
				grid[r][c].value = 0
			end
		end

		for color, endpoints in pairs(endpointsMap) do
			local r1, c1 = endpoints[1].row, endpoints[1].col
			local r2, c2 = endpoints[2].row, endpoints[2].col
			grid[r1][c1].value = color
			grid[r2][c2].value = color
		end

		local solution = {}
		local result = backtrack_solve(colorsToSolve, endpointsMap, grid, solution, rows, cols, 0, maxDepth)

		if result then
			return result
		end
	end


	return nil
end


local function lerp(a, b, t)
	return a + (b - a) * t
end

local function smooth_move(x1, y1, x2, y2, steps, delay)
	for i = 1, steps do
		local t = i / steps
		local x = lerp(x1, x2, t)
		local y = lerp(y1, y2, t)
		mousemoveabs(x, y)
		task.wait(delay)
	end
end

local function pixel_bump(x, y)
	-- Moves the mouse by 1 pixel and back to trigger UI hover detection
	mousemoveabs(x + 1, y)
	task.wait(0.001)
	mousemoveabs(x, y)
end

local function draw(cells, solutions)
	for color, path in pairs(solutions) do
		local firstPos = cells[path[1][1]][path[1][2]].position
		local x = firstPos.X + 25
		local y = firstPos.Y + 25

		-- Move to the first position
		mousemoveabs(x, y)
		task.wait(0.003)
		pixel_bump(x, y) -- tiny movement to make UI register hover
		mouse1press()
		task.wait(0.003)

		for i = 2, #path do
			local s, r = pcall(function()
				local pos = cells[path[i][1]][path[i][2]].position
				local targetX = pos.X + 45
				local targetY = pos.Y + 45

				-- Smoothly move between cells (10 small lerp steps)
				smooth_move(x, y, targetX, targetY, 3, 0.001)

				x, y = targetX, targetY
			end)
		end

		mouse1release()
		task.wait(0.001)
	end
end

local function main()
	if _G.IsDrawing then
		return
	end

	_G.IsDrawing = true
	local cells, circles, gridSize = parse_grid()

	local endpointsMap = {}
	for pairNum, endpoints in pairs(circles) do
		if #endpoints == 2 then
			endpointsMap[pairNum] = endpoints
		end
	end


	local solution = solve(endpointsMap, gridSize, gridSize)

	if solution then
		draw(cells, solution)
	end

	task.wait(.25)
	_G.IsDrawing = false
end

-- end of acidzs autogen

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
			if workspace.Map.Ingame:FindFirstChild('Map') then
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
Drag.Size = Vector2.new(200, 488)
Drag.Position = Vector2.new(100, 100)
Drag.Color = Color3.fromRGB(30, 30, 30)
Drag.Filled = true
Drag.ZIndex = 2

local Title = Drawing.new("Text")
Title.ZIndex = 3
Title.Position = Vector2.new(Drag.Position.X + 5, Drag.Position.Y + 2)
Title.Color = Color3.fromRGB(255, 255, 255)
Title.Text = "shitsaken // " .. versionId .. " // Ping: 67"

local Background = Drawing.new("Square")
Background.ZIndex = 1
Background.Size = Vector2.new(Drag.Size.X + 4, Drag.Size.Y + 4)
Background.Position = Vector2.new(Drag.Position.X - 2, Drag.Position.Y - 2)
Background.Color = Color3.fromRGB(255, 255, 255)
Background.Filled = true

local BorderLine1 = Drawing.new("Square")
BorderLine1.ZIndex = 3
BorderLine1.Size = Vector2.new(Drag.Size.X - 6, 2)
BorderLine1.Position = Vector2.new(Drag.Position.X + 3, Drag.Position.Y + 20)
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
CreateHeader("Automation", Vector2.new(105, 543))
CreateCheckbox("Auto Generator (Tap Space)", Toggles.autoGen, Vector2.new(105, 560), "autoGen")

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

-- add esp objects
spawn(function()
	while true do
		task.wait(0.5)
		if updatesPaused == false then
			updateObjects()
		end
	end
end)

-- autogen
spawn(function()
	while true do
		if iskeypressed(0x20) then
			if game.Players.LocalPlayer.PlayerGui:FindFirstChild('PuzzleUI') then
				Grid = game.Players.LocalPlayer.PlayerGui.PuzzleUI.Container.GridHolder.Grid
				main()
			end
		end
		task.wait(.2)
	end
end)

-- esp position update + reseter
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
