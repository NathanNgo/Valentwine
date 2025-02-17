extends RayCast2D


@onready var parent: BasicEnemy = $".."
@export var health : float = 100
@export var damage : float = 10.0
@export var stagger_threshold : float = 10
@export var stagger_time : float = 1.0
var current_stagger_count : float = 0.0
@export var attack_range : float = 300.0
@export var cause_stagger : bool = true
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var stagger_timer: Timer = $StaggerTimer

func _ready() -> void:
	parent.take_damage.connect(take_damage)


func _process(_delta: float) -> void:
	if parent.state != BasicEnemy.States.STATE_IDLE:
		return
	target_position = parent.movement_direction * attack_range
	if is_colliding():
		var attack_target := get_collider()
		if attack_target.is_in_group("player_character"):
			start_attack(attack_target, parent.movement_direction)


func take_damage(damage_taken, attack_direction):
	health -= damage_taken
	if health <= 0:
		parent.state = BasicEnemy.States.STATE_BLOCKED
		die()
	
	current_stagger_count += damage_taken
	if current_stagger_count >= stagger_threshold:
		parent.state = BasicEnemy.States.STATE_STAGGER
		parent.position = global_position + attack_direction * 10
		stagger_timer.start(stagger_time)

func  die():
	animation_player.play("death")


func start_attack(attack_target : Node2D, attack_direction : Vector2):
	animation_player.play("attack")
	parent.state = BasicEnemy.States.STATE_ATTACK
	attack_target.damage(damage, attack_direction, cause_stagger)


func return_to_idle():
	parent.state = BasicEnemy.States.STATE_IDLE
	current_stagger_count = 0
