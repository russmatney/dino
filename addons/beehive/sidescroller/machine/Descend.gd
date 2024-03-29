extends State

var max_reach = 500

## enter ###########################################################

func enter(_opts = {}):
	pass
	# Log.pr("DESCENDING")


## exit ###########################################################

func exit():
	last_collision_point = null
	last_coll = null
	actor.warp_cast.clear_exceptions()

## warp ###########################################################

var last_collision_point
var last_coll

func warp_position_in_dir(actor, direction, opts={}):
	actor.warp_cast.target_position = direction.normalized() * max_reach
	actor.warp_cast.force_raycast_update()

	var coll = actor.warp_cast.get_collider()
	var seen_tilemap = opts.get("seen_tilemap")

	if seen_tilemap:
		if coll != null and coll is TileMap and coll != last_coll:
			# Log.pr("found next tilemap coll, returning collision_point")
			return actor.warp_cast.get_collision_point()
		last_coll = coll

		if coll == null:
			# nowhere to travel down to!
			return

	if coll != null:
		# Log.pr("warp pos in dir hit:", coll)

		if coll is TileMap:
			# Log.pr("descend saw tilemap", coll)
			opts["seen_tilemap"] = true
		# else:
		# 	Log.pr("warp found something else! adding exception for it", coll)

		var coll_rid = actor.warp_cast.get_collider_rid()
		actor.warp_cast.add_exception_rid(coll_rid)
		return warp_position_in_dir(actor, direction, opts)

func warp(actor, position):
	actor.global_position = position + Vector2.DOWN * 50

## physics ###########################################################

func physics_process(_delta):
	var warp_position = warp_position_in_dir(actor, Vector2.DOWN)
	if warp_position != null:
		warp(actor, warp_position)
		transit("Idle")
		return

	actor.move_and_slide()
	transit("Idle")
