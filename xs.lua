-- VIOLENCE DISTRICT HUB - DELTA MOBILE v4.0
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

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
        BypassExit = false
    },
    Killer = {
        NoCooldown = false,
        InstantHit = false,
        SpeedMulti = 2.2,
        NoStun = false,
        InstantGrab = false
    },
    Aimbot = { Enabled = false, FOV = 220 },
    ESP = { Enabled = true, Players = true, Generators = true },
    Misc = { WalkSpeed = 18, Noclip = false, GodMode = false }
}

-- ==================== PALLETS ====================
local function GetAllPallets()
    local pallets = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v.Name:lower():find("pallet") then
            table.insert(pallets, v)
        end
    end
    return pallets
end

local function DropAllPalletsWithTP()
    local pallets = GetAllPallets()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, pallet in pairs(pallets) do
        local pRoot = pallet:FindFirstChild("HumanoidRootPart") or pallet.PrimaryPart
        if pRoot then
            root.CFrame = pRoot.CFrame * CFrame.new(3, 7, 3)
            wait(0.12)
            pRoot.Velocity = Vector3.new(0, -1400, 0)
        end
        wait(0.08)
    end
end

-- ==================== AUTO GENERATOR ====================
local function AutoGenerator()
    if not _G.RheyzHub.Survivor.AutoGenerator then return end
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, gen in pairs(Workspace:GetDescendants()) do
        if gen.Name == "Generator" then
            local point = gen:FindFirstChild("GeneratorPoint1") or gen.PrimaryPart
            if point and (root.Position - point.Position).Magnitude < 30 then
                root.CFrame = point.CFrame * CFrame.new(0, 5, 0)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                wait(0.6)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                break
            end
        end
    end
end

-- ==================== UI MEJORADA ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VDHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 360, 0, 520)
Main.Position = UDim2.new(0.5, -180, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "VIOLENCE DISTRICT HUB"
Title.TextColor3 = Color3.fromRGB(100, 170, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = TopBar

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 65, 0, 65)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
ToggleBtn.Text = "VD"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 24
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 16)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

local y = 60
local function AddBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 52)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 15
    btn.Parent = Main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(callback)
    y = y + 60
end

AddBtn("DROP ALL PALLETS (TP + Throw)", DropAllPalletsWithTP)
AddBtn("Unlock All Pallets", function() _G.RheyzHub.Survivor.UnlockPallets = not _G.RheyzHub.Survivor.UnlockPallets end)
AddBtn("Auto Generator", function() _G.RheyzHub.Survivor.AutoGenerator = not _G.RheyzHub.Survivor.AutoGenerator end)
AddBtn("Auto Skillcheck", function() _G.RheyzHub.Survivor.AutoSkillCheck = not _G.RheyzHub.Survivor.AutoSkillCheck end)
AddBtn("Auto Parry", function() _G.RheyzHub.Survivor.AutoParry = not _G.RheyzHub.Survivor.AutoParry end)
AddBtn("Auto Heal", function() _G.RheyzHub.Survivor.AutoHeal = not _G.RheyzHub.Survivor.AutoHeal end)
AddBtn("No Slowdown", function() _G.RheyzHub.Survivor.NoSlowdown = not _G.RheyzHub.Survivor.NoSlowdown end)
AddBtn("Killer Speed x2.2", function() _G.RheyzHub.Killer.SpeedMulti = 2.2 end)
AddBtn("Noclip", function() _G.RheyzHub.Misc.Noclip = not _G.RheyzHub.Misc.Noclip end)
AddBtn("God Mode", function() _G.RheyzHub.Misc.GodMode = not _G.RheyzHub.Misc.GodMode end)
AddBtn("WalkSpeed 30", function() _G.RheyzHub.Misc.WalkSpeed = 30 end)

-- ==================== MAIN LOOP ====================
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    hum.WalkSpeed = _G.RheyzHub.Misc.WalkSpeed

    if _G.RheyzHub.Survivor.DropAllPallets then
        _G.RheyzHub.Survivor.DropAllPallets = false
        DropAllPalletsWithTP()
    end

    if _G.RheyzHub.Survivor.AutoGenerator then
        AutoGenerator()
    end

    if _G.RheyzHub.Survivor.UnlockPallets then
        for _, p in pairs(GetAllPallets()) do
            for _, d in pairs(p:GetDescendants()) do
                if d:IsA("BoolValue") and (d.Name:lower():find("lock") or d.Name:lower():find("used")) then
                    d.Value = false
                end
            end
        end
    end

    if _G.RheyzHub.Misc.Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if _G.RheyzHub.Misc.GodMode and hum then
        hum.Health = hum.MaxHealth
    end
end)

print("✅ VD Hub Mobile v4.0 Cargado")
print("Arrastra la ventana | Usa los botones")