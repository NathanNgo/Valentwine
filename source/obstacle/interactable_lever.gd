extends StaticBody2D

signal finished_interaction

@export var press_number : int = 5

var already_interacting : bool = false

var _player : PlayerCharacter
var _presses : int = 0

func interact(player : PlayerCharacter) -> void:
	_presses = 0
	_player = player
	player.stun_pressed.connect(on_button_press)
	player.interrupted.connect(interrupted)
	player.state = player.State.STUNNED
	already_interacting = true



func on_button_press() -> void:
	_presses = (_presses + 1) % press_number
	if _presses == 0:
		finished_interaction.emit()
		already_interacting = false
		_player.stun_pressed.disconnect(on_button_press)
		_player.interrupted.disconnect(interrupted)


func interrupted() -> void:
	if _player:
		_player.stun_pressed.disconnect(on_button_press)
		_player.interrupted.disconnect(interrupted)
	already_interacting = false
	_presses = 0
