local rs = game:GetService("ReplicatedStorage")
local hs = game:GetService("HttpService")
local modules = rs.Modules
local serializer = require(modules.Serializer)

local output = ""

for _, part in pairs(workspace.Serialize:GetChildren()) do
    local serialized = nil
	local startTime = tick()

	if part:IsA("BasePart") then
		print("serializing", part.Name)
		serialized = serializer:SerializeBasePart(part)
	elseif part:IsA("Model") or part:IsA("Folder") then
		print("serializing", part.Name)
		serialized = serializer:SerializeModel(part)
	end

	if serialized then
		print("done serializing", part.Name, "("..tick()-startTime..")")
		for _, name in pairs(part.Name:split("/")) do
			output ..= string.format([[{"prompt": "%s", "completion": "%s"}]].."\n", "build a "..name, serialized)
		end
	end
end

print("BEGIN OUTPUT\n", output, "END OUTPUT")