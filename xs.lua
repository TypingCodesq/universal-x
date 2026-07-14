-- VIOLENCE DISTRICT HUB - DELTA MOBILE (Drop Pallets FIX)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

_G.RheyzHub = {
    Survivor = {
        DropAllPallets = false,
        UnlockPallets = false,
    },
    Misc = { WalkSpeed = 18, Fly = false, Noclip = false, GodMode = false }
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
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root or #pallets == 0 then 
        print("No pallets encontrados o character no cargado")
        return 
    end

    print("Iniciando Drop de " .. #pallets .. " pallets...")

    for i, pallet in ipairs(pallets) do
        local pRoot = pallet:FindFirstChild("HumanoidRootPart") or pallet.PrimaryPart or pallet:FindFirstChildWhichIsA("BasePart")
        if pRoot and root then
            
            -- TP al pallet
            root.CFrame = pRoot.CFrame * CFrame.new(2, 6, 2)
            wait(0.12)
            
            -- Tirada fuerte
            pRoot.Velocity = Vector3.new(math.random(-20,20), -1200, math.random(-20,20))
            pRoot.AssemblyLinearVelocity = Vector3.new(0, -1200, 0)
            
            -- Forzar todas las partes
            for _, part in pairs(pallet:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Velocity = Vector3.new(0, -1000, 0)
                    part.CanCollide = true
                end
            end
        end
        wait(0.09) -- Pausa entre pallets
    end
    
    print("✅ Drop de todos los pallets completado (" .. #pallets .. ")")
end

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VDHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 340, 0, 460)
Main.Position = UDim2.new(0.5, -170, 0.3, 0)
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

-- Botones
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

-- Loop
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if hum then
        hum.WalkSpeed = _G.RheyzHub.Misc.WalkSpeed or 16
    end

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

print("✅ Hub cargado - Prueba el botón DROP ALL PALLETS")