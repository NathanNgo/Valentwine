class_name Level extends Node2D

signal damage_taken(damage: float)
signal transition_level

@export var tile_maps: Node2D
@export var enemies_container: Node2D
@export var non_player_characters_container: Node2D
@export var obstacles_container: Node2D
@export var interactables_container: Node2D
@export var portals_container: Node2D
@export var game_events_container: Node2D

@export var line: Node2D
@export var player_one: PlayerCharacter
@export var player_two: PlayerCharacter
@export var trailing_line_one: Node2D
@export var trailing_line_two: Node2D
@export var trailing_line_draw_timer: Timer
@export var trailing_line_draw_time := 0.05

@onready var player_characters: Array[PlayerCharacter] = [player_one, player_two]
@onready
var non_player_characters: Array[Node] = non_player_characters_container.get_children()


func _ready() -> void:
	get_viewport().transparent_bg = true
	for game_event in game_events_container.get_children():
		game_event.spawn_enemies.connect(_on_spawn_enemies)
		game_event.target_player.connect(_on_target_player)
		game_event.target_closest_player.connect(_on_target_closest_player)
		game_event.target_random_player.connect(_on_target_random_player)
		game_event.target_closest_npc.connect(_on_target_closest_npc)
		game_event.target_random_npc.connect(_on_target_random_npc)

	player_one.player_damaged.connect(_on_damage_taken)
	player_two.player_damaged.connect(_on_damage_taken)
	line.line_body.player_damaged.connect(_on_damage_taken)

	trailing_line_draw_timer.timeout.connect(_on_trailing_line_draw_timer)
	trailing_line_draw_timer.start(trailing_line_draw_time)

	for portal in portals_container.get_children():
		portal.transition_level.connect(_on_transition_level)


func _physics_process(_delta: float) -> void:
	line.set_end_positions(
		player_one.line_point.global_position, player_two.line_point.global_position
	)


func _on_spawn_enemies(enemy: Enemy, enemy_global_position: Vector2) -> void:
	enemies_container.add_child(enemy)
	enemy.global_position = enemy_global_position


func _on_target_player(enemy: Enemy, player: PlayerCharacter.Player) -> void:
	if player == PlayerCharacter.Player.FIRST:
		enemy.target = player_one
	else:
		enemy.target = player_two


func _on_target_closest_player(enemy: Enemy) -> void:
	var closest_distance := enemy.global_position.distance_to(
		player_characters[0].global_position
	)
	var closest_player: PlayerCharacter = player_characters[0]

	for player_character in player_characters:
		if (
			enemy.global_position.distance_to(player_character.global_position)
			< closest_distance
		):
			closest_player = player_character

	enemy.target = closest_player


func _on_target_random_player(enemy: Enemy) -> void:
	enemy.target = player_characters.pick_random()


func _on_target_closest_npc(enemy: Enemy) -> void:
	# TODO: Make a proper class for Non Player Characters, instead of using Node2D.
	var closest_distance := enemy.global_position.distance_to(
		non_player_characters[0].global_position
	)
	var closest_non_player_character: Node2D = non_player_characters[0]

	for non_player_character in non_player_characters:
		if (
			enemy.global_position.distance_to(non_player_character.global_position)
			< closest_distance
		):
			closest_non_player_character = non_player_character

	enemy.target = closest_non_player_character


func _on_target_random_npc(enemy: Enemy) -> void:
	enemy.target = non_player_characters.pick_random()


func _on_trailing_line_draw_timer() -> void:
	var possible_intersection_player_one: Variant = trailing_line_one.add_point(
		player_one.draw_point.global_position
	)
	if possible_intersection_player_one:
		_kill_circled_enemies(
			possible_intersection_player_one["intersection"],
			possible_intersection_player_one["start_point"],
			trailing_line_one
		)
		trailing_line_one.clear_line()

	var possible_intersection_player_two: Variant = trailing_line_two.add_point(
		player_two.draw_point.global_position
	)
	if possible_intersection_player_two:
		_kill_circled_enemies(
			possible_intersection_player_two["intersection"],
			possible_intersection_player_two["start_point"],
			trailing_line_two
		)
		trailing_line_two.clear_line()

	trailing_line_draw_timer.start(trailing_line_draw_time)


func _on_damage_taken(damage: float) -> void:
	damage_taken.emit(damage)


func _kill_circled_enemies(
	intersection: Vector2, start_point: int, trailing_line: TrailingLine
) -> void:
	for enemy in enemies_container.get_children():
		if Geometry2D.is_point_in_polygon(
			enemy.global_position,
			trailing_line.get_closed_polygon(intersection, start_point)
		):
			enemy.die()


func _on_transition_level() -> void:
	transition_level.emit()
