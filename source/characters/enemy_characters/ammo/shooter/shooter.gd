extends Node2D

"""for now, this entire script is a temporal patch to test that the ammo works properly"""
@export var line: Node2D
@export var timer: Timer
@export var ammo: PackedScene
@export var active : bool = false
@export var trigger_area : Area2D
@export var stop_area : Area2D
@export var fire_delay : float = 1.0

func _ready() -> void:
	timer.timeout.connect(spawn_ammo)
	if trigger_area:
		trigger_area.body_entered.connect(start_shooting)
	if stop_area:
		stop_area.body_entered.connect(stop_shooting)


func spawn_ammo() -> void:
	if !line or !active:
		return
	var new_shot: Node2D = ammo.instantiate()
	new_shot.target = line.get_node("Line")
	add_child(new_shot)


func  start_shooting(body : Node2D) -> void:
	if body.is_in_group(PlayerCharacter.player_group):
		active = true
		timer.start(fire_delay)


func stop_shooting(body : Node2D) -> void:
	if body.is_in_group(PlayerCharacter.player_group):
		active = false
		timer.stop()
