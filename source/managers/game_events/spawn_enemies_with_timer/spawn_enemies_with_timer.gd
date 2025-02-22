extends GameEvent

@export var timer: Timer
@export var spawn_locations: Array[Node2D]
@export var enemies: Array[PackedScene]

@export var spawn_time: float


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	timer.start(spawn_time)


func activate() -> void:
	var random_spawn_location := spawn_locations.pick_random()
	var random_enemy: Enemy = enemies.pick_random().instantiate()

	spawn_enemies.emit(random_enemy, random_spawn_location)


func _on_timer_timeout() -> void:
	timer.start(spawn_time)
	activate()
