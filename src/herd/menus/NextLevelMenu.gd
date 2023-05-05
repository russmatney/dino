extends CanvasLayer

@onready var sheep_saved = $%SheepSaved
@onready var hero_label = $%HeroLabel
@onready var buttons = $%LevelButtonList

var all_sheep = []

func _ready():
	Game.ensure_current_game()

	update_sheep_saved()

func update_sheep_saved():
	all_sheep = Hotel.query({group="sheep"})
	var survivors = all_sheep.filter(func(s): return not s.get("is_dead"))
	var saved_text = "[center]Sheep saved so far: [jump]%s[/jump][/center]" % (str(len(survivors), "/", len(all_sheep)))
	sheep_saved.set_text(saved_text)

func update_hero_text(text):
	hero_label.set_text("[center]%s" % text)

func update_buttons():
	buttons.rebuild()
