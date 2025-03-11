-- Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Wait for the game and player to load
repeat wait() until game:IsLoaded()
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Remove existing GUI to prevent duplicates
if game.CoreGui:FindFirstChild("MultiToolGUI") then
    game.CoreGui.MultiToolGUI:Destroy()
end

-- Create Main GUI and parent to CoreGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MultiToolGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Main Frame (Compact Design)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 240)
mainFrame.Position = UDim2.new(0, 10, 0.5, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleLabel.Text = "Multi-Tool GUI"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Parent = mainFrame

-- Function to create compact buttons
local function createButton(name, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 25)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Text = name
    button.Parent = mainFrame
    button.MouseButton1Click:Connect(callback)
end

-- BTools Button
createButton("BTools", UDim2.new(0, 5, 0, 35), function()
    for i = 1, 4 do
        local tool = Instance.new("HopperBin")
        tool.BinType = i
        tool.Name = tostring(math.random(1000, 9999))
        tool.Parent = player.Backpack
    end
end)

-- Join Player Button
createButton("Join Player", UDim2.new(0, 5, 0, 65), function()
    local userName = "PlayerNameHere" -- Replace with actual username
    local placeId = game.PlaceId
    local userId
    local success, err = pcall(function()
        userId = Players:GetUserIdFromNameAsync(userName)
    end)
    if success and userId then
        local URL = ("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100")
        local response = HttpService:JSONDecode(game:HttpGet(URL))
        for _, server in pairs(response.data) do
            for _, id in pairs(server.playerIds) do
                if id == userId then
                    TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
                    return
                end
            end
        end
    end
end)

-- Custom Tool Button
createButton("Custom Tool", UDim2.new(0, 5, 0, 95), function()
    local tool = Instance.new("Tool")
    tool.Name = "CustomTool"
    tool.Parent = player.Backpack

    local handle = Instance.new("Part")
    handle.Size = Vector3.new(1, 1, 1)
    handle.Name = "Handle"
    handle.Parent = tool

    local decal = Instance.new("Decal")
    decal.Texture = "rbxassetid://16019795773"
    decal.Face = Enum.NormalId.Front
    decal.Parent = handle
end)

-- Boost Graphics Button
createButton("Boost Graphics", UDim2.new(0, 5, 0, 125), function()
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
end)

-- Fly Button
createButton("Enable Fly", UDim2.new(0, 5, 0, 155), function()
    local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
    local flying = true
    local speed = 50

    local bodyGyro = Instance.new("BodyGyro", humanoidRootPart)
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = humanoidRootPart.CFrame

    local bodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    RunService.Heartbeat:Connect(function()
        if flying then
            bodyVelocity.Velocity = humanoidRootPart.CFrame.lookVector * speed
        else
            bodyGyro:Destroy()
            bodyVelocity:Destroy()
        end
    end)
end)

-- Noclip Camera Button
createButton("Noclip Cam", UDim2.new(0, 5, 0, 185), function()
    local pop = player.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
    for _, func in pairs(getgc()) do
        if type(func) == "function" and getfenv(func).script == pop then
            for i, const in pairs(debug.getconstants(func)) do
                if const == .25 then
                    debug.setconstant(func, i, 0)
                elseif const == 0 then
                    debug.setconstant(func, i, .25)
                end
            end
        end
    end
end)
