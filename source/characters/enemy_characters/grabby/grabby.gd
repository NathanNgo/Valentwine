class_name Grabby extends Enemy


@export var ray_cast: RayCast2D
@export var attack_range: float = 300.0
@export var escape_requirement := 10


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	ray_cast.target_position = movement_direction * attack_range

	if not ray_cast.is_colliding():
		return

	var collider := ray_cast.get_collider()

	if not collider.is_in_group(PlayerCharacter.player_character_group):
		return

	state = States.ESCAPING
	collider.state = PlayerCharacter.State.GRABBED
	collider.escape_requirement = escape_requirement
	collider.velocity = -movement_direction * speed


