-- VIOLENCE DISTRICT ULTIMATE - DELTA MOBILE
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
        SpeedMulti = 2.0
    },
    Aimbot = {
        Enabled = false,
        FOV = 250,
        Smoothness = 8
    },
    ESP = {
        Enabled = true,
        Players = true,
        Generators = true,
        Pallets = true
    },
    Misc = {
        WalkSpeed = 18,
        Fly = false,
        Noclip = false,
        GodMode = false
    }
}

-- ==================== PALLETS FIX ====================
local function GetRootPart(obj)
    if not obj then return nil end
    if obj:FindFirstChild("HumanoidRootPart") then return obj.HumanoidRootPart end
    if obj.PrimaryPart then return obj.PrimaryPart end
    for _, part in pairs(obj:GetDescendants()) do
        if part:IsA("BasePart") and part.Size.Magnitude > 3 then
            return part
        end
    end
    for _, part in pairs(obj:GetDescendants()) do
        if part:IsA("BasePart") then return part end
    end
    return nil
end

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
        local pRoot = GetRootPart(pallet)
        if pRoot then
            root.CFrame = pRoot.CFrame * CFrame.new(3, 6, 3)
            wait(0.12)
            pRoot.Velocity = Vector3.new(0, -1400, 0)
            for _, part in pairs(pallet:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Velocity = Vector3.new(0, -1200, 0)
                end
            end
        end
        wait(0.1)
    end
    print("✅ Drop All Pallets completado")
end

-- ==================== AUTO GENERATOR ====================
local function AutoGenerator()
    local conn = RunService.Heartbeat:Connect(function()
        if not _G.RheyzHub.Survivor.AutoGenerator then conn:Disconnect() return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        for _, gen in pairs(Workspace:GetDescendants()) do
            if gen.Name == "Generator" then
                local gRoot = GetRootPart(gen)
                if gRoot then
                    local side = math.random(1,2) == 1 and 4 or -4
                    root.CFrame = gRoot.CFrame * CFrame.new(side, 5, 0)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    wait(0.4)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end
            end
        end
    end)
end

-- ==================== UI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VDHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 340, 0, 520)
Main.Position = UDim2.new(0.5, -170, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
Title.Text = "VIOLENCE DISTRICT HUB"
Title.TextColor3 = Color3.fromRGB(110, 180, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Main

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 70, 0, 70)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
ToggleBtn.Text = "VD"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 24
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 18)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

local y = 60
local function AddBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 52)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = Main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(callback)
    y = y + 62
end

AddBtn("AUTO GENERATOR", function()
    _G.RheyzHub.Survivor.AutoGenerator = not _G.RheyzHub.Survivor.AutoGenerator
    if _G.RheyzHub.Survivor.AutoGenerator then AutoGenerator() end
end)

AddBtn("DROP ALL PALLETS (TP + Throw)", DropAllPalletsWithTP)

AddBtn("Unlock All Pallets", function()
    _G.RheyzHub.Survivor.UnlockPallets = not _G.RheyzHub.Survivor.UnlockPallets
end)

AddBtn("WalkSpeed 30", function()
    _G.RheyzHub.Misc.WalkSpeed = 30
end)

AddBtn("Toggle Fly", function()
    _G.RheyzHub.Misc.Fly = not _G.RheyzHub.Misc.Fly
end)

AddBtn("Toggle Noclip", function()
    _G.RheyzHub.Misc.Noclip = not _G.RheyzHub.Misc.Noclip
end)

AddBtn("God Mode", function()
    _G.RheyzHub.Misc.GodMode = not _G.RheyzHub.Misc.GodMode
end)

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = _G.RheyzHub.Misc.WalkSpeed
    end
end)

print("✅ Hub completo cargado")