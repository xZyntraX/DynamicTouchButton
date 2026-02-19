# DynamicTouchButton v1.0.2

A lightweight Luau module for Roblox that allows creating custom mobile buttons inside the default `TouchGui`.

## Features
- Custom button icons and transparency (`setImageTransparency`)
- Alignment presets (`RightTop`, `LeftBack`)
- Layout order support (`setOrder`)
- Enable / disable individual buttons (`setEnabled`)
- Enable / disable all buttons globally (`DynamicButtonsEnabled`)
- Dynamic background color (`setBackgroundColor`)
- Optional vibration support (HapticEffect)
- `Clicked`, `InputBegan`, `InputEnded` events (Signal-powered)
- Automatic respawn detection (`CharacterAdded`)
- Full cleanup handled with Janitor
- Global registry (`DynamicTouchButton.get`)
- Direct UI instance access (`getInstance`)
- Fluent API design

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
    :setOrder(1)
    :setBackgroundColor(Color3.fromRGB(126, 255, 100))
    :Clicked(function(selected)
        print("Sprint clicked! Selected:", selected)
    end)
```
### Full Example
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DynamicTouchButton = require(ReplicatedStorage.TouchGuiButtons.DynamicTouchButton)

local SprintButton = DynamicTouchButton.new()
    :setName("Sprint")
    :setImage(9760497816)
    :setSize(90)
    :setAlign("RightTop")
    :setOrder(1)
    :setImageTransparency(0.2)
    :setBackgroundColor(Color3.fromRGB(255, 0, 0))
    :Clicked(function(selected)
        print("[Sprint]: Clicked!", selected)
    end)
    :InputBegan(function(input, selected)
        print("[Sprint]: Input Began", input.UserInputType)
    end)
    :InputEnded(function(input, selected)
        print("[Sprint]: Input Ended", input.UserInputType)
    end)

-- Enable / disable
SprintButton:setEnabled(false)
task.wait(2)
SprintButton:setEnabled(true)

-- Change order
SprintButton:setOrder(2)

-- Change alignment
SprintButton:setAlign("LeftBack")

-- Change background
SprintButton:setBackgroundColor(Color3.fromRGB(100, 255, 100))

-- Get UI instance
local instance = SprintButton:getInstance()
print("Instance:", instance)

-- Get by name
local found = DynamicTouchButton.get("Sprint")
if found then
    print("Found in registry:", found.name)
end

-- Enable / disable all buttons
DynamicTouchButton.DynamicButtonsEnabled(false)
task.wait(2)
DynamicTouchButton.DynamicButtonsEnabled(true)

-- Destroy
task.delay(10, function()
    SprintButton:Destroy()
end)
```
## Events (Signal-Based)

All events are internally powered by `Signal`, allowing multiple listeners:

```lua
SprintButton:Clicked(function(selected)
    print("Listener A")
end)

SprintButton:Clicked(function(selected)
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