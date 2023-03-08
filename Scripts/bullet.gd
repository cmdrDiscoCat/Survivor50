extends CharacterBody2D

const ACCELERATION = 2000

@onready var sprite = $Sprite2D
@onready var collisionshape = $CollisionShape2D

var direction = null
var speed = 450
var speed_multiplier = 1
var damage = 10
var damage_multiplier = 1
var current_scale = 1

func _process(delta):
    # if we found an enemy to shoot to
    if direction != null:
        # we move the bullet in the direction the closest enemy was  
        velocity = velocity.move_toward(direction * speed * speed_multiplier, ACCELERATION * delta)
        # let's calculate the movement and get potential collisions
        var collision = move_and_collide(velocity * delta)
        # if we're colling with something, we'll display it
        if collision != null :
            var body = collision.get_collider()
            if body.is_in_group("enemies"):
                # we hit an enemy, so we use it's damage function
                body.damage(damage * damage_multiplier)
                # then we delete the bullet
                queue_free()
    
    
# we delete the bullet if it exits the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
    queue_free()

func set_damage_multiplier(value):
    damage_multiplier = value

func set_speed_multiplier(value):
    speed_multiplier = value
    
func change_scale(value):
    sprite.scale = Vector2(value,value)
    collisionshape.scale = Vector2(value*2,value*2)

func update_scale_multiplier(value):
    current_scale = value
    change_scale(current_scale)

func set_direction(target):
    direction = target
