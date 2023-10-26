@tool
extends DinoGame

# var first_scene = "res://src/pluggs/player/PluggsGym.tscn"
var first_scene = "res://src/pluggs/room/LevelGen.tscn"

func start(_opts={}):
	Navi.nav_to(first_scene)
