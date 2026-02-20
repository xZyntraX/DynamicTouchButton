# DynamicTouchButton v1.0.2

A lightweight Luau module for Roblox that allows creating custom mobile buttons inside the default `TouchGui`.

## Features
- `setName` – Change button name dynamically
- `setImage` – Define or change the icon asset
- `setImageTransparency` – Control icon transparency
- `setBackgroundColor` – Customize button background color
- `setOrder` – Control layout order
- `setAlign` – Alignment presets (`RightTop`, `LeftBack`)
- `setSize` – Adjust button size (1–100 scale)
- `setEnabled` – Enable or disable individual buttons
- `oneClick` – Disable toggle mode (single press behavior)
- `setVibration` – Optional mobile vibration feedback
- `Clicked` – Toggle click event
- `InputBegan` – Input start detection
- `InputEnded` – Input end detection
- `getInstance` – Direct access to the ImageButton instance
- `DynamicTouchButton.get` – Retrieve button by name
- `DynamicTouchButton.DynamicButtonsEnabled` – Globally enable/disable all buttons
- `Destroy` – Full cleanup and removal
- Automatic respawn handling
- Automatic memory cleanup using Janitor
- More soon...

## Requirements

The following dependencies must be inside `ReplicatedStorage/Packages`:

- Janitor
- Signal

## Installation
Recommended structure:
```lua
ReplicatedStorage
 └── TouchGuiButtons
     ├── Packages
     │  ├── Janitor.luau
     │  └── Signal.luau
     ├── DynamicTouchButton.luau
     └── Types.luau
```

## Usage

### Basic Example
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DynamicTouchButton = require(ReplicatedStorage.TouchGuiButtons.DynamicTouchButton)

local SprintButton = DynamicTouchButton.new()
	:setName("Sprint")
	:setImage(9760497816)
	:setSize(90)
	:setAlign("RightTop")
	:setBackgroundColor(Color3.fromRGB(126, 255, 100))
	:Clicked(function(selected)
		print("Sprint toggled:", selected)
	end)
```
### Full Example
```lua
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
```
## Events (Signal-Based)

All events are internally powered by `Signal`, allowing multiple listeners:

```lua
ActionButton:Clicked(function(selected)
    print("Listener A")
end)

ActionButton:Clicked(function(selected)
    print("Listener B")
end)
```

## Example image

![Example with multiple buttons](images/Example.png)

## Notes
DynamicTouchButton is designed to be:

- Simple for beginners
- Scalable for advanced projects
- Clean internally
- Performance-aware

If you find bugs or want to contribute, feel free to open an issue or submit a pull request.

## Rojo
To build the place from scratch, use:

```bash
rojo build -o "TouchGuiButtons.rbxlx"
```

Next, open `TouchGuiButtons.rbxlx` in Roblox Studio and start the Rojo server:

```bash
rojo serve
```

**Download the ready-to-use place:** 
[TouchGuiButtons.rbxlx](./TouchGuiButtons.rbxlx)