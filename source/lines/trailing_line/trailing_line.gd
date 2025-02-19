extends Node2D

const LAST_INDEX = -1
const SECOND_LAST_INDEX = -2
const LAST_LINE_FIRST_POINT_OFFSET = 2

@export var max_points := 10
@export var trailing_line: Line2D

var trailing_line_points: Array[Vector2] = []


func add_point(point: Vector2) -> Variant:
	if trailing_line_points.size() == max_points:
		trailing_line_points.pop_front()
		trailing_line_points.push_back(point)
	else:
		trailing_line_points.push_back(point)

	_redraw_trailing_line()
	return _check_all_lines_for_intersection()


func get_closed_polygon(start_and_end_point: Vector2) -> Array[Vector2]:
	return [start_and_end_point] + trailing_line_points.slice(1, -1) + [start_and_end_point]


func _check_all_lines_for_intersection() -> Variant:
	var second_line_end := trailing_line_points[LAST_INDEX]
	var second_line_start := trailing_line_points[SECOND_LAST_INDEX]

	for point_index in range(trailing_line_points.size() - LAST_LINE_FIRST_POINT_OFFSET):
		var first_line_start := trailing_line_points[point_index]
		var first_line_end := trailing_line_points[point_index + 1]

		if first_line_end == second_line_start:
			continue

		var possible_intersection := _check_intersection_between_two_lines(first_line_start, first_line_end, second_line_start, second_line_end)

		if possible_intersection:
			return possible_intersection

	return null


func _check_intersection_between_two_lines(
	first_line_start: Vector2,
	first_line_end: Vector2,
	second_line_start: Vector2,
	second_line_end: Vector2
) -> Variant:
	var first_direction := first_line_end - first_line_start
	var second_direction := second_line_end - second_line_start

	var possible_intersection := Geometry2D.line_intersects_line(
		first_line_start, first_direction, second_line_start, second_direction
	)

	if (
		not possible_intersection
		or not (
			first_line_start.x < possible_intersection.x
			and possible_intersection.x < first_line_end.x
		)
		or not (
			second_line_start.x < possible_intersection.x
			and possible_intersection.x < second_line_end.x
		)
	):
		return null

	return possible_intersection


func _redraw_trailing_line() -> void:
	trailing_line.clear_points()
	for trailing_line_point in trailing_line_points:
		trailing_line.add_point(trailing_line_point)