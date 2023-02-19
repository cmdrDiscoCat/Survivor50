extends CharacterBody2D

@export var speed = 400
@export var health = 100
@onready var healthBar = $Health

var bullet = preload("res://Scenes/bullet.tscn")
var closest = INF
var guided_once = true
var closest_enemy = null

func get_input():
    var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = input_direction * speed

func _physics_process(delta):
    # we manage the input
    get_input()
    # we handle the movement
    move_and_slide()
    
    # If we're not full health, we're 
    if health < 100 and health != 0:
        health += delta
        healthBar.value = health

func damage(delta, amount=1):
    # we're taking damage if we're not dead
    if health > 0:
        health -= delta * amount * 20
    # then we deal with the death and the loss of health
    if health == 0:
        print("Dead")
        emit_signal("dead")
    else:
        healthBar.value = health


func _on_bullet_timer_timeout():    
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
        var target = (closest_enemy.global_position - global_position).normalized()
        var this_bullet = bullet.instantiate()
        get_parent().add_child(this_bullet)
        this_bullet.global_position = global_position
        this_bullet.set_direction(target)
    
    

