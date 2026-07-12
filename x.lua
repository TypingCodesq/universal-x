local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = gethui and gethui() or game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if getgenv().UltimateCheatMenu then getgenv().UltimateCheatMenu:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateCheatMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui
getgenv().UltimateCheatMenu = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 680, 0, 520)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(28,28,34)), ColorSequenceKeypoint.new(1, Color3.fromRGB(14,14,19))}
UIGradient.Rotation = 90
UIGradient.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,60)
TitleBar.BackgroundColor3 = Color3.fromRGB(24,24,30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,16)

local Title = Instance.new("TextLabel")
Title.Text = "ULTIMATE CHEAT MENU"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 26
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0.65,0,1,0)
Title.Position = UDim2.new(0,30,0,0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0,40,0,40)
MinimizeBtn.Position = UDim2.new(1,-85,0.5,-20)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(100,255,180)
MinimizeBtn.TextSize = 32
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,40,0,40)
CloseBtn.Position = UDim2.new(1,-40,0.5,-20)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255,90,90)
CloseBtn.TextSize = 32
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local FlingEnabled = false

local function SuperFling()
    if not FlingEnabled then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local vel = root.Velocity
    root.Velocity = vel * 120 + Vector3.new(0,6500,0)
    RunService.RenderStepped:Wait()
    root.Velocity = vel * 3 + Vector3.new(math.random(-35,35), 9200, math.random(-35,35))
end

RunService.Heartbeat:Connect(SuperFling)

local minimized = false
local minimizedFrame

MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame.Visible = not minimized
    if minimized then
        minimizedFrame = Instance.new("Frame")
        minimizedFrame.Size = UDim2.new(0,70,0,70)
        minimizedFrame.Position = UDim2.new(0.5,-35,0.1,0)
        minimizedFrame.BackgroundColor3 = Color3.fromRGB(25,25,32)
        minimizedFrame.Parent = ScreenGui
        Instance.new("UICorner", minimizedFrame).CornerRadius = UDim.new(1,0)
        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(1,0,1,0)
        icon.BackgroundTransparency = 1
        icon.Text = "⚡"
        icon.TextSize = 42
        icon.TextColor3 = Color3.fromRGB(80,255,160)
        icon.Font = Enum.Font.GothamBold
        icon.Parent = minimizedFrame
        minimizedFrame.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                minimizedFrame:Destroy()
                MainFrame.Visible = true
                minimized = false
            end
        end)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    getgenv().UltimateCheatMenu = nil
end)

local dragging
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        local dragStart = input.Position
        local startPos = MainFrame.Position
        local conn
        conn = UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                local delta = inp.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                conn:Disconnect()
            end
        end)
    end
end)

local FlingBtn = Instance.new("TextButton")
FlingBtn.Size = UDim2.new(0,220,0,55)
FlingBtn.Position = UDim2.new(0.5,-110,0.5,-30)
FlingBtn.BackgroundColor3 = Color3.fromRGB(220,50,50)
FlingBtn.Text = "TOUCH FLING: OFF"
FlingBtn.TextColor3 = Color3.fromRGB(255,255,255)
FlingBtn.TextSize = 18
FlingBtn.Font = Enum.Font.GothamBold
FlingBtn.Parent = MainFrame
Instance.new("UICorner", FlingBtn).CornerRadius = UDim.new(0,10)

FlingBtn.MouseButton1Click:Connect(function()
    FlingEnabled = not FlingEnabled
    FlingBtn.Text = "TOUCH FLING: " .. (FlingEnabled and "ON" or "OFF")
    FlingBtn.BackgroundColor3 = FlingEnabled and Color3.fromRGB(50,220,80) or Color3.fromRGB(220,50,50)
end)

print("Ultimate Cheat Menu Loaded")
