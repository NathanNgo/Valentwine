extends Area2D

@export var game_events : Array[GameEvent]

@export var activations : int = 1

func _ready() -> void:
	body_entered.connect(activate)


func activate(body : Node2D) -> void:
	if activations <= 0:
		return
	if body.is_in_group(PlayerCharacter.player_group):
		activations -= 1
		for event in game_events:
			event.trigger_activated = true
			event.first_activation()
