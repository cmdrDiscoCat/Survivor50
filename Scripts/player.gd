extends CharacterBody2D

@export var speed = 400
@export var health = 100
@onready var healthBar = $Health
@onready var expBar = $Camera2D/HUD/ProgressBar
@onready var lblLevel = $Camera2D/HUD/ProgressBar/LblLevel

var alive = 0

var experience = 0
var player_level = 1
var collected_experience = 0

signal death

var bullet = preload("res://Scenes/bullet.tscn")

func _ready():
    update_expBar(experience,get_level_cap())

func get_input():
    var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = input_direction * speed

func _physics_process(delta):
    if alive:
        # we manage the input
        get_input()
        # we handle the movement
        move_and_slide()
    
        # If we're not full health, we're taking damage
        if health < 100 and health != 0:
            health += delta
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
        # then we tell it the direction its target was when it spawned
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
        # update of the level
        lblLevel.text = str("Level : ", player_level)
        experience = 0
        exp_for_lvlup = get_level_cap()
        update_experience(0)
    else:
        experience += collected_experience
        collected_experience = 0
    
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
