extends Node2D

@export var _collision_shape: CollisionShape2D
@export var line: Line2D
@export var line_body: CharacterBody2D
@export var dividing_line: StaticBody2D

@export var line_offset := 40.0


func set_end_positions(position_one: Vector2, position_two: Vector2) -> void:
	var middle_point_x: float = (position_one.x + position_two.x) / 2
	var middle_point_y: float = (position_one.y + position_two.y) / 2
	var middle_point := Vector2(middle_point_x, middle_point_y)

	line_body.global_position = middle_point
	line_body.rotate(line_body.get_angle_to(position_two))

	set_length(position_one, position_two)

	line.points = [position_one, position_two]
	dividing_line.global_position = middle_point


func set_length(position_one: Vector2, position_two: Vector2) -> void:
	var distance := sqrt(
		(position_two.x - position_one.x) ** 2 + (position_two.y - position_one.y) ** 2
	)
	var radius_distance := (distance / 2) - line_offset

	if radius_distance > 0:
		_collision_shape.shape.extents.x = radius_distance
