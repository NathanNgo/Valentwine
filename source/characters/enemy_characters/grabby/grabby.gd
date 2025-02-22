class_name Grabby extends Enemy


@export var ray_cast: RayCast2D
@export var attack_range: float = 300.0
@export var escape_requirement := 10
@export var grabbed_player: PlayerCharacter = null


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
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
	state = States.STAGGERED
	grabbed_player.grabbing_object = null
	grabbed_player.state = PlayerCharacter.State.IDLE
	grabbed_player.stun_container.hide()
	grabbed_player = null


func die() -> void:
	player_escaped()
	super.die()