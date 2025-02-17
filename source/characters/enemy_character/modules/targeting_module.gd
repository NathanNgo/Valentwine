extends Node2D

@export var line_length_limit : float = 300

@onready var parent: BasicEnemy = $".."

func _process(_delta: float) -> void:
	global_position = parent.global_position
	look_at(parent.player.position)
	var target_distance = parent.player.global_position.distance_to(global_position)
	target_distance = min(target_distance, line_length_limit)
	scale.x = target_distance
