@tool
extends VBoxContainer

## vars ######################################

@onready var active_icon = $%ActiveWeapon
@onready var inactive_icons = $%InactiveWeapons

@export var entities: Array[DinoWeaponEntity] = []
@export var active_entity: DinoWeaponEntity

var weapon_icon_scene = preload("res://src/dino/hud/HUDWeaponIcon.tscn")

## ready ######################################

func _ready():
	render()

## render ######################################

func render():
	U.remove_children(inactive_icons, {defer=true})

	active_icon.entity = active_entity
	active_icon.render()

	for w in entities.filter(func(w): return not w == active_entity):
		var icon = weapon_icon_scene.instantiate()
		icon.entity = w
		icon.is_active = false
		inactive_icons.add_child(icon)
