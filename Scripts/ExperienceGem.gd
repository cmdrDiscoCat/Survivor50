extends Area2D

@export var experience = 1

var blue = preload("res://Assets/gem_blue.png")
var yellow = preload("res://Assets/gem_yellow.png")
var red = preload("res://Assets/gem_red.png")
var purple = preload("res://Assets/gem_purple.png")

var target
var speed = -3

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready():
    if experience < 10:
        return
    elif experience < 25:
        sprite.texture = yellow
    elif experience < 40:
        sprite.texture = red
    else:
        sprite.texture = purple
        
func _physics_process(delta):
    if target != null:
        global_position = global_position.move_toward(target.global_position, speed)
        speed += delta*15

func collect():
    collision.call_deferred("set","disabled", true)
    sprite.visible = false
    return experience

func destroy():
    queue_free()
