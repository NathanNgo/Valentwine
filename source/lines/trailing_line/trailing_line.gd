extends Node2D

const LAST_INDEX = -1
const SECOND_LAST_INDEX = -2
const EXCLUDED_POINTS_OFFSET = 3
const MINIMUM_NUMBER_OF_POINTS_FOR_INTERSECTION = 4

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

	if trailing_line_points.size() < MINIMUM_NUMBER_OF_POINTS_FOR_INTERSECTION:
		return null

	return _check_all_lines_for_intersection()


func get_closed_polygon(start_and_end_point: Vector2) -> Array[Vector2]:
	return (
		[start_and_end_point] + trailing_line_points.slice(1, -1) + [start_and_end_point]
	)


func clear_line() -> void:
	trailing_line_points.clear()
	_redraw_trailing_line()


func _check_all_lines_for_intersection() -> Variant:
	var second_line_end := trailing_line_points[LAST_INDEX]
	var second_line_start := trailing_line_points[SECOND_LAST_INDEX]

	for point_index in range(trailing_line_points.size() - EXCLUDED_POINTS_OFFSET):
		var first_line_start := trailing_line_points[point_index]
		var first_line_end := trailing_line_points[point_index + 1]

		if first_line_end == second_line_start:
			continue

		var possible_intersection := _check_intersection_between_two_lines(
			first_line_start, first_line_end, second_line_start, second_line_end
		)

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

	if not possible_intersection:
		return null


	if _point_not_contained_in_all_line_segments(
		possible_intersection,
		first_line_start,
		first_line_end,
		second_line_start,
		second_line_end
	):
		return null

	return possible_intersection


func _redraw_trailing_line() -> void:
	trailing_line.clear_points()
	for trailing_line_point in trailing_line_points:
		trailing_line.add_point(trailing_line_point)


func _point_not_contained_in_all_line_segments(
	possible_intersection: Vector2,
	first_line_start: Vector2,
	first_line_end: Vector2,
	second_line_start: Vector2,
	second_line_end: Vector2
) -> bool:
	var first_line_range_x := _get_x_range(first_line_start, first_line_end)
	var first_line_smallest_x := first_line_range_x[0]
	var first_line_largest_x := first_line_range_x[1]
	var second_line_range_x := _get_x_range(second_line_start, second_line_end)
	var second_line_smallest_x := second_line_range_x[0]
	var second_line_largest_x := second_line_range_x[1]

	var first_line_range_y := _get_y_range(first_line_start, first_line_end)
	var first_line_smallest_y := first_line_range_y[0]
	var first_line_largest_y := first_line_range_y[1]
	var second_line_range_y := _get_y_range(second_line_start, second_line_end)
	var second_line_smallest_y := second_line_range_y[0]
	var second_line_largest_y := second_line_range_y[1]

	var intersection_in_first_line_x: bool = (
		first_line_smallest_x <= possible_intersection.x
		and possible_intersection.x <= first_line_largest_x
	)
	var intersection_in_second_line_x: bool = (
		second_line_smallest_x <= possible_intersection.x
		and possible_intersection.x <= second_line_largest_x
	)

	var intersection_in_first_line_y: bool = (
		first_line_smallest_y <= possible_intersection.y
		and possible_intersection.y <= first_line_largest_y
	)
	var intersection_in_second_line_y: bool = (
		second_line_smallest_y <= possible_intersection.y
		and possible_intersection.y <= second_line_largest_y
	)

	return (
		not (intersection_in_first_line_x)
		or not (intersection_in_second_line_x)
		or not (intersection_in_first_line_y)
		or not (intersection_in_second_line_y)
	)


func _get_x_range(line_start: Vector2, line_end: Vector2) -> Array[float]:
	var line_smallest_x: float
	var line_largest_x: float

	if line_start.x < line_end.x:
		line_smallest_x = line_start.x
		line_largest_x = line_end.x
	else:
		line_smallest_x = line_end.x
		line_largest_x = line_start.x

	return [line_smallest_x, line_largest_x]


func _get_y_range(line_start: Vector2, line_end: Vector2) -> Array[float]:
	var line_smallest_y: float
	var line_largest_y: float

	if line_start.y < line_end.y:
		line_smallest_y = line_start.y
		line_largest_y = line_end.y
	else:
		line_smallest_y = line_end.y
		line_largest_y = line_start.y

	return [line_smallest_y, line_largest_y]