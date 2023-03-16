extends Control


var map1 = "res://World/world.tscn"
var map2 = "res://World/world2.tscn"


func _on_button_click_end():
	var world1 = get_tree().change_scene_to_file(map1)


func _on_button_2_click_end():
	var world2 = get_tree().change_scene_to_file(map2)
