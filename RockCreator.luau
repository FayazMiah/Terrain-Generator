

local rockMaxSize = 20
local rockMinSize = 6

local growRate = 15

local chunksFolder = workspace:WaitForChild("chunksFolder")

local function getZone()
	local parts = chunksFolder:GetDescendants()
	local part = parts[math.random(1, #parts)]
	if part:GetAttribute("groundPart") then
		return part
	else
		wait()
		return getZone()
	end
end

local function isPositionValid(rock, position)
	local rockTemplate = rock:Clone()
	rockTemplate.Transparency = 1
	rockTemplate.CanCollide = false
	rockTemplate.Position = position
	rockTemplate.Parent = workspace
	local connection = rockTemplate.Touched:Connect(function() end)
	local touchingParts = rockTemplate:GetTouchingParts()
	connection:Disconnect()
--	print(touchingParts)
	for _, v in pairs(touchingParts) do
		if not v:GetAttribute("groundPart") then
			rockTemplate:Destroy()
			return false
		end
	end
	rockTemplate:Destroy()
	return true
end

local function createRockPosition(rock)
	if #chunksFolder:GetChildren() <= 0 then
		wait()
		return false
	end
	local zone = getZone()
	
	local x = zone.Position.X + math.random(-zone.Size.X/(rock.Size.X / 2.5),zone.Size.X/ (rock.Size.X / 2.5))
	local y = (zone.Position.Y + (zone.Size.Y / 2)) + (rock.Size.Y / 2.3)
	local z = zone.Position.Z + math.random(-zone.Size.Z/(rock.Size.Z / 2.5),zone.Size.Z/(rock.Size.Z / 2.5))
	local vector = Vector3.new(x,y,z)
	if not isPositionValid(rock, vector, zone) then
		wait()
	--	print("not valid")
		return false
	end
	return vector
end

local function makeProximityPrompt(rockSize)
	local proxPrompt = Instance.new("ProximityPrompt")
	proxPrompt.ActionText = "Harvest"
	proxPrompt.ObjectText = "Rock"
	proxPrompt.HoldDuration = rockSize / 6
	proxPrompt.RequiresLineOfSight = false
	return proxPrompt
end

local function getRock()
	local rocks = script.Parent.rocks:GetChildren()
	local rock = rocks[math.random(1, #rocks)]:Clone()
	local rockSize = math.random(rockMinSize,rockMaxSize)
	rock.Size = Vector3.new(rockSize, rockSize, rockSize)
	local proxPrompt = makeProximityPrompt(rockSize)
	proxPrompt.Parent = rock
	proxPrompt.Triggered:Connect(function(player)
		for i = 1, (math.floor(rockSize / (rockMaxSize - rockMinSize)) + 1), 1 do
			local rockSpawnPoint = rock.Position + Vector3.new(0,2,0)
			local rockItem = game.ServerStorage.objects["Rock"]:Clone()
			rockItem.Position = rockSpawnPoint
			rockItem.Parent = workspace
		end
		rock:Destroy()
	end)
	return rock
end

local function placeRockInZone()
	local rock = getRock()
	rock.Transparency = 0
	
	local position = createRockPosition(rock)
	if not position then
		placeRockInZone()
		return
	end
	rock.Position = position
	rock.Parent = script.Parent.currentRocks
end

while true do
	wait(growRate)
	placeRockInZone()
end
