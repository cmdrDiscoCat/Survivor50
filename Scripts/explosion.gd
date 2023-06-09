extends Sprite2D

@onready var enemyDeath = $EnemyDeath

func _ready():
	$AnimationPlayer.play("explode")
	enemyDeath.play()
		

func _on_animation_player_animation_finished(_anim_name):
	queue_free()
