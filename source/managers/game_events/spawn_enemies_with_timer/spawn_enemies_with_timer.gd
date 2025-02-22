extends GameEvent

@export var spawn_timer: Timer
@export var spawn_locations: Array[Node2D]
@export var enemies: Array[PackedScene]

@export var spawn_time: float = 10.0


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start(spawn_time)


func activate() -> void:
	var random_spawn_location: Vector2 = spawn_locations.pick_random().global_position
	var random_enemy: Enemy = enemies.pick_random().instantiate()

	spawn_enemies.emit(random_enemy, random_spawn_location)
	target_random_player.emit(random_enemy)


func _on_spawn_timer_timeout() -> void:
	spawn_timer.start(spawn_time)
	activate()
