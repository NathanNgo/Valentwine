extends Node2D

const SPAWN_TIME = 2

@export var level: Node2D
@export var ui_manager: Node
@export var levels: Array[PackedScene] = []

var health := 100.0
var current_level := 0

func _ready() -> void:
	ui_manager.health_bar.value = health
	level.damage_taken.connect(_on_damage_taken)
	level.transition_level.connect(_on_transition_level)


func _on_damage_taken(damage: float) -> void:
	health -= damage
	ui_manager.health_bar.value = health


func _on_transition_level() -> void:
	current_level += 1
	get_tree().change_scene_to_packed(levels[current_level])
