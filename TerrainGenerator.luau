
local module = require(script.Parent.ModuleScript)

local startPoint = Vector3.new(100,100,100)
local terrainLength = 40
local startingTerrainDirection = Vector3.new(0,0,1)

local propertyTable = {
	["Size"] = Vector3.new(4,4,4),
	["Material"] = Enum.Material.Grass,
	["Color"] = Color3.fromRGB(28, 56, 23),
}


local function randomQuadratic(min, max)
	
	min *= 10000
	max *= 10000
	
	local aValue = math.random(min, max)
	local bValue = math.random(min, max)
	local cValue = 0
	
	aValue /= 10000
	bValue /= 10000
	cValue /= 10000
	
	return {a = aValue, b = bValue, c = cValue}
end


local previousChunk = nil
local increment = 1

local function inverseTerrainDirection(terrainDirection)
	if terrainDirection == Vector3.new(1,0,0) then
		return Vector3.new(0,0,1)
	elseif terrainDirection == Vector3.new(0,0,1) then
		return Vector3.new(1,0,0)
	end
end

local chunksFolder = workspace:WaitForChild("chunksFolder")

mainChunk = module.makeChunk(startPoint, randomQuadratic(-0.02, 0.02), randomQuadratic(-0.02, 0.02), math.random(20,25), terrainLength, startingTerrainDirection, propertyTable, "chunk_" .. tostring(increment), chunksFolder)

while true do
	mainChunk = module.makeChunk(startPoint, randomQuadratic(-0.02, 0.02), randomQuadratic(-0.02, 0.02), math.random(20,25), terrainLength, startingTerrainDirection, propertyTable, "chunk_" .. tostring(increment), chunksFolder, mainChunk, "straight")
	spawn(function()
		module.makeChunk(startPoint, randomQuadratic(-0.02, 0.02), randomQuadratic(-0.02, 0.02), math.random(20,25), terrainLength, startingTerrainDirection, propertyTable, "chunk_" .. tostring(increment), chunksFolder, mainChunk, "right")
	end)
	spawn(function()
		module.makeChunk(startPoint, randomQuadratic(-0.02, 0.02), randomQuadratic(-0.02, 0.02), math.random(20,25), terrainLength, startingTerrainDirection, propertyTable, "chunk_" .. tostring(increment), chunksFolder, mainChunk, "left")
	end)
	increment += 1
end