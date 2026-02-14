local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DynamicTouchButton = require(ReplicatedStorage.TouchGuiButtons.DynamicTouchButton)

-- Create a simple button
local myButton = DynamicTouchButton.new({
	name = "myButton",

	imageID = 1234567890, -- replace with your decal ID

	size = 90, -- 1 to 100

	order = 1,
	alignment = "RightTop",

	BackgroundColor = Color3.fromRGB(126, 255, 100),

	Clicked = function(button)
		print("Button clicked!")
	end,
})

-- Enable / disable button
myButton:setEnabled(true)
