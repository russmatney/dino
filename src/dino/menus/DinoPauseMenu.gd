extends CanvasLayer

## vars ##########################################

@onready var hero_label = $%HeroLabel
@onready var regen_menu = $%BrickRegenMenu
@onready var tabs: TabContainer = $%TabContainer

## ready ##########################################

func _ready():
	Log.pr("pause menu ready")
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
	Log.pr("Focusing tab bar")
	var tabbar = tabs.get_tab_bar()
	tabbar.grab_focus()

## update ##########################################

func refresh():
	if regen_menu:
		regen_menu.refresh()

func update_hero():
	var g = Game.get_current_game()
	if g != null:
		hero_label.text = "[center]%s[/center]" % g.get_display_name()
