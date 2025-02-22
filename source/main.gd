extends Node2D

const SPAWN_TIME = 2

@export var level: Node2D
@export var ui_manager: Node

var health := 100.0

func _ready() -> void:
	ui_manager.health_bar.value = health
	level.damage_taken.connect(_on_damage_taken)


func _on_damage_taken(damage: float) -> void:
	health -= damage
	ui_manager.health_bar.value = health