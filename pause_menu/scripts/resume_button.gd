extends Button
@onready var node: AnimationComponent = $Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	node.finished_entering.connect(finished_entering)


func finished_entering(_finished):
	call_deferred("grab_focus")
