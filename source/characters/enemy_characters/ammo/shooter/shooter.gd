extends Node2D

"""for now, this entire script is a temporal patch to test that the ammo works properly"""
@export var fate_line: Node2D
@export var timer: Timer
@export var ammo: PackedScene


func _ready() -> void:
	timer.timeout.connect(spawn_ammo)


func spawn_ammo() -> void:
	var new_shot: Node2D = ammo.instantiate()
	new_shot.target = fate_line
	add_child(new_shot)
