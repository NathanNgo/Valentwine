extends GameEvent

enum TargetingModes {
	RANDOM, CLOSEST
}

@export var trigger_areas: Array[Area2D]
@export var effected_areas: Array[Area2D]
@export var activation_timer: Timer

@export var targeting_mode := TargetingModes.RANDOM
@export var activation_time_limit := 10.0
@export var enable_activation_time_limit := false

var trigger_activated := false
var effected_bodies: Array[Enemy] = []


func _ready() -> void:
	for trigger_area in trigger_areas:
		trigger_area.body_entered.connect(_on_body_entered_trigger_area)
		trigger_area.set_collision_mask_value(PlayerCharacter.player_collision_layer, true)

	for effected_area in effected_areas:
		effected_area.body_entered.connect(_on_body_entered_effected_area)

	for effected_area in effected_areas:
		effected_area.body_exited.connect(_on_body_exited_effected_area)

	activation_timer.timeout.connect(_on_activation_timer_timeout)


func _process(_delta: float) -> void:
	if not trigger_activated:
		return

	activate()


func activate() -> void:
	for effected_body in effected_bodies:
		match targeting_mode:
			TargetingModes.RANDOM:
				target_random_player.emit(effected_body)
			TargetingModes.CLOSEST:
				target_closest_player.emit(effected_body)

		effected_bodies.erase(effected_body)


func first_activation() -> void:
	activate()


func _on_body_entered_trigger_area(body: Node2D) -> void:
	if body.is_in_group(PlayerCharacter.player_group):
		trigger_activated = true

	if enable_activation_time_limit:
		activation_timer.start(activation_time_limit)


func _on_body_entered_effected_area(body: Node2D) -> void:
	if body.is_in_group(Enemy.enemy_group):
		effected_bodies.append(body)


func _on_body_exited_effected_area(body: Node2D) -> void:
	if body.is_in_group(Enemy.enemy_group):
		effected_bodies.erase(body)


func _on_activation_timer_timeout() -> void:
	trigger_activated = false
