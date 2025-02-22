class_name Level extends Node2D

@export var tile_maps: Node2D
@export var enemies_container: Node2D
@export var non_player_characters_container: Node2D
@export var obstacles_container: Node2D
@export var interactables_container: Node2D
@export var game_events_container: Node2D
@export var player_one: PlayerCharacter
@export var player_two: PlayerCharacter

@onready var player_characters: Array[PlayerCharacter] = [player_one, player_two]
@onready
var non_player_characters: Array[Node] = non_player_characters_container.get_children()


func _ready() -> void:
	for game_event in game_events_container.get_children():
		game_event.spawn_enemies.connect(_on_spawn_enemies)
		game_event.target_player.connect(_on_target_player)
		game_event.target_closest_player.connect(_on_target_closest_player)
		game_event.target_random_player.connect(_on_target_random_player)
		game_event.target_closest_npc.connect(_on_target_closest_npc)
		game_event.target_random_npc.connect(_on_target_random_npc)


func _on_spawn_enemies(enemy: Enemy, enemy_global_position: Vector2) -> void:
	enemies_container.add_child(enemy)
	enemy.global_position = enemy_global_position


func _on_target_player(enemy: Enemy, player: PlayerCharacter.Player) -> void:
	if player == PlayerCharacter.Player.FIRST:
		enemy.target = player_one
	else:
		enemy.target = player_two


func _on_target_closest_player(enemy: Node2D) -> void:
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


func _on_target_random_player(enemy: Node2D) -> void:
	enemy.target = player_characters.pick_random()


func _on_target_closest_npc(enemy: Node2D) -> void:
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


func _on_target_random_npc(enemy: Node2D) -> void:
	enemy.target = non_player_characters.pick_random()
