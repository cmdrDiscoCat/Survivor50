extends Node

const ICON_PATH = "res://Assets/Upgrades/"
const UPGRADES = {
	"debug": {
		"icon": ICON_PATH + "debug.png",
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
		"description" : "Gain 5% speed",
		"level" : "Level 2",
		"requirements" : ["speed1"]
	},
	"speed3": {
		"icon": ICON_PATH + "speed.png",
		"name" : "Speed",
		"description" : "Gain 5% speed",
		"level" : "Level 3",
		"requirements" : ["speed2"]
	},
	"speed4": {
		"icon": ICON_PATH + "speed.png",
		"name" : "Speed",
		"description" : "Gain 5% speed",
		"level" : "Level 4",
		"requirements" : ["speed3"]
	},
	"speed5": {
		"icon": ICON_PATH + "speed.png",
		"name" : "Speed",
		"description" : "Gain 5% speed",
		"level" : "Level 5",
		"requirements" : ["speed4"]
	},
	"speed6": {
		"icon": ICON_PATH + "speed.png",
		"name" : "Speed",
		"description" : "Gain 5% speed",
		"level" : "Level 6",
		"requirements" : ["speed5"]
	},
	"speed7": {
		"icon": ICON_PATH + "speed.png",
		"name" : "Speed",
		"description" : "Gain 5% speed",
		"level" : "Level 7",
		"requirements" : ["speed6"]
	},
	"speed8": {
		"icon": ICON_PATH + "speed.png",
		"name" : "Speed",
		"description" : "Gain 5% speed",
		"level" : "Level 8",
		"requirements" : ["speed7"]
	},
	"attack_damage1": {
		"icon": ICON_PATH + "attack_damage.png",
		"name" : "Attack damage",
		"description" : "Additional damage",
		"level" : "Level 1",
		"requirements" : []
	},
	"attack_damage2": {
		"icon": ICON_PATH + "attack_damage.png",
		"name" : "Attack damage",
		"description" : "Additional damage",
		"level" : "Level 2",
		"requirements" : ["attack_damage1"]
	},
	"attack_damage3": {
		"icon": ICON_PATH + "attack_damage.png",
		"name" : "Attack damage",
		"description" : "Additional damage",
		"level" : "Level 3",
		"requirements" : ["attack_damage2"]
	},
	"attack_damage4": {
		"icon": ICON_PATH + "attack_damage.png",
		"name" : "Attack damage",
		"description" : "Additional damage",
		"level" : "Level 4",
		"requirements" : ["attack_damage3"]
	},
	"attack_damage5": {
		"icon": ICON_PATH + "attack_damage.png",
		"name" : "Attack damage",
		"description" : "Additional damage",
		"level" : "Level 5",
		"requirements" : ["attack_damage4"]
	},
	"attack_damage6": {
		"icon": ICON_PATH + "attack_damage.png",
		"name" : "Attack damage",
		"description" : "Additional damage",
		"level" : "Level 6",
		"requirements" : ["attack_damage5"]
	},
	"attack_damage7": {
		"icon": ICON_PATH + "attack_damage.png",
		"name" : "Attack damage",
		"description" : "Additional damage",
		"level" : "Level 7",
		"requirements" : ["attack_damage6"]
	},
	"attack_damage8": {
		"icon": ICON_PATH + "attack_damage.png",
		"name" : "Attack damage",
		"description" : "Additional damage",
		"level" : "Level 8",
		"requirements" : ["attack_damage7"]
	},
	"attack_speed1": {
		"icon": ICON_PATH + "attack_speed.png",
		"name" : "Attack speed",
		"description" : "Less time between attacks",
		"level" : "Level 1",
		"requirements" : []
	},
	"attack_speed2": {
		"icon": ICON_PATH + "attack_speed.png",
		"name" : "Attack speed",
		"description" : "Less time between attacks",
		"level" : "Level 2",
		"requirements" : ["attack_speed1"]
	},
	"attack_speed3": {
		"icon": ICON_PATH + "attack_speed.png",
		"name" : "Attack speed",
		"description" : "Less time between attacks",
		"level" : "Level 3",
		"requirements" : ["attack_speed2"]
	},
	"attack_speed4": {
		"icon": ICON_PATH + "attack_speed.png",
		"name" : "Attack speed",
		"description" : "Less time between attacks",
		"level" : "Level 4",
		"requirements" : ["attack_speed3"]
	},
	"attack_speed5": {
		"icon": ICON_PATH + "attack_speed.png",
		"name" : "Attack speed",
		"description" : "Less time between attacks",
		"level" : "Level 5",
		"requirements" : ["attack_speed4"]
	},
	"attack_speed6": {
		"icon": ICON_PATH + "attack_speed.png",
		"name" : "Attack speed",
		"description" : "Less time between attacks",
		"level" : "Level 6",
		"requirements" : ["attack_speed5"]
	},
	"attack_speed7": {
		"icon": ICON_PATH + "attack_speed.png",
		"name" : "Attack speed",
		"description" : "Less time between attacks",
		"level" : "Level 7",
		"requirements" : ["attack_speed6"]
	},
	"attack_speed8": {
		"icon": ICON_PATH + "attack_speed.png",
		"name" : "Attack speed",
		"description" : "Less time between attacks",
		"level" : "Level 8",
		"requirements" : ["attack_speed7"]
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
		"description" : "Augments the speed and size of the robots !",
		"level" : "Level 2",
		"requirements" : ["godot1"]
	},
	"godot3": {
		"icon": ICON_PATH + "godot.png",
		"name" : "Godot",
		"description" : "Augments the speed and size of the robots !",
		"level" : "Level 3",
		"requirements" : ["godot2"]
	},
	"godot4": {
		"icon": ICON_PATH + "godot.png",
		"name" : "Godot",
		"description" : "Augments the speed and size of the robots !",
		"level" : "Level 4",
		"requirements" : ["godot3"]
	},
	"godot5": {
		"icon": ICON_PATH + "godot.png",
		"name" : "Godot",
		"description" : "Augments the speed and size of the robots !",
		"level" : "Level 5",
		"requirements" : ["godot4"]
	},
	"godot6": {
		"icon": ICON_PATH + "godot.png",
		"name" : "Godot",
		"description" : "Augments the speed and size of the robots !",
		"level" : "Level 6",
		"requirements" : ["godot5"]
	},
	"godot7": {
		"icon": ICON_PATH + "godot.png",
		"name" : "Godot",
		"description" : "Augments the speed and size of the robots !",
		"level" : "Level 7",
		"requirements" : ["godot6"]
	},
	"godot8": {
		"icon": ICON_PATH + "godot.png",
		"name" : "Godot",
		"description" : "Augments the speed and size of the robots !",
		"level" : "Level 8",
		"requirements" : ["godot7"]
	},
	"projectiles1": {
		"icon": ICON_PATH + "projectiles.png",
		"name" : "Projectiles",
		"description" : "Augments the number of projectiles !",
		"level" : "Level 1",
		"requirements" : []
	},
	"projectiles2": {
		"icon": ICON_PATH + "projectiles.png",
		"name" : "Projectiles",
		"description" : "Augments the number of projectiles !",
		"level" : "Level 2",
		"requirements" : ["projectiles1"]
	},
	"projectiles3": {
		"icon": ICON_PATH + "projectiles.png",
		"name" : "Projectiles",
		"description" : "Augments the number of projectiles !",
		"level" : "Level 3",
		"requirements" : ["projectiles2"]
	},
	"projectiles4": {
		"icon": ICON_PATH + "projectiles.png",
		"name" : "Projectiles",
		"description" : "Augments the number of projectiles !",
		"level" : "Level 4",
		"requirements" : ["projectiles3"]
	},
	"projectiles5": {
		"icon": ICON_PATH + "projectiles.png",
		"name" : "Projectiles",
		"description" : "Augments the number of projectiles !",
		"level" : "Level 5",
		"requirements" : ["projectiles4"]
	},
	"projectiles6": {
		"icon": ICON_PATH + "projectiles.png",
		"name" : "Projectiles",
		"description" : "Augments the number of projectiles !",
		"level" : "Level 6",
		"requirements" : ["projectiles5"]
	},
	"projectiles7": {
		"icon": ICON_PATH + "projectiles.png",
		"name" : "Projectiles",
		"description" : "Augments the number of projectiles !",
		"level" : "Level 7",
		"requirements" : ["projectiles6"]
	},
	"projectiles8": {
		"icon": ICON_PATH + "projectiles.png",
		"name" : "Projectiles",
		"description" : "Augments the number of projectiles !",
		"level" : "Level 8",
		"requirements" : ["projectiles7"]
	},
}
