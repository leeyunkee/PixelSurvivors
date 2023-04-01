extends Node


const SAVE_PATH0: String = "user://savegame0.bin"
const SAVE_PATH1: String = "user://savegame1.bin"
const SAVE_PATH2: String = "user://savegame2.bin"


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
		"Health": player.hp,
		"CurrentPosition": player.currrent_position,
		"Time": player.time,
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
	elif file == null:
		return
	elif not file.eof_reached():
		var current_line = JSON.parse_string(file.get_line())
		if current_line:
			player.time = current_line["Time"]
			player.hp = current_line["Health"]
			player.currrent_position = current_line["CurrentPosition"]
