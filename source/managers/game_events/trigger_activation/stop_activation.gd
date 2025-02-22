extends Node2D

enum area_interaction{ON_ENTER, ON_EXIT}

@export var interactable : Interactable
@export var area_2d : Area2D
@export var game_events : Array[GameEvent]

@export var area_behavior : area_interaction = area_interaction.ON_ENTER

func _ready() -> void:
	if interactable:
		interactable.interaction_finished.connect(stop)
	if area_2d:
		match area_behavior:
			area_interaction.ON_ENTER:
				area_2d.body_entered.connect(stop_with_area)

			area_interaction.ON_EXIT:
				area_2d.body_exited.connect(stop_with_area)


func stop_with_area(body : Node2D) -> void:
	if body.is_in_group(PlayerCharacter.player_group):
		stop()


func stop() -> void:
	for event in game_events:
		event.trigger_activated = false
