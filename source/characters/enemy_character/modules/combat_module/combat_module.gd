class_name CombatModule extends RayCast2D

@export var health: float = 100
@export var damage_amount: float = 10.0
@export var stagger_threshold: float = 10
@export var stagger_time: float = 1.0
@export var attack_range: float = 300.0
@export var cause_stagger: bool = true

var _current_stagger_count: float = 0.0

@onready var parent: Enemy = $".."
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var stagger_timer: Timer = $StaggerTimer


func _process(_delta: float) -> void:
	if parent.state != Enemy.States.IDLE:
		return

	target_position = parent.movement_direction * attack_range
	if is_colliding():
		var attack_target: Node2D = get_collider()
		if attack_target.is_in_group("player_character"):
			start_attack(attack_target, parent.movement_direction)


func damage(damage_taken: float, attack_direction: Vector2 = Vector2.ZERO) -> void:
	health -= damage_taken
	if health <= 0:
		parent.state = Enemy.States.BLOCKED
		die()

	_current_stagger_count += damage_taken
	if _current_stagger_count >= stagger_threshold:
		parent.state = Enemy.States.STAGGERED
		parent.position = global_position + attack_direction * 10
		stagger_timer.start(stagger_time)


func die() -> void:
	animation_player.play("death")


func start_attack(attack_target: Node2D, attack_direction: Vector2) -> void:
	animation_player.play("attack")
	parent.state = Enemy.States.ATTACK
	attack_target.damage(damage_amount, attack_direction)


func return_to_idle() -> void:
	parent.state = Enemy.States.IDLE
	_current_stagger_count = 0
