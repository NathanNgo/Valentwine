extends Label
class_name inputPrompt

@export var action: String = "MoveRight"


func _ready():
	var input = InputHelper.get_keyboard_input_for_action(action)
	var label: String = InputHelper.get_label_for_input(input)
	text = str("keyboard_", label)
	InputHelper.device_changed.connect(_on_input_device_changed)


func updatePrompt():
	var device: int = InputHelper.device_index
	var input
	var label: String
	##the device is probably a controller
	if device >= 0:
		input = InputHelper.get_joypad_input_for_action(action)
		label = InputHelper.get_label_for_input(input)
		if !InputBindingsAutoloadScene.button_prompt_Dictionary.has(label):
			print_debug(label, "  not in bindings dictionary")
			return
		text = InputBindingsAutoloadScene.button_prompt_Dictionary[label]
	if device < 0:
		input = InputHelper.get_keyboard_input_for_action(action)
		label = InputHelper.get_label_for_input(input)
		text = str("keyboard_", label)


func _on_input_device_changed(_device_name: String, device_index: int):
	updatePrompt()
