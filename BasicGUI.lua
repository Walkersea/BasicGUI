-- Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Create Main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MultiToolGui"
screenGui.Parent = CoreGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 400)
mainFrame.Position = UDim2.new(0, 10, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleLabel.Text = "Multi-Tool GUI"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Parent = mainFrame

-- Username Input
local usernameBox = Instance.new("TextBox")
usernameBox.Size = UDim2.new(1, -10, 0, 30)
usernameBox.Position = UDim2.new(0, 5, 0, 50)
usernameBox.PlaceholderText = "Enter Username"
usernameBox.Text = ""
usernameBox.Parent = mainFrame

-- PlaceId Input
local placeIdBox = Instance.new("TextBox")
placeIdBox.Size = UDim2.new(1, -10, 0, 30)
placeIdBox.Position = UDim2.new(0, 5, 0, 90)
placeIdBox.PlaceholderText = "Enter PlaceId"
placeIdBox.Text = ""
placeIdBox.Parent = mainFrame

-- Function to create buttons
local function createButton(name, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 35)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Text = name
    button.Parent = mainFrame
    button.MouseButton1Click:Connect(callback)
end

-- BTools Button
createButton("BTools", UDim2.new(0, 5, 0, 130), function()
    for i = 1, 4 do
        local tool = Instance.new("HopperBin")
        tool.BinType = i
        tool.Name = "BTool_"..i
        tool.Parent = Players.LocalPlayer.Backpack
    end
end)

-- Join Player Button
createButton("Join Player", UDim2.new(0, 5, 0, 170), function()
    local username = usernameBox.Text
    local placeId = tonumber(placeIdBox.Text) or game.PlaceId
    if username == "" then
        print("Please enter a username")
        return
    end
    local success, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)
    if success and userId then
        local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
        local response = HttpService:JSONDecode(game:HttpGet(url))
        for _, server in pairs(response.data) do
            if table.find(server.playerIds, userId) then
                TeleportService:TeleportToPlaceInstance(placeId, server.id, Players.LocalPlayer)
                return
            end
        end
        print("Player not found in any server.")
    else
        print("Invalid Username.")
    end
end)

-- Updated Fly Button (Mobile-Friendly)
createButton("Enable Fly", UDim2.new(0, 5, 0, 210), function()
    local torso = Players.LocalPlayer.Character.HumanoidRootPart
    local flying = false
    local speed = 50
    local maxSpeed = 1000

    local function Fly()
        local bg = Instance.new("BodyGyro", torso)
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = torso.CFrame

        local bv = Instance.new("BodyVelocity", torso)
        bv.Velocity = Vector3.new(0, 0.1, 0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        RunService.Heartbeat:Connect(function()
            if flying then
                bv.Velocity = torso.CFrame.lookVector * speed
            else
                bg:Destroy()
                bv:Destroy()
            end
        end)
    end

    local mouse = Players.LocalPlayer:GetMouse()
    mouse.KeyDown:Connect(function(key)
        if key == "e" then
            flying = not flying
            if flying then Fly() end
        elseif key == "=" and speed < maxSpeed then
            speed = speed + 10
        elseif key == "-" and speed > 10 then
            speed = speed - 10
        end
    end)
end)

-- Boost Graphics Button
createButton("Boost Graphics", UDim2.new(0, 5, 0, 250), function()
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
