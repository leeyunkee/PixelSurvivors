extends TouchScreenButton


var touched = false
var joystick_active = false
var move_vector = Vector2.ZERO
@onready var Dpad = get_node("JoystickTip")

signal movement

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if self.is_pressed():
			joystick_active = true
			Dpad.position = _get_joy_position() + self.texture_normal.get_size()/2
			move_vector = _get_joy_position().normalized()
			
	if event is InputEventScreenTouch:
		if event.pressed == false:
			joystick_active = false
			Dpad.position = self.texture_normal.get_size()/2
			
func _physics_process(_delta):
	if joystick_active:
		emit_signal("movement", move_vector)
	else:
		emit_signal("movement", Vector2.ZERO)

func _get_joy_position():
	var max_distance = self.get_shape().radius
	var pos = (get_global_mouse_position() - Dpad.global_position).limit_length(max_distance)
	return pos


	


