class_name PlayerCharacter extends CharacterBody2D

signal player_damaged(damage_amount: float)
# signal stun_pressed

enum Player { FIRST, SECOND }
enum Controls { LEFT, RIGHT, UP, DOWN, INTERACT }
enum State { BLOCKED, IDLE, WALKING, ATTACK, STUNNED, STAGGERING }

static var player_group := "player_objects"
static var player_collision_layer := 4
static var walking_animation := "walking"

@export var _player_one_sprite: Sprite2D
@export var _player_two_sprite: Sprite2D
@export var ray_cast_2d: RayCast2D
@export var player_type := Player.FIRST
@export var speed := 400
@export var grace_time_between_punches := 1.0
@export var stagger_amount: float = 150
@export var stagger_speed: float = 75
@export var attack_range := 150

@export var stun_container: Node2D
@export var _left_prompt: Sprite2D
@export var _right_prompt: Sprite2D
@export var grace_timer: Timer
@export var animation_player: AnimationPlayer
@export var draw_point: Node2D
@export var line_point_one: Node2D
@export var line_point_two: Node2D

var staggering_distance: float = 0.0
var staggering_towards: Vector2
var state := State.IDLE
var current_stun_prompt := Controls.LEFT
var current_interacting_object: Node2D
var punches_in_a_row: int = 0
var punches_in_combo: int = 3
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
@onready
var line_point: Node2D = line_point_one if player_type == Player.FIRST else line_point_two


func _ready() -> void:
	_player_one_sprite.hide()
	_player_two_sprite.hide()
	stun_container.hide()

	if player_type == Player.FIRST:
		_player_one_sprite.show()
	elif player_type == Player.SECOND:
		_player_two_sprite.show()

	grace_timer.timeout.connect(_on_grace_timer_timeout)


func _physics_process(_delta: float) -> void:
	var direction := (
		Vector2(
			Input.get_axis(
				selected_scheme[Controls.LEFT], selected_scheme[Controls.RIGHT]
			),
			Input.get_axis(selected_scheme[Controls.UP], selected_scheme[Controls.DOWN])
		)
		. normalized()
	)

	ray_cast_2d.target_position = direction * attack_range
	stun_container.hide()

	match state:
		State.BLOCKED:
			return

		State.STUNNED:
			stun_container.show()
			stun(Controls.UP)

			if Input.is_action_just_pressed(selected_scheme[Controls.LEFT]):
				stun(Controls.LEFT)

			if Input.is_action_just_pressed(selected_scheme[Controls.RIGHT]):
				stun(Controls.RIGHT)

			return

		State.IDLE:
			idle(direction)

		State.STAGGERING:
			velocity = staggering_towards * stagger_speed / _delta
			# how long has the player been pushed
			staggering_distance += staggering_towards.length() * stagger_speed

			if staggering_distance >= stagger_amount:
				state = State.IDLE

			move_and_slide()

			return

	velocity = direction * speed

	move_and_slide()


func idle(direction: Vector2) -> void:
	if !animation_player.is_playing():
		animation_player.play(walking_animation)
	if not ray_cast_2d.is_colliding():
		return

	var target: Node2D = ray_cast_2d.get_collider()

	if not target:
		return

	if target.is_in_group(Enemy.enemy_group):
		attack(target, direction)
		return

	if target.is_in_group(Interactable.interactable_group):
		current_interacting_object = target
		current_interacting_object.open_interaction(self)


func get_pushed(direction: Vector2) -> void:
	velocity = direction
	move_and_slide()


func damage(damage_amount: float, attack_direction: Vector2 = Vector2.ZERO) -> void:
	player_damaged.emit(damage_amount)
	state = State.STAGGERING
	staggering_towards = attack_direction
	close_interaction()


func attack(attack_target: Node2D, attack_direction: Vector2 = Vector2.ZERO) -> void:
	if attack_target.is_in_group(Enemy.enemy_group):
		if attack_target.state == Enemy.States.KO:
			return

	grace_timer.stop()
	state = State.BLOCKED
	var damage_done: float = calculate_damage_with_modifiers(punches_in_a_row)

	if attack_target.is_in_group(Enemy.enemy_group):
		attack_target.damage(damage_done, attack_direction)
		animation_player.play("punch%s" % [punches_in_a_row])
		punches_in_a_row = (punches_in_a_row + 1) % punches_in_combo


func calculate_damage_with_modifiers(number_in_combo: int) -> float:
	var total_damage := 0.0
	match number_in_combo:
		0:
			total_damage += 5
		1:
			total_damage += 10
		2:
			total_damage += 20
	return total_damage


func finish_attack() -> void:
	state = State.IDLE
	grace_timer.start(grace_time_between_punches)


func close_interaction() -> void:
	if not current_interacting_object:
		return

	state = State.IDLE
	current_interacting_object = null
	current_stun_prompt = Controls.UP


func stun(button_pressed: Controls) -> void:
	if current_stun_prompt == Controls.LEFT:
		_left_prompt.show()
		_right_prompt.hide()

	if current_stun_prompt == Controls.RIGHT:
		_left_prompt.hide()
		_right_prompt.show()

	if button_pressed == current_stun_prompt and current_stun_prompt == Controls.LEFT:
		current_stun_prompt = Controls.RIGHT
		current_interacting_object.interact()

	if button_pressed == current_stun_prompt and current_stun_prompt == Controls.RIGHT:
		current_stun_prompt = Controls.LEFT
		current_interacting_object.interact()


func _on_grace_timer_timeout() -> void:
	punches_in_a_row = 0
