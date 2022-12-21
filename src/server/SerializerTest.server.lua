local rs = game:GetService("ReplicatedStorage")
local modules = rs.Modules
local serializer = require(modules.Serializer)

print(serializer)

for _, part in pairs(workspace.Serialize:GetChildren()) do
	if part:IsA("BasePart") then
		local serialized = serializer:SerializeBasePart(part)
		print(serialized)
		part:Destroy()
		serializer:DeserializeBasePart(serialized).Parent = workspace.Deserialized
	elseif part:IsA("Model") or part:IsA("Folder") then
		local serialized = serializer:DeserializeModel(part)
		print(serialized)
		part:Destroy()
		serializer:DeserializeModel(serialized).Parent = workspace.Deserialized
	end
end