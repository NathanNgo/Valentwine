extends CombatModule

@export var interact: Interactable
@export var speed_grabbing: int

@export var special_animation_player: AnimationPlayer

var original_speed: int
var _grabbed_player: PlayerCharacter


func _ready() -> void:
	stagger_timer.timeout.connect(return_to_idle)
	original_speed = parent.speed
	interact.interaction_finished.connect(stagger_after_grab)


func _process(_delta: float) -> void:
	if parent.state != Enemy.States.IDLE and parent.state != Enemy.States.ESCAPING:
		return

	if is_colliding():
		var attack_target: Node2D = get_collider()
		if attack_target.is_in_group("player_character"):
			start_attack(attack_target, parent.movement_direction)

	target_position = parent.movement_direction * attack_range
	if parent.state == parent.States.ESCAPING:
		if not _grabbed_player:
			return

		_grabbed_player.get_pushed(-parent.movement_direction * speed_grabbing)
		return


func damage(damage_taken: float, attack_direction: Vector2 = Vector2.ZERO) -> void:
	health -= damage_taken
	if health <= 0:
		parent.state = Enemy.States.BLOCKED
		if _grabbed_player != null:
			_grabbed_player.close_interaction()
			_grabbed_player = null

	_current_stagger_count += damage_taken
	if _current_stagger_count >= stagger_threshold:
		if _grabbed_player != null:
			_grabbed_player.close_interaction()
			_grabbed_player = null
		parent.state = Enemy.States.STAGGERED
		stagger_timer.start(stagger_time)
		parent.position = global_position + attack_direction * 10


func start_attack(attack_target: Node2D, _attack_direction: Vector2) -> void:
	special_animation_player.play("grab")
	parent.state = Enemy.States.ESCAPING
	attack_target.current_interacting_object = interact
	interact.open_interaction(attack_target)
	_grabbed_player = attack_target
	parent.speed = speed_grabbing


func stagger_after_grab() -> void:
	if _grabbed_player != null:
		_grabbed_player = null
	parent.state = Enemy.States.STAGGERED
	stagger_timer.start(stagger_time)


func return_to_idle() -> void:
	animation_player.play(idle_animation)
	parent.state = Enemy.States.IDLE
	_current_stagger_count = 0
	parent.speed = original_speed


func die() -> void:
	if _grabbed_player != null:
		_grabbed_player.close_interaction()
		_grabbed_player = null
