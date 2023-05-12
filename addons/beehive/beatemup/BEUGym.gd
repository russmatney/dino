@tool
extends DinoGym
class_name BEUGym

var beu_bodies = []

func _ready():
	super._ready()

	beu_bodies = []
	for c in get_children():
		if c is BEUBody:
			beu_bodies.append(c)
			c.died.connect(func(): c.machine.transit("Respawn"))
