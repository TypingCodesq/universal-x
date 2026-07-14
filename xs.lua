-- AUTO GENERATOR FIX (Tap + Alternar lados)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local autoGenActive = false
local genConn = nil

local function GetRootPart(obj)
    if not obj then return nil end
    if obj:FindFirstChild("HumanoidRootPart") then return obj.HumanoidRootPart end
    if obj.PrimaryPart then return obj.PrimaryPart end
    for _, part in pairs(obj:GetDescendants()) do
        if part:IsA("BasePart") and part.Size.Magnitude > 3 then
            return part
        end
    end
    return nil
end

local function findBestGenerator()
    local char = player.Character
    if not char then return nil, {} end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, {} end

    local bestGen, bestDist, bestPoints = nil, math.huge, {}

    for _, gen in pairs(Workspace:GetDescendants()) do
        if gen.Name == "Generator" then
            local progress = gen:GetAttribute("Progress") or gen:GetAttribute("RepairProgress") or 0
            if progress < 100 then
                local points = {}
                for i = 1, 4 do
                    local p = gen:FindFirstChild("GeneratorPoint"..i)
                    if p then table.insert(points, p) end
                end
                if #points > 0 then
                    for _, p in pairs(points) do
                        local dist = (root.Position - p.Position).Magnitude
                        if dist < bestDist then
                            bestDist = dist
                            bestGen = gen
                            bestPoints = points
                        end
                    end
                end
            end
        end
    end
    return bestGen, bestPoints
end

local function StartAutoGenerator()
    if autoGenActive then return end
    autoGenActive = true

    print("Auto Generator ACTIVADO")

    genConn = RunService.Heartbeat:Connect(function()
        if not autoGenActive then return end

        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local gen, points = findBestGenerator()
        if not gen or #points == 0 then return end

        -- Mover al punto actual
        local targetPoint = points[1]  -- Puedes cambiar a alternar si quieres
        root.CFrame = targetPoint.CFrame * CFrame.new(2.5, 5, 0)

        -- Hacer tap para generar
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.25)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

        task.wait(1.8) -- Tiempo de espera para que avance el generador
    end)
end

local function StopAutoGenerator()
    autoGenActive = false
    if genConn then
        genConn:Disconnect()
        genConn = nil
    end
    print("Auto Generator DESACTIVADO")
end

-- ==================== BOTÓN PARA PROBAR ====================
print("Auto Generator listo. Usa el botón para activar/desactivar.")