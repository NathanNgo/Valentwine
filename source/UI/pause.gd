extends CanvasLayer


@export var main_menu_scene : String = "res://source/UI/main_menu.tscn"
@export var resume_button : Button
@export var main_menu_button : Button
@export var restart_button : Button
@export var exit_button : Button

var paused : bool = false
var delay : float = 0.5
var time_since_last_direction : float = 0
func _ready() -> void:
	resume_button.button_up.connect(swap_pause_state)
	main_menu_button.button_up.connect(_on_main_menu_button_up)
	restart_button.button_up.connect(_on_restart_button_up)
	exit_button.button_up.connect(_on_exit_game_button_up)
	call_deferred("hide")
	call_deferred("unpause")


func _input(event : InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		swap_pause_state()
	

func swap_pause_state() -> void:
	if !paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		show()
		get_tree().paused = true
		paused = true
	else:
		unpause()


func unpause() -> void:
	get_tree().paused = false
	paused = false
	hide()


func _on_main_menu_button_up() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu_scene)


func _on_exit_game_button_up() -> void:
	get_tree().paused = false
	get_tree().quit()


func _on_restart_button_up() -> void:
	get_tree().paused = false 
	swap_pause_state()


func _on_resume_button_up() -> void:
	swap_pause_state()
