extends CanvasLayer

# TODO create per-game-mode tab

## vars ##########################################

@onready var hero_label = $%HeroLabel
@onready var tabs: TabContainer = $%TabContainer

@onready var returnToMain = $%ReturnToMainMenu

## ready ##########################################

func _ready():
	returnToMain.pressed.connect(on_return_to_main)

	visibility_changed.connect(func():
		if visible:
			update_hero()
			set_focus())
	if visible:
		set_focus()

func on_return_to_main():
	# TODO maybe this work happens in game-mode exit_tree?
	# TODO clear MetSys stuff
	# TODO safely kill threads
	# TODO clear player entity
	Navi.nav_to_main_menu()

## focus ##########################################

func set_focus():
	var tabbar = tabs.get_tab_bar()
	tabbar.grab_focus()
	# var active_tab = tabs.get_current_tab_control()
	# if active_tab.has_method("render"):
	# 	active_tab.render()

## update ##########################################

func update_hero():
	var m = Dino.get_game_mode()
	if m != null:
		hero_label.text = "[center]%s[/center]" % m.get_display_name()
