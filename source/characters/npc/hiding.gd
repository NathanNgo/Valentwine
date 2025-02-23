extends Area2D

@export var animation_player : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)
	animation_player.play("happy")

func on_body_entered(body : Node2D) -> void:
	if body.is_in_group(PlayerCharacter.player_group):
		queue_free()
