extends Area2D

##this node pushes the player towards its top. To change the direction rotate the entire node.
@export var speed : float = 100

func _process(_delta : float) -> void:
	var bodies : Array[Node2D] = get_overlapping_bodies()
	for body : Node2D in bodies:
		if body.is_in_group(PlayerCharacter.player_group):
		#this pushes the player towards the top of the platform
			body.get_pushed(-transform.y * speed)
