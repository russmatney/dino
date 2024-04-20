extends State

## properties #####################################################

func should_ignore_hit():
	return true

func can_bump():
	return false

## vars #####################################################

var last_ws
var next_warp_spot

var warp_in = 1
var warp_ttl = 1

## enter ####################################################

func enter(_ctx={}):
	actor.anim.play("warp_leave")

	var warp_options = actor.warp_spots.filter(func(ws): return ws != last_ws)
	next_warp_spot = U.rand_of(warp_options)

	if next_warp_spot == null:
		next_warp_spot = {global_position=Vector2(randf_range(-10, 10), randf_range(-10, 10))}

	warp_ttl = warp_in

func exit():
	last_ws = next_warp_spot

## process ####################################################

func physics_process(delta):
	warp_ttl -= delta
	if warp_ttl <= 0:
		# animate
		actor.global_position = next_warp_spot.global_position

		DJZ.play(DJZ.S.bosswarp)
		actor.anim.play("warp_arrive")

		machine.transit("Idle")
