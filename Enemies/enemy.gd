extends CharacterBody2D

@export var movement_speed = 30.0
@export var hp = 20
@export var knockback_recovery = 3.5
@export var experience = 1
@export var enemy_damage = 1
var knockback = Vector2.ZERO

@onready var animatedsprite = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var snd_hit = $snd_hit
@onready var hitBox = $HitBox

var death_anim = preload("res://die.tscn")
var exp_gem = preload("res://Object/exp_gems.tscn")

signal remove_from_array(object)

func _ready():
	hitBox.damage = enemy_damage

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	velocity += knockback
	move_and_slide()

	if direction.x > 0:
		animatedsprite.flip_h = false
	elif direction.x < 0:
		animatedsprite.flip_h = true

func die():
	emit_signal("remove_from_array", self)
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = animatedsprite.scale
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child", enemy_death)
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child", new_gem)
	queue_free()

func _on_hurtbox_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		die()
	else:
		snd_hit.play()

