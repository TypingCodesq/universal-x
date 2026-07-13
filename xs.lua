local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

_G.RheyzHub = {
    Survivor = {
        AutoSkillCheck = false,
        AutoGenerator = false,
        AutoParry = false,
        AutoHeal = false,
        DropAllPallets = false,
        UnlockPallets = false,
        NoSlowdown = false,
        FastVault = false,
        BypassExit = false,
        SelfHeal = false,
        AntiKnockdown = false,
        AutoWiggle = false
    },
    Killer = {
        NoCooldown = false,
        InstantHit = false,
        NoStun = false,
        SpeedMulti = 2.0,
        WallCheckBypass = false,
        IgnoreObstacle = false,
        NoAnimation = false,
        InstantGrab = false,
        NoMiss = false
    },
    Combat = {
        FaceKiller = false,
        Sensitivity = 0.01,
        AimPrediction = false,
        AimStrictness = 2,
        IgnoreKillerSkills = false,
        VeilMaskedStalker = false
    },
    Aimbot = {
        Enabled = false,
        LockSurvivor = false,
        LockKiller = false,
        SilentAim = false,
        FOV = 250,
        ShowFOV = false,
        Smoothness = 8
    },
    ESP = {
        Enabled = true,
        Players = true,
        Killer = true,
        Generator = true,
        Exit = true,
        Pallet = true,
        ShowDistance = true,
        ShowHealth = true,
        ShowProgress = true
    },
    Visual = {
        FullBright = false,
        NoFog = false,
        NoShadow = false,
        NoBlur = false,
        NoVignette = false
    },
    Misc = {
        WalkSpeed = 18,
        JumpPower = 60,
        NoClip = false,
        Fly = false,
        FlySpeed = 50,
        GodMode = false
    },
    Troll = {
        HeadSit = false,
        SelectedPlayer = nil,
        Spin = false,
        SpamChat = false,
        Fling = false,
        Invisible = false
    }
}

local selectedPlayer = nil
local headSitConn = nil
local espCache = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VDHubPremium"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 780, 0, 620)
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -310)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 55)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
TopBar.Parent = MainFrame
local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 18)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.65, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VIOLENCE DISTRICT"
Title.TextColor3 = Color3.fromRGB(100, 180, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 26
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(0.65, 0, 0.4, 0)
Subtitle.Position = UDim2.new(0.05, 0, 0.55, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "PREMIUM HUB"
Subtitle.TextColor3 = Color3.fromRGB(140, 140, 255)
Subtitle.Font = Enum.Font.GothamBold
Subtitle.TextSize = 14
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Position = UDim2.new(0.02, 0, 0.35, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 120, 255)
ToggleButton.Text = "VD"
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 22
ToggleButton.Parent = ScreenGui
local TBCorner = Instance.new("UICorner")
TBCorner.CornerRadius = UDim.new(0, 14)
TBCorner.Parent = ToggleButton

local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 180, 1, -55)
SideBar.Position = UDim2.new(0, 0, 0, 55)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
SideBar.Parent = MainFrame

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -190, 1, -55)
ContentArea.Position = UDim2.new(0, 180, 0, 55)
ContentArea.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
ContentArea.Parent = MainFrame

local tabs = {}

local function CreateTabButton(name, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 48)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 15
    btn.Parent = SideBar
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 10)
    bc.Parent = btn
    return btn
end

local tab1 = CreateTabButton("Survivor", 20)
local tab2 = CreateTabButton("Killer", 80)
local tab3 = CreateTabButton("Combat", 140)
local tab4 = CreateTabButton("Aimbot", 200)
local tab5 = CreateTabButton("ESP", 260)
local tab6 = CreateTabButton("Visual", 320)
local tab7 = CreateTabButton("Misc", 380)
local tab8 = CreateTabButton("Troll", 440)

local function SwitchToTab(tabContent)
    for _, t in pairs(tabs) do t.Visible = false end
    tabContent.Visible = true
end

local function CreateScrollingContent()
    local sc = Instance.new("ScrollingFrame")
    sc.Size = UDim2.new(1, 0, 1, 0)
    sc.BackgroundTransparency = 1
    sc.ScrollBarThickness = 5
    sc.Parent = ContentArea
    sc.Visible = false
    return sc
end

local survivorTab = CreateScrollingContent()
local killerTab = CreateScrollingContent()
local combatTab = CreateScrollingContent()
local aimbotTab = CreateScrollingContent()
local espTab = CreateScrollingContent()
local visualTab = CreateScrollingContent()
local miscTab = CreateScrollingContent()
local trollTab = CreateScrollingContent()

tabs = {survivorTab, killerTab, combatTab, aimbotTab, espTab, visualTab, miscTab, trollTab}

tab1.MouseButton1Click:Connect(function() SwitchToTab(survivorTab) end)
tab2.MouseButton1Click:Connect(function() SwitchToTab(killerTab) end)
tab3.MouseButton1Click:Connect(function() SwitchToTab(combatTab) end)
tab4.MouseButton1Click:Connect(function() SwitchToTab(aimbotTab) end)
tab5.MouseButton1Click:Connect(function() SwitchToTab(espTab) end)
tab6.MouseButton1Click:Connect(function() SwitchToTab(visualTab) end)
tab7.MouseButton1Click:Connect(function() SwitchToTab(miscTab) end)
tab8.MouseButton1Click:Connect(function() SwitchToTab(trollTab) end)

local function CreateSwitch(parent, y, text, path)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -30, 0, 50)
    f.Position = UDim2.new(0, 15, 0, y)
    f.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.75, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.Gotham
    l.TextSize = 16
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local s = Instance.new("TextButton")
    s.Size = UDim2.new(0, 70, 0, 32)
    s.Position = UDim2.new(0.88, 0, 0.5, -16)
    s.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    s.Text = "OFF"
    s.TextColor3 = Color3.fromRGB(255, 80, 80)
    s.Font = Enum.Font.GothamBold
    s.Parent = f
    Instance.new("UICorner", s).CornerRadius = UDim.new(0, 16)

    local enabled = false
    s.MouseButton1Click:Connect(function()
        enabled = not enabled
        s.Text = enabled and "ON" or "OFF"
        s.BackgroundColor3 = enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(50, 50, 65)
        s.TextColor3 = enabled and Color3.new(1,1,1) or Color3.fromRGB(255, 80, 80)
        
        local t = _G.RheyzHub
        for _, k in ipairs(path) do t = t[k] end
        t = enabled
    end)
end

local y = 20

CreateSwitch(survivorTab, y, "Auto Skillcheck", {"Survivor", "AutoSkillCheck"}) y = y + 65
CreateSwitch(survivorTab, y, "Auto Generator", {"Survivor", "AutoGenerator"}) y = y + 65
CreateSwitch(survivorTab, y, "Auto Parry", {"Survivor", "AutoParry"}) y = y + 65
CreateSwitch(survivorTab, y, "Auto Heal", {"Survivor", "AutoHeal"}) y = y + 65
CreateSwitch(survivorTab, y, "Drop All Pallets", {"Survivor", "DropAllPallets"}) y = y + 65
CreateSwitch(survivorTab, y, "Unlock Pallets", {"Survivor", "UnlockPallets"}) y = y + 65
CreateSwitch(survivorTab, y, "No Slowdown", {"Survivor", "NoSlowdown"}) y = y + 65
CreateSwitch(survivorTab, y, "Fast Vault", {"Survivor", "FastVault"}) y = y + 65
CreateSwitch(survivorTab, y, "Bypass Exit", {"Survivor", "BypassExit"}) y = y + 65

y = 20
CreateSwitch(killerTab, y, "No Cooldown", {"Killer", "NoCooldown"}) y = y + 65
CreateSwitch(killerTab, y, "Instant Hit", {"Killer", "InstantHit"}) y = y + 65
CreateSwitch(killerTab, y, "No Stun", {"Killer", "NoStun"}) y = y + 65
CreateSwitch(killerTab, y, "Wall Check Bypass", {"Killer", "WallCheckBypass"}) y = y + 65

y = 20
CreateSwitch(combatTab, y, "Face Killer", {"Combat", "FaceKiller"}) y = y + 65

y = 20
CreateSwitch(aimbotTab, y, "Aimbot Enabled", {"Aimbot", "Enabled"}) y = y + 65
CreateSwitch(aimbotTab, y, "Silent Aim", {"Aimbot", "SilentAim"}) y = y + 65

y = 20
CreateSwitch(espTab, y, "ESP Enabled", {"ESP", "Enabled"}) y = y + 65
CreateSwitch(espTab, y, "Player ESP", {"ESP", "Players"}) y = y + 65
CreateSwitch(espTab, y, "Generator ESP", {"ESP", "Generator"}) y = y + 65
CreateSwitch(espTab, y, "Pallet ESP", {"ESP", "Pallet"}) y = y + 65

y = 20
CreateSwitch(visualTab, y, "Full Bright", {"Visual", "FullBright"}) y = y + 65
CreateSwitch(visualTab, y, "No Fog", {"Visual", "NoFog"}) y = y + 65

y = 20
CreateSwitch(miscTab, y, "Fly", {"Misc", "Fly"}) y = y + 65
CreateSwitch(miscTab, y, "Noclip", {"Misc", "NoClip"}) y = y + 65
CreateSwitch(miscTab, y, "God Mode", {"Misc", "GodMode"}) y = y + 65

y = 20
CreateSwitch(trollTab, y, "HeadSit (on selected)", {"Troll", "HeadSit"}) y = y + 65
CreateSwitch(trollTab, y, "Spin Target", {"Troll", "Spin"}) y = y + 65
CreateSwitch(trollTab, y, "Spam Chat", {"Troll", "SpamChat"}) y = y + 65
CreateSwitch(trollTab, y, "Fling Target", {"Troll", "Fling"}) y = y + 65

local function GetAllPallets()
    local list = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("pallet") then
            table.insert(list, obj)
        end
    end
    return list
end

local function DropAllPallets()
    for _, p in pairs(GetAllPallets()) do
        local r = p:FindFirstChild("HumanoidRootPart") or p.PrimaryPart
        if r then
            r.Velocity = Vector3.new(0, -400, 0)
            r.CFrame = r.CFrame * CFrame.new(0, -25, 0)
        end
    end
end

local function UnlockPallets()
    for _, p in pairs(GetAllPallets()) do
        for _, d in pairs(p:GetDescendants()) do
            if d:IsA("BoolValue") then
                if d.Name:lower():find("lock") or d.Name:lower():find("used") then
                    d.Value = false
                end
            end
            if d:IsA("NumberValue") and d.Name:lower():find("cooldown") then
                d.Value = 0
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if _G.RheyzHub.Survivor.DropAllPallets then
        DropAllPallets()
        _G.RheyzHub.Survivor.DropAllPallets = false
    end
    if _G.RheyzHub.Survivor.UnlockPallets then
        UnlockPallets()
    end

    if _G.RheyzHub.Troll.HeadSit and selectedPlayer and selectedPlayer.Character then
        local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and myRoot then
            myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 4.2, 0)
        end
    end

    if _G.RheyzHub.Troll.Spin and selectedPlayer and selectedPlayer.Character then
        local root = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyAngularVelocity = Vector3.new(0, 150, 0) end
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

print("Violence District Premium Hub Loaded")