extends GameEvent

@export var trigger_areas: Array[Area2D]
@export var spawn_locations: Array[Node2D]
@export var activation_timer: Timer
@export var spawn_timer: Timer
@export var enemies: Array[PackedScene]

@export var spawn_time: float = 1.0
@export var activation_time_limit := 10.0
@export var enable_activation_time_limit := true
@export var one_shot := true

var trigger_activated := false
var alive_enemies: Array[Enemy] = []
var previously_triggered := false


func _ready() -> void:
	for trigger_area in trigger_areas:
		trigger_area.body_entered.connect(_on_body_entered_trigger_area)
		trigger_area.body_exited.connect(_on_body_exited_trigger_area)
		trigger_area.set_collision_mask_value(Enemy.enemy_collision_layer, true)

	activation_timer.timeout.connect(_on_activation_timer_timeout)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)


func activate() -> void:
	var random_spawn_location: Vector2 = spawn_locations.pick_random().global_position
	var random_enemy: Enemy = enemies.pick_random().instantiate()

	spawn_enemies.emit(random_enemy, random_spawn_location)
	target_random_player.emit(random_enemy)


func _on_body_entered_trigger_area(body: Node2D) -> void:
	if body.is_in_group(Enemy.enemy_group):
		alive_enemies.append(body)


func _on_body_exited_trigger_area(body: Node2D) -> void:
	if one_shot and previously_triggered:
		return

	if body.is_in_group(Enemy.enemy_group):
		alive_enemies.erase(body)

	if alive_enemies.size() == 0:
		trigger_activated = true
		previously_triggered = true
		spawn_timer.start(spawn_time)
		activate()

	if enable_activation_time_limit:
		activation_timer.start(activation_time_limit)


func _on_activation_timer_timeout() -> void:
	trigger_activated = false


func _on_spawn_timer_timeout() -> void:
	if not trigger_activated:
		return

	spawn_timer.start(spawn_time)
	activate()