extends Node

const ICON_PATH = "res://Assets/Upgrades/"
const UPGRADES = {
    "debug": {
        "icon": ICON_PATH + "speed.png",
        "name" : "Debug",
        "description" : "The power of the default",
        "level" : "N/A",
        "requirements" : []
    },
    "speed1": {
        "icon": ICON_PATH + "speed.png",
        "name" : "Speed",
        "description" : "Gain 5% speed",
        "level" : "Level 1",
        "requirements" : []
    },
    "speed2": {
        "icon": ICON_PATH + "speed.png",
        "name" : "Speed",
        "description" : "Gain 10% speed",
        "level" : "Level 2",
        "requirements" : ["speed1"]
    },
    "speed3": {
        "icon": ICON_PATH + "speed.png",
        "name" : "Speed",
        "description" : "Gain 15% speed",
        "level" : "Level 3",
        "requirements" : ["speed2"]
    },
    "speed4": {
        "icon": ICON_PATH + "speed.png",
        "name" : "Speed",
        "description" : "Gain 20% speed",
        "level" : "Level 4",
        "requirements" : ["speed3"]
    },
    "godot1": {
        "icon": ICON_PATH + "godot.png",
        "name" : "Godot",
        "description" : "Send a Godot robot to kill your enemies",
        "level" : "Level 1",
        "requirements" : []
    },
    "godot2": {
        "icon": ICON_PATH + "godot.png",
        "name" : "Godot",
        "description" : "Send one more Godot robot",
        "level" : "Level 2",
        "requirements" : ["godot1"]
    }
}
