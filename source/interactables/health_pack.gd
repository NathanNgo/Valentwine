extends Area2D

@export var health : float = 50
@export var sound : FmodEventEmitter2D

var disabled : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)
	sound.stopped.connect(queue_free)


func on_body_entered(body : Node2D) -> void:
	if disabled:
		return
	if body.is_in_group(PlayerCharacter.player_group):
		hide()
		disabled = true
		body.damage(-health)
		sound.play()
