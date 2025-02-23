extends ProgressBar

signal died

@export var delay_timer : Timer
@export var damage_bar : ProgressBar
@export var delay : float = 2.5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value_changed.connect(on_value_changed)
	delay_timer.timeout.connect(update_damage_bar)


func on_value_changed(new_value: float) -> void:
	delay_timer.start(delay)
	if new_value <= 0:
		died.emit()


func update_damage_bar() -> void:
	damage_bar.value = value
