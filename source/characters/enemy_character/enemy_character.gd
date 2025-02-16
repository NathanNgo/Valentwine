class_name EnemyCharacter extends CharacterBody2D

signal body_hit(damage: float)

static var enemy_group = "enemies"

@export var _collision_area: Area2D
@export var damage_amount := 10
@export var speed := 300

var _target_position: Vector2


func _ready() -> void:
	_collision_area.body_entered.connect(_on_body_entered)


func _physics_process(_delta: float) -> void:
	velocity = position.direction_to(_target_position) * speed
	move_and_slide()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(PlayerCharacter.player_group):
		body_hit.emit(damage_amount)
		queue_free()

func damage(damage_done):
	queue_free()
	

func target(target_position: Vector2) -> void:
	_target_position = target_position
