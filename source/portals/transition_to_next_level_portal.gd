extends Area2D

signal transition_level


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	set_collision_mask_value(PlayerCharacter.player_collision_layer, true)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(PlayerCharacter.player_group):
		transition_level.emit()
