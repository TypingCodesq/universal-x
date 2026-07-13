-- VIOLENCE DISTRICT HUB - DELTA MOBILE (Drop Pallets Mejorado)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

_G.RheyzHub = {
    Survivor = {
        AutoSkillCheck = false,
        AutoGenerator = false,
        AutoParry = false,
        AutoHeal = false,
        DropAllPallets = false,
        UnlockPallets = false,
        NoSlowdown = false,
        FastVault = false
    },
    Misc = { WalkSpeed = 18, Fly = false, Noclip = false, GodMode = false },
    Troll = { HeadSit = false, Selected = nil }
}

local function GetAllPallets()
    local pallets = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v.Name:lower():find("pallet") and (v:IsA("Model") or v:IsA("BasePart")) then
            table.insert(pallets, v)
        end
    end
    return pallets
end

local function DropAllPalletsWithTP()
    local pallets = GetAllPallets()
    if #pallets == 0 then 
        print("No se encontraron pallets")
        return 
    end

    for _, pallet in pairs(pallets) do
        local palletRoot = pallet:FindFirstChild("HumanoidRootPart") or pallet.PrimaryPart or pallet:FindFirstChildWhichIsA("BasePart")
        if palletRoot and root then
            
            -- Teleport al pallet
            root.CFrame = palletRoot.CFrame * CFrame.new(0, 5, 0)
            wait(0.15)
            
            -- Tirar el pallet con fuerza
            palletRoot.Velocity = Vector3.new(0, -800, 0)
            palletRoot.AssemblyLinearVelocity = Vector3.new(0, -800, 0)
            
            -- Forzar caída
            for _, part in pairs(pallet:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Velocity = Vector3.new(0, -600, 0)
                end
            end
        end
        wait(0.08) -- Pequeña pausa para que no se buguee
    end
    
    print("✅ Todos los pallets fueron teleportados y tirados")
end

-- Loop principal
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local r = char:FindFirstChild("HumanoidRootPart")
    if not hum or not r then return end

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

    if _G.RheyzHub.Misc.WalkSpeed then
        hum.WalkSpeed = _G.RheyzHub.Misc.WalkSpeed
    end
end)

-- UI Simple Mobile
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VDHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0.9, 0, 0.8, 0)
Main.Position = UDim2.new(0.05, 0, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
Title.Text = "VIOLENCE DISTRICT HUB"
Title.TextColor3 = Color3.fromRGB(100, 170, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 19
Title.Parent = Main

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 80, 0, 80)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
ToggleBtn.Text = "VD"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 26
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 20)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Botones
local y = 70
local function AddBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 55)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = Main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    btn.MouseButton1Click:Connect(callback)
    y = y + 65
end

AddBtn("DROP ALL PALLETS (TP + Throw)", function()
    DropAllPalletsWithTP()
end)

AddBtn("Unlock All Pallets", function()
    _G.RheyzHub.Survivor.UnlockPallets = not _G.RheyzHub.Survivor.UnlockPallets
end)

AddBtn("WalkSpeed 30", function()
    _G.RheyzHub.Misc.WalkSpeed = 30
end)

AddBtn("Fly Mode", function()
    _G.RheyzHub.Misc.Fly = not _G.RheyzHub.Misc.Fly
end)

AddBtn("Noclip", function()
    _G.RheyzHub.Misc.Noclip = not _G.RheyzHub.Misc.Noclip
end)

print("✅ Hub cargado correctamente para Delta Mobile")
print("Toca el botón VD para abrir el menú")
