extends CharacterBody2D

@export var speed = 400
@export var health = 100
@onready var healthBar = $Health

func get_input():
    var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = input_direction * speed

func _physics_process(delta):
    # we manage the input
    get_input()
    # we handle the movement
    move_and_collide(velocity * delta)
    
    # If we're not full health, we're 
    if health < 100 and health != 0:
        health += delta
        healthBar.value = health

func damage(delta):
    # we're taking damage if we're not dead
    if health > 0:
        health -= delta*20
    # then we deal with the death and the loss of health
    if health == 0:
        print("Dead")
        emit_signal("dead")
    else:
        healthBar.value = health
        print("Taking damage ! Health is "+str(health))
