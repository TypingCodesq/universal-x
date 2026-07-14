-- VIOLENCE DISTRICT HUB - DELTA MOBILE (Auto Gen Mejorado)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local root = nil

_G.RheyzHub = {
    Survivor = {
        AutoGenerator = false,
        DropAllPallets = false,
        UnlockPallets = false,
    },
    Misc = { WalkSpeed = 18 }
}

local currentGen = nil
local autoGenConn = nil

local function GetNearestGenerator()
    local nearest = nil
    local shortest = math.huge
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    for _, gen in pairs(Workspace:GetDescendants()) do
        if gen.Name == "Generator" or gen.Name:lower():find("gen") then
            local gRoot = gen:FindFirstChild("HumanoidRootPart") or gen.PrimaryPart or gen:FindFirstChildWhichIsA("BasePart")
            if gRoot then
                local dist = (myRoot.Position - gRoot.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    nearest = gen
                end
            end
        end
    end
    return nearest
end

local function AutoGenerator()
    if autoGenConn then autoGenConn:Disconnect() end

    autoGenConn = RunService.Heartbeat:Connect(function()
        if not _G.RheyzHub.Survivor.AutoGenerator then 
            if autoGenConn then autoGenConn:Disconnect() end
            return 
        end

        local char = player.Character
        if not char then return end
        root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local gen = GetNearestGenerator()
        if not gen then return end

        local genRoot = gen:FindFirstChild("HumanoidRootPart") or gen.PrimaryPart or gen:FindFirstChildWhichIsA("BasePart")
        if not genRoot then return end

        -- Alternar lados del generador
        local side = math.random(1,2) == 1 and 3 or -3
        root.CFrame = genRoot.CFrame * CFrame.new(side, 4, 0) * CFrame.Angles(0, math.rad(90), 0)

        -- Mantener E presionado
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        wait(0.4)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
end

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VDHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 340, 0, 460)
Main.Position = UDim2.new(0.5, -170, 0.25, 0)
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

AddBtn("AUTO GENERATOR (Alterna lados)", function()
    _G.RheyzHub.Survivor.AutoGenerator = not _G.RheyzHub.Survivor.AutoGenerator
    if _G.RheyzHub.Survivor.AutoGenerator then
        AutoGenerator()
        print("Auto Generator ACTIVADO")
    else
        print("Auto Generator DESACTIVADO")
    end
end)

AddBtn("DROP ALL PALLETS (TP + Throw)", function()
    DropAllPalletsWithTP()
end)

AddBtn("Unlock All Pallets", function()
    _G.RheyzHub.Survivor.UnlockPallets = not _G.RheyzHub.Survivor.UnlockPallets
end)

AddBtn("WalkSpeed 30", function()
    _G.RheyzHub.Misc.WalkSpeed = 30
end)

print("✅ Hub cargado - Auto Gen mejorado")