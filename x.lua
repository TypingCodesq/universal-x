--[[
    ⚡ ENHANCED TOUCH FLING GUI - PRO EDITION v2.0 ⚡
    • Modern animated UI with minimize/close system
    • Ultra-optimized fling engine
    • Target selection & Head Sit feature
    • English labels with descriptions
    • Smooth animations & professional design
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
	local detection = Instance.new("Decal")
	detection.Name = "juisdfj0i32i0eidsuf0iok"
	detection.Parent = ReplicatedStorage
end

local Theme = {
	Background   = Color3.fromRGB(22, 22, 26),
	Sidebar      = Color3.fromRGB(28, 28, 34),
	Panel        = Color3.fromRGB(32, 32, 38),
	Accent       = Color3.fromRGB(90, 130, 255),
	AccentSoft   = Color3.fromRGB(90, 130, 255),
	Text         = Color3.fromRGB(235, 235, 240),
	SubText      = Color3.fromRGB(160, 160, 170),
	Stroke       = Color3.fromRGB(45, 45, 52),
	Good         = Color3.fromRGB(90, 210, 140),
	Bad          = Color3.fromRGB(230, 90, 90),
}

local FONT       = Enum.Font.GothamBold
local FONT_BODY  = Enum.Font.Gotham

local function new(class, props, children)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do
		inst[k] = v
	end
	for _, child in ipairs(children or {}) do
		child.Parent = inst
	end
	return inst
end

local function corner(radius)
	return new("UICorner", { CornerRadius = UDim.new(0, radius or 8) })
end

local function stroke(color, thickness)
	return new("UIStroke", {
		Color = color or Theme.Stroke,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end

local function tween(obj, info, props)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

local QUICK = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local SMOOTH = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local UI = {}
UI.__index = UI

function UI.new(config)
	config = config or {}
	local self = setmetatable({}, UI)

	self.Title = config.Title or "Panel"
	self.Tabs = {}
	self.CurrentTab = nil

	self.ScreenGui = new("ScreenGui", {
		Name = "CustomUI_" .. self.Title:gsub("%s", ""),
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = CoreGui,
	})

	self.MinimizedIcon = new("ImageButton", {
		Name = "MinimizedIcon",
		Size = UDim2.new(0, 52, 0, 52),
		Position = UDim2.new(0, 24, 0, 24),
		BackgroundColor3 = Theme.Panel,
		Image = "",
		Visible = false,
		Parent = self.ScreenGui,
	}, { corner(26), stroke(Theme.Accent, 1.5) })

	new("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "▣",
		Font = FONT,
		TextSize = 20,
		TextColor3 = Theme.Accent,
		Parent = self.MinimizedIcon,
	})

	self.MinimizedIcon.MouseButton1Click:Connect(function()
		self:_restore()
	end)

	self:_makeDraggable(self.MinimizedIcon, self.MinimizedIcon)

	self.Main = new("Frame", {
		Name = "Main",
		Size = UDim2.new(0, 620, 0, 420),
		Position = UDim2.new(0.5, -310, 0.5, -210),
		BackgroundColor3 = Theme.Background,
		ClipsDescendants = true,
		Parent = self.ScreenGui,
	}, { corner(12), stroke(Theme.Stroke, 1) })

	local shadow = new("ImageLabel", {
		Name = "Shadow",
		Image = "rbxassetid://1316045217",
		ImageColor3 = Color3.new(0, 0, 0),
		ImageTransparency = 0.45,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 118, 118),
		Size = UDim2.new(1, 60, 1, 60),
		Position = UDim2.new(0, -30, 0, -30),
		BackgroundTransparency = 1,
		ZIndex = -1,
		Parent = self.Main,
	})

	self.TopBar = new("Frame", {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 46),
		BackgroundColor3 = Theme.Sidebar,
		Parent = self.Main,
	}, { corner(12) })

	new("Frame", {
		Size = UDim2.new(1, 0, 0, 12),
		Position = UDim2.new(0, 0, 1, -12),
		BackgroundColor3 = Theme.Sidebar,
		BorderSizePixel = 0,
		Parent = self.TopBar,
	})

	new("TextLabel", {
		Text = self.Title,
		Font = FONT,
		TextSize = 16,
		TextColor3 = Theme.Text,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 18, 0, 0),
		Size = UDim2.new(0.6, 0, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = self.TopBar,
	})

	self.CloseBtn = new("TextButton", {
		Text = "✕",
		Font = FONT,
		TextSize = 16,
		TextColor3 = Theme.SubText,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 40, 1, 0),
		Position = UDim2.new(1, -40, 0, 0),
		Parent = self.TopBar,
	})
	self.CloseBtn.MouseEnter:Connect(function()
		tween(self.CloseBtn, QUICK, { TextColor3 = Theme.Bad })
	end)
	self.CloseBtn.MouseLeave:Connect(function()
		tween(self.CloseBtn, QUICK, { TextColor3 = Theme.SubText })
	end)
	self.CloseBtn.MouseButton1Click:Connect(function()
		self:Destroy()
	end)

	self.MinBtn = new("TextButton", {
		Text = "—",
		Font = FONT,
		TextSize = 16,
		TextColor3 = Theme.SubText,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 40, 1, 0),
		Position = UDim2.new(1, -80, 0, 0),
		Parent = self.TopBar,
	})
	self.MinBtn.MouseEnter:Connect(function()
		tween(self.MinBtn, QUICK, { TextColor3 = Theme.Accent })
	end)
	self.MinBtn.MouseLeave:Connect(function()
		tween(self.MinBtn, QUICK, { TextColor3 = Theme.SubText })
	end)
	self.MinBtn.MouseButton1Click:Connect(function()
		self:_minimize()
	end)

	self:_makeDraggable(self.TopBar, self.Main)

	self.Sidebar = new("Frame", {
		Name = "Sidebar",
		Size = UDim2.new(0, 150, 1, -46),
		Position = UDim2.new(0, 0, 0, 46),
		BackgroundColor3 = Theme.Sidebar,
		Parent = self.Main,
	})

	self.TabList = new("Frame", {
		Size = UDim2.new(1, 0, 1, -10),
		Position = UDim2.new(0, 0, 0, 10),
		BackgroundTransparency = 1,
		Parent = self.Sidebar,
	})

	local tabLayout = new("UIListLayout", {
		Padding = UDim.new(0, 4),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = self.TabList,
	})

	self.ContentHolder = new("Frame", {
		Name = "ContentHolder",
		Size = UDim2.new(1, -150, 1, -46),
		Position = UDim2.new(0, 150, 0, 46),
		BackgroundColor3 = Theme.Panel,
		Parent = self.Main,
	})

	return self
end

function UI:_makeDraggable(handle, target)
	local dragging, dragStart, startPos, dragInput

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
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

	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

function UI:_minimize()
	local t = tween(self.Main, SMOOTH, {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(
			self.Main.Position.X.Scale, self.Main.Position.X.Offset + self.Main.AbsoluteSize.X / 2,
			self.Main.Position.Y.Scale, self.Main.Position.Y.Offset + self.Main.AbsoluteSize.Y / 2
		),
		BackgroundTransparency = 1,
	})
	t.Completed:Connect(function()
		self.Main.Visible = false
		self.Main.Size = UDim2.new(0, 620, 0, 420)
		self.Main.BackgroundTransparency = 0
		self.MinimizedIcon.Visible = true
		self.MinimizedIcon.Size = UDim2.new(0, 0, 0, 0)
		tween(self.MinimizedIcon, SMOOTH, { Size = UDim2.new(0, 52, 0, 52) })
	end)
end

function UI:_restore()
	local t = tween(self.MinimizedIcon, QUICK, { Size = UDim2.new(0, 0, 0, 0) })
	t.Completed:Connect(function()
		self.MinimizedIcon.Visible = false
		self.Main.Visible = true
		local goalPos = UDim2.new(0.5, -310, 0.5, -210)
		self.Main.Position = goalPos
		self.Main.Size = UDim2.new(0, 0, 0, 0)
		tween(self.Main, SMOOTH, { Size = UDim2.new(0, 620, 0, 420) })
	end)
end

function UI:Destroy()
	if self.ScreenGui then
		local t = tween(self.Main, QUICK, { BackgroundTransparency = 1 })
		t.Completed:Connect(function()
			self.ScreenGui:Destroy()
		end)
	end
end

function UI:AddTab(name, iconId)
	local index = #self.Tabs + 1

	local tabBtn = new("TextButton", {
		Name = name,
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Theme.Panel,
		BackgroundTransparency = index == 1 and 0 or 1,
		Text = "",
		LayoutOrder = index,
		Parent = self.TabList,
	}, { corner(8) })

	local icon = new("ImageLabel", {
		Size = UDim2.new(0, 18, 0, 18),
		Position = UDim2.new(0, 10, 0.5, -9),
		BackgroundTransparency = 1,
		Image = iconId or "",
		ImageColor3 = index == 1 and Theme.Accent or Theme.SubText,
		Parent = tabBtn,
	})

	local label = new("TextLabel", {
		Text = name,
		Font = FONT,
		TextSize = 13,
		TextColor3 = index == 1 and Theme.Text or Theme.SubText,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 36, 0, 0),
		Size = UDim2.new(1, -40, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = tabBtn,
	})

	local page = new("ScrollingFrame", {
		Size = UDim2.new(1, -20, 1, -20),
		Position = UDim2.new(0, 10, 0, 10),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Theme.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Visible = index == 1,
		Parent = self.ContentHolder,
	})

	local pageLayout = new("UIListLayout", {
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = page,
	})
	pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
	end)

	local tab = {
		Button = tabBtn,
		Icon = icon,
		Label = label,
		Page = page,
		Order = 0,
	}

	tabBtn.MouseButton1Click:Connect(function()
		self:_selectTab(tab)
	end)

	table.insert(self.Tabs, tab)
	if index == 1 then
		self.CurrentTab = tab
	end

	local api = self:_TabAPI(tab)
	for methodName, fn in pairs(api) do
		tab[methodName] = fn
	end

	return tab
end

function UI:_selectTab(tab)
	if self.CurrentTab == tab then return end
	if self.CurrentTab then
		tween(self.CurrentTab.Button, QUICK, { BackgroundTransparency = 1 })
		tween(self.CurrentTab.Label, QUICK, { TextColor3 = Theme.SubText })
		tween(self.CurrentTab.Icon, QUICK, { ImageColor3 = Theme.SubText })
		self.CurrentTab.Page.Visible = false
	end
	tween(tab.Button, QUICK, { BackgroundTransparency = 0 })
	tween(tab.Label, QUICK, { TextColor3 = Theme.Text })
	tween(tab.Icon, QUICK, { ImageColor3 = Theme.Accent })
	tab.Page.Visible = true
	self.CurrentTab = tab
end

function UI:_TabAPI(tab)
	local api = {}

	function api.AddSectionTitle(_, text)
		new("TextLabel", {
			Text = text,
			Font = FONT,
			TextSize = 13,
			TextColor3 = Theme.SubText,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 20),
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = (tab.Order),
			Parent = tab.Page,
		})
		tab.Order = tab.Order + 1
	end

	function api.AddButton(_, text, callback)
		local btn = new("TextButton", {
			Text = text,
			Font = FONT,
			TextSize = 14,
			TextColor3 = Theme.Text,
			BackgroundColor3 = Theme.Accent,
			Size = UDim2.new(1, 0, 0, 36),
			LayoutOrder = tab.Order,
			Parent = tab.Page,
		}, { corner(8) })
		tab.Order = tab.Order + 1

		btn.MouseEnter:Connect(function()
			tween(btn, QUICK, { BackgroundColor3 = Theme.AccentSoft })
		end)
		btn.MouseButton1Click:Connect(function()
			tween(btn, TweenInfo.new(0.08), { Size = UDim2.new(1, -6, 0, 33) })
			task.delay(0.08, function()
				tween(btn, TweenInfo.new(0.08), { Size = UDim2.new(1, 0, 0, 36) })
			end)
			if callback then callback() end
		end)
		return btn
	end

	function api.AddToggle(_, text, default, callback)
		local state = default or false

		local holder = new("Frame", {
			Size = UDim2.new(1, 0, 0, 36),
			BackgroundColor3 = Theme.Background,
			LayoutOrder = tab.Order,
			Parent = tab.Page,
		}, { corner(8) })
		tab.Order = tab.Order + 1

		new("TextLabel", {
			Text = text,
			Font = FONT_BODY,
			TextSize = 13,
			TextColor3 = Theme.Text,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 0),
			Size = UDim2.new(1, -70, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = holder,
		})

		local switch = new("TextButton", {
			Text = "",
			Size = UDim2.new(0, 44, 0, 22),
			Position = UDim2.new(1, -54, 0.5, -11),
			BackgroundColor3 = state and Theme.Accent or Theme.Stroke,
			Parent = holder,
		}, { corner(11) })

		local knob = new("Frame", {
			Size = UDim2.new(0, 18, 0, 18),
			Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
			BackgroundColor3 = Color3.new(1, 1, 1),
			Parent = switch,
		}, { corner(9) })

		switch.MouseButton1Click:Connect(function()
			state = not state
			tween(switch, QUICK, { BackgroundColor3 = state and Theme.Accent or Theme.Stroke })
			tween(knob, QUICK, { Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9) })
			if callback then callback(state) end
		end)

		return holder
	end

	function api.AddSlider(_, text, min, max, default, callback)
		min, max = min or 0, max or 100
		default = math.clamp(default or min, min, max)

		local holder = new("Frame", {
			Size = UDim2.new(1, 0, 0, 50),
			BackgroundColor3 = Theme.Background,
			LayoutOrder = tab.Order,
			Parent = tab.Page,
		}, { corner(8) })
		tab.Order = tab.Order + 1

		local label = new("TextLabel", {
			Text = text .. ": " .. tostring(default),
			Font = FONT_BODY,
			TextSize = 13,
			TextColor3 = Theme.Text,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 4),
			Size = UDim2.new(1, -24, 0, 18),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = holder,
		})

		local bar = new("Frame", {
			Size = UDim2.new(1, -24, 0, 8),
			Position = UDim2.new(0, 12, 1, -18),
			BackgroundColor3 = Theme.Stroke,
			Parent = holder,
		}, { corner(4) })

		local startRel = (default - min) / (max - min)
		local fill = new("Frame", {
			Size = UDim2.new(startRel, 0, 1, 0),
			BackgroundColor3 = Theme.Accent,
			Parent = bar,
		}, { corner(4) })

		local dragging = false
		local function setFromX(x)
			local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
			local value = math.floor(min + (max - min) * rel)
			fill.Size = UDim2.new(rel, 0, 1, 0)
			label.Text = text .. ": " .. tostring(value)
			if callback then callback(value) end
		end

		bar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				setFromX(input.Position.X)
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
				setFromX(input.Position.X)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		return holder
	end

	return function() return api end
end

local Window = UI.new({ Title = "⚡ TOUCH FLING PRO" })

local FlingTab = Window:AddTab("Fling", "rbxassetid://7733968881")
local TargetTab = Window:AddTab("Target", "rbxassetid://7734053495")
local TeleportTab = Window:AddTab("Teleport", "rbxassetid://7733964742")

local flingEnabled = false
local flingThread = nil
local flingPower = 10000

local function optimizedFling()
	local lp = LocalPlayer
	local c, hrp, vel, movel = nil, nil, nil, 0.1

	while flingEnabled do
		RunService.Heartbeat:Wait()
		c = lp.Character
		hrp = c and c:FindFirstChild("HumanoidRootPart")

		if hrp then
			vel = hrp.Velocity
			hrp.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
			RunService.RenderStepped:Wait()
			hrp.Velocity = vel
			RunService.Stepped:Wait()
			hrp.Velocity = vel + Vector3.new(0, movel, 0)
			movel = -movel
		end
	end
end

FlingTab.AddSectionTitle("Touch Fling Controls")

FlingTab.AddToggle("Enable Touch Fling", false, function(state)
	flingEnabled = state
	if state then
		flingThread = coroutine.create(optimizedFling)
		coroutine.resume(flingThread)
	else
		flingEnabled = false
	end
end)

FlingTab.AddSlider("Fling Power", 1000, 50000, 10000, function(value)
	flingPower = value
end)

FlingTab.AddSectionTitle("Information")
FlingTab.AddButton("How to use", function()
	print("Click on a player to select target, then press X to teleport or enable fling to ragdoll them!")
end)

local Target
TargetTab.AddSectionTitle("Target Selection")

TargetTab.AddButton("Select Target (Click Player)", function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local mouseTarget = Mouse.Target
		if mouseTarget and mouseTarget.Parent then
			local player = Players:GetPlayerFromCharacter(mouseTarget.Parent)
			if player and player ~= LocalPlayer then
				Target = player
				print("Target selected: " .. player.Name)
			end
		end
	end
end)

TargetTab.AddButton("Head Sit on Target", function()
	if Target and Target.Character and Target.Character:FindFirstChild("Head") then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = Target.Character.Head.CFrame * CFrame.new(0, 2, 0)
		end
	end
end)

TargetTab.AddButton("Teleport to Target", function()
	if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
		end
	end
end)

TargetTab.AddButton("Clear Target", function()
	Target = nil
	print("Target cleared!")
end)

TeleportTab.AddSectionTitle("Quick Teleports")

TeleportTab.AddButton("Teleport to Spawn", function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local spawns = workspace:FindFirstChild("SpawnLocation")
		if spawns then
			char.HumanoidRootPart.CFrame = spawns.CFrame + Vector3.new(0, 5, 0)
		end
	end
end)

TeleportTab.AddButton("Teleport to Sky", function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position.X, 500, char.HumanoidRootPart.Position.Z)
	end
end)

TeleportTab.AddButton("Teleport to Mouse Position", function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local mousePos = Mouse.Hit
		if mousePos then
			char.HumanoidRootPart.CFrame = CFrame.new(mousePos.Position.X, mousePos.Position.Y + 5, mousePos.Position.Z)
		end
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.X and Target and Target.Character then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") and Target.Character:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
		end
	end
end)
