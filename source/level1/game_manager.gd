extends Node2D

@export var lever1 : StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lever1.finished_interaction.connect(removelever1)


func removelever1() -> void:
	lever1.queue_free()
