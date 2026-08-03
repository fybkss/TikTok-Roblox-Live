local AuraSystem = {}

local function createParticle(parent, color)

	local attachment = Instance.new("Attachment")
	attachment.Parent = parent

	local particle = Instance.new("ParticleEmitter")
	particle.Parent = attachment

	particle.Texture = "rbxasset://textures/particles/sparkles_main.dds"

	particle.Rate = 40
	particle.Lifetime = NumberRange.new(1,2)
	particle.Speed = NumberRange.new(2,4)

	particle.SpreadAngle = Vector2.new(360,360)

	particle.LightEmission = 1
	particle.Color = ColorSequence.new(color)

	particle.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0,0.5),
		NumberSequenceKeypoint.new(1,0)
	})

	particle.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0,0.2),
		NumberSequenceKeypoint.new(1,1)
	})


	local light = Instance.new("PointLight")
	light.Parent = parent
	light.Range = 15
	light.Brightness = 2
	light.Color = color

end


function AuraSystem.CreateFire(npc)

	local torso = npc:FindFirstChild("UpperTorso") or npc:FindFirstChild("Torso")

	if torso then
		createParticle(torso, Color3.fromRGB(255,80,0))
	end

end


function AuraSystem.CreateThunder(npc)

	local torso = npc:FindFirstChild("UpperTorso") or npc:FindFirstChild("Torso")

	if torso then
		createParticle(torso, Color3.fromRGB(0,170,255))
	end

end


function AuraSystem.CreateShadow(npc)

	local torso = npc:FindFirstChild("UpperTorso") or npc:FindFirstChild("Torso")

	if torso then
		createParticle(torso, Color3.fromRGB(170,0,255))
	end

end


return AuraSystem
