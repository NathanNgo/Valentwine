extends Node2D

const SPAWN_TIME = 2

@export var line: Node2D
@export var player_one: CharacterBody2D
@export var player_two: CharacterBody2D
@export var enemies_container: Node2D
@export var obstacles_container: Node2D
@export var point_sampler: PathFollow2D
@export var health_bar: ProgressBar

var health := 100.0

@onready var targetable_players: Array[Node2D] = [player_one, player_two]


func _ready() -> void:
	_assign_enemy_targets()

	player_one.player_damaged.connect(_on_damage_taken)
	player_two.player_damaged.connect(_on_damage_taken)
	line.line_body.player_damaged.connect(_on_damage_taken)

	health_bar.value = health


func _physics_process(_delta: float) -> void:
	line.set_end_positions(player_one.position, player_two.position)


func _on_damage_taken(damage: float) -> void:
	health -= damage
	health_bar.value = health


func _assign_enemy_targets() -> void:
	for enemy in enemies_container.get_children():
		var random_target: Node2D = targetable_players.pick_random()
		enemy.target = random_target
