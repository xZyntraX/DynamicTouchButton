--!optimize 2

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
local playerGui = LocalPlayer.PlayerGui

local Packages = script.Parent.Packages

-- MODULES
local Types = require(script.Parent.Types)
local Janitor = require(Packages.Janitor)
local Signal = require(Packages.Signal)

-- TYPES
type AlignmentType = Types.AlignmentType
type DynamicTouchButtonConfig = Types.DynamicTouchButtonConfig
export type DynamicTouchButton = Types.DynamicTouchButton

local DynamicTouchButton = {}
DynamicTouchButton.__index = DynamicTouchButton

local GlobalButtons: { DynamicTouchButton } = {}
local AlignmentsFrames = {}

local function IsRunningStudio(): boolean
	return RunService:IsStudio()
end

local function SafeLog(self: DynamicTouchButton, funcName: string, text: string)
	if IsRunningStudio() then
		print(`({self.name}) / [{funcName}]: {text}`)
	end
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

	local layout: UIListLayout = frame:FindFirstChild(name .. "Layout") or Instance.new("UIListLayout", frame)
	layout.Name = name .. "Layout"
	layout.FillDirection = layoutType
	layout.Padding = UDim.new(0.05, 0)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	return frame
end

local function updateAppearance(self: DynamicTouchButton)
	local btn: ImageButton = _WaitForButton(self)
	local image: ImageButton = btn.ReferenceIMG

	local touchGui = playerGui:WaitForChild("TouchGui", 10)
	local touchControlFrame = touchGui:WaitForChild("TouchControlFrame")
	local jumpButton: ImageButton = touchControlFrame:WaitForChild("JumpButton")
	local newSize =
		UDim2.new(0, jumpButton.Size.X.Offset * self.size / 100, 0, jumpButton.Size.Y.Offset * self.size / 100)

	local parentBtn = AlignmentsFrames[self.alignment]
	if not parentBtn then
		error("Invalid alignment: " .. tostring(self.alignment))
	end

	btn.Name = self.name
	btn.Visible = self.State.Enabled
	btn.ImageColor3 = self.BackgroundColor
	btn.LayoutOrder = self.order
	btn.Size = newSize

	image.Image = "rbxassetid://" .. tostring(self.imageID)
	image.ImageTransparency = self.ImageTransparency
end

-- ADD BUTTON
local function btnAdd(self: DynamicTouchButton)
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

	local newSize =
		UDim2.new(0, jumpButton.Size.X.Offset * self.size / 100, 0, jumpButton.Size.Y.Offset * self.size / 100)
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
			self.State.Selected = not self.State.Selected
			self._clickedCallback:Fire(self.State.Selected)
		end),
		"Disconnect"
	)
	self.btnJanitor:Add(
		Button.InputBegan:Connect(function(input)
			if not self.State.Enabled then
				return
			end
			self._inputBeganCallback:Fire(input, self.State.Selected)
		end),
		"Disconnect"
	)
	self.btnJanitor:Add(
		Button.InputEnded:Connect(function(input)
			if not self.State.Enabled then
				return
			end
			self._inputEndedCallback:Fire(input, self.State.Selected)
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

			SafeLog(self, "resetDetection", "Player restarted")

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

-- SET NAME
function DynamicTouchButton:setName(Name: string): DynamicTouchButton
	self.name = Name

	SafeLog(self, "setName", "name changed")
	updateAppearance(self)

	return self
end

-- MODIFY OR ADD IMAGE
function DynamicTouchButton:setImage(imageID: number): DynamicTouchButton
	self.imageID = imageID

	SafeLog(self, "setImage", "image changed")
	updateAppearance(self)

	return self
end

-- MODIFY IMAGE TRANSPARENCY
function DynamicTouchButton:setImageTransparency(transparency: number): DynamicTouchButton
	self.ImageTransparency = transparency

	SafeLog(self, "setImageTransparency", "imageTransparency changed")
	updateAppearance(self)

	return self
end

-- SET BACKGROUND COLOR
function DynamicTouchButton:setBackgroundColor(Color: Color3): DynamicTouchButton?
	self.BackgroundColor = Color

	SafeLog(self, "setBackgroundColor", "BackgroundColor changed")
	updateAppearance(self)

	return self
end

-- BUTTON DISPLAY ORDER
function DynamicTouchButton:setOrder(order: number): DynamicTouchButton
	if type(order) ~= "number" then
		error("The order must be a number")
	end

	self.order = order

	SafeLog(self, "setOrder", "order changed")
	updateAppearance(self)

	return self
end

-- ALIGN BUTTON
function DynamicTouchButton:setAlign(align: AlignmentType): DynamicTouchButton
	if not AlignmentsFrames or not AlignmentsFrames.LeftBack then
		error("Alignment frames not created yet")
	end

	self.alignment = align

	SafeLog(self, "setAlign", "alignment changed")
	updateAppearance(self)

	return self
end

-- CHANGE THE BUTTON SIZE
function DynamicTouchButton:setSize(size: number): DynamicTouchButton
	size = math.clamp(size, 1, 100)
	self.size = size

	SafeLog(self, "setSize", "size changed")
	updateAppearance(self)

	return self
end

-- ENABLE BUTTON
function DynamicTouchButton:setEnabled(enabled: boolean): DynamicTouchButton
	if self.State.BTNEnabledJanitor then
		self.State.BTNEnabledJanitor:Destroy()
	end

	self.State.Enabled = enabled
	self.State.BTNEnabledJanitor = Janitor.new()

	SafeLog(self, "setEnabled", "adjusted")
	updateAppearance(self)

	return self
end

-- GET BUTTON INSTANCE
function DynamicTouchButton:getInstance(): ImageButton
	local button = _WaitForButton(self)
	return button
end

-- CLICK FUNCTION
function DynamicTouchButton:Clicked(func: (boolean) -> ()): DynamicTouchButton
	if type(func) ~= "function" then
		error("Clicked expects a function")
	end

	self._clickedCallback:Connect(func)
	return self
end

-- INPUT BEGAN FUNCTION
function DynamicTouchButton:InputBegan(func: (InputObject, boolean) -> ()): DynamicTouchButton
	if type(func) ~= "function" then
		error("InputBegan expects a function")
	end

	self._inputBeganCallback:Connect(func)

	return self
end

-- INPUT ENDED FUNCTION
function DynamicTouchButton:InputEnded(func: (InputObject, boolean) -> ()): DynamicTouchButton
	if type(func) ~= "function" then
		error("InputEnded expects a function")
	end

	self._inputEndedCallback:Connect(func)

	return self
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

-----------------------------------------------------------------------------------------------------------------------------------

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
function DynamicTouchButton.new()
	local self = setmetatable({}, DynamicTouchButton)

	self.name = ""
	self.imageID = 0
	self.size = 100

	self._clickedCallback = Signal.new()
	self._inputBeganCallback = Signal.new()
	self._inputEndedCallback = Signal.new()

	self.ImageTransparency = 0.5
	self.BackgroundColor = Color3.fromRGB(255, 255, 255)

	self.order = 1
	self.alignment = "RightTop"

	self.Vibration = nil

	self.State = {
		["resetDetect"] = nil,
		["Button"] = nil,
		["BTNEnabledJanitor"] = nil,
		["Enabled"] = true,
		["Selected"] = false,
	}

	btnAdd(self)
	resetDetection(self)

	table.insert(GlobalButtons, self)

	return self
end

return DynamicTouchButton
