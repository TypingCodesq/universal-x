-- VIOLENCE DISTRICT HUB - DELTA MOBILE (GUI FIJA)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- Esperar a que cargue el jugador
player.CharacterAdded:Wait()

_G.RheyzHub = {
    Survivor = {
        DropAllPallets = false,
        UnlockPallets = false,
    },
    Misc = { WalkSpeed = 18 }
}

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
        if not pRoot then
            for _, part in pairs(pallet:GetDescendants()) do
                if part:IsA("BasePart") then
                    pRoot = part
                    break
                end
            end
        end
        if pRoot then
            root.CFrame = pRoot.CFrame * CFrame.new(4, 8, 0)
            wait(0.15)
            pRoot.Velocity = Vector3.new(0, -1600, 0)
        end
        wait(0.1)
    end
end

-- ==================== GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VDHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Intentar poner en CoreGui primero
pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)

-- Si falla, poner en PlayerGui
if not ScreenGui.Parent then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 420)
Main.Position = UDim2.new(0.5, -160, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
Main.Active = true
Main.Draggable = true
Main.Visible = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
Title.Text = "VIOLENCE DISTRICT"
Title.TextColor3 = Color3.fromRGB(120, 200, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Main

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 65, 0, 65)
ToggleBtn.Position = UDim2.new(0.5, -32.5, 0.8, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
ToggleBtn.Text = "VD"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 22
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 16)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

local y = 60
local function AddBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = Main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    btn.MouseButton1Click:Connect(callback)
    y = y + 58
end

AddBtn("DROP ALL PALLETS", DropAllPalletsWithTP)

AddBtn("Unlock Pallets", function()
    _G.RheyzHub.Survivor.UnlockPallets = not _G.RheyzHub.Survivor.UnlockPallets
end)

AddBtn("WalkSpeed 30", function()
    _G.RheyzHub.Misc.WalkSpeed = 30
end)

print("✅ GUI cargada - Toca el botón VD")
