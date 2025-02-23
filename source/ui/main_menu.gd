extends MarginContainer

@export var level1: String = "res://source/main.tscn"
@export var start_button: Button
@export var how_to_play: Button
@export var exit_button: Button
@export var comic : Control
@export var skip_label : Control
@export var how_to_panel: Panel


var showing_panel: bool = false
var showing_comic : bool = false
var comic_panel : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.button_up.connect(next_panel)
	how_to_play.button_up.connect(tutorial)
	exit_button.button_up.connect(exit)
	start_button.call_deferred("grab_focus")

	for i in comic.get_children():
		i.hide()
	comic_panel = 0
	skip_label.hide()


func start() -> void:
	get_tree().change_scene_to_file(level1)


func tutorial() -> void:
	how_to_panel.show()
	await get_tree().create_timer(.5).timeout
	showing_panel = true


func exit() -> void:
	get_tree().quit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		start()


func _unhandled_key_input(_event: InputEvent) -> void:
	if showing_panel:
		how_to_panel.hide()
		showing_panel = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("player_one_right"):
		next_panel()


func next_panel() -> void:
	skip_label.show()
	if comic_panel >= comic.get_child_count():
		start()
		return
	showing_comic = true
	comic.get_child(comic_panel).show()
	comic_panel += 1
