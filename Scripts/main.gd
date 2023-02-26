extends Node2D

func start_game():
    $MainMenu.visible = false
    $Player.visible = true
    $Player.alive = 1
    $Player.health = 100
    $Player/Health.value = 100
    $Player/Camera2D/HUD.visible = true
    $Player/BulletTimer.start()
    $EnemyManager.start_timers()
    
    
func end_game():
    $Player.global_position = Vector2.ZERO
    $Player.visible = false
    $Player/Camera2D/HUD.visible = false
    $Player/BulletTimer.stop()
    $EnemyManager.stop_timers()
    # destroy all remaining enemies
    var enemies = get_tree().get_nodes_in_group("enemies")
    if len(enemies) > 0:
        for the_enemy in enemies:
            the_enemy.queue_free()
        
    $MainMenu.visible = true
    

