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

	var warp_opts = actor.calculate_warp_spots()
	var filtered = warp_opts.filter(func(ws): return ws != last_ws)
	if len(filtered) == 0:
		filtered = warp_opts
	next_warp_spot = U.rand_of(filtered)

	if next_warp_spot == null:
		next_warp_spot = {global_position=Vector2(randf_range(-10, 10), randf_range(-10, 10))}

	warp_ttl = warp_in

## exit ####################################################

func exit():
	last_ws = next_warp_spot

## process ####################################################

func physics_process(delta):
	# could instead/also wait for warp_leave to finish
	warp_ttl -= delta
	if warp_ttl <= 0:
		# animate
		actor.global_position = next_warp_spot.global_position

		DJZ.play(DJZ.S.bosswarp)
		actor.anim.play("warp_arrive")

		machine.transit("Idle")
