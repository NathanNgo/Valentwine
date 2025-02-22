extends GameEvent

@export var spawn_timer: Timer
@export var spawn_locations: Array[Node2D]
@export var activation_timer: Timer
@export var enemies: Array[PackedScene]

@export var spawn_time: float = 10.0
@export var activation_time_limit := 30.0
@export var enable_activation_time_limit := true

var trigger_activated := true


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start(spawn_time)
	activation_timer.timeout.connect(_on_activation_timer_timeout)
	activation_timer.start(activation_time_limit)


func activate() -> void:
	var random_spawn_location: Vector2 = spawn_locations.pick_random().global_position
	var random_enemy: Enemy = enemies.pick_random().instantiate()

	spawn_enemies.emit(random_enemy, random_spawn_location)
	target_random_player.emit(random_enemy)


func _on_activation_timer_timeout() -> void:
	trigger_activated = false


func _on_spawn_timer_timeout() -> void:
	if not trigger_activated:
		return

	spawn_timer.start(spawn_time)
	activate()
