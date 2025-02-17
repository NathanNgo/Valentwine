class_name BasicEnemy extends CharacterBody2D

signal body_hit(damage: float)
signal take_damage(damage_done : float, attack_direction : Vector2)
static var enemy_group = "enemies"

enum States{ STATE_BLOCKED, STATE_IDLE, STATE_WALKING, STATE_ATTACK, STATE_STAGGER}
var state : States = States.STATE_IDLE
@export var speed := 300
@export var player : Node2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
var movement_direction : Vector2

func _physics_process(_delta: float) -> void:
	if state == States.STATE_IDLE:
		movement_direction = to_local(navigation_agent_2d.get_next_path_position()).normalized()
		velocity = movement_direction * speed
		move_and_slide()


func make_path():
	navigation_agent_2d.target_position = player.global_position


func _on_timer_timeout() -> void:
	make_path()


func damage(damage_done, attack_direction):
	take_damage.emit(damage_done, attack_direction)
