extends CharacterBody2D

signal player_damaged(damage_amount: float)

func damage(damage_amount: float, _attack_direction: Vector2 = Vector2.ZERO) -> void:
	player_damaged.emit(damage_amount)