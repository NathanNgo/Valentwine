class_name Enemy extends CharacterBody2D

signal died

enum States { BLOCKED, IDLE, WALKING, ATTACK, STAGGERED, ESCAPING, KO }

static var enemy_group := "enemies"
static var enemy_collision_layer := 1

@export var speed := 300
@export var navigation_agent: NavigationAgent2D
@export var sprite: Sprite2D
@export var death_sound: FmodEventEmitter2D
@export var combat_module: CombatModule
@export var animation_player: AnimationPlayer
@export var death_sprite: Sprite2D
@export var timer: Timer
@export var target: Node2D

var state: States = States.IDLE
var movement_direction: Vector2


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	death_sound.stopped.connect(queue_free)
	death_sprite.hide()


func _physics_process(_delta: float) -> void:
	movement_direction = (
		to_local(navigation_agent.get_next_path_position()).normalized()
	)
	match state:
		States.BLOCKED:
			return

		States.IDLE:
			velocity = movement_direction * speed
			move_and_slide()

		States.ESCAPING:
			velocity = -movement_direction * speed
			move_and_slide()


func set_target() -> void:
	if target:
		navigation_agent.target_position = target.global_position


func _on_timer_timeout() -> void:
	set_target()


func damage(damage_taken: float, attack_direction: Vector2 = Vector2.ZERO) -> void:
	combat_module.damage(damage_taken, attack_direction)


func die() -> void:
	death_sprite.show()
	combat_module.die()
	var animation_number := randi_range(1, 4)
	animation_player.play("death%s" % [animation_number])
	death_sound.play()
	died.emit()
