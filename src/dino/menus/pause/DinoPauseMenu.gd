extends CanvasLayer

# TODO create per-game-mode tab

## vars ##########################################

@onready var hero_label = $%HeroLabel
@onready var regen_menu = $%BrickRegenMenu
@onready var tabs: TabContainer = $%TabContainer

## ready ##########################################

func _ready():
	refresh()

	visibility_changed.connect(func():
		if visible:
			refresh()
			update_hero()
			set_focus())
	if visible:
		set_focus()

## focus ##########################################

func set_focus():
	var tabbar = tabs.get_tab_bar()
	tabbar.grab_focus()
	# var active_tab = tabs.get_current_tab_control()
	# if active_tab.has_method("render"):
	# 	active_tab.render()

## update ##########################################

func refresh():
	if regen_menu:
		regen_menu.refresh()

func update_hero():
	var m = Dino.get_game_mode()
	if m != null:
		hero_label.text = "[center]%s[/center]" % m.get_display_name()
