extends State

var max_reach = 500

## enter ###########################################################

func enter(_opts = {}):
	Debug.pr("ASCENDING")


## exit ###########################################################

func exit():
	last_collision_point = null
	actor.warp_cast.clear_exceptions()

## warp ###########################################################

var last_collision_point

func warp_position_in_dir(actor, direction, opts={}):
	actor.warp_cast.target_position = direction.normalized() * max_reach
	actor.warp_cast.force_raycast_update()

	var coll = actor.warp_cast.get_collider()
	var seen_tilemap = opts.get("seen_tilemap")

	if seen_tilemap:
		# in 'down', this logic needs to make sure there's another
		# tileset down there to land on
		if coll == null:
			Debug.pr("no more coll, return last_collision_point")
			return last_collision_point
		else:
			last_collision_point = actor.warp_cast.get_collision_point()

	if coll != null:
		Debug.pr("warp pos in dir hit:", coll)

		if coll is TileMap:
			Debug.pr("ascend saw tilemap", coll)
			opts["seen_tilemap"] = true

			var coll_rid = actor.warp_cast.get_collider_rid()
			actor.warp_cast.add_exception_rid(coll_rid)

			return warp_position_in_dir(actor, direction, opts)
		else:
			Debug.pr("warp found something else!")

		return coll.global_position

func warp(actor, position):
	# TODO disable collisions and tween to location
	actor.global_position = position + Vector2.UP * 50

## physics ###########################################################

func physics_process(_delta):
	# TODO maybe wait bit, do some animating along the way

	var warp_position = warp_position_in_dir(actor, Vector2.UP)
	if warp_position != null:
		warp(actor, warp_position)
		return

	actor.move_and_slide()
	transit("Idle")
