extends MarginContainer

var generators = []

func _ready():
	setup()

func setup():
	if is_inside_tree():
		generators = get_tree().get_nodes_in_group("brick_generators")

		for g in generators:
			setup_regen_menu(g)

func setup_regen_menu(g):
	Debug.pr("building regen menu for g", g, g._seed, g.room_count)
