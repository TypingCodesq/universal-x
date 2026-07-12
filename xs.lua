-- Touch fling gui
-- Gui to Lua (VIP VERSION)
-- Version: 6.9
-- Instances:
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Frame_2 = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")
--Properties:
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
print("sub to DuplexScripts")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.388539821, 0, 0.427821517, 0)
Frame.Size = UDim2.new(0, 158, 0, 110)
Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Size = UDim2.new(0, 158, 0, 25)
TextLabel.Parent = Frame_2
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.112792775, 0, -0.0151660154, 0)
TextLabel.Size = UDim2.new(0, 121, 0, 26)
TextLabel.Font = Enum.Font.Sarpanch
TextLabel.Text = "Touch Fling"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 25.000
TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.113924049, 0, 0.418181807, 0)
TextButton.Size = UDim2.new(0, 121, 0, 37)
TextButton.Font = Enum.Font.SourceSansItalic
TextButton.Text = "OFF"
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 20.000
-- Scripts:
local function IIMAWH_fake_script() -- TextButton.LocalScript 
	local script = Instance.new('LocalScript', TextButton)
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	
	local toggleButton = script.Parent
	local hiddenfling = false
	local flingActive = false
	
	if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
		local detection = Instance.new("Decal")
		detection.Name = "juisdfj0i32i0eidsuf0iok"
		detection.Parent = ReplicatedStorage
	end
	
	local lp = Players.LocalPlayer
	local currentHRP = nil
	local currentHumanoid = nil
	local currentCharacter = nil
	
	local function updateCharacterRefs(character)
		currentCharacter = character
		if not character then
			currentHRP = nil
			currentHumanoid = nil
			return
		end
		currentHRP = character:FindFirstChild("HumanoidRootPart")
		currentHumanoid = character:FindFirstChild("Humanoid")
		if not currentHRP then
			local success = pcall(function()
				currentHRP = character:WaitForChild("HumanoidRootPart", 2)
			end)
		end
		if not currentHumanoid then
			local success = pcall(function()
				currentHumanoid = character:WaitForChild("Humanoid", 2)
			end)
		end
	end
	
	if lp.Character then
		updateCharacterRefs(lp.Character)
	end
	
	lp.CharacterAdded:Connect(updateCharacterRefs)
	lp.CharacterRemoving:Connect(function()
		updateCharacterRefs(nil)
	end)
	
	local function doFling()
		if flingActive then return end
		flingActive = true
		local movel = 0.1
		
		while hiddenfling do
			local dt = RunService.Heartbeat:Wait()
			
			if not currentHRP or not currentHRP.Parent then
				task.wait(0.1)
				continue
			end
			
			if currentHumanoid and currentHumanoid.Health <= 0 then
				task.wait(0.1)
				continue
			end
			
			local vel = currentHRP.Velocity
			
			-- FLING ULTRA POTENTE: velocidad extrema + rotación caótica
			currentHRP.Velocity = vel * 75000 + Vector3.new(0, 75000, 0)
			currentHRP.RotVelocity = Vector3.new(
				math.random(-25000, 25000),
				math.random(-25000, 25000),
				math.random(-25000, 25000)
			)
			
			RunService.RenderStepped:Wait()
			
			if currentHRP and currentHRP.Parent then
				currentHRP.Velocity = vel
				currentHRP.RotVelocity = Vector3.new(0, 0, 0)
			end
			
			RunService.Stepped:Wait()
			
			if currentHRP and currentHRP.Parent then
				currentHRP.Velocity = vel + Vector3.new(0, movel * 200, 0)
				movel = -movel
			end
		end
		
		flingActive = false
	end
	
	toggleButton.MouseButton1Click:Connect(function()
		hiddenfling = not hiddenfling
		toggleButton.Text = hiddenfling and "ON" or "OFF"
		
		if hiddenfling then
			task.spawn(doFling)
		end
	end)
	
end
coroutine.wrap(IIMAWH_fake_script)()
local function QCJQJL_fake_script() -- Frame.LocalScript 
	local script = Instance.new('LocalScript', Frame)
	script.Parent.Active = true
	script.Parent.Draggable = true
end
coroutine.wrap(QCJQJL_fake_script)()
