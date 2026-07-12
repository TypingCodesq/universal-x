-- Touch fling gui improved
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Frame_2 = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local FlingButton = Instance.new("TextButton")
local HeadsitButton = Instance.new("TextButton")
local PlayerSelector = Instance.new("TextBox")
local SpinButton = Instance.new("TextButton")
local AttachButton = Instance.new("TextButton")
local NoclipButton = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.388539821, 0, 0.427821517, 0)
Frame.Size = UDim2.new(0, 158, 0, 220)
Frame.Active = true
Frame.Draggable = true

Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Size = UDim2.new(0, 158, 0, 25)

TextLabel.Parent = Frame_2
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.112792775, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 121, 0, 26)
TextLabel.Font = Enum.Font.Sarpanch
TextLabel.Text = "Touch Fling+"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 25

CloseButton.Parent = Frame_2
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Position = UDim2.new(0.85, 0, 0.1, 0)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18

PlayerSelector.Parent = Frame
PlayerSelector.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerSelector.Position = UDim2.new(0.113924049, 0, 0.15, 0)
PlayerSelector.Size = UDim2.new(0, 121, 0, 25)
PlayerSelector.Font = Enum.Font.SourceSans
PlayerSelector.PlaceholderText = "Player Name"
PlayerSelector.Text = ""
PlayerSelector.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerSelector.TextSize = 14

FlingButton.Parent = Frame
FlingButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FlingButton.Position = UDim2.new(0.113924049, 0, 0.3, 0)
FlingButton.Size = UDim2.new(0, 121, 0, 30)
FlingButton.Font = Enum.Font.SourceSansItalic
FlingButton.Text = "Fling: OFF"
FlingButton.TextColor3 = Color3.fromRGB(0, 0, 0)
FlingButton.TextSize = 18

HeadsitButton.Parent = Frame
HeadsitButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HeadsitButton.Position = UDim2.new(0.113924049, 0, 0.48, 0)
HeadsitButton.Size = UDim2.new(0, 121, 0, 30)
HeadsitButton.Font = Enum.Font.SourceSansItalic
HeadsitButton.Text = "Headsit: OFF"
HeadsitButton.TextColor3 = Color3.fromRGB(0, 0, 0)
HeadsitButton.TextSize = 18

SpinButton.Parent = Frame
SpinButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpinButton.Position = UDim2.new(0.113924049, 0, 0.66, 0)
SpinButton.Size = UDim2.new(0, 121, 0, 30)
SpinButton.Font = Enum.Font.SourceSansItalic
SpinButton.Text = "Spin: OFF"
SpinButton.TextColor3 = Color3.fromRGB(0, 0, 0)
SpinButton.TextSize = 18

AttachButton.Parent = Frame
AttachButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AttachButton.Position = UDim2.new(0.113924049, 0, 0.84, 0)
AttachButton.Size = UDim2.new(0, 121, 0, 30)
AttachButton.Font = Enum.Font.SourceSansItalic
AttachButton.Text = "Attach: OFF"
AttachButton.TextColor3 = Color3.fromRGB(0, 0, 0)
AttachButton.TextSize = 18

NoclipButton.Parent = Frame
NoclipButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.Position = UDim2.new(0.113924049, 0, 1.02, 0)
NoclipButton.Size = UDim2.new(0, 121, 0, 30)
NoclipButton.Font = Enum.Font.SourceSansItalic
NoclipButton.Text = "Noclip: OFF"
NoclipButton.TextColor3 = Color3.fromRGB(0, 0, 0)
NoclipButton.TextSize = 18

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local mouse = lp:GetMouse()

if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
	local detection = Instance.new("Decal")
	detection.Name = "juisdfj0i32i0eidsuf0iok"
	detection.Parent = ReplicatedStorage
end

local hiddenfling = false
local headsit = false
local spin = false
local attach = false
local noclip = false
local selectedPlayer = nil
local flingThread, headsitThread, spinThread, attachThread
local connections = {}

local function getPlayer(name)
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Name:lower():find(name:lower()) or plr.DisplayName:lower():find(name:lower()) then
			return plr
		end
	end
	return nil
end

local function flingFunc()
	while hiddenfling do
		RunService.Heartbeat:Wait()
		local c = lp.Character
		local hrp = c and c:FindFirstChild("HumanoidRootPart")
		if hrp then
			local vel = hrp.Velocity
			hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
			RunService.RenderStepped:Wait()
			hrp.Velocity = vel
			RunService.Stepped:Wait()
			hrp.Velocity = vel + Vector3.new(0, 0.1, 0)
		end
	end
end

local function headsitFunc(target)
	while headsit and target and target.Character and target.Character:FindFirstChild("Head") do
		local myChar = lp.Character
		local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
		local targetHead = target.Character.Head
		if myHrp and targetHead then
			myHrp.CFrame = targetHead.CFrame * CFrame.new(0, 2.5, 0) * CFrame.Angles(math.rad(90), 0, 0)
		end
		RunService.Heartbeat:Wait()
	end
end

local function spinFunc()
	while spin do
		local c = lp.Character
		local hrp = c and c:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(15), 0)
		end
		RunService.Heartbeat:Wait()
	end
end

local function attachFunc(target)
	while attach and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") do
		local myChar = lp.Character
		local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
		local targetHrp = target.Character.HumanoidRootPart
		if myHrp and targetHrp then
			myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, -3)
		end
		RunService.Heartbeat:Wait()
	end
end

local function toggleNoclip()
	if noclip then
		for _, conn in pairs(connections) do
			conn:Disconnect()
		end
		connections = {}
		local char = lp.Character
		if char then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	else
		local char = lp.Character
		if char then
			table.insert(connections, RunService.Stepped:Connect(function()
				for _, part in pairs(char:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then
						part.CanCollide = false
					end
				end
			end))
		end
	end
end

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

PlayerSelector.FocusLost:Connect(function()
	selectedPlayer = getPlayer(PlayerSelector.Text)
end)

FlingButton.MouseButton1Click:Connect(function()
	hiddenfling = not hiddenfling
	FlingButton.Text = hiddenfling and "Fling: ON" or "Fling: OFF"
	if hiddenfling then
		flingThread = coroutine.create(flingFunc)
		coroutine.resume(flingThread)
	end
end)

HeadsitButton.MouseButton1Click:Connect(function()
	headsit = not headsit
	HeadsitButton.Text = headsit and "Headsit: ON" or "Headsit: OFF"
	if headsit and selectedPlayer then
		headsitThread = coroutine.create(function() headsitFunc(selectedPlayer) end)
		coroutine.resume(headsitThread)
	end
end)

SpinButton.MouseButton1Click:Connect(function()
	spin = not spin
	SpinButton.Text = spin and "Spin: ON" or "Spin: OFF"
	if spin then
		spinThread = coroutine.create(spinFunc)
		coroutine.resume(spinThread)
	end
end)

AttachButton.MouseButton1Click:Connect(function()
	attach = not attach
	AttachButton.Text = attach and "Attach: ON" or "Attach: OFF"
	if attach and selectedPlayer then
		attachThread = coroutine.create(function() attachFunc(selectedPlayer) end)
		coroutine.resume(attachThread)
	end
end)

NoclipButton.MouseButton1Click:Connect(function()
	noclip = not noclip
	NoclipButton.Text = noclip and "Noclip: ON" or "Noclip: OFF"
	toggleNoclip()
end)

lp.CharacterAdded:Connect(function()
	if noclip then
		task.wait(1)
		toggleNoclip()
		toggleNoclip()
	end
end)
