@tool
extends DinoGame

var game_scene = preload("res://src/woods/world/WorldGen.tscn")

func start(opts={}):
	Debug.pr("starting The Woods", opts)

	var game = game_scene.instantiate()
	# TODO apply options/gen level
	Navi.nav_to(game)
