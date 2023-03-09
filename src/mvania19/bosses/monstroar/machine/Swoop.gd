extends State

var swoop_in = 0.3
var swoop_ttl

var swoop_spots = []

#####################################################
# enter

func enter(_ctx={}):
	actor.anim.play("jump")

	var positions = actor.warp_spots \
		.filter(func(ws): return not Util.are_nodes_close(ws, actor)) \
		.map(func(ws): return ws.global_position)
	swoop_spots = Util.rand_of(positions, 2)
	# insert player position
	swoop_spots.insert(1, MvaniaGame.player.global_position)

#####################################################
# physics

func physics_process(delta):
	if swoop_ttl == null:
		swoop_ttl = swoop_in

	if not swooping:
		swoop_ttl -= delta
		if swoop_ttl <= 0:
			swoop_ttl = swoop_in

			var pos = swoop_spots.pop_front()
			if pos == null:
				machine.transit("Warping")
				return

			swoop(pos)

#####################################################
# swoop

var swooping
func swoop(pos):
	swooping = true

	var tween = create_tween()
	tween.tween_property(actor, "position", pos, 0.4)
	tween.tween_callback(set.bind("swooping", false))
