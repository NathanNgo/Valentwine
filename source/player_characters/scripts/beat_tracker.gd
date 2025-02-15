extends CanvasLayer

@onready var music: RhythmNotifier = %music
@onready var beat_timer: Sprite2D = $MarginContainer/Control/Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music.beats(1).connect(receiveBeat)
	
##this function gets called by the rhythm notifier every beat. It hanles actions which wou.d
##usually be handled in physics process, including movement and attack
func receiveBeat(_beat):
	var tween = beat_timer.create_tween()
	tween.set_parallel(false)
	tween.tween_property(beat_timer, "scale", Vector2(1,1), 0.025).set_trans(Tween.TRANS_LINEAR)
	#scale = Vector2(1,1)
	tween.tween_property(beat_timer, "scale", Vector2(0,1), 60/music.bpm * .8)
	pass
