extends Button

var remapping: bool = false
var button_on_cooldown: bool = false
@onready var timer: Timer = $Timer

@export var action: String = "MoveRight"
@export var actionName: String = "Right"
@onready var action_name_label: Label = $MarginContainer/ActionName
@onready var button_prompt: inputPrompt = $MarginContainer/ButtonPrompt


func _ready():
	action_name_label.text = actionName
	#rebinding_tab.finishedLoading.connect(updatePrompt)
	button_prompt.action = action
	button_prompt.updatePrompt()
	visibility_changed.connect(updatePrompt)


func updatePrompt():
	action_name_label.show()
	text = ""
	button_prompt.show()
	button_prompt.updatePrompt()
	remapping = false
	#rebinding_tab.saveSettings()


# this method is called upon by the button click
func startRebind():
	action_name_label.hide()
	remapping = true
	button_on_cooldown = true
	text = "press button or key ....."
	button_prompt.hide()
	timer.start()


func _input(event) -> void:
	if !remapping or button_on_cooldown:
		return
	if (event is InputEventKey or event is InputEventMouseButton) and event.is_pressed():
		accept_event()
		InputHelper.set_keyboard_input_for_action(action, event)
		updatePrompt()

	if event is InputEventJoypadButton and event.is_pressed():
		accept_event()
		InputHelper.set_joypad_input_for_action(action, event)
		updatePrompt()


func _on_timer_timeout() -> void:
	button_on_cooldown = false
