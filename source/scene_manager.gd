extends Node

@export var main_menu_scene : String = "res://source/UI/main_menu.tscn"

@export var GameOver_canvas : CanvasLayer
@export var main_menu : Button
@export var try_again : Button
@export var exit_game : Button

@export var health_bar : ProgressBar

func _ready() -> void:
	main_menu.button_up.connect(to_main_menu)
	try_again.button_up.connect(reload_level)
	exit_game.button_up.connect(exit)
	health_bar.died.connect(on_lost)
	GameOver_canvas.call_deferred("hide")


func on_lost() -> void:
	
	GameOver_canvas.show()
	try_again.grab_focus()


func to_main_menu() -> void:
	get_tree().change_scene_to_file(main_menu_scene)


func reload_level() -> void:
	get_tree().reload_current_scene()


func exit() -> void:
	get_tree().quit()
