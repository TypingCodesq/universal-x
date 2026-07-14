-- VIOLENCE DISTRICT HUB - DELTA MOBILE v4.3 (GUI Moderna)
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

-- ==================== DROP PALLETS (FIX TOTAL) ====================
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
            -- TP fuerte
            root.CFrame = pRoot.CFrame * CFrame.new(4, 9, 4)
            wait(0.18)
            
            -- Tirada extrema
            pRoot.Velocity = Vector3.new(0, -2000, 0)
            pRoot.AssemblyLinearVelocity = Vector3.new(0, -2000, 0)
            
            for _, part in pairs(pallet:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Velocity = Vector3.new(0, -1800, 0)
                end
            end
        end
        wait(0.12)
    end
    print("✅ Drop completado")
end

-- ==================== AUTO GENERATOR (Debajo) ====================
local function AutoGenerator()
    if not _G.RheyzHub.Survivor.AutoGenerator then return end
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, gen in pairs(Workspace:GetDescendants()) do
        if gen.Name == "Generator" then
            for i = 1, 4 do
                local point = gen:FindFirstChild("GeneratorPoint"..i)
                if point and (root.Position - point.Position).Magnitude < 40 then
                    root.CFrame = point.CFrame * CFrame.new(0, -1.5, 0)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    wait(0.5)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end
            end
        end
    end
end

-- ==================== GUI MODERNA ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VDHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 400, 0, 620)
Main.Position = UDim2.new(0.5, -200, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(13, 13, 22)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 60)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 18)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "VIOLENCE DISTRICT"
Title.TextColor3 = Color3.fromRGB(120, 200, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.Parent = TopBar

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 75, 0, 75)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
ToggleBtn.Text = "VD"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 26
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 20)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

local y = 75
local function AddBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 58)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.Parent = Main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 14)
    btn.MouseButton1Click:Connect(callback)
    y = y + 68
end

AddBtn("DROP ALL PALLETS (TP + Throw)", DropAllPalletsWithTP)
AddBtn("Unlock All Pallets", function() _G.RheyzHub.Survivor.UnlockPallets = not _G.RheyzHub.Survivor.UnlockPallets end)
AddBtn("Auto Generator", function() _G.RheyzHub.Survivor.AutoGenerator = not _G.RheyzHub.Survivor.AutoGenerator end)
AddBtn("Auto Skillcheck", function() _G.RheyzHub.Survivor.AutoSkillCheck = not _G.RheyzHub.Survivor.AutoSkillCheck end)
AddBtn("Auto Parry", function() _G.RheyzHub.Survivor.AutoParry = not _G.RheyzHub.Survivor.AutoParry end)
AddBtn("Auto Heal", function() _G.RheyzHub.Survivor.AutoHeal = not _G.RheyzHub.Survivor.AutoHeal end)
AddBtn("No Slowdown", function() _G.RheyzHub.Survivor.NoSlowdown = not _G.RheyzHub.Survivor.NoSlowdown end)
AddBtn("Killer Speed x2.5", function() _G.RheyzHub.Killer.SpeedMulti = 2.5 end)
AddBtn("Instant Hit (Killer)", function() _G.RheyzHub.Killer.InstantHit = not _G.RheyzHub.Killer.InstantHit end)
AddBtn("Noclip", function() _G.RheyzHub.Misc.Noclip = not _G.RheyzHub.Misc.Noclip end)
AddBtn("God Mode", function() _G.RheyzHub.Misc.GodMode = not _G.RheyzHub.Misc.GodMode end)
AddBtn("WalkSpeed 30", function() _G.RheyzHub.Misc.WalkSpeed = 30 end)

-- ==================== LOOP ====================
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
    if _G.RheyzHub.Survivor.AutoHeal then
        if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end
    if _G.RheyzHub.Misc.GodMode and hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end
    if _G.RheyzHub.Misc.Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

print("✅ VD Hub v4.3 Cargado - GUI Moderna")
print("Arrastra la ventana")