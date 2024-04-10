@tool
extends Control
class_name QuickSelectMenu

## static #####################################################

# TODO per genre weapon fetching
static func ss_weapons_menu():
	var weaps = DinoWeaponsData.sidescroller_weapon_entities()
	var menu = QuickSelectMenu.new()
	menu.set_entities(weaps)
	return menu

## vars #####################################################

@onready var entityList = $%EntityList

@onready var entityButton = preload("res://src/dino/ui/EntityButton.tscn")

## ready #####################################################

func _ready():
	Log.pr("entity list ready")

	# if Engine.is_editor_hint():
	set_entities(DinoWeaponsData.sidescroller_weapon_entities())

	set_focus()

## set focus #####################################################

func set_focus():
	var chs = entityList.get_children()
	if len(chs) > 0:
		chs[0].grab_focus()

## set entities #####################################################

func set_entities(ents):
	U.remove_children(entityList)

	for ent in ents:
		var butt = EntityButton.newButton(ent)
		entityList.add_child(butt)
