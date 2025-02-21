extends StaticBody2D

## add the coordinates of the tile in the tileset and it gets shown at run time.
@export var tile_coordinates: Vector2 = Vector2(7, 17)
@export var sprite: Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.frame_coords = tile_coordinates
