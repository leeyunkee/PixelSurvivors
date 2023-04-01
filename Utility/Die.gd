extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_animated_sprite_2d_animation_finished()

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("die")
	queue_free()
