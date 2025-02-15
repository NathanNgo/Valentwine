extends Node2D
@export var player1 : CharacterBody2D
@export var player2 : CharacterBody2D
@onready var scalable_parent: Node2D = $scalable_parent
@onready var ray_cast_2d: RayCast2D = $RayCast2D
var received_data_from_both_players : int = 0
var attempted_position1 : Vector2
var attempted_position2 : Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = player1.position
	scalable_parent.look_at(player2.position)
	scalable_parent.scale.x = player1.position.distance_to(player2.position)
func check_for_collisions(player_number, checked_position):
	received_data_from_both_players += 1
	if player_number == 1:
		attempted_position1 = checked_position
	if player_number == 2:
		attempted_position2 = checked_position
	if received_data_from_both_players <2:
		return
	received_data_from_both_players = 0
	ray_cast_2d.global_position = attempted_position1
	ray_cast_2d.target_position = attempted_position2 - attempted_position1
	ray_cast_2d.force_raycast_update()
	if ray_cast_2d.is_colliding():
		player1.movement_obstructed = true
		player2.movement_obstructed = true
	else:
		player1.movement_obstructed = false
		player2.movement_obstructed = false
