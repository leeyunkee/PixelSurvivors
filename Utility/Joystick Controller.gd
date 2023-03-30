extends Area2D

@onready var BigCicle = get_node("JoystickBaseOutline")
@onready var Dpad = get_node("JoystickBaseOutline/JoystickTipArrows")

var dir = Vector2.ZERO
var touched = false

@onready var max_distance = get_node("CollisionShape2D").shape.radius

func _input(event):
	if event is InputEventScreenDrag:
		var distance = event.position.distance_to(BigCicle.global_position)
		if distance <= max_distance:
			touched = true
			Dpad.global_position = event.position

 
