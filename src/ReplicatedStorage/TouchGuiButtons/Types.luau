type VibrationConfig = {
	HapticEffectType: Enum.HapticEffectType,
	Delay: number,
}

export type AlignmentType = "RightTop" | "LeftBack"

export type DynamicTouchButtonConfig = {
	name: string,
	imageID: number,
	ImageTransparency: number?,
	BackgroundColor: Color3?,
	size: number,

	order: number?,
	alignment: AlignmentType?,

	Clicked: ((button: ImageButton) -> ())?,
	InputBegan: ((input: InputObject) -> ())?,
	InputEnded: ((input: InputObject) -> ())?,

	Vibration: VibrationConfig?,
}

export type DynamicTouchButton = {
	name: string,
	imageID: number,
	size: number,
	order: number,
	alignment: AlignmentType,
	ImageTransparency: number,
	Vibration: VibrationConfig?,
	BackgroundColor: Color3?,

	State: {
		resetDetect: Janitor?,
		Button: ImageButton?,
		BTNEnabledJanitor: Janitor?,
		Enabled: boolean,
	}?,

	AlignmentsFrames: {
		RightTop: Frame?,
		LeftBack: Frame?,
	},

	btnJanitor: Janitor?,

	setOrder: (self: DynamicTouchButton, order: number) -> (),
	Align: (self: DynamicTouchButton, align: AlignmentType) -> (),
	setEnabled: (self: DynamicTouchButton, Enabled: boolean) -> (),
	Destroy: (self: DynamicTouchButton) -> (),
}

print("Running DynamicTouchButton by lucasrtt132.")

return {}