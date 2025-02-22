extends MarginContainer

@export var level1: String = "res://source/main.tscn"
@export var start_button: Button
@export var how_to_play: Button
@export var exit_button: Button

@export var how_to_panel: Panel

var showing_panel: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.button_up.connect(start)
	how_to_play.button_up.connect(tutorial)
	exit_button.button_up.connect(exit)
	start_button.call_deferred("grab_focus")


func start() -> void:
	get_tree().change_scene_to_file(level1)


func tutorial() -> void:
	how_to_panel.show()
	await get_tree().create_timer(.5).timeout
	showing_panel = true


func exit() -> void:
	get_tree().quit()


func _unhandled_key_input(_event: InputEvent) -> void:
	if showing_panel:
		how_to_panel.hide()
		showing_panel = false
