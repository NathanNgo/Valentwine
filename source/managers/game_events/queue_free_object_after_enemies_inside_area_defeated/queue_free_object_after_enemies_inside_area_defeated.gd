extends GameEvent

@export var trigger_areas: Array[Area2D]
@export var objects_to_free: Array[Node2D]
@export var activation_timer : Timer
@export var delay_before_queue_free : float = 1.0

var alive_enemies: Array[Enemy] = []
var previously_triggered : bool = false

func _ready() -> void:
	for trigger_area in trigger_areas:
		trigger_area.body_entered.connect(_on_body_entered_trigger_area)
		trigger_area.body_exited.connect(_on_body_exited_trigger_area)
		trigger_area.set_collision_mask_value(Enemy.enemy_collision_layer, true)

	activation_timer.timeout.connect(_on_activation_timer_timeout)


func activate() -> void:
	for object : Node2D in objects_to_free:
		object.call_thread_safe("queue_free")
		objects_to_free.erase(object)


func _on_body_entered_trigger_area(body: Node2D) -> void:
	if body.is_in_group(Enemy.enemy_group):
		alive_enemies.append(body)


func _on_body_exited_trigger_area(body: Node2D) -> void:
	if previously_triggered:
		return
	if body.is_in_group(Enemy.enemy_group):
		alive_enemies.erase(body)

	if alive_enemies.size() == 0:
		activation_timer.start()


func _on_activation_timer_timeout() -> void:
	activate()
