extends Node

var enemy = preload("res://Scenes/enemy.tscn")

@onready var player = get_tree().get_root().get_node("Main/Player")
@onready var player_position = player.global_position
@onready var label_gameTimer = get_tree().get_root().get_node("Main/Player/Camera2D/HUD/ProgressBar/LblGameTimer")
@onready var world = get_tree().get_root().get_node("Main/Map")
@onready var world_x = world.texture.get_width()
@onready var world_y = world.texture.get_height()

const safe_range = 700
const MAX_ENEMY_COUNT = 100
var current_enemy_count

var game_timer = 0

var wave1_end = 20
var wave2_end = 40
var wave3_end = 60
var wave4_end = 80
var wave5_end = 100

var wave = 1


func _ready():
    randomize()

    
func start_timers():
    game_timer = 0
    $EnemyTimer.start()
    $GameTimer.start()

    
func stop_timers():
    $EnemyTimer.stop()
    $GameTimer.stop()


func _on_enemy_timer_timeout():
    # on each tick of this time, we spawn an enemy    
    wave_manager()


func _on_game_timer_timeout():
    # each second we add to the game timer and we update the label
    game_timer += 1
    var minutes = game_timer/60
    var seconds = game_timer - minutes*60
    var timer_str = str(minutes,":","%02d"%seconds)
    label_gameTimer.set_text(timer_str)


# function call each tick of the enemy timer that will handle waves, bosses and such
func wave_manager():
    # we check the Game Timer, cause our logic for the spawn will depend on its value
    if game_timer < wave1_end:
        spawn_enemy(1, "c",10,350,400,1,false,false)
    elif game_timer == wave1_end:
        spawn_enemy(1, "c",40,250,400,3,true,true)
    elif game_timer > wave1_end and game_timer < wave2_end:
        spawn_enemy(1, "cpp",30,350,400,2,false,false)
    elif game_timer == wave2_end:
        spawn_enemy(1, "cpp",120,250,400,6,true,true)
    elif game_timer > wave2_end and game_timer < wave3_end:
        spawn_enemy(1, "cs",50,350,400,3,false,false)
    elif game_timer == wave3_end:
        spawn_enemy(1, "cs",200,350,400,9,false,true)
    elif game_timer > wave3_end and game_timer < wave4_end:
        spawn_enemy(1, "css",70,350,400,4,false,false)
    elif game_timer == wave4_end:
        spawn_enemy(1, "css",280,350,400,12,false,true)
    elif game_timer > wave4_end and game_timer < wave5_end:
        spawn_enemy(1, "js",100,350,400,5,false,false)
    elif game_timer == wave5_end:
        spawn_enemy(1, "js",400,350,400,15,false,true)
    else : 
        spawn_enemy(1, "c",10,350,400,1,false,false)
        spawn_enemy(1, "cpp",30,350,400,2,false,false)
        spawn_enemy(1, "cs",50,350,400,3,false,false)
        spawn_enemy(1, "css",70,350,400,4,false,false)
        spawn_enemy(1, "js",100,350,400,5,false,false)
    

# function that spawn an enemy
func spawn_enemy(number, type, health, speed, acceleration, attack, boss, force_spawn):
    current_enemy_count = get_tree().get_nodes_in_group("enemies").size()
    for n in range(number):
        if current_enemy_count < MAX_ENEMY_COUNT or force_spawn:             
            # we instanciate an enemy of this type
            var this_enemy = enemy.instantiate()
            # we place it at a random valid spawn location
            this_enemy.global_position = get_spawn_location()
            # we look at the wave and the timer to determine spawn
            this_enemy.initialize(type, boss, health, speed, acceleration, attack)
            # we set it as a child of main, not the player
            get_parent().add_child(this_enemy)
            # we give it the player reference
            this_enemy.get_player(player)


func get_spawn_location():
    var posx = randi_range(0 - world_x, world_x)
    var posy = randi_range(0 - world_y, world_y)
    var spawn = Vector2(posx,posy)
    var distance_x = posx - player_position.x
    var distance_y = posy - player_position.y
    if abs(distance_x) < safe_range or abs(distance_y) < safe_range : # if we are too close
        spawn = get_spawn_location() # just get a new one instead
    return spawn
