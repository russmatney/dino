@tool
extends DinoGame

var first_scene = preload("res://src/pluggs/factory/FactoryFloor.tscn")

func start(_opts={}):
	Navi.nav_to(first_scene)
