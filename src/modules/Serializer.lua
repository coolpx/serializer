local module = {}

function module:SerializeBasePart(instance: BasePart): string
	return string.format(
		"%s:%s:%s:%s:%s:%s",
		instance.ClassName,
		tostring(instance.Material):split(".")[3],
		string.format(
			"%s/%s/%s",
			tostring(math.round(instance.Color.R*255)),
			tostring(math.round(instance.Color.G*255)),
			tostring(math.round(instance.Color.B*255))
		),
		string.format(
			"%s/%s/%s",
			tostring(math.round(instance.Position.X*100)/100),
			tostring(math.round(instance.Position.Y*100)/100),
			tostring(math.round(instance.Position.Z*100)/100)
		),
		string.format(
			"%s/%s/%s",
			tostring(math.round(instance.Size.X*100)/100),
			tostring(math.round(instance.Size.Y*100)/100),
			tostring(math.round(instance.Size.Z*100)/100)
		),
		string.format(
			"%s/%s/%s",
			tostring(math.round(instance.Orientation.X*100)/100),
			tostring(math.round(instance.Orientation.Y*100)/100),
			tostring(math.round(instance.Orientation.Z*100)/100)
		)
	)
end

function module:DeserializeBasePart(serializedData: string): BasePart
	local data = serializedData:split(":")
	local colorData = data[3]:split("/")
	local posData = data[4]:split("/")
	local sizeData = data[5]:split("/")
	local rotData = data[6]:split("/")
	
	local part = Instance.new(data[1])
	part.Anchored = true
	part.Material = Enum.Material[data[2]]
	part.Color = Color3.new(tonumber(colorData[1])/255, tonumber(colorData[2])/255, tonumber(colorData[3])/255)
	part.Position = Vector3.new(tonumber(posData[1]), tonumber(posData[2]), tonumber(posData[3]))
	part.Size = Vector3.new(tonumber(sizeData[1]), tonumber(sizeData[2]), tonumber(sizeData[3]))
	part.Orientation = Vector3.new(tonumber(rotData[1]), tonumber(rotData[2]), tonumber(rotData[3]))
	
	return part
end

function module:SerializeModel(model: Model)
	local modelString = ""
	
	for _, part in pairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			modelString ..= module:SerializeBasePart(part)..";"
		end
	end
	
	return modelString:sub(1, -2)
end

function module:DeserializeModel(serializedData: string): Model
	local model = Instance.new("Model")
	
	for _, partData in pairs(serializedData:split(";")) do
		local part = module:DeserializeBasePart(partData)
		part.Parent = model
	end
	
	return model
end

return module