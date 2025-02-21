extends Node2D

@export var lever: StaticBody2D
@export var first_punchy : Enemy

var defeated_counter : int = 0

func _ready() -> void:
	lever.interaction_finished.connect(_on_interaction_finished)
	first_punchy.died.connect(open_door)


func _on_interaction_finished() -> void:
	lever.queue_free()


func open_door() -> void:
	pass
