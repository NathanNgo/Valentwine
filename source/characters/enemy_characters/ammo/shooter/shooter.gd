extends Node2D

"""for now, this entire script is a temporal patch to test that the ammo works properly"""
@export var line: Node2D
@export var timer: Timer
@export var ammo: PackedScene
@export var active : bool = false
@export var trigger_area : Area2D
@export var stop_area : Area2D

func _ready() -> void:
	timer.timeout.connect(spawn_ammo)
	trigger_area.body_entered.connect(start_shooting)
	stop_area.body_entered.connect(stop_shooting)


func spawn_ammo() -> void:
	if !line:
		return
	var new_shot: Node2D = ammo.instantiate()
	new_shot.target = line
	add_child(new_shot)


func  start_shooting(body : Node2D) -> void:
	if body.is_in_group(PlayerCharacter.player_group):
		active = true


func stop_shooting(body : Node2D) -> void:
	if body.is_in_group(PlayerCharacter.player_group):
		active = false
