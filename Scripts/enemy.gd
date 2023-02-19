extends CharacterBody2D

@export var speed = 350
const ACCELERATION = 400

@onready var player = get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
    velocity = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
            body.damage(delta)
            
        print("Collision with ", body.name)
