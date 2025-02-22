extends ProgressBar

signal died


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value_changed.connect(on_value_changed)


func on_value_changed(new_value: float) -> void:
	if new_value <= 0:
		died.emit()
