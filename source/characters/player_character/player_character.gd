class_name PlayerCharacter extends CharacterBody2D

signal took_damage(damage_amount: float)

enum Player { FIRST, SECOND }

enum Controls { LEFT, RIGHT, UP, DOWN, INTERACT }
enum { STATE_BLOCKED, STATE_IDLE, STATE_WALKING, STATE_ATTACK}
var state = STATE_IDLE
var punches_in_a_row : int = 0
var punches_in_combo : int = 3
static var player_group = "player_objects"


@export var _player_one_sprite: Sprite2D
@export var _player_two_sprite: Sprite2D
@export var ray_cast_2d: RayCast2D
@export var player_type := Player.FIRST
@export var speed := 400
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var grace_time_between_punches : float = 1.0
@onready var grace_between_punches: Timer = $grace_between_punches


var control_schemes := {
	Player.FIRST:
	{
		Controls.LEFT: "player_one_left",
		Controls.RIGHT: "player_one_right",
		Controls.UP: "player_one_up",
		Controls.DOWN: "player_one_down",
		Controls.INTERACT: "player_one_interact"
	},
	Player.SECOND:
	{
		Controls.LEFT: "player_two_left",
		Controls.RIGHT: "player_two_right",
		Controls.UP: "player_two_up",
		Controls.DOWN: "player_two_down",
		Controls.INTERACT: "player_two_interact"
	}
}

@onready var selected_scheme: Dictionary = control_schemes[player_type]


func _ready() -> void:
	_player_one_sprite.hide()
	_player_two_sprite.hide()

	if player_type == Player.FIRST:
		_player_one_sprite.show()
	elif player_type == Player.SECOND:
		_player_two_sprite.show()


func _physics_process(_delta: float) -> void:
	var direction = (
		Vector2(
			Input.get_axis(
				selected_scheme[Controls.LEFT], selected_scheme[Controls.RIGHT]
			),
			Input.get_axis(selected_scheme[Controls.UP], selected_scheme[Controls.DOWN])
		)
		. normalized()
	)
	ray_cast_2d.target_position = direction * 150
	match state:
		STATE_BLOCKED:
			return
		STATE_IDLE:
			if ray_cast_2d.is_colliding():
				var attack_target := ray_cast_2d.get_collider()
				if attack_target == null:
					return
				if attack_target.is_in_group("enemies"):
					attack(attack_target, direction)
					return
				if attack_target.is_in_group("interactable"):
					pass
			velocity = direction * speed
	move_and_slide()

func damage(how_much : float, attack_direction : Vector2, stagger : bool):
	took_damage.emit(how_much)
	if stagger:
		global_position = global_position + attack_direction * 150
		
	

func attack(attack_target : Node2D, attack_direction : Vector2):
	grace_between_punches.stop()
	state = STATE_BLOCKED
	var damage_done : float = calculate_damage_with_modifiers(punches_in_a_row)
	attack_target.damage(damage_done, attack_direction)
	animation_player.play("punch%s" % [punches_in_a_row])
	punches_in_a_row = (punches_in_a_row + 1) % punches_in_combo
	pass


func calculate_damage_with_modifiers(number_in_combo : int) -> float:
	var total_damage = 0.0
	match number_in_combo:
		0:
			total_damage += 5
		1:
			total_damage += 10
		2:
			total_damage += 20
	return total_damage


func finish_attack():
	state = STATE_IDLE
	grace_between_punches.start(grace_time_between_punches)


func _on_grace_between_punches_timeout() -> void:
	punches_in_a_row = 0
