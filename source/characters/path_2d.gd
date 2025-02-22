extends Path2D

@export var speed : float = .01
@export var follower : PathFollow2D

func _process(delta: float) -> void:
	follower.progress_ratio += delta * speed
