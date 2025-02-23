class_name Ammo extends CharacterBody2D
static var enemy_group := "enemies"

@export var _collision_area: Area2D
@export var damage_amount := 10
@export var speed := 300
@export var sprite: Sprite2D

var target: Line2D

var _target_position: Vector2


func _ready() -> void:
	_collision_area.body_entered.connect(_on_body_entered)


func _physics_process(_delta: float) -> void:
	var point_count := target.get_point_count()
	@warning_ignore("integer_division")
	var middle_point : int = int(point_count/2)
	_target_position = target.get_point_position(middle_point)
	velocity = global_position.direction_to(_target_position) * speed
	look_at(_target_position)
	move_and_slide()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_objects"):
		var attack_direction: Vector2 = _target_position - global_position
		body.damage(damage_amount, attack_direction)
		queue_free()
	if body.is_in_group("player_character"):
		queue_free()
