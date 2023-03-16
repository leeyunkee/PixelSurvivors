extends CharacterBody2D

@export var movement_speed = 50.0
@export var hp = 100
@export var maxhp = 100
@export var last_movement = Vector2.UP
@export var time = 0

@export var experience = 0
@export var experience_level = 1
@export var collected_experience = 0

#Attacks
var fireBall = preload("res://Player/Spell/fire_ball.tscn")
var fireCore = preload("res://Player/Spell/fire_core.tscn")

#AttackNodes
@onready var FireBallTimer = $Attack/FireBallTimer
@onready var FireBallAttackTimer = $Attack/FireBallTimer/FireBallAttackTimer
@onready var FireCoreTimer = $Attack/FireCoreTimer
@onready var FireCoreAttackTimer = $Attack/FireCoreTimer/FireCoreAttackTimer

#UPGRADES
@export var collected_upgrades = []
@export var upgrades_options = []
@export var armor = 0
@export var speed = 0
@export var spell_cooldown = 0
@export var spell_size = 0
@export var additional_attacks = 0

#FireBall
@export var fireball_ammo = 0
@export var fireball_baseammo = 0
@export var fireball_attackspeed = 1.5
@export var fireball_level = 0

#FireCore
@export var firecore_ammo = 0
@export var firecore_baseammo = 0
@export var firecore_attackspeed = 3
@export var firecore_level = 0

#Enemy_Related
var enemy_close = []

@onready var animatedsprite = $AnimatedSprite2D

#GUI
@onready var expBar = get_node("%ExperienceBar")
@onready var lbllevel = get_node("%lbl_level")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%upgradeOptions")
@onready var itemOptions = preload("res://Utility/item_option.tscn")
@onready var sndLevelUp = get_node("%snd_levelup")
@onready var healthBar = get_node("%HealthBar")
@onready var lblTimer = get_node("%lblTimer")
@onready var collectedWeapons = get_node("%CollectedWeapons")
@onready var collectedUpgrades = get_node("%CollectedUpgrades")
@onready var itemContainer = preload("res://Player/GUI/item_container.tscn")
@onready var deathPanel = get_node("%DeathPanel")
@onready var lblresult = get_node("%lbl_result")
@onready var sndVictory = get_node("%snd_victory")
@onready var snd_hurt = $snd_hurt
@onready var sndLose = get_node("%snd_lose")

#signal
signal playerdeath

func _ready():
	upgrade_character("fireball1")
	attack()
	set_expbar(experience, calculate_experiencecap())
	_on_hurtbox_hurt(0,0,0)

func _physics_process(delta):
	movement()

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	if x_mov or y_mov:
		$AnimatedSprite2D.play("move")
	elif x_mov or y_mov == 0:
		$AnimatedSprite2D.play("idle")
		
	if mov.x > 0:
		animatedsprite.flip_h = false
	elif mov.x < 0:
		animatedsprite.flip_h = true
		
	if mov != Vector2.ZERO:
		last_movement = mov 
	
	velocity = mov.normalized()*movement_speed
	move_and_slide()

func attack():
	if fireball_level > 0:
		FireBallTimer.wait_time = fireball_attackspeed * (1-spell_cooldown)
		if FireBallTimer.is_stopped():
			FireBallTimer.start()
	if firecore_level > 0:
		FireCoreTimer.wait_time = firecore_attackspeed * (1-spell_cooldown)
		if FireCoreTimer.is_stopped():
			FireCoreTimer.start()

func _on_hurtbox_hurt(damage, _angle, _knockback):
	hp -= clamp(damage-armor, 1.0, 999.0)
	if hp <= 0:
		death()
	healthBar.max_value = maxhp
	healthBar.value = hp

func death():
	deathPanel.visible = true
	emit_signal("playerdeath")
	get_tree().paused = true
	var tween = deathPanel.create_tween()
	tween.tween_property(deathPanel,"position",Vector2(220,50), 3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	if time >= 300:
		lblresult.text = "You Win"
		sndVictory.play()
	else:
		lblresult.text = "You Lose"
		sndLose.play()

func _on_fire_ball_timer_timeout():
	fireball_ammo += fireball_baseammo + additional_attacks
	FireBallAttackTimer.start()

func _on_fire_ball_attack_timer_timeout():
	if fireball_ammo > 0:
		var fireball_attack = fireBall.instantiate()
		fireball_attack.position = position
		fireball_attack.target = _get_closest_target()
		fireball_attack.level = fireball_level
		add_child(fireball_attack)
		fireball_ammo -= 1
		if fireball_ammo > 0:
			FireBallAttackTimer.start()
		else: 
			FireBallAttackTimer.stop()

func _on_fire_core_timer_timeout():
	firecore_ammo += firecore_baseammo + additional_attacks
	FireCoreAttackTimer.start()

func _on_fire_core_attack_timer_timeout():
	if firecore_ammo > 0:
		var firecore_attack = fireCore.instantiate()
		firecore_attack.position = position
		firecore_attack.last_movement = last_movement
		firecore_attack.level = firecore_level
		add_child(firecore_attack)
		firecore_ammo -= 1
		if firecore_ammo > 0:
			FireCoreAttackTimer.start()
		else: 
			FireCoreAttackTimer.stop()


func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP
		
func _get_closest_target() -> Vector2:
	if enemy_close.size() == 0:
		return Vector2.UP
	var closest_distance = INF
	var closest_enemy
	for enemy in enemy_close:
		var distance = (global_position - enemy.global_position).length()
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	return closest_enemy.global_position

func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)

func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)
		
func calculate_experience(gem_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required: #level up
		collected_experience -= exp_required-experience
		experience_level += 1
		experience = 0
		exp_required = calculate_experiencecap()
		levelup()
	else: 
		experience += collected_experience
		collected_experience = 0
	
	set_expbar(experience, exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level*5
	elif exp_cap < 40:
		exp_cap = 95 + (experience_level-19)*8
	else:
		exp_cap = 255 + (experience_level-39)*12 
		
	return exp_cap

func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value

func levelup():
	sndLevelUp.play()
	lbllevel.text = str("Level ",experience_level)
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel,"position",Vector2(220,50),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = itemOptions.instantiate()
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true

func upgrade_character(upgrade):
	match upgrade:
		"fireball1":
			fireball_level = 1
			fireball_baseammo += 1
		"fireball2":
			fireball_level = 2
			fireball_baseammo += 1
		"fireball3":
			fireball_level = 3
		"fireball4":
			fireball_level = 4
			fireball_baseammo += 2
		"firecore1":
			firecore_level = 1
			firecore_baseammo += 1
		"firecore2":
			firecore_level = 2
			firecore_baseammo += 1
		"firecore3":
			firecore_level = 3
			firecore_attackspeed -= 0.5
		"firecore4":
			firecore_level = 4
			firecore_baseammo += 1
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			movement_speed += 20.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"ring1","ring2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp,0,maxhp)
	adjust_gui_collection(upgrade)
	attack()
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrades_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(800,50)
	get_tree().paused = false
	calculate_experience(0)

func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #Find already collected upgrades
			pass
		elif i in upgrades_options: #If the upgrades is already an option 
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": #Don't pick food
			pass
		elif UpgradeDb.UPGRADES[i]["prereq"].size() > 0: #Check for pre-req
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prereq"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrades_options.append(randomitem)
		return randomitem
	else:
		return null

func change_time(argtime = 0):
	time = argtime
	var get_m = int(time/60.0)
	var get_s = time % 60
	if get_m < 10:
		get_m = str(0,get_m)
	if get_s < 10:
		get_s = str(0,get_s)
	lblTimer.text = str(get_m,":",get_s)

func adjust_gui_collection(upgrade):
	var get_upgraded_displayname = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_displaynames = []
		for i in collected_upgrades:
			get_collected_displaynames.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displayname in get_collected_displaynames:
			var new_item = itemContainer.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					collectedWeapons.add_child(new_item)
				"upgrade":
					collectedUpgrades.add_child(new_item)


func _on_btn_menu_click_end():
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://Titlescreen/menu.tscn")
