local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DynamicTouchButton = require(ReplicatedStorage.TouchGuiButtons.DynamicTouchButton)

-- Create a simple button
local btn1 = DynamicTouchButton.new({
	name = "Punch",

	imageID = 13050670424, -- replace with your decal ID

	size = 100, -- 1 to 100

	order = 2,
	alignment = "LeftBack",

	BackgroundColor = Color3.fromRGB(200, 255, 0),

	Clicked = function(button)
		print("Punch clicked!")
	end,
})

-- Create a simple button
local btn2 = DynamicTouchButton.new({
	name = "Sprint",

	imageID = 9525535512, -- replace with your decal ID

	size = 90, -- 1 to 100

	order = 1,
	alignment = "RightTop",

	BackgroundColor = Color3.fromRGB(30, 255, 0),

	Clicked = function(button)
		print("Sprint clicked!")
	end,
})

-- Create a simple button
local btn3 = DynamicTouchButton.new({
	name = "Shift lock",

	imageID = 16812589014, -- replace with your decal ID

	size = 65, -- 1 to 100

	order = 1,
	alignment = "LeftBack",

	BackgroundColor = Color3.fromRGB(255, 255, 255),

	Clicked = function(button)
		print("Shift lock clicked!")
	end,
})

-- Create a simple button
local btn4 = DynamicTouchButton.new({
	name = "Crouch",
	
	imageID = 14599404746, -- replace with your decal ID

	size = 90, -- 1 to 100

	order = 1,
	alignment = "RightTop",

	BackgroundColor = Color3.fromRGB(0, 17, 255),

	Clicked = function(button)
		print("Crouch clicked!")
	end,
})