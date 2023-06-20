extends Node2D

@onready var music_menu = $Music/Menu
@onready var music_game = $Music/Game
@onready var player_death = $Music/PlayerDeath

func _ready():
	music_menu.play()
	

func start_game():
	music_menu.stop()
	music_game.play()
	$MainMenu.visible = false
	$Player.visible = true
	$Player.alive = 1
	$Player.health = 100
	$Player.experience = 0
	$Player.update_experience(0)
	$Player.player_level = 1
	$Player.collected_experience = 0
	$Player/Health.value = 100
	$Player/HUD.visible = true
	$Player/BulletTimer.start()
	$EnemyManager.start_timers()

func death_jingle():
	music_game.stop()
	player_death.play()
	end_game()
	
	
func _on_player_death_finished():
	player_death.stop()
	music_menu.play()
	
	
func end_game():
	$Player.global_position = Vector2.ZERO
	$Player.visible = false
	$Player/HUD.visible = false
	$Player/BulletTimer.stop()
	$EnemyManager.stop_timers()
	# we reset all the xp/level 
	$Player.health = 100
	$Player.experience = 0
	$Player.player_level = 1
	$Player.collected_experience = 0
	$Player/Health.value = 100
	
	# destroy all remaining enemies
	var enemies = get_tree().get_nodes_in_group("enemies")
	if len(enemies) > 0:
		for the_enemy in enemies:
			the_enemy.queue_free()
	# destroy all remaining loot
	var drops = get_tree().get_nodes_in_group("drop")
	if len(drops) > 0:
		for a_drop in drops:
			a_drop.queue_free()
	
	# we display the main menu again
	$MainMenu.visible = true
	

