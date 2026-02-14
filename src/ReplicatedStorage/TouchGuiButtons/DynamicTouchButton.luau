--[[
 DynamicTouchButton - Roblox Mobile TouchGui Button Library
 Created by: Zyntra (lucasrtt132)

 This module allows developers to easily create and manage custom mobile
 buttons inside Roblox's TouchGui system.

 All documentation, usage examples, and updates are available on GitHub:
 https://github.com/xZyntraX/DynamicTouchButton

 Open Source Project: Feel free to use or modify, just keep credits please.
 ]]

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Packages = script.Parent.Packages

-- MODULES
local Types = require(script.Parent.Types)
local Janitor = require(Packages.Janitor)

-- TYPES
type AlignmentType = Types.AlignmentType
type DynamicTouchButtonConfig = Types.DynamicTouchButtonConfig
export type DynamicTouchButton = Types.DynamicTouchButton

local Logs = true --BUTTONS LOGS

local DynamicTouchButton = {}
DynamicTouchButton.__index = DynamicTouchButton

local GlobalButtons: { DynamicTouchButton } = {}
local AlignmentsFrames = {}

local function IsRunningStudio(): boolean
	return RunService:IsStudio()
end

-- BUTTON REQUEST
local function _WaitForButton(self: DynamicTouchButton): ImageButton
	if not self.State then
		error("DynamicTouchButton destroyed")
	end

	local start = os.clock()

	while self.State and not self.State.Button and os.clock() - start < 5 do
		task.wait(0.03)
	end

	if not self.State then
		error("DynamicTouchButton destroyed while waiting for button")
	end

	if not self.State.Button then
		error("Button not created")
	end

	return self.State.Button
end

-- VIBRATION EFFECT
local function VibrationEffect(effectType: Enum.HapticEffectType, Delay: number)
	Delay = Delay or 0.15

	local HapticCache = ReplicatedStorage:FindFirstChild("HapticCache") or Instance.new("Folder", ReplicatedStorage)
	HapticCache.Name = "HapticCache"

	local effect: HapticEffect = Instance.new("HapticEffect")
	effect.Type = effectType
	effect.Looped = false
	effect.Parent = HapticCache

	effect:Play()
	if IsRunningStudio() and Logs then
		print("[VibrationEffect]: vibrated")
	end
	task.delay(Delay, function()
		if effect then
			effect:Destroy()
		end
	end)
end

local function AlignmentFrameworkCreate(name, layoutType, parent)
	local frame = parent:FindFirstChild(name) or Instance.new("Frame", parent)
	frame.Name = name
	frame.BackgroundTransparency = 1

	local layout : UIListLayout = frame:FindFirstChild(name .. "Layout") or Instance.new("UIListLayout", frame)
	layout.Name = name .. "Layout"
	layout.FillDirection = layoutType
	layout.Padding = UDim.new(0.05, 0)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	return frame
end

local function updateAppearance(self)
	local btn = _WaitForButton(self)
	btn.Visible = self.State.Enabled
	btn.ImageColor3 = self.BackgroundColor
end

-- ADD BUTTON
local function btnAdd(self)
	if not self.State then
		return
	end

	if self.btnJanitor then
		self.btnJanitor:Destroy()
		self.btnJanitor = nil
	end
	if self.State.Button then
		self.State.Button:Destroy()
		self.State.Button = nil
	end

	local playerGui = LocalPlayer.PlayerGui

	local touchGui = playerGui:WaitForChild("TouchGui", 10)
	if not touchGui then
		return
	end

	local touchControlFrame = touchGui:WaitForChild("TouchControlFrame")
	local jumpButton: ImageButton = touchControlFrame:WaitForChild("JumpButton")

	local RightTop: Frame = AlignmentFrameworkCreate("RightTop", Enum.FillDirection.Vertical, touchControlFrame)
	RightTop.Size = UDim2.new(jumpButton.Size.X.Scale, jumpButton.Size.X.Offset, 0.5, 0)
	RightTop.Position = UDim2.new(
		jumpButton.Position.X.Scale,
		jumpButton.Position.X.Offset,
		jumpButton.Position.Y.Scale - 0.53,
		jumpButton.Position.Y.Offset
	)

	local RightTopLayout: UIListLayout = RightTop:FindFirstChild("RightTopLayout")
	RightTopLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	RightTopLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

	local LeftBack: Frame = AlignmentFrameworkCreate("LeftBack", Enum.FillDirection.Horizontal, touchControlFrame)
	LeftBack.Size = UDim2.new(0.3, 0, jumpButton.Size.Y.Scale, jumpButton.Size.Y.Offset)
	LeftBack.Position = UDim2.new(
		jumpButton.Position.X.Scale - 0.32,
		jumpButton.Position.X.Offset,
		jumpButton.Position.Y.Scale,
		jumpButton.Position.Y.Offset
	)

	local LeftBackLayout: UIListLayout = LeftBack:FindFirstChild("LeftBackLayout")
	LeftBackLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	LeftBackLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	AlignmentsFrames.RightTop = RightTop
	AlignmentsFrames.LeftBack = LeftBack

	local Button: ImageButton = Instance.new("ImageButton")
	Button.LayoutOrder = self.order

	local parentBtn = AlignmentsFrames[self.alignment]
	if not parentBtn then
		error("Invalid alignment: " .. tostring(self.alignment))
	end

	Button.Parent = parentBtn

	self.State.Button = Button

	Button.BackgroundTransparency = 1
	Button.ImageTransparency = 0
	Button.Name = self.name
	Button.Image = "rbxassetid://6256840888"
	Button.PressedImage = "rbxassetid://14112658774"
	Button.ImageColor3 = self.BackgroundColor

	local ReferenceIMG: ImageLabel = Instance.new("ImageLabel", Button)
	ReferenceIMG.Name = "ReferenceIMG"
	ReferenceIMG.Interactable = false
	ReferenceIMG.BackgroundTransparency = 1
	ReferenceIMG.ImageTransparency = self.ImageTransparency
	ReferenceIMG.Image = "rbxassetid://" .. tostring(self.imageID)
	ReferenceIMG.AnchorPoint = Vector2.new(0.5, 0.5)
	ReferenceIMG.Position = UDim2.fromScale(0.5, 0.5)
	ReferenceIMG.Size = UDim2.fromScale(0.7, 0.7)

	local SizePrecentage = self.size / 100

	local newSize =
		UDim2.new(0, jumpButton.Size.X.Offset * SizePrecentage, 0, jumpButton.Size.Y.Offset * SizePrecentage)
	Button.Size = newSize

	self.btnJanitor = Janitor.new()

	self.btnJanitor:Add(
		Button.MouseButton1Click:Connect(function()
			if not self.State.Enabled then
				return
			end
			if self.Vibration then
				VibrationEffect(self.Vibration.HapticEffectType, self.Vibration.Delay)
			end
			self.Clicked(Button)
		end),
		"Disconnect"
	)
	self.btnJanitor:Add(
		Button.InputBegan:Connect(function(input)
			if not self.State.Enabled then
				return
			end
			self.InputBegan(input)
		end),
		"Disconnect"
	)
	self.btnJanitor:Add(
		Button.InputEnded:Connect(function(input)
			if not self.State.Enabled then
				return
			end
			self.InputEnded(input)
		end),
		"Disconnect"
	)
end

local function resetDetection(self: DynamicTouchButton)
	if self.State.resetDetect then
		self.State.resetDetect:Destroy()
		self.State.resetDetect = nil
	end
	self.State.resetDetect = Janitor.new()

	self.State.resetDetect:Add(
		LocalPlayer.CharacterAdded:Connect(function()
			if not self.State then
				return
			end
			if IsRunningStudio() and Logs then
				print("[resetDetection]: Player restarted")
			end
			task.defer(function()
				if not self.State then
					return
				end
				btnAdd(self)
			end)
		end),
		"Disconnect"
	)
end

-- BUTTON DISPLAY ORDER
function DynamicTouchButton:setOrder(order: number)
	local button = _WaitForButton(self)
	if type(order) ~= "number" then
		error("The order must be a number")
	end
	if IsRunningStudio() and Logs then
		print("[setOrder]: button change")
	end

	self.order = order
	button.LayoutOrder = order
end

-- ALIGN BUTTON
function DynamicTouchButton:Align(align: AlignmentType)
	if not AlignmentsFrames or not AlignmentsFrames.LeftBack then
		error("Alignment frames not created yet")
	end

	local button = _WaitForButton(self)

	if align == "LeftBack" then
		button.Parent = AlignmentsFrames.LeftBack
	elseif align == "RightTop" then
		button.Parent = AlignmentsFrames.RightTop
	else
		error("invalid alignment")
	end
	if IsRunningStudio() and Logs then
		print("[Align]: adjusted alignment")
	end

	self.alignment = align
end

-- ENABLE BUTTON
function DynamicTouchButton:setEnabled(enabled: boolean): ()
	if self.State.BTNEnabledJanitor then
		self.State.BTNEnabledJanitor:Destroy()
	end

	self.State.Enabled = enabled
	self.State.BTNEnabledJanitor = Janitor.new()

	updateAppearance(self)
end

-- GET BUTTON INSTANCE
function DynamicTouchButton:getInstance(): ImageButton
	local button = _WaitForButton(self)
	return button
end

-- SET BACKGROUND
function DynamicTouchButton:setBackground(Color: Color3): ()
	if not self.State then
		return
	end
	if not Color then
		Color = Color3.fromRGB(255, 255, 255)
	end
	self.BackgroundColor = Color
	updateAppearance(self)
end

-- DESTROY / CLEAN
function DynamicTouchButton:Destroy(): ()
	if not self.State then
		return
	end
	for i, btn in GlobalButtons do
		if btn == self then
			table.remove(GlobalButtons, i)
			break
		end
	end
	if self.State.BTNEnabledJanitor then
		self.State.BTNEnabledJanitor:Destroy()
		self.State.BTNEnabledJanitor = nil
	end
	if self.btnJanitor then
		self.btnJanitor:Destroy()
		self.btnJanitor = nil
	end
	if self.State.resetDetect then
		self.State.resetDetect:Destroy()
		self.State.resetDetect = nil
	end
	if self.State.Button then
		self.State.Button:Destroy()
		self.State.Button = nil
	end

	self.State = nil
end

function DynamicTouchButton.DynamicButtonsEnabled(enabled: boolean): ()
	for _, btn in pairs(GlobalButtons) do
		btn.State.Enabled = enabled
		continue
	end
	if AlignmentsFrames.LeftBack then
		AlignmentsFrames.LeftBack.Visible = enabled
	end
	if AlignmentsFrames.RightTop then
		AlignmentsFrames.RightTop.Visible = enabled
	end
end

-- GET BUTTON
function DynamicTouchButton.get(Name: string): DynamicTouchButton?
	for _, btn in pairs(GlobalButtons) do
		if btn.name == Name then
			return btn
		end
	end
	return nil
end

-- CREATE BUTTON
function DynamicTouchButton.new(config: DynamicTouchButtonConfig)
	if type(config) ~= "table" then
		error("The configuration needs to be a table.")
	end
	if not config.name then
		error("You need to give the button a name.")
	end
	if not config.imageID then
		error("You need to enter a valid ID for the button image.")
	end
	if not config.size then
		error("you need to define a size")
	end

	local self = setmetatable({}, DynamicTouchButton)

	self.name = config.name
	self.imageID = config.imageID
	self.size = math.clamp(config.size, 1, 100)

	self.InputBegan = config.InputBegan or function() end
	self.InputEnded = config.InputEnded or function() end
	self.Clicked = config.Clicked or function() end

	self.ImageTransparency = config.ImageTransparency or 0.5
	self.BackgroundColor = config.BackgroundColor or Color3.fromRGB(255, 255, 255)

	self.order = config.order or 1
	self.alignment = config.alignment or "RightTop"

	self.Vibration = config.Vibration

	self.State = {
		["resetDetect"] = nil,
		["Button"] = nil,
		["BTNEnabledJanitor"] = nil,
		["Enabled"] = true,
	}

	btnAdd(self)
	resetDetection(self)

	table.insert(GlobalButtons, self)

	return self
end

return DynamicTouchButton
