extends Node2D

var enemy = preload("res://Scenes/enemy.tscn")

@onready var player_position = $Player.global_position
@onready var world = $Map
@onready var world_x = world.texture.get_width()
@onready var world_y = world.texture.get_height()

const safe_range = 700
const MAX_ENEMY_COUNT = 100
var current_enemy_count = 0

func _ready():
    randomize()


func _on_enemy_timer_timeout():
    # on each tick of this time, we spawn an enemy
    if current_enemy_count < MAX_ENEMY_COUNT:
        spawn_enemy()
        current_enemy_count += 1


# function that spawn an enemy
func spawn_enemy():
    # we instanciate a bullet
    var this_enemy = enemy.instantiate()
    # we place it at a random valid spawn location
    this_enemy.global_position = get_spawn_location()
    # we set it as a child of main, not the player
    get_parent().add_child(this_enemy)
    # we give it the player reference
    this_enemy.get_player($Player)
    print('Enemy instanciated')


func get_spawn_location():
    var posx = randi_range(0, world_x)
    var posy = randi_range(0, world_y)
    var spawn = Vector2(posx,posy)
    var distance_x = posx - player_position.x
    var distance_y = posy - player_position.y
    if abs(distance_x) < safe_range or abs(distance_y) < safe_range : # if we are too close
      spawn = get_spawn_location() # just get a new one instead
    return spawn
