extends Node2D

@export var line_length_limit: float = 300

@onready var parent: Enemy = $".."


func _process(_delta: float) -> void:
	if not parent.target:
		return

	global_position = parent.global_position
	look_at(parent.target.position)
	var target_distance: float = parent.target.global_position.distance_to(global_position)
	target_distance = min(target_distance, line_length_limit)
	scale.x = target_distance
