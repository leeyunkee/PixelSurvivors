extends Control


var mapmenu = "res://Utility/mapmenu.tscn"


func _on_button_click_end():
	var mapMenu = get_tree().change_scene_to_file(mapmenu)

func _on_btn_exit_click_end():
	get_tree().exit()
	
	
