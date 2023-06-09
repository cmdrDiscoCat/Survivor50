extends CharacterBody2D

# Utility variales
var alive = 0
var experience = 0
var player_level = 1
var collected_experience = 0

# player stats
var speed = 400
var speed_multiplier = 1 
var health = 100
var health_max = 100
var attack_speed = 2
# godot weapon (the default for now)
var godot_damage_multiplier = 1
var godot_speed = 1
var godot_scale =.5
var godot_base_instances = 1
var godot_instances = 0
var godot_level = 0
# regen
var health_recovery = 0.01

var my_upgrades = {
		"debug":0,
		"speed":0,
		"godot":0,
		"damage":0,
		"attack speed":0,
		"projectiles":0,
	}

# attacks (only godot so far)
var bullet = preload("res://Scenes/bullet.tscn")

# sound for shooting
@onready var shoot = $Shoot

# health, level and xp bar
@onready var healthBar = $Health
@onready var expBar = $HUD/GUI/ProgressBar
@onready var lblLevel = $HUD/GUI/ProgressBar/LblLevel
# Bullet timer
@onready var bulletTimer = $BulletTimer
@onready var bulletAttackTimer = $BulletTimer/BulletAttackTimer

# level up ui
@onready var levelUpPanel = $HUD/GUI/LevelUpPanel
@onready var levelUpOptions = $HUD/GUI/LevelUpPanel/LevelUpOptions
@onready var itemOptions = preload("res://Scenes/upgrade_option.tscn")

# debug label with the collected upgrades and xp
@onready var lblUpgrades = $HUD/GUI/LblUpgrades
@onready var lblTrackXp = $HUD/GUI/ProgressBar/LblTrackXp

# Upgrade
var collected_upgrades = []
var upgrade_choices = []


signal death



func _ready():
	# we set the Bullet time to the godot_speed value for now
	# later on, we'll have one Timer per weapon
	bulletTimer.wait_time = attack_speed
	update_expBar(experience,get_level_cap())

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed * speed_multiplier

func _physics_process(_delta):
	if alive:
		# we manage the input
		get_input()
		# we handle the movement
		move_and_slide()
	
		# If we're not full health, we're healing
		if health < health_max and health != 0:
			health += health_recovery
			healthBar.value = health

func damage(delta, amount=1):
	# we're taking damage if we're not dead
	if health > 0:
		print("Taking damage")
		health -= delta * amount * 10
	# then we deal with the death and the loss of health
	if health < 1:
		alive = 0
		reset_upgrades()
		print("Dead")
		emit_signal("death")
	else:
		healthBar.value = health


func _on_bullet_timer_timeout():
	# on each bullet timer tick, we can fire godot_base_instances bullets
	godot_instances = godot_base_instances
	# we start the timer to shoot the first bullet
	bulletAttackTimer.start()

func _on_grab_area_area_entered(area):
	if area.is_in_group("drop"):
		# we got a gem so it has to move towards us, we set its target to us !
		area.target = self
		


func _on_collect_area_area_entered(area):
	# if a gem from the loot layer is in the collect area
	if area.is_in_group("drop"):
		# we grab it
		var gem_experience = area.collect()
		# we call our function to update our xp
		update_experience(gem_experience)
		# we delete the gem
		area.destroy()


func _on_bullet_attack_timer_timeout():
	# on each timeout of that timer, we fire a bullet
	# if we still haven't fired all the bullets we can via our upgrades to godot_base_instances
	if godot_instances > 0:
		var closest = INF
		var closest_enemy = null
		# we determine a target if we can, else we don't spawn bullets
		# we get all the enemies
		var enemies = get_tree().get_nodes_in_group("enemies")
		# for all those enemies
		for enemy in enemies:
			# we get the distance to the bullet cause it's spawned below the player
			var enemy_distance = position.distance_to(enemy.position)
			# if it's smaller than the closest we've seen so far (default INF)
			if enemy_distance < closest:
				# it becomes our closest
				closest = enemy_distance
				closest_enemy = enemy
			
		# at the end of the loop we have our closest enemy
		# we calculate the direction we'll use for the bullet's movement
		if closest_enemy != null:
			# we get the direction of the target by substracting the positions
			# Vectors, right ? :D
			var target = (closest_enemy.global_position - global_position).normalized()
			# we instanciate a bullet
			var this_bullet = bullet.instantiate()
			# we play the shoot sound
			shoot.play()
			# we set it as a child of main, not the player
			get_parent().add_child(this_bullet)
			# we place it where the player is
			this_bullet.velocity = Vector2.ZERO
			this_bullet.global_position = global_position
			# then we tell it its damage and the direction its target was when it spawned
			this_bullet.set_damage_multiplier(godot_damage_multiplier)
			this_bullet.set_speed_multiplier(godot_speed)
			this_bullet.change_scale(godot_scale)
			this_bullet.set_direction(target)
		godot_instances -= 1
	
		if godot_instances > 0:
			# if we can still fire, we restart the attack timer to fire the next bullet
			bulletAttackTimer.start()
		else:
			# we used up our bullet, they'll replenish on the next BulletTimer tick
			bulletAttackTimer.stop()


func update_experience(xp):
	# we get how much xp is needed to level up with our current level
	var exp_for_lvlup = get_level_cap()
	collected_experience += xp
	# if we have enough xp to level up
	if experience + collected_experience >= exp_for_lvlup:
		collected_experience -= exp_for_lvlup
		player_level += 1
		experience = 0
		exp_for_lvlup = get_level_cap()
		level_up()
	else:
		experience += collected_experience
		collected_experience = 0
		if experience < 0:
			experience = 0
	# we update the xp bar
	update_expBar(experience,exp_for_lvlup)
	

func get_level_cap():
	var cap
	
	if player_level < 20:
		cap = player_level * 3
	elif player_level < 40:
		cap = player_level * 15
	else:
		cap = player_level * 25
		
	return cap
	
	
func update_expBar(value = 1, maximum = 100):
	# we update the experience bar... and our debug label
	expBar.value = value
	expBar.max_value = maximum
	# we update the xp label
	lblTrackXp.text = "XP : "+str(experience)+" / "+str(get_level_cap())+"\n"


func level_up():
	# before anything else, the player gets 10 more max hp
	health_max += 10
	
	# update of the level
	lblLevel.text = str("Level : ", player_level)
	levelUpPanel.visible = true
	var options = 0
	var optionsMax = 3
	
	while options < optionsMax:
		var option_choice = itemOptions.instantiate()
		option_choice.item = get_random_upgrade()
		levelUpOptions.add_child(option_choice)
		options += 1
	
	get_tree().paused = true

func upgrade_player(upgrade):
	# match upgrade to actually do the things related to them
	match upgrade:
		"speed1":
			speed_multiplier += 0.05
		"speed2":
			speed_multiplier += 0.05
		"speed3":
			speed_multiplier += 0.05
		"speed4":
			speed_multiplier += 0.05
		"speed5":
			speed_multiplier += 0.05
		"speed6":
			speed_multiplier += 0.05
		"speed7":
			speed_multiplier += 0.05
		"speed8":
			speed_multiplier += 0.05
		"godot1":
			godot_speed += 1
			godot_scale += .1
		"godot2":
			godot_speed += 1
			godot_scale += .1
		"godot3":
			godot_speed += 1
			godot_scale += .1
		"godot4":
			godot_speed += 1
			godot_scale += .1
		"godot5":
			godot_speed += 1
			godot_scale += .1
		"godot6":
			godot_speed += 1
			godot_scale += .1
		"godot7":
			godot_speed += 1
			godot_scale += .1
		"godot8":
			godot_speed += 1
			godot_scale += .1
		"attack_damage1":
			godot_damage_multiplier += 1
		"attack_damage2":
			godot_damage_multiplier += 1
		"attack_damage3":
			godot_damage_multiplier += 1
		"attack_damage4":
			godot_damage_multiplier += 1
		"attack_damage5":
			godot_damage_multiplier += 1
		"attack_damage6":
			godot_damage_multiplier += 1
		"attack_damage7":
			godot_damage_multiplier += 1
		"attack_damage8":
			godot_damage_multiplier += 1
		"attack_speed1":
			attack_speed -= .2
		"attack_speed2":
			attack_speed -= .2
		"attack_speed3":
			attack_speed -= .2
		"attack_speed4":
			attack_speed -= .2
		"attack_speed5":
			attack_speed -= .2
		"attack_speed6":
			attack_speed -= .2
		"attack_speed7":
			attack_speed -= .2
		"attack_speed8":
			attack_speed -= .2
		"projectiles1":
			godot_base_instances += 1
		"projectiles2":
			godot_base_instances += 1
		"projectiles3":
			godot_base_instances += 1
		"projectiles4":
			godot_base_instances += 1
	
	# we handle the changes that needs logic like changing the attack speed
	bulletTimer.wait_time = attack_speed
	
	
	var option_children = levelUpOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_choices.clear()
	collected_upgrades.append(upgrade)
	levelUpPanel.visible = false
	get_tree().paused = false
	update_experience(0)
	
	# we refresh the lbl with the upgrades we have, so we reset everything to refresh the counts
	lblUpgrades.text = ""
	
	# we reset the upgrades
	reset_upgrades()
	
	collected_upgrades.sort()
	# we iterate on all the upgrade we have to generate a dict with the type as key, and the level as value
	for upg in collected_upgrades:
		# we add +1 to the corresponding type of upgrade each time we see an upgrade of that name
		var the_upgrade = Upgrades.UPGRADES[upg]["name"].to_lower()
		my_upgrades[the_upgrade] += 1
	
	for my_upgrade in my_upgrades.keys():
		if my_upgrades[my_upgrade] != 0:
			lblUpgrades.text += my_upgrade.capitalize()+" : Level "+str(my_upgrades[my_upgrade])+"\n" 


func reset_upgrades():
	for upgr in my_upgrades:
		my_upgrades[upgr] = 0


func get_random_upgrade():
	var upgradelist = []
	for i in Upgrades.UPGRADES:
		# if the player already has that upgrade
		if i in collected_upgrades:
			pass
		# if the upgrade has already be selected to be shown
		elif i in upgrade_choices:
			pass
		# checking for requirements
		elif Upgrades.UPGRADES[i]["requirements"].size() > 0:
			for n in Upgrades.UPGRADES[i]["requirements"]:
				if n not in collected_upgrades:
					pass
				else:
					upgradelist.append(i)
		else:
			upgradelist.append(i)
	if upgradelist.size() > 0:
		var randomitem = upgradelist.pick_random()
		upgrade_choices.append(randomitem)
		return randomitem
	else:
		return null
