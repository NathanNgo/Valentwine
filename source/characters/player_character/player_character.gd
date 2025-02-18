class_name PlayerCharacter extends CharacterBody2D

signal player_damaged(damage_amount: float)
signal stun_pressed
signal interrupted

enum Player { FIRST, SECOND }
enum Controls { LEFT, RIGHT, UP, DOWN, INTERACT }
enum State { BLOCKED, IDLE, WALKING, ATTACK, STUNNED }

static var player_group := "player_objects"

@export var _player_one_sprite: Sprite2D
@export var _player_two_sprite: Sprite2D
@export var ray_cast_2d: RayCast2D
@export var player_type := Player.FIRST
@export var speed := 400
@export var grace_time_between_punches := 1.0
@export var stagger_amount := 150
@export var attack_range := 150

@export var stun_container : Node2D
@export var _left_prompt : Sprite2D
@export var _right_prompt : Sprite2D
@export var grace_timer: Timer
@export var animation_player: AnimationPlayer

var state := State.IDLE
var current_stun_prompt := Controls.LEFT
var current_interacting_object : Node2D
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
			handle_stun(Controls.UP)
			if Input.is_action_just_pressed(selected_scheme[Controls.LEFT]):
				handle_stun(Controls.LEFT)
			if Input.is_action_just_pressed(selected_scheme[Controls.RIGHT]):
				handle_stun(Controls.RIGHT)
			return
		State.IDLE:
			idle(direction)

	velocity = direction * speed
	move_and_slide()


func idle(direction: Vector2) -> void:
	if not ray_cast_2d.is_colliding():
		return

	var attack_target: Node2D = ray_cast_2d.get_collider()

	if not attack_target:
		return

	if attack_target.is_in_group(Enemy.enemy_group):
		attack(attack_target, direction)
		return

	if attack_target.is_in_group("interactable"):
		current_interacting_object = attack_target
		current_interacting_object.finished_interaction.connect(resolve_interaction)
		attack_target.interact(self)
		pass


func damage(damage_amount: float, attack_direction: Vector2 = Vector2.ZERO) -> void:
	player_damaged.emit(damage_amount)
	global_position = global_position + attack_direction * stagger_amount
	interrupt_interaction()


func attack(attack_target: Node2D, attack_direction: Vector2 = Vector2.ZERO) -> void:
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


func resolve_interaction() -> void:
	current_interacting_object.finished_interaction.disconnect(resolve_interaction)
	current_interacting_object = null
	state = State.IDLE


func interrupt_interaction() -> void:
	interrupted.emit()
	if current_interacting_object:
		current_interacting_object.finished_interaction.disconnect(resolve_interaction)
	state = State.IDLE
	current_interacting_object = null


func handle_stun(which_button_pressed : Controls) -> void:
	if current_stun_prompt == Controls.LEFT:
		_left_prompt.show()
		_right_prompt.hide()
	if current_stun_prompt == Controls.RIGHT:
		_left_prompt.hide()
		_right_prompt.show()
	if which_button_pressed == current_stun_prompt and current_stun_prompt == Controls.LEFT:
		current_stun_prompt = Controls.RIGHT
		stun_pressed.emit()
	if which_button_pressed == current_stun_prompt and current_stun_prompt == Controls.RIGHT:
		current_stun_prompt = Controls.LEFT
		stun_pressed.emit()


func _on_grace_timer_timeout() -> void:
	punches_in_a_row = 0
