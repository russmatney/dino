@tool
extends PanelContainer

## vars ######################################

@export var entity: DinoWeaponEntity
var is_active: bool = false

@onready var icon = $%WeaponIcon

## ready ######################################

func _ready():
	render()

## render ######################################

func render():
	if entity:
		icon.set_texture(entity.get_icon_texture())

		if is_active:
			#TODO some kind of animation/shader
			pass
		else:
			#TODO apply greyscale shader
			pass

## label ######################################

# func set_label(entity: DinoWeaponEntity):
# 	$%WeaponLabel.text = "[center]%s[/center]" % entity.get_display_name()
# 	$%WeaponLabel.visible = true
