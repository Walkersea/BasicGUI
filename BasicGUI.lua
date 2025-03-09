local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local rootPart = character:FindFirstChild("HumanoidRootPart")

local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Default Speed Values
local walkSpeed = 16
local flySpeed = 50

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local function createButton(name, position, action)
    local button = Instance.new("TextButton")
    button.Parent = screenGui
    button.Size = UDim2.new(0.2, 0, 0.1, 0) -- 1:10 ratio (Width:Height)
    button.Position = position
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0

    -- Rounded Corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15) -- Adjust for more/less roundness
    corner.Parent = button

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    button.MouseButton1Click:Connect(function() action(button) end)

    return button
end

-- NOCLIP (Mobile Button)
local noclipEnabled = false
local noclipButton = createButton("NOCLIP (Off)", UDim2.new(0.05, 0, 0.05, 0), function(button)
    noclipEnabled = not noclipEnabled
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not noclipEnabled
        end
    end
    button.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    button.Text = noclipEnabled and "NOCLIP (On)" or "NOCLIP (Off)"
end)

-- TELEPORT BUTTON
createButton("Teleport", UDim2.new(0.05, 0, 0.15, 0), function()
    local mouse = player:GetMouse()
    if mouse.Target then
        rootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0))
    end
end)

-- WALK SPEED SLIDER
local function createSlider(position, defaultText, callback)
    local textBox = Instance.new("TextBox")
    textBox.Parent = screenGui
    textBox.Size = UDim2.new(0.2, 0, 0.1, 0) -- Responsive scaling
    textBox.Position = position
    textBox.Text = defaultText
    textBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Rounded Corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = textBox

    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local number = tonumber(textBox.Text)
            if number and number > 0 then
                callback(number)
            else
                textBox.Text = defaultText
            end
        end
    end)
    return textBox
end

createSlider(UDim2.new(0.05, 0, 0.25, 0), tostring(walkSpeed), function(newSpeed)
    walkSpeed = newSpeed
    humanoid.WalkSpeed = newSpeed
end)

-- FLY MODE (Button)
local flying = false
local bodyVelocity, bodyGyro, flightLoop

createButton("Fly", UDim2.new(0.05, 0, 0.35, 0), function(button)
    flying = not flying

    if flying then
        bodyVelocity = Instance.new("BodyVelocity", rootPart)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

        bodyGyro = Instance.new("BodyGyro", rootPart)
        bodyGyro.CFrame = rootPart.CFrame
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)

        flightLoop = runService.RenderStepped:Connect(function()
            local moveDirection = humanoid.MoveDirection
            bodyVelocity.Velocity = moveDirection * flySpeed
            bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + moveDirection)
        end)
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        button.Text = "Fly (On)"
    else
        if flightLoop then flightLoop:Disconnect() end
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        button.Text = "Fly (Off)"
    end
end)

-- DOUBLE JUMP BUTTON
createButton("Double Jump", UDim2.new(0.05, 0, 0.45, 0), function()
    if humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- FLY SPEED SLIDER
createSlider(UDim2.new(0.05, 0, 0.55, 0), tostring(flySpeed), function(newSpeed)
    flySpeed = newSpeed
end)

-- Ensure script ends properly
print("Script loaded successfully!")

