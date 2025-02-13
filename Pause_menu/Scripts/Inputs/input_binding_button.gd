extends Button

var remapping : bool = false
var button_on_cooldown : bool = false
@onready var timer: Timer = $Timer

@export var action : String = "MoveRight"
@onready var button_prompt: inputPrompt = $ButtonPrompt
@onready var rebindings_general: TabBar = $"../../../../.."

func _ready():
	rebindings_general.finishedLoading.connect(updatePrompt)
	button_prompt.action = action
	button_prompt.updatePrompt()
	
# this method is connected to the parent's "finished loading" signal, and also 
# is called when a remap finishes
func updatePrompt():
	text = ""
	button_prompt.show()
	button_prompt.updatePrompt()
	remapping = false
# this method is called upon by the button click
func startRebind():
	remapping = true
	button_on_cooldown = true
	text = "press button or key ....."
	button_prompt.hide()
	timer.start()
	
func _unhandled_input(event) -> void:
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
