local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local ScrollingFrame = Instance.new("ScrollingFrame")
local FlingButton = Instance.new("TextButton")
local HeadsitButton = Instance.new("TextButton")
local SpinButton = Instance.new("TextButton")
local AttachButton = Instance.new("TextButton")
local NoclipButton = Instance.new("TextButton")
local FreezeButton = Instance.new("TextButton")
local BringButton = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.35, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 220, 0, 380)
Frame.Active = true
Frame.Draggable = true

TitleBar.Parent = Frame
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 30)

TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.Font = Enum.Font.Sarpanch
TitleLabel.Text = "Touch Fling+"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 22

CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.Position = UDim2.new(0.88, 0, 0.1, 0)
CloseButton.Size = UDim2.new(0, 22, 0, 22)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18

ScrollingFrame.Parent = Frame
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ScrollingFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
ScrollingFrame.Size = UDim2.new(0.9, 0, 0.45, 0)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

FlingButton.Parent = Frame
FlingButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
FlingButton.Position = UDim2.new(0.05, 0, 0.58, 0)
FlingButton.Size = UDim2.new(0.9, 0, 0, 28)
FlingButton.Font = Enum.Font.SourceSansBold
FlingButton.Text = "Fling: OFF"
FlingButton.TextColor3 = Color3.fromRGB(0, 0, 0)
FlingButton.TextSize = 16

HeadsitButton.Parent = Frame
HeadsitButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HeadsitButton.Position = UDim2.new(0.05, 0, 0.66, 0)
HeadsitButton.Size = UDim2.new(0.9, 0, 0, 28)
HeadsitButton.Font = Enum.Font.SourceSansBold
HeadsitButton.Text = "Headsit: OFF"
HeadsitButton.TextColor3 = Color3.fromRGB(0, 0, 0)
HeadsitButton.TextSize = 16

SpinButton.Parent = Frame
SpinButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpinButton.Position = UDim2.new(0.05, 0, 0.74, 0)
SpinButton.Size = UDim2.new(0.9, 0, 0, 28)
SpinButton.Font = Enum.Font.SourceSansBold
SpinButton.Text = "Spin: OFF"
SpinButton.TextColor3 = Color3.fromRGB(0, 0, 0)
SpinButton.TextSize = 16

AttachButton.Parent = Frame
AttachButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AttachButton.Position = UDim2.new(0.05, 0, 0.82, 0)
AttachButton.Size = UDim2.new(0.9, 0, 0, 28)
AttachButton.Font = Enum.Font.SourceSansBold
AttachButton.Text = "Attach: OFF"
AttachButton.TextColor3 = Color3.fromRGB(0, 0, 0)
AttachButton.TextSize = 16

NoclipButton.Parent = Frame
NoclipButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.Position = UDim2.new(0.05, 0, 0.9, 0)
NoclipButton.Size = UDim2.new(0.9, 0, 0, 28)
NoclipButton.Font = Enum.Font.SourceSansBold
NoclipButton.Text = "Noclip: OFF"
NoclipButton.TextColor3 = Color3.fromRGB(0, 0, 0)
NoclipButton.TextSize = 16

FreezeButton.Parent = Frame
FreezeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FreezeButton.Position = UDim2.new(0.05, 0, 0.98, 0)
FreezeButton.Size = UDim2.new(0.9, 0, 0, 28)
FreezeButton.Font = Enum.Font.SourceSansBold
FreezeButton.Text = "Freeze Target: OFF"
FreezeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
FreezeButton.TextSize = 16

BringButton.Parent = Frame
BringButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BringButton.Position = UDim2.new(0.05, 0, 1.06, 0)
BringButton.Size = UDim2.new(0.9, 0, 0, 28)
BringButton.Font = Enum.Font.SourceSansBold
BringButton.Text = "Bring Target"
BringButton.TextColor3 = Color3.fromRGB(0, 0, 0)
BringButton.TextSize = 16

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local selectedPlayer = nil
local toggles = {fling = false, headsit = false, spin = false, attach = false, noclip = false, freeze = false}
local threads = {}
local noclipConn = nil

local function updatePlayerList()
	ScrollingFrame:ClearAllChildren()
	local y = 0
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= lp then
			local playerFrame = Instance.new("Frame")
			playerFrame.Size = UDim2.new(1, -10, 0, 50)
			playerFrame.Position = UDim2.new(0, 5, 0, y)
			playerFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			playerFrame.Parent = ScrollingFrame

			local avatar = Instance.new("ImageLabel")
			avatar.Size = UDim2.new(0, 40, 0, 40)
			avatar.Position = UDim2.new(0, 5, 0.5, -20)
			avatar.BackgroundTransparency = 1
			avatar.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
			avatar.Parent = playerFrame

			local nameLabel = Instance.new("TextLabel")
			nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
			nameLabel.Position = UDim2.new(0.3, 0, 0, 0)
			nameLabel.BackgroundTransparency = 1
			nameLabel.Text = plr.Name
			nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			nameLabel.TextXAlignment = Enum.TextXAlignment.Left
			nameLabel.Parent = playerFrame

			local selectBtn = Instance.new("TextButton")
			selectBtn.Size = UDim2.new(0.25, 0, 0.8, 0)
			selectBtn.Position = UDim2.new(0.72, 0, 0.1, 0)
			selectBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
			selectBtn.Text = "Select"
			selectBtn.TextColor3 = Color3.fromRGB(255,255,255)
			selectBtn.Parent = playerFrame

			selectBtn.MouseButton1Click:Connect(function()
				selectedPlayer = plr
				for _, f in pairs(ScrollingFrame:GetChildren()) do
					if f:IsA("Frame") then
						f.BackgroundColor3 = Color3.fromRGB(60,60,60)
					end
				end
				playerFrame.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
			end)

			y += 55
		end
	end
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

local function powerfulFling()
	local char = lp.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local touchConn
	touchConn = root.Touched:Connect(function(hit)
		local targetChar = hit.Parent
		local targetPlr = Players:GetPlayerFromCharacter(targetChar)
		if targetPlr and targetPlr ~= lp then
			local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				targetRoot.Velocity = Vector3.new(math.random(-200,200), 500, math.random(-200,200)) * 8
			end
		end
	end)

	task.delay(0.3, function() if touchConn then touchConn:Disconnect() end end)
end

local function toggleFling()
	toggles.fling = not toggles.fling
	FlingButton.Text = toggles.fling and "Fling: ON" or "Fling: OFF"
	if toggles.fling then
		threads.fling = coroutine.create(function()
			while toggles.fling do
				powerfulFling()
				task.wait(0.4)
			end
		end)
		coroutine.resume(threads.fling)
	end
end

local function headsitFunc()
	while toggles.headsit and selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Head") do
		local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		local tHead = selectedPlayer.Character.Head
		if myRoot and tHead then
			myRoot.CFrame = tHead.CFrame * CFrame.new(0, 3, 0) * CFrame.Angles(math.rad(90), 0, 0)
		end
		RunService.Heartbeat:Wait()
	end
end

local function spinFunc()
	while toggles.spin do
		local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame *= CFrame.Angles(0, math.rad(25), 0)
		end
		RunService.Heartbeat:Wait()
	end
end

local function attachFunc()
	while toggles.attach and selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") do
		local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		local tRoot = selectedPlayer.Character.HumanoidRootPart
		if myRoot and tRoot then
			myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, -4)
		end
		RunService.Heartbeat:Wait()
	end
end

local function toggleNoclip(state)
	toggles.noclip = state
	NoclipButton.Text = toggles.noclip and "Noclip: ON" or "Noclip: OFF"
	if noclipConn then noclipConn:Disconnect() end
	if toggles.noclip then
		noclipConn = RunService.Stepped:Connect(function()
			local char = lp.Character
			if char then
				for _, part in pairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		local char = lp.Character
		if char then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = true end
			end
		end
	end
end

local function freezeFunc()
	while toggles.freeze and selectedPlayer and selectedPlayer.Character do
		local hum = selectedPlayer.Character:FindFirstChild("Humanoid")
		if hum then hum.PlatformStand = true end
		RunService.Heartbeat:Wait()
	end
end

local function bringTarget()
	if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		local tRoot = selectedPlayer.Character.HumanoidRootPart
		if myRoot and tRoot then
			tRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -5)
		end
	end
end

FlingButton.MouseButton1Click:Connect(toggleFling)
HeadsitButton.MouseButton1Click:Connect(function()
	toggles.headsit = not toggles.headsit
	HeadsitButton.Text = toggles.headsit and "Headsit: ON" or "Headsit: OFF"
	if toggles.headsit then
		threads.headsit = coroutine.create(headsitFunc)
		coroutine.resume(threads.headsit)
	end
end)

SpinButton.MouseButton1Click:Connect(function()
	toggles.spin = not toggles.spin
	SpinButton.Text = toggles.spin and "Spin: ON" or "Spin: OFF"
	if toggles.spin then
		threads.spin = coroutine.create(spinFunc)
		coroutine.resume(threads.spin)
	end
end)

AttachButton.MouseButton1Click:Connect(function()
	toggles.attach = not toggles.attach
	AttachButton.Text = toggles.attach and "Attach: ON" or "Attach: OFF"
	if toggles.attach then
		threads.attach = coroutine.create(attachFunc)
		coroutine.resume(threads.attach)
	end
end)

NoclipButton.MouseButton1Click:Connect(function() toggleNoclip(not toggles.noclip) end)

FreezeButton.MouseButton1Click:Connect(function()
	toggles.freeze = not toggles.freeze
	FreezeButton.Text = toggles.freeze and "Freeze Target: ON" or "Freeze Target: OFF"
	if toggles.freeze then
		threads.freeze = coroutine.create(freezeFunc)
		coroutine.resume(threads.freeze)
	end
end)

BringButton.MouseButton1Click:Connect(bringTarget)

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

lp.CharacterAdded:Connect(function()
	task.wait(1)
	if toggles.noclip then toggleNoclip(true) end
end)
