-- =============================================
--       Byte_EXPLOITS v2 - Enhanced GUI
-- =============================================

-- Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- =============================================
-- THEME CONSTANTS
-- =============================================
local THEME = {
    BG          = Color3.fromRGB(15, 15, 20),
    PANEL       = Color3.fromRGB(22, 22, 30),
    CARD        = Color3.fromRGB(30, 30, 42),
    ACCENT      = Color3.fromRGB(100, 80, 255),
    ACCENT_DIM  = Color3.fromRGB(60, 45, 160),
    SUCCESS     = Color3.fromRGB(60, 210, 120),
    DANGER      = Color3.fromRGB(220, 70, 70),
    TEXT        = Color3.fromRGB(230, 230, 240),
    SUBTEXT     = Color3.fromRGB(140, 140, 160),
    BORDER      = Color3.fromRGB(50, 50, 70),
    TOGGLE_ON   = Color3.fromRGB(80, 200, 120),
    TOGGLE_OFF  = Color3.fromRGB(60, 60, 80),
}

-- =============================================
-- UTILITY FUNCTIONS
-- =============================================
local function tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad), props):Play()
end

local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
end

local function addPadding(parent, px, py)
    local p = Instance.new("UIPadding")
    p.PaddingLeft  = UDim.new(0, px or 8)
    p.PaddingRight = UDim.new(0, px or 8)
    p.PaddingTop   = UDim.new(0, py or 6)
    p.PaddingBottom = UDim.new(0, py or 6)
    p.Parent = parent
end

local function addListLayout(parent, spacing, dir)
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, spacing or 6)
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = parent
    return l
end

local function addStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or THEME.BORDER
    s.Thickness = thickness or 1
    s.Parent = parent
end

-- =============================================
-- DESTROY OLD GUI
-- =============================================
if CoreGui:FindFirstChild("Byte_EXPLOITS") then
    CoreGui:FindFirstChild("Byte_EXPLOITS"):Destroy()
end

-- =============================================
-- ROOT GUI
-- =============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Byte_EXPLOITS"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

-- =============================================
-- MAIN WINDOW
-- =============================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 480)
mainFrame.Position = UDim2.new(0, 20, 0.5, -240)
mainFrame.BackgroundColor3 = THEME.BG
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true
addCorner(mainFrame, 12)
addStroke(mainFrame, THEME.BORDER, 1)

-- Glow shadow effect
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0, -20, 0, -20)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5028857084"
shadow.ImageColor3 = THEME.ACCENT
shadow.ImageTransparency = 0.85
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(24, 24, 276, 276)
shadow.ZIndex = 0
shadow.Parent = mainFrame

-- =============================================
-- TITLE BAR
-- =============================================
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 48)
titleBar.BackgroundColor3 = THEME.PANEL
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
addCorner(titleBar, 12)

-- Square off bottom corners
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0.5, 0)
titleFix.Position = UDim2.new(0, 0, 0.5, 0)
titleFix.BackgroundColor3 = THEME.PANEL
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

-- Accent strip
local accentBar = Instance.new("Frame")
accentBar.Size = UDim2.new(0, 4, 0.6, 0)
accentBar.Position = UDim2.new(0, 12, 0.2, 0)
accentBar.BackgroundColor3 = THEME.ACCENT
accentBar.BorderSizePixel = 0
accentBar.Parent = titleBar
addCorner(accentBar, 4)

-- Title text
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 24, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "BYTE EXPLOITS"
titleLabel.TextColor3 = THEME.TEXT
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Version badge
local versionBadge = Instance.new("TextLabel")
versionBadge.Size = UDim2.new(0, 28, 0, 16)
versionBadge.Position = UDim2.new(0, 130, 0.5, -8)
versionBadge.BackgroundColor3 = THEME.ACCENT_DIM
versionBadge.Text = "v2"
versionBadge.TextColor3 = THEME.TEXT
versionBadge.TextSize = 10
versionBadge.Font = Enum.Font.GothamBold
versionBadge.Parent = titleBar
addCorner(versionBadge, 4)

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -40, 0.5, -14)
minBtn.BackgroundColor3 = THEME.CARD
minBtn.Text = "—"
minBtn.TextColor3 = THEME.SUBTEXT
minBtn.TextSize = 12
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = titleBar
addCorner(minBtn, 6)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -72, 0.5, -14)
closeBtn.BackgroundColor3 = THEME.DANGER
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
addCorner(closeBtn, 6)

-- =============================================
-- CONTENT AREA
-- =============================================
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, 0, 1, -48)
contentArea.Position = UDim2.new(0, 0, 0, 48)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

-- =============================================
-- TAB BAR
-- =============================================
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -16, 0, 34)
tabBar.Position = UDim2.new(0, 8, 0, 8)
tabBar.BackgroundColor3 = THEME.PANEL
tabBar.BorderSizePixel = 0
tabBar.Parent = contentArea
addCorner(tabBar, 8)

local tabLayout = addListLayout(tabBar, 4, Enum.FillDirection.Horizontal)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
addPadding(tabBar, 4, 4)

-- Scroll frame for tab content
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -16, 1, -54)
scrollFrame.Position = UDim2.new(0, 8, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = THEME.ACCENT
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = contentArea
addListLayout(scrollFrame, 6)
addPadding(scrollFrame, 0, 4)

-- =============================================
-- TAB SYSTEM
-- =============================================
local tabs = {}
local tabPages = {}
local activeTab = nil

local function createTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 70, 1, -6)
    tabBtn.BackgroundColor3 = THEME.CARD
    tabBtn.Text = (icon or "") .. " " .. name
    tabBtn.TextColor3 = THEME.SUBTEXT
    tabBtn.TextSize = 11
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.Parent = tabBar
    addCorner(tabBtn, 6)

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 0, 0)
    page.AutomaticSize = Enum.AutomaticSize.Y
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = scrollFrame
    addListLayout(page, 6)

    tabs[name] = {btn = tabBtn, page = page}
    tabPages[name] = page

    tabBtn.MouseButton1Click:Connect(function()
        for n, t in pairs(tabs) do
            t.page.Visible = false
            tween(t.btn, {BackgroundColor3 = THEME.CARD, TextColor3 = THEME.SUBTEXT})
        end
        page.Visible = true
        tween(tabBtn, {BackgroundColor3 = THEME.ACCENT, TextColor3 = Color3.fromRGB(255, 255, 255)})
        activeTab = name
    end)

    return page
end

-- =============================================
-- UI COMPONENTS
-- =============================================

-- Section header
local function sectionHeader(parent, text)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 24)
    f.BackgroundTransparency = 1
    f.LayoutOrder = 0
    f.Parent = parent

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = THEME.BORDER
    line.BorderSizePixel = 0
    line.Parent = f

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 0, 1, 0)
    label.AutomaticSize = Enum.AutomaticSize.X
    label.Position = UDim2.new(0.5, 0, 0, 0)
    label.AnchorPoint = Vector2.new(0.5, 0)
    label.BackgroundColor3 = THEME.BG
    label.Text = "  " .. text .. "  "
    label.TextColor3 = THEME.SUBTEXT
    label.TextSize = 10
    label.Font = Enum.Font.GothamBold
    label.Parent = f
    return f
end

-- Input box
local function createInput(parent, placeholder, order)
    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, 0, 0, 34)
    wrapper.BackgroundColor3 = THEME.CARD
    wrapper.BorderSizePixel = 0
    wrapper.LayoutOrder = order or 0
    wrapper.Parent = parent
    addCorner(wrapper, 8)
    addStroke(wrapper, THEME.BORDER)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -12, 1, 0)
    box.Position = UDim2.new(0, 6, 0, 0)
    box.BackgroundTransparency = 1
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = THEME.SUBTEXT
    box.Text = ""
    box.TextColor3 = THEME.TEXT
    box.TextSize = 12
    box.Font = Enum.Font.Gotham
    box.ClearTextOnFocus = false
    box.Parent = wrapper

    box.Focused:Connect(function()
        tween(wrapper, {BackgroundColor3 = Color3.fromRGB(38, 38, 55)})
        addStroke(wrapper, THEME.ACCENT)
    end)
    box.FocusLost:Connect(function()
        tween(wrapper, {BackgroundColor3 = THEME.CARD})
        addStroke(wrapper, THEME.BORDER)
    end)

    return box, wrapper
end

-- Action button (full-width)
local function createButton(parent, text, color, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = color or THEME.ACCENT
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order or 0
    btn.Parent = parent
    addCorner(btn, 8)

    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundColor3 = Color3.fromRGB(
            math.min(255, color and color.R*255+20 or 120),
            math.min(255, color and color.G*255+20 or 100),
            math.min(255, color and color.B*255+20 or 275)
        )})
    end)
    btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = color or THEME.ACCENT}) end)
    btn.MouseButton1Click:Connect(function()
        tween(btn, {BackgroundColor3 = THEME.ACCENT_DIM})
        task.delay(0.15, function() tween(btn, {BackgroundColor3 = color or THEME.ACCENT}) end)
        if callback then callback() end
    end)
    return btn
end

-- Toggle button
local function createToggle(parent, text, order, callback)
    local isOn = false

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundColor3 = THEME.CARD
    row.BorderSizePixel = 0
    row.LayoutOrder = order or 0
    row.Parent = parent
    addCorner(row, 8)
    addStroke(row, THEME.BORDER)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = THEME.TEXT
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local toggleTrack = Instance.new("Frame")
    toggleTrack.Size = UDim2.new(0, 38, 0, 20)
    toggleTrack.Position = UDim2.new(1, -50, 0.5, -10)
    toggleTrack.BackgroundColor3 = THEME.TOGGLE_OFF
    toggleTrack.BorderSizePixel = 0
    toggleTrack.Parent = row
    addCorner(toggleTrack, 10)

    local toggleThumb = Instance.new("Frame")
    toggleThumb.Size = UDim2.new(0, 14, 0, 14)
    toggleThumb.Position = UDim2.new(0, 3, 0.5, -7)
    toggleThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleThumb.BorderSizePixel = 0
    toggleThumb.Parent = toggleTrack
    addCorner(toggleThumb, 7)

    local function setState(state)
        isOn = state
        tween(toggleTrack, {BackgroundColor3 = isOn and THEME.TOGGLE_ON or THEME.TOGGLE_OFF})
        tween(toggleThumb, {Position = isOn and UDim2.new(0, 21, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)})
        tween(row, {BackgroundColor3 = isOn and Color3.fromRGB(35, 45, 38) or THEME.CARD})
        if callback then callback(isOn) end
    end

    toggleTrack.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            setState(not isOn)
        end
    end)
    row.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            setState(not isOn)
        end
    end)

    return row, function(v) setState(v) end
end

-- Status label
local function createStatus(parent, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = ""
    lbl.TextColor3 = THEME.SUBTEXT
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.LayoutOrder = order or 99
    lbl.Parent = parent
    return lbl
end

-- =============================================
-- CREATE TABS
-- =============================================
local playerPage  = createTab("Player",  "⚡")
local worldPage   = createTab("World",   "🌍")
local toolsPage   = createTab("Tools",   "🛠")
local networkPage = createTab("Network", "🌐")

-- =============================================
-- TAB: PLAYER
-- =============================================
do
    local p = playerPage

    sectionHeader(p, "MOVEMENT")

    -- Fly Toggle
    local flyActive = false
    local flyBG, flyBV

    local function stopFly()
        flyActive = false
        if flyBG then flyBG:Destroy() flyBG = nil end
        if flyBV then flyBV:Destroy() flyBV = nil end
    end

    local function startFly(speed)
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        stopFly()
        flyActive = true

        flyBG = Instance.new("BodyGyro", root)
        flyBG.P = 9e4
        flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBG.CFrame = root.CFrame

        flyBV = Instance.new("BodyVelocity", root)
        flyBV.Velocity = Vector3.zero
        flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        RunService.Heartbeat:Connect(function()
            if not flyActive or not flyBG or not flyBV then return end
            local cam = workspace.CurrentCamera
            local move = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
            flyBV.Velocity = move.Magnitude > 0 and move.Unit * speed or Vector3.zero
            flyBG.CFrame = cam.CFrame
        end)
    end

    local flySpeed = 50
    createToggle(p, "Fly  (WASD + Space/Shift)", 1, function(on)
        if on then startFly(flySpeed) else stopFly() end
    end)

    -- Speed Slider row
    local speedRow = Instance.new("Frame")
    speedRow.Size = UDim2.new(1, 0, 0, 36)
    speedRow.BackgroundColor3 = THEME.CARD
    speedRow.LayoutOrder = 2
    speedRow.Parent = p
    addCorner(speedRow, 8)
    addStroke(speedRow, THEME.BORDER)

    local speedLbl = Instance.new("TextLabel")
    speedLbl.Size = UDim2.new(0.6, 0, 1, 0)
    speedLbl.Position = UDim2.new(0, 12, 0, 0)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "Fly Speed: 50"
    speedLbl.TextColor3 = THEME.TEXT
    speedLbl.TextSize = 12
    speedLbl.Font = Enum.Font.Gotham
    speedLbl.TextXAlignment = Enum.TextXAlignment.Left
    speedLbl.Parent = speedRow

    local speedMinus = Instance.new("TextButton")
    speedMinus.Size = UDim2.new(0, 26, 0, 22)
    speedMinus.Position = UDim2.new(1, -64, 0.5, -11)
    speedMinus.BackgroundColor3 = THEME.ACCENT_DIM
    speedMinus.Text = "−"
    speedMinus.TextColor3 = Color3.fromRGB(255,255,255)
    speedMinus.TextSize = 14
    speedMinus.Font = Enum.Font.GothamBold
    speedMinus.Parent = speedRow
    addCorner(speedMinus, 6)

    local speedPlus = Instance.new("TextButton")
    speedPlus.Size = UDim2.new(0, 26, 0, 22)
    speedPlus.Position = UDim2.new(1, -34, 0.5, -11)
    speedPlus.BackgroundColor3 = THEME.ACCENT
    speedPlus.Text = "+"
    speedPlus.TextColor3 = Color3.fromRGB(255,255,255)
    speedPlus.TextSize = 14
    speedPlus.Font = Enum.Font.GothamBold
    speedPlus.Parent = speedRow
    addCorner(speedPlus, 6)

    speedMinus.MouseButton1Click:Connect(function()
        flySpeed = math.max(10, flySpeed - 10)
        speedLbl.Text = "Fly Speed: " .. flySpeed
    end)
    speedPlus.MouseButton1Click:Connect(function()
        flySpeed = math.min(500, flySpeed + 10)
        speedLbl.Text = "Fly Speed: " .. flySpeed
    end)

    sectionHeader(p, "ABILITIES")

    -- Infinite Jump
    local jumpConn
    createToggle(p, "Infinite Jump", 10, function(on)
        if jumpConn then jumpConn:Disconnect() jumpConn = nil end
        if on then
            jumpConn = UserInputService.JumpRequest:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                end
            end)
        end
    end)

    -- Noclip
    local noclipConn
    createToggle(p, "Noclip", 11, function(on)
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        if on then
            noclipConn = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if not char then return end
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end)
        else
            local char = LocalPlayer.Character
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = true end
                end
            end
        end
    end)

    -- Anti-AFK
    local afkConn
    createToggle(p, "Anti-AFK", 12, function(on)
        if afkConn then afkConn:Disconnect() afkConn = nil end
        if on then
            afkConn = LocalPlayer.Idled:Connect(function()
                -- Wiggle to reset AFK timer
                local vr = LocalPlayer:FindFirstChild("VirtualUser")
                if not vr then
                    vr = Instance.new("VirtualUser")
                    vr.Parent = LocalPlayer
                end
                vr:CaptureController()
                vr:ClickButton2(Vector2.new())
            end)
        end
    end)

    -- Speed Boost (WalkSpeed)
    sectionHeader(p, "WALKSPEED")
    local wsRow = Instance.new("Frame")
    wsRow.Size = UDim2.new(1, 0, 0, 36)
    wsRow.BackgroundColor3 = THEME.CARD
    wsRow.LayoutOrder = 20
    wsRow.Parent = p
    addCorner(wsRow, 8)
    addStroke(wsRow, THEME.BORDER)

    local wsLabel = Instance.new("TextLabel")
    wsLabel.Size = UDim2.new(0.6, 0, 1, 0)
    wsLabel.Position = UDim2.new(0, 12, 0, 0)
    wsLabel.BackgroundTransparency = 1
    wsLabel.Text = "WalkSpeed: 16"
    wsLabel.TextColor3 = THEME.TEXT
    wsLabel.TextSize = 12
    wsLabel.Font = Enum.Font.Gotham
    wsLabel.TextXAlignment = Enum.TextXAlignment.Left
    wsLabel.Parent = wsRow

    local wsMinus = Instance.new("TextButton")
    wsMinus.Size = UDim2.new(0, 26, 0, 22)
    wsMinus.Position = UDim2.new(1, -64, 0.5, -11)
    wsMinus.BackgroundColor3 = THEME.DANGER
    wsMinus.Text = "−"
    wsMinus.TextColor3 = Color3.fromRGB(255,255,255)
    wsMinus.TextSize = 14
    wsMinus.Font = Enum.Font.GothamBold
    wsMinus.Parent = wsRow
    addCorner(wsMinus, 6)

    local wsPlus = Instance.new("TextButton")
    wsPlus.Size = UDim2.new(0, 26, 0, 22)
    wsPlus.Position = UDim2.new(1, -34, 0.5, -11)
    wsPlus.BackgroundColor3 = THEME.SUCCESS
    wsPlus.Text = "+"
    wsPlus.TextColor3 = Color3.fromRGB(255,255,255)
    wsPlus.TextSize = 14
    wsPlus.Font = Enum.Font.GothamBold
    wsPlus.Parent = wsRow
    addCorner(wsPlus, 6)

    local wsReset = Instance.new("TextButton")
    wsReset.Size = UDim2.new(0, 0, 0, 22)
    wsReset.AutomaticSize = Enum.AutomaticSize.X
    wsReset.Position = UDim2.new(1, -36, 0.5, -11)
    wsReset.BackgroundTransparency = 1
    wsReset.Text = ""
    wsReset.Parent = wsRow

    local curWS = 16
    local function applyWS()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = curWS end
        end
        wsLabel.Text = "WalkSpeed: " .. curWS
    end
    wsMinus.MouseButton1Click:Connect(function() curWS = math.max(0, curWS-4); applyWS() end)
    wsPlus.MouseButton1Click:Connect(function() curWS = math.min(500, curWS+8); applyWS() end)

    -- Reset WS button
    createButton(p, "Reset WalkSpeed (16)", THEME.CARD, 21, function()
        curWS = 16; applyWS()
    end)
end

-- =============================================
-- TAB: WORLD
-- =============================================
do
    local p = worldPage
    sectionHeader(p, "GRAPHICS")

    createButton(p, "⚡ Boost FPS (Low Graphics)", THEME.ACCENT, 1, function()
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 0
        end
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        settings().Rendering.QualityLevel = 1
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
                v.Material = Enum.Material.Plastic
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

    createButton(p, "🌙 Toggle Fullbright", THEME.CARD, 2, function()
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 10
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") then
                v.Enabled = false
            end
        end
    end)

    sectionHeader(p, "TIME OF DAY")

    local timeOptions = {{"🌅 Dawn", 6}, {"☀️ Noon", 12}, {"🌇 Sunset", 18}, {"🌙 Night", 0}}
    for i, opt in ipairs(timeOptions) do
        createButton(p, opt[1], THEME.CARD, 10+i, function()
            Lighting.TimeOfDay = opt[2] .. ":00:00"
        end)
    end

    sectionHeader(p, "FOG")
    createButton(p, "Remove Fog", THEME.CARD, 20, function()
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
    end)
    createButton(p, "Dense Fog", THEME.CARD, 21, function()
        Lighting.FogEnd = 50
        Lighting.FogStart = 0
        Lighting.FogColor = Color3.fromRGB(200, 200, 200)
    end)
end

-- =============================================
-- TAB: TOOLS
-- =============================================
do
    local p = toolsPage

    sectionHeader(p, "GIVE TOOLS")

    createButton(p, "🗡 Give Sword Tool", THEME.ACCENT, 1, function()
        local tool = Instance.new("Tool")
        tool.Name = "SwordTool"
        tool.Parent = LocalPlayer.Backpack

        local handle = Instance.new("Part")
        handle.Size = Vector3.new(1, 4, 1)
        handle.Name = "Handle"
        handle.Parent = tool

        local mesh = Instance.new("SpecialMesh", handle)
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.TextureId = "rbxassetid://117186212806363"
    end)

    createButton(p, "🔨 Give BTools (All 4)", THEME.CARD, 2, function()
        for i = 1, 4 do
            local tool = Instance.new("HopperBin")
            tool.BinType = i
            tool.Name = "BTool_" .. i
            tool.Parent = LocalPlayer.Backpack
        end
    end)

    createButton(p, "🧲 Give Grab Tool", THEME.CARD, 3, function()
        local tool = Instance.new("HopperBin")
        tool.BinType = Enum.BinType.GameTool
        tool.Name = "GrabTool"
        tool.Parent = LocalPlayer.Backpack
    end)

    sectionHeader(p, "CHARACTER")

    createButton(p, "♻️ Respawn Character", THEME.DANGER, 10, function()
        LocalPlayer:LoadCharacter()
    end)

    createButton(p, "🎯 Teleport to Spawn", THEME.CARD, 11, function()
        local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
        local char = LocalPlayer.Character
        if spawn and char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
        else
            warn("No spawn or character found.")
        end
    end)

    createButton(p, "📍 Teleport to 0,0,0", THEME.CARD, 12, function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        end
    end)
end

-- =============================================
-- TAB: NETWORK
-- =============================================
do
    local p = networkPage

    sectionHeader(p, "SERVER FINDER")

    local userInput, _  = createInput(p, "🔍 Enter Username", 1)
    local placeInput, _ = createInput(p, "🎮 PlaceId (blank = current)", 2)

    local statusLbl = createStatus(p, 4)

    createButton(p, "🚀 Join Player Server", THEME.ACCENT, 3, function()
        local username = userInput.Text
        local placeId = tonumber(placeInput.Text) or game.PlaceId

        if username == "" then
            statusLbl.Text = "⚠ Please enter a username."
            statusLbl.TextColor3 = THEME.DANGER
            return
        end

        statusLbl.Text = "⏳ Looking up player..."
        statusLbl.TextColor3 = THEME.SUBTEXT

        local ok, userId = pcall(function()
            return Players:GetUserIdFromNameAsync(username)
        end)

        if not ok or not userId then
            statusLbl.Text = "✗ Invalid username."
            statusLbl.TextColor3 = THEME.DANGER
            return
        end

        local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
        local ok2, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)

        if not ok2 or not response or not response.data then
            statusLbl.Text = "✗ Failed to fetch servers."
            statusLbl.TextColor3 = THEME.DANGER
            return
        end

        for _, server in pairs(response.data) do
            if table.find(server.playerIds, userId) then
                statusLbl.Text = "✓ Found! Teleporting..."
                statusLbl.TextColor3 = THEME.SUCCESS
                TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                return
            end
        end

        statusLbl.Text = "✗ Player not found in any server."
        statusLbl.TextColor3 = THEME.DANGER
    end)

    sectionHeader(p, "INFO")

    local infoLbl = Instance.new("TextLabel")
    infoLbl.Size = UDim2.new(1, 0, 0, 0)
    infoLbl.AutomaticSize = Enum.AutomaticSize.Y
    infoLbl.BackgroundColor3 = THEME.CARD
    infoLbl.TextColor3 = THEME.SUBTEXT
    infoLbl.TextSize = 11
    infoLbl.Font = Enum.Font.Gotham
    infoLbl.TextWrapped = true
    infoLbl.Text = "Place ID: " .. game.PlaceId .. "\nJob ID: " .. game.JobId:sub(1,12) .. "...\nPlayers: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
    infoLbl.LayoutOrder = 10
    infoLbl.Parent = p
    addCorner(infoLbl, 8)
    addPadding(infoLbl, 10, 8)
end

-- =============================================
-- ACTIVATE DEFAULT TAB
-- =============================================
tabs["Player"].btn.MouseButton1Click:Fire()

-- =============================================
-- MINIMIZE / CLOSE
-- =============================================
local minimized = false
local originalSize = mainFrame.Size

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tween(mainFrame, {Size = minimized and UDim2.new(0, 320, 0, 48) or originalSize}, 0.25)
    contentArea.Visible = not minimized
    minBtn.Text = minimized and "▢" or "—"
end)

closeBtn.MouseButton1Click:Connect(function()
    tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
    task.delay(0.25, function() screenGui:Destroy() end)
end)

-- =============================================
-- ENTRANCE ANIMATION
-- =============================================
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0, 20, 0.5, 0)
tween(mainFrame, {Size = originalSize, Position = UDim2.new(0, 20, 0.5, -240)}, 0.35)

print("[Byte_EXPLOITS v2] Loaded successfully!")
