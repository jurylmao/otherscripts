--[[
 Merry Christmas skids!
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

local versionId = "v1.9"

-- acidzs stuff
_G.IsDrawing = false
local Grid

local Players = game:GetService("Players")	
local Http = game:GetService("HttpService")
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

local reelLetters = { -- these tables are seperate so auto reel doesnt have to sort through a bunch of bullshit
	[1] = {"W", 0x57},
	[2] = {"A", 0x41},
	[3] = {"S", 0x53},
	[4] = {"D", 0x44},
}

local keys = { -- use for later
	-- top row numbers
	{ "0", 0x30 },
	{ "1", 0x31 },
	{ "2", 0x32 },
	{ "3", 0x33 },
	{ "4", 0x34 },
	{ "5", 0x35 },
	{ "6", 0x36 },
	{ "7", 0x37 },
	{ "8", 0x38 },
	{ "9", 0x39 },

	-- letters
	{ "A", 0x41 }, { "B", 0x42 }, { "C", 0x43 }, { "D", 0x44 },
	{ "E", 0x45 }, { "F", 0x46 }, { "G", 0x47 }, { "H", 0x48 },
	{ "I", 0x49 }, { "J", 0x4A }, { "K", 0x4B }, { "L", 0x4C },
	{ "M", 0x4D }, { "N", 0x4E }, { "O", 0x4F }, { "P", 0x50 },
	{ "Q", 0x51 }, { "R", 0x52 }, { "S", 0x53 }, { "T", 0x54 },
	{ "U", 0x55 }, { "V", 0x56 }, { "W", 0x57 }, { "X", 0x58 },
	{ "Y", 0x59 }, { "Z", 0x5A },

	-- punctuation
	{ ";", 0xBA }, { "=", 0xBB }, { ",", 0xBC }, { "-", 0xBD },
	{ "period", 0xBE }, { "slash", 0xBF }, { "`", 0xC0 }, { "[", 0xDB },
	{ "backslash", 0xDC }, { "]", 0xDD }, { "'", 0xDE },

	-- space
	{ "SPACE", 0x20 },

	-- function row f1 f12
	{ "F1", 0x70 }, { "F2", 0x71 }, { "F3", 0x72 }, { "F4", 0x73 },
	{ "F5", 0x74 }, { "F6", 0x75 }, { "F7", 0x76 }, { "F8", 0x77 },
	{ "F9", 0x78 }, { "F10", 0x79 }, { "F11", 0x7A }, { "F12", 0x7B },

	-- modifiers
	{ "LSHIFT", 0xA0 },
	{ "RSHIFT", 0xA1 },
	{ "LCTRL", 0xA2 },
	{ "RCTRL", 0xA3 },

	-- nav cluster
	{ "INSERT", 0x2D },
	{ "DELETE", 0x2E },
	{ "HOME", 0x24 },
	{ "END", 0x23 },
	{ "PAGEUP", 0x21 },
	{ "PAGEDOWN", 0x22 },

	-- numpad
	{ "NUMPAD0", 0x60 }, { "NUMPAD1", 0x61 }, { "NUMPAD2", 0x62 },
	{ "NUMPAD3", 0x63 }, { "NUMPAD4", 0x64 }, { "NUMPAD5", 0x65 },
	{ "NUMPAD6", 0x66 }, { "NUMPAD7", 0x67 }, { "NUMPAD8", 0x68 },
	{ "NUMPAD9", 0x69 }, { "NUMPAD_MULTIPLY", 0x6A },
	{ "NUMPAD_ADD", 0x6B }, { "NUMPAD_SEPARATOR", 0x6C },
	{ "NUMPAD_SUBTRACT", 0x6D }, { "NUMPAD_DECIMAL", 0x6E },
	{ "NUMPAD_DIVIDE", 0x6F },
}

local Config = {
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
	coloredStamina = true,
	antiZeroStamina = true,
	veeronicaSpray = true,
	autoGen = false,
	oneXFourZombie = true,
	coolkiddMinions = true,
	killersEnabled = true,
	-- qte
	autoQTE = true,
	killerReelSpeed = 0.15,
	survivorReelSpeed = 0.15,
	nosferatuRandomDelay = 0.05,
}

-- save data manager


if isfile("shitsaken.cfg") then
	local loaded = Http:JSONDecode(readfile("shitsaken.cfg"))
	for i, v in pairs(loaded) do
		if Config[i] ~= nil then
			if type(v) == "number" then
				v = tonumber(string.format("%.2f", tostring(v)))
			end
			Config[i] = v
		end
	end
else
	writefile("shitsaken.cfg", Http:JSONEncode(Config))
end


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
	Graffiti = "veeronicaSpray",
	Zombie = "oneXFourZombie",
	C00lkidd = "coolkiddMinions",
	Killer = "killersEnabled"
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
	
	["Nosferatu"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "Nosferatu",
		Color = Color3.fromHex("ecc3dc"),
		Special = "Killer"
	},
	
	["Noli"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "Noli",
		Color = Color3.fromHex("ecc3dc"),
		Special = "Killer"
	},
	
	["1x1x1x1"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "1x1x1x1",
		Color = Color3.fromHex("ecc3dc"),
		Special = "Killer"
	},
	
	["JohnDoe"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "John Doe",
		Color = Color3.fromHex("ecc3dc"),
		Special = "Killer"
	},
	
	["Slasher"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "Slasher",
		Color = Color3.fromHex("ecc3dc"),
		Special = "Killer"
	},
	
	["Sixer"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "Guest 666",
		Color = Color3.fromHex("ff0000"),
		Special = "Killer"
	},
	
	["c00lkidd"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "c00lkidd",
		Color = Color3.fromHex("ff0000"),
		Special = "Killer"
	},

	["1x1x1x1Zombie"] = {
		Type = "Model",
		Root = "Torso",
		Text = "1x4 Zombie",
		Color = Color3.fromHex("046000"),
	},
	-- coolkidd minions there are so fucking many of these dude holy shit
	["PizzaDeliveryRig"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["Minion1"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["Minion2"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["Minion3"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["Minion4"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["GreenGuy"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["RedGuy"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["BlueGuy"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["PurpleGuy"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["Builderman"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["Elliot"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["ShedletskyCORRUPT"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["ChancecORRUPT"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["Mafia1"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["Mafia2"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["Mafia3"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},
	["Mafia4"] = {
		Type = "Model",
		Root = "HumanoidRootPart",
		Text = "C00lkidd Minion",
		Color = Color3.fromHex("ff0000"),
	},

}

local candyESPObjects = {
	-- event candy
	["Builderman"] = {
		Type = "Model",
		Root = "Part",
		Text = "Event Candy",
		Color = Color3.fromHex("45d16f"),
	},
	["Chance"] = {
		Type = "Model",
		Root = "Part",
		Text = "Event Candy",
		Color = Color3.fromHex("45d16f"),
	},
	["Guest"] = {
		Type = "Model",
		Root = "Part",
		Text = "Event Candy",
		Color = Color3.fromHex("45d16f"),
	},
	["Noob"] = {
		Type = "Model",
		Root = "Part",
		Text = "Event Candy",
		Color = Color3.fromHex("45d16f"),
	},
	["Shedletsky"] = {
		Type = "Model",
		Root = "Part",
		Text = "Event Candy",
		Color = Color3.fromHex("45d16f"),
	},
	["TwoTime"] = {
		Type = "Model",
		Root = "Part",
		Text = "Event Candy",
		Color = Color3.fromHex("45d16f"),
	}
}


print("shitsaken " .. versionId .. " loaded")

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
	Ping = get_offsets()["Ping"],
	Text = get_offsets()["TextLabelText"],
	ElementVisible = get_offsets()["FrameVisible"],
	Value = get_offsets()["Value"]
}


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

			if not s then
				notify("shitsaken", "Auto Generator could not solve this puzzle. Please do it manually.", 5)
			end

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
	section.Title.Font = Drawing.Fonts.System
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
	CheckboxText.Font = Drawing.Fonts.System
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
	SliderTitle.Font = Drawing.Fonts.System
	SliderTitle.ZIndex = 11
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
	SliderValue.Font = Drawing.Fonts.System
	SliderValue.ZIndex = 11
	SliderValue.Center = true
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
	HeaderText.Font = Drawing.Fonts.System
	HeaderText.ZIndex = 11
	HeaderText.Position = adjustedPos
	HeaderText.Color = Color3.fromRGB(255, 255, 255)
	HeaderText.Text = text

	AddElement(HeaderText, section)
end

local function CheckEnabled(text)
	for keyword, varname in pairs(textLookup) do
		if string.find(text, keyword) and Config[varname] then
			return true
		end
	end
	return false
end

local function SetValue(name, value)
	if Config[name] ~= nil then
		Config[name] = value
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

local function addObjects(v)
	for objName, objData in pairs(ESPObjects) do
		if string.find(v.Name, objName) and v:IsA(objData.Type) and not table.find(TempObjects, v.Address) and game.Workspace.Map.Ingame:FindFirstChild("Map") then
			local objType
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

				if objData.Special == "Killer" then
					objType = "Killer"
				else
					objType = "Object"
				end

				local objs
				local espText

				if objType == "Object" then
					espText = Drawing.new("Text")
					espText.Font = Drawing.Fonts.System
					espText.Text = objData.Text
					if rootPart ~= nil then
						if rootPart.Position ~= nil then
							espText.Position = WorldToScreen(rootPart.Position)
						end
					else
						espText:Remove()
						return
					end
					espText.Color = objData.Color
					espText.Outline = true
					espText.Center = true

				elseif objType == "Killer" then

					if rootPart ~= nil then

						local rLeg = v:FindFirstChild("Right Leg")
						local lLeg = v:FindFirstChild("Left Leg")
						local rArm = v:FindFirstChild("Right Arm") or v:FindFirstChild("Right Horn")
						local lArm = v:FindFirstChild("Left Arm") or v:FindFirstChild("Left Horn")
						local head = v:FindFirstChild("Head")

						
						if rLeg and lLeg and rArm and lArm and head then

							local boxOut, boxMid, boxIn, text = Drawing.new("Square"), Drawing.new("Square"), Drawing.new("Square"), Drawing.new("Text")

							boxIn.Color, boxOut.Color = Color3.fromHex("000000"), Color3.fromHex("000000")

							boxMid.Color, text.Color = Color3.fromHex("FF0000"), Color3.fromHex("FF0000")
							text.Outline = true
							text.Center = true
							text.Font = Drawing.Fonts.System
							text.Text = "Killer (" .. objData.Text .. ")"

							
							objs = {
								boxIn = boxIn, 
								boxMid = boxMid, 
								boxOut = boxOut, 
								text = text, 
								rLeg = rLeg, 
								lLeg = lLeg, 
								rArm = rArm, 
								lArm = lArm, 
								head = head
							}
						else
							return 
						end
					end
				end

				if rootPart ~= nil then
					table.insert(TempObjects, v.Address)
					local entry = {}
					entry.object = rootPart
					entry.type = objType
					if objType == "Killer" then
						entry.objs = objs
					else
						entry.text = espText
					end

					entry.model = v
					entry.temporary = true

					table.insert(TextList, entry)
				else
					if espText then espText:Remove() end
				end
			end
		end
	end
end

local function addCandyObjects(v) -- im so fucking lazyyyyyyyyyyyy
	for objName, objData in pairs(candyESPObjects) do
		if string.find(v.Name, objName) and v:IsA(objData.Type) and not table.find(TempObjects, v.Address) and game.Workspace.Map.Ingame:FindFirstChild("Map") then
			local objType
			local rootPart = v:FindFirstChild(objData.Root) or nil
			if objData.Root == "None" or rootPart then
				objType = "Object"

				local espText
					espText = Drawing.new("Text")
					espText.Font = Drawing.Fonts.System
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
					entry.type = objType
					entry.text = espText

					entry.model = v
					entry.temporary = true

					table.insert(TextList, entry)
				else
					if espText then espText:Remove() end
				end
			end
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

		if (v.type == "Object" and not v.text) or (v.type == "Killer" and not v.objs) then
			table.remove(TextList, i)
			continue
		end

		local ok, result

		if v.type == "Killer" then
			ok, result = pcall(function()
				if not v.object or not v.object.Parent then
					return nil, "remove"
				end

				local boxIn = v.objs.boxIn
				local boxMid = v.objs.boxMid
				local boxOut = v.objs.boxOut
				local text = v.objs.text


				local bottomPos = (v.objs.rLeg.Position + v.objs.lLeg.Position) / 2 - Vector3.new(0, 1, 0)
				local topPos = v.objs.head.Position + Vector3.new(0, 1, 0)
				local rightPos = v.objs.rArm.Position
				local leftPos = v.objs.lArm.Position

				local bottom2 = WorldToScreen(bottomPos)
				local top2 = WorldToScreen(topPos)
				local right2 = WorldToScreen(rightPos)
				local left2 = WorldToScreen(leftPos)

				if right2.X < left2.X then
					local temp = right2
					right2 = left2
					left2 = temp
				end

				local boxWidth = math.abs(right2.X - left2.X)
				local boxHeight = math.abs(bottom2.Y - top2.Y)

				local centerX = (right2.X + left2.X) / 2
				local centerY = (bottom2.Y + top2.Y) / 2

				-- Update Drawing properties
				boxIn.Size = Vector2.new(boxWidth, boxHeight)
				boxIn.Position = Vector2.new(centerX - (boxWidth / 2), centerY - (boxHeight / 2))

				boxMid.Size = Vector2.new(boxWidth + 2, boxHeight + 2)
				boxMid.Position = Vector2.new(centerX - (boxWidth / 2) - 1, centerY - (boxHeight / 2) - 1)

				boxOut.Size = Vector2.new(boxWidth + 4, boxHeight + 4)
				boxOut.Position = Vector2.new(centerX - (boxWidth / 2) - 2, centerY - (boxHeight / 2) - 2)

				text.Position = Vector2.new(centerX, centerY - (boxHeight / 2) - 12)

				local _, onScreen = WorldToScreen(v.object.Position)
				local isVisible = onScreen and Config.killersEnabled == true --and not string.find(Players.LocalPlayer.Character:GetFullName(), "Killers")

				if isVisible then
					boxIn.Visible = true
					boxMid.Visible = true
					boxOut.Visible = true
					text.Visible = true
				else
					boxIn.Visible = false
					boxMid.Visible = false
					boxOut.Visible = false
					text.Visible = false
				end

				return true, "ok"
			end)
		else
			-- objects
			ok, result = pcall(function()
				if not v.object or not v.object.Parent then
					return nil, "remove"
				end

				local objPos = v.object.Position
				local screenPos, onScreen = WorldToScreen(objPos)

				local isVisible = false
				local okName, fullname = pcall(function() return v.object:GetFullName() end)

				if okName and string.find(fullname, "Workspace") and onScreen and CheckEnabled(v.text.Text) then
					isVisible = true
				end

				if isVisible and Config.espEnabled then
					v.text.Visible = true
					v.text.Position = screenPos
				else
					v.text.Visible = false
				end

				-- Generators
				if v.model and v.object and v.object.Name == "Main" and game.Workspace.Map and game.Workspace.Map:FindFirstChild("Ingame") and game.Workspace.Map.Ingame:FindFirstChild("Map") then
					local value = 0
					local okProg, progVal = pcall(function()
						local prog = v.model:FindFirstChild("Progress")
						return prog and prog.Value or 0
					end)
					if okProg then value = progVal end

					local Progress = 0
					if value == 26 then Progress = 1
					elseif value == 52 then Progress = 2
					elseif value == 78 then Progress = 3
					elseif value == 100 then
						Progress = 4
						pcall(function() v.text.Color = Color3.fromHex("764a4a") end)
					end
					if v.model.Name ~= "Fake Generator" then
						pcall(function()
							v.text.Text = "Generator (" .. tostring(Progress) .. "/4)"
						end)
					end
				end

				return true, "ok"
			end)
		end

		if not ok or result == "remove" or result == nil then
			pcall(function()
				if v and v.text then v.text:Remove() end
				if v and v.objs then
					v.objs.boxIn:Remove()
					v.objs.boxMid:Remove()
					v.objs.boxOut:Remove()
					v.objs.text:Remove()
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
			addCandyObjects(v)
		end
	end
	
	-- killer
	if game.Workspace.Players.Killers then
		for _, v in game.Workspace.Players.Killers:GetChildren() do
			addObjects(v)
		end
	end

end

local function updateQuickUI()
	local StaminaText
	local color = Color3.fromRGB(255, 255, 255)
	local currentstam
	local success, result = pcall(function()
		return Players.LocalPlayer.PlayerGui.TemporaryUI.PlayerInfo.Bars.Stamina
	end)
	local isReal = success and result or nil

	if isReal then
		local s, r = pcall(function()
			return tostring(memory_read("string", Players.LocalPlayer.PlayerGui:FindFirstChild("TemporaryUI"):FindFirstChild("PlayerInfo"):FindFirstChild("Bars"):FindFirstChild("Stamina"):FindFirstChild("Amount").Address + memoryOffsets.Text))
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
					notify("shitsaken", "An error occured while getting stamina.", 5)
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
				stamina.Font = Drawing.Fonts.System
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

				writefile("shitsaken.cfg", Http:JSONEncode(Config))
				notify("shitsaken", "saved config", 2)
			end
		end
	end
end



local visualsSection = CreateSection("shitsaken " .. versionId .. " // Visuals", Vector2.new(250, 100), Vector2.new(200, 488), Color3.fromRGB(35, 35, 35))
local utiliesSection = CreateSection("shitsaken " .. versionId .. " // Utilities", Vector2.new(500, 100), Vector2.new(200, 342), Color3.fromRGB(35, 35, 35))

--[[
+17 (header -> checkbox)
+25 (checkbox -> header)
+28 (checkbox -> checkbox)
+50 (slider -> slider)
]]

-- visual section
CreateHeader("ESP", Vector2.new(5, 25), visualsSection)
CreateCheckbox("ESP Enabled", Config.espEnabled, Vector2.new(5, 40), "espEnabled", visualsSection)
CreateCheckbox("Taph Tripmine ESP", Config.taphTripmine, Vector2.new(5, 68), "taphTripmine", visualsSection)
CreateCheckbox("Taph Tripwire ESP", Config.taphTripwire, Vector2.new(5, 96), "taphTripwire", visualsSection)
CreateCheckbox("Two Time Respawn ESP", Config.twoTimeRespawn, Vector2.new(5, 124), "twoTimeRespawn", visualsSection)
CreateCheckbox("Veeronica Graffiti ESP", Config.veeronicaSpray, Vector2.new(5, 152), "veeronicaSpray", visualsSection)
CreateCheckbox("Bloxy Cola ESP", Config.gameCola, Vector2.new(5, 180), "gameCola", visualsSection)
CreateCheckbox("Medkit ESP", Config.gameMedkit, Vector2.new(5, 208), "gameMedkit", visualsSection)
CreateCheckbox("Builderman Sentry ESP", Config.buildermanSentry, Vector2.new(5, 236), "buildermanSentry", visualsSection)
CreateCheckbox("Builderman Dispenser ESP", Config.buildermanDispenser, Vector2.new(5, 264), "buildermanDispenser", visualsSection)
CreateCheckbox("Generator ESP", Config.gameGenerator, Vector2.new(5, 292), "gameGenerator", visualsSection)
CreateCheckbox("Fake Generator ESP", Config.noliGenerator, Vector2.new(5, 320), "noliGenerator", visualsSection)
CreateCheckbox("Digital Footprint ESP", Config.johndoeDigitalFootprint, Vector2.new(5, 348), "johndoeDigitalFootprint", visualsSection)
CreateCheckbox("1x1x1x1 Zombies ESP", Config.oneXFourZombie, Vector2.new(5, 376), "oneXFourZombie", visualsSection)
CreateCheckbox("C00lkidd Minions ESP", Config.coolkiddMinions, Vector2.new(5, 404), "coolkiddMinions", visualsSection)
CreateCheckbox("Killer ESP", Config.killersEnabled, Vector2.new(5, 432), "killersEnabled", visualsSection)
CreateCheckbox("Event Candy ESP", Config.eventItem, Vector2.new(5, 460), "eventItem", visualsSection)

-- utilities section
CreateHeader("Visual Tools", Vector2.new(5, 25), utiliesSection)
CreateCheckbox("Stamina on Mouse", Config.staminaOnMouse, Vector2.new(5, 40), "staminaOnMouse", utiliesSection)
CreateCheckbox("Colored Stamina", Config.coloredStamina, Vector2.new(5, 68), "coloredStamina", utiliesSection)
CreateHeader("Automation", Vector2.new(5, 93), utiliesSection)
CreateCheckbox("Auto Generator (Tap Space)", Config.autoGen, Vector2.new(5, 108), "autoGen", utiliesSection)
CreateCheckbox("Auto Reel/Escape", Config.autoQTE, Vector2.new(5, 136), "autoQTE", utiliesSection)
CreateSlider("Auto Reel Speed (secs)", Config.killerReelSpeed, "killerReelSpeed", 0.05, 1, Vector2.new(5, 164), utiliesSection)
CreateSlider("Auto Escape Speed (secs)", Config.survivorReelSpeed, "survivorReelSpeed", 0.05, 1, Vector2.new(5, 214), utiliesSection)
CreateSlider("Nosferatu Latency (secs)", Config.nosferatuRandomDelay, "nosferatuRandomDelay", 0.05, 1, Vector2.new(5, 264), utiliesSection)
CreateCheckbox("Anti Zero Stamina", Config.antiZeroStamina, Vector2.new(5, 314), "antiZeroStamina", utiliesSection)

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
		if iskeypressed(0x20) and Config.autoGen == true then
			if game.Players.LocalPlayer.PlayerGui:FindFirstChild('PuzzleUI') then
				if game.Players.LocalPlayer.PlayerGui:FindFirstChild('PuzzleUI'):FindFirstChild('Container').AbsoluteSize.X > 5 then
					Grid = game.Players.LocalPlayer.PlayerGui.PuzzleUI.Container.GridHolder.Grid
					main()
				end
			end
		end
		task.wait(.2)
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

-- auto reel / escape
spawn(function()
	while true do
		if game.Players.LocalPlayer.PlayerGui.TemporaryUI:FindFirstChild("QTE") and Config.autoQTE == true then
			local keys = {}
			local largestKey = nil
			local largestSize = 0

			for _, v in game.Players.LocalPlayer.PlayerGui.TemporaryUI:FindFirstChild("QTE"):GetChildren() do
				if v.Name == "PC" and v:FindFirstChild("TextLabel") then
					table.insert(keys, v)
				end
			end

			for _, v in ipairs(keys) do
				local keytext = v:FindFirstChild("TextLabel").Text or ""
				local keysize = v.AbsoluteSize.Y

				local testMemory = memory_read("byte", v.Address + memoryOffsets.ElementVisible)

				if not testMemory then
					if os.clock() >= lastNotif + 5 then
						notify("shitsaken", "An error occured while doing the quick time event.", 5)
						lastNotif = os.clock()
					end
				end

				if memory_read("byte", v.Address + memoryOffsets.ElementVisible) == 1 and keysize > largestSize then
					largestSize = keysize
					largestKey = v
				end
			end

			if largestKey then
				local keytext = memory_read("string", largestKey:FindFirstChild("TextLabel").Address + memoryOffsets.Text) or ""
				for _, entry in pairs(reelLetters) do
					local letter = entry[1]
					if keytext == letter then
						keypress(entry[2])
						task.wait()
						keyrelease(entry[2])
						break 
					end
				end
			end
			local qteDelay
			
			if math.random(1,2) == 1 then -- idk why the fuck this works but the other thing didnt but whatever bro
				qteDelay = Config.nosferatuRandomDelay
			else
				qteDelay = 0 - Config.nosferatuRandomDelay
			end
			if qteDelay <= 0 then
				qteDelay = 0.01
			end
			
			if Players.LocalPlayer.Character.Parent.Name == "Killers" then
				task.wait(Config.killerReelSpeed + qteDelay)
			else
				task.wait(Config.survivorReelSpeed + qteDelay)
			end
			
		end	
		task.wait()
	end
end)

-- esp position update + reseter
spawn(function()
	while true do

		if game.Workspace.Map.Ingame:FindFirstChild("Map") then
			updatePositions()
		else
			for _, v in TextList do
				if v.type == "Killer" then
					v.objs.boxIn:Remove()
					v.objs.boxMid:Remove()
					v.objs.boxOut:Remove()
					v.objs.text:Remove()
					
				else
					v.text:Remove()
				end
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

notify("shitsaken", "shitsaken " .. versionId .. " loaded successfully!", 5)
