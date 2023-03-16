extends Node2D

@onready var player = $Player

func _on_save_pressed():
	GlobalData.save(GlobalData.SAVE_PATH0)


func _on_print_pressed():
	print(GlobalData.data)


func _on_load_pressed():
	GlobalData.load_game(GlobalData.SAVE_PATH0)
	
const SAVE_PATH0: String = "user://savegame0.bin"
const SAVE_PATH1: String = "user://savegame1.bin"
const SAVE_PATH2: String = "user://savegame2.bin"

var data = {}

func save(slot) -> void:
	var file 
	match slot:
		0:
			file = FileAccess.open(SAVE_PATH0, FileAccess.WRITE)
		1: 
			file = FileAccess.open(SAVE_PATH1, FileAccess.WRITE)
		2: 
			file = FileAccess.open(SAVE_PATH2, FileAccess.WRITE)
		
	var data: Dictionary = {
		"Health": player.hp
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)


func load_game(slot) -> void:
	var file 
	match slot:
		0:
			file = FileAccess.open(SAVE_PATH0, FileAccess.READ)
		1: 
			file = FileAccess.open(SAVE_PATH1, FileAccess.READ)
		2: 
			file = FileAccess.open(SAVE_PATH2, FileAccess.READ)
	if not file:
		return
	if file == null:
		return
	if not file.eof_reached():
		var data_json = JSON.parse_string(file.get_line())
		file.close()
		
		data = data_json.result
