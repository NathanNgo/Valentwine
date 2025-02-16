extends Node2D

const SPAWN_TIME = 2

@export var line: Node2D
@export var player_one: CharacterBody2D
@export var player_two: CharacterBody2D
@export var enemies_container: Node2D
@export var obstacles_container: Node2D
@export var enemy_spawn_timer: Timer
@export var enemy_scene: PackedScene
@export var point_sampler: PathFollow2D
@export var health_bar: ProgressBar

var health := 100


func _ready() -> void:
	for enemy in enemies_container.get_children():
		enemy.body_hit.connect(_on_body_hit)

	for obstacle in obstacles_container.get_children():
		obstacle.body_hit.connect(_on_body_hit)
	
	player_one.took_damage.connect(_on_body_hit)
	player_two.took_damage.connect(_on_body_hit)
	enemy_spawn_timer.timeout.connect(_on_enemy_spawn_timer_timeout)
	enemy_spawn_timer.start(SPAWN_TIME)
	health_bar.value = health


func _physics_process(_delta: float) -> void:
	line.set_end_positions(player_one.position, player_two.position)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.target(line.line_body.position)


func _on_body_hit(damage: float) -> void:
	health -= damage
	health_bar.value = health


func _on_enemy_spawn_timer_timeout():
	enemy_spawn_timer.start(SPAWN_TIME)
	var enemy_instance = enemy_scene.instantiate()
	enemies_container.add_child(enemy_instance)
	point_sampler.progress_ratio = randf_range(0.0, 1.0)
	enemy_instance.position = point_sampler.position
	enemy_instance.body_hit.connect(_on_body_hit)
