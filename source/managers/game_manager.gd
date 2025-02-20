extends Node2D

@export var lever: StaticBody2D

func _ready() -> void:
	lever.interaction_finished.connect(_on_interaction_finished)
	


func _on_interaction_finished() -> void:
	lever.queue_free()
