extends Node

@export var main_menu_scene: String = "res://source/ui/main_menu.tscn"

@export var game_over_canvas: CanvasLayer
@export var pause_menu : CanvasLayer
@export var resume_button: Button
@export var pause_main_menu: Button
@export var pause_retry: Button
@export var pause_exit: Button
@export var main_menu: Button
@export var try_again: Button
@export var exit_game: Button

@export var health_bar: ProgressBar

var paused : bool = false

func _ready() -> void:
	resume_button.button_up.connect(swap_pause_state)
	pause_main_menu.button_up.connect(to_main_menu)
	pause_retry.button_up.connect(reload_level)
	pause_exit.button_up.connect(exit)
	main_menu.button_up.connect(to_main_menu)
	try_again.button_up.connect(reload_level)
	exit_game.button_up.connect(exit)
	health_bar.died.connect(on_lost)
	game_over_canvas.call_deferred("hide")


func on_lost() -> void:
	game_over_canvas.show()
	try_again.grab_focus()


func to_main_menu() -> void:
	unpause()
	get_tree().change_scene_to_file(main_menu_scene)


func reload_level() -> void:
	unpause()
	get_tree().reload_current_scene()


func exit() -> void:
	get_tree().quit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		swap_pause_state()


func swap_pause_state() -> void:
	if !paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pause_menu.show()
		get_tree().paused = true
		paused = true
		resume_button.grab_focus()
	else:
		unpause()


func unpause() -> void:
	get_tree().paused = false
	paused = false
	pause_menu.hide()
