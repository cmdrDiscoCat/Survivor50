extends Node2D

var enemy = preload("res://Scenes/enemy.tscn")

@onready var player_position = $Player.global_position
@onready var world = $Map
@onready var world_x = world.texture.get_width()
@onready var world_y = world.texture.get_height()

const safe_range = 700
const MAX_ENEMY_COUNT = 100
var current_enemy_count

func _ready():
    randomize()


func _on_enemy_timer_timeout():
    # on each tick of this time, we spawn an enemy
    current_enemy_count = get_tree().get_nodes_in_group("enemies").size();
    if current_enemy_count < MAX_ENEMY_COUNT:
        spawn_enemy()


func start_game():
    $MainMenu.visible = false
    $Player.visible = true
    $Player.health = 100
    $Player/Health.value = 100
    $Player/HUD.visible = true
    $Player/BulletTimer.start()
    $EnemyTimer.start()
    
    
func end_game():
    $Player.global_position = Vector2.ZERO
    $Player.visible = false
    $Player/HUD.visible = false
    $Player/BulletTimer.stop()
    $EnemyTimer.stop()
    # destroy all remaining enemies
    var enemies = get_tree().get_nodes_in_group("enemies")
    if len(enemies) > 0:
        for the_enemy in enemies:
            the_enemy.queue_free()
        
    $MainMenu.visible = true
    


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


func get_spawn_location():
    var posx = randi_range(0 - world_x, world_x)
    var posy = randi_range(0 - world_y, world_y)
    var spawn = Vector2(posx,posy)
    var distance_x = posx - player_position.x
    var distance_y = posy - player_position.y
    if abs(distance_x) < safe_range or abs(distance_y) < safe_range : # if we are too close
        spawn = get_spawn_location() # just get a new one instead
    return spawn
