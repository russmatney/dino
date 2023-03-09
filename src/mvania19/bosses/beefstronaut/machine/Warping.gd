extends State

var last_ws
var next_warp_spot

var warp_in = 1
var warp_ttl = 1

#####################################################
# enter

func enter(_ctx={}):
	# TODO warping animation
	actor.anim.play("jump")

	var warp_options = actor.warp_spots.filter(func(ws): return ws != last_ws)
	next_warp_spot = Util.rand_of(warp_options)

	warp_ttl = warp_in

func exit():
	last_ws = next_warp_spot

#####################################################
# physics

func physics_process(delta):
	warp_ttl -= delta
	if warp_ttl <= 0:
		# animate
		actor.global_position = next_warp_spot.global_position
		machine.transit("Idle")
