local module = {}

local growRate = 5

local ServerStorage = game:GetService("ServerStorage")
local objectFolder = ServerStorage.objects

local chunksFolder = workspace:WaitForChild("chunksFolder")

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

local function createRockPosition(rock, zone)
	if #chunksFolder:GetChildren() <= 0 then
		wait()
		return false
	end

	local x = zone.Position.X
	local y = (zone.Position.Y + (zone.Size.Y / 2)) + (rock.Size.Y / 2.3)
	local z = zone.Position.Z

	local vector = Vector3.new(x,y,z)

	if not isPositionValid(rock, vector) then
		wait()
		--	print("not valid")
		return false
	end
	return vector
end

local oresName = {
	["coalOre"] = "Coal",
	["ironOre"] = "Iron Ore",
	["goldOre"] = "Gold Ore",
	["emeraldOre"] = "Emerald Ore",
	["diamondOre"] = "Diamond Ore",
	["rubyOre"] = "Ruby Ore"
	
}

local function makeProximityPrompt(oreType)
	local proxPrompt = Instance.new("ProximityPrompt")
	proxPrompt.ActionText = "Mine"
	proxPrompt.ObjectText = oresName[oreType]
	proxPrompt.HoldDuration = 1.5
	proxPrompt.RequiresLineOfSight = false
	return proxPrompt
end

local function getOre()
	local ores = script.Parent.ores
	local oreType
	
	local random = math.random(1,85)
	
	if random < 25 then
		oreType = "coalOre"
	elseif random < 50 then
		oreType = "ironOre"
	elseif random < 65 then
		oreType = "goldOre"
	elseif random < 75 then
		oreType = "emeraldOre"
	elseif random < 80 then
		oreType = "diamondOre"
	elseif random <= 85 then
		oreType = "rubyOre"
	else
		oreType = "coalOre"
	end
		
	local ore = ores[oreType]:Clone()
	
	local proxPrompt = makeProximityPrompt(oreType)
	proxPrompt.Parent = ore
	proxPrompt.Triggered:Connect(function(player)
		
		local oreNode = objectFolder:FindFirstChild(oresName[oreType]):Clone()
		for _, v in pairs(oreNode:GetChildren()) do
			v.Anchored = false
		end 
		local position = ore.PrimaryPart.Position + Vector3.new(0, 3, 0)	
		oreNode.Parent = workspace
		if oreNode:IsA("BasePart") then
			oreNode.Position = position
		else
			oreNode:MoveTo(position)
		end
		ore:Destroy()
	end)
	return ore
end

function module.placeOreInZone(zone)
	local ore = getOre()

	for _, v in pairs(ore.oreModel:GetChildren()) do
		v.Transparency = 0
	end

	local position = createRockPosition(ore:FindFirstChild("oreModel").rockPart, zone)
	if not position then
		return
	end
	position = position + Vector3.new(0,-2.5,0)
	ore.Parent = script.Parent.currentOres
	ore:SetPrimaryPartCFrame(CFrame.new(position))
	return ore
end

return module
