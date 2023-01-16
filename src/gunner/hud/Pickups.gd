tool
extends HBoxContainer

var pickups
var hat_scene = preload("res://src/gunner/hud/PickupHat.tscn")
var body_scene = preload("res://src/gunner/hud/PickupBody.tscn")

func _ready():
	if Engine.editor_hint:
		update_pickups(["hat", "body", "hat"])

func x_pos(i):
	return 11 + i * 25

func update_pickups(ps=pickups):
	pickups = ps
	if ps:
		for c in get_children():
			c.queue_free()

		for i in range(ps.size()):
			var p = ps[i]
			var inst
			match (p):
				"hat":
					inst = hat_scene.instance()
					inst.position.y = 19
				"body":
					inst = body_scene.instance()
					inst.position.y = -2
			inst.position.x = x_pos(i)

			add_child(inst)
