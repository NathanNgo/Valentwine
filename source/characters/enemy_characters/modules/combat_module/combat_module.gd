class_name CombatModule extends RayCast2D

static var idle_animation := "idle"
static  var attack_animation := "attack"
@export var health: float = 100
@export var damage_amount: float = 10.0
@export var stagger_threshold: float = 10
##how long they get staggered when they receive enough damage
@export var stagger_time: float = 1.0
@export var KO_time : float = 5.0
@export var attack_range: float = 300.0
@export var cause_stagger: bool = true
@export var animation_player: AnimationPlayer
@export var stagger_timer: Timer
@export var death_sound : FmodEventEmitter2D
var _current_stagger_count: float = 0.0

@onready var parent: Enemy = $".."


func _ready() -> void:
	stagger_timer.timeout.connect(return_to_idle)


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
		KO()

	_current_stagger_count += damage_taken
	if _current_stagger_count >= stagger_threshold:
		parent.state = Enemy.States.STAGGERED
		parent.position = global_position + attack_direction * 10
		stagger_timer.start(stagger_time)


func KO() -> void:
	parent.state = Enemy.States.KO
	stagger_timer.start(KO_time)


func start_attack(attack_target: Node2D, attack_direction: Vector2) -> void:
	animation_player.play(attack_animation)
	parent.state = Enemy.States.ATTACK
	attack_target.damage(damage_amount, attack_direction)


func return_to_idle() -> void:
	animation_player.play(idle_animation)
	parent.state = Enemy.States.IDLE
	_current_stagger_count = 0



func die() -> void:
	return
