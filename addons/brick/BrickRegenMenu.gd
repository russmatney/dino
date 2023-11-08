extends MarginContainer

@onready var gens = $%Generators

var generators = []

func _ready():
	refresh()

func refresh():
	Debug.pr("brick regen refresh")
	if is_inside_tree():
		generators = get_tree().get_nodes_in_group("brick_generators")
		for ch in gens.get_children():
			ch.queue_free()

		for g in generators:
			setup_regen_menu(g)

func setup_regen_menu(g):
	Debug.pr("building regen menu for g", g, g._seed, g.room_count)

	var menu = NaviButtonList.new()
	menu.alignment = BoxContainer.ALIGNMENT_CENTER
	menu.add_menu_item(
		{label="Randomize Seed (%d)" % g._seed,
			fn=func():
			g._seed = randi()
			refresh()
			})
	menu.add_menu_item(
		{label="Randomize Room Count (%d)" % g.room_count,
			fn=func():
			g.room_count = Util.rand_of([1, 2, 3, 4])
			refresh()
			})
	menu.add_menu_item(
		{label="Regenerate Level",
			fn=func():
			g.generate()
			refresh()
			})

	gens.add_child(menu)
