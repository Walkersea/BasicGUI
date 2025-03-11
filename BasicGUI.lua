-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local playerGui = player:WaitForChild("PlayerGui")

-- Main GUI Creation
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "MainControlGui"
mainGui.Parent = playerGui

-- Function to Create Buttons
local function createButton(name, position, text)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(0, 120, 0, 50)
	button.Position = position
	button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Text = text
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 18
	button.BorderSizePixel = 0
	button.Parent = mainGui
	return button
end

-- === Noclip Cam Button ===
local noclipButton = createButton("NoclipCamButton", UDim2.new(0.05, 0, 0.85, 0), "Noclip Cam")
noclipButton.MouseButton1Click:Connect(function()
	local sc = debug and debug.setconstant
	local gc = debug and debug.getconstants
	if sc and gc then
		local pop = player.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
		for _, v in pairs(getgc()) do
			if type(v) == 'function' and getfenv(v).script == pop then
				for i, v1 in pairs(gc(v)) do
					if tonumber(v1) == 0.25 then
						sc(v, i, 0)
					elseif tonumber(v1) == 0 then
						sc(v, i, 0.25)
					end
				end
			end
		end
	end
end)

-- === Fly Button ===
local flyButton = createButton("FlyButton", UDim2.new(0.2, 0, 0.85, 0), "Fly")
flyButton.MouseButton1Click:Connect(function()
	local FLYING = true
	local SPEED = 50
	local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	local BG = Instance.new('BodyGyro', rootPart)
	local BV = Instance.new('BodyVelocity', rootPart)
	BG.P = 9e4
	BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	BV.maxForce = Vector3.new(9e9, 9e9, 9e9)

	local humanoid = player.Character:FindFirstChildOfClass('Humanoid')
	if humanoid then humanoid.PlatformStand = true end

	task.spawn(function()
		while FLYING do
			wait()
			BV.velocity = workspace.CurrentCamera.CFrame.LookVector * SPEED
			BG.CFrame = workspace.CurrentCamera.CFrame
		end
		BG:Destroy()
		BV:Destroy()
		if humanoid then humanoid.PlatformStand = false end
	end)
end)

-- === BTools Button ===
local btoolsButton = createButton("BToolsButton", UDim2.new(0.35, 0, 0.85, 0), "BTools")
btoolsButton.MouseButton1Click:Connect(function()
	for i = 1, 4 do
		local tool = Instance.new("HopperBin")
		tool.BinType = i
		tool.Name = "BTool_" .. i
		tool.Parent = backpack
	end
end)

-- === Join Player Button ===
local joinButton = createButton("JoinPlayerButton", UDim2.new(0.5, 0, 0.85, 0), "Join Player")
joinButton.MouseButton1Click:Connect(function()
	local user = "USERNAME" -- Replace with the desired username
	local place = game.PlaceId
	if not user or user == "" then return end

	local success, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(user)
	end)
	if success then
		local url = "https://games.roblox.com/v1/games/"..place.."/servers/Public?sortOrder=Asc&limit=100"
		local data = HttpService:JSONDecode(game:HttpGet(url))
		for _, server in pairs(data.data) do
			if table.find(server.playerIds, userId) then
				TeleportService:TeleportToPlaceInstance(place, server.id, player)
				return
			end
		end
	end
end)

-- === Custom Tool Button ===
local customToolButton = createButton("CustomToolButton", UDim2.new(0.65, 0, 0.85, 0), "Add Tool")
customToolButton.MouseButton1Click:Connect(function()
	local tool = Instance.new("Tool")
	tool.Name = "CustomTool"
	tool.Parent = backpack

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(1, 1, 1)
	handle.Parent = tool
	tool.RequiresHandle = true

	local texture = Instance.new("Decal")
	texture.Texture = "rbxassetid://16019795773"
	texture.Face = Enum.NormalId.Top
	texture.Parent = handle
end)

-- === Boost Graphics Button ===
local boostButton = createButton("BoostGraphicsButton", UDim2.new(0.8, 0, 0.85, 0), "Boost Graphics")
boostButton.MouseButton1Click:Connect(function()
	local Terrain = workspace:FindFirstChildOfClass('Terrain')
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 0
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 9e9
	settings().Rendering.QualityLevel = 1

	for _, v in pairs(game:GetDescendants()) do
		if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
			v.Material = "Plastic"
			v.Reflectance = 0
		elseif v:IsA("Decal") then
			v.Transparency = 1
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Lifetime = NumberRange.new(0)
		elseif v:IsA("Explosion") then
			v.BlastPressure = 1
			v.BlastRadius = 1
		end
	end

	workspace.DescendantAdded:Connect(function(child)
		task.spawn(function()
			if child:IsA('ForceField') or child:IsA('Smoke') or child:IsA('Fire') or child:IsA('Sparkles') then
				RunService.Heartbeat:Wait()
				child:Destroy()
			end
		end)
	end)
end)
