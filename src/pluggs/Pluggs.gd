@tool
extends DinoGame

var first_scene = "res://src/pluggs/player/PluggsGym.tscn"

func start(_opts={}):
	Navi.nav_to(first_scene)
