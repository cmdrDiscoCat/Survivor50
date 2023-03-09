extends Node

var enemy = preload("res://Scenes/enemy.tscn")

@onready var player = get_tree().get_first_node_in_group("player")
@onready var player_position = player.global_position
@onready var label_gameTimer = get_tree().get_root().get_node("Main/Player/HUD/GUI/LblGameTimer")

const safe_range = 900
var max_enemy_count = 200
var current_enemy_count

var game_timer = 0

var wave1_end = 120
var wave2_end = 240
var wave3_end = 360
var wave4_end = 480
var wave5_end = 600

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
        spawn_enemy(1,"c",1,10,350,400,1,false,false)
    elif game_timer == wave1_end:
        spawn_enemy(1,"c",5,40,250,400,3,true,true)
    elif game_timer > wave1_end and game_timer < wave2_end:
        max_enemy_count += 50
        spawn_enemy(1,"c",3,10,350,400,1,false,false)
        spawn_enemy(1,"cpp",5,30,350,400,2,false,false)
    elif game_timer == wave2_end:
        spawn_enemy(1,"cpp",15,120,250,400,6,true,true)
    elif game_timer > wave2_end and game_timer < wave3_end:
        max_enemy_count += 50
        spawn_enemy(1,"c",3,10,350,400,1,false,false)
        spawn_enemy(1,"cpp",5,30,350,400,2,false,false)
        spawn_enemy(1,"cs",15,50,350,400,3,false,false)
    elif game_timer == wave3_end:
        spawn_enemy(1,"cs",25,200,350,400,9,true,true)
    elif game_timer > wave3_end and game_timer < wave4_end:
        max_enemy_count += 50
        spawn_enemy(1,"c",3,10,350,400,1,false,false)
        spawn_enemy(1,"cpp",5,30,350,400,2,false,false)
        spawn_enemy(1,"cs",15,50,350,400,3,false,false)
        spawn_enemy(1,"css",25,70,350,400,4,false,false)
    elif game_timer == wave4_end:
        spawn_enemy(1,"css",40,280,350,400,12,true,true)
    elif game_timer > wave4_end and game_timer < wave5_end:
        max_enemy_count += 50
        spawn_enemy(1,"c",3,10,350,400,1,false,false)
        spawn_enemy(1,"cpp",5,30,350,400,2,false,false)
        spawn_enemy(1,"cs",15,50,350,400,3,false,false)
        spawn_enemy(1,"css",25,70,350,400,4,false,false)
        spawn_enemy(1,"js",40,100,350,400,5,false,false)
    elif game_timer == wave5_end:
        spawn_enemy(1,"js",60,400,350,400,15,true,true)
    else:
        max_enemy_count += 200 
        spawn_enemy(3,"c",1,10,350,400,1,false,false)
        spawn_enemy(2,"cpp",5,30,350,400,2,false,false)
        spawn_enemy(2,"cs",15,50,350,400,3,false,false)
        spawn_enemy(1,"css",25,70,350,400,4,false,false)
        spawn_enemy(1,"js",40,100,350,400,5,false,false)
    

# function that spawn an enemy
func spawn_enemy(number, type, xp, health, speed, acceleration, attack, boss, force_spawn):
    current_enemy_count = get_tree().get_nodes_in_group("enemies").size()
    for n in range(number):
        if current_enemy_count < max_enemy_count or force_spawn:             
            # we instanciate an enemy of this type
            var this_enemy = enemy.instantiate()
            # we place it at a random valid spawn location
            this_enemy.global_position = get_spawn_location()
            # we look at the wave and the timer to determine spawn
            this_enemy.initialize(type, boss, health, speed, acceleration, xp, attack)
            # we set it as a child of main, not the player
            get_parent().add_child(this_enemy)
            # we give it the player reference
            this_enemy.get_player(player)


func get_spawn_location():
    # we refresh the player position to get the current one
    player_position = player.global_position
    # we generate a spawn location at the safe_range, with a random rotation
    # so enemy will come from all sides !
    var spawn = player.position + Vector2(safe_range, 0).rotated(randf_range(0, 2*PI))
    return spawn
