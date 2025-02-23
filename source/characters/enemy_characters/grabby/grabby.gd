class_name Grabby extends Enemy

@export var ray_cast: RayCast2D
@export var attack_range: float = 300.0
@export var escape_requirement := 10
@export var grabbed_player: PlayerCharacter = null
@export var grace_timer: Timer
@export var grace_time: float = 3.0
var has_player_escaped := false


func _ready() -> void:
	super._ready()

	grace_timer.timeout.connect(_on_grace_timer_timeout)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if has_player_escaped:
		has_player_escaped = false
		state = States.BLOCKED
		grabbed_player.grabbing_object = null
		grabbed_player.state = PlayerCharacter.State.IDLE
		grabbed_player.stun_container.hide()
		grabbed_player = null
		ray_cast.target_position = Vector2.ZERO
		return

	if state == States.BLOCKED:
		return

	if grabbed_player:
		grabbed_player.velocity = -movement_direction * speed
		return

	ray_cast.target_position = movement_direction * attack_range

	if not ray_cast.is_colliding():
		return

	var collider := ray_cast.get_collider()

	if not collider.is_in_group(PlayerCharacter.player_character_group):
		return

	state = States.ESCAPING
	collider.escape_requirement = escape_requirement
	collider.grabbing_object = self
	collider.state = PlayerCharacter.State.GRABBED
	grabbed_player = collider


func player_escaped() -> void:
	has_player_escaped = true
	grace_timer.start(grace_time)


func die() -> void:
	if grabbed_player:
		grabbed_player.state = PlayerCharacter.State.IDLE
		grabbed_player.grabbing_object = null
		grabbed_player.stun_container.hide()
		player_escaped()

	death_sprite.show()
	var animation_number := randi_range(1, 4)
	animation_player.play("death%s" % [animation_number])
	death_sound.play()
	died.emit()


func damage(_damage_taken: float, _attack_direction: Vector2 = Vector2.ZERO) -> void:
	pass


func _on_grace_timer_timeout() -> void:
	state = States.IDLE
