--[[
    Touch Fling Pro – Mobile Optimized
    • Small draggable UI (300×220)
    • Minimize to floating icon
    • Fling ON/OFF with power slider
    • Target selection, Head Sit, Teleports
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Anti-detection (opcional)
if not ReplicatedStorage:FindFirstChild("fling_check") then
    local d = Instance.new("Decal")
    d.Name = "fling_check"
    d.Parent = ReplicatedStorage
end

-- --------------------------------------------------
-- UI Components
-- --------------------------------------------------
local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        inst[k] = v
    end
    return inst
end

local ScreenGui = create("ScreenGui", {
    Name = "FlingPro",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = CoreGui,
})

-- Tema
local BG = Color3.fromRGB(28, 28, 32)
local ACCENT = Color3.fromRGB(90, 130, 255)
local TEXT = Color3.fromRGB(235, 235, 240)

-- Icono minimizado
local MinimizedIcon = create("ImageButton", {
    Size = UDim2.new(0, 48, 0, 48),
    Position = UDim2.new(0, 20, 0, 20),
    BackgroundColor3 = BG,
    Image = "",
    Visible = false,
    Parent = ScreenGui,
})
create("UICorner", {CornerRadius = UDim.new(1,0)}, {Parent = MinimizedIcon})
create("UIStroke", {Color = ACCENT, Thickness = 1.5}, {Parent = MinimizedIcon})
local iconLabel = create("TextLabel", {
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Text = "⚡",
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    TextColor3 = ACCENT,
    Parent = MinimizedIcon,
})
MinimizedIcon.MouseButton1Click:Connect(function()
    MinimizedIcon.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0,0,0,0)
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Size = UDim2.new(0,300,0,220)}):Play()
end)

-- Arrastre del icono
local dragIcon = false
MinimizedIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragIcon = true
        local start = input.Position
        local startPos = MinimizedIcon.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragIcon = false end
        end)
        UserInputService.InputChanged:Connect(function(move)
            if move == input and dragIcon then
                local delta = move.Position - start
                MinimizedIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
end)

-- Ventana principal
local MainFrame = create("Frame", {
    Name = "Main",
    Size = UDim2.new(0, 300, 0, 220),
    Position = UDim2.new(0.5, -150, 0.5, -110),
    BackgroundColor3 = BG,
    ClipsDescendants = true,
    Parent = ScreenGui,
})
create("UICorner", {CornerRadius = UDim.new(0,10)}, {Parent = MainFrame})

-- Sombra
local shadow = create("ImageLabel", {
    Image = "rbxassetid://1316045217",
    ImageColor3 = Color3.new(0,0,0),
    ImageTransparency = 0.45,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(10,10,118,118),
    Size = UDim2.new(1,40,1,40),
    Position = UDim2.new(0,-20,0,-20),
    BackgroundTransparency = 1,
    ZIndex = -1,
    Parent = MainFrame,
})

-- Barra superior
local TopBar = create("Frame", {
    Size = UDim2.new(1,0,0,34),
    BackgroundColor3 = Color3.fromRGB(35,35,40),
    Parent = MainFrame,
})
create("UICorner", {CornerRadius = UDim.new(0,10)}, {Parent = TopBar})
create("Frame", {
    Size = UDim2.new(1,0,0,10),
    Position = UDim2.new(0,0,1,-10),
    BackgroundColor3 = TopBar.BackgroundColor3,
    BorderSizePixel = 0,
    Parent = TopBar,
})

local title = create("TextLabel", {
    Text = "⚡ Touch Fling Pro",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = TEXT,
    BackgroundTransparency = 1,
    Position = UDim2.new(0,10,0,0),
    Size = UDim2.new(1,-100,1,0),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopBar,
})

-- Botón minimizar
local MinBtn = create("TextButton", {
    Text = "–",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = TEXT,
    BackgroundTransparency = 1,
    Size = UDim2.new(0,36,1,0),
    Position = UDim2.new(1,-72,0,0),
    Parent = TopBar,
})
MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedIcon.Visible = true
end)

-- Botón cerrar
local CloseBtn = create("TextButton", {
    Text = "✕",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255,100,100),
    BackgroundTransparency = 1,
    Size = UDim2.new(0,36,1,0),
    Position = UDim2.new(1,-36,0,0),
    Parent = TopBar,
})
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Arrastre de la ventana
local dragging = false
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        local start = input.Position
        local startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(move)
            if move == input and dragging then
                local delta = move.Position - start
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
end)

-- Contenido
local Content = create("ScrollingFrame", {
    Size = UDim2.new(1,-10,1,-40),
    Position = UDim2.new(0,5,0,38),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = ACCENT,
    CanvasSize = UDim2.new(0,0,0,0),
    Parent = MainFrame,
})
local layout = create("UIListLayout", {
    Padding = UDim.new(0,6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = Content,
})
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

-- Función para crear botones
local function addButton(text, callback)
    local btn = create("TextButton", {
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = TEXT,
        BackgroundColor3 = ACCENT,
        Size = UDim2.new(1,-6,0,30),
        LayoutOrder = #Content:GetChildren(),
        Parent = Content,
    })
    create("UICorner", {CornerRadius = UDim.new(0,6)}, {Parent = btn})
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function addToggle(text, default, callback)
    local state = default
    local holder = create("Frame", {
        Size = UDim2.new(1,-6,0,32),
        BackgroundColor3 = Color3.fromRGB(22,22,26),
        LayoutOrder = #Content:GetChildren(),
        Parent = Content,
    })
    create("UICorner", {CornerRadius = UDim.new(0,6)}, {Parent = holder})

    create("TextLabel", {
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = TEXT,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,8,0,0),
        Size = UDim2.new(1,-70,1,0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = holder,
    })

    local switch = create("TextButton", {
        Text = "",
        Size = UDim2.new(0,40,0,20),
        Position = UDim2.new(1,-50,0.5,-10),
        BackgroundColor3 = state and ACCENT or Color3.fromRGB(60,60,65),
        Parent = holder,
    })
    create("UICorner", {CornerRadius = UDim.new(1,0)}, {Parent = switch})

    local knob = create("Frame", {
        Size = UDim2.new(0,16,0,16),
        Position = state and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8),
        BackgroundColor3 = Color3.new(1,1,1),
        Parent = switch,
    })
    create("UICorner", {CornerRadius = UDim.new(1,0)}, {Parent = knob})

    switch.MouseButton1Click:Connect(function()
        state = not state
        local goalCol = state and ACCENT or Color3.fromRGB(60,60,65)
        local goalPos = state and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = goalCol}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = goalPos}):Play()
        callback(state)
    end)
end

local function addSlider(text, min, max, default, callback)
    local holder = create("Frame", {
        Size = UDim2.new(1,-6,0,42),
        BackgroundColor3 = Color3.fromRGB(22,22,26),
        LayoutOrder = #Content:GetChildren(),
        Parent = Content,
    })
    create("UICorner", {CornerRadius = UDim.new(0,6)}, {Parent = holder})

    local label = create("TextLabel", {
        Text = text .. ": " .. tostring(default),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = TEXT,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,8,0,2),
        Size = UDim2.new(1,-16,0,16),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = holder,
    })

    local bar = create("Frame", {
        Size = UDim2.new(1,-16,0,6),
        Position = UDim2.new(0,8,1,-14),
        BackgroundColor3 = Color3.fromRGB(50,50,55),
        Parent = holder,
    })
    create("UICorner", {CornerRadius = UDim.new(1,0)}, {Parent = bar})

    local fill = create("Frame", {
        Size = UDim2.new((default-min)/(max-min),0,1,0),
        BackgroundColor3 = ACCENT,
        Parent = bar,
    })
    create("UICorner", {CornerRadius = UDim.new(1,0)}, {Parent = fill})

    local draggingSlider = false
    local function updateFromX(x)
        local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max-min)*rel)
        fill.Size = UDim2.new(rel,0,1,0)
        label.Text = text .. ": " .. tostring(val)
        callback(val)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
end

-- --------------------------------------------------
-- LÓGICA DEL FLING Y DEMÁS
-- --------------------------------------------------
local flingActive = false
local flingPower = 10000

addToggle("Touch Fling", false, function(state)
    flingActive = state
    if state then
        task.spawn(function()
            while flingActive do
                RunService.Heartbeat:Wait()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local vel = hrp.Velocity
                    hrp.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
                    RunService.RenderStepped:Wait()
                    hrp.Velocity = vel
                    RunService.Stepped:Wait()
                    hrp.Velocity = vel + Vector3.new(0, 0.1, 0)
                    task.wait()
                    hrp.Velocity = vel
                end
            end
        end)
    end
end)

addSlider("Fling Power", 1000, 50000, 10000, function(val)
    flingPower = val
end)

-- Target selection
local currentTarget = nil

addButton("🎯 Select Target (click player)", function()
    local t = Mouse.Target
    if t and t.Parent then
        local plr = Players:GetPlayerFromCharacter(t.Parent)
        if plr and plr ~= LocalPlayer then
            currentTarget = plr
        end
    end
end)

addButton("🧑‍💻 Head Sit Target", function()
    if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("Head") then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = currentTarget.Character.Head.CFrame * CFrame.new(0, 2, 0)
        end
    end
end)

addButton("📍 TP to Target", function()
    if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = currentTarget.Character.HumanoidRootPart.CFrame
        end
    end
end)

addButton("🗑 Clear Target", function()
    currentTarget = nil
end)

addButton("🌌 TP to Sky", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position.X, 500, char.HumanoidRootPart.Position.Z)
    end
end)

addButton("🖱 TP to Mouse", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hit = Mouse.Hit
        if hit then
            char.HumanoidRootPart.CFrame = CFrame.new(hit.Position.X, hit.Position.Y + 5, hit.Position.Z)
        end
    end
end)
