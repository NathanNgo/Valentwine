extends Area2D

@export var health : float = 50
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)


func on_body_entered(body : Node2D) -> void:
	if body.is_in_group(PlayerCharacter.player_group):
		body.damage(-health)
		queue_free()
