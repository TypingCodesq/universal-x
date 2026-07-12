-- Touch fling gui (MEJORADO)

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
	local lp = Players.LocalPlayer
	
	local toggleButton = script.Parent
	local hiddenfling = false
	local flingThread 
	local connection
	
	if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
		local detection = Instance.new("Decal")
		detection.Name = "juisdfj0i32i0eidsuf0iok"
		detection.Parent = ReplicatedStorage
	end
	
	local function createFlingLoop()
		if flingThread then
			coroutine.close(flingThread)
		end
		
		flingThread = coroutine.create(function()
			local movel = 0.1
			while hiddenfling do
				RunService.Heartbeat:Wait()
				
				local c = lp.Character
				if not c then continue end
				
				local hrp = c:FindFirstChild("HumanoidRootPart")
				if not hrp then continue end
				
				-- Versión más potente (multiplicadores más altos + mejor timing)
				local vel = hrp.Velocity
				
				-- Spike ultra potente
				hrp.Velocity = vel * 25000 + Vector3.new(0, 25000, 0)
				RunService.RenderStepped:Wait()
				
				-- Reset rápido
				hrp.Velocity = vel
				RunService.Stepped:Wait()
				
				-- Oscilación mejorada para más estabilidad y potencia
				hrp.Velocity = vel + Vector3.new(0, movel * 150, 0)
				movel = -movel
			end
		end)
		
		coroutine.resume(flingThread)
	end
	
	local function startFling()
		hiddenfling = true
		toggleButton.Text = "ON"
		createFlingLoop()
	end
	
	local function stopFling()
		hiddenfling = false
		toggleButton.Text = "OFF"
		if flingThread then
			coroutine.close(flingThread)
			flingThread = nil
		end
	end
	
	toggleButton.MouseButton1Click:Connect(function()
		if hiddenfling then
			stopFling()
		else
			startFling()
		end
	end)
	
	-- Persistencia total tras respawn / muerte
	local function onCharacterAdded(char)
		wait(0.5) -- Pequeño delay para que el personaje cargue completamente
		if hiddenfling then
			createFlingLoop()
		end
	end
	
	lp.CharacterAdded:Connect(onCharacterAdded)
	
	-- Si ya hay personaje, inicializar
	if lp.Character then
		onCharacterAdded(lp.Character)
	end
	
	-- Cleanup al destruir
	script.Destroying:Connect(function()
		stopFling()
	end)
end
coroutine.wrap(IIMAWH_fake_script)()

local function QCJQJL_fake_script() -- Frame.LocalScript 
	local script = Instance.new('LocalScript', Frame)

	script.Parent.Active = true
	script.Parent.Draggable = true
end
coroutine.wrap(QCJQJL_fake_script)()
