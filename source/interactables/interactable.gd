class_name Interactable extends Node2D

static var interactable_group := "interactable"

@export var number_of_presses_required: int = 5

var _presses: int = 0
var _player: PlayerCharacter


func open_interaction(player: PlayerCharacter) -> void:
	if _player != null:
		# If the player is not null, we're already interacting.
		return

	_player = player
	player.state = PlayerCharacter.State.STUNNED


func close_interaction() -> void:
	_presses = 0
	_player = null


func interact() -> void:
	_presses += 1

	if _player == null:
		return

	if _presses != number_of_presses_required:
		return

	if not _player.has_method("close_interaction"):
		return

	_player.close_interaction()


func _finish_interaction() -> void:
	# Implemented by sub-classes.
	pass
