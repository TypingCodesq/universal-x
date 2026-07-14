-- VIOLENCE DISTRICT HUB - AUTO GENERATOR FIX (Delta Mobile)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

_G.RheyzHub = {
    Survivor = {
        AutoGenerator = false,
    }
}

local autoGenActive = false
local currentGen = nil
local currentPoints = {}
local currentIndex = 1
local genConn = nil

local function GetRootPart(obj)
    if not obj then return nil end
    if obj:FindFirstChild("HumanoidRootPart") then return obj.HumanoidRootPart end
    if obj.PrimaryPart then return obj.PrimaryPart end
    for _, p in pairs(obj:GetDescendants()) do
        if p:IsA("BasePart") then return p end
    end
    return nil
end

local function findBestGenerator()
    local char = player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local bestGen, bestDist, bestPts = nil, math.huge, {}

    for _, gen in pairs(Workspace:GetDescendants()) do
        if gen.Name == "Generator" then
            local progress = gen:GetAttribute("Progress") or gen:GetAttribute("RepairProgress") or 0
            if progress < 100 then
                local pts = {}
                for i = 1, 4 do
                    local p = gen:FindFirstChild("GeneratorPoint"..i)
                    if p then table.insert(pts, p) end
                end
                if #pts > 0 then
                    for _, p in pairs(pts) do
                        local dist = (root.Position - p.Position).Magnitude
                        if dist < bestDist then
                            bestDist = dist
                            bestGen = gen
                            bestPts = pts
                        end
                    end
                end
            end
        end
    end
    return bestGen, bestPts
end

local function startAutoGenerator()
    if autoGenActive then return end
    autoGenActive = true

    genConn = RunService.Heartbeat:Connect(function()
        if not autoGenActive then
            if genConn then genConn:Disconnect() end
            return
        end

        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        -- Buscar nuevo generador si es necesario
        if not currentGen or (currentGen:GetAttribute("Progress") or 0) >= 100 then
            local gen, pts = findBestGenerator()
            if gen then
                currentGen = gen
                currentPoints = pts
                currentIndex = 1
                print("Nuevo generador encontrado")
            else
                return
            end
        end

        -- Mover al punto actual
        if currentPoints[currentIndex] then
            root.CFrame = currentPoints[currentIndex].CFrame * CFrame.new(2, 5, 0)
        end

        -- Hacer el primer tap para iniciar el generador
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        wait(0.25)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

        -- Cambiar de lado cada cierto tiempo
        wait(1.2)
        if #currentPoints > 1 then
            currentIndex = currentIndex == 1 and 2 or 1
        end
    end)

    print("✅ Auto Generator ACTIVADO (Tap + Alternar lados)")
end

local function stopAutoGenerator()
    autoGenActive = false
    if genConn then genConn:Disconnect() end
    currentGen = nil
    currentPoints = {}
    print("❌ Auto Generator DESACTIVADO")
end

-- ==================== UI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VDHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 340, 0, 420)
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

AddBtn("AUTO GENERATOR (Tap + Alternar)", function()
    _G.RheyzHub.Survivor.AutoGenerator = not _G.RheyzHub.Survivor.AutoGenerator
    if _G.RheyzHub.Survivor.AutoGenerator then
        startAutoGenerator()
    else
        stopAutoGenerator()
    end
end)

AddBtn("DROP ALL PALLETS", DropAllPalletsWithTP)

print("✅ Auto Generator listo - Usa el botón para activar")