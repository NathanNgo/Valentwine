class_name GameEvent extends Node2D

signal spawn_enemies(enemy: Enemy, enemy_global_position: Vector2)
signal target_player(enemy: Enemy, player: PlayerCharacter.Player)
signal target_closest_player(enemy: Enemy)
signal target_random_player(enemy: Enemy)
signal target_closest_npc(enemy: Enemy)
signal target_random_npc(enemy: Enemy)


func activate() -> void:
	# Implemented by sub-classes.
	pass
