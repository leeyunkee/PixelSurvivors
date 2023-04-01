extends CanvasLayer

var is_paused = false


signal load_me

func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		_launch_pause_panel()


func _launch_pause_panel():
	if not is_paused:
			get_tree().paused = true
			self.show()
			is_paused = true
	else:
		get_tree().paused = false
		self.hide()
		is_paused = false


func _on_save_pressed():
	SaveAndLoad.save(0)
	self.hide()
	get_tree().paused = false	

func _on_load_pressed():
	SaveAndLoad.load_game(0)
	self.hide()
	get_tree().paused = false
	emit_signal("load_me")
	
func _on_exit_pressed():
	get_tree().quit(0)


func _on_button_pressed():
	_launch_pause_panel()
