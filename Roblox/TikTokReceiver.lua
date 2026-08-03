local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TikTokSpawn = ReplicatedStorage:WaitForChild("TikTokSpawn")

local URL = "http://localhost:5000/queue"

while true do

	local success, response = pcall(function()
		return HttpService:GetAsync(URL)
	end)

	if success then

		if response ~= "null" then

			local data = HttpService:JSONDecode(response)

			if data then

				print("===================================")
				print("DATA DARI PYTHON")
				print(data.name)
				print(data.aura)
				print(data.gift)
				print(data.scale)
				print(data.cinematic)
				print("===================================")

				-- Kirim SEMUA data ke SpawnNPC
				TikTokSpawn:Fire(data)

			end

		end

	else

		warn("Gagal konek server:", response)

	end

	task.wait(1)

end
