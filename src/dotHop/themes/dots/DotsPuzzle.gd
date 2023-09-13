@tool
extends DotHopPuzzle

var obj_scene_override = {
	"Player": preload("res://src/dotHop/themes/dots/Player.tscn"),
	"Dot": preload("res://src/dotHop/themes/dots/Dot.tscn"),
	"Dotted": preload("res://src/dotHop/themes/dots/Dot.tscn"),
	"Goal": preload("res://src/dotHop/themes/dots/Dot.tscn"),
	}

func _init():
	obj_scene = obj_scene_override

var exit_t = 0.8
func animate_exit():
	state.players.map(func(p): p.node.animate_exit(exit_t))

	all_cell_nodes().map(func(node):
		node.animate_exit(exit_t))

	# return blocking signal until animations finish
	return get_tree().create_timer(exit_t).timeout
