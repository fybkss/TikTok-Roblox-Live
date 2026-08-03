local AuraSystem = require(game.ReplicatedStorage.AuraSystem)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SpawnEvent = ReplicatedStorage.Shared:WaitForChild("SpawnNPC")
local TikTokSpawn = ReplicatedStorage:WaitForChild("TikTokSpawn")

local NPCFolder = workspace:FindFirstChild("NPCs")

if not NPCFolder then
	NPCFolder = Instance.new("Folder")
	NPCFolder.Name = "NPCs"
	NPCFolder.Parent = workspace
end


local MAX_NPCS = 50
local SPACING = 8
local NPC_PER_ROW = 5


local function getPosition(index)

	local row = math.floor(index / NPC_PER_ROW)
	local col = index % NPC_PER_ROW

	return Vector3.new(
		col * SPACING,
		10,
		row * SPACING
	)

end


local function spawnNPC(username)

	username = tostring(username)

	username = username:gsub("^%s+", "")
	username = username:gsub("%s+$", "")

	if username == "" then
		return
	end


	local userId
	local success = false


	for i = 1, 3 do

		success, userId = pcall(function()
			return Players:GetUserIdFromNameAsync(username)
		end)


		if success then
			break
		end


		warn("Percobaan ke-"..i.." gagal")
		task.wait(1)

	end


	if not success then
		warn("Username tidak ditemukan:", username)
		return
	end



	local descSuccess, description = pcall(function()
		return Players:GetHumanoidDescriptionFromUserId(userId)
	end)


	if not descSuccess then
		warn("Avatar gagal:", username)
		return
	end



	if #NPCFolder:GetChildren() >= MAX_NPCS then

		local oldNPC = NPCFolder:GetChildren()[1]

		if oldNPC then
			oldNPC:Destroy()
		end

	end



	local npc = Players:CreateHumanoidModelFromDescription(
		description,
		Enum.HumanoidRigType.R15
	)


	npc.Name = username
	npc.Parent = NPCFolder


	local index = #NPCFolder:GetChildren() - 1


	npc:PivotTo(
		CFrame.new(getPosition(index))
	)



	AuraSystem.CreateShadow(npc)


	print("NPC berhasil spawn:", username)

end



-- Spawn dari sistem lama
SpawnEvent.OnServerEvent:Connect(function(player, username)
	spawnNPC(username)
end)


-- Spawn dari TikTok
TikTokSpawn.Event:Connect(function(username)
	spawnNPC(username)
end)