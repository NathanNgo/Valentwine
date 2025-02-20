extends Button
@export var UI_node: UI_animator


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UI_node.finished_entering.connect(finished_entering)

func finished_entering(_finished : bool) -> void:
	call_deferred("grab_focus")
