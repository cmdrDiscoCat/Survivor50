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
# godot weapon (the default for now)
var godot_damage_multiplier = 10
var godot_speed = 2
var godot_scale = 1
var godot_instances = 1
var godot_level = 0
# regen
var health_recovery = 0.02

# attacks (only godot so far)
var bullet = preload("res://Scenes/bullet.tscn")

# health, level and xp bar
@onready var healthBar = $Health
@onready var expBar = $HUD/GUI/ProgressBar
@onready var lblLevel = $HUD/GUI/ProgressBar/LblLevel
# Bullet timer
@onready var bulletTimer = $BulletTimer

# level up ui
@onready var levelUpPanel = $HUD/GUI/LevelUpPanel
@onready var levelUpOptions = $HUD/GUI/LevelUpPanel/LevelUpOptions
@onready var itemOptions = preload("res://Scenes/upgrade_option.tscn")

# Upgrade
var collected_upgrades = []
var upgrade_choices = []


signal death



func _ready():
    # we set the Bullet time to the godot_speed value for now
    # later on, we'll have one Timer per weapon
    bulletTimer.wait_time = godot_speed
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
    
        # If we're not full health, we're taking damage
        if health < health_max and health != 0:
            health += health_recovery
            healthBar.value = health

func damage(delta, amount=1):
    # we're taking damage if we're not dead
    if health > 0:
        health -= delta * amount * 10
    # then we deal with the death and the loss of health
    if health < 1:
        alive = 0
        print("Dead")
        emit_signal("death")
    else:
        healthBar.value = health


func _on_bullet_timer_timeout():    
    spawn_bullet()


func spawn_bullet():
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
        # we set it as a child of main, not the player
        get_parent().add_child(this_bullet)
        # we place it where the player is
        this_bullet.global_position = global_position
        # then we tell it its damage and the direction its target was when it spawned
        this_bullet.set_damage_multiplier(godot_damage_multiplier)
        this_bullet.set_direction(target)



func _on_grab_area_area_entered(area):
    if area.is_in_group("loot"):
        # we got a gem !
        area.target = self
        


func _on_collect_area_area_entered(area):
    if area.is_in_group("loot"):
        var gem_experience = area.collect()
        update_experience(gem_experience)
        area.destroy()


func update_experience(xp):
    # we get how much xp is needed to level up with our current level
    var exp_for_lvlup = get_level_cap()
    collected_experience += xp
    # if we have enough xp to level up
    if experience + xp >= exp_for_lvlup:
        collected_experience -= exp_for_lvlup - xp
        player_level += 1
        experience = 0
        exp_for_lvlup = get_level_cap()
        level_up()
    else:
        experience += collected_experience
        collected_experience = 0
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
    expBar.value = value
    expBar.max_value = maximum


func level_up():
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
    var option_children = levelUpOptions.get_children()
    for i in option_children:
        i.queue_free()
    upgrade_choices.clear()
    collected_upgrades.append(upgrade)
    levelUpPanel.visible = false
    get_tree().paused = false
    update_experience(0)


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
