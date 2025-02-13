extends TabBar

"""save settings"""
@export var fileName : String = "user://Player_data/bindings"
@export var defaultSettingsfileName : String = "res://Player_data/default_bindings"
signal finishedLoading
var controls : String
var settingsDictionary = {"controls" : controls}

func _ready():
	call_deferred("initialize")
func initialize():
	loadSettings()
func loadSettings():
	var file = FileAccess.open(fileName, FileAccess.READ)
	if file == null:
		return
	var dictionaryWithSettings = file.get_var()
	InputHelper.deserialize_inputs_for_actions(dictionaryWithSettings["controls"])
	finishedLoading.emit()
func saveSettings(): 
	settingsDictionary["controls"] = InputHelper.serialize_inputs_for_actions()
	var file = FileAccess.open(fileName, FileAccess.WRITE)
	file.store_var(settingsDictionary)
	file.close()
