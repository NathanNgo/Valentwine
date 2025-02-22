extends GameEvent

@export var triger_area: Area2D
@export var target_object : Node2D
@export var timer : Timer

@export var delay_before_hide : int = 10

func _ready() -> void:
	triger_area.body_entered.connect(_on_body_entered_trigger_area)
	timer.timeout.connect(_hide_again)


func	_on_body_entered_trigger_area(body: Node2D) -> void:
	if body.is_in_group(PlayerCharacter.player_group):
		target_object.hide()
		timer.start(delay_before_hide)


func _hide_again() -> void:
	target_object.show()
