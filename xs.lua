-- VIOLENCE DISTRICT HUB - DELTA MOBILE (Completo)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

_G.RheyzHub = {
    Survivor = {
        AutoSkillCheck = false,
        AutoGenerator = false,
        AutoParry = false,
        AutoHeal = false,
        DropAllPallets = false,
        UnlockPallets = false
    },
    Misc = { WalkSpeed = 18, Fly = false, Noclip = false, GodMode = false }
}

-- ==================== TU CÓDIGO (ESP + SkillCheck) ====================
local Config = {
    Players = {
        Killer = {Color = Color3.fromRGB(255, 93, 108)},
        Survivor = {Color = Color3.fromRGB(64, 224, 255)}
    },
    Objects = {
        Generator = {Color = Color3.fromRGB(150, 0, 200)},
        Gate = {Color = Color3.fromRGB(255, 255, 255)},
        Pallet = {Color = Color3.fromRGB(74, 255, 181)},
        Window = {Color = Color3.fromRGB(74, 255, 181)},
        Hook = {Color = Color3.fromRGB(132, 255, 169)}
    }
}

local MaskNames = { ["Richard"] = "Rooster", ["Tony"] = "Tiger", ["Brandon"] = "Panther", ["Cobra"] = "Cobra", ["Richter"] = "Rat", ["Rabbit"] = "Rabbit", ["Alex"] = "Chainsaw" }
local MaskColors = { ["Richard"] = Color3.fromRGB(255, 0, 0), ["Tony"] = Color3.fromRGB(255, 255, 0), ["Brandon"] = Color3.fromRGB(160, 32, 240), ["Cobra"] = Color3.fromRGB(0, 255, 0), ["Richter"] = Color3.fromRGB(0, 0, 0), ["Rabbit"] = Color3.fromRGB(255, 105, 180), ["Alex"] = Color3.fromRGB(255, 255, 255) }

local IndicatorGui = nil

local function SetupGui()
    if player.PlayerGui:FindFirstChild("ChasedInds") then player.PlayerGui.ChasedInds:Destroy() end
    IndicatorGui = Instance.new("ScreenGui")
    IndicatorGui.Name = "ChasedInds"
    IndicatorGui.IgnoreGuiInset = true
    IndicatorGui.DisplayOrder = 999
    IndicatorGui.Parent = player.PlayerGui
end

local function GetGameValue(obj, name)
    if not obj then return nil end
    local attr = obj:GetAttribute(name)
    if attr \~= nil then return attr end
    local child = obj:FindFirstChild(name)
    if child then
        local success, val = pcall(function() return child.Value end)
        if success then return val end
    end
    return nil
end

local function ApplyHighlight(object, color)
    local h = object:FindFirstChild("H") or Instance.new("Highlight")
    h.Name = "H"
    h.Adornee = object
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.7
    h.OutlineTransparency = 0.2
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = object
end

local function CreateBillboardTag(text, color, size, textSize)
    local billboard = Instance.new("BillboardGui")
    billboard.AlwaysOnTop = true
    billboard.Size = size or UDim2.new(0, 120, 0, 30)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = textSize or 12
    label.Parent = billboard
    return billboard
end

local function updatePlayerNametag(p)
    if not p.Character then return end
    local root = p.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local isKiller = (p.Team and p.Team.Name:lower():find("killer")) \~= nil
    local color = isKiller and Config.Players.Killer.Color or Config.Players.Survivor.Color

    ApplyHighlight(p.Character, color)

    local billboard = root:FindFirstChild("Nametag")
    if not billboard then
        billboard = CreateBillboardTag(p.Name, color)
        billboard.Adornee = root
        billboard.StudsOffset = Vector3.new(0, 4, 0)
        billboard.Parent = root
        billboard.Name = "Nametag"
    end
end

local function GetAllPallets()
    local list = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v.Name:lower():find("pallet") then table.insert(list, v) end
    end
    return list
end

local function DropAllPalletsWithTP()
    local pallets = GetAllPallets()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, pallet in pairs(pallets) do
        local pRoot = pallet:FindFirstChild("HumanoidRootPart") or pallet.PrimaryPart or pallet:FindFirstChildWhichIsA("BasePart")
        if pRoot then
            root.CFrame = pRoot.CFrame * CFrame.new(3, 7, 0)
            wait(0.1)
            pRoot.Velocity = Vector3.new(0, -1400, 0)
        end
        wait(0.08)
    end
end

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VDHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 340, 0, 480)
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
end)

AddBtn("DROP ALL PALLETS", DropAllPalletsWithTP)

AddBtn("Unlock Pallets", function()
    _G.RheyzHub.Survivor.UnlockPallets = not _G.RheyzHub.Survivor.UnlockPallets
end)

AddBtn("WalkSpeed 30", function()
    _G.RheyzHub.Misc.WalkSpeed = 30
end)

-- Loop principal
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = _G.RheyzHub.Misc.WalkSpeed end

    if _G.RheyzHub.Survivor.DropAllPallets then
        _G.RheyzHub.Survivor.DropAllPallets = false
        DropAllPalletsWithTP()
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
end)

SetupGui()
print("✅ Hub cargado correctamente")