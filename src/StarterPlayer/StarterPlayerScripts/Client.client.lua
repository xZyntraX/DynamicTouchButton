local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DynamicTouchButton = require(ReplicatedStorage.TouchGuiButtons.DynamicTouchButton)

-- Create
local ActionButton = DynamicTouchButton.new()

-- Configure core properties
ActionButton
	:setName("Action")
	:setImage(10173441836)
	:setImageTransparency(0.2)
	:setBackgroundColor(Color3.fromRGB(0, 170, 255))
	:setSize(85)
	:setAlign("RightTop")
	:setOrder(1)
	:setVibration(Enum.HapticEffectType.UINotification, 0.1)

-- Events
ActionButton
	:Clicked(function(selected)
		print("Clicked. Toggle state:", selected)
	end)
	:InputBegan(function(input, selected)
		print("Input began:", input.UserInputType)
	end)
	:InputEnded(function(input, selected)
		print("Input ended:", input.UserInputType)
	end)

-- Switch to one-click mode (no toggle)
ActionButton:oneClick()

-- Enable / Disable individual button
ActionButton:setEnabled(false)
task.wait(1)
ActionButton:setEnabled(true)

-- Access UI instance directly
local instance = ActionButton:getInstance()
print("Instance reference:", instance)

-- Retrieve button from global registry
local found = DynamicTouchButton.get("Action")
if found then
	print("Found button in registry:", found.name)
end

-- Globally enable / disable all dynamic buttons
DynamicTouchButton.DynamicButtonsEnabled(false)
task.wait(1)
DynamicTouchButton.DynamicButtonsEnabled(true)

-- Destroy and cleanup
task.delay(10, function()
	ActionButton:Destroy()
end)