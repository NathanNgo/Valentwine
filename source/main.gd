extends Node2D

const SPAWN_TIME = 2
const TRAILING_LINE_DRAW_TIME = 0.05

@export var line: Node2D
@export var player_one: CharacterBody2D
@export var player_two: CharacterBody2D
@export var enemies_container: Node2D
@export var obstacles_container: Node2D
@export var point_sampler: PathFollow2D
@export var health_bar: ProgressBar
@export var trailing_line_one: Node2D
@export var trailing_line_two: Node2D
@export var trailing_line_draw_timer: Timer
@export var ui_manager: Node


var health := 100.0

@onready var targetable_players: Array[Node2D] = [player_one, player_two]


func _ready() -> void:
	_assign_enemy_targets()

	player_one.player_damaged.connect(_on_damage_taken)
	player_two.player_damaged.connect(_on_damage_taken)
	line.line_body.player_damaged.connect(_on_damage_taken)

	ui_manager.health_bar.value = health

	trailing_line_draw_timer.timeout.connect(_on_trailing_line_draw_timer)
	trailing_line_draw_timer.start(TRAILING_LINE_DRAW_TIME)


func _physics_process(_delta: float) -> void:
	line.set_end_positions(player_one.position, player_two.position)


func _on_damage_taken(damage: float) -> void:
	health -= damage
	ui_manager.health_bar.value = health


func _assign_enemy_targets() -> void:
	for enemy in enemies_container.get_children():
		var random_target: Node2D = targetable_players.pick_random()
		enemy.target = random_target


func _on_trailing_line_draw_timer() -> void:
	var possible_intersection_player_one: Variant = trailing_line_one.add_point(
		player_one.draw_point.global_position
	)
	if possible_intersection_player_one:
		_kill_circled_enemies(
			possible_intersection_player_one["intersection"],
			possible_intersection_player_one["start_point"]
		)
		trailing_line_one.clear_line()

	var possible_intersection_player_two: Variant = trailing_line_two.add_point(
		player_two.draw_point.global_position
	)
	if possible_intersection_player_two:
		_kill_circled_enemies(
			possible_intersection_player_two["intersection"],
			possible_intersection_player_two["start_point"]
		)
		trailing_line_two.clear_line()

	trailing_line_draw_timer.start(TRAILING_LINE_DRAW_TIME)


func _kill_circled_enemies(intersection: Vector2, start_point: int) -> void:
	for enemy in enemies_container.get_children():
		if Geometry2D.is_point_in_polygon(
			enemy.global_position,
			trailing_line_one.get_closed_polygon(intersection, start_point)
		):
			enemy.die()
