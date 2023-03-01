extends ColorRect

@onready var lblName = $LblName
@onready var lblDescription = $LblDescription
@onready var lblLevel = $LblLevel
@onready var icon = $ColorRect/Icon

var mouse_over = false
var item = null

@onready var player = get_tree().get_first_node_in_group("player")

signal selected_upgrade(upgrade)

func _ready():
    connect("selected_upgrade", Callable(player,"upgrade_player"))
    if item == null:
        item = "debug"
    lblName.text = Upgrades.UPGRADES[item]["name"]
    lblDescription.text  = Upgrades.UPGRADES[item]["description"]
    lblLevel.text  = Upgrades.UPGRADES[item]["level"]
    icon.texture = load(Upgrades.UPGRADES[item]["icon"])

func _input(event):
    if event.is_action("click"):
        if mouse_over:
            emit_signal("selected_upgrade", item)

func _on_mouse_entered():
    mouse_over = true


func _on_mouse_exited():
    mouse_over = false
