
local growthTime = 5
local growRate = 5


local functions = require(script.Parent.growRoot)
local chunksFolder = workspace:WaitForChild("chunksFolder")

local function isPositionValid(object, position)
	local objectTemplate = object:Clone()
	objectTemplate.Transparency = 1
	objectTemplate.CanCollide = false
	objectTemplate.Position = position
	objectTemplate.Parent = workspace
	local connection = objectTemplate.Touched:Connect(function() end)
	local touchingParts = objectTemplate:GetTouchingParts()
	connection:Disconnect()
	--print(touchingParts)
	for _, v in pairs(touchingParts) do
		if not v:GetAttribute("groundPart") then --or (not (v == zone)) then
			objectTemplate:Destroy()
		--	print(touchingParts)
			return false
		end
	end
	objectTemplate:Destroy()
	return true
end

local function createRootPosition(zone)

	local x = zone.Position.X + math.random(-zone.Size.X/2.25,zone.Size.X/2.25)
	local y = zone.Position.Y + (zone.Size.Y / 2)
	local z = zone.Position.Z + math.random(-zone.Size.Z/2.25,zone.Size.Z/2.25)
	local vector = Vector3.new(x,y,z)
	
	if not isPositionValid(script:FindFirstChild("rootTemplate"), vector, zone) then
		wait(.25)
		--	print("not valid")
		return false
	end
	return vector
end

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

local function createRoot()
	if #chunksFolder:GetChildren() <= 0 then
		wait()
		createRoot()
		return
	end
	local zone = getZone()
	local pos = createRootPosition(zone)
	if not pos then
		wait()
		createRoot()
		return
	end
	local root = script.Parent.treeRoot:Clone()
	for _, v in pairs(root:GetChildren()) do
		v.CanCollide = true
	end
	root.root.BrickColor = BrickColor.new("Earth green")
	root.root.Material = Enum.Material.Grass
	root.root.Transparency = 0
	root.Parent = script.Parent.currentTrees
	root:MoveTo(pos)
	spawn(function()
		wait(growthTime)
		functions.growRoot(root)
		root.root:FindFirstChild("ProximityPrompt").Triggered:Connect(function(player)

			local woodSpawnPoint = root.root.Position + Vector3.new(0,2,0)
			local wood = game.ServerStorage.objects["Wood"]:Clone()
			wood.Position = woodSpawnPoint
			wood.Parent = workspace
			root:Destroy()

		end)
	end)
	
end

while true do
	createRoot()
	wait(growRate)
end