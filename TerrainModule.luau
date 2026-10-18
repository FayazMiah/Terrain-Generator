local module = {}


local oresModule = require(workspace:WaitForChild("rockSystem").createOre)
local grassBlockPart = script.Parent.terrainParts:FindFirstChild("2"):Clone()

local function setVectorX(vector,x)
	local vector = Vector3.new(x, vector.Y, vector.Z)
	return vector
end

local function setVectorZ(vector,z)
	local vector = Vector3.new(vector.X, vector.Y, z)
	return vector
end

local function setVectorY(vector,y)
	local vector = Vector3.new(vector.X, y, vector.Z)
	return vector
end

local function makePart(position, size)
	local part = grassBlockPart:Clone()
	part.Size = size
	part.Position = position
	part.Anchored = true
	return part
end

local function applyGrassMeshes(terrain, color)
	for _, part in pairs(terrain:GetChildren()) do
		if math.random(1,10) == 1 then
			local meshes = script.Parent.grassMeshes
			local grassMesh = meshes:GetChildren()[math.random(1, #meshes:GetChildren())]:Clone()
			if grassMesh.Name == "1" then
				grassMesh.Size = setVectorY(part.Size, part.Size.X)
			elseif grassMesh.Name == "2" then
				grassMesh.Size = setVectorY(part.Size, part.Size.X / 4)
			end				
			grassMesh.Position = setVectorY(part.Position, part.Position.Y + (part.Size.Y / 2) + (grassMesh.Size.Y / 3))
			grassMesh.Color = color
			grassMesh.Anchored = true
			grassMesh.Parent = part
			grassMesh.CanCollide = false
		end
	end
end

local function getSecondValueSequence(sequence)
	local firstSequence = {}
	for i = 1, 3, 1 do
		local a = (i * i) * sequence.a
		local b = i * sequence.b
		local c = sequence.c
		table.insert(firstSequence, (a + b + c))
	end
	return firstSequence[2] - firstSequence[1]
end

local function heightLength(partOne, partTwo, size, terrainDirection)	
	
	--[[local truePositionOne = setVectorY(partOne.Position, partOne.Position.Y - (partOne.Size.Y / 2))
	local truePositionTwo = setVectorY(partTwo.Position, partTwo.Position.Y + (partTwo.Size.Y / 2))	
	local hypotonuse = (truePositionOne - truePositionTwo).Magnitude	
	
	local baseDistance = size.X
	local height = math.sqrt((hypotonuse * hypotonuse) - (baseDistance * baseDistance))
--	print(hypotonuse, baseDistance)
	return math.floor(height + 0.5) + size.X]]--
	
	local truePositionOne = setVectorY(partOne.Position, partOne.Position.Y - (partOne.Size.Y / 2))
	local truePositionTwo = setVectorY(partTwo.Position, partTwo.Position.Y + (partOne.Size.Y / 2))

	local truePositionOne = setVectorX(partOne.Position, 0)
	local truePositionTwo = setVectorX(partTwo.Position, 0)

	local truePositionOne = setVectorZ(partOne.Position, 0)
	local truePositionTwo = setVectorZ(partTwo.Position, 0)

	local height = (truePositionOne - truePositionTwo).Magnitude
--	print(height, partOne.Position, partTwo.Position)
	return height
	
end

local function getPartFromListByName(name, list)
	for i, item in pairs(list) do
		if item.Name == name then
			return item
		end
	end
end

local function getChunkPart(chunk, typeOfPart)
	for _, terrain in pairs(chunk:GetChildren()) do
		for _, part in pairs(terrain:GetChildren()) do
			if part:GetAttribute("firstPart") and typeOfPart == "first" and not part:GetAttribute("isChunkBuilt") then
				return part
			elseif part:GetAttribute("finalPart") and typeOfPart == "final" and not part:GetAttribute("isChunkBuilt") then
				return part
			end
		end
	end
end

local function getTerrainFromChunk(terrainNumber, chunk)
	for _, terrain in pairs(chunk:GetChildren()) do
		if terrain:GetAttribute("terrainNumber") == terrainNumber then
			return terrain
		end
	end
end

local function inverseTerrainDirection(terrainDirection)
	if terrainDirection == Vector3.new(1,0,0) then
		return Vector3.new(0,0,1)
	elseif terrainDirection == Vector3.new(0,0,1) then
		return Vector3.new(1,0,0)
	end
end

local function getSpecialPart(terrain, typeOfPart)
	for _, part in pairs(terrain:GetChildren()) do
		if part:GetAttribute("finalPart") and typeOfPart == "final" then
			return part
		elseif part:GetAttribute("firstPart") and typeOfPart == "first" then
			return part
		end
	end
end

local function getAverageOffset(terrainOne, terrainTwo, chunkDirection, size, terrainDirection)
	
	local heights = {}
	local totalHeight = 0
	
	if chunkDirection == "right" then
		for _, terrainOnePart in pairs(terrainOne:GetChildren()) do
			for _, terrainTwoPart in pairs(terrainTwo:GetChildren()) do
				if terrainOnePart.Name == terrainTwoPart.Name then
					
					local truePositionOne = setVectorY(terrainOnePart.Position, terrainOnePart.Position.Y - (terrainOnePart.Size.Y / 2))
					local truePositionTwo = setVectorY(terrainTwoPart.Position, terrainTwoPart.Position.Y + (terrainTwoPart.Size.Y / 2))	
					local hypotonuse = (truePositionOne - truePositionTwo).Magnitude	
					
					local truePositionOne = setVectorY(terrainOnePart.Position, 0)
					local truePositionTwo = setVectorY(terrainTwoPart.Position, 0)
					
					local truePositionOne = setVectorX(terrainOnePart.Position, terrainOnePart.Position.X - (terrainOnePart.Size.X / 2))
					local truePositionTwo = setVectorX(terrainTwoPart.Position, terrainTwoPart.Position.X + (terrainTwoPart.Size.X / 2))
					
					local truePositionOne = setVectorZ(terrainOnePart.Position, terrainOnePart.Position.Z - (terrainOnePart.Size.Z / 2))
					local truePositionTwo = setVectorZ(terrainTwoPart.Position, terrainTwoPart.Position.Z + (terrainTwoPart.Size.Z / 2))

					local baseDistance = (truePositionOne - truePositionTwo).Magnitude
					local height = math.sqrt((hypotonuse * hypotonuse) - (baseDistance * baseDistance))
					height = math.floor(height + 0.5)
					--print(hypotonuse, baseDistance)
					if height == height then
						table.insert(heights, height)
					end
				end
			end
		end
	end
	
	for _, v in pairs(heights) do
		totalHeight += v
	end
	
	local avgheight = totalHeight / #heights
	
	return avgheight
	
end

local oppositeDirection = {
	["right"] = "left",
	["left"] = "right"
}

local function absoluteVector(vector)
	return Vector3.new(math.abs(vector.X),math.abs(vector.Y),math.abs(vector.Z))
end

	
local function makeTerrain(startPosition, quadratic, count, terrainLength, terrainDirection, partPropertyTable, terrainName, connectingChunk, chunkDirection)
	

	local parts = {}
	
	local maximumPoint = (quadratic.b / (2 * quadratic.a)) * -1
	
	local firstHalf = {}
	local secondHalf = {}
	local sequenceCount = getSecondValueSequence(quadratic)

	local x = -(math.abs(count))
	local j = 1
	local previousPart
	local part = makePart(startPosition, partPropertyTable.Size)
	local startPart = part
	local temp
	part.Name = "startPart"
	part.BrickColor = BrickColor.new("Really red")
	--part.Parent = workspace
	
	j = 1
	
	if connectingChunk then
		if chunkDirection == "straight" then		
			local firstPart = getChunkPart(connectingChunk, "first")
			local lastPart = getChunkPart(connectingChunk, "final")
			if not lastPart or not firstPart then return end
			startPart = makePart(lastPart.Position, partPropertyTable.Size)
			--startPart.Position = startPart.Position + (terrainDirection * partPropertyTable.Size)
			startPosition = startPart.Position
			startPart.Name = "startPart"
			startPart.BrickColor = BrickColor.new("Really red")
			part = startPart
			firstPart:SetAttribute("isChunkBuilt", true)
			lastPart:SetAttribute("isChunkBuilt", true)
		elseif chunkDirection == "right" then
			
			local chunkTerrain = getTerrainFromChunk(1, connectingChunk)
			local chunkPart = chunkTerrain[terrainName]
			startPart = makePart(chunkPart.Position , partPropertyTable.Size)
			--startPart.Position = (startPart.Position + (inverseTerrainDirection(terrainDirection) * terrainLength)) - (terrainDirection * partPropertyTable.Size)
			startPart.Position = startPart.Position - (terrainDirection * partPropertyTable.Size) + (terrainDirection * partPropertyTable.Size)
			startPosition = startPart.Position
			part = startPart
			startPart.Name = "startPart"
			startPart.BrickColor = BrickColor.new("Really red")
			
		elseif chunkDirection == "left" then
			

			local chunkTerrain = getTerrainFromChunk(#connectingChunk:GetChildren(), connectingChunk)
			local chunkPart = chunkTerrain[terrainName]
			startPart = makePart(chunkPart.Position , partPropertyTable.Size)
			startPart.Position = startPart.Position
			startPosition = startPart.Position
			part = startPart
			startPart.Name = "startPart"
			startPart.BrickColor = BrickColor.new("Really red")
			
		end
	end

	while (startPosition - part.Position).Magnitude < terrainLength do
		if chunkDirection then
			if chunkDirection == "right" then
				local position = part.Position - (inverseTerrainDirection(terrainDirection) * partPropertyTable.Size)
				--print(startPosition,position)
				local nextPart = makePart(position, partPropertyTable.Size)
				nextPart.Parent = script.Parent.terrain
				nextPart.Name = tostring(j)
				part = nextPart
				table.insert(parts, nextPart)
			elseif chunkDirection == "left" then
				
				local position = part.Position + (inverseTerrainDirection(terrainDirection) * partPropertyTable.Size.X)
				local nextPart = makePart(position, partPropertyTable.Size)
				nextPart.Parent = script.Parent.terrain
				nextPart.Name = tostring(j)
				part = nextPart
				table.insert(parts, nextPart)
			else
				local position = part.Position + (terrainDirection * partPropertyTable.Size.X)
				local nextPart = makePart(position, partPropertyTable.Size)
				nextPart.Parent = script.Parent.terrain
				nextPart.Name = tostring(j)
				part = nextPart
				table.insert(parts, nextPart)
			end
		else
			local position = part.Position + (terrainDirection * partPropertyTable.Size.X)
			local nextPart = makePart(position, partPropertyTable.Size)
			nextPart.Parent = script.Parent.terrain
			nextPart.Name = tostring(j)
			part = nextPart
			table.insert(parts, nextPart)
		end
		wait(0.01)
		j += 1
	end

	local yOffset = (math.pow((x - 1),2) * quadratic.a) + ((x - 1)*quadratic.b) + (quadratic.c)
	startPart:Destroy()
	
	
	j = 1
	local reachedMax = false
	table.insert(firstHalf, parts[1])
	for i = 1,#parts, 1 do
		local currentPart = parts[i]
		local y = (math.pow(x,2) * quadratic.a) + (x*quadratic.b) + (quadratic.c)
		currentPart.Position = setVectorY(currentPart.Position, startPosition.Y + (y) - yOffset)
		if previousPart then
			if maximumPoint >= y and not reachedMax then
				table.insert(firstHalf, currentPart)
			else
				reachedMax = true
				table.insert(secondHalf, currentPart)
			end
		end
		x += 1
		previousPart = currentPart
	end
	
	previousPart = nil
	x = -count

	local heights = {}
	
	for i, currentPart in pairs(parts) do
		if parts[i + 1] then
			local nextPart = parts[i + 1]
			local height = heightLength(currentPart, nextPart, partPropertyTable.Size, terrainDirection)
			table.insert(heights, {currentPart.Name, height})
		else
			local nextPart = parts[i - 1]
			local height = heightLength(currentPart, nextPart, partPropertyTable.Size, terrainDirection)
			table.insert(heights, {currentPart.Name, height})
		end
	end
	
	for i, currentPart in pairs(parts) do
		for _, v in pairs(heights) do
			if v[1] == currentPart.Name then
				if chunkDirection == "right" or chunkDirection == "left" then
					currentPart.Size = setVectorY(currentPart.Size, (v[2] * currentPart.Size.Y))
					currentPart.Position = setVectorY(currentPart.Position, currentPart.Position.Y - partPropertyTable.Size.X)
				else
					currentPart.Size = setVectorY(currentPart.Size, ((v[2] * currentPart.Size.Y) + currentPart.Size.Y) * 2)
				end
			end
		end
	end
	
	local model = Instance.new("Model")
	
	if terrainName then
		model.Name = "terrain_" .. terrainName
	else
		model.Name = "terrain"
	end
	for _, part in pairs(parts) do
		part.Parent = model
		if partPropertyTable.Transparency then
			part.Transparency = partPropertyTable.Transparency
		end
		if partPropertyTable.Color then
			part.Color = partPropertyTable.Color
		end
		if partPropertyTable.Material then
			part.Material = partPropertyTable.Material
		end
		part:SetAttribute("groundPart", true)
	end

	getPartFromListByName(tostring(#parts), parts):SetAttribute("finalPart", true)
	parts[1]:SetAttribute("firstPart", true)
	
	
	--model.Parent = workspace
	
	applyGrassMeshes(model, partPropertyTable.Color)
	
	if math.random(1, 75) == 1 then
		local oreZone = parts[math.random(1, #parts)]
		if oreZone then
			local ore = oresModule.placeOreInZone(oreZone)
			if ore then
				ore.Parent = oreZone
			end
		end
	end
	
	return model
	
end

function module.makeChunk(startPosition, quadraticOne, quadraticTwo, count, terrainLength, terrainDirection, partPropertyTable, chunkName, newChunkParent, connectingChunk, chunkDirection)
	
	local chunk = Instance.new("Model")
	chunk.Name = chunkName
	
	if connectingChunk and chunkDirection then
		if chunk:GetAttribute(chunkDirection) then return end
	end
	
	if connectingChunk and chunkDirection then

		if chunkDirection == "right" then
			chunk:SetAttribute("left", true)
		elseif chunkDirection == "left" then
			chunk:SetAttribute("right", true)
		end

		connectingChunk:SetAttribute(chunkDirection, true)
	end
	
	if not connectingChunk then
		for x = 1,(terrainLength / partPropertyTable.Size.X),1 do
			local y = (math.pow(x,2) * -0.1) + (x*quadraticTwo.b) + (quadraticTwo.c)
			local position = startPosition + Vector3.new((partPropertyTable.Size.X * x),y,0)
			local terrainModel = makeTerrain(position, quadraticOne, count, terrainLength, terrainDirection, partPropertyTable, tostring(x))
			terrainModel:SetAttribute("terrainNumber", x)
			if terrainModel then
				terrainModel.Parent = chunk
			end
		end
	elseif connectingChunk then
		if chunkDirection == "straight" then
			for x = 1,(terrainLength / partPropertyTable.Size.X),1 do
				local y = (math.pow(x,2) * -0.1) + (x*quadraticTwo.b) + (quadraticTwo.c)
				local position = startPosition + Vector3.new((partPropertyTable.Size.X * x),y,0)
				local terrainModel = makeTerrain(position, quadraticOne, count, terrainLength, terrainDirection, partPropertyTable, tostring(x), connectingChunk, chunkDirection)
				terrainModel:SetAttribute("terrainNumber", x)
				if terrainModel then
					terrainModel.Parent = chunk
				end
			end
		elseif chunkDirection == "right" then
			for x = 1,(terrainLength / partPropertyTable.Size.X),1 do
				local y = (math.pow(x,2) * -0.1) + (x*quadraticTwo.b) + (quadraticTwo.c)
				local position = startPosition + Vector3.new((partPropertyTable.Size.X * x),y,0)
				local terrainModel = makeTerrain(position, quadraticOne, count, terrainLength, terrainDirection, partPropertyTable, tostring(x), connectingChunk, chunkDirection)
				terrainModel:SetAttribute("terrainNumber", x)
				if terrainModel then
					terrainModel.Parent = chunk
				end
			end
		elseif chunkDirection == "left" then
			for x = 1,(terrainLength / partPropertyTable.Size.X),1 do
				local y = (math.pow(x,2) * -0.1) + (x*quadraticTwo.b) + (quadraticTwo.c)
				local position = startPosition + Vector3.new((partPropertyTable.Size.X * x),y,0)
				local terrainModel = makeTerrain(position, quadraticOne, count, terrainLength, terrainDirection, partPropertyTable, tostring(x), connectingChunk, chunkDirection)
				terrainModel:SetAttribute("terrainNumber", x)
				if terrainModel then
					terrainModel.Parent = chunk
				end
			end
		end
	end
	
	chunk.Parent = newChunkParent
	return chunk
	
end


return module
