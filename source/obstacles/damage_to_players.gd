extends Area2D

@export var damage_amount : float = 10.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_character"):
		body.damage(damage_amount)
