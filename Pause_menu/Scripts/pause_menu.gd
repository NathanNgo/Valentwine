extends MarginContainer



var paused : bool = false
@onready var controls: TabBar = $MarginContainer/TabContainer/Controls
@onready var margin_container: MarginContainer = $MarginContainer


func swap_pause_state():
	if !paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		show()
		paused = true
		get_tree().paused = true
	else:
		unpause()

func _ready():
	call_deferred("hide")
	call_deferred("unpause")
func _input(event):
	if event.is_action_pressed("Pause"):
		swap_pause_state()
func unpause():
	get_tree().paused = false
	paused = false
	hide_all_tabs()
func hide_all_tabs():
	controls.show()
	margin_container.hide()
	hide()
func _on_settings_button_up():
	margin_container.show()
	controls.show()
	controls.grab_focus.call_deferred()
func _on_exit_game_button_up():
	get_tree().quit()
func _on_restart_button_up() -> void:
	swap_pause_state()
	get_tree().reload_current_scene()
func _on_resume_button_up() -> void:
	swap_pause_state()
