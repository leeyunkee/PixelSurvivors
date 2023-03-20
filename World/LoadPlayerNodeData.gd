extends Node2D

@onready var player_node = get_node("Player")



func _on_canvas_layer_load_me():
	player_node.position = player.position
	player_node.time = player.time
