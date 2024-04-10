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
@onready var panel = $%Panel

@onready var entityButton = preload("res://src/dino/ui/EntityButton.tscn")

## ready #####################################################

func _ready():
	if not Engine.is_editor_hint():
		hide_menu()

	if Engine.is_editor_hint():
		set_entities(DinoWeaponsData.sidescroller_weapon_entities())

func _unhandled_input(event):
	if Trolls.is_released(event, "weapon_swap_menu"):
		hide_menu()

## set focus #####################################################

func set_focus():
	var chs = entityList.get_children()
	if len(chs) > 0:
		chs[0].grab_focus()

## set entities #####################################################

func set_entities(ents, on_select=null):
	U.remove_children(entityList)

	for ent in ents:
		var butt = EntityButton.newButton(ent)
		entityList.add_child(butt)
		if on_select:
			butt.icon_pressed.connect(func():
				on_select.call(ent))

func select_current():
	for ch in entityList.get_children():
		if U.has_focus(ch):
			ch.icon_pressed.emit()

## show #####################################################

func show_menu(opts):
	Log.pr("show menu")

	get_tree().paused = true

	set_entities(opts.get("entities"), opts.get("on_select"))
	set_focus()
	panel.set_visible(true)

## hide #####################################################

func hide_menu():
	Log.pr("hide menu")
	select_current()
	panel.set_visible(false)

	get_tree().paused = false
