extends MarginContainer

@onready var gens = $%Generators

var generators = []

func _ready():
	refresh()

func refresh():
	if is_inside_tree():
		generators = get_tree().get_nodes_in_group("brick_generators")
		for ch in gens.get_children():
			ch.queue_free()

		for g in generators:
			setup_regen_menu(g)

func setup_regen_menu(g):
	var menu = NaviButtonList.new()
	menu.alignment = BoxContainer.ALIGNMENT_CENTER
	menu.add_menu_item(
		{label="Increase Room Count (%d)" % g.room_count,
			fn=func():
			g.room_count += 1
			g.generate()
			await g.nodes_transferred
			Game.respawn_player()
			refresh()
			})
	menu.add_menu_item(
		{label="Decrease Room Count (%d)" % g.room_count,
			fn=func():
			g.room_count -= 1
			g.room_count = max(1, g.room_count)
			g.generate()
			await g.nodes_transferred
			Game.respawn_player()
			refresh()
			})
	menu.add_menu_item(
		{label="Regenerate Level",
			fn=func():
			g.generate()
			await g.nodes_transferred
			Game.respawn_player()
			refresh()
			})
	menu.add_menu_item(
		{label="Randomize Seed and Regenerate(%d)" % g._seed,
			fn=func():
			g._seed = randi()
			g.generate()
			await g.nodes_transferred
			Game.respawn_player()
			refresh()
			})

	gens.add_child(menu)
