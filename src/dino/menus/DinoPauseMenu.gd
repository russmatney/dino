extends CanvasLayer

@onready var hero_label = $%HeroLabel
@onready var regen_menu = $%BrickRegenMenu

func _ready():
	Log.pr("pause menu ready")
	refresh()

	visibility_changed.connect(func():
		if visible: refresh()
		update_hero()
		)

func refresh():
	regen_menu.refresh()

func update_hero():
	var g = Game.get_current_game()
	if g != null:
		hero_label.text = "[center]%s[/center]" % g.get_display_name()
