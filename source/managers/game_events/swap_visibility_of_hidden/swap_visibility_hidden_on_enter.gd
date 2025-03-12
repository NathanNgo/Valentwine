extends GameEvent

@export var triger_show_area: Area2D
@export var triger_hide_area: Area2D
@export var target_object : Node


func _ready() -> void:
	triger_show_area.body_entered.connect(_on_body_entered_area_show)
	triger_hide_area.body_entered.connect(_on_body_entered_area_hide)


func	_on_body_entered_area_show(body: Node2D) -> void:
	if body.is_in_group(PlayerCharacter.player_group):
		target_object.show()


func	_on_body_entered_area_hide(body: Node2D) -> void:
	if body.is_in_group(PlayerCharacter.player_group):
		target_object.hide()
