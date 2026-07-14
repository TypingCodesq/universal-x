-- VIOLENCE DISTRICT HUB - DELTA MOBILE v4.2
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
        NoSlowdown = false
    },
    Killer = {
        SpeedMulti = 2.5,
        InstantHit = false,
        NoStun = false
    },
    Misc = { WalkSpeed = 18, Noclip = false, GodMode = false }
}

-- ==================== AUTO GENERATOR (Mejorado) ====================
local function AutoGenerator()
    if not _G.RheyzHub.Survivor.AutoGenerator then return end
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, gen in pairs(Workspace:GetDescendants()) do
        if gen.Name == "Generator" then
            for i = 1, 4 do
                local point = gen:FindFirstChild("GeneratorPoint"..i)
                if point and (root.Position - point.Position).Magnitude < 40 then
                    root.CFrame = point.CFrame * CFrame.new(0, -2, 0)  -- Debajo del gen
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    wait(0.4)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    wait(0.6)
                end
            end
        end
    end
end

-- ==================== AUTO HEAL ====================
local function AutoHeal()
    if not _G.RheyzHub.Survivor.AutoHeal then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum and hum.Health < hum.MaxHealth then
        hum.Health = hum.MaxHealth
    end
end

-- ==================== GOD MODE ====================
local function GodMode()
    if not _G.RheyzHub.Misc.GodMode then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end
end

-- ==================== DROP PALLETS ====================
local function DropAllPalletsWithTP()
    local pallets = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v.Name:lower():find("pallet") then table.insert(pallets, v) end
    end
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, p in pairs(pallets) do
        local pRoot = p:FindFirstChild("HumanoidRootPart") or p.PrimaryPart
        if pRoot then
            root.CFrame = pRoot.CFrame * CFrame.new(3, 8, 3)
            wait(0.12)
            pRoot.Velocity = Vector3.new(0, -1600, 0)
        end
        wait(0.1)
    end
end

-- ==================== UI MEJORADA ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VDHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 580)
Main.Position = UDim2.new(0.5, -190, 0.15, 0)
Main.BackgroundColor3 = Color3.fromRGB(14, 14, 24)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 55)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 38)
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "VIOLENCE DISTRICT HUB"
Title.TextColor3 = Color3.fromRGB(110, 180, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 21
Title.Parent = TopBar

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

local y = 70
local function AddBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 55)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(32, 32, 50)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 15
    btn.Parent = Main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    btn.MouseButton1Click:Connect(callback)
    y = y + 65
end

AddBtn("DROP ALL PALLETS", DropAllPalletsWithTP)
AddBtn("Unlock All Pallets", function() _G.RheyzHub.Survivor.UnlockPallets = not _G.RheyzHub.Survivor.UnlockPallets end)
AddBtn("Auto Generator", function() _G.RheyzHub.Survivor.AutoGenerator = not _G.RheyzHub.Survivor.AutoGenerator end)
AddBtn("Auto Skillcheck", function() _G.RheyzHub.Survivor.AutoSkillCheck = not _G.RheyzHub.Survivor.AutoSkillCheck end)
AddBtn("Auto Parry", function() _G.RheyzHub.Survivor.AutoParry = not _G.RheyzHub.Survivor.AutoParry end)
AddBtn("Auto Heal", function() _G.RheyzHub.Survivor.AutoHeal = not _G.RheyzHub.Survivor.AutoHeal end)
AddBtn("No Slowdown", function() _G.RheyzHub.Survivor.NoSlowdown = not _G.RheyzHub.Survivor.NoSlowdown end)
AddBtn("Killer Speed x2.5", function() _G.RheyzHub.Killer.SpeedMulti = 2.5 end)
AddBtn("Instant Hit", function() _G.RheyzHub.Killer.InstantHit = not _G.RheyzHub.Killer.InstantHit end)
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

    if _G.RheyzHub.Survivor.AutoGenerator then AutoGenerator() end
    if _G.RheyzHub.Survivor.AutoHeal then AutoHeal() end
    if _G.RheyzHub.Misc.GodMode then GodMode() end

    if _G.RheyzHub.Misc.Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

print("✅ VD Hub v4.2 Cargado")
print("Arrastra la ventana")