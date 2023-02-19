extends CharacterBody2D

const ACCELERATION = 500

var direction = null
var speed = 450

func _process(delta):
    # if we found an enemy to shoot to
    if direction != null:
        # we move the bullet in the direction the closest enemy was  
        velocity = velocity.move_toward(direction * speed, ACCELERATION * delta)
        # let's calculate the movement and get potential collisions
        var collision = move_and_collide(velocity * delta)
        # if we're colling with something, we'll display it
        if collision != null :
            var body = collision.get_collider()
            if body.is_in_group("enemies"):
                # we hit an enemy, so we use it's damage function
                body.damage(delta, 10)
                # then we delete the bullet
                queue_free()
    
    
# we delete the bullet if it exits the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
    queue_free()


func set_direction(target):
    direction = target
