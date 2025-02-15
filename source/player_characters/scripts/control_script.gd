extends CharacterBody2D
class_name Player


var linear_vel = Vector2()
@export var player_number : int = 1 
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ground: TileMapLayer = %ground
@onready var line_of_fate: Node2D = $"../line_of_fate"
@onready var punch_audio: AudioStreamPlayer = $audio_streams/punch_audio
var movement_obstructed : bool = false

func _ready():
	%music.beats(1).connect(receiveBeat)


##this function gets called by the rhythm notifier every beat. It hanles actions which wou.d
##usually be handled in physics process, including movement and attack
func receiveBeat(_beat):
	#Here we are assuming that tile 
	var tile_size : Vector2 = ground.tile_set.tile_size
	var attempted_position : Vector2 = Vector2(tile_size.x * linear_vel.x, tile_size.y * linear_vel.y)
	attempted_position = position.snapped(position + linear_vel * tile_size)
	line_of_fate.check_for_collisions(player_number,attempted_position)
	ray_cast_2d.target_position = Vector2(linear_vel.x * tile_size.x, linear_vel.y * tile_size.y)
	ray_cast_2d.force_raycast_update()
	if ray_cast_2d.is_colliding():
		var collided_body = ray_cast_2d.get_collider()
		if collided_body.is_in_group("enemy"):
			punch(collided_body, attempted_position)
	else:
		if !movement_obstructed:
			position = attempted_position
	linear_vel = Vector2(0,0)
#so that when another player collides with this, they don't create an error.
func get_custom_data(_name : String):
	return "player"


func punch(what_got_punched : Node2D, where : Vector2):
	punch_audio.play()


func _physics_process(_delta):
	var  target_speed = Vector2()
	if Input.is_action_just_pressed("MoveDown%s" % [player_number]):
		target_speed += Vector2.DOWN
	if Input.is_action_just_pressed("MoveLeft%s" % [player_number]):
		target_speed += Vector2.LEFT
	if Input.is_action_just_pressed("MoveRight%s" % [player_number]):
		target_speed += Vector2.RIGHT
	if Input.is_action_just_pressed("MoveUp%s" % [player_number]):
		target_speed += Vector2.UP
	if target_speed != Vector2():
		linear_vel = target_speed
