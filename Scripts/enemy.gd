extends CharacterBody2D

var enemy_c = preload("res://Assets/c_logo.png")
var enemy_cpp = preload("res://Assets/cpp_logo.png")
var enemy_cs = preload("res://Assets/cs_logo.png")
var enemy_css = preload("res://Assets/css_logo.png")
var enemy_js = preload("res://Assets/js_logo.png")

@export var experience = 1

@onready var loot_node = get_tree().get_first_node_in_group("loot")

var xp = preload("res://Scenes/experience_gem.tscn")

var speed
var ACCELERATION
var health
var attack

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
    velocity = Vector2.ZERO
    

# we set values of the instance of this enemy
func initialize(type, boss, h, s, a, expe, d):
    # initializing values
    speed = s
    ACCELERATION = a
    health = h
    attack = d
    experience = expe
    # initializing texture
    if type == "c":
        $Sprite2D.texture = enemy_c
    elif type == "css":
        $Sprite2D.texture = enemy_css
    elif type == "cpp":
        $Sprite2D.texture = enemy_cpp
    elif type == "cs":
        $Sprite2D.texture = enemy_cs
    elif type == "js":
        $Sprite2D.texture = enemy_js
    else:
        $Sprite2D.texture = enemy_c
    # initializing scale for bosses
    if boss:
        print("Boss spawned")
        $Sprite2D.scale = Vector2(2,2)
        $CollisionShape2D.scale = Vector2(4,4)
    else:
        $Sprite2D.scale = Vector2(0.5,0.5)
        $CollisionShape2D.scale = Vector2(1,1)
    


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if player:
        # let's get the vector between that enemy and the player
        var direction = (player.global_position - global_position).normalized()
        # let's make the enemy move towards the player
        velocity = velocity.move_toward(direction * speed, ACCELERATION * delta)
        
        var collision = move_and_collide(velocity * delta)
        # if we're colling with something, we'll display it
        if collision != null :
            var body = collision.get_collider()
            if body.name == "Player":
                #we hit the player, so we use it's damage function
                body.damage(delta,attack)


func damage(amount=10):
    # we're taking damage if we're not dead
    if health > 0:
        health -= amount
    # then we deal with the death and the loss of health
    if health <= 0:
        var new_xp = xp.instantiate()
        new_xp.global_position = global_position
        new_xp.experience = experience
        loot_node.call_deferred("add_child",new_xp)
        queue_free()

func get_player(target):
    player = target
