class_name PlayerCharacter extends CharacterBody2D

enum Player { FIRST, SECOND }

enum Controls { LEFT, RIGHT, UP, DOWN, INTERACT }

static var player_group = "player_objects"

@export var _collision_area: Area2D
@export var _player_one_sprite: Sprite2D
@export var _player_two_sprite: Sprite2D

@export var player_type := Player.FIRST
@export var speed := 400

var control_schemes := {
	Player.FIRST:
	{
		Controls.LEFT: "player_one_left",
		Controls.RIGHT: "player_one_right",
		Controls.UP: "player_one_up",
		Controls.DOWN: "player_one_down",
		Controls.INTERACT: "player_one_interact"
	},
	Player.SECOND:
	{
		Controls.LEFT: "player_two_left",
		Controls.RIGHT: "player_two_right",
		Controls.UP: "player_two_up",
		Controls.DOWN: "player_two_down",
		Controls.INTERACT: "player_two_interact"
	}
}

@onready var selected_scheme: Dictionary = control_schemes[player_type]


func _ready() -> void:
	_collision_area.body_entered.connect(_on_body_entered)
	_player_one_sprite.hide()
	_player_two_sprite.hide()

	if player_type == Player.FIRST:
		_player_one_sprite.show()
	elif player_type == Player.SECOND:
		_player_two_sprite.show()


func _physics_process(_delta: float) -> void:
	var direction = (
		Vector2(
			Input.get_axis(
				selected_scheme[Controls.LEFT], selected_scheme[Controls.RIGHT]
			),
			Input.get_axis(selected_scheme[Controls.UP], selected_scheme[Controls.DOWN])
		)
		. normalized()
	)

	velocity = direction * speed
	move_and_slide()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.queue_free()
