extends Area2D

@export var damage_amount := 10


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_objects"):
		body.damage(damage_amount)
