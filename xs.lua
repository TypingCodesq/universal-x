local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Workspace = game:GetService("Workspace")

local function log(level, msg)
    local prefix = "[" .. level .. "] "
    if level == "ERROR" then
        warn(prefix .. msg)
    elseif level == "INFO" then
        print(prefix .. msg)
    elseif level == "SUCCESS" then
        print(prefix .. "✓ " .. msg)
    end
end

local function errHandler(func, name)
    return function(...)
        local ok, res = pcall(func, ...)
        if not ok then
            log("ERROR", name .. " failed: " .. tostring(res))
        end
        return res
    end
end

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
if not isMobile then
    local vp = Camera.ViewportSize
    isMobile = math.min(vp.X, vp.Y) < 600
end
log("INFO", "Device mode: " .. (isMobile and "MOBILE" or "DESKTOP"))

local Theme = {
    Background = Color3.fromRGB(22, 22, 26),
    Sidebar = Color3.fromRGB(28, 28, 34),
    Panel = Color3.fromRGB(32, 32, 38),
    Accent = Color3.fromRGB(90, 130, 255),
    Text = Color3.fromRGB(235, 235, 240),
    SubText = Color3.fromRGB(160, 160, 170),
    Stroke = Color3.fromRGB(45, 45, 52),
}

local FONT = Enum.Font.GothamBold
local FONT_BODY = Enum.Font.Gotham
local BTN_HEIGHT = isMobile and 36 or 30
local FONT_SIZE = isMobile and 13 or 12
local FRAME_W = isMobile and 360 or 320
local FRAME_H = isMobile and 520 or 460

local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        pcall(function() inst[k] = v end)
    end
    return inst
end

local ScreenGui = create("ScreenGui", {
    Name = "VDUnified",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = CoreGui,
})
log("SUCCESS", "ScreenGui created")

local MinimizedIcon = create("ImageButton", {
    Size = UDim2.new(0, 56, 0, 56),
    Position = UDim2.new(0, 20, 0, 20),
    BackgroundColor3 = Theme.Panel,
    Image = "",
    Visible = false,
    Parent = ScreenGui,
})
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = MinimizedIcon
local iconStroke = Instance.new("UIStroke")
iconStroke.Color = Theme.Accent
iconStroke.Thickness = 2
iconStroke.Parent = MinimizedIcon
create("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "VD",
    Font = FONT,
    TextSize = 18,
    TextColor3 = Theme.Accent,
    Parent = MinimizedIcon,
})

local MainFrame = create("Frame", {
    Name = "Main",
    Size = UDim2.new(0, FRAME_W, 0, FRAME_H),
    Position = UDim2.new(0.5, -FRAME_W/2, 0.5, -FRAME_H/2),
    BackgroundColor3 = Theme.Background,
    ClipsDescendants = true,
    Parent = ScreenGui,
})
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainFrame
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Theme.Stroke
mainStroke.Thickness = 1
mainStroke.Parent = MainFrame

local TopBar = create("Frame", {
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundColor3 = Theme.Sidebar,
    Parent = MainFrame,
})
local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = TopBar
create("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = Theme.Sidebar,
    BorderSizePixel = 0,
    Parent = TopBar,
})

create("TextLabel", {
    Text = "VIOLENCE DISTRICT",
    Font = FONT,
    TextSize = isMobile and 14 or 13,
    TextColor3 = Theme.Text,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 12, 0, 0),
    Size = UDim2.new(1, -100, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopBar,
})

local MinBtn = create("TextButton", {
    Text = "–",
    Font = FONT,
    TextSize = 20,
    TextColor3 = Theme.SubText,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 40, 1, 0),
    Position = UDim2.new(1, -82, 0, 0),
    Parent = TopBar,
})

local CloseBtn = create("TextButton", {
    Text = "✕",
    Font = FONT,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255, 100, 100),
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 40, 1, 0),
    Position = UDim2.new(1, -42, 0, 0),
    Parent = TopBar,
})

MinimizedIcon.MouseButton1Click:Connect(function()
    MinimizedIcon.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Size = UDim2.new(0, FRAME_W, 0, FRAME_H)}):Play()
end)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedIcon.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    log("INFO", "UI destroyed by user")
end)

local TabBar = create("Frame", {
    Size = UDim2.new(1, 0, 0, 34),
    Position = UDim2.new(0, 0, 0, 42),
    BackgroundColor3 = Theme.Panel,
    Parent = MainFrame,
})

local tabButtons = {}
local currentTab = nil

local function addTab(name)
    local btn = create("TextButton", {
        Text = name,
        Font = FONT_BODY,
        TextSize = 12,
        TextColor3 = Theme.SubText,
        BackgroundColor3 = Theme.Panel,
        Size = UDim2.new(0, 70, 1, -4),
        Position = UDim2.new(0, 4 + (#tabButtons * 74), 0, 2),
        Parent = TabBar,
    })
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local page = create("ScrollingFrame", {
        Size = UDim2.new(1, -12, 1, -80),
        Position = UDim2.new(0, 6, 0, 80),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = #tabButtons == 0,
        Parent = MainFrame,
    })
    local pageLayout = create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = page,
    })
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 12)
    end)

    btn.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.btn.BackgroundColor3 = Theme.Panel
            currentTab.btn.TextColor3 = Theme.SubText
            currentTab.page.Visible = false
        end
        currentTab = {btn = btn, page = page}
        btn.BackgroundColor3 = Theme.Accent
        btn.TextColor3 = Theme.Text
        page.Visible = true
    end)

    table.insert(tabButtons, btn)
    if #tabButtons == 1 then
        currentTab = {btn = btn, page = page}
        btn.BackgroundColor3 = Theme.Accent
        btn.TextColor3 = Theme.Text
    end
    return page
end

local SurvivorPage = addTab("Survivor")
local KillerPage = addTab("Killer")
local ESPPage = addTab("ESP")
local MovePage = addTab("Move")
local MiscPage = addTab("Misc")

local function addSection(page, text)
    local frame = create("Frame", {
        Size = UDim2.new(1, -8, 0, 22),
        BackgroundTransparency = 1,
        LayoutOrder = #page:GetChildren(),
        Parent = page,
    })
    create("TextLabel", {
        Text = text,
        Font = FONT,
        TextSize = FONT_SIZE - 1,
        TextColor3 = Theme.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })
end

local function addToggle(page, text, default, callback)
    local state = default
    local holder = create("Frame", {
        Size = UDim2.new(1, -8, 0, BTN_HEIGHT),
        BackgroundColor3 = Color3.fromRGB(28, 28, 34),
        LayoutOrder = #page:GetChildren(),
        Parent = page,
    })
    local hc = Instance.new("UICorner")
    hc.CornerRadius = UDim.new(0, 8)
    hc.Parent = holder

    create("TextLabel", {
        Text = text,
        Font = FONT_BODY,
        TextSize = FONT_SIZE,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -70, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = holder,
    })

    local switch = create("TextButton", {
        Text = "",
        Size = UDim2.new(0, 44, 0, 22),
        Position = UDim2.new(1, -54, 0.5, -11),
        BackgroundColor3 = state and Theme.Accent or Theme.Stroke,
        Parent = holder,
    })
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(1, 0)
    sc.Parent = switch

    local knob = create("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
        BackgroundColor3 = Color3.new(1, 1, 1),
        Parent = switch,
    })
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    switch.MouseButton1Click:Connect(function()
        state = not state
        local goalCol = state and Theme.Accent or Theme.Stroke
        local goalPos = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = goalCol}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = goalPos}):Play()
        callback(state)
    end)
end

local function addSlider(page, text, min, max, default, callback)
    local holder = create("Frame", {
        Size = UDim2.new(1, -8, 0, BTN_HEIGHT + 6),
        BackgroundColor3 = Color3.fromRGB(28, 28, 34),
        LayoutOrder = #page:GetChildren(),
        Parent = page,
    })
    local hc = Instance.new("UICorner")
    hc.CornerRadius = UDim.new(0, 8)
    hc.Parent = holder

    local label = create("TextLabel", {
        Text = text .. ": " .. tostring(default),
        Font = FONT_BODY,
        TextSize = FONT_SIZE - 1,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 2),
        Size = UDim2.new(1, -16, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = holder,
    })

    local bar = create("Frame", {
        Size = UDim2.new(1, -16, 0, 6),
        Position = UDim2.new(0, 8, 1, -14),
        BackgroundColor3 = Color3.fromRGB(50, 50, 55),
        Parent = holder,
    })
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = bar

    local fill = create("Frame", {
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        Parent = bar,
    })
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = fill

    local draggingSlider = false
    local function updateFromX(x)
        local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * rel)
        fill.Size = UDim2.new(rel, 0, 1, 0)
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

local function addButton(page, text, callback)
    local btn = create("TextButton", {
        Text = text,
        Font = FONT,
        TextSize = FONT_SIZE,
        TextColor3 = Theme.Text,
        BackgroundColor3 = Theme.Accent,
        Size = UDim2.new(1, -8, 0, BTN_HEIGHT),
        LayoutOrder = #page:GetChildren(),
        Parent = page,
    })
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = btn
    btn.MouseButton1Click:Connect(errHandler(callback, text))
    return btn
end

local function dragElement(element, target)
    local dragging, start, startPos
    element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - start
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

dragElement(TopBar, MainFrame)
dragElement(MinimizedIcon, MinimizedIcon)

_G.FeatureState = _G.FeatureState or {}
_G.RoleData = _G.RoleData or {TeamName = "SURVIVORS"}

local function getRole()
    return string.upper(_G.RoleData.TeamName or "")
end

local TouchID = 8822
local ActionPath = "Survivor-mob.Controls.action.check"

local function GetActionTarget()
    local current = LocalPlayer:WaitForChild("PlayerGui")
    for segment in string.gmatch(ActionPath, "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function tapActionButton()
    local b = GetActionTarget()
    if not b or not b:IsA("GuiObject") then
        log("ERROR", "Action button not found")
        return
    end
    local pos = b.AbsolutePosition
    local size = b.AbsoluteSize
    local inset = GuiService:GetGuiInset()
    local cx, cy = pos.X + size.X/2 + inset.X, pos.Y + size.Y/2 + inset.Y
    pcall(function()
        VirtualInputManager:SendTouchEvent(TouchID, 0, cx, cy)
        task.wait(0.02)
        VirtualInputManager:SendTouchEvent(TouchID, 2, cx, cy)
    end)
end

local function getGenerators()
    local gens = {}
    pcall(function()
        local map = Workspace:FindFirstChild("Map")
        if map then
            for _, v in pairs(map:GetDescendants()) do
                if v.Name == "Generator" then table.insert(gens, v) end
            end
        end
    end)
    return gens
end

local function getPallets()
    local pallets = {}
    pcall(function()
        local map = Workspace:FindFirstChild("Map")
        if map then
            for _, v in pairs(map:GetDescendants()) do
                if v.Name == "Pallet" or v.Name == "Palletwrong" then table.insert(pallets, v) end
            end
        end
    end)
    return pallets
end

local function getGeneratorProgress(gen)
    local progress = 0
    if gen:GetAttribute("Progress") then
        progress = gen:GetAttribute("Progress")
    elseif gen:GetAttribute("RepairProgress") then
        progress = gen:GetAttribute("RepairProgress")
    end
    progress = (progress > 1) and progress / 100 or progress
    return math.clamp(progress, 0, 1)
end

local function getPalletPosition(pallet)
    if pallet:IsA("Model") then
        local prim = pallet.PrimaryPart
        if prim then return prim.Position end
        for _, c in pairs(pallet:GetChildren()) do
            if c:IsA("BasePart") then return c.Position end
        end
    elseif pallet:IsA("BasePart") then
        return pallet.Position
    end
    return nil
end

local autoSkillcheckEnabled = false
local autoSkillConnection = nil

local function startAutoSkillcheck()
    if autoSkillcheckEnabled then return end
    autoSkillcheckEnabled = true
    log("INFO", "Starting Auto Skillcheck")
    
    local prompt = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SkillCheckPromptGui", 10)
    if not prompt then
        log("ERROR", "SkillCheckPromptGui not found")
        return
    end
    local check = prompt:WaitForChild("Check", 10)
    if not check then
        log("ERROR", "Check not found")
        return
    end
    local line = check:WaitForChild("Line")
    local goal = check:WaitForChild("Goal")
    
    autoSkillConnection = check:GetPropertyChangedSignal("Visible"):Connect(function()
        if not autoSkillcheckEnabled then return end
        if check.Visible then
            local lr = line.Rotation % 360
            local gr = goal.Rotation % 360
            local ss = (gr + 101) % 360
            local se = (gr + 115) % 360
            
            if (ss > se and (lr >= ss or lr <= se)) or (lr >= ss and lr <= se) then
                tapActionButton()
                log("SUCCESS", "Skillcheck perfect")
            end
        end
    end)
    log("SUCCESS", "Auto Skillcheck enabled")
end

local function stopAutoSkillcheck()
    autoSkillcheckEnabled = false
    if autoSkillConnection then
        autoSkillConnection:Disconnect()
        autoSkillConnection = nil
    end
    log("INFO", "Auto Skillcheck disabled")
end

local autoGeneEnabled = false
local autoGeneConnection = nil

local function getClosestGeneratorWithPoints()
    local char = LocalPlayer.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local bestGen, bestDist, bestPoints = nil, math.huge, {}
    for _, gen in pairs(getGenerators()) do
        if getGeneratorProgress(gen) < 1 then
            local pts = {}
            for i = 1, 4 do
                local pt = gen:FindFirstChild("GeneratorPoint" .. i)
                if pt then table.insert(pts, pt) end
            end
            if #pts >= 2 then
                local minD = math.huge
                for _, pt in pairs(pts) do
                    local d = (root.Position - pt.Position).Magnitude
                    if d < minD then minD = d end
                end
                if minD < bestDist then
                    bestDist = minD
                    bestGen = gen
                    bestPoints = pts
                end
            end
        end
    end
    
    if bestGen then return bestGen, bestPoints end
    return nil
end

local function startRepairAtPoint(point)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    root.CFrame = CFrame.new(point.Position + Vector3.new(1.5, 0, 0))
    task.wait(0.1)
    tapActionButton()
    task.wait(0.05)
end

local function autoGeneLoop()
    while autoGeneEnabled do
        local gen, pts = getClosestGeneratorWithPoints()
        if not gen then
            task.wait(0.5)
            continue
        end
        
        log("INFO", "Starting generator: " .. tostring(gen))
        startRepairAtPoint(pts[1])
        task.wait(0.8)
        startRepairAtPoint(pts[2])
        task.wait(0.8)
        if pts[3] then
            startRepairAtPoint(pts[3])
            task.wait(0.8)
        end
        startRepairAtPoint(pts[1])
        
        while autoGeneEnabled and getGeneratorProgress(gen) < 1 do
            task.wait(0.5)
        end
        log("SUCCESS", "Generator completed")
        task.wait(0.5)
    end
end

local function startAutoGene()
    if autoGeneEnabled then return end
    autoGeneEnabled = true
    log("INFO", "Starting Auto Generator")
    autoGeneConnection = task.spawn(autoGeneLoop)
end

local function stopAutoGene()
    autoGeneEnabled = false
    if autoGeneConnection then
        task.cancel(autoGeneConnection)
        autoGeneConnection = nil
    end
    log("INFO", "Auto Generator disabled")
end

local function dropAllPallets()
    local char = LocalPlayer.Character
    if not char then
        log("ERROR", "No character to drop pallets")
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then
        log("ERROR", "No HumanoidRootPart")
        return
    end
    
    local pallets = getPallets()
    log("INFO", "Dropping " .. #pallets .. " pallets")
    
    task.spawn(function()
        local dropped = 0
        for _, pallet in pairs(pallets) do
            if pallet and pallet.Parent then
                local pos = getPalletPosition(pallet)
                if pos then
                    root.CFrame = CFrame.new(pos + Vector3.new(2, 0, 0))
                    task.wait(0.1)
                    for i = 1, 3 do
                        tapActionButton()
                        task.wait(0.05)
                    end
                    dropped = dropped + 1
                    task.wait(0.2)
                end
            end
        end
        log("SUCCESS", "Dropped " .. dropped .. " pallets")
    end)
end

local godModeEnabled = false

local function godModeLoop()
    while godModeEnabled do
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.MaxHealth = 1e9
                hum.Health = 1e9
            end
        end
        task.wait(0.1)
    end
end

local function startGodMode()
    godModeEnabled = true
    log("INFO", "God Mode enabled")
    task.spawn(godModeLoop)
end

local function stopGodMode()
    godModeEnabled = false
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.MaxHealth = 100
            hum.Health = 100
        end
    end
    log("INFO", "God Mode disabled")
end

local selfHealEnabled = false
local healRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Healing"):WaitForChild("SkillCheckResultEvent")

local function selfHealLoop()
    while selfHealEnabled do
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health < 90 then
                healRemote:FireServer("success", 1, char)
            end
        end
        task.wait(0.5)
    end
end

local function startSelfHeal()
    selfHealEnabled = true
    log("INFO", "Self Heal enabled")
    task.spawn(selfHealLoop)
end

local function stopSelfHeal()
    selfHealEnabled = false
    log("INFO", "Self Heal disabled")
end

local autoHealEnabled = false

local function autoHealLoop()
    while autoHealEnabled do
        local char = LocalPlayer.Character
        if not char then task.wait(0.5) continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then task.wait(0.5) continue end
        
        for _, plr in pairs(Players:GetPlayers()) do
            if not autoHealEnabled then break end
            if plr ~= LocalPlayer and plr.Team == LocalPlayer.Team and plr.Character then
                local targetHum = plr.Character:FindFirstChild("Humanoid")
                if targetHum and targetHum.Health <= 50 then
                    local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        root.CFrame = CFrame.new(targetRoot.Position + Vector3.new(2, 0, 0))
                        task.wait(0.3)
                        healRemote:FireServer("success", 1, plr.Character)
                        task.wait(0.5)
                    end
                end
            end
        end
        task.wait(1)
    end
end

local function startAutoHeal()
    if autoHealEnabled then return end
    autoHealEnabled = true
    log("INFO", "Team Heal enabled")
    task.spawn(autoHealLoop)
end

local function stopAutoHeal()
    autoHealEnabled = false
    log("INFO", "Team Heal disabled")
end

local espPlayers = {}
local espGenerators = {}

local function createPlayerESP(plr)
    if plr == LocalPlayer then return end
    if espPlayers[plr] then return end
    local char = plr.Character
    if not char then return end
    
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = char
    highlight.Parent = CoreGui
    
    local head = char:FindFirstChild("Head")
    if head then
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = plr.Name
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 13
        label.TextStrokeTransparency = 0
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Parent = billboard
        
        espPlayers[plr] = {highlight = highlight, billboard = billboard}
    else
        espPlayers[plr] = {highlight = highlight}
    end
end

local function removePlayerESP(plr)
    local data = espPlayers[plr]
    if data then
        if data.highlight then data.highlight:Destroy() end
        if data.billboard then data.billboard:Destroy() end
        espPlayers[plr] = nil
    end
end

local function updatePlayerESPColors()
    if not _G.FeatureState.espPlayer then return end
    for plr, data in pairs(espPlayers) do
        if data.highlight and data.highlight.Parent then
            local role = plr.Team and string.upper(plr.Team.Name or "") or ""
            local color = role == "KILLER" and Color3.fromRGB(255, 0, 0) or
                         role == "SURVIVORS" and Color3.fromRGB(0, 170, 255) or
                         Color3.fromRGB(255, 255, 255)
            data.highlight.FillColor = color
            data.highlight.OutlineColor = color
            if data.billboard then
                local label = data.billboard:FindFirstChildOfClass("TextLabel")
                if label then label.TextColor3 = color end
            end
        else
            removePlayerESP(plr)
        end
    end
end

local function startPlayerESP()
    _G.FeatureState.espPlayer = true
    log("INFO", "Player ESP enabled")
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            createPlayerESP(plr)
        end
    end
    updatePlayerESPColors()
end

local function stopPlayerESP()
    _G.FeatureState.espPlayer = false
    log("INFO", "Player ESP disabled")
    for plr in pairs(espPlayers) do
        removePlayerESP(plr)
    end
end

local function createGeneratorESP(gen)
    if espGenerators[gen] then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(150, 0, 200)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = gen
    highlight.Parent = CoreGui
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Parent = gen
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextSize = 14
    label.Font = Enum.Font.SourceSansBold
    label.TextStrokeTransparency = 0
    label.Text = ""
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Parent = billboard
    
    espGenerators[gen] = {highlight = highlight, billboard = billboard, label = label}
end

local function removeGeneratorESP(gen)
    local data = espGenerators[gen]
    if data then
        if data.highlight then data.highlight:Destroy() end
        if data.billboard then data.billboard:Destroy() end
        espGenerators[gen] = nil
    end
end

local function updateGeneratorESP()
    if not _G.FeatureState.espGenerator then return end
    for _, gen in pairs(getGenerators()) do
        local progress = getGeneratorProgress(gen)
        local percent = math.floor(progress * 100)
        local color = Color3.fromRGB(150, 0, 200):Lerp(Color3.fromRGB(0, 255, 0), progress)
        
        createGeneratorESP(gen)
        local data = espGenerators[gen]
        if data then
            data.highlight.FillColor = color
            data.highlight.OutlineColor = color
            data.label.Text = _G.FeatureState.generatorProgress and (percent .. "%") or ""
            data.label.TextColor3 = color
        end
    end
end

local function startGeneratorESP()
    _G.FeatureState.espGenerator = true
    log("INFO", "Generator ESP enabled")
    updateGeneratorESP()
end

local function stopGeneratorESP()
    _G.FeatureState.espGenerator = false
    log("INFO", "Generator ESP disabled")
    for gen in pairs(espGenerators) do
        removeGeneratorESP(gen)
    end
end

local aimbotEnabled = false

local function isValidAimTarget(plr)
    local role = getRole()
    if role == "SPECTATOR" then return false end
    local targetRole = plr.Team and string.upper(plr.Team.Name or "") or ""
    
    if role == "SURVIVORS" then
        return targetRole == "KILLER"
    elseif role == "KILLER" then
        if targetRole ~= "SURVIVORS" then return false end
        local char = plr.Character
        if not char then return false end
        local hum = char:FindFirstChild("Humanoid")
        if hum and (hum.Health <= 0 or hum.PlatformStand) then return false end
        return true
    end
    return false
end

local function findAimTarget()
    local closest = nil
    local closestDist = 200
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isValidAimTarget(plr) and plr.Character then
            local targetPart = plr.Character:FindFirstChild("UpperTorso") or 
                              plr.Character:FindFirstChild("Torso") or 
                              plr.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local dist = (Camera.CFrame.Position - targetPart.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = targetPart
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if not aimbotEnabled then return end
    local target = findAimTarget()
    if target then
        local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position)
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 0.15)
    end
end)

local function startAimbot()
    aimbotEnabled = true
    log("INFO", "Aimbot enabled")
end

local function stopAimbot()
    aimbotEnabled = false
    log("INFO", "Aimbot disabled")
end

local flyEnabled = false
local flySpeed = 50
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil

local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    bodyVelocity.Parent = hrp
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
    bodyGyro.P = 1000
    bodyGyro.Parent = hrp
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyEnabled then return end
        bodyGyro.CFrame = Camera.CFrame
        local vel = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel += Camera.CFrame.LookVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel += Camera.CFrame.LookVector * -flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel += Camera.CFrame.RightVector * -flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel += Camera.CFrame.RightVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel += Vector3.new(0, flySpeed, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel += Vector3.new(0, -flySpeed, 0) end
        bodyVelocity.Velocity = vel
        hum.PlatformStand = true
    end)
    log("INFO", "Fly enabled")
end

local function stopFly()
    if flyConnection then flyConnection:Disconnect() end
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
    log("INFO", "Fly disabled")
end

local noclipEnabled = false
local noclipConnection = nil

local function startNoclip()
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipEnabled then return end
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
    log("INFO", "Noclip enabled")
end

local function stopNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
    log("INFO", "Noclip disabled")
end

local function fullbrightUpdate()
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
end
fullbrightUpdate()
RunService.Heartbeat:Connect(fullbrightUpdate)

addSection(SurvivorPage, "GENERATOR")
addToggle(SurvivorPage, "Auto Generator (Multi)", false, function(v) if v then startAutoGene() else stopAutoGene() end end)
addToggle(SurvivorPage, "Auto Skillcheck", false, function(v) if v then startAutoSkillcheck() else stopAutoSkillcheck() end end)
addButton(SurvivorPage, "Drop All Pallets", dropAllPallets)

addSection(SurvivorPage, "HEALING")
addToggle(SurvivorPage, "Auto Heal Team", false, function(v) if v then startAutoHeal() else stopAutoHeal() end end)
addToggle(SurvivorPage, "Auto Heal Self", false, function(v) if v then startSelfHeal() else stopSelfHeal() end end)

addSection(KillerPage, "COMBAT")
addToggle(KillerPage, "Aimbot", false, function(v) if v then startAimbot() else stopAimbot() end end)

addSection(ESPPage, "VISUALS")
addToggle(ESPPage, "ESP Players", false, function(v) if v then startPlayerESP() else stopPlayerESP() end end)
addToggle(ESPPage, "ESP Generators", false, function(v) if v then startGeneratorESP() else stopGeneratorESP() end end)
addToggle(ESPPage, "Show Progress", false, function(v) _G.FeatureState.generatorProgress = v; updateGeneratorESP() end)

addSection(MovePage, "MOVEMENT")
addToggle(MovePage, "Fly (WASD)", false, function(v) flyEnabled = v; if v then startFly() else stopFly() end end)
addSlider(MovePage, "Fly Speed", 10, 200, 50, function(v) flySpeed = v end)
addToggle(MovePage, "Noclip", false, function(v) noclipEnabled = v; if v then startNoclip() else stopNoclip() end end)
addToggle(MovePage, "Speed Boost", false, function(v)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v and 30 or 16 end
    end
end)
addToggle(MovePage, "Infinite Jump", false, function(v)
    if v then
        UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

addSection(MiscPage, "GOD MODE")
addToggle(MiscPage, "God Mode (No Death)", false, function(v) if v then startGodMode() else stopGodMode() end end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        if _G.FeatureState.espPlayer then createPlayerESP(plr) end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    removePlayerESP(plr)
end)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer and plr.Character then
        plr.CharacterAdded:Connect(function(char)
            task.wait(1)
            if _G.FeatureState.espPlayer then createPlayerESP(plr) end
        end)
    end
end

RunService.RenderStepped:Connect(function()
    if _G.FeatureState.espPlayer then updatePlayerESPColors() end
    if _G.FeatureState.espGenerator then updateGeneratorESP() end
end)

log("SUCCESS", "Violence District script fully loaded")
