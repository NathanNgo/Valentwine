extends Button

@export var action: String = "MoveRight"
@export var action_name: String = "Right"

var remapping: bool = false
var button_on_cooldown: bool = false

@onready var timer: Timer = $Timer
@onready var action_name_label: Label = $MarginContainer/action_name
@onready var button_prompt: InputPrompt = $MarginContainer/ButtonPrompt


func _ready():
	action_name_label.text = action_name
	#rebinding_tab.finishedLoading.connect(update_prompt)
	button_prompt.action = action
	button_prompt.update_prompt()
	visibility_changed.connect(update_prompt)


func update_prompt():
	action_name_label.show()
	text = ""
	button_prompt.show()
	button_prompt.update_prompt()
	remapping = false
	#rebinding_tab.saveSettings()


# this method is called upon by the button click
func start_rebind():
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
		update_prompt()

	if event is InputEventJoypadButton and event.is_pressed():
		accept_event()
		InputHelper.set_joypad_input_for_action(action, event)
		update_prompt()


func _on_timer_timeout() -> void:
	button_on_cooldown = false
