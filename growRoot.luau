local module = {}


local function makePlace(part, treeType)

	local newPart = Instance.new("Part")
	if treeType == "primary" then
		newPart.Name = "primaryPlace"
		newPart.Size = Vector3.new(part.Size.X * 0.6, 0.1, part.Size.X * 0.6)
	else
		newPart.Name = "secondaryPlace"
		newPart.Size = Vector3.new(part.Size.X * 0.4, 0.1, part.Size.X * 0.4)
	end
	newPart.CFrame = part.CFrame
	newPart.CFrame = newPart.CFrame * CFrame.new(0,part.Size.Y / 2.1,0)
	newPart.Anchored = true
	newPart.Parent = part.Parent

	return newPart
end

local function primaryPartManager(partPlace)

	local maxLength = 5.5
	local random = Random.new()

	local newPart = partPlace:Clone()
	newPart.Position = partPlace.Position
	newPart.Parent = partPlace.Parent

	--newPart.Orientation = Vector3.new(0,math.random(90,360), math.random(5,18))

	if newPart.Parent:IsA("Model") then
		newPart.Orientation = Vector3.new(0,math.random(90,360), math.random(5,18))
	else
		newPart.Orientation = partPlace.Parent.Orientation
		newPart.Orientation = Vector3.new(newPart.Orientation.X + math.random(5,20), newPart.Orientation.Y + math.random(5,20), newPart.Orientation.Z)
	end

	newPart.Size = Vector3.new(newPart.Size.X,random:NextNumber(3.5, maxLength),newPart.Size.Z)
	if newPart.Size.Y > 5 then
		newPart.CFrame = newPart.CFrame * CFrame.new(0,1.5,0)
	else
		newPart.CFrame = newPart.CFrame * CFrame.new(0,1,0)
	end

	newPart.Name = "primaryBark"
	partPlace:FindFirstChild("secondaryPlace").Parent = newPart
	newPart:FindFirstChild("secondaryPlace").Name = "usedSecondaryPart"
	partPlace:Destroy()
	local newPlacePart = makePlace(newPart, "primary")
	local newSecondaryPlacePart = makePlace(newPart, "secondary")
	newPlacePart.Parent = newPart
	newSecondaryPlacePart.Parent = newPlacePart
end

local function secondaryPartManager(placePart, primaryPart)

	local newPart = placePart:Clone()
	newPart.Position = placePart.Position
	newPart.Parent = placePart.Parent
	local random = Random.new()
	local maxLength = 5

	if newPart.Parent:IsA("Model") then
		newPart.Orientation = -(primaryPart.Orientation)
		newPart.Orientation = Vector3.new(0,math.random(90,360), math.random(5,18))
	else
		newPart.Orientation = placePart.Parent.Orientation
		newPart.Orientation = Vector3.new(newPart.Orientation.X + math.random(5,20), newPart.Orientation.Y + math.random(5,20), newPart.Orientation.Z)
	end
	newPart.Orientation = Vector3.new(math.random(10,20), newPart.Orientation.Y, (newPart.Orientation.Z + math.random(0,10)))
	newPart.Size = Vector3.new(newPart.Size.X,random:NextNumber(2, maxLength),newPart.Size.Z)

	if newPart.Size.Y > 2.5 and newPart.Parent:IsA("Model") then
		newPart.CFrame = newPart.CFrame * CFrame.new(0,2,0)
	elseif newPart.Size.Y > 4 and newPart.Parent:IsA("Model") then
		newPart.CFrame = newPart.CFrame * CFrame.new(0,2.5,0)
	end


	newPart.Name = "secondaryBark"
	placePart:Destroy()
	local newPlacePart = makePlace(newPart, "secondary")
	local newPrimaryPlacePart = makePlace(newPart, "primary")
	newPrimaryPlacePart.Name = "primaryPlace"
	newPart.Parent = newPart.Parent.Parent
	newPlacePart.Parent = newPrimaryPlacePart
	newPrimaryPlacePart.Parent = newPart

end

local function applyLeaves(tree, colour)
	
	local colours = {
		--[[black = BrickColor.new("Really black"),
		white = BrickColor.new("Medium stone grey"),
		red = BrickColor.new("Bright red"),
		blue = BrickColor.new("Deep blue"),
		yellow = BrickColor.new("Deep orange")]]--
		
		green = BrickColor.new("Earth green")
	}

	for _, v in pairs(tree:GetDescendants()) do
		if v.Name == "primaryPlace" or v.Name == "secondaryPlace" then
			local leaf = Instance.new("Part")
			leaf.Size = v.Size * 12.5
			leaf.Anchored = true
			leaf.Transparency = 0.3
			leaf.BrickColor = colours[colour]
			leaf.CFrame = v.CFrame
			leaf.Parent = v.Parent
			leaf.Material = Enum.Material.Ground
			leaf.CanCollide = false
		end
	end

end

function module.growRoot(v)

	for _, j in pairs(v:GetChildren()) do
		if j.Name == "primaryPlace" then
			primaryPartManager(j)
		end
	end
	for _, j in pairs(v:GetChildren()) do
		if j.Name == "primaryBark" then
			secondaryPartManager(j:FindFirstChild("secondaryPlace"), j)
		end
	end
	for _, j in pairs(v:GetChildren()) do
		if j.Name == "primaryBark" and j:FindFirstChild("primaryPlace") then
			primaryPartManager(j:FindFirstChild("primaryPlace"))
		end
	end
	for _, j in pairs(v:GetChildren()) do
		if j.Name == "secondaryBark" and j:FindFirstChild("primaryPlace") then
			secondaryPartManager(j:FindFirstChild("primaryPlace"):FindFirstChild("secondaryPlace"), j:FindFirstChild("primaryPlace"))
		end
	end
	
	local treeTypes = {
		--[["black",
		"white",
		"blue",
		"red",
		"yellow"]]--
		"green"
	}
	local chosenType = treeTypes[math.random(1,#treeTypes)]
	applyLeaves(v,chosenType)

	for _, j in pairs(v:GetDescendants()) do
		j.Transparency = 0
		if j.Name == "primaryBark" or j.Name == "secondaryBark" or j.Name == "root" then
			j.BrickColor = BrickColor.new("Pine Cone")
			j.Material = Enum.Material.Concrete
		end
	end
	
	v:SetAttribute("treeType", chosenType)
	v:SetAttribute("isGrown", true)
	local proxPrompt = Instance.new("ProximityPrompt")
	proxPrompt.ActionText = "Harvest"
	proxPrompt.ObjectText = "Tree"
	proxPrompt.HoldDuration = 0.5
	proxPrompt.RequiresLineOfSight = false
	proxPrompt.Parent = v:FindFirstChild("root")

end



return module
