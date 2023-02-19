extends ProgressBar

@onready var player = get_parent()

func _ready():
    value = 100
