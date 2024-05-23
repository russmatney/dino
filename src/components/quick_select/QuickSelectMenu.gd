@tool
extends Control
class_name QuickSelectMenu

## static #####################################################

static func ss_weapons_menu():
	var weaps = DinoWeaponsData.sidescroller_weapon_entities()
	var menu = QuickSelectMenu.new()
	menu.set_entities(weaps)
	return menu

static func player_entities_menu():
	var menu = QuickSelectMenu.new()
	menu.set_entities(DinoPlayerEntity.all_entities())
	return menu

static func all_entities_menu():
	var menu = QuickSelectMenu.new()
	menu.set_entities(DinoEntity.all_entities())
	return menu

static var scene = preload("res://src/components/quick_select/QuickSelect.tscn")
static var _menu

# TODO make this work? similar to the jumbotron?
static func quick_show(opts):
	if not _menu:
		_menu = scene.instantiate()
		Navi.add_child(_menu)

	var ents = opts.get("entities")
	_menu.set_entities(ents)

	_menu.show_menu(opts) # pass an on-selected

	return _menu.selected


## vars #####################################################

@onready var canvasLayer = $%CanvasLayer
@onready var entityList = $%EntityList
@onready var panel = $%Panel
@onready var screenBlur = $%ScreenBlur

var anim_duration = 0.4
var entities

signal selected(entity)

## ready #####################################################

func _ready():
	if not Engine.is_editor_hint():
		hide_menu()

	if Engine.is_editor_hint():
		set_entities(DinoEnemy.all_enemies())

func _unhandled_input(event):
	if Trolls.is_released(event, "weapon_swap_menu"):
		select_and_hide_menu()

	if Trolls.is_accept(event):
		select_and_hide_menu()

## set focus #####################################################

func set_focus():
	var chs = entityList.get_children()
	if len(chs) > 0:
		chs[0].grab_focus()

## set entities #####################################################

func set_entities(ents, on_select=null):
	entities = ents
	U.remove_children(entityList)

	for ent in ents:
		var butt = EntityButton.newButton(ent, on_select)
		entityList.add_child(butt)
		butt.selected.connect(select_and_hide_menu, CONNECT_DEFERRED)

func select_current():
	for ch in entityList.get_children():
		if U.has_focus(ch):
			ch.selected.emit()
			selected.emit(ch.entity)
			break

## show #####################################################

func show_menu(opts):
	# naive, but maybe this is fine?
	get_tree().paused = true
	canvasLayer.set_visible(true)
	screenBlur.fade_in({duration=anim_duration})

	set_entities(opts.get("entities", entities), opts.get("on_select"))
	set_focus()
	panel.set_visible(true)

	return selected

## hide #####################################################

func select_and_hide_menu():
	select_current()
	hide_menu()

func hide_menu():
	screenBlur.fade_out({duration=anim_duration})
	panel.set_visible(false)
	canvasLayer.set_visible(false)

	get_tree().paused = false
