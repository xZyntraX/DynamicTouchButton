type VibrationConfig = {
	HapticEffectType: Enum.HapticEffectType,
	Delay: number,
}

export type AlignmentType = "RightTop" | "LeftBack"

export type DynamicTouchButtonConfig = {
	name: string,
	imageID: number,
	size: number,

	ImageTransparency: number?,
	BackgroundColor: Color3?,
	order: number?,
	alignment: AlignmentType?,
	Vibration: VibrationConfig?,
}

export type DynamicTouchButton = {
	name: string,
	imageID: number,
	size: number,
	order: number,
	alignment: AlignmentType,
	ImageTransparency: number,
	BackgroundColor: Color3,
	Vibration: VibrationConfig?,

	_clickedCallback: ((boolean) -> ())?,
	_inputBeganCallback: ((InputObject, boolean) -> ())?,
	_inputEndedCallback: ((InputObject, boolean) -> ())?,

	State: {
		resetDetect: Janitor?,
		Button: ImageButton?,
		BTNEnabledJanitor: Janitor?,
		Enabled: boolean,
		Selected: boolean,
	},

	btnJanitor: Janitor?,

	setName: (self: DynamicTouchButton, Name: string) -> DynamicTouchButton,
	setImage: (self: DynamicTouchButton, imageID: number) -> DynamicTouchButton,
	setImageTransparency: (self: DynamicTouchButton, transparency: number) -> DynamicTouchButton,
	setBackgroundColor: (self: DynamicTouchButton, Color: Color3) -> DynamicTouchButton,
	setOrder: (self: DynamicTouchButton, order: number) -> DynamicTouchButton,
	setAlign: (self: DynamicTouchButton, align: AlignmentType) -> DynamicTouchButton,
	setSize: (self: DynamicTouchButton, size: number) -> DynamicTouchButton,
	setEnabled: (self: DynamicTouchButton, enabled: boolean) -> DynamicTouchButton,

	getInstance: (self: DynamicTouchButton) -> ImageButton,

	Clicked: (self: DynamicTouchButton, func: (boolean) -> ()) -> DynamicTouchButton,
	InputBegan: (self: DynamicTouchButton, func: (InputObject, boolean) -> ()) -> DynamicTouchButton,
	InputEnded: (self: DynamicTouchButton, func: (InputObject, boolean) -> ()) -> DynamicTouchButton,

	Destroy: (self: DynamicTouchButton) -> (),
}

local RunService = game:GetService("RunService")

if not RunService:IsStudio() then
	print("📱 Running DynamicTouchButton v1.0.2 by @lucasrtt132.")
end

return {}