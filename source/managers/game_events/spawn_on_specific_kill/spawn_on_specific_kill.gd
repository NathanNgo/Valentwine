extends GameEvent


@export var triggering_enemies: Array[Enemy]
##How many triggers you want
@export var can_be_triggered : int = 1
##each element is an array of enemies, which will be spawned upon trigger
@export var enemy_array_per_trigger : Array[Array]
##Each element is an array wtih positions where each enemy will be spawned upon trigger
@export var position_per_trigger : Array[Array]

var has_been_triggered : int = 0

func _ready() -> void:
	for enemy in triggering_enemies:
		enemy.died.connect(activate)


func activate() -> void:
	if has_been_triggered >= can_be_triggered:
		return
	for i : int in enemy_array_per_trigger[has_been_triggered].size():
		var object_spawned : Node2D =\
		 enemy_array_per_trigger[has_been_triggered][i].instantiate()
		var spawn_position : Vector2 =\
		 get_node(position_per_trigger[has_been_triggered][i]).global_position
		spawn_enemies.emit(object_spawned, spawn_position)
	has_been_triggered += 1
