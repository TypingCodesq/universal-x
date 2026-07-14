print("VD Script executing...")

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
    if level == "ERROR" then warn("[ERROR] " .. msg)
    elseif level == "INFO" then print("[INFO] " .. msg)
    elseif level == "SUCCESS" then print("[SUCCESS] " .. msg) end
end

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
if not isMobile then
    local vp = Camera.ViewportSize
    isMobile = math.min(vp.X, vp.Y) < 600
end

local Theme = {
    Bg = Color3.fromRGB(18, 18, 22),
    Side = Color3.fromRGB(24, 24, 30),
    Panel = Color3.fromRGB(28, 28, 34),
    Accent = Color3.fromRGB(100, 140, 255),
    Text = Color3.fromRGB(230, 230, 240),
    Sub = Color3.fromRGB(150, 150, 165),
    Stroke = Color3.fromRGB(40, 40, 50),
}

local FONT = Enum.Font.GothamBold
local FONT_BODY = Enum.Font.Gotham
local BTN_H = isMobile and 32 or 28
local FONT_SZ = isMobile and 12 or 11
local W = isMobile and 290 or 300
local H = isMobile and 440 or 460

local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        pcall(function() inst[k] = v end)
    end
    return inst
end

local ScreenGui = create("ScreenGui", {
    Name = "VDMini",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = CoreGui,
})

local FloatIcon = create("ImageButton", {
    Size = UDim2.new(0, 48, 0, 48),
    Position = UDim2.new(0, 16, 0, 16),
    BackgroundColor3 = Theme.Panel,
    Image = "",
    Visible = false,
    Parent = ScreenGui,
})
Instance.new("UICorner", FloatIcon).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", FloatIcon).Color = Theme.Accent
FloatIcon.UIStroke.Thickness = 1.5
create("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "VD",
    Font = FONT,
    TextSize = 16,
    TextColor3 = Theme.Accent,
    Parent = FloatIcon,
})

local Main = create("Frame", {
    Size = UDim2.new(0, W, 0, H),
    Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
    BackgroundColor3 = Theme.Bg,
    ClipsDescendants = true,
    Parent = ScreenGui,
})
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Theme.Stroke
Main.UIStroke.Thickness = 1

local DragBar = create("Frame", {
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = Theme.Side,
    Parent = Main,
})
Instance.new("UICorner", DragBar).CornerRadius = UDim.new(0, 10)
create("Frame", {
    Size = UDim2.new(1, 0, 0, 10),
    Position = UDim2.new(0, 0, 1, -10),
    BackgroundColor3 = Theme.Side,
    BorderSizePixel = 0,
    Parent = DragBar,
})
create("TextLabel", {
    Text = "VD SCRIPT",
    Font = FONT,
    TextSize = 13,
    TextColor3 = Theme.Text,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 0),
    Size = UDim2.new(1, -80, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = DragBar,
})

local HideBtn = create("TextButton", {
    Text = "–",
    Font = FONT,
    TextSize = 18,
    TextColor3 = Theme.Sub,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 36, 1, 0),
    Position = UDim2.new(1, -72, 0, 0),
    Parent = DragBar,
})
HideBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    FloatIcon.Visible = true
end)

local CloseBtn = create("TextButton", {
    Text = "✕",
    Font = FONT,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255, 100, 100),
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 36, 1, 0),
    Position = UDim2.new(1, -36, 0, 0),
    Parent = DragBar,
})
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

FloatIcon.MouseButton1Click:Connect(function()
    FloatIcon.Visible = false
    Main.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {Size = UDim2.new(0, W, 0, H)}):Play()
end)

local TabBar = create("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 0, 36),
    BackgroundColor3 = Theme.Panel,
    Parent = Main,
})

local tabs = {}
local currentTab = nil

local function addTab(name)
    local btn = create("TextButton", {
        Text = name,
        Font = FONT_BODY,
        TextSize = 11,
        TextColor3 = Theme.Sub,
        BackgroundColor3 = Theme.Panel,
        Size = UDim2.new(0, 60, 1, -4),
        Position = UDim2.new(0, 4 + (#tabs * 64), 0, 2),
        Parent = TabBar,
    })
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    local page = create("ScrollingFrame", {
        Size = UDim2.new(1, -8, 1, -70),
        Position = UDim2.new(0, 4, 0, 70),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = #tabs == 0,
        Parent = Main,
    })
    local lay = create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = page,
    })
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 10)
    end)

    btn.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.btn.BackgroundColor3 = Theme.Panel
            currentTab.btn.TextColor3 = Theme.Sub
            currentTab.page.Visible = false
        end
        currentTab = {btn = btn, page = page}
        btn.BackgroundColor3 = Theme.Accent
        btn.TextColor3 = Theme.Text
        page.Visible = true
    end)

    table.insert(tabs, btn)
    if #tabs == 1 then
        currentTab = {btn = btn, page = page}
        btn.BackgroundColor3 = Theme.Accent
        btn.TextColor3 = Theme.Text
    end
    return page
end

local Survivor = addTab("Survivor")
local Killer = addTab("Killer")
local Esp = addTab("ESP")
local Move = addTab("Move")
local Misc = addTab("Misc")

local function sec(page, txt)
    local f = create("Frame", {
        Size = UDim2.new(1, -6, 0, 18),
        BackgroundTransparency = 1,
        LayoutOrder = #page:GetChildren(),
        Parent = page,
    })
    create("TextLabel", {
        Text = txt,
        Font = FONT,
        TextSize = FONT_SZ - 1,
        TextColor3 = Theme.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = f,
    })
end

local function toggle(page, txt, def, cb)
    local state = def
    local h = create("Frame", {
        Size = UDim2.new(1, -6, 0, BTN_H),
        BackgroundColor3 = Color3.fromRGB(24, 24, 30),
        LayoutOrder = #page:GetChildren(),
        Parent = page,
    })
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 6)
    create("TextLabel", {
        Text = txt,
        Font = FONT_BODY,
        TextSize = FONT_SZ,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = h,
    })

    local sw = create("TextButton", {
        Text = "",
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -48, 0.5, -10),
        BackgroundColor3 = state and Theme.Accent or Theme.Stroke,
        Parent = h,
    })
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

    local kn = create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Color3.new(1, 1, 1),
        Parent = sw,
    })
    Instance.new("UICorner", kn).CornerRadius = UDim.new(1, 0)

    sw.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Theme.Stroke}):Play()
        TweenService:Create(kn, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        cb(state)
    end)
end

local function slider(page, txt, min, max, def, cb)
    local h = create("Frame", {
        Size = UDim2.new(1, -6, 0, BTN_H + 4),
        BackgroundColor3 = Color3.fromRGB(24, 24, 30),
        LayoutOrder = #page:GetChildren(),
        Parent = page,
    })
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 6)
    local lbl = create("TextLabel", {
        Text = txt .. ": " .. def,
        Font = FONT_BODY,
        TextSize = FONT_SZ - 1,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 2),
        Size = UDim2.new(1, -16, 0, 12),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = h,
    })

    local bar = create("Frame", {
        Size = UDim2.new(1, -16, 0, 5),
        Position = UDim2.new(0, 8, 1, -12),
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        Parent = h,
    })
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local fill = create("Frame", {
        Size = UDim2.new((def - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        Parent = bar,
    })
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local drag = false
    local function upd(x)
        local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * rel)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        lbl.Text = txt .. ": " .. val
        cb(val)
    end
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true
            upd(i.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            upd(i.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
end

local function button(page, txt, cb)
    local b = create("TextButton", {
        Text = txt,
        Font = FONT,
        TextSize = FONT_SZ,
        TextColor3 = Theme.Text,
        BackgroundColor3 = Theme.Accent,
        Size = UDim2.new(1, -6, 0, BTN_H),
        LayoutOrder = #page:GetChildren(),
        Parent = page,
    })
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function()
        local ok, err = pcall(cb)
        if not ok then log("ERROR", txt .. ": " .. tostring(err)) end
    end)
end

local function makeDraggable(handle, target)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(DragBar, Main)
makeDraggable(FloatIcon, FloatIcon)

_G.FeatureState = _G.FeatureState or {}
_G.RoleData = _G.RoleData or {TeamName = "SURVIVORS"}

local function getRole()
    return string.upper(_G.RoleData.TeamName or "")
end

local genRemote, healRemote

pcall(function()
    genRemote = ReplicatedStorage:WaitForChild("Remotes", 10):WaitForChild("Generator", 10):WaitForChild("SkillCheckResultEvent", 10)
end)
pcall(function()
    healRemote = ReplicatedStorage:WaitForChild("Remotes", 10):WaitForChild("Healing", 10):WaitForChild("SkillCheckResultEvent", 10)
end)

if not genRemote then log("ERROR", "Gen remote missing") end
if not healRemote then log("ERROR", "Heal remote missing") end

local function getGenerators()
    local g = {}
    pcall(function()
        local map = Workspace:FindFirstChild("Map")
        if map then
            for _, v in pairs(map:GetDescendants()) do
                if v.Name == "Generator" then table.insert(g, v) end
            end
        end
    end)
    return g
end

local function genProgress(gen)
    local p = 0
    pcall(function()
        if gen:GetAttribute("Progress") then p = gen:GetAttribute("Progress")
        elseif gen:GetAttribute("RepairProgress") then p = gen:GetAttribute("RepairProgress") end
    end)
    p = tonumber(p) or 0
    return math.clamp(p > 1 and p / 100 or p, 0, 1)
end

-- Check for hooked, tagged, carried, knocked, etc.
local function isCharacterBusy(char)
    if not char then return true end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return true end
    if hum.Health <= 0 or hum.Sit or hum.PlatformStand then return true end
    if char:GetAttribute("Hooked") or char:GetAttribute("Carried") or char:GetAttribute("Tagged") or char:GetAttribute("Knocked") or char:GetAttribute("Grabbed") then return true end
    return false
end

local function tapAction()
    pcall(function()
        local current = LocalPlayer:WaitForChild("PlayerGui")
        for seg in string.gmatch("Survivor-mob.Controls.action.check", "[^%.]+") do
            current = current and current:FindFirstChild(seg)
        end
        if current and current:IsA("GuiObject") then
            local pos = current.AbsolutePosition
            local size = current.AbsoluteSize
            local ins = GuiService:GetGuiInset()
            local cx, cy = pos.X + size.X/2 + ins.X, pos.Y + size.Y/2 + ins.Y
            VirtualInputManager:SendTouchEvent(8822, 0, cx, cy)
            task.wait(0.02)
            VirtualInputManager:SendTouchEvent(8822, 2, cx, cy)
        end
    end)
end

-- Auto Skillcheck: perfect, uses remote directly
local autoSkill = false
local skConn

local function startAutoSkill()
    if autoSkill then return end
    autoSkill = true
    log("INFO", "Auto Skillcheck ON")
    
    local prompt = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SkillCheckPromptGui", 10)
    if not prompt then log("ERROR", "SkillCheckPromptGui missing") return end
    local check = prompt:WaitForChild("Check", 10)
    if not check then return end
    
    skConn = check:GetPropertyChangedSignal("Visible"):Connect(function()
        if not autoSkill or not check.Visible then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local nearGen, genModel, genPoint
        for _, g in pairs(getGenerators()) do
            for i = 1, 4 do
                local pt = g:FindFirstChild("GeneratorPoint" .. i)
                if pt and (root.Position - pt.Position).Magnitude < 10 then
                    nearGen = true
                    genModel = g
                    genPoint = pt
                    break
                end
            end
            if nearGen then break end
        end
        
        if nearGen and genModel and genPoint and genRemote then
            genRemote:FireServer("success", 1, genModel, genPoint)
        elseif healRemote then
            healRemote:FireServer("success", 1, char)
        end
    end)
end

local function stopAutoSkill()
    autoSkill = false
    if skConn then skConn:Disconnect() skConn = nil end
    log("INFO", "Auto Skillcheck OFF")
end

-- Auto Generator: side-to-side perfect using remote
local autoGen = false
local genConn

local function getClosestGenWithPoints()
    local char = LocalPlayer.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    
    local bestGen, bestDist, bestPts = nil, math.huge, {}
    for _, g in pairs(getGenerators()) do
        if genProgress(g) < 1 then
            local pts = {}
            for i = 1, 4 do
                local p = g:FindFirstChild("GeneratorPoint" .. i)
                if p then table.insert(pts, p) end
            end
            if #pts >= 1 then
                for _, p in pairs(pts) do
                    local d = (root.Position - p.Position).Magnitude
                    if d < bestDist then
                        bestDist = d
                        bestGen = g
                        bestPts = pts
                    end
                end
            end
        end
    end
    return bestGen, bestPts
end

local function fireGenRemote(gen, point)
    if not genRemote then return false end
    local ok, err = pcall(function()
        genRemote:FireServer("success", 1, gen, point)
    end)
    if not ok then log("ERROR", "Fire gen remote: "..tostring(err)) end
    return ok
end

local function startAutoGen()
    if autoGen then return end
    autoGen = true
    log("INFO", "Auto Generator ON (Perfect Side-to-Side)")
    
    genConn = RunService.Heartbeat:Connect(function()
        if not autoGen then
            if genConn then genConn:Disconnect() end
            return
        end
        
        local char = LocalPlayer.Character
        if not char then return end
        if isCharacterBusy(char) then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local gen, pts = getClosestGenWithPoints()
        if not gen then return end
        
        -- If only one point, just spam it
        if #pts == 1 then
            root.CFrame = CFrame.new(pts[1].Position + Vector3.new(1.5, 0, 0))
            task.wait(0.15)
            fireGenRemote(gen, pts[1])
            return
        end
        
        -- Side-to-side: point1 -> point2 -> (point3 if exists) -> point1
        root.CFrame = CFrame.new(pts[1].Position + Vector3.new(1.5, 0, 0))
        task.wait(0.1)
        fireGenRemote(gen, pts[1])
        task.wait(0.7)
        
        if not autoGen or genProgress(gen) >= 1 then return end
        root.CFrame = CFrame.new(pts[2].Position + Vector3.new(1.5, 0, 0))
        task.wait(0.1)
        fireGenRemote(gen, pts[2])
        task.wait(0.7)
        
        if #pts >= 3 and autoGen and genProgress(gen) < 1 then
            root.CFrame = CFrame.new(pts[3].Position + Vector3.new(1.5, 0, 0))
            task.wait(0.1)
            fireGenRemote(gen, pts[3])
            task.wait(0.7)
        end
        
        -- Return to point1 and stay until complete
        if autoGen and genProgress(gen) < 1 then
            root.CFrame = CFrame.new(pts[1].Position + Vector3.new(1.5, 0, 0))
            task.wait(0.1)
            while autoGen and genProgress(gen) < 1 do
                fireGenRemote(gen, pts[1])
                task.wait(0.5)
            end
        end
    end)
end

local function stopAutoGen()
    autoGen = false
    if genConn then genConn:Disconnect() genConn = nil end
    log("INFO", "Auto Generator OFF")
end

local god = false
local function godLoop()
    while god do
        local c = LocalPlayer.Character
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h then
                h.MaxHealth = 1e9
                h.Health = 1e9
            end
        end
        task.wait(0.1)
    end
end
local function startGod() god = true task.spawn(godLoop) log("INFO", "God Mode ON") end
local function stopGod()
    god = false
    local c = LocalPlayer.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then
            h.MaxHealth = 100
            h.Health = 100
        end
    end
    log("INFO", "God Mode OFF")
end

local selfHeal = false
local function selfHealLoop()
    while selfHeal do
        local c = LocalPlayer.Character
        if c and healRemote then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h and h.Health < 90 then
                healRemote:FireServer("success", 1, c)
            end
        end
        task.wait(0.5)
    end
end
local function startSelfHeal() selfHeal = true task.spawn(selfHealLoop) log("INFO", "Self Heal ON") end
local function stopSelfHeal() selfHeal = false log("INFO", "Self Heal OFF") end

local teamHeal = false
local function teamHealLoop()
    while teamHeal do
        local c = LocalPlayer.Character
        if not c then task.wait(0.5) continue end
        local root = c:FindFirstChild("HumanoidRootPart")
        if not root then task.wait(0.5) continue end
        
        for _, p in pairs(Players:GetPlayers()) do
            if not teamHeal then break end
            if p ~= LocalPlayer and p.Team == LocalPlayer.Team and p.Character and healRemote then
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health <= 50 then
                    local tr = p.Character:FindFirstChild("HumanoidRootPart")
                    if tr then
                        root.CFrame = CFrame.new(tr.Position + Vector3.new(2, 0, 0))
                        task.wait(0.3)
                        healRemote:FireServer("success", 1, p.Character)
                        task.wait(0.5)
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function startTeamHeal() if teamHeal then return end teamHeal = true task.spawn(teamHealLoop) log("INFO", "Team Heal ON") end
local function stopTeamHeal() teamHeal = false log("INFO", "Team Heal OFF") end

local espP = {}
local function playerESP(plr)
    if plr == LocalPlayer or espP[plr] then return end
    local c = plr.Character
    if not c then return end
    
    local hl = Instance.new("Highlight")
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = c
    hl.Parent = CoreGui
    espP[plr] = {hl = hl}
end
local function remPlayerESP(plr)
    local d = espP[plr]
    if d then if d.hl then d.hl:Destroy() end espP[plr] = nil end
end
local function updatePlayerColors()
    if not _G.FeatureState.espPlayer then return end
    for plr, d in pairs(espP) do
        if d.hl and d.hl.Parent then
            local role = plr.Team and string.upper(plr.Team.Name or "") or ""
            local col = role == "KILLER" and Color3.fromRGB(255, 0, 0) or
                       role == "SURVIVORS" and Color3.fromRGB(0, 170, 255) or
                       Color3.fromRGB(255, 255, 255)
            d.hl.FillColor = col
            d.hl.OutlineColor = col
        else
            remPlayerESP(plr)
        end
    end
end
local function startPlayerESP()
    _G.FeatureState.espPlayer = true
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then playerESP(p) end
    end
    updatePlayerColors()
    log("INFO", "Player ESP ON")
end
local function stopPlayerESP()
    _G.FeatureState.espPlayer = false
    for p in pairs(espP) do remPlayerESP(p) end
    log("INFO", "Player ESP OFF")
end

local espG = {}
local function genESP(g)
    if espG[g] then return end
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(150, 0, 200)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = g
    hl.Parent = CoreGui
    espG[g] = {hl = hl}
end
local function remGenESP(g)
    local d = espG[g]
    if d then if d.hl then d.hl:Destroy() end espG[g] = nil end
end
local function updateGenESP()
    if not _G.FeatureState.espGenerator then return end
    for _, g in pairs(getGenerators()) do
        local prog = genProgress(g)
        local col = Color3.fromRGB(150, 0, 200):Lerp(Color3.fromRGB(0, 255, 0), prog)
        genESP(g)
        local d = espG[g]
        if d then
            d.hl.FillColor = col
            d.hl.OutlineColor = col
        end
    end
end
local function startGenESP() _G.FeatureState.espGenerator = true updateGenESP() log("INFO", "Generator ESP ON") end
local function stopGenESP() _G.FeatureState.espGenerator = false for g in pairs(espG) do remGenESP(g) end log("INFO", "Generator ESP OFF") end

local aim = false
local function isValidAim(plr)
    local role = getRole()
    if role == "SPECTATOR" then return false end
    local tr = plr.Team and string.upper(plr.Team.Name or "") or ""
    if role == "SURVIVORS" then return tr == "KILLER"
    elseif role == "KILLER" then
        if tr ~= "SURVIVORS" then return false end
        local c = plr.Character
        if not c then return false end
        local h = c:FindFirstChild("Humanoid")
        if h and (h.Health <= 0 or h.PlatformStand) then return false end
        return true
    end
    return false
end
local function findAim()
    local best, bestD
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isValidAim(p) and p.Character then
            local part = p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local d = (Camera.CFrame.Position - part.Position).Magnitude
                if d < 200 and (not best or d < bestD) then
                    best = part
                    bestD = d
                end
            end
        end
    end
    return best
end
RunService.RenderStepped:Connect(function()
    if not aim then return end
    local t = findAim()
    if t then
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, t.Position), 0.15)
    end
end)
local function startAim() aim = true log("INFO", "Aimbot ON") end
local function stopAim() aim = false log("INFO", "Aimbot OFF") end

local fly = false
local flySpd = 50
local flyConn, bv, bg
local function startFly()
    local c = LocalPlayer.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local hum = c:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(40000, 40000, 40000)
    bv.Parent = hrp
    
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(40000, 40000, 40000)
    bg.P = 1000
    bg.Parent = hrp
    
    flyConn = RunService.Heartbeat:Connect(function()
        if not fly then return end
        bg.CFrame = Camera.CFrame
        local vel = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel += Camera.CFrame.LookVector * flySpd end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel += Camera.CFrame.LookVector * -flySpd end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel += Camera.CFrame.RightVector * -flySpd end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel += Camera.CFrame.RightVector * flySpd end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel += Vector3.new(0, flySpd, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel += Vector3.new(0, -flySpd, 0) end
        bv.Velocity = vel
        hum.PlatformStand = true
    end)
    log("INFO", "Fly ON")
end
local function stopFly()
    if flyConn then flyConn:Disconnect() end
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    local c = LocalPlayer.Character
    if c then
        local h = c:FindFirstChild("Humanoid")
        if h then h.PlatformStand = false end
    end
    log("INFO", "Fly OFF")
end

local noclip = false
local ncConn
local function startNoclip()
    ncConn = RunService.Stepped:Connect(function()
        if not noclip then return end
        local c = LocalPlayer.Character
        if c then
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
    log("INFO", "Noclip ON")
end
local function stopNoclip()
    if ncConn then ncConn:Disconnect() end
    local c = LocalPlayer.Character
    if c then
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
    log("INFO", "Noclip OFF")
end

Lighting.Ambient = Color3.new(1, 1, 1)
Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.FogEnd = 9e9
Lighting.GlobalShadows = false
RunService.Heartbeat:Connect(function()
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    Lighting.Brightness = 2
end)

sec(Survivor, "GENERATOR")
toggle(Survivor, "Auto Generator", false, function(v) if v then startAutoGen() else stopAutoGen() end end)
toggle(Survivor, "Auto Skillcheck", false, function(v) if v then startAutoSkill() else stopAutoSkill() end end)
sec(Survivor, "HEALING")
toggle(Survivor, "Self Heal", false, function(v) if v then startSelfHeal() else stopSelfHeal() end end)
toggle(Survivor, "Team Heal", false, function(v) if v then startTeamHeal() else stopTeamHeal() end end)
sec(Killer, "AIMBOT")
toggle(Killer, "Aimbot", false, function(v) if v then startAim() else stopAim() end end)
sec(Esp, "ESP")
toggle(Esp, "Players", false, function(v) if v then startPlayerESP() else stopPlayerESP() end end)
toggle(Esp, "Generators", false, function(v) if v then startGenESP() else stopGenESP() end end)
toggle(Esp, "Progress %", false, function(v) _G.FeatureState.generatorProgress = v updateGenESP() end)
sec(Move, "MOVEMENT")
toggle(Move, "Fly (WASD)", false, function(v) fly = v if v then startFly() else stopFly() end end)
slider(Move, "Speed", 10, 200, 50, function(v) flySpd = v end)
toggle(Move, "Noclip", false, function(v) noclip = v if v then startNoclip() else stopNoclip() end end)
toggle(Move, "Speed Boost", false, function(v)
    local c = LocalPlayer.Character
    if c then
        local h = c:FindFirstChild("Humanoid")
        if h then h.WalkSpeed = v and 30 or 16 end
    end
end)
toggle(Move, "Inf Jump", false, function(v)
    if v then
        UserInputService.JumpRequest:Connect(function()
            local c = LocalPlayer.Character
            if c and c:FindFirstChild("Humanoid") then
                c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)
sec(Misc, "GOD")
toggle(Misc, "God Mode", false, function(v) if v then startGod() else stopGod() end end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if _G.FeatureState.espPlayer then playerESP(p) end
    end)
end)
Players.PlayerRemoving:Connect(function(p) remPlayerESP(p) end)
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer and p.Character then playerESP(p) end
end
RunService.RenderStepped:Connect(function()
    if _G.FeatureState.espPlayer then updatePlayerColors() end
    if _G.FeatureState.espGenerator then updateGenESP() end
end)

log("SUCCESS", "VD Mini loaded – Perfect Gen Side-to-Side")