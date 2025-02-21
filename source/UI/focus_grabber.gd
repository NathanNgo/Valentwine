extends Button
@export var ui_node: UI_animator


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_node.finished_entering.connect(finished_entering)

func finished_entering(_finished : bool) -> void:
	call_deferred("grab_focus")
